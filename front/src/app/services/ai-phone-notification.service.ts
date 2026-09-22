import { Injectable, inject, signal } from '@angular/core';
import { ApiService } from './api.service';
import { PermissionService } from './permission.service';

export interface AiPhoneToast {
  id: number;
  phoneLabel: string;
}

/**
 * App-wide "new AI phone order to review" awareness — independent of which page is open.
 * Injected once from app.ts so it starts listening at boot, not just while the Phones AI
 * page happens to be mounted. The sidebar badge and the transient toast both read from here.
 */
@Injectable({ providedIn: 'root' })
export class AiPhoneNotificationService {
  private api = inject(ApiService);
  private permissions = inject(PermissionService);

  pendingCount = signal(0);
  toast = signal<AiPhoneToast | null>(null);

  private toastTimeout?: ReturnType<typeof setTimeout>;
  private pollHandle?: ReturnType<typeof setInterval>;
  private started = false;

  /** Call once (from app.ts) after login state is known. Safe to call more than once. */
  start(): void {
    if (this.started) return;
    if (!this.api.getCurrentUser()) return;
    if (!this.permissions.hasPermission(this.api.getCurrentUser(), 'order:update_status')) {
      // Not applicable to this role (e.g. kitchen display accounts) — never poll for it.
      return;
    }
    this.started = true;

    this.refresh();
    // Light fallback poll — the real-time path is the WebSocket event below, this just
    // covers a missed message (e.g. briefly offline) without hammering the API.
    this.pollHandle = setInterval(() => this.refresh(), 30000);

    try {
      this.api.connectWebSocket();
      this.api.orderUpdates$.subscribe((update: unknown) => {
        if (update && typeof update === 'object' && (update as { type?: string }).type === 'ai_phone_order_pending') {
          const evt = update as { draft_id: number; phone_label: string };
          this.refresh();
          this.showToast(evt.draft_id, evt.phone_label);
        }
      });
    } catch {
      // continue on polling alone
    }
  }

  refresh(): void {
    this.api.listAiPhoneOrders('pending_review').subscribe({
      next: (list) => this.pendingCount.set(list.length),
      error: () => {},
    });
  }

  showToast(draftId: number, phoneLabel: string): void {
    if (this.toastTimeout) clearTimeout(this.toastTimeout);
    this.toast.set({ id: draftId, phoneLabel });
    this.toastTimeout = setTimeout(() => this.toast.set(null), 6000);
  }

  dismissToast(): void {
    if (this.toastTimeout) clearTimeout(this.toastTimeout);
    this.toast.set(null);
  }
}
