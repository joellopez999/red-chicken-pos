import { Component, signal, OnInit, OnDestroy, inject } from '@angular/core';
import { RouterOutlet, Router, NavigationEnd } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { filter, Subscription } from 'rxjs';
import { LanguageService } from './services/language.service';
import { SeoService } from './services/seo.service';
import { AiPhoneNotificationService } from './services/ai-phone-notification.service';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, TranslateModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements OnInit, OnDestroy {
  protected readonly title = signal('front');
  private router = inject(Router);
  private routerSub?: Subscription;

  /** Inject so LanguageService initializes at bootstrap and applies browser default language everywhere from first load. */
  private languageService = inject(LanguageService);
  private seo = inject(SeoService);
  /** Public: app.html reads pendingCount/toast to render the badge-independent global toast. */
  protected aiPhoneNotif = inject(AiPhoneNotificationService);

  ngOnInit() {
    this.seo.start();

    // Set initial favicon based on current route
    this.updateFavicon(this.router.url);
    // Not logged in yet on first load in most cases — retried (cheaply, it's idempotent)
    // on every navigation below so it actually starts right after login.
    this.aiPhoneNotif.start();

    // Listen to route changes and update favicon
    this.routerSub = this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe((event) => {
        if (event instanceof NavigationEnd) {
          this.updateFavicon(event.urlAfterRedirects);
          this.aiPhoneNotif.start();
        }
      });
  }

  ngOnDestroy() {
    this.seo.stop();
    this.routerSub?.unsubscribe();
  }

  private updateFavicon(_url: string) {
    // Dev: white | Staging: blue | Production: orange (all routes)
    if (!environment.production) {
      this.setFavicon('/favicon-dev.svg');
      return;
    }
    if (environment.staging) {
      this.setFavicon('/favicon-admin.svg');
      return;
    }
    this.setFavicon('/favicon.svg');
  }

  private setFavicon(path: string) {
    // Remove existing favicon links
    const existingLinks = document.querySelectorAll('link[rel*="icon"]');
    existingLinks.forEach(link => link.remove());

    // Create new favicon link
    const link = document.createElement('link');
    link.rel = 'icon';
    link.type = 'image/svg+xml';
    link.href = `${path}?v=2.0.0`;
    document.head.appendChild(link);

    // Also update apple-touch-icon
    const appleLink = document.createElement('link');
    appleLink.rel = 'apple-touch-icon';
    appleLink.href = path;
    document.head.appendChild(appleLink);
  }
}
