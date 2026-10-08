<script lang="ts">
	// Episode 2 — the shared story player (src/lib/components/story/) runs it.
	import StoryPlayer from '$lib/components/story/StoryPlayer.svelte';
	import type { Episode } from '$lib/components/story/types';
	import ep from '$content/stories/ep2_secret_room.json';
</script>

<StoryPlayer
	episode={ep as unknown as Episode}
	path="/story/ep2-secret-room"
	seoTitle="The Secret Room — Story"
	seoDescription="An interactive German mystery for the end of A1.1: a parcel of paint, a phone call, a grandmother's kitchen and a locked door." />
