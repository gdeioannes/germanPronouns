<script lang="ts">
	// "Ich bin Max" — the A1.1 sing-along; the shared song player runs it.
	import SongPlayer from '$lib/components/song/SongPlayer.svelte';
	import { SONGS } from '$lib/domain/songs';

	const song = SONGS.find((s) => s.id === 'ich_bin_max')!;
</script>

<SongPlayer {song} courseName="German Course A1–C2" />
