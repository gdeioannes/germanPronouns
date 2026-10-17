<script lang="ts">
	// A torn-off ticket stub: what a "Schreib mir!" chat costs. One ticket from
	// the pocket shared with Ja oder Nein?, or "free" for a chat already running.
	let {
		free = false,
		pocket = null,
		refillAt = 0,
		size = 'md'
	}: {
		/** A chat in progress: continuing costs nothing. */
		free?: boolean;
		/** Tickets in the pocket, shown under the cost; 0 locks the stub. */
		pocket?: number | null;
		/** When the next free ticket arrives, for the locked stub. */
		refillAt?: number;
		size?: 'sm' | 'md';
	} = $props();

	const locked = $derived(!free && pocket === 0);
	/** "in 4 Std" / "in 35 Min" until the next free ticket. */
	const wait = $derived.by(() => {
		const ms = Math.max(0, refillAt - Date.now());
		const h = Math.floor(ms / 3600e3);
		return h >= 1 ? `in ${h} Std` : `in ${Math.max(1, Math.ceil(ms / 60e3))} Min`;
	});
</script>

<span
	class="stub {size}"
	class:free
	class:locked
	aria-label={free
		? 'Free: chat in progress'
		: locked
			? `No ticket left. The next free one arrives ${wait.replace('Std', 'hours').replace('Min', 'minutes')}.`
			: `Costs 1 ticket${pocket !== null ? `, ${pocket} in your pocket` : ''}`}
>
	<span class="perf" aria-hidden="true"></span>
	<span class="main" aria-hidden="true">
		{#if free}
			<span class="big">Gratis</span>
			<span class="small">läuft schon</span>
		{:else if locked}
			<span class="big">🔒 0</span>
			<span class="small">neu {wait}</span>
		{:else}
			<span class="big">🎟️ 1</span>
			<span class="small">{pocket !== null ? `${pocket} in der Tasche` : 'Ticket'}</span>
		{/if}
	</span>
</span>

<style>
	.stub {
		position: relative;
		display: inline-flex;
		align-items: stretch;
		border-radius: 0.45rem;
		background: linear-gradient(135deg, #ff4d6d, #c9683b 70%, #d9a441);
		color: #fff;
		box-shadow:
			0 0.4rem 1rem -0.3rem rgb(194 54 74 / 0.6),
			inset 0 0 0 1px rgb(255 255 255 / 0.25);
		transform: rotate(6deg);
		/* Two half-circle notches where the stub was torn. */
		-webkit-mask:
			radial-gradient(circle at 0 50%, transparent 0.42rem, #000 0.45rem) left / 51% 100% no-repeat,
			radial-gradient(circle at 100% 50%, transparent 0.42rem, #000 0.45rem) right / 51% 100% no-repeat;
		mask:
			radial-gradient(circle at 0 50%, transparent 0.42rem, #000 0.45rem) left / 51% 100% no-repeat,
			radial-gradient(circle at 100% 50%, transparent 0.42rem, #000 0.45rem) right / 51% 100% no-repeat;
		animation: wiggle 3.2s ease-in-out infinite;
	}
	.stub.free {
		background: linear-gradient(135deg, #3f7d46, #6aa86f);
		box-shadow: 0 0.4rem 1rem -0.3rem rgb(63 125 70 / 0.6);
	}
	.stub.locked {
		background: linear-gradient(135deg, #8a8f99, #5c6270);
		box-shadow: 0 0.4rem 1rem -0.3rem rgb(40 45 60 / 0.5);
		animation: none;
		transform: rotate(-4deg);
	}
	.perf {
		width: 0;
		margin: 0.35rem 0 0.35rem 0.9rem;
		border-left: 2px dashed rgb(255 255 255 / 0.65);
	}
	.main {
		display: grid;
		justify-items: center;
		padding: 0.35rem 0.95rem 0.4rem 0.6rem;
		line-height: 1.05;
	}
	.big {
		font-weight: 900;
		font-size: 1.25rem;
		letter-spacing: 0.02em;
	}
	.small {
		font-size: 0.62rem;
		font-weight: 700;
		text-transform: uppercase;
		letter-spacing: 0.06em;
		opacity: 0.92;
	}
	.sm .big {
		font-size: 1rem;
	}
	.sm .main {
		padding: 0.25rem 0.8rem 0.3rem 0.5rem;
	}
	@keyframes wiggle {
		0%,
		86%,
		100% {
			transform: rotate(6deg);
		}
		90% {
			transform: rotate(1deg) scale(1.06);
		}
		95% {
			transform: rotate(9deg) scale(1.03);
		}
	}
	:global(html[data-effects='calm']) .stub {
		animation: none;
	}
	@media (prefers-reduced-motion: reduce) {
		.stub {
			animation: none;
		}
	}
</style>
