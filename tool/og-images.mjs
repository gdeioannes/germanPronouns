// Draws the share images (1200×630) into static/og/: one per CEFR sub-level,
// one per exercise kind and one each for the noun and verb pages, so a link
// shared to a quiz previews as "A1.1 · First contact" rather than as the
// generic site card. Run `npm run og` after the nav or syllabus changes; the
// PNGs are committed, so the build does not depend on this.
//
// Same identity as the site: ink-navy and terracotta on warm paper, serif
// display, sans body. Rendered by resvg with the system's fonts.

import { Resvg } from '@resvg/resvg-js';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const read = (p) => JSON.parse(readFileSync(new URL(p, import.meta.url), 'utf8'));

const catalog = read('../assets/content/catalog.json');
const courseId = catalog.defaultCourseId;
const course = read(`../assets/content/courses/${courseId}.json`);
const syllabus = read(`../assets/content/syllabus/${courseId}.json`);

const NAVY = '#1f3a5f';
const TERRACOTTA = '#c9683b';
const PAPER = '#fbf8f3';
const INK = '#2a2a28';
const MUTED = '#6e6458';

const esc = (s) =>
	String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');

/** The card: a kicker, a big title, a line under it, and the site name. */
function card({ kicker, title, sub, accent = TERRACOTTA }) {
	const size = title.length > 26 ? 64 : title.length > 18 ? 80 : 96;
	return `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
  <rect width="1200" height="630" fill="${PAPER}"/>
  <rect x="0" y="0" width="18" height="630" fill="${accent}"/>
  <circle cx="1060" cy="120" r="220" fill="${accent}" opacity="0.10"/>
  <circle cx="1120" cy="560" r="120" fill="${NAVY}" opacity="0.08"/>
  <text x="90" y="150" font-family="Segoe UI, Inter, Arial, sans-serif" font-size="34" font-weight="700" letter-spacing="3" fill="${accent}">${esc(kicker.toUpperCase())}</text>
  <text x="90" y="${150 + size + 30}" font-family="Georgia, 'Source Serif 4', serif" font-size="${size}" font-weight="700" fill="${NAVY}">${esc(title)}</text>
  <text x="90" y="${150 + size + 100}" font-family="Segoe UI, Inter, Arial, sans-serif" font-size="36" fill="${INK}">${esc(sub)}</text>
  <text x="90" y="560" font-family="Segoe UI, Inter, Arial, sans-serif" font-size="30" font-weight="700" fill="${NAVY}">Language Quiz</text>
  <text x="330" y="560" font-family="Segoe UI, Inter, Arial, sans-serif" font-size="30" fill="${MUTED}">languagequiz.org · free German course, A1 to C2</text>
</svg>`;
}

const images = [];

for (const group of course.nav.groups) {
	if (group.type !== 'questChain' || !group.level) continue;
	const module = syllabus.modules.find((m) => m.level === group.level);
	const count = course.quizzes.filter((q) => q.level === group.level).length;
	images.push({
		name: `level-${group.level.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`,
		svg: card({
			kicker: `German ${group.level}`,
			title: module?.title ?? group.title.replace(/^[ABC][12](\.\d)?\s*·\s*/, ''),
			sub: `${count} free exercises with audio · ${module?.subtitle ?? 'grammar, reading, listening, speaking'}`
		})
	});
}

const KINDS = {
	fillBlank: ['Fill in the blank', 'Articles, cases and endings, one sentence at a time'],
	reading: ['Reading', 'Short German texts with comprehension questions'],
	listening: ['Listening', 'Hear a passage read aloud, then answer'],
	dictation: ['Dictation', 'Type what you hear'],
	speakRepeat: ['Repeat aloud', 'Copy native-sounding phrases'],
	speaking: ['Speaking', 'Guided conversation prompts']
};
for (const [type, [title, sub]] of Object.entries(KINDS)) {
	images.push({
		name: `type-${type.toLowerCase()}`,
		svg: card({ kicker: 'German exercises', title, sub, accent: NAVY })
	});
}

images.push({
	name: 'words-nouns',
	svg: card({ kicker: 'Word library', title: 'der, die or das?', sub: 'Every German noun with its article, plural and cases' })
});
images.push({
	name: 'words-verbs',
	svg: card({ kicker: 'Word library', title: 'German verbs', sub: 'Full conjugation tables, every form with audio', accent: NAVY })
});

mkdirSync(`${root}static/og`, { recursive: true });
for (const { name, svg } of images) {
	const png = new Resvg(svg, {
		fitTo: { mode: 'width', value: 1200 },
		font: { loadSystemFonts: true, defaultFontFamily: 'Segoe UI' }
	})
		.render()
		.asPng();
	writeFileSync(`${root}static/og/${name}.png`, png);
	console.log(`static/og/${name}.png (${(png.length / 1024).toFixed(0)} KB)`);
}
