"""Unified log for staff actions and unhandled backend errors (see StaffActionLog).

Writing a log entry must never break the action being logged, so log_staff_action()
swallows its own failures — a working delete/mark-paid/etc. is more important than a
guaranteed audit row.
"""

from __future__ import annotations

import logging

from sqlmodel import Session

from . import models

logger = logging.getLogger(__name__)


def log_staff_action(
    session: Session,
    *,
    tenant_id: int,
    user_id: int | None = None,
    user_email: str | None = None,
    action_type: str,
    summary: str | None = None,
    detail: dict | None = None,
    success: bool = True,
    error_message: str | None = None,
    request_path: str | None = None,
) -> None:
    try:
        row = models.StaffActionLog(
            tenant_id=tenant_id,
            user_id=user_id,
            user_email=user_email,
            action_type=action_type,
            summary=summary,
            detail=detail,
            success=success,
            error_message=(error_message or "")[:4000] or None,
            request_path=(request_path or "")[:255] or None,
        )
        session.add(row)
        session.commit()
    except Exception:
        logger.exception("Failed to write staff_action_log row (action_type=%s)", action_type)
        try:
            session.rollback()
        except Exception:
            pass
