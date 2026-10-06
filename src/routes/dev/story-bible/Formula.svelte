<script lang="ts">
	// The story formula: the invariants every episode follows so all stories
	// feel like one series. Source of truth: docs/story_bible.md.
	import './bible.css';
	import { img } from './data';
</script>

<main class="bible">
	<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
	<header class="hero">
		<img class="hero-img" src={img('maya_canon_casefile')} alt="Maya at the case board" />
		<div class="hero-text">
			<p class="eyebrow">Foundation · applies to every episode</p>
			<h1>Story Formula</h1>
			<p class="lede">
				Every episode is built from the same skeleton. The mystery changes; the formula doesn't —
				that's what makes them feel like one series.
			</p>
		</div>
	</header>

	<section>
		<h2>The frame</h2>
		<ul class="rules">
			<li><strong>Every episode is an episode of Maya's podcast.</strong> She opens it, narrates it, closes it with a cliffhanger. The learner is her assistant, addressed directly as <code>{'{user}'}</code>.</li>
			<li><strong>One mystery per episode, honestly solvable at the learner's level.</strong> The solution must be readable from the German evidence alone — no clue may require grammar or vocabulary above the episode's half-level.</li>
			<li><strong>The stakes are social, never scary.</strong> Cozy mystery: reputations, secrets, surprises — no violence, no real danger. Failure costs Maya's credibility, not the learner's score.</li>
			<li><strong>Each episode covers one half of a sub-level</strong> and pulls its grammar and vocabulary from those quests only; the next episode continues both the curriculum and the story.</li>
		</ul>
	</section>

	<section>
		<h2>The skeleton</h2>
		<p class="intro">Seven chapters, always the same shape:</p>
		<ul class="rules">
			<li><strong>Intro</strong> — the hook in 2 panels: what's wrong, and Maya recruits the learner.</li>
			<li><strong>Two linear chapters</strong> — first evidence, teaching the episode's core forms; ends naming the lead(s).</li>
			<li><strong>Hub: three leads, any order</strong> — each a different evidence type (something heard, something written/filled-in, something to re-order), each granting a clue.</li>
			<li><strong>Finale</strong> — unlocked by all clues; a live conversation where the learner chooses/builds Maya's German. The mystery resolves, honestly.</li>
			<li><strong>Cliffhanger</strong> — one open question carries into the next episode.</li>
		</ul>
	</section>

	<section>
		<h2>The numbers (gate-tested)</h2>
		<ul class="rules">
			<li>≥ 8 minutes error-free play; every evidence chapter ≥ 3 questions; bigText ≥ 6 blanks; sorts ≥ 6 items.</li>
			<li>Credibility = 3; 5–8 critical beats per episode, concentrated in the dial/build/finale moments. Losing all restarts only the current chapter with the same details; the room number, directions etc. only re-randomize when a playthrough starts from the beginning (Start over / play again after the end).</li>
			<li>Every fact a learner could memorize (numbers, names, cities) comes from a <strong>pool of ≥ 3 variants</strong>, drawn per playthrough, with audio recorded per variant.</li>
			<li>A micro-text from Maya after (nearly) every chapter: one question, spaced review of an earlier chapter.</li>
			<li>Torch-noir lighting at most 2–3 times; door shaft is the default investigation light.</li>
		</ul>
	</section>

	<section>
		<h2>Cohesion between episodes</h2>
		<ul class="rules">
			<li><strong>Same cast rules:</strong> Maya always; recurring characters (Böhm-types) accumulate; episode characters follow the character checklist (block → reference sheet → voice) before first use.</li>
			<li><strong>Same world:</strong> Berlin, the WG, the neighbourhood. New locations join the scenario catalog and may return.</li>
			<li><strong>Same language contract:</strong> English frame / German evidence, one language per clip, one voice per character, Maya never reads German aloud, the app's quiz voice stays reserved.</li>
			<li><strong>Same look:</strong> ligne claire canon + the lighting vocabulary; all prompts built from verbatim blocks.</li>
			<li><strong>Continuity hooks:</strong> each episode plants one detail that a later episode pays off (Lena's "Bald, Maya. Bald."). Keep a running list in the episode docs.</li>
		</ul>
	</section>

	<footer>
		<p>
			Episode JSON schema: <code>docs/story_module_schema.md</code> · episode docs:
			<code>docs/episodes/</code> · written formula: <code>docs/story_bible.md</code>
		</p>
	</footer>
</main>
