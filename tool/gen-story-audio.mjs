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
// Also records the number tasks' lines (assets/content/tasks/*.json): every
// {who, audio, de} line, under the task's id — npm run story-audio -- call_after_party.
//
// A task line with a `style` (how it is acted: "groggy, just woken up") is
// recorded with Gemini TTS instead, which performs the direction, in the same
// cast voice. Each such clip is transcribed back and re-recorded if the
// digits it says are not the ones in the text. Needs GEMINI_API_KEY.
//
// Needs GOOGLE_TTS_KEY in .env (same key as gen-audio.mjs / gen-voice-refs).

import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import { Mp3Encoder } from '@breezystack/lamejs';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT_DIR = join(root, 'static', 'audio', 'story');
const STORIES = join(root, 'assets', 'content', 'stories');
const TASKS = join(root, 'assets', 'content', 'tasks');

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
	announcer: { locale: 'de-DE', voice: 'Schedar' },
	// Number task "Call Kim after the party". Kim is deliberately neither he
	// nor she: the script never says, and the voice sits mid-range.
	kim: { locale: 'de-DE', voice: 'Pulcherrima' },
	tom: { locale: 'de-DE', voice: 'Fenrir' },
	empfang: { locale: 'de-DE', voice: 'Callirrhoe' },
	oma: { locale: 'de-DE', voice: 'Gacrux' },
	pizza: { locale: 'de-DE', voice: 'Algenib' },
	praxis: { locale: 'de-DE', voice: 'Erinome' },
	fitness: { locale: 'de-DE', voice: 'Laomedeia' },
	taxi: { locale: 'de-DE', voice: 'Orus' },
	// Number task "Order the round" (the U-Bahn task reuses the announcer).
	freund: { locale: 'de-DE', voice: 'Umbriel' },
	barkeeper: { locale: 'de-DE', voice: 'Sadaltager' }
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
const geminiKey = process.env.GEMINI_API_KEY;
/** The acting voice model, and the one that listens back. */
// Not gemini-3.8-flash-tts: it reads the direction aloud ("A giggly person…")
// instead of acting it. The 2.5 TTS models are trained on "Say …: <line>".
const GEMINI_TTS = 'gemini-2.5-pro-preview-tts';
const GEMINI_CHECK = 'gemini-3.8-flash';
/** Spoken digits, for checking an acted clip says the right number. */
const lowerFirst = (s) => s.charAt(0).toLowerCase() + s.slice(1);
/** Words, with a run of numerals counted per digit ("0176" and "null, eins, sieben, sechs" alike). */
const wordCount = (t) => (t.match(/\d|[A-Za-zÄÖÜäöüß']+/g) ?? []).length;
const DIGITS = ['null', 'eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun'];
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

// The number tasks: every voiced line, wherever it sits in the task file.
if (existsSync(TASKS)) {
	for (const file of readdirSync(TASKS).filter((f) => f.endsWith('.json'))) {
		const task = JSON.parse(readFileSync(join(TASKS, file), 'utf8'));
		if (only.size && !only.has(task.id)) continue;
		const visit = (node) => {
			if (Array.isArray(node)) return node.forEach(visit);
			if (!node || typeof node !== 'object') return;
			if (node.who && node.audio && node.de)
				jobs.push({ file: `${node.audio}.mp3`, text: node.de, speaker: node.who, style: node.style });
			Object.values(node).forEach(visit);
		};
		visit(task);
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
	process.stdout.write(`${job.file} [${job.speaker}${job.style ? ', acted' : ''}] … `);
	if (job.style) {
		try {
			writeFileSync(file, await acted(job, v));
			made++;
			console.log('ok');
		} catch (e) {
			console.log(`FAILED: ${e.message}`);
		}
		continue;
	}
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

/**
 * Gemini TTS with an acting direction. The direction goes before the line and
 * is performed, not read; the clip is checked by transcribing it back, since a
 * phone number with one digit wrong would teach the wrong number.
 */
async function acted(job, v) {
	if (!geminiKey) throw new Error('GEMINI_API_KEY is not set');
	let heard = '';
	for (let attempt = 1; attempt <= 3; attempt++) {
		const json = await gemini(GEMINI_TTS, {
			contents: [{ parts: [{ text: `Say this in German, acted as ${lowerFirst(job.style)}

${job.text}` }] }],
			generationConfig: {
				responseModalities: ['AUDIO'],
				speechConfig: { voiceConfig: { prebuiltVoiceConfig: { voiceName: v.voice } } }
			}
		});
		const data = json.candidates?.[0]?.content?.parts?.find((p) => p.inlineData?.data)?.inlineData.data;
		if (!data) throw new Error('no audio in response');
		const raw = Buffer.from(data, 'base64');
		const pcm = raw.toString('ascii', 0, 4) === 'RIFF' ? raw.subarray(44) : raw;
		const check = await gemini(GEMINI_CHECK, {
			contents: [
				{
					parts: [
						{ inlineData: { mimeType: 'audio/wav', data: wav(pcm).toString('base64') } },
						{ text: 'Transcribe this German audio word for word. Write every number as German words. Answer with the transcript only.' }
					]
				}
			]
		});
		heard = (check.candidates?.[0]?.content?.parts ?? []).map((p) => p.text ?? '').join('').trim();
		// Reject a take that says more than the line (the direction read out) or,
		// for a line with a phone number, different digits.
		const extra = wordCount(heard) / wordCount(job.text);
		const phone = digitsIn(job.text).length >= 4;
		if (extra <= 1.35 && (!phone || digitsIn(heard) === digitsIn(job.text))) return mp3(pcm);
		process.stdout.write(`(retake ${attempt}: heard "${heard.slice(0, 50)}…") `);
		await new Promise((r) => setTimeout(r, 6500));
	}
	throw new Error(`digits never matched; last heard: ${heard}`);
}

/** The single digits a text says, in order, as words or numerals ("null, eins" and "01" alike). */
function digitsIn(text) {
	return (text.toLowerCase().match(/[a-zäöüß]+|\d/g) ?? [])
		.map((w) => (/\d/.test(w) ? w : DIGITS.indexOf(w) >= 0 ? String(DIGITS.indexOf(w)) : ''))
		.join('');
}

async function gemini(model, body) {
	for (let attempt = 0; ; attempt++) {
		const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`, {
			method: 'POST',
			headers: { 'content-type': 'application/json', 'x-goog-api-key': geminiKey },
			body: JSON.stringify(body)
		});
		if (res.status === 429 && attempt < 4) {
			await new Promise((r) => setTimeout(r, 15000));
			continue;
		}
		if (!res.ok) throw new Error(`${model} ${res.status} ${(await res.text()).slice(0, 160)}`);
		return res.json();
	}
}

/** Gemini answers 24 kHz 16-bit mono PCM. */
function wav(pcm, rate = 24000) {
	const h = Buffer.alloc(44);
	h.write('RIFF', 0);
	h.writeUInt32LE(36 + pcm.length, 4);
	h.write('WAVE', 8);
	h.write('fmt ', 12);
	h.writeUInt32LE(16, 16);
	h.writeUInt16LE(1, 20);
	h.writeUInt16LE(1, 22);
	h.writeUInt32LE(rate, 24);
	h.writeUInt32LE(rate * 2, 28);
	h.writeUInt16LE(2, 32);
	h.writeUInt16LE(16, 34);
	h.write('data', 36);
	h.writeUInt32LE(pcm.length, 40);
	return Buffer.concat([h, pcm]);
}

function mp3(pcm, rate = 24000) {
	const samples = new Int16Array(pcm.buffer, pcm.byteOffset, Math.floor(pcm.length / 2));
	const encoder = new Mp3Encoder(1, rate, 64);
	const chunks = [];
	for (let i = 0; i < samples.length; i += 1152) {
		const out = encoder.encodeBuffer(samples.subarray(i, i + 1152));
		if (out.length) chunks.push(Buffer.from(out));
	}
	const end = encoder.flush();
	if (end.length) chunks.push(Buffer.from(end));
	return Buffer.concat(chunks);
}

function loadDotEnv(path) {
	if (!existsSync(path)) return;
	for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
		const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
		if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
	}
}
