// Records every spoken clip of a story episode with the cast voices
// (docs/story_bible.md): the German evidence lines (voicemails, calls,
// Böhm), the number memos per pool variant, and Maya's English narration
// for each panel — one language per clip, one voice per character.
//
//   npm run story-audio                 record every missing ep1 clip
//   npm run story-audio -- --force      re-record everything
//   npm run story-audio -- --dry        list what would be recorded
//
// Files land in static/audio/story/ (shipped, the player streams them).
// Pool-dependent clips are recorded once per variant, suffixed _<index>
// (ep1_voicemail_0.mp3 …), matching the variant index the player draws.
// Narration clips are ep1_narr_<beatId>.mp3; panels whose text contains a
// pool splice get one file per variant too.
//
// Needs GOOGLE_TTS_KEY in .env (same key as gen-audio.mjs / gen-voice-refs).

import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT_DIR = join(root, 'static', 'audio', 'story');
const EPISODE = join(root, 'assets', 'content', 'stories', 'ep1_empty_room.json');

/** The cast (chosen voices, see tool/gen-voice-refs.mjs) + minor NPCs. */
const VOICES = {
	maya: { locale: 'en-US', voice: 'Achernar' },
	jonas: { locale: 'de-DE', voice: 'Puck' },
	lena: { locale: 'de-DE', voice: 'Aoede' },
	boehm: { locale: 'de-DE', voice: 'Charon' },
	// Minor NPC: the Pension receptionist — chirpy, distinct from the cast
	// and from the app's reserved Kore.
	reception: { locale: 'de-DE', voice: 'Leda' }
};

/** Who speaks each scripted (non-narration) audio key, by base name. */
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

loadDotEnv(join(root, '.env'));
const key = process.env.GOOGLE_TTS_KEY;
if (!key && !dry) {
	console.error('GOOGLE_TTS_KEY is not set.');
	process.exit(1);
}

const ep = JSON.parse(readFileSync(EPISODE, 'utf8'));
const pools = ep.pools;

/** story/ep1_x_{pool:name} → [{file, text}] one per variant (or a single clip). */
function clipsFor(base, template) {
	const m = template.match(/\{pool:([a-zA-Z]+)\}/);
	if (!m) return [{ file: `${base}.mp3`, text: template }];
	const name = m[1];
	return pools[name].map((v, i) => ({
		file: `${base}_${i}.mp3`,
		text: template.replaceAll(`{pool:${name}}`, v)
	}));
}

/** The narration text as Maya speaks it. */
const spoken = (text) => text.replaceAll('{user}', 'partner');

const jobs = [];
for (const ch of ep.chapters) {
	for (const b of ch.beats) {
		// Scripted clip referenced by the beat (German evidence, intro/outro).
		if (b.audio) {
			const keyName = b.audio.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');
			const speaker = SPEAKERS[keyName];
			if (speaker) {
				// Intro/outro speak the panel text; everything else its transcript.
				const template = b.transcript ?? spoken(b.text ?? '');
				if (template) for (const c of clipsFor(keyName, template)) jobs.push({ ...c, speaker });
			}
		}
		// Maya's narration for every panel (except ones that ARE her clip).
		if (b.type === 'narrative' && b.text && !(b.audio ?? '').includes('podcast')) {
			for (const c of clipsFor(`ep1_narr_${b.id}`, spoken(b.text))) jobs.push({ ...c, speaker: 'maya' });
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
	process.stdout.write(`${job.file} [${job.speaker}] … `);
	try {
		const v = VOICES[job.speaker];
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
