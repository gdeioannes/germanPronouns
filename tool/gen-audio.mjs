// Pre-records the German the app reads aloud, with Google's Chirp 3 HD voices
// (Cloud Text-to-Speech; Gemini TTS optional), so it plays a natural neural voice instantly and offline instead of asking
// the TTS Worker or the browser voice on every tap.
//
//   npm run audio                     every A1.1 exercise
//   npm run audio -- --level A1.2     another sub-level (repeatable)
//   npm run audio -- --all            the whole app: every level, plus the
//                                     Word Library and the landing demo
//   npm run audio -- --dry            only list what would be recorded
//   npm run audio -- --force          re-record files that already exist
//   npm run audio -- --engine gemini  record with Gemini TTS instead of Chirp 3 HD
//
// Windows PowerShell 5.1 swallows npm's `--`, so there run the flags as
// `node tool/gen-audio.mjs --all` instead.
//
// What to record comes from src/lib/audio/spoken-texts.ts, loaded through the
// project's Vite config, which derives each string with the same function the
// speak button uses. One MP3 per string lands in static/audio/, named by a
// hash of model + voice + text. The manifest — locale → text → file — is split
// into static/audio/manifest/<shard>.json by audioShard(text) (src/lib/audio/
// shard.ts), and RecordedTtsProvider (src/lib/services/speech.ts) fetches only
// the shard of the text it is about to speak.
//
// With --engine gemini each clip is transcribed back and re-recorded when the
// transcript does not match — that model sometimes voices extra words, or
// answers a lone word ("null") instead of reading it; SAY_AS covers those.
//
// Needs GOOGLE_TTS_KEY (Chirp) or GEMINI_API_KEY (Gemini) in .env (see .env.example). The build never calls the
// API; this is an authoring tool like gen-images.

import { createHash } from 'node:crypto';
import { existsSync, mkdirSync, readdirSync, readFileSync, unlinkSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import { Mp3Encoder } from '@breezystack/lamejs';
import { createServer } from 'vite';

const root = fileURLToPath(new URL('..', import.meta.url));
/**
 * The two ways to record. Chirp 3 HD (Cloud Text-to-Speech) is the default:
 * the same voice family as Gemini TTS with production quotas. Gemini TTS
 * allows only 100 requests a day at this project's tier (and 10 a minute),
 * too few for the whole app, and it sometimes answers a lone word instead of
 * reading it — so its clips are transcribed back and checked.
 */
const ENGINES = {
	chirp: {
		id: 'chirp3-hd',
		keyEnv: 'GOOGLE_TTS_KEY',
		keyHelp: 'a Google Cloud API key with the Text-to-Speech API enabled',
		parallel: 4,
		// ~170 a minute: faster trips the Chirp per-minute quota (429s).
		gapMs: 350,
		verify: false,
		synth: callChirp
	},
	gemini: {
		id: 'gemini-3.8-flash-tts',
		keyEnv: 'GEMINI_API_KEY',
		keyHelp: 'a Google AI Studio key (https://aistudio.google.com/apikey)',
		parallel: 2,
		gapMs: 6500,
		verify: true,
		synth: callGemini
	}
};
const VOICE = 'Kore';
/**
 * What to send the engine for a text it will not read as written. The clip
 * is still filed under the original text. Keep the spoken words identical —
 * only casing and punctuation may change.
 */
const SAY_AS = {
	null: 'Null.'
};
const OUT_DIR = join(root, 'static', 'audio');
/** The manifest, split by audioShard(text) into <shard>.json files (src/lib/audio/shard.ts). */
const MANIFEST_DIR = join(OUT_DIR, 'manifest');
/** The single-file manifest from before the split; removed on the next run. */
const LEGACY_MANIFEST = join(OUT_DIR, 'manifest.json');
/** Transcribes a Gemini clip back, to reject one that says something else. */
const CHECK_MODEL = 'gemini-3.8-flash';
/** Transcript vs text, after normalising; below this the clip is re-recorded. */
const MIN_SIMILARITY = 0.85;
const KBPS = 48;
const SAMPLE_RATE = 24000;
/** When the next TTS request may go out (see ttsSlot). */
let nextTtsSlot = 0;

const args = process.argv.slice(2);
const force = args.includes('--force');
const dry = args.includes('--dry');
const all = args.includes('--all');
const levels = args.flatMap((a, i) => (args[i - 1] === '--level' ? [a] : []));
if (!levels.length && !all) levels.push('A1.1');
const engineName = args.flatMap((a, i) => (args[i - 1] === '--engine' ? [a] : []))[0] ?? 'chirp';
const engine = ENGINES[engineName];
if (!engine) {
	console.error(`Unknown --engine ${engineName}; use ${Object.keys(ENGINES).join(' or ')}.`);
	process.exit(1);
}

loadDotEnv(join(root, '.env'));
const key = process.env[engine.keyEnv];
// Chirp also takes a service-account JSON (the path, never the key itself, goes in .env).
const serviceAccount = engineName === 'chirp' && !!process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!key && !serviceAccount && !dry) {
	console.error(`${engine.keyEnv} is not set: add ${engine.keyHelp} to .env (see .env.example).`);
	process.exit(1);
}

const { spoken, audioShard } = await collect();
const texts = spoken.filter((t) => all || (t.level && levels.includes(t.level)));
const chars = texts.reduce((n, t) => n + t.text.length, 0);
console.log(`${texts.length} distinct strings (${chars} characters) in ${all ? 'the whole app' : levels.join(', ')}`);
if (dry) {
	for (const t of texts)
		console.log(`  [${t.level ?? 'app'} ${t.source}] ${t.text.length > 70 ? t.text.slice(0, 70) + '…' : t.text}`);
	process.exit(0);
}

mkdirSync(MANIFEST_DIR, { recursive: true });
// A whole-app run rebuilds the manifest, so texts the app no longer speaks
// (and clips from another engine or voice) drop out and get pruned below.
const manifest = all ? {} : readManifest();

let made = 0;
let skipped = 0;
let failed = 0;
const queue = [...texts];
await Promise.all(Array.from({ length: engine.parallel }, worker));
writeManifest();
if (existsSync(LEGACY_MANIFEST)) unlinkSync(LEGACY_MANIFEST);
console.log(`\n${made} recorded, ${skipped} already present, ${failed} failed, in static/audio/`);
if (all && !failed) prune();
if (failed) process.exitCode = 1;

async function worker() {
	for (let item = queue.shift(); item !== undefined; item = queue.shift()) {
		const { text, locale } = item;
		const files = (manifest[locale] ??= {});
		const file = `${createHash('sha1').update(`${engine.id}|${VOICE}|${locale}|${text}`).digest('hex').slice(0, 16)}.mp3`;
		if (existsSync(join(OUT_DIR, file)) && !force) {
			files[text] = file;
			skipped++;
			continue;
		}
		try {
			const wav = await generate(text, locale);
			const mp3 = encodeMp3(trimSilence(readWav(wav)));
			writeFileSync(join(OUT_DIR, file), mp3);
			files[text] = file;
			// Saved per clip, so an interrupted run keeps what it recorded.
			writeManifest(audioShard(text));
			made++;
			console.log(`ok  ${file} (${Math.round(mp3.length / 1024)} kB)  ${text.slice(0, 50)}`);
		} catch (e) {
			failed++;
			console.log(`FAILED  ${text.slice(0, 50)}: ${e.message}`);
		}
	}
}

/**
 * Every string the app speaks, from the app's own collector, and the app's
 * shard function — both TypeScript, loaded through Vite.
 */
async function collect() {
	const server = await createServer({
		root,
		logLevel: 'error',
		appType: 'custom',
		server: { middlewareMode: true, hmr: false, watch: null }
	});
	try {
		const { spokenTexts } = await server.ssrLoadModule('/src/lib/audio/spoken-texts.ts');
		const { audioShard } = await server.ssrLoadModule('/src/lib/audio/shard.ts');
		return { spoken: await spokenTexts(), audioShard };
	} finally {
		await server.close();
	}
}

/** locale → text → file, merged from every shard (and a pre-split manifest.json). */
function readManifest() {
	const merged = {};
	const add = (part) => {
		for (const [locale, files] of Object.entries(part)) Object.assign((merged[locale] ??= {}), files);
	};
	if (existsSync(LEGACY_MANIFEST)) add(JSON.parse(readFileSync(LEGACY_MANIFEST, 'utf8')));
	for (const name of existsSync(MANIFEST_DIR) ? readdirSync(MANIFEST_DIR) : []) {
		if (name.endsWith('.json')) add(JSON.parse(readFileSync(join(MANIFEST_DIR, name), 'utf8')));
	}
	return merged;
}

/**
 * Writes one shard, or all of them (removing shards left empty). A failed
 * write mid-run (Windows locks a file open in an editor) is not fatal: the
 * final write at the end of the run saves it.
 */
function writeManifest(only) {
	const shards = {};
	for (const [locale, files] of Object.entries(manifest)) {
		for (const [text, file] of Object.entries(files)) {
			const shard = audioShard(text);
			if (only !== undefined && shard !== only) continue;
			((shards[shard] ??= {})[locale] ??= {})[text] = file;
		}
	}
	for (const [shard, part] of Object.entries(shards)) {
		try {
			writeFileSync(join(MANIFEST_DIR, `${shard}.json`), JSON.stringify(sortKeys(part), null, 1) + '\n');
		} catch (e) {
			if (only === undefined) throw e;
		}
	}
	if (only !== undefined) return;
	for (const name of readdirSync(MANIFEST_DIR)) {
		if (name.endsWith('.json') && !(name.slice(0, -5) in shards)) unlinkSync(join(MANIFEST_DIR, name));
	}
}

/** Deletes clips no manifest entry points at — after a whole-app run only. */
function prune() {
	const used = new Set(Object.values(manifest).flatMap((files) => Object.values(files)));
	let removed = 0;
	for (const name of readdirSync(OUT_DIR)) {
		if (name.endsWith('.mp3') && !used.has(name)) {
			unlinkSync(join(OUT_DIR, name));
			removed++;
		}
	}
	if (removed) console.log(`pruned ${removed} clips the app no longer speaks`);
}

/**
 * One WAV buffer for the text. The API occasionally answers without audio or
 * rate-limits, and Gemini sometimes voices something else, so retry.
 */
async function generate(text, locale, attempt = 1) {
	try {
		await ttsSlot();
		const wav = await engine.synth(SAY_AS[text] ?? text, locale);
		// Throws on an empty clip, which Chirp occasionally returns; retry it.
		trimSilence(readWav(wav));
		if (engine.verify) {
			const heard = await transcribe(wav);
			const score = similarity(normalise(heard), normalise(text));
			if (score < MIN_SIMILARITY) throw new Error(`transcript mismatch (${score.toFixed(2)}): "${heard.slice(0, 80)}"`);
		}
		return wav;
	} catch (e) {
		// The daily quota does not come back within a run: stop every worker.
		if (/per_day/.test(e.message)) {
			queue.length = 0;
			throw new Error(`daily quota used up — run again tomorrow (${e.message.match(/retry in (\S+)/i)?.[1] ?? ''})`);
		}
		if (attempt >= 6) throw e;
		// A 429 says how long to wait ("retry in 50.5s", "1m2s"); otherwise back off.
		const hinted = e.message.match(/retry in (?:(\d+)h)?(?:(\d+)m)?([\d.]+)s/i);
		const wait = hinted
			? ((Number(hinted[1] ?? 0) * 60 + Number(hinted[2] ?? 0)) * 60 + Number(hinted[3])) * 1000 + 1000
			: 3000 * attempt;
		console.log(`retry ${attempt} in ${Math.round(wait / 1000)}s: ${e.message.split('\n')[0].slice(0, 90)}`);
		await new Promise((r) => setTimeout(r, wait));
		return generate(text, locale, attempt + 1);
	}
}

/** Resolves when the next TTS request may go out, spacing all workers' calls. */
function ttsSlot() {
	const now = Date.now();
	const at = Math.max(now, nextTtsSlot);
	nextTtsSlot = at + engine.gapMs;
	return new Promise((r) => setTimeout(r, at - now));
}

/**
 * A bearer token from the service-account JSON at GOOGLE_APPLICATION_CREDENTIALS
 * (a signed JWT exchanged at the token endpoint), cached until near expiry.
 */
let cachedToken = null;
async function serviceAccountToken() {
	if (cachedToken && cachedToken.until > Date.now()) return cachedToken.promise;
	const sa = JSON.parse(readFileSync(process.env.GOOGLE_APPLICATION_CREDENTIALS, 'utf8'));
	const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
	const now = Math.floor(Date.now() / 1000);
	const unsigned =
		b64({ alg: 'RS256', typ: 'JWT' }) +
		'.' +
		b64({
			iss: sa.client_email,
			scope: 'https://www.googleapis.com/auth/cloud-platform',
			aud: sa.token_uri,
			iat: now,
			exp: now + 3600
		});
	const jwt = `${unsigned}.${createSign('RSA-SHA256').update(unsigned).sign(sa.private_key, 'base64url')}`;
	const promise = fetch(sa.token_uri, {
		method: 'POST',
		headers: { 'content-type': 'application/x-www-form-urlencoded' },
		body: new URLSearchParams({ grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer', assertion: jwt })
	}).then(async (res) => {
		if (!res.ok) throw new Error(`service-account token: ${res.status} ${await errorMessage(res)}`);
		return (await res.json()).access_token;
	});
	cachedToken = { promise, until: Date.now() + 50 * 60 * 1000 };
	promise.catch(() => (cachedToken = null));
	return promise;
}

/** Cloud Text-to-Speech, Chirp 3 HD: 24 kHz 16-bit WAV. */
async function callChirp(text, locale) {
	const auth = key ? { 'x-goog-api-key': key } : { authorization: `Bearer ${await serviceAccountToken()}` };
	const res = await fetch('https://texttospeech.googleapis.com/v1/text:synthesize', {
		method: 'POST',
		headers: { 'content-type': 'application/json', ...auth },
		body: JSON.stringify({
			input: { text },
			voice: { languageCode: locale, name: `${locale}-Chirp3-HD-${VOICE}` },
			audioConfig: { audioEncoding: 'LINEAR16', sampleRateHertz: SAMPLE_RATE }
		})
	});
	if (!res.ok) throw new Error(`${res.status} ${await errorMessage(res)}`);
	const { audioContent } = await res.json();
	if (!audioContent) throw new Error('no audio in response');
	const bytes = Buffer.from(audioContent, 'base64');
	return bytes.toString('ascii', 0, 4) === 'RIFF' ? bytes : pcmToWav(bytes, SAMPLE_RATE);
}

/** Gemini TTS: 24 kHz WAV (or bare PCM from older models). */
async function callGemini(text) {
	// Only the text: this model voices any instruction in the prompt too
	// ("Say calmly: …" is read aloud), and it rejects a systemInstruction.
	const json = await gemini(engine.id, {
		contents: [{ parts: [{ text }] }],
		generationConfig: {
			responseModalities: ['AUDIO'],
			speechConfig: { voiceConfig: { prebuiltVoiceConfig: { voiceName: VOICE } } }
		}
	});
	const part = (json.candidates?.[0]?.content?.parts ?? []).find((p) => p.inlineData?.data);
	if (!part) {
		const reason = json.candidates?.[0]?.finishReason ?? json.promptFeedback?.blockReason;
		throw new Error(`no audio in response (${reason ?? 'unknown reason'})`);
	}
	const bytes = Buffer.from(part.inlineData.data, 'base64');
	// Older TTS models answer headerless 24 kHz PCM; wrap it so readWav takes both.
	return bytes.toString('ascii', 0, 4) === 'RIFF' ? bytes : pcmToWav(bytes, SAMPLE_RATE);
}

/** What a listener hears in the clip, so a voiced extra or an English "null" is caught. */
async function transcribe(wav) {
	const json = await gemini(CHECK_MODEL, {
		contents: [
			{
				parts: [
					{ inlineData: { mimeType: 'audio/wav', data: wav.toString('base64') } },
					{
						text:
							'Transcribe this German audio exactly, word for word, in German spelling. ' +
							'Write numbers as words. If any part is not German, transcribe it as heard. ' +
							'Answer with the transcript only.'
					}
				]
			}
		]
	});
	return (json.candidates?.[0]?.content?.parts ?? []).map((p) => p.text ?? '').join('').trim();
}

async function gemini(model, body) {
	const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`, {
		method: 'POST',
		headers: { 'content-type': 'application/json', 'x-goog-api-key': key },
		body: JSON.stringify(body)
	});
	if (!res.ok) throw new Error(`${res.status} ${await errorMessage(res)}`);
	return res.json();
}

/** A Google API error's message, or the raw body when it is not JSON. */
async function errorMessage(res) {
	const body = await res.text();
	try {
		return JSON.parse(body).error?.message ?? body.slice(0, 300);
	} catch {
		return body.slice(0, 300);
	}
}

/** Lower case, letters and digits only, so punctuation and casing never count. */
function normalise(s) {
	return s
		.toLowerCase()
		.normalize('NFC')
		.replace(/[^\p{L}\p{N}]+/gu, ' ')
		.trim();
}

/** 1 − edit distance / length: 1 is identical. */
function similarity(a, b) {
	if (!a.length && !b.length) return 1;
	let prev = Array.from({ length: b.length + 1 }, (_, j) => j);
	for (let i = 1; i <= a.length; i++) {
		const row = [i];
		for (let j = 1; j <= b.length; j++) {
			row[j] = Math.min(prev[j] + 1, row[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
		}
		prev = row;
	}
	return 1 - prev[b.length] / Math.max(a.length, b.length);
}

function pcmToWav(pcm, rate) {
	const h = Buffer.alloc(44);
	h.write('RIFF', 0);
	h.writeUInt32LE(36 + pcm.length, 4);
	h.write('WAVEfmt ', 8);
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

/** 16-bit mono PCM WAV → { rate, samples }. */
function readWav(buf) {
	let rate = 24000;
	for (let at = 12; at + 8 <= buf.length; ) {
		const id = buf.toString('ascii', at, at + 4);
		const size = buf.readUInt32LE(at + 4);
		if (id === 'fmt ') {
			if (buf.readUInt16LE(at + 10) !== 1 || buf.readUInt16LE(at + 22) !== 16) {
				throw new Error('expected 16-bit mono WAV');
			}
			rate = buf.readUInt32LE(at + 12);
		} else if (id === 'data') {
			// The model streams the header before it knows the length, so trust the buffer.
			const end = size && at + 8 + size <= buf.length ? at + 8 + size : buf.length;
			const bytes = buf.subarray(at + 8, end - ((end - at - 8) % 2));
			return { rate, samples: new Int16Array(bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.length)) };
		}
		at += 8 + size + (size % 2);
	}
	throw new Error('no data chunk in WAV');
}

/** Cuts the model's leading/trailing silence, keeping a short breath either side. */
function trimSilence({ rate, samples }) {
	const THRESHOLD = 300; // about -40 dBFS
	const PAD = Math.round(rate * 0.12);
	let start = 0;
	while (start < samples.length && Math.abs(samples[start]) < THRESHOLD) start++;
	let end = samples.length;
	while (end > start && Math.abs(samples[end - 1]) < THRESHOLD) end--;
	if (end <= start) throw new Error('the audio is silent');
	return { rate, samples: samples.subarray(Math.max(0, start - PAD), Math.min(samples.length, end + PAD)) };
}

function encodeMp3({ rate, samples }) {
	const encoder = new Mp3Encoder(1, rate, KBPS);
	const chunks = [];
	const BLOCK = 1152;
	for (let i = 0; i < samples.length; i += BLOCK) {
		const out = encoder.encodeBuffer(samples.subarray(i, i + BLOCK));
		if (out.length) chunks.push(Buffer.from(out));
	}
	const tail = encoder.flush();
	if (tail.length) chunks.push(Buffer.from(tail));
	return Buffer.concat(chunks);
}

function sortKeys(obj) {
	return Object.fromEntries(
		Object.keys(obj)
			.sort()
			.map((k) => [k, obj[k] && typeof obj[k] === 'object' ? sortKeys(obj[k]) : obj[k]])
	);
}

/** Minimal .env reader so the tool has no dependency. */
function loadDotEnv(path) {
	if (!existsSync(path)) return;
	for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
		const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
		if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
	}
}
