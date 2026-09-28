"""
Manual expense log — "Registrar gasto" button in the Reports module. Independent of
orders/products; purely lets the owner/admin track outgoing cash alongside the sales
revenue Reports already shows. See models.Expense / models.EXPENSE_CATEGORIES.
"""

from __future__ import annotations

from datetime import date
from io import BytesIO
from pathlib import Path
from typing import Annotated
from uuid import uuid4

from fastapi import APIRouter, Depends, File, HTTPException, Query, UploadFile
from fastapi.responses import FileResponse
from PIL import Image
from sqlmodel import Session, select

from . import models
from .db import get_session
from .permissions import Permission, require_permission

router = APIRouter()

UPLOADS_DIR = Path(__file__).resolve().parent.parent / "uploads"
MAX_ATTACHMENT_SIZE = 8 * 1024 * 1024  # 8MB — phone photos of receipts can be sizeable
ALLOWED_ATTACHMENT_TYPES = {"image/jpeg", "image/png", "image/webp", "application/pdf"}
_EXT_BY_CONTENT_TYPE = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
    "application/pdf": ".pdf",
}


def _resolve_attachment_content_type(file: UploadFile, contents: bytes) -> str | None:
    """Resolve the real content-type of an expense receipt upload (photo or PDF),
    never trusting the client's declared Content-Type alone."""
    if contents.startswith(b"%PDF"):
        return "application/pdf"
    try:
        image = Image.open(BytesIO(contents))
        fmt = (image.format or "").upper()
        return {"JPEG": "image/jpeg", "PNG": "image/png", "WEBP": "image/webp"}.get(fmt)
    except Exception:
        return None


def _expense_attachment_path(tenant_id: int, filename: str) -> Path:
    safe_name = Path(filename).name
    uploads_root = UPLOADS_DIR.resolve()
    path = (UPLOADS_DIR / str(tenant_id) / "expenses" / safe_name).resolve()
    if not path.is_relative_to(uploads_root):
        raise HTTPException(status_code=400, detail="Invalid file path")
    return path


def _delete_expense_attachment_on_disk(expense: models.Expense) -> None:
    if not expense.attachment_filename:
        return
    try:
        path = _expense_attachment_path(expense.tenant_id, expense.attachment_filename)
        if path.is_file():
            path.unlink()
    except (OSError, ValueError, HTTPException):
        pass


def _expense_public_dict(expense: models.Expense) -> dict:
    return {
        "id": expense.id,
        "category": expense.category,
        "amount_cents": expense.amount_cents,
        "description": expense.description,
        "expense_date": expense.expense_date.isoformat(),
        "created_by_user_id": expense.created_by_user_id,
        "created_at": expense.created_at.isoformat() if expense.created_at else None,
        "has_attachment": bool(expense.attachment_filename),
    }


def _get_owned_expense(session: Session, expense_id: int, tenant_id: int) -> models.Expense:
    expense = session.exec(
        select(models.Expense).where(
            models.Expense.id == expense_id,
            models.Expense.tenant_id == tenant_id,
        )
    ).first()
    if not expense:
        raise HTTPException(status_code=404, detail="Expense not found")
    return expense


@router.get("/expenses/categories")
def list_expense_categories(
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_READ))],
) -> list[str]:
    return models.EXPENSE_CATEGORIES


@router.post("/expenses")
def create_expense(
    body: models.ExpenseCreate,
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_WRITE))],
    session: Session = Depends(get_session),
) -> dict:
    category = (body.category or "").strip()
    if not category:
        raise HTTPException(status_code=400, detail="category is required")
    if body.amount_cents <= 0:
        raise HTTPException(status_code=400, detail="amount_cents must be greater than zero")

    expense = models.Expense(
        tenant_id=current_user.tenant_id,
        category=category[:50],
        amount_cents=body.amount_cents,
        description=(body.description or "").strip()[:500] or None,
        expense_date=body.expense_date,
        created_by_user_id=current_user.id,
    )
    session.add(expense)
    session.commit()
    session.refresh(expense)
    return _expense_public_dict(expense)


@router.get("/expenses")
def list_expenses(
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_READ))],
    session: Session = Depends(get_session),
    from_date: date | None = Query(None),
    to_date: date | None = Query(None),
) -> list[dict]:
    query = select(models.Expense).where(models.Expense.tenant_id == current_user.tenant_id)
    if from_date:
        query = query.where(models.Expense.expense_date >= from_date)
    if to_date:
        query = query.where(models.Expense.expense_date <= to_date)
    query = query.order_by(models.Expense.expense_date.desc(), models.Expense.id.desc())
    expenses = session.exec(query).all()
    return [_expense_public_dict(e) for e in expenses]


@router.delete("/expenses/{expense_id}")
def delete_expense(
    expense_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_WRITE))],
    session: Session = Depends(get_session),
) -> dict:
    expense = _get_owned_expense(session, expense_id, current_user.tenant_id)
    _delete_expense_attachment_on_disk(expense)
    session.delete(expense)
    session.commit()
    return {"status": "deleted", "id": expense_id}


@router.post("/expenses/{expense_id}/attachment")
async def upload_expense_attachment(
    expense_id: int,
    file: Annotated[UploadFile, File()],
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_WRITE))],
    session: Session = Depends(get_session),
) -> dict:
    """Attach a photo of the receipt/invoice, or a scanned PDF, to a manual expense."""
    expense = _get_owned_expense(session, expense_id, current_user.tenant_id)

    contents = await file.read()
    if len(contents) > MAX_ATTACHMENT_SIZE:
        raise HTTPException(
            status_code=400,
            detail=f"File too large. Max size: {MAX_ATTACHMENT_SIZE // (1024 * 1024)}MB",
        )
    content_type = _resolve_attachment_content_type(file, contents)
    if content_type not in ALLOWED_ATTACHMENT_TYPES:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid file type. Allowed: {', '.join(sorted(ALLOWED_ATTACHMENT_TYPES))}",
        )

    _delete_expense_attachment_on_disk(expense)

    tenant_dir = UPLOADS_DIR / str(current_user.tenant_id) / "expenses"
    tenant_dir.mkdir(parents=True, exist_ok=True)
    new_filename = f"{uuid4().hex}{_EXT_BY_CONTENT_TYPE[content_type]}"
    (tenant_dir / new_filename).write_bytes(contents)

    expense.attachment_filename = new_filename
    expense.attachment_content_type = content_type
    session.add(expense)
    session.commit()
    session.refresh(expense)
    return _expense_public_dict(expense)


@router.get("/expenses/{expense_id}/attachment")
def download_expense_attachment(
    expense_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_READ))],
    session: Session = Depends(get_session),
):
    expense = _get_owned_expense(session, expense_id, current_user.tenant_id)
    if not expense.attachment_filename:
        raise HTTPException(status_code=404, detail="No attachment uploaded")
    path = _expense_attachment_path(expense.tenant_id, expense.attachment_filename)
    if not path.is_file():
        raise HTTPException(status_code=404, detail="File missing on server")
    return FileResponse(path, media_type=expense.attachment_content_type or "application/octet-stream")


@router.delete("/expenses/{expense_id}/attachment")
def delete_expense_attachment(
    expense_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.EXPENSE_WRITE))],
    session: Session = Depends(get_session),
) -> dict:
    expense = _get_owned_expense(session, expense_id, current_user.tenant_id)
    _delete_expense_attachment_on_disk(expense)
    expense.attachment_filename = None
    expense.attachment_content_type = None
    session.add(expense)
    session.commit()
    return _expense_public_dict(expense)
