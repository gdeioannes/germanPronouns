<script lang="ts">
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	// Settings card: a weekly practice reminder in the learner's own calendar.
	// There is no server to send notifications, so the calendar does it — see
	// domain/reminder.ts.
	import Icon from '$lib/icons/Icon.svelte';
	import { catalog } from '$lib/content';
	import { absoluteUrl } from '$lib/seo';
	import { track } from '$lib/services/analytics';
	import { announce } from '$lib/a11y.svelte';
	import {
		WEEKDAYS,
		reminderGoogleUrl,
		reminderIcs,
		type ReminderPlan,
		type Weekday
	} from '$lib/domain/reminder';

	let days = $state<Weekday[]>(['MO', 'WE', 'FR']);
	let time = $state('19:00');
	let minutes = $state(15);

	const ready = $derived(days.length > 0 && /^\d{2}:\d{2}$/.test(time));

	const plan = $derived<ReminderPlan>({
		days,
		time,
		minutes,
		title: t('German practice 🇩🇪'),
		url: absoluteUrl(`/course/${catalog.defaultCourseId}`)
	});

	const googleUrl = $derived(ready ? reminderGoogleUrl(plan) : undefined);

	function toggle(day: Weekday) {
		days = days.includes(day) ? days.filter((d) => d !== day) : [...days, day];
	}

	// Day names in the learner's language, from the browser (2024-01-01 was a Monday).
	const dayName = (i: number, style: 'short' | 'long') =>
		lang.tr ? new Date(2024, 0, 1 + i).toLocaleDateString('tr', { weekday: style }) : style === 'short' ? WEEKDAYS[i].short : WEEKDAYS[i].long;

	/** "Monday, Wednesday and Friday at 19:00" — the plan in words, for the summary line. */
	const summary = $derived.by(() => {
		const names = WEEKDAYS.flatMap((w, i) => (days.includes(w.code) ? [dayName(i, 'long')] : []));
		if (names.length === 7) return t('Every day at {time}', { time });
		const list = new Intl.ListFormat(lang.current, { type: 'conjunction' }).format(names);
		return t('{days} at {time}, {minutes} minutes', { days: list, time, minutes });
	});

	function props(target: string) {
		return { target, days: days.length, time, minutes };
	}

	function downloadIcs() {
		if (!ready) return;
		const blob = new Blob([reminderIcs(plan)], { type: 'text/calendar;charset=utf-8' });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = 'german-practice.ics';
		a.click();
		setTimeout(() => URL.revokeObjectURL(url), 1000);
		track('reminder_added', props('ics'));
		announce(t('Calendar file downloaded. Open it to add the reminder.'));
	}
</script>

<section class="card">
	<h2>{t('Practice reminder')}</h2>
	<p class="lede">
		{t('Little and often beats long and rare. Pick your days and a time, and add a repeating reminder to your own calendar — tapping it brings you straight back to your course. Nothing is sent to us; change or delete it in your calendar whenever you like.')}
	</p>

	<div class="field">
		<span class="label" id="reminder-days">{t('Days')}</span>
		<div class="days" role="group" aria-labelledby="reminder-days" aria-describedby="reminder-status">
			{#each WEEKDAYS as day, i (day.code)}
				<button
					type="button"
					aria-pressed={days.includes(day.code)}
					aria-label="{dayName(i, 'short')}, {dayName(i, 'long')}"
					onclick={() => toggle(day.code)}
				>
					{#if days.includes(day.code)}<Icon name="check" size="0.85em" />{/if}
					{dayName(i, 'short')}
				</button>
			{/each}
		</div>
	</div>

	<div class="pair">
		<label class="field">
			<span class="label">{t('Time')}</span>
			<input type="time" bind:value={time} required />
		</label>
		<label class="field">
			<span class="label">{t('Length')}</span>
			<select bind:value={minutes}>
				{#each [5, 10, 15, 20, 30] as m (m)}
					<option value={m}>{t('{n} minutes', { n: m })}</option>
				{/each}
			</select>
		</label>
	</div>

	<!-- Always in the page, so a screen reader hears it change rather than missing
	     a region that appears out of nowhere. -->
	<p class="status" class:hint={!ready} id="reminder-status" role="status">
		{ready ? summary : t('Pick at least one day and a time.')}
	</p>

	<div class="actions">
		{#if googleUrl}
			<a
				class="btn"
				href={googleUrl}
				target="_blank"
				rel="noopener"
				onclick={() => track('reminder_added', props('google'))}
			>
				<Icon name="calendar" size="1em" /> {t('Google Calendar')}
				<Icon name="external" size="0.85em" />
				<span class="sr-only">{t('(opens in a new tab)')}</span>
			</a>
		{:else}
			<!-- A link can't be disabled; a button can, and says so to a screen reader. -->
			<button type="button" class="btn" disabled>
				<Icon name="calendar" size="1em" /> {t('Google Calendar')}
			</button>
		{/if}
		<button type="button" class="btn" disabled={!ready} onclick={downloadIcs}>
			<Icon name="download" size="1em" /> {t('Apple, Outlook & others (.ics)')}
		</button>
	</div>
</section>

<style>
	.card {
		padding: 1.35rem 1.6rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	h2 {
		margin: 0 0 0.6rem;
		font-size: 1.05rem;
	}

	.lede {
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.field {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		margin-bottom: 1rem;
	}

	.label {
		font-size: var(--step--1);
		font-weight: 600;
	}

	.days {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
	}

	.days button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.2rem;
		min-width: 3.1rem;
		min-height: 2.25rem;
		padding: 0.4rem 0.6rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out);
	}

	.days button[aria-pressed='true'] {
		border-color: var(--ink);
		background: var(--ink);
		color: var(--surface);
	}

	/* High-contrast mode drops the fill, so mark the chosen days another way. */
	@media (forced-colors: active) {
		.days button[aria-pressed='true'] {
			border-width: 3px;
			text-decoration: underline;
		}
	}

	.pair {
		display: flex;
		flex-wrap: wrap;
		gap: 0 1.25rem;
	}

	.pair input,
	.pair select {
		padding: 0.4rem 0.6rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	.status {
		margin: 0 0 0.75rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.status.hint {
		color: var(--wrong);
	}

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.5rem 1.05rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.btn:hover:not(:disabled) {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	.btn:disabled {
		opacity: 0.5;
		cursor: default;
	}
</style>
