<script lang="ts">
	// "Wie bitte?" — the A1.1 asking-for-help rap; the shared song player runs it.
	import SongPlayer from '$lib/components/song/SongPlayer.svelte';
	import { SONGS } from '$lib/domain/songs';

	const song = SONGS.find((s) => s.id === 'wie_bitte_max')!;
</script>

<SongPlayer {song} courseName="German Course A1–C2" />
