<script lang="ts">
	// Episode 1 — the shared story player (src/lib/components/story/) runs it.
	import StoryPlayer from '$lib/components/story/StoryPlayer.svelte';
	import type { Episode } from '$lib/components/story/types';
	import ep from '$content/stories/ep1_empty_room.json';
</script>

<StoryPlayer
	episode={ep as unknown as Episode}
	path="/story/ep1-empty-room"
	seoTitle="The Empty Room — Story"
	seoDescription="An interactive German mystery: help Maya find her missing flatmate." />
