"""Regression test: sales reports must attribute revenue to the tenant's LOCAL calendar day,
not the raw UTC day the timestamp happens to be stored in.

Real bug found live: Order.created_at/paid_at are stored as naive UTC. Ecuador is UTC-5, so an
order placed at 22:00 local time is already 03:00 UTC the next day — comparing/grouping by the
raw UTC date silently moved evening sales into tomorrow's report (confirmed live: a full day's
report undercounted orders by nearly half before this fix).
"""

from __future__ import annotations

import unittest
from datetime import date, datetime, timezone

from pg_client_mixin import PgClientTestCase

from app import models
from app.reports_routes import _build_report_payload


class TestReportsTimezone(PgClientTestCase):
    def setUp(self) -> None:
        super().setUp()
        tenant = models.Tenant(name="Timezone Test", timezone="America/Guayaquil")
        self.session.add(tenant)
        self.session.commit()
        self.session.refresh(tenant)
        self.tenant_id = tenant.id

    def _make_paid_order(self, paid_at: datetime, price_cents: int = 1000) -> None:
        order = models.Order(
            tenant_id=self.tenant_id,
            table_id=None,
            status=models.OrderStatus.paid,
            paid_at=paid_at,
        )
        self.session.add(order)
        self.session.flush()
        product = models.Product(tenant_id=self.tenant_id, name="Test Item", price_cents=price_cents)
        self.session.add(product)
        self.session.flush()
        item = models.OrderItem(
            order_id=order.id,
            product_id=product.id,
            product_name=product.name,
            quantity=1,
            price_cents=price_cents,
            status=models.OrderItemStatus.delivered,
        )
        self.session.add(item)
        self.session.commit()

    def test_late_evening_order_attributed_to_local_day_not_utc_day(self):
        # 2026-01-02 03:30 UTC == 2026-01-01 22:30 America/Guayaquil (UTC-5) — a customer who
        # paid right before closing on Jan 1st, stored under the Jan 2nd UTC calendar date.
        self._make_paid_order(datetime(2026, 1, 2, 3, 30, tzinfo=None))

        jan1 = _build_report_payload(self.tenant_id, self.session, date(2026, 1, 1), date(2026, 1, 1))
        jan2 = _build_report_payload(self.tenant_id, self.session, date(2026, 1, 2), date(2026, 1, 2))

        self.assertEqual(jan1["summary"]["total_revenue_cents"], 1000)
        self.assertEqual(jan2["summary"]["total_revenue_cents"], 0)
        self.assertEqual(jan1["summary"]["daily"][0]["date"], "2026-01-01")

    def test_tenant_without_timezone_falls_back_to_ecuador(self):
        tenant = self.session.get(models.Tenant, self.tenant_id)
        tenant.timezone = None
        self.session.add(tenant)
        self.session.commit()

        self._make_paid_order(datetime(2026, 1, 2, 3, 30, tzinfo=None))
        jan1 = _build_report_payload(self.tenant_id, self.session, date(2026, 1, 1), date(2026, 1, 1))
        self.assertEqual(jan1["summary"]["total_revenue_cents"], 1000)


if __name__ == "__main__":
    unittest.main()
