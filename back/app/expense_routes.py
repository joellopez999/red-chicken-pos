"""
Manual expense log — "Registrar gasto" button in the Reports module. Independent of
orders/products; purely lets the owner/admin track outgoing cash alongside the sales
revenue Reports already shows. See models.Expense / models.EXPENSE_CATEGORIES.
"""

from __future__ import annotations

from datetime import date
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlmodel import Session, select

from . import models
from .db import get_session
from .permissions import Permission, require_permission

router = APIRouter()


def _expense_public_dict(expense: models.Expense) -> dict:
    return {
        "id": expense.id,
        "category": expense.category,
        "amount_cents": expense.amount_cents,
        "description": expense.description,
        "expense_date": expense.expense_date.isoformat(),
        "created_by_user_id": expense.created_by_user_id,
        "created_at": expense.created_at.isoformat() if expense.created_at else None,
    }


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
    expense = session.exec(
        select(models.Expense).where(
            models.Expense.id == expense_id,
            models.Expense.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not expense:
        raise HTTPException(status_code=404, detail="Expense not found")
    session.delete(expense)
    session.commit()
    return {"status": "deleted", "id": expense_id}
