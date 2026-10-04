// Generates the content illustrations in static/img/ from
// assets/images/manifest.json with Google's Gemini image model, so quizzes
// can show a picture ("What is this? — der Apfel") instead of only text.
//
//   npm run images            generate every manifest entry whose WebP is missing
//   npm run images -- --force regenerate everything
//   npm run images -- apple bread   only these ids (still skips existing unless --force)
//   npm run images -- --link  only stamp `image` onto the deck cards, no API calls
//
// After generating, every vocabulary deck in the course bundles gets `image`
// (and `imageHint`, from the manifest's `hint`) on each card whose German
// word slugs to a manifest id with a WebP on disk — "Mädchen" → maedchen.
//
// Needs GEMINI_API_KEY in .env (see .env.example). The model returns ~1.5 MB
// 1024px PNGs; those land in assets/images/raw/ (gitignored) and a 512px WebP
// of each is written to static/img/, which is what the app serves and what is
// committed. The build never calls the API; this is an authoring tool like og-images.
//
// Manifest shape:
//   { "style": "<preamble prepended to every prompt>",
//     "images": [ { "id": "apple", "prompt": "a red apple", "aspect": "1:1" }, ... ] }

import { existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const MODEL = 'gemini-2.5-flash-image';
/** The cream every backdrop is levelled to; VocabularyQuiz.svelte paints the card the same. */
const PAPER = [0xfb, 0xf5, 0xe4];

const args = process.argv.slice(2);
// Story mode: npm run images -- --story  — uses assets/images/story_manifest.json
// (its own style preamble: scenes, props and mood lighting allowed, see
// docs/story_bible.md) and writes to static/img/story/. Scenes keep their
// lighting, so no paper levelling or palette quantisation, and a larger size.
const story = args.includes('--story');
const force = args.includes('--force');
const linkOnly = args.includes('--link');
/** Rebuild every WebP from the raw originals (new size or quality), no API. */
const reshrink = args.includes('--shrink');
const only = new Set(args.filter((a) => !a.startsWith('--')));

// Story reference images are dev-only (the /dev/story-bible page); they live
// under src/lib so they never ship in the static build. Episode images that
// the game itself shows are marked `"ship": true` in the story manifest and
// land in static/img/story/ like any other served content.
const OUT_DIR = story ? join(root, 'src', 'lib', 'assets', 'story') : join(root, 'static', 'img');
const SHIP_DIR = join(root, 'static', 'img', 'story');
const RAW_DIR = join(root, 'assets', 'images', 'raw', ...(story ? ['story'] : []));
const SIZE = story ? 1024 : 512;

const manifest = JSON.parse(
	readFileSync(join(root, 'assets', 'images', story ? 'story_manifest.json' : 'manifest.json'), 'utf8')
);
mkdirSync(OUT_DIR, { recursive: true });
mkdirSync(RAW_DIR, { recursive: true });

loadDotEnv(join(root, '.env'));
const key = process.env.GEMINI_API_KEY;
if (!key && !linkOnly && !reshrink) {
	console.error('GEMINI_API_KEY is not set. Copy .env.example to .env and add your key.');
	process.exit(1);
}

let made = 0;
let skipped = 0;
for (const img of linkOnly ? [] : manifest.images) {
	if (only.size && !only.has(img.id)) continue;
	if (img.ship) mkdirSync(SHIP_DIR, { recursive: true });
	const file = join(img.ship ? SHIP_DIR : OUT_DIR, `${img.id}.webp`);
	const raw = join(RAW_DIR, `${img.id}.png`);
	if (existsSync(file) && !force && !(reshrink && existsSync(raw))) {
		skipped++;
		continue;
	}
	process.stdout.write(`${img.id} … `);
	try {
		const png =
			existsSync(raw) && !force
				? readFileSync(raw)
				: await generate(`${manifest.style}\n\n${expand(img.prompt)}`, img.aspect ?? '1:1');
		writeFileSync(raw, png);
		await shrink(png, file, img.transparent);
		made++;
		console.log(`ok (${Math.round(statSync(file).size / 1024)} kB)`);
	} catch (e) {
		console.log(`FAILED: ${e.message}`);
	}
}
if (!linkOnly) console.log(`\n${made} generated, ${skipped} already present, in ${OUT_DIR}`);
if (!story) linkImages();

/**
 * Splices the manifest's reusable `blocks` (character and location
 * descriptions, kept verbatim across every scene so the cast stays
 * consistent — see docs/story_bible.md) into a prompt: "{maya} crouches…".
 */
function expand(prompt) {
	return prompt.replace(/\{([a-z0-9_]+)\}/g, (m, name) => manifest.blocks?.[name] ?? m);
}

/** "Mädchen" → "maedchen", "Großvater" → "grossvater": the manifest id of a word. */
function slug(de) {
	return de
		.toLowerCase()
		.replace(/ä/g, 'ae')
		.replace(/ö/g, 'oe')
		.replace(/ü/g, 'ue')
		.replace(/ß/g, 'ss')
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/^-|-$/g, '');
}

/** Stamps `image` / `imageHint` onto every deck card that has a picture on disk. */
function linkImages() {
	const byId = new Map(manifest.images.map((img) => [img.id, img]));
	const coursesDir = join(root, 'assets', 'content', 'courses');
	for (const name of readdirSync(coursesDir)) {
		if (!name.endsWith('.json')) continue;
		const path = join(coursesDir, name);
		const bundle = JSON.parse(readFileSync(path, 'utf8'));
		let linked = 0;
		let changed = false;
		// A passage quiz owns a scene named after its id; a speaking exercise
		// borrows one from its level (the "dialog" prefers the reading scene,
		// the "kurzcheck" the listening one) and carries the scene's prompt as
		// the description its tutor, who cannot see the picture, reads.
		const sceneOf = (quiz) =>
			byId.has(quiz.id) && existsSync(join(OUT_DIR, `${quiz.id}.webp`)) ? quiz.id : null;
		// Everything else without its own scene shares one card picture per
		// type and sub-level ("card_grammar_a1_1"). Only the deck card shows
		// it: these quiz pages never render `quiz.image`.
		const CARD_TYPE = { fillBlank: 'grammar', speakRepeat: 'repeat', dictation: 'dictation', vocabulary: 'words' };
		const sharedOf = (quiz) => {
			const type = CARD_TYPE[quiz.type];
			if (!type || !quiz.level) return null;
			const id = `card_${type}_${quiz.level.toLowerCase().replace('.', '_')}`;
			return byId.has(id) && existsSync(join(OUT_DIR, `${id}.webp`)) ? id : null;
		};
		const describe = (id) =>
			byId
				.get(id)
				.prompt.replace(/^scene:\s*/, '')
				.replace(/,\s*wide empty paper margins[^,]*$/, '');
		for (const quiz of bundle.quizzes ?? []) {
			let scene = sceneOf(quiz) ?? sharedOf(quiz);
			if (!scene && quiz.type === 'speaking') {
				const wants = /kurzcheck/.test(quiz.id) ? ['listening', 'reading'] : ['reading', 'listening'];
				for (const type of wants) {
					const donor = bundle.quizzes.find(
						(q) => q.type === type && q.level === quiz.level && sceneOf(q)
					);
					if (donor) {
						scene = donor.id;
						break;
					}
				}
			}
			const description = scene && quiz.type === 'speaking' ? describe(scene) : undefined;
			if (quiz.image !== (scene ?? undefined) || quiz.imageDescription !== description) changed = true;
			delete quiz.image;
			delete quiz.imageDescription;
			if (scene) quiz.image = scene;
			if (description) quiz.imageDescription = description;
			if (quiz.type !== 'vocabulary') continue;
			for (const card of quiz.cards) {
				const id = slug(card.de);
				const img = byId.get(id);
				const has = !!img && existsSync(join(OUT_DIR, `${id}.webp`));
				const image = has ? id : undefined;
				const imageHint = has && img.hint ? true : undefined;
				if (card.image !== image || card.imageHint !== imageHint) changed = true;
				delete card.image;
				delete card.imageHint;
				if (image) card.image = image;
				if (imageHint) card.imageHint = true;
				if (image) linked++;
			}
		}
		if (changed) writeFileSync(path, JSON.stringify(bundle, null, 2) + '\n');
		const scenes = bundle.quizzes.filter((q) => q.image).length;
		console.log(`${name}: ${linked} cards and ${scenes} quizzes with a picture${changed ? ' (updated)' : ''}`);
	}
}

/** One image, as a PNG buffer; the API sometimes answers with no image, so retry. */
async function generate(prompt, aspect, attempt = 1) {
	try {
		return await callApi(prompt, aspect);
	} catch (e) {
		if (attempt >= 3) throw e;
		process.stdout.write(`retry ${attempt} … `);
		await new Promise((r) => setTimeout(r, 2000 * attempt));
		return generate(prompt, aspect, attempt + 1);
	}
}

async function callApi(prompt, aspect) {
	const res = await fetch(
		`https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
		{
			method: 'POST',
			headers: { 'content-type': 'application/json', 'x-goog-api-key': key },
			body: JSON.stringify({
				contents: [{ parts: [{ text: prompt }] }],
				generationConfig: {
					responseModalities: ['IMAGE'],
					imageConfig: { aspectRatio: aspect }
				}
			})
		}
	);
	if (!res.ok) throw new Error(`${res.status} ${(await res.text()).slice(0, 300)}`);
	const json = await res.json();
	const parts = json.candidates?.[0]?.content?.parts ?? [];
	const part = parts.find((p) => p.inlineData?.data);
	if (!part) {
		const reason = json.candidates?.[0]?.finishReason ?? json.promptFeedback?.blockReason;
		throw new Error(`no image in response (${reason ?? 'unknown reason'})`);
	}
	return Buffer.from(part.inlineData.data, 'base64');
}

/**
 * 1024px PNG → 512px WebP for the app. With `transparent` (a manifest flag,
 * for illustrations that sit directly on a page rather than on a cream card,
 * like the About page's), the flood-filled backdrop becomes alpha instead of
 * levelled paper.
 */
async function shrink(png, file, transparent = false) {
	// Story scenes keep their mood lighting: no paper levelling, no palette
	// quantisation — a plain lossy WebP at full size.
	if (story) {
		await sharp(png).resize(SIZE, SIZE, { fit: 'inside' }).removeAlpha().webp({ quality: 82 }).toFile(file);
		return;
	}
	const { data, info } = await sharp(png)
		.resize(SIZE, SIZE, { fit: 'inside' })
		.removeAlpha()
		.raw()
		.toBuffer({ resolveWithObject: true });
	const filled = levelPaper(data, info.width, info.height);
	if (transparent) {
		// RGB → RGBA, with every flood-filled backdrop pixel fully clear.
		const rgba = Buffer.alloc(info.width * info.height * 4);
		for (let p = 0; p < info.width * info.height; p++) {
			rgba[p * 4] = data[p * 3];
			rgba[p * 4 + 1] = data[p * 3 + 1];
			rgba[p * 4 + 2] = data[p * 3 + 2];
			rgba[p * 4 + 3] = filled[p] ? 0 : 255;
		}
		await sharp(rgba, { raw: { width: info.width, height: info.height, channels: 4 } })
			.webp({ lossless: true, effort: 6 })
			.toFile(file);
		return;
	}
	// Lossy WebP shifts flat colours by a few units, which shows as a faint
	// tile edge on the card. Quantising to a palette flattens the model's
	// paper grain, so a lossless WebP of it stays small (~30 kB) and the
	// backdrop stays exactly PAPER.
	const quantised = await sharp(data, { raw: { width: info.width, height: info.height, channels: 3 } })
		.png({ palette: true, colours: 256, dither: 0, effort: 10 })
		.toBuffer();
	await sharp(quantised).webp({ lossless: true, effort: 6 }).toFile(file);
}

/**
 * The card behind a picture is painted PAPER (VocabularyQuiz.svelte), but
 * the model's cream drifts a few units per image, which shows as a faint
 * tile edge. A flood fill from the border repaints every backdrop pixel
 * that touches the edge to exactly PAPER; enclosed light areas (a shirt,
 * a window) are left alone, and so is the drawing.
 */
function levelPaper(px, w, h) {
	// The reference is the median border colour, not the corner pixel: the
	// model often shades the corners, and a fill measured from a dark corner
	// gives up a few pixels in. The wider tolerance then also swallows that
	// corner shading; the drawing is safe because its light areas are closed
	// off from the border by outlines.
	const corner = medianBorder(px, w, h);
	const TOLERANCE = 48;
	// The corner shading can be 80+ units darker than the paper, so a band
	// along the edges, where the drawing never reaches, is judged leniently.
	const EDGE_BAND = 48;
	const EDGE_TOLERANCE = 120;
	const near = (i, x, y) => {
		const tol =
			x < EDGE_BAND || y < EDGE_BAND || x >= w - EDGE_BAND || y >= h - EDGE_BAND
				? EDGE_TOLERANCE
				: TOLERANCE;
		return (
			Math.abs(px[i] - corner[0]) < tol &&
			Math.abs(px[i + 1] - corner[1]) < tol &&
			Math.abs(px[i + 2] - corner[2]) < tol
		);
	};
	const seen = new Uint8Array(w * h);
	const filled = new Uint8Array(w * h);
	const stack = [];
	const push = (x, y) => {
		if (x < 0 || y < 0 || x >= w || y >= h) return;
		const p = y * w + x;
		if (seen[p]) return;
		seen[p] = 1;
		stack.push(p);
	};
	for (let x = 0; x < w; x++) (push(x, 0), push(x, h - 1));
	for (let y = 0; y < h; y++) (push(0, y), push(w - 1, y));
	while (stack.length) {
		const p = stack.pop();
		const x = p % w;
		const y = (p - x) / w;
		if (!near(p * 3, x, y)) continue;
		px[p * 3] = PAPER[0];
		px[p * 3 + 1] = PAPER[1];
		px[p * 3 + 2] = PAPER[2];
		filled[p] = 1;
		push(x - 1, y);
		push(x + 1, y);
		push(x, y - 1);
		push(x, y + 1);
	}
	return filled;
}

/** The median colour of the image's outermost pixels. */
function medianBorder(px, w, h) {
	const ch = [[], [], []];
	const take = (x, y) => {
		const i = (y * w + x) * 3;
		for (let c = 0; c < 3; c++) ch[c].push(px[i + c]);
	};
	for (let x = 0; x < w; x++) (take(x, 0), take(x, h - 1));
	for (let y = 0; y < h; y++) (take(0, y), take(w - 1, y));
	return ch.map((v) => v.sort((a, b) => a - b)[v.length >> 1]);
}

/** Minimal .env reader so the tool has no dependency. */
function loadDotEnv(path) {
	if (!existsSync(path)) return;
	for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
		const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
		if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
	}
}
