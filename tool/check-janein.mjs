// Validates assets/content/janein/*.json: every theme ("Which … are you?")
// has 5 result personas with a profile, traits, a match and a clash, and 10
// rounds of 12 questions; every question feeds two different personas of its
// own theme with a Ja and a Nein (or a left and a right); the German is short
// and a question; no round repeats a question; the personas of a theme are
// fed roughly evenly across its rounds, and each from both sides.
//   node tool/check-janein.mjs            all themes
//   node tool/check-janein.mjs stadt      one theme
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const dir = 'assets/content/janein';
const ROUND = 12;
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
	if (!c.id || !c.title || !c.en || !c.emoji) err(`${f}: missing id/title/en/emoji`);
	if (c.title && !c.title.endsWith('?')) err(`${f}: the theme title must be the quiz question ("${c.title}")`);
	const vibes = new Set((c.personas ?? []).map((p) => p.id));
	if (vibes.size !== 5) err(`${f}: ${vibes.size} personas, want 5`);
	for (const p of c.personas ?? []) {
		const tag = `${f} > persona ${p.id}`;
		if (!p.title || !p.emoji || !p.line || !p.word?.de || !p.word?.en) err(`${tag}: missing title/emoji/line/word`);
		if ((p.title ?? '').length > 24) err(`${tag}: title too long "${p.title}"`);
		if ((p.line ?? '').length > 90) err(`${tag}: line too long (${p.line.length})`);
		if (!p.profile || p.profile.length < 120 || p.profile.length > 340) err(`${tag}: profile must be 120–340 chars (${p.profile?.length ?? 0})`);
		if (!Array.isArray(p.traits) || p.traits.length !== 3 || p.traits.some((t) => typeof t !== 'string' || !t || t.length > 24))
			err(`${tag}: traits must be 3 short strings`);
		if (!p.de || !p.de.line || !p.de.profile || !Array.isArray(p.de.traits) || p.de.traits.length !== 3)
			err(`${tag}: missing de { line, profile, traits[3] }`);
		else {
			if (p.de.line.length > 90) err(`${tag}: de.line too long (${p.de.line.length})`);
			if (p.de.profile.length < 120 || p.de.profile.length > 360) err(`${tag}: de.profile must be 120–360 chars (${p.de.profile.length})`);
		}
		if (!vibes.has(p.match) || p.match === p.id) err(`${tag}: match must be another persona (${p.match})`);
		if (!vibes.has(p.clash) || p.clash === p.id || p.clash === p.match) err(`${tag}: clash must be another persona, not the match (${p.clash})`);
	}
	if ((c.rounds ?? []).length !== 10) err(`${f}: ${c.rounds?.length} rounds, want 10`);
	const fed = Object.fromEntries([...vibes].map((v) => [v, 0]));
	const fedJa = Object.fromEntries([...vibes].map((v) => [v, 0]));
	const fedNein = Object.fromEntries([...vibes].map((v) => [v, 0]));
	const ids = new Set();
	for (const r of c.rounds ?? []) {
		const tag = `${f} > ${r.id}`;
		if (ids.has(r.id)) err(`${tag}: duplicate round id`);
		ids.add(r.id);
		if (!r.title || !r.en || !r.hook) err(`${tag}: missing title/en/hook`);
		if ((r.title ?? '').length > 22) err(`${tag}: round title too long "${r.title}"`);
		if ((r.questions ?? []).length !== ROUND) err(`${tag}: ${r.questions?.length ?? 0} questions, want ${ROUND}`);
		const seen = new Set();
		let pairs = 0;
		for (const q of r.questions ?? []) {
			total++;
			const pair = q.left && q.right;
			const de = pair ? `${q.left.de} oder ${q.right.de}?` : q.de;
			if (seen.has(de)) err(`${tag}: repeats "${de}"`);
			seen.add(de);
			if (pair) {
				pairs++;
				for (const side of ['left', 'right']) {
					const s = q[side];
					if (!s.de || !s.en || !vibes.has(s.vibe)) err(`${tag}: bad ${side} in "${de}"`);
					if ((s.de ?? '').length > 24) err(`${tag}: ${side} too long "${s.de}"`);
				}
				if (q.left.vibe === q.right.vibe) err(`${tag}: both sides feed ${q.left.vibe} in "${de}"`);
				if (de.length > 48) err(`${tag}: spoken as "${de}" it is ${de.length} chars, max 48`);
				if (q.de || q.ja || q.nein) err(`${tag}: a this-or-that must not also have de/ja/nein ("${de}")`);
				fed[q.left.vibe] = (fed[q.left.vibe] ?? 0) + 1;
				fed[q.right.vibe] = (fed[q.right.vibe] ?? 0) + 1;
				fedNein[q.left.vibe] = (fedNein[q.left.vibe] ?? 0) + 1;
				fedJa[q.right.vibe] = (fedJa[q.right.vibe] ?? 0) + 1;
			} else {
				if (!q.de || !q.en) err(`${tag}: question without de/en`);
				if (!q.de?.endsWith('?')) err(`${tag}: not a question "${q.de}"`);
				if (/[=+→←]/.test(q.de ?? '')) err(`${tag}: symbols are not spoken, write the word ("${q.de}")`);
				if (!q.en?.endsWith('?')) err(`${tag}: English not a question "${q.en}"`);
				if ((q.de ?? '').length > 48) err(`${tag}: too long "${q.de}"`);
				if (!vibes.has(q.ja) || !vibes.has(q.nein)) err(`${tag}: unknown vibe in "${q.de}" (${q.ja}/${q.nein})`);
				if (q.ja === q.nein) err(`${tag}: Ja and Nein both feed ${q.ja} in "${q.de}"`);
				fed[q.ja] = (fed[q.ja] ?? 0) + 1;
				fed[q.nein] = (fed[q.nein] ?? 0) + 1;
				fedJa[q.ja] = (fedJa[q.ja] ?? 0) + 1;
				fedNein[q.nein] = (fedNein[q.nein] ?? 0) + 1;
			}
		}
		if (pairs < 3 || pairs > 6) err(`${tag}: ${pairs} this-or-that questions, want 3–6`);
	}
	const counts = Object.values(fed);
	if (counts.length && Math.min(...counts) < Math.max(...counts) * 0.5)
		err(`${f}: personas fed unevenly ${JSON.stringify(fed)} (the least-fed must get at least half of the most-fed)`);
	for (const v of vibes) {
		if ((fedJa[v] ?? 0) < 5) err(`${f}: ${v} is fed by a Ja/right only ${fedJa[v]}× (want ≥ 5)`);
		if ((fedNein[v] ?? 0) < 5) err(`${f}: ${v} is fed by a Nein/left only ${fedNein[v]}× (want ≥ 5)`);
	}
	console.log(`${f}: ${c.rounds?.reduce((n, r) => n + (r.questions?.length ?? 0), 0)} questions, fed ${JSON.stringify(fed)}`);
}
console.log(`${files.length} themes, ${total} questions, ${errors} errors`);
process.exit(errors ? 1 : 0);
