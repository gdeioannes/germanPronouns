<script lang="ts">
	// Every photo that carries overlay text, with the text laid on, to check
	// that each box sits on the blank sign, paper or screen it was measured for.
	import OverlayText from '$lib/components/match/OverlayText.svelte';
	import { MATCH_CHATS } from '$lib/domain/matchChat';

	const photos = MATCH_CHATS.flatMap((c) =>
		c.turns.flatMap((t) => t.before.filter((m) => m.type === 'photo' && m.overlay).map((m) => ({ chat: c.id, msg: m })))
	);
	let ratios = $state<Record<string, number>>({});
</script>

<main>
	<h1>Overlay check · {photos.length} photos</h1>
	<div class="grid">
		{#each photos as p (p.msg.image)}
			<figure>
				<div class="photo">
					<img
						src="/img/story/{p.msg.image}.webp"
						alt=""
						onload={(e) => {
							const img = e.currentTarget as HTMLImageElement;
							ratios = { ...ratios, [p.msg.image!]: img.naturalHeight / img.naturalWidth };
						}}
					/>
					<OverlayText image={p.msg.image!} lines={p.msg.overlay!} ratio={ratios[p.msg.image!]} />
				</div>
				<figcaption>{p.msg.image}</figcaption>
			</figure>
		{/each}
	</div>
</main>

<style>
	main {
		padding: 1rem;
	}
	.grid {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
		gap: 1rem;
	}
	figure {
		margin: 0;
	}
	.photo {
		position: relative;
		container-type: inline-size;
	}
	.photo img {
		display: block;
		width: 100%;
	}
	figcaption {
		font-size: 0.75rem;
	}
</style>
