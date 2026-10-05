// Records every spoken clip of the story episodes with the cast voices
// (docs/story_bible.md): the German evidence lines (voicemails, calls,
// dialogue lines, announcements), per pool variant, and Maya's English
// narration for each panel — one language per clip, one voice per character.
//
//   npm run story-audio                    record every missing clip, all episodes
//   npm run story-audio -- ep0_lost_in_berlin   only this episode
//   npm run story-audio -- --force         re-record everything
//   npm run story-audio -- --dry           list what would be recorded
//
// Files land in static/audio/story/ (shipped, the player streams them).
// Pool-dependent clips are recorded once per variant, suffixed _<index>
// (ep1_voicemail_0.mp3 …), matching the variant index the player draws;
// every pool in the text takes that same index (pools of one length are
// drawn together). Narration clips are <ep>_narr_<beatId>.mp3, e.g.
// ep1_narr_i2.mp3; panels whose text contains a pool splice get one file
// per variant too. Dialogue lines are voiced by their `who`.
//
// Needs GOOGLE_TTS_KEY in .env (same key as gen-audio.mjs / gen-voice-refs).

import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT_DIR = join(root, 'static', 'audio', 'story');
const STORIES = join(root, 'assets', 'content', 'stories');

/** The cast (chosen voices, see tool/gen-voice-refs.mjs) + minor NPCs. */
const VOICES = {
	maya: { locale: 'en-US', voice: 'Achernar' },
	jonas: { locale: 'de-DE', voice: 'Puck' },
	lena: { locale: 'de-DE', voice: 'Aoede' },
	boehm: { locale: 'de-DE', voice: 'Charon' },
	// Minor NPC: the Pension receptionist — chirpy, distinct from the cast
	// and from the app's reserved Kore.
	reception: { locale: 'de-DE', voice: 'Leda' },
	// Episode 0: the passer-by, the baker, a friendly stranger, the U-Bahn.
	passantin: { locale: 'de-DE', voice: 'Zephyr' },
	baeckerin: { locale: 'de-DE', voice: 'Sulafat' },
	stranger: { locale: 'de-DE', voice: 'Achird' },
	announcer: { locale: 'de-DE', voice: 'Schedar' }
};

/** Who speaks each scripted beat-level audio key (dialogue lines say it themselves). */
const SPEAKERS = {
	ep1_podcast_intro: 'maya',
	ep1_podcast_outro: 'maya',
	ep1_voicemail: 'lena',
	ep1_boehm_complaint: 'boehm',
	ep1_number: 'jonas',
	ep1_pension: 'reception',
	ep1_lena_greet: 'lena',
	ep1_lena_frage: 'lena'
};

const args = process.argv.slice(2);
const force = args.includes('--force');
const dry = args.includes('--dry');
const only = new Set(args.filter((a) => !a.startsWith('--')));

loadDotEnv(join(root, '.env'));
const key = process.env.GOOGLE_TTS_KEY;
if (!key && !dry) {
	console.error('GOOGLE_TTS_KEY is not set.');
	process.exit(1);
}

/** The narration text as Maya speaks it. */
const spoken = (text) => text.replaceAll('{user}', 'partner');

const jobs = [];
for (const file of readdirSync(STORIES).filter((f) => f.endsWith('.json'))) {
	const ep = JSON.parse(readFileSync(join(STORIES, file), 'utf8'));
	if (only.size && !only.has(ep.id)) continue;
	const prefix = ep.id.split('_')[0];
	const pools = ep.pools;

	/** story/x_{pool:name} → [{file, text}] one per variant (or a single clip). */
	function clipsFor(base, template, keyHint = template) {
		const m = keyHint.match(/\{pool:([a-zA-Z]+)\}/) ?? template.match(/\{pool:([a-zA-Z]+)\}/);
		const fill = (i) =>
			template.replace(/\{pool:([a-zA-Z]+)\}/g, (_, name) => pools[name][i % pools[name].length]);
		if (!m) return [{ file: `${base}.mp3`, text: template }];
		return pools[m[1]].map((_, i) => ({ file: `${base}_${i}.mp3`, text: fill(i) }));
	}
	const baseOf = (k) => k.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');

	for (const ch of ep.chapters) {
		for (const b of ch.beats) {
			// Scripted clip referenced by the beat (German evidence, intro/outro,
			// announcements): speaker from the beat or the SPEAKERS table.
			if (b.audio) {
				const keyName = baseOf(b.audio);
				const speaker = b.speaker ?? SPEAKERS[keyName];
				if (speaker) {
					// Intro/outro speak the panel text; everything else its transcript.
					const template = b.transcript ?? spoken(b.text ?? '');
					if (template) for (const c of clipsFor(keyName, template, b.audio)) jobs.push({ ...c, speaker });
				}
			}
			// A U-Bahn ride's near-miss stops: announced like the real ones.
			if (b.kind === 'stops')
				for (const x of b.extraStops ?? [])
					jobs.push({ file: `${baseOf(x.audio)}.mp3`, text: `Nächster Halt: ${x.name}.`, speaker: b.speaker });
			// Dialogue: every voiced line, in its character's voice.
			if (b.kind === 'dialogue')
				for (const l of b.lines)
					if (l.audio && l.de)
						for (const c of clipsFor(baseOf(l.audio), l.de, l.audio)) jobs.push({ ...c, speaker: l.who });
			// Maya's narration for every panel (except ones that ARE her clip).
			if (b.type === 'narrative' && b.text && !(b.audio ?? '').includes('podcast')) {
				for (const c of clipsFor(`${prefix}_narr_${b.id}`, spoken(b.text))) jobs.push({ ...c, speaker: 'maya' });
			}
		}
	}
}

mkdirSync(OUT_DIR, { recursive: true });
let made = 0;
let skipped = 0;
for (const job of jobs) {
	const file = join(OUT_DIR, job.file);
	if (existsSync(file) && !force) {
		skipped++;
		continue;
	}
	if (dry) {
		console.log(`${job.file}  [${job.speaker}]  ${job.text.slice(0, 70)}`);
		continue;
	}
	const v = VOICES[job.speaker];
	if (!v) {
		console.log(`${job.file}: no voice cast for "${job.speaker}" — skipped`);
		continue;
	}
	process.stdout.write(`${job.file} [${job.speaker}] … `);
	try {
		const res = await fetch('https://texttospeech.googleapis.com/v1/text:synthesize', {
			method: 'POST',
			headers: { 'content-type': 'application/json', 'x-goog-api-key': key },
			body: JSON.stringify({
				input: { text: job.text },
				voice: { languageCode: v.locale, name: `${v.locale}-Chirp3-HD-${v.voice}` },
				audioConfig: { audioEncoding: 'MP3' }
			})
		});
		if (!res.ok) throw new Error(`${res.status} ${(await res.text()).slice(0, 200)}`);
		const { audioContent } = await res.json();
		if (!audioContent) throw new Error('no audio in response');
		writeFileSync(file, Buffer.from(audioContent, 'base64'));
		made++;
		console.log('ok');
	} catch (e) {
		console.log(`FAILED: ${e.message}`);
	}
	await new Promise((r) => setTimeout(r, 400));
}
console.log(`\n${made} recorded, ${skipped} already present (${jobs.length} total), in ${OUT_DIR}`);

function loadDotEnv(path) {
	if (!existsSync(path)) return;
	for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
		const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
		if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
	}
}
