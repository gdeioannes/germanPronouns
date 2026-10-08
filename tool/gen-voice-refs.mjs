// Records character voice references for the story modules ("Maya mysteries"),
// so casting is an audible decision, kept on disk, and every future episode
// reuses the same named voice per character.
//
//   npm run voices            record every missing reference clip
//   npm run voices -- --force re-record everything
//   npm run voices -- maya    only this character's candidates
//
// One MP3 per (character, voice) lands in src/lib/assets/story/voices/ —
// dev-only assets, shown on /dev/story-bible, never shipped in the build.
// The app's quiz voice is Kore (de-DE); characters must NOT reuse it, so a
// learner always hears instantly whether a clip is "the app" or "the story".
//
// Casting rules live in docs/story_bible.md. Chosen voices get `chosen: true`
// here once the user decides; candidates stay recorded as the audition trail.
//
// Needs GOOGLE_TTS_KEY in .env (same key as gen-audio.mjs).

import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT_DIR = join(root, 'src', 'lib', 'assets', 'story', 'voices');

/**
 * The audition sheet. Every entry is one reference clip: a character, a
 * Chirp 3 HD voice, and that character's signature line. Maya speaks English
 * (en-GB — she's British-American); German speakers use de-DE voices.
 */
const AUDITIONS = [
	// — Maya: cast 2026-10-02 after four audition rounds (en-GB Leda/Aoede/
	// Zephyr, livelier en-GB set, en-US set, soft-young en-US set) — the
	// en-GB voices read too old; Achernar (en-US) won. She is American.
	{ character: 'maya', locale: 'en-US', voice: 'Achernar', chosen: true,
		line: "Listeners — HUGE update. The wardrobe is empty, the note is torn, and somebody called Lena just phoned MY flat. This is officially the best worst day of my life. Episode one starts... NOW." },

	// — Jonas: friendly, a little shy, around thirty. German.
	{ character: 'jonas', locale: 'de-DE', voice: 'Puck', chosen: true,
		line: 'Hallo! Ähm... hier ist Jonas. Ich bin nicht weg. Also... doch. Es ist kompliziert. Bitte nicht böse sein.' },

	// — Lena: composed, hard to read. German.
	{ character: 'lena', locale: 'de-DE', voice: 'Leda', chosen: false,
		line: 'Hallo, hier ist Lena. Ich bin im Moment nicht da. Bitte hinterlassen Sie eine Nachricht.' },
	{ character: 'lena', locale: 'de-DE', voice: 'Aoede', chosen: true,
		line: 'Hallo, hier ist Lena. Ich bin im Moment nicht da. Bitte hinterlassen Sie eine Nachricht.' },

	// — Hausmeister Böhm: gruff, unimpressed. German.
	{ character: 'boehm', locale: 'de-DE', voice: 'Charon', chosen: true,
		line: 'Ja, was ist? Ich habe keine Zeit. Der Müll kommt am Dienstag raus, nicht am Montag.' },
	{ character: 'boehm', locale: 'de-DE', voice: 'Orus', chosen: false,
		line: 'Ja, was ist? Ich habe keine Zeit. Der Müll kommt am Dienstag raus, nicht am Montag.' },

	// — Episode 0 (2026-10-05): cast from the Chirp 3 HD voice descriptions;
	// listen on /dev/story-bible and recast here if one sounds wrong.
	{ character: 'passantin', locale: 'de-DE', voice: 'Zephyr', chosen: true,
		line: 'Die Lindenstraße? Ach, das ist ganz einfach: links, dann geradeaus!' },
	{ character: 'baeckerin', locale: 'de-DE', voice: 'Sulafat', chosen: true,
		line: 'Guten Tag! Bitte schön? Eine Brezel? Gerne!' },
	{ character: 'stranger', locale: 'de-DE', voice: 'Achird', chosen: true,
		line: 'Guten Morgen! Willkommen in Berlin!' },
	{ character: 'announcer', locale: 'de-DE', voice: 'Schedar', chosen: true,
		line: 'Nächster Halt: Rosenplatz.' },

	// — Episode 2 (2026-10-08). Oma Hartmann: Gacrux is already the "oma" of the
	// number tasks and sounds the part; two alternatives recorded for the ear.
	{ character: 'oma', locale: 'de-DE', voice: 'Gacrux', chosen: true,
		line: 'Und Sie sind…? Aha. Sie fragen viel. Gut. Sie können helfen. Kommen Sie — in die Küche!' },
	{ character: 'oma', locale: 'de-DE', voice: 'Despina', chosen: false,
		line: 'Und Sie sind…? Aha. Sie fragen viel. Gut. Sie können helfen. Kommen Sie — in die Küche!' },
	{ character: 'oma', locale: 'de-DE', voice: 'Vindemiatrix', chosen: false,
		line: 'Und Sie sind…? Aha. Sie fragen viel. Gut. Sie können helfen. Kommen Sie — in die Küche!' },
	{ character: 'kurier', locale: 'de-DE', voice: 'Rasalgethi', chosen: true,
		line: 'Ein Paket für Jonas Weber. Unterschreiben Sie hier, bitte.' }
];

const args = process.argv.slice(2);
const force = args.includes('--force');
const only = new Set(args.filter((a) => !a.startsWith('--')));

loadDotEnv(join(root, '.env'));
const key = process.env.GOOGLE_TTS_KEY;
if (!key) {
	console.error('GOOGLE_TTS_KEY is not set (same key gen-audio.mjs uses).');
	process.exit(1);
}

mkdirSync(OUT_DIR, { recursive: true });
let made = 0;
let skipped = 0;
for (const a of AUDITIONS) {
	if (only.size && !only.has(a.character)) continue;
	const file = join(OUT_DIR, `${a.character}_${a.voice.toLowerCase()}.mp3`);
	if (existsSync(file) && !force) {
		skipped++;
		continue;
	}
	process.stdout.write(`${a.character} / ${a.voice} … `);
	try {
		const res = await fetch('https://texttospeech.googleapis.com/v1/text:synthesize', {
			method: 'POST',
			headers: { 'content-type': 'application/json', 'x-goog-api-key': key },
			body: JSON.stringify({
				input: { text: a.line },
				voice: { languageCode: a.locale, name: `${a.locale}-Chirp3-HD-${a.voice}` },
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
console.log(`\n${made} recorded, ${skipped} already present, in ${OUT_DIR}`);

function loadDotEnv(path) {
	if (!existsSync(path)) return;
	for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
		const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
		if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
	}
}
