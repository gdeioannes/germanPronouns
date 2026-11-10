<script lang="ts">
	// "Save this level for offline" on a level's page: one button, a progress
	// bar while it downloads, and the date it was last saved.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import {
		fetchOfflineList,
		megabytes,
		offlineSupported,
		saveLevel,
		savedLevels,
		type OfflineLevel,
		type SaveProgress
	} from '$lib/offline/saveLevel';

	let { level }: { level: string } = $props();

	let supported = $state(false);
	let list = $state<OfflineLevel | null>(null);
	let savedAt = $state<number | null>(null);
	let progress = $state<SaveProgress | null>(null);
	let result = $state<'ok' | 'partial' | 'error' | null>(null);

	onMount(() => {
		supported = offlineSupported();
		if (!supported) return;
		void (async () => {
			savedAt = (await savedLevels())[level] ?? null;
			try {
				list = await fetchOfflineList(level);
			} catch {
				list = null;
			}
		})();
	});

	async function save() {
		if (progress) return;
		result = null;
		try {
			const l = list ?? (await fetchOfflineList(level));
			progress = { done: 0, total: l.pages.length + l.media.length };
			const failed = await saveLevel(l, (p) => (progress = p));
			savedAt = Date.now();
			result = failed ? 'partial' : 'ok';
			announce(failed ? `${level} saved, but ${failed} files could not be downloaded.` : `${level} is saved for offline.`);
		} catch {
			result = 'error';
			announce('Saving failed. Check your connection and try again.');
		} finally {
			progress = null;
		}
	}

	const when = $derived(savedAt ? new Date(savedAt).toLocaleDateString(undefined, { day: 'numeric', month: 'short' }) : '');
</script>

{#if supported}
	<section class="offline" aria-labelledby="offline-h">
		<div class="text">
			<h2 id="offline-h">Study without a connection</h2>
			<p>
				{#if progress}
					Saving {level}… keep this page open.
				{:else if result === 'error'}
					Saving failed. Check your connection and try again.
				{:else if result === 'partial'}
					Saved on {when}, but a few files did not download. Try again to fill the gaps.
				{:else if savedAt}
					Saved on {when}: every exercise, book chapter and recording of {level} works offline.
				{:else}
					Download every exercise, book chapter and recording of {level}{#if list}, about {megabytes(list.bytes)} MB{/if}, for the U-Bahn or a flight.
				{/if}
			</p>
			{#if progress}
				<progress max={progress.total} value={progress.done} aria-label="Saving {level}">{progress.done} of {progress.total}</progress>
			{/if}
		</div>
		<button class="btn" type="button" onclick={save} disabled={!!progress}>
			<Icon name="download" size="1em" />
			{progress ? `${Math.round((progress.done / Math.max(1, progress.total)) * 100)} %` : savedAt ? 'Update' : 'Save offline'}
		</button>
	</section>
{/if}

<style>
	.offline { display: flex; align-items: center; gap: 1rem; margin: 1.5rem 0; padding: 0.9rem 1rem; border: 1px solid var(--line); border-radius: var(--radius-sm); background: var(--surface); }
	.text { flex: 1; min-width: 0; }
	h2 { margin: 0 0 0.2rem; font-size: var(--step-0); }
	p { margin: 0; font-size: var(--step--1); color: var(--ink-muted); }
	progress { width: 100%; height: 0.4rem; margin-top: 0.5rem; accent-color: var(--accent); }
	.btn { flex: none; display: inline-flex; align-items: center; gap: 0.4rem; white-space: nowrap; }
	@media (max-width: 30rem) { .offline { flex-direction: column; align-items: stretch; } }
</style>
