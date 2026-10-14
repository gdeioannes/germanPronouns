// Validates assets/content/janein/*.json: every category has 5 personas and
// 10 rounds of 8 questions; every question feeds two different personas of
// its own category with a Ja and a Nein (or a left and a right); the German
// is short and a question; no round repeats a question; the personas of a
// category are fed roughly evenly across its rounds.
//   node tool/check-janein.mjs            all categories
//   node tool/check-janein.mjs teller     one category
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const dir = 'assets/content/janein';
const ROUND = 8;
const only = process.argv[2];
let errors = 0;
const err = (m) => {
	console.error('x', m);
	errors++;
};
const files = readdirSync(dir).filter((f) => f.endsWith('.json') && (!only || f === `${only}.json`));
let total = 0;
for (const f of files) {
	const c = JSON.parse(readFileSync(join(dir, f), 'utf8'));
	const vibes = new Set((c.personas ?? []).map((p) => p.id));
	if (vibes.size !== 5) err(`${f}: ${vibes.size} personas, want 5`);
	if ((c.rounds ?? []).length !== 10) err(`${f}: ${c.rounds?.length} rounds, want 10`);
	const fed = Object.fromEntries([...vibes].map((v) => [v, 0]));
	const ids = new Set();
	for (const r of c.rounds ?? []) {
		const tag = `${f} > ${r.id}`;
		if (ids.has(r.id)) err(`${tag}: duplicate round id`);
		ids.add(r.id);
		if (!r.title || !r.en || !r.hook) err(`${tag}: missing title/en/hook`);
		if ((r.questions ?? []).length !== ROUND) err(`${tag}: ${r.questions?.length ?? 0} questions, want ${ROUND}`);
		const seen = new Set();
		for (const q of r.questions ?? []) {
			total++;
			const pair = q.left && q.right;
			const de = pair ? `${q.left.de} oder ${q.right.de}?` : q.de;
			if (seen.has(de)) err(`${tag}: repeats "${de}"`);
			seen.add(de);
			if (pair) {
				for (const side of ['left', 'right']) {
					const s = q[side];
					if (!s.de || !s.en || !vibes.has(s.vibe)) err(`${tag}: bad ${side} in "${de}"`);
					if ((s.de ?? '').length > 24) err(`${tag}: ${side} too long "${s.de}"`);
				}
				if (q.left.vibe === q.right.vibe) err(`${tag}: both sides feed ${q.left.vibe} in "${de}"`);
				if (q.de || q.ja || q.nein) err(`${tag}: a this-or-that must not also have de/ja/nein ("${de}")`);
				fed[q.left.vibe] = (fed[q.left.vibe] ?? 0) + 1;
				fed[q.right.vibe] = (fed[q.right.vibe] ?? 0) + 1;
			} else {
				if (!q.de || !q.en) err(`${tag}: question without de/en`);
				if (!q.de?.endsWith('?')) err(`${tag}: not a question "${q.de}"`);
				if (!q.en?.endsWith('?')) err(`${tag}: English not a question "${q.en}"`);
				if ((q.de ?? '').length > 48) err(`${tag}: too long "${q.de}"`);
				if (!vibes.has(q.ja) || !vibes.has(q.nein)) err(`${tag}: unknown vibe in "${q.de}" (${q.ja}/${q.nein})`);
				if (q.ja === q.nein) err(`${tag}: Ja and Nein both feed ${q.ja} in "${q.de}"`);
				fed[q.ja] = (fed[q.ja] ?? 0) + 1;
				fed[q.nein] = (fed[q.nein] ?? 0) + 1;
			}
		}
	}
	const counts = Object.values(fed);
	if (counts.length && Math.min(...counts) < Math.max(...counts) * 0.5)
		err(`${f}: personas fed unevenly ${JSON.stringify(fed)} (the least-fed must get at least half of the most-fed)`);
	console.log(`${f}: ${c.rounds?.reduce((n, r) => n + (r.questions?.length ?? 0), 0)} questions, fed ${JSON.stringify(fed)}`);
}
console.log(`${files.length} categories, ${total} questions, ${errors} errors`);
process.exit(errors ? 1 : 0);
