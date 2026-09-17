"""Shared take-away/pickup table name matching.

Single source of truth for "is this Table a take-away/pickup table" — used to skip the
customer PIN and to surface a pickup link on the public menu. Previously duplicated in
main.py and offline_order_service.py, which let them drift out of sync (the English-only
name list missed "Para llevar", silently blocking every pickup order via that QR).
"""

from __future__ import annotations

from typing import Protocol


class _NamedTable(Protocol):
    name: str | None


TAKE_AWAY_TABLE_NAMES = (
    "take away", "home ordering", "takeaway", "take-away",
    "para llevar", "para-llevar", "llevar", "pickup", "para recoger", "recoger", "recogida",
)


def is_take_away_table(table: _NamedTable | None) -> bool:
    """True if table name indicates take-away/pickup ordering (no PIN required)."""
    if not table or not getattr(table, "name", None):
        return False
    return (table.name or "").strip().lower() in TAKE_AWAY_TABLE_NAMES
