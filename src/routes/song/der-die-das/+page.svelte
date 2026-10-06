<script lang="ts">
	// "Der, die, das" — the A1.1 article rap; the shared song player runs it.
	import SongPlayer from '$lib/components/song/SongPlayer.svelte';
	import { SONGS } from '$lib/domain/songs';

	const song = SONGS.find((s) => s.id === 'der_die_das')!;
</script>

<SongPlayer {song} courseName="German Course A1–C2" />
