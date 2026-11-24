// One-time side tips: a card in the corner that explains something the app
// just did, once, and stays until the learner closes it. Closing (or taking
// its action) saves `tip_seen_<id>`, which syncs like a setting, so a tip
// never comes back on another exercise or device.
//
// One tip at a time: a second offer while one is up is simply dropped.

import { SettingsKeys } from '$lib/domain/keys';
import { storage } from '$lib/services/storage';
import { progress } from '$lib/state/progress.svelte';

export type SideTipId = 'wait-after-miss';

export const sideTip = $state<{ id: SideTipId | null }>({ id: null });

/** Shows the tip unless it has been closed before or another is up. */
export async function offerTip(id: SideTipId): Promise<void> {
	if (sideTip.id) return;
	if (await storage.get(SettingsKeys.tipSeenPrefix + id)) return;
	sideTip.id ??= id;
}

/** Closes the tip on show for good. */
export async function dismissTip(): Promise<void> {
	const id = sideTip.id;
	sideTip.id = null;
	if (id) await storage.set(SettingsKeys.tipSeenPrefix + id, '1');
}

/**
 * A wrong answer is waiting for Next: the first time that happens because of
 * the new default (not because the learner chose "Wait for me"), say it can be
 * changed.
 */
export function noteHeldMiss(): void {
	if (progress.answerRevealMode === 'manual' || !progress.waitAfterMiss) return;
	void offerTip('wait-after-miss');
}
