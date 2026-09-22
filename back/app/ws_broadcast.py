"""
Redis pub/sub publishing for the WebSocket bridge (ws-bridge/main.py subscribes to these
channels and forwards messages to connected browser clients). Extracted out of main.py so
other modules (e.g. ai_phone_order_service.py) can publish without importing main.py itself
and creating a circular import.
"""

from __future__ import annotations

import json
import os

import redis

_redis_client: redis.Redis | None = None


def get_redis() -> redis.Redis | None:
    global _redis_client
    if _redis_client is None:
        redis_url = os.getenv("REDIS_URL", "redis://localhost:6379")
        try:
            _redis_client = redis.from_url(redis_url)
            _redis_client.ping()
        except Exception:
            _redis_client = None
    return _redis_client


def publish_order_update(tenant_id: int, order_data: dict, table_id: int | None = None) -> None:
    """Publish order update to Redis for the WebSocket bridge.

    Publishes to both:
    - orders:tenant:{tenant_id} - for restaurant owners (all tenant orders)
    - orders:table:{table_id} - for customers (table-specific orders, if table_id provided)
    """
    r = get_redis()
    if r:
        try:
            r.publish(f"orders:tenant:{tenant_id}", json.dumps(order_data))
            if table_id is not None:
                r.publish(f"orders:table:{table_id}", json.dumps(order_data))
        except Exception:
            pass  # Fail silently if Redis unavailable
