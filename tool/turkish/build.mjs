#!/usr/bin/env node
// Folds tool/turkish/tr/<level>/ into the overlays the app reads:
//   assets/content/tr/de_cert_a1/<level>.json
//   {
//     "quizzes":  { <quiz id>:    { <path>: [English, Türkçe] } },   exact, by path
//     "chapters": { <chapter id>: { <path>: [English, Türkçe] } },   the book
//     "front":    { <path>: [English, Türkçe] },                     the book's own lines
//     "text":     { English: Türkçe }    fallback for content derived from the
//                                         exercises (placement test, word lists)
//   }
// A path translation applies only while the English there is unchanged.
// Validates first and writes nothing for a level with errors.
//   node tool/turkish/build.mjs [a1_1 ...]        build
//   node tool/turkish/build.mjs a1_1 --check      validate and report only
import { existsSync, mkdirSync, readdirSync, writeFileSync } from 'node:fs';
import { COURSE, LEVELS, readJson } from './lib.mjs';
// English words in a Turkish line (a sign of an untranslated string). Letter-
// aware, so "ağrıyor" is not the English "a", and Turkish "on" (ten) is left out.
const EN_WORD = /(?<!\p{L})(the|a|an|is|are|was|were|be|you|your|with|and|or|of|to|this|that|these|for|not|it|its|when|means?|from|by|at|in|as|but|if|then|after|before|here|has|have|can|one|two|word|verb|noun)(?!\p{L})/giu;
const englishWords = (s) => (s.replace(/\*[^*]*\*/g, ' ').match(EN_WORD) ?? []).filter((w) => !['in', 'an', 'was'].includes(w.toLowerCase())).length;

const args = process.argv.slice(2);
const check = args.includes('--check');
const levels = args.filter((a) => !a.startsWith('--'));
const dir = 'tool/turkish';
const tokens = (s) => [...s.matchAll(/\{\{?\w+\}?\}|_{3,}/g)].map((m) => m[0]).sort().join(' ');

let failed = false;
for (const level of levels.length ? levels : LEVELS) {
	const errors = [];
	const flags = [];
	const overlay = {};
	const exact = { quizzes: {}, chapters: {}, front: {} };
	let variants = 0;
	const coverage = { have: 0, total: 0 };
	for (const kind of ['app', 'book']) {
		const enDir = `${dir}/en/${level}/${kind}`;
		if (!existsSync(enDir)) continue;
		for (const f of readdirSync(enDir).filter((f) => f.endsWith('.json'))) {
			const id = `${kind}/${f.slice(0, -5)}`;
			const en = readJson(`${enDir}/${f}`);
			coverage.total += Object.keys(en).length;
			const trPath = `${dir}/tr/${level}/${kind}/${f}`;
			if (!existsSync(trPath)) continue;
			let tr;
			try {
				tr = readJson(trPath);
			} catch (e) {
				errors.push(`${id}: not valid JSON (${e.message})`);
				continue;
			}
			for (const [path, source] of Object.entries(en)) {
				const text = tr[path];
				if (text === undefined) {
					flags.push(`${id} ${path}: missing`);
					continue;
				}
				if (typeof text !== 'string' || !text.trim()) {
					errors.push(`${id} ${path}: empty`);
					continue;
				}
				coverage.have++;
				if (tokens(text) !== tokens(source)) errors.push(`${id} ${path}: placeholders/blanks differ: "${source}" → "${text}"`);
				// Stars mark emphasis in pairs; a lone footnote star ("A2*") is fine when the English has one too.
				if ((text.match(/\*/g) ?? []).length % 2 !== (source.match(/\*/g) ?? []).length % 2) errors.push(`${id} ${path}: unbalanced *`);
				if (text !== source && englishWords(text.replace(/\bon\b/gi, '')) >= 4) flags.push(`${id} ${path}: looks English: ${text.slice(0, 70)}`);
				if (text === source) continue; // German, or a name: nothing to overlay
				const name = f.slice(0, -5);
				const bucket =
					kind === 'app' ? (exact.quizzes[name] ??= {}) : name === '_front' ? exact.front : (exact.chapters[name] ??= {});
				bucket[path] = [source, text];
				// The text fallback keeps the first Turkish; a second one is fine
				// (Turkish can need two where English has one), the paths keep both.
				if (overlay[source] === undefined) overlay[source] = text;
				else if (overlay[source] !== text) variants++;
			}
			for (const path of Object.keys(tr)) if (!(path in en)) flags.push(`${id} ${path}: not in the English file (stale?)`);
			// A check's answer must still be one of its options.
			const groups = {};
			for (const path of Object.keys(en)) {
				const m = path.match(/^(.*check)\.(answer|options\[\d+\])$/);
				if (m) (groups[m[1]] ??= []).push(path);
			}
			for (const [base] of Object.entries(groups)) {
				const answerEn = en[`${base}.answer`];
				if (answerEn === undefined) continue;
				const answer = tr[`${base}.answer`] ?? answerEn;
				const options = Object.keys(en)
					.filter((p) => p.startsWith(`${base}.options[`))
					.map((p) => tr[p] ?? en[p]);
				if (options.length && !options.includes(answer)) errors.push(`${id} ${base}: answer "${answer}" is not one of its options`);
			}
		}
	}
	const pct = coverage.total ? Math.round((coverage.have / coverage.total) * 100) : 0;
	console.log(`${level}: ${coverage.have}/${coverage.total} strings (${pct}%), ${Object.keys(overlay).length} text entries (${variants} with variants), ${errors.length} errors, ${flags.length} flags`);
	for (const e of errors) console.log('  ERROR', e);
	for (const f of flags.slice(0, 40)) console.log('  flag ', f);
	if (flags.length > 40) console.log(`  … ${flags.length - 40} more flags`);
	if (errors.length) {
		failed = true;
		continue;
	}
	if (!check && Object.keys(overlay).length) {
		mkdirSync(`assets/content/tr/${COURSE}`, { recursive: true });
		writeFileSync(`assets/content/tr/${COURSE}/${level}.json`, JSON.stringify({ ...exact, text: overlay }) + '\n');
	}
}
process.exit(failed ? 1 : 0);
