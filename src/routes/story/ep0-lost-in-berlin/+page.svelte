<script lang="ts">
	// Episode 0, the prologue — the shared story player (src/lib/components/story/) runs it.
	import StoryPlayer from '$lib/components/story/StoryPlayer.svelte';
	import type { Episode } from '$lib/components/story/types';
	import ep from '$content/stories/ep0_lost_in_berlin.json';
</script>

<StoryPlayer
	episode={ep as unknown as Episode}
	path="/story/ep0-lost-in-berlin"
	seoTitle="Lost in Berlin — Story"
	seoDescription="An interactive first German story: help Maya get from the airport to her new flat, with no German at all." />
