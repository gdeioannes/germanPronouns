// Generates the Instagram story-mode ad pictures in assets/images/promo/
// instagram/ (square 1080×1080, viewable at /dev/story-bible/instagram).
// Art comes from Gemini in the canon ligne claire style — the story
// manifest's style preamble and {blocks} plus existing story webps fed in as
// strict style/character references — and the caption text is stamped on
// afterwards with sharp (the model mangles text; same rule as game props).
//
//   node tool/gen-promo-ig.mjs                 render every slide (art is only
//                                              generated when its *_raw.png is missing)
//   node tool/gen-promo-ig.mjs promo_ig_b_mystery --force   regenerate that art
//
// Rewording a caption is free: edit SLIDES below and re-run — the overlay is
// re-stamped from the kept raw PNGs, no API calls. Needs GEMINI_API_KEY in
// .env only when generating new art.
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT = join(root, 'assets', 'images', 'promo', 'instagram');
mkdirSync(OUT, { recursive: true });

for (const line of readFileSync(join(root, '.env'), 'utf8').split(/\r?\n/)) {
	const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
	if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
}
const key = process.env.GEMINI_API_KEY;

const manifest = JSON.parse(
	readFileSync(join(root, 'assets', 'images', 'story_manifest.json'), 'utf8')
);
const expand = (p) => p.replace(/\{([a-z0-9_]+)\}/g, (m, n) => manifest.blocks?.[n] ?? m);

const refs = ['maya_pose_clue', 'ep1_room_wide', 'ep1_maya_board'].map((id) => ({
	inlineData: {
		mimeType: 'image/webp',
		data: readFileSync(join(root, 'static', 'img', 'story', `${id}.webp`)).toString('base64')
	}
}));

const NAVY = '#1f3a5f';
const MUSTARD = '#d9a441';
const TERRA = '#c9683b';
const CREAM = '#fbf8f3';

// Carousel order: invite → the mystery → how playing teaches.
const SLIDES = [
	{
		id: 'promo_ig_3_invite',
		aspect: '1:1',
		prompt:
			'scene: {maya} facing the viewer, looking directly at the camera with a warm inviting smile, holding out a torn paper note toward the viewer with one hand as if asking for help, cozy room behind her with patterned wallpaper and a case board softly out of focus, dusk window light, golden hour glow. Square composition: her head and shoulders sit in the LOWER half of the frame, slightly right of centre; the upper 45% of the image is calm, plain, dim wall in shadow, completely uncluttered, so a large caption can sit there.',
		text: [
			{ t: 'Spielst du mit?', size: 92, weight: 700, serif: true, fill: CREAM },
			{ t: 'A little German is all you need (A1.1+)', size: 44, weight: 600, serif: false, fill: MUSTARD },
			{ t: 'Play Episode 1 free · languagequiz.org', size: 36, weight: 500, serif: false, fill: '#8fb3c9' }
		],
		band: NAVY
	},
	{
		id: 'promo_ig_b_mystery',
		aspect: '1:1',
		prompt:
			'scene: a wooden desk seen from above at a slight angle, evidence of a mystery laid out: a torn paper note in two pieces, an old smartphone with a blank dark screen, a small city map, a cup of coffee, a magnifying glass, terracotta string and pins, warm lamp cone light from the side cutting into cool blue-grey shadow. Square composition: the props sit in the LOWER half of the frame; the upper 45% is the calm, dim, plain wall and shadow above the desk, completely uncluttered, so a large caption can sit there.',
		text: [
			{ t: 'Jonas ist weg.', size: 100, weight: 700, serif: true, fill: CREAM },
			{ t: 'Your flatmate vanished overnight', size: 44, weight: 600, serif: false, fill: MUSTARD },
			{ t: 'A torn note, a locked phone, a strange chat — follow the clues', size: 34, weight: 500, serif: false, fill: '#d7e2ee' }
		],
		band: NAVY
	},
	{
		id: 'promo_ig_c_learn',
		aspect: '1:1',
		prompt:
			'scene: {maya} seen from behind over her shoulder, holding her smartphone in one hand and pressing it slightly toward the viewer, the phone screen glowing warmly but completely blank, her cork case board with blank notes, small photos and terracotta string softly visible in front of her, lamp cone light, golden and cozy against cool blue-grey dusk. Square composition: she and the phone sit in the LOWER half of the frame, slightly right of centre; the upper 45% of the image is calm dim wall in shadow, completely uncluttered, so a large caption can sit there.',
		text: [
			{ t: 'Spiel. Und lerne.', size: 100, weight: 700, serif: true, fill: CREAM },
			{ t: 'Every clue is a tiny German exercise', size: 44, weight: 600, serif: false, fill: MUSTARD },
			{ t: 'Read, listen and type your way to the truth · languagequiz.org', size: 34, weight: 500, serif: false, fill: '#d7e2ee' }
		],
		band: NAVY
	}
];

const W = 1080;
const H = 1080;

const only = new Set(process.argv.slice(2).filter((a) => !a.startsWith('--')));
for (const s of SLIDES) {
	if (only.size && !only.has(s.id)) continue;
	process.stdout.write(`${s.id} … `);
	const raw = join(OUT, `${s.id}_raw.png`);
	let png;
	if (existsSync(raw) && !process.argv.includes('--force')) {
		png = readFileSync(raw);
	} else {
		if (!key) throw new Error('GEMINI_API_KEY is not set and raw art is missing');
		png = await generate(
			`${manifest.style}\n\nUse the attached images as strict style and character references: same linework, palette and faces.\n\n${expand(s.prompt)}`,
			s.aspect ?? '1:1'
		);
		writeFileSync(raw, png);
	}
	const art = await sharp(png).resize(W, H, { fit: 'cover', position: 'attention' }).toBuffer();
	await sharp(art)
		.composite([{ input: Buffer.from(overlay(s)), top: 0, left: 0 }])
		.jpeg({ quality: 90 })
		.toFile(join(OUT, `${s.id}.jpg`));
	console.log('ok');
}
console.log(`\nDone → ${OUT}`);

function overlay(s) {
	const pad = 64;
	// Text block at the TOP: badge pill, then the headline lines, big.
	const lines = [];
	let y = 150;
	for (const l of s.text) {
		y += l.size * 1.18;
		lines.push(
			`<text x="${pad}" y="${y}" font-family="${l.serif ? "'Source Serif 4','Georgia',serif" : "'Inter','Segoe UI',sans-serif"}" font-size="${l.size}" font-weight="${l.weight}" fill="${l.fill}">${esc(l.t)}</text>`
		);
		y += 14;
	}
	const gradBottom = y + 150;
	return `<svg width="${W}" height="${H}" xmlns="http://www.w3.org/2000/svg">
	<defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
		<stop offset="0" stop-color="${s.band}" stop-opacity="0.96"/>
		<stop offset="0.6" stop-color="${s.band}" stop-opacity="0.85"/>
		<stop offset="1" stop-color="${s.band}" stop-opacity="0"/>
	</linearGradient></defs>
	<rect x="0" y="0" width="${W}" height="${gradBottom}" fill="url(#g)"/>
	<rect x="${pad}" y="58" rx="26" width="440" height="56" fill="${CREAM}"/>
	<text x="${pad + 220}" y="96" text-anchor="middle" font-family="'Inter','Segoe UI',sans-serif" font-size="25" font-weight="700" letter-spacing="3" fill="${NAVY}">STORY MODE · EPISODE 1</text>
	<g>${lines.join('\n')}</g>
	${s.id.endsWith('_invite') ? `<g><circle cx="${W - 110}" cy="${H - 110}" r="48" fill="${TERRA}"/><path d="M ${W - 130} ${H - 110} h 36 m 0 0 l -13 -13 m 13 13 l -13 13" stroke="${CREAM}" stroke-width="6" stroke-linecap="round" fill="none"/></g>` : ''}
</svg>`;
}

function esc(t) {
	return t.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

async function generate(prompt, aspect, attempt = 1) {
	try {
		const res = await fetch(
			'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent',
			{
				method: 'POST',
				headers: { 'content-type': 'application/json', 'x-goog-api-key': key },
				body: JSON.stringify({
					contents: [{ parts: [...refs, { text: prompt }] }],
					generationConfig: { responseModalities: ['IMAGE'], imageConfig: { aspectRatio: aspect } }
				})
			}
		);
		if (!res.ok) throw new Error(`${res.status} ${(await res.text()).slice(0, 300)}`);
		const json = await res.json();
		const part = (json.candidates?.[0]?.content?.parts ?? []).find((p) => p.inlineData?.data);
		if (!part)
			throw new Error(
				`no image (${json.candidates?.[0]?.finishReason ?? json.promptFeedback?.blockReason ?? '?'})`
			);
		return Buffer.from(part.inlineData.data, 'base64');
	} catch (e) {
		if (attempt >= 3) throw e;
		await new Promise((r) => setTimeout(r, 2000 * attempt));
		return generate(prompt, aspect, attempt + 1);
	}
}
