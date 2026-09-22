/**
 * Phones AI — dedicated page for the AI phone-order module (moved out of Orders so it
 * doesn't clutter that screen; a global toast + sidebar badge, both driven by
 * AiPhoneNotificationService, cover awareness while staff are on any other page).
 */
import { Component, OnDestroy, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { SidebarComponent } from '../shared/sidebar.component';
import { ApiService, AiPhoneOrderDraft, TenantSettings } from '../services/api.service';
import { PermissionService } from '../services/permission.service';
import { AiPhoneNotificationService } from '../services/ai-phone-notification.service';
import { intlLocaleFromTranslate } from '../shared/intl-locale';
import { currencySymbolFromIsoCode } from '../shared/currency-symbol';

@Component({
  selector: 'app-phones-ai',
  standalone: true,
  imports: [CommonModule, FormsModule, SidebarComponent, TranslateModule],
  templateUrl: './phones-ai.component.html',
  styleUrl: './phones-ai.component.scss',
})
export class PhonesAiComponent implements OnInit, OnDestroy {
  private api = inject(ApiService);
  private translate = inject(TranslateService);
  private permissions = inject(PermissionService);
  protected notif = inject(AiPhoneNotificationService);

  private pollHandle?: ReturnType<typeof setInterval>;

  drafts = signal<AiPhoneOrderDraft[]>([]);
  busyId = signal<number | null>(null);
  newLabel = 'Teléfono 1';
  startingSimulation = signal(false);
  draftMessages: Record<number, string> = {};
  lastReply: Record<number, string> = {};
  toast = signal<{ message: string; type: 'success' | 'error' } | null>(null);
  private toastTimeout?: ReturnType<typeof setTimeout>;

  currency = signal('$');
  currencyCode = signal<string | null>('USD');

  canManage(): boolean {
    return this.permissions.hasPermission(this.api.getCurrentUser(), 'order:update_status');
  }

  ngOnInit(): void {
    this.api.getTenantSettings().subscribe({
      next: (settings: TenantSettings) => {
        const code = settings.currency_code || null;
        this.currencyCode.set(code);
        this.currency.set(code ? currencySymbolFromIsoCode(this.translate, code) : settings.currency || '$');
      },
      error: () => {},
    });
    this.refresh();
    this.pollHandle = setInterval(() => this.refresh(), 8000);
  }

  ngOnDestroy(): void {
    if (this.pollHandle) clearInterval(this.pollHandle);
  }

  refresh(): void {
    this.api.listAiPhoneOrders().subscribe({
      next: (list) => this.drafts.set(list.filter(d => d.status === 'in_progress' || d.status === 'pending_review')),
      error: () => {},
    });
    this.notif.refresh();
  }

  showToast(message: string, type: 'success' | 'error'): void {
    if (this.toastTimeout) clearTimeout(this.toastTimeout);
    this.toast.set({ message, type });
    this.toastTimeout = setTimeout(() => this.toast.set(null), 4000);
  }

  formatPrice(priceCents: number): string {
    const code = this.currencyCode();
    const locale = intlLocaleFromTranslate(this.translate);
    if (code) {
      return new Intl.NumberFormat(locale, { style: 'currency', currency: code, currencyDisplay: 'symbol' }).format(priceCents / 100);
    }
    return `${this.currency()}${(priceCents / 100).toFixed(2)}`;
  }

  draftTotal(draft: AiPhoneOrderDraft): number {
    return draft.items.reduce((sum, it) => sum + it.price_cents * it.quantity, 0);
  }

  statusLabel(status: string): string {
    switch (status) {
      case 'in_progress': return this.translate.instant('ORDERS.AI_PHONE_STATUS_IN_PROGRESS');
      case 'pending_review': return this.translate.instant('ORDERS.AI_PHONE_STATUS_PENDING_REVIEW');
      case 'accepted': return this.translate.instant('ORDERS.AI_PHONE_STATUS_ACCEPTED');
      case 'rejected': return this.translate.instant('ORDERS.AI_PHONE_STATUS_REJECTED');
      default: return status;
    }
  }

  startSimulation(): void {
    const label = (this.newLabel || 'Teléfono 1').trim() || 'Teléfono 1';
    this.startingSimulation.set(true);
    this.api.createAiPhoneOrder(label).subscribe({
      next: (draft) => {
        this.startingSimulation.set(false);
        this.drafts.set([draft, ...this.drafts()]);
      },
      error: () => {
        this.startingSimulation.set(false);
        this.showToast(this.translate.instant('ORDERS.AI_PHONE_ERROR'), 'error');
      },
    });
  }

  sendMessage(draft: AiPhoneOrderDraft): void {
    const message = (this.draftMessages[draft.id] || '').trim();
    if (!message || this.busyId() === draft.id) return;
    this.busyId.set(draft.id);
    this.api.advanceAiPhoneOrderTurn(draft.id, message).subscribe({
      next: (result) => {
        this.busyId.set(null);
        this.draftMessages[draft.id] = '';
        this.lastReply[draft.id] = result.reply;
        this.drafts.set(this.drafts().map(d => d.id === draft.id
          ? { ...d, items: result.items, customer_note: result.customer_note, status: result.status as AiPhoneOrderDraft['status'] }
          : d));
        if (result.finished) this.notif.refresh();
      },
      error: (err) => {
        this.busyId.set(null);
        const msg = err?.status === 400 && err?.error?.detail?.includes('PHONE_ORDER_AI_API_KEY')
          ? this.translate.instant('ORDERS.AI_PHONE_NOT_CONFIGURED')
          : this.translate.instant('ORDERS.AI_PHONE_ERROR');
        this.showToast(msg, 'error');
      },
    });
  }

  accept(draft: AiPhoneOrderDraft): void {
    if (this.busyId() === draft.id) return;
    this.busyId.set(draft.id);
    this.api.acceptAiPhoneOrder(draft.id).subscribe({
      next: () => {
        this.busyId.set(null);
        this.drafts.set(this.drafts().filter(d => d.id !== draft.id));
        this.showToast(this.translate.instant('ORDERS.AI_PHONE_ACCEPTED_TOAST'), 'success');
        this.notif.refresh();
      },
      error: () => {
        this.busyId.set(null);
        this.showToast(this.translate.instant('ORDERS.AI_PHONE_ERROR'), 'error');
      },
    });
  }

  confirmReject(draft: AiPhoneOrderDraft): void {
    if (!confirm(this.translate.instant('ORDERS.AI_PHONE_REJECT_CONFIRM'))) return;
    this.busyId.set(draft.id);
    this.api.rejectAiPhoneOrder(draft.id).subscribe({
      next: () => {
        this.busyId.set(null);
        this.drafts.set(this.drafts().filter(d => d.id !== draft.id));
        this.showToast(this.translate.instant('ORDERS.AI_PHONE_REJECTED_TOAST'), 'success');
        this.notif.refresh();
      },
      error: () => {
        this.busyId.set(null);
        this.showToast(this.translate.instant('ORDERS.AI_PHONE_ERROR'), 'error');
      },
    });
  }
}
