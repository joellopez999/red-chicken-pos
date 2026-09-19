"""
Endpoints for the AI phone-order assistant. See ai_phone_order_service.py for the
conversation/menu-resolution logic — this module is just the HTTP surface:
create a draft, advance it turn by turn, list what's pending, and accept/reject.

Nothing here ever creates a real Order except POST /accept, which a staff member must
call explicitly from the "pendientes de aceptación" queue.
"""

from datetime import datetime, timezone
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select

from . import models
from .ai_phone_order_service import process_turn
from .db import get_session
from .permissions import Permission, require_permission

router = APIRouter()


def _draft_public_dict(draft: models.AiPhoneOrder) -> dict:
    return {
        "id": draft.id,
        "phone_label": draft.phone_label,
        "status": draft.status.value,
        "items": draft.items or [],
        "customer_note": draft.customer_note,
        "transcript": draft.transcript or [],
        "created_at": draft.created_at.isoformat() if draft.created_at else None,
        "updated_at": draft.updated_at.isoformat() if draft.updated_at else None,
        "resulting_order_id": draft.resulting_order_id,
        "total_cents": sum((it.get("price_cents", 0) * it.get("quantity", 0)) for it in (draft.items or [])),
    }


def _get_draft_or_404(session: Session, tenant_id: int, draft_id: int) -> models.AiPhoneOrder:
    draft = session.exec(
        select(models.AiPhoneOrder).where(
            models.AiPhoneOrder.id == draft_id,
            models.AiPhoneOrder.tenant_id == tenant_id,
        )
    ).first()
    if not draft:
        raise HTTPException(status_code=404, detail="Draft not found")
    return draft


@router.post("/ai-phone-orders")
def create_ai_phone_order(
    body: models.AiPhoneOrderCreate,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """Start a new draft — called when a phone goes off-hook (or, for now, manually to test)."""
    draft = models.AiPhoneOrder(
        tenant_id=current_user.tenant_id,
        phone_label=(body.phone_label or "Teléfono 1").strip()[:50] or "Teléfono 1",
    )
    session.add(draft)
    session.commit()
    session.refresh(draft)
    return _draft_public_dict(draft)


@router.post("/ai-phone-orders/{draft_id}/turn")
def advance_ai_phone_order_turn(
    draft_id: int,
    body: models.AiPhoneOrderTurn,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """Feed one customer utterance (typed today; transcribed speech later) into the
    conversation. Returns what the assistant says back and the current draft state."""
    draft = _get_draft_or_404(session, current_user.tenant_id, draft_id)
    if draft.status != models.AiPhoneOrderStatus.in_progress:
        raise HTTPException(status_code=400, detail=f"Draft is already {draft.status.value}")
    message = (body.message or "").strip()
    if not message:
        raise HTTPException(status_code=400, detail="message is required")
    try:
        result = process_turn(session, draft, message)
    except RuntimeError as e:
        code = str(e)
        if code == "phone_order_ai_not_configured":
            raise HTTPException(status_code=400, detail="Falta configurar la clave de OpenAI (PHONE_ORDER_AI_API_KEY)")
        raise HTTPException(status_code=502, detail="No se pudo contactar al servicio de IA") from e
    return result


@router.get("/ai-phone-orders")
def list_ai_phone_orders(
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_READ))],
    session: Session = Depends(get_session),
    status: str | None = None,
) -> list[dict]:
    query = select(models.AiPhoneOrder).where(models.AiPhoneOrder.tenant_id == current_user.tenant_id)
    if status:
        try:
            query = query.where(models.AiPhoneOrder.status == models.AiPhoneOrderStatus(status))
        except ValueError:
            raise HTTPException(status_code=400, detail=f"Unknown status: {status}")
    query = query.order_by(models.AiPhoneOrder.created_at.desc())
    drafts = session.exec(query).all()
    return [_draft_public_dict(d) for d in drafts]


@router.get("/ai-phone-orders/{draft_id}")
def get_ai_phone_order(
    draft_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_READ))],
    session: Session = Depends(get_session),
) -> dict:
    draft = _get_draft_or_404(session, current_user.tenant_id, draft_id)
    return _draft_public_dict(draft)


@router.post("/ai-phone-orders/{draft_id}/accept")
def accept_ai_phone_order(
    draft_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """The only path from an AI draft to a real Order — always an explicit staff action."""
    draft = _get_draft_or_404(session, current_user.tenant_id, draft_id)
    if draft.status not in (models.AiPhoneOrderStatus.pending_review, models.AiPhoneOrderStatus.in_progress):
        raise HTTPException(status_code=400, detail=f"Draft is already {draft.status.value}")
    items = draft.items or []
    if not items:
        raise HTTPException(status_code=400, detail="El borrador no tiene ítems")

    order = models.Order(
        tenant_id=current_user.tenant_id,
        table_id=None,
        order_channel=models.OrderChannel.ai_phone,
        status=models.OrderStatus.pending,
        customer_name=draft.phone_label,
        notes=draft.customer_note,
    )
    session.add(order)
    session.flush()

    for it in items:
        session.add(models.OrderItem(
            order_id=order.id,
            product_id=it["product_id"],
            product_name=it["product_name"],
            quantity=it["quantity"],
            price_cents=it["price_cents"],
            notes=it.get("notes") or None,
            status=models.OrderItemStatus.pending,
        ))

    draft.status = models.AiPhoneOrderStatus.accepted
    draft.accepted_by_user_id = current_user.id
    draft.accepted_at = datetime.now(timezone.utc)
    draft.resulting_order_id = order.id
    session.add(draft)
    session.commit()
    session.refresh(order)

    return {"order_id": order.id, "draft": _draft_public_dict(draft)}


@router.post("/ai-phone-orders/{draft_id}/reject")
def reject_ai_phone_order(
    draft_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    draft = _get_draft_or_404(session, current_user.tenant_id, draft_id)
    if draft.status in (models.AiPhoneOrderStatus.accepted, models.AiPhoneOrderStatus.rejected):
        raise HTTPException(status_code=400, detail=f"Draft is already {draft.status.value}")
    draft.status = models.AiPhoneOrderStatus.rejected
    session.add(draft)
    session.commit()
    return _draft_public_dict(draft)
