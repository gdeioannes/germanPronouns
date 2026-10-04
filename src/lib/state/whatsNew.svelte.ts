// The "something new" dot on the What's new link. It lights up when the
// changelog has a release newer than the last one this browser saw, and goes
// out once the changelog page is opened. A first visit marks everything as
// seen without lighting it: a newcomer has nothing to catch up on.
//
// Purely a per-browser convenience — storage can be blocked or wiped, and
// then the dot simply stays dark.
import { browser } from '$app/environment';
import { changelog } from '$lib/content/changelog';
import { SettingsKeys } from '$lib/domain/keys';

const latest = changelog[0]?.date ?? '';

export const whatsNew = $state({ unseen: false });

function read(): string | null {
	try {
		return localStorage.getItem(SettingsKeys.changelogSeen);
	} catch {
		return null;
	}
}

function write(date: string): void {
	try {
		localStorage.setItem(SettingsKeys.changelogSeen, date);
	} catch {
		// Blocked storage: the dot just won't remember.
	}
}

/** Called once on the client; prerendered HTML always ships without the dot. */
export function initWhatsNew(): void {
	if (!browser || !latest) return;
	const seen = read();
	if (seen === null) write(latest);
	else whatsNew.unseen = seen < latest;
}

/** The changelog page has been opened: everything up to `latest` is read. */
export function markWhatsNewSeen(): void {
	if (!browser || !latest) return;
	write(latest);
	whatsNew.unseen = false;
}
