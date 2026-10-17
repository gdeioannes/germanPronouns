// Builds assets/images/match_manifest.json from the "Schreib mir!" chats
// (assets/content/match/*.json): every chat's `imagePrompts`, with "{self}"
// replaced by the chat's `imageCharacter`, all shipped to static/img/story/.
// Then generate the missing pictures with:
//
//   node tool/build-match-images.mjs
//   node tool/gen-images.mjs --story --manifest assets/images/match_manifest.json
//   node tool/gen-images.mjs --story --manifest assets/images/match_manifest.json match_helga   (one picture)

import { readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const DIR = join(root, 'assets', 'content', 'match');
const OUT = join(root, 'assets', 'images', 'match_manifest.json');

const STYLE =
	"Flat picture-book illustration with warm, absurd humour, in the spirit of a mid-century children's picture book with a touch of graphic simplification: natural proportions and simple expressive faces, details reduced to clean flat colour shapes, medium-weight ink-navy outlines, no gradients, no photographic texture. Limited warm palette: ink-navy (#1f3a5f), terracotta (#c9683b), mustard (#d9a441), sage (#7a9a7e), soft blue, cream, plus deep black for black clothes and night shadows. Bare hands, no gloves. No text, no letters, no numbers, no logos, no watermark anywhere in the image.";

const images = [];
for (const file of readdirSync(DIR).filter((f) => f.endsWith('.json')).sort()) {
	const chat = JSON.parse(readFileSync(join(DIR, file), 'utf8'));
	for (const p of chat.imagePrompts ?? []) {
		images.push({
			id: p.id,
			aspect: p.aspect ?? '1:1',
			ship: true,
			prompt: p.prompt.replaceAll('{self}', chat.imageCharacter ?? '')
		});
	}
}
writeFileSync(OUT, JSON.stringify({ style: STYLE, images }, null, 2) + '\n');
console.log(`${images.length} pictures from the chats → ${OUT}`);
