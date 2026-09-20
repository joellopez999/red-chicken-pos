"""
Endpoints for the AI phone "explain the menu" assistant (function #2 — see
ai_phone_menu_service.py). Two audiences:
- Staff-only (permission-gated, same pattern as the rest of the app): register/list/retire
  a physical phone's device token. The raw token is only ever returned once, at creation.
- Public (no login — a customer picked up a handset): start a bounded session and advance
  it turn by turn, authenticated by that device token instead of a staff login.
"""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Annotated

import redis
from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session, select

from . import models
from .ai_phone_menu_service import (
    GREETING_TEXT,
    find_device_by_token,
    generate_device_token,
    hash_device_token,
    process_menu_turn,
)
from .db import get_session
from .permissions import Permission, require_permission
from .rate_limits import rate_limit_redis_url
from .settings import settings

router = APIRouter()


def _device_public_dict(device: models.AiPhoneMenuDevice) -> dict:
    return {
        "id": device.id,
        "label": device.label,
        "is_active": device.is_active,
        "created_at": device.created_at.isoformat() if device.created_at else None,
        "last_used_at": device.last_used_at.isoformat() if device.last_used_at else None,
    }


# --- Staff: device management ---

@router.post("/ai-phone-menu/devices")
def create_ai_phone_menu_device(
    body: models.AiPhoneMenuDeviceCreate,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """Registers a physical phone. The raw token is returned ONLY in this response —
    copy it into the phone's device/Arduino config now, it can't be retrieved again."""
    raw_token = generate_device_token()
    device = models.AiPhoneMenuDevice(
        tenant_id=current_user.tenant_id,
        label=(body.label or "Teléfono 1").strip()[:50] or "Teléfono 1",
        token_hash=hash_device_token(raw_token),
    )
    session.add(device)
    session.commit()
    session.refresh(device)
    return {**_device_public_dict(device), "token": raw_token}


@router.get("/ai-phone-menu/devices")
def list_ai_phone_menu_devices(
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_READ))],
    session: Session = Depends(get_session),
) -> list[dict]:
    devices = session.exec(
        select(models.AiPhoneMenuDevice)
        .where(models.AiPhoneMenuDevice.tenant_id == current_user.tenant_id)
        .order_by(models.AiPhoneMenuDevice.created_at.desc())
    ).all()
    return [_device_public_dict(d) for d in devices]


@router.delete("/ai-phone-menu/devices/{device_id}")
def deactivate_ai_phone_menu_device(
    device_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    device = session.exec(
        select(models.AiPhoneMenuDevice).where(
            models.AiPhoneMenuDevice.id == device_id,
            models.AiPhoneMenuDevice.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not device:
        raise HTTPException(status_code=404, detail="Device not found")
    device.is_active = False
    session.add(device)
    session.commit()
    return {"status": "deactivated", "id": device_id}


# --- Public: bounded menu-explainer sessions, authenticated by device token ---

def _enforce_phone_menu_rate_limit(device_id: int) -> None:
    """Per-device-token hourly cap (not per-IP — the caller is a fixed physical phone, and
    IP-based limiting would also throttle legitimate traffic behind the same NAT)."""
    if not settings.rate_limit_enabled:
        return
    limit = settings.rate_limit_phone_menu_per_hour
    if limit <= 0:
        return
    key = f"rl:phone_menu:{device_id}"
    try:
        r = redis.Redis.from_url(
            rate_limit_redis_url(),
            decode_responses=True,
            socket_connect_timeout=1.0,
            socket_timeout=1.0,
        )
        n = r.incr(key)
        if n == 1:
            r.expire(key, 3600)
        if n > limit:
            raise HTTPException(status_code=status.HTTP_429_TOO_MANY_REQUESTS, detail="Too many calls, try later.")
    except HTTPException:
        raise
    except redis.RedisError:
        pass  # fail open — a Redis blip shouldn't take down the phone line


def _device_or_401(session: Session, token: str) -> models.AiPhoneMenuDevice:
    device = find_device_by_token(session, token)
    if not device:
        raise HTTPException(status_code=401, detail="Invalid device token")
    return device


@router.post("/public/ai-phone-menu/sessions")
def start_ai_phone_menu_session(body: models.AiPhoneMenuSessionStart, session: Session = Depends(get_session)) -> dict:
    device = _device_or_401(session, body.token)
    _enforce_phone_menu_rate_limit(device.id)

    device.last_used_at = datetime.now(timezone.utc)
    session.add(device)

    menu_session = models.AiPhoneMenuSession(tenant_id=device.tenant_id, device_id=device.id)
    session.add(menu_session)
    session.commit()
    session.refresh(menu_session)

    return {"session_id": menu_session.id, "greeting": GREETING_TEXT}


@router.post("/public/ai-phone-menu/sessions/{session_id}/turn")
def advance_ai_phone_menu_session_turn(
    session_id: int,
    body: models.AiPhoneMenuSessionTurn,
    session: Session = Depends(get_session),
) -> dict:
    device = _device_or_401(session, body.token)
    _enforce_phone_menu_rate_limit(device.id)

    menu_session = session.exec(
        select(models.AiPhoneMenuSession).where(
            models.AiPhoneMenuSession.id == session_id,
            models.AiPhoneMenuSession.device_id == device.id,
        )
    ).first()
    if not menu_session:
        raise HTTPException(status_code=404, detail="Session not found")

    message = (body.message or "").strip()
    if not message:
        raise HTTPException(status_code=400, detail="message is required")

    try:
        result = process_menu_turn(session, menu_session, message)
    except RuntimeError as e:
        if str(e) == "phone_order_ai_not_configured":
            raise HTTPException(status_code=400, detail="Falta configurar la clave de OpenAI (PHONE_ORDER_AI_API_KEY)")
        raise HTTPException(status_code=502, detail="No se pudo contactar al servicio de IA") from e
    return result
