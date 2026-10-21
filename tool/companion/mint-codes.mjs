// Mints the permanent QR codes for one printed book (A2, B1 …) into
// assets/content/booklinks.json, without printing it — so a study companion
// can print its codes before the book exists. Same rule and order as
// tool/gen-books.mjs, which skips codes already minted, so the two agree.
//
//   node tool/companion/mint-codes.mjs A2
import { readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const read = (p) => JSON.parse(readFileSync(new URL(p, root), 'utf8'));
const bookId = process.argv[2];
if (!/^[ABC][12]$/.test(bookId ?? '')) throw new Error('Usage: node tool/companion/mint-codes.mjs A2');

const registryPath = new URL('assets/content/booklinks.json', root);
const registry = JSON.parse(readFileSync(registryPath, 'utf8'));
const before = registry.links.length;
const mint = (kind, target, note) => {
	if (registry.links.some((l) => l.kind === kind && l.target === target)) return;
	const prefix = bookId.toLowerCase();
	const used = registry.links.filter((l) => l.code.startsWith(prefix + '-')).length;
	registry.links.push({ code: `${prefix}-${String(used + 1).padStart(2, '0')}`, kind, target, note, since: new Date().toISOString().slice(0, 10) });
};

for (const card of read('assets/content/catalog.json').courses) {
	const course = read(`assets/content/courses/${card.id}.json`);
	if (!course.quizzes.some((q) => q.level === `${bookId}.1`)) continue;
	mint('book', bookId, `Book ${bookId}`);
	for (const level of [`${bookId}.1`, `${bookId}.2`]) {
		for (const q of course.quizzes.filter((q) => q.level === level && q.status !== 'placeholder')) {
			mint('quiz', q.id, `${bookId} ${q.title}`);
			const audible = ['listening', 'dictation', 'speakRepeat', 'suchbild'].includes(q.type) || (q.type === 'reading' && !('inlineBlanks' in q));
			if (audible) mint('audio', q.id, `${bookId} ${q.title} audio`);
		}
	}
}

writeFileSync(registryPath, JSON.stringify(registry, null, '\t') + '\n');
console.log(`${registry.links.length - before} new codes, ${registry.links.length} in the registry`);
