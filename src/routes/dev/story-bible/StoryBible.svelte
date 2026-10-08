<script lang="ts">
	// Hub of the dev-only story bible: links to the style guide, the
	// scenarios page and one thematic page per character, plus the
	// cross-cutting language rules. Source of truth: docs/story_bible.md.
	import './bible.css';
	import { img, clip, cast } from './data';

	// One shared player so card voices never overlap; the button sits inside
	// the card link, so it swallows the click instead of navigating.
	let playingId = $state<string | null>(null);
	let player: HTMLAudioElement | null = null;
	function playVoice(e: MouseEvent, id: string) {
		e.preventDefault();
		e.stopPropagation();
		if (playingId === id) {
			player?.pause();
			playingId = null;
			return;
		}
		player?.pause();
		player = new Audio(clip(id));
		player.onended = () => (playingId = null);
		playingId = id;
		player.play().catch(() => (playingId = null));
	}

</script>

<main class="bible">
	<header class="hero">
		<img class="hero-img" src={img('maya_canon_casefile')} alt="Maya at her case board" />
		<div class="hero-text">
			<p class="eyebrow">Gamified modules · internal reference</p>
			<h1>Story Bible</h1>
			<p class="lede">
				The general foundation for every gamified quiz module. Episode material lives in
				<code>docs/episodes/</code>; written source of truth is <code>docs/story_bible.md</code>.
				Dev builds only.
			</p>
		</div>
	</header>

	<section>
		<h2>Foundations</h2>
		<div class="grid two">
			<a class="nav-card" href="/dev/story-bible/style">
				<img src={img('light_ref_doorshaft')} alt="Style guide" loading="lazy" />
				<span class="nav-body">
					<strong>Style &amp; colour</strong>
					<span>The ligne claire canon, what each colour is for, and the four-light vocabulary.</span>
				</span>
			</a>
			<a class="nav-card" href="/dev/story-bible/formula">
				<img src={img('maya_canon_casefile')} alt="Story formula" loading="lazy" />
				<span class="nav-body">
					<strong>Story formula</strong>
					<span>The skeleton, numbers and cohesion rules every episode is built from.</span>
				</span>
			</a>
			<a class="nav-card" href="/dev/story-bible/scenarios">
				<img src={img('room_ref_wide')} alt="Scenarios" loading="lazy" />
				<span class="nav-body">
					<strong>Backgrounds &amp; scenarios</strong>
					<span>How locations are defined, lit and rendered; the scenario checklist.</span>
				</span>
			</a>
		</div>
	</section>

	<section>
		<h2>Characters</h2>
		<div class="grid four">
			{#each cast as c (c.id)}
				<a class="nav-card tall" href="/dev/story-bible/cast/{c.id}" style:--cast-accent={c.accent}>
					<span class="card-media">
						<img src={img(c.portrait)} alt={c.name} loading="lazy" />
						{#if c.voices.length}
							<button
								class="voice-btn"
								class:playing={playingId === c.voices[0].id}
								title={`Hear ${c.name}`}
								onclick={(e) => playVoice(e, c.voices[0].id)}
							>
								{playingId === c.voices[0].id ? '◼' : '▶'}
							</button>
						{/if}
					</span>
					<span class="nav-body">
						<span class="nav-group">{c.group}</span>
						<strong>{c.name}</strong>
						<span>{c.tagline}</span>
					</span>
				</a>
			{/each}
		</div>
	</section>

	<section>
		<h2>Episodes</h2>
		<div class="grid two">
			<a class="nav-card" href="/dev/story-bible/episode?ep=ep0_lost_in_berlin">
				<img src="/img/story/ep0_arrivals.webp" alt="Episode 0 script" loading="lazy" />
				<span class="nav-body">
					<span class="nav-group">de_cert_a1 · A1.1 prologue · zero German</span>
					<strong>Episode 0 — Lost in Berlin</strong>
					<span>Maya's first day: airport to doorbell. Map, U-Bahn, live dialogues, tap-in-the-scene.</span>
				</span>
			</a>
			<a class="nav-card" href="/dev/story-bible/episode?ep=ep1_empty_room">
				<img src={img('room_ref_close')} alt="Episode 1 script" loading="lazy" />
				<span class="nav-body">
					<span class="nav-group">de_cert_a1 · A1.1 first half</span>
					<strong>Episode 1 — The Empty Room</strong>
					<span>The full script: every beat, quiz, pool and clue, readable like a screenplay.</span>
				</span>
			</a>
			<a class="nav-card" href="/dev/story-bible/episode?ep=ep2_secret_room">
				<img src="/img/story/ep2_courtyard_night.webp" alt="Episode 2 script" loading="lazy" />
				<span class="nav-body">
					<span class="nav-group">de_cert_a1 · A1.1 finale · all of the level</span>
					<strong>Episode 2 — The Secret Room</strong>
					<span>Parcel, phone call, Oma's kitchen, the key, the crates, the night visit — every A1.1 topic put to work.</span>
				</span>
			</a>
		</div>
		<p class="intro" style="margin-top:0.75rem">
			Review loop for every episode: <code>npm run story-review -- &lt;id&gt;</code> +
			<code>node tool/playtest-story.mjs &lt;id&gt;</code> — see <code>docs/story_review.md</code>.
		</p>
	</section>

	<section>
		<h2>Marketing</h2>
		<div class="grid two">
			<a class="nav-card" href="/dev/story-bible/instagram">
				<img src={img('maya_canon_casefile')} alt="Instagram ad" loading="lazy" />
				<span class="nav-body">
					<strong>Instagram ad</strong>
					<span>The three-slide carousel promoting story mode, the idea behind each slide, and the regeneration recipe.</span>
				</span>
			</a>
		</div>
	</section>

	<section>
		<h2>Mixing English and German</h2>
		<ul class="rules">
			<li><strong>English is the frame, German is the evidence.</strong> Maya narrates, jokes and asks in English; German appears only as material to decode — notes, voicemails, forms, chats, overheard calls.</li>
			<li><strong>One language per audio clip, one voice per character.</strong> Never mix languages inside a clip; scenes interleave clips. The learner always knows by ear whether this is story or evidence.</li>
			<li><strong>Maya never reads German aloud.</strong> Her mangled German is a text-only gag; every spoken German word the learner hears is correct, native-voiced and safe to imitate.</li>
			<li><strong>In text</strong>, German inside English prose is visually marked (GermanText styling) and tappable — spoken by the German character's voice, never hers.</li>
			<li><strong>The app's quiz voice (Kore, de-DE) is reserved.</strong> Characters never use it: quiz audio sounds like the app, story audio sounds like people.</li>
		</ul>
	</section>

	<footer>
		<p>
			Images: <code>npm run images -- --story</code> · Voices: <code>npm run voices</code> ·
			Episode schema: <code>docs/story_module_schema.md</code>
		</p>
	</footer>
</main>

<style>
	.nav-card {
		display: grid;
		grid-template-columns: 9rem 1fr;
		gap: 1rem;
		align-items: center;
		background: var(--surface);
		border: 1px solid var(--line);
		border-left: 4px solid var(--cast-accent, var(--accent));
		border-radius: var(--radius-sm);
		overflow: hidden;
		text-decoration: none;
		color: inherit;
		transition: transform 120ms ease, box-shadow 120ms ease;
	}
	.nav-card:hover {
		transform: translateY(-2px);
		box-shadow: 0 6px 18px rgb(0 0 0 / 0.08);
	}
	.nav-card img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		display: block;
	}
	.nav-card.tall {
		grid-template-columns: 1fr;
		align-items: start;
	}
	.nav-card.tall img {
		aspect-ratio: 1;
	}
	.card-media {
		position: relative;
		display: block;
	}
	.voice-btn {
		position: absolute;
		right: 0.6rem;
		bottom: 0.6rem;
		width: 2.4rem;
		height: 2.4rem;
		border-radius: 50%;
		border: none;
		background: var(--cast-accent, var(--accent));
		color: var(--paper);
		font-size: 0.9rem;
		cursor: pointer;
		box-shadow: 0 2px 8px rgb(0 0 0 / 0.25);
		display: grid;
		place-items: center;
		transition: transform 120ms ease;
	}
	.voice-btn:hover {
		transform: scale(1.1);
	}
	.voice-btn.playing {
		animation: voice-pulse 1s ease-in-out infinite;
	}
	@keyframes voice-pulse {
		50% {
			transform: scale(1.12);
		}
	}
	.nav-body {
		display: grid;
		gap: 0.2rem;
		padding: 0.75rem 1rem 0.9rem 0;
		font-size: var(--step--1);
	}
	.nav-card.tall .nav-body {
		padding: 0 0.9rem 0.9rem;
	}
	.nav-body strong {
		font-size: var(--step-0);
		color: var(--heading);
	}
	.nav-body > span:not(.nav-group) {
		color: var(--ink-muted);
	}
	.nav-group {
		font-size: 0.72rem;
		text-transform: uppercase;
		letter-spacing: 0.08em;
		color: var(--cast-accent, var(--accent));
		margin-top: 0.6rem;
	}
</style>
