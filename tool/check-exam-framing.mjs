#!/usr/bin/env node
// Lists Help Memory prose that frames learning around the exam or the level
// ladder instead of the language. The course teaches German; the certificate
// is a side goal, so:
//   - exercise help never names exam task numbers (Hören Teil 2, …);
//   - only skill exercises (Hören/Lesen/Schreiben/Sprechen/Gespräch/Diktat)
//     carry the one-line `exam` note, and only there may exams or CEFR levels
//     be mentioned;
//   - everywhere else the reason to learn something is the language itself.
//
//   node tool/check-exam-framing.mjs de_cert_a1 [module ...]
import { readFileSync, readdirSync } from 'node:fs';
import { resolve, join } from 'node:path';

const [courseId, ...modules] = process.argv.slice(2);
const dir = join(resolve(import.meta.dirname, '..'), 'assets/content/authoring', courseId ?? 'de_cert_a1');
const files = (modules.length ? modules.map((m) => `${m}.json`) : readdirSync(dir)).filter((f) => f.endsWith('.json')).sort();

export const SKILL = /^(Hören|Lesen|Schreiben|Sprechen|Gespräch|Diktat)\b/;
const TASK = /\bTeil\s*\d|\b\d\s*Teile\b|\bTeile\b\)/;
const EXAM = /\b(exam|exams|examiner|examiners|certificate|certification|Prüfungsteil)\b/i;
const LEVEL = /\b(A1|A2|B1|B2|C1|C2)(\.[12])?\b/;

let problems = 0;
for (const file of files) {
	for (const e of JSON.parse(readFileSync(join(dir, file), 'utf8'))) {
		const h = e.help ?? e.quiz?.help;
		if (!h) continue;
		const skill = SKILL.test(e.title ?? '');
		const prose = [
			['intro', h.intro],
			...(h.remember ?? []).map((r, i) => [`remember[${i}]`, r]),
			...(h.tips ?? []).flatMap((t, i) => [
				[`tips[${i}].title`, t.title],
				[`tips[${i}].text`, t.text],
				[`tips[${i}].trap`, t.trap],
				...(t.examples ?? []).flatMap((x, j) => [[`tips[${i}].examples[${j}]`, `${x.de} / ${x.en}`]])
			]),
			['table.caption', h.table?.caption],
			...(h.table?.columns ?? []).map((c, i) => [`table.columns[${i}]`, c]),
			...(h.mistakes ?? []).flatMap((m, i) => [[`mistakes[${i}]`, `${m.wrong} / ${m.right} / ${m.why}`]])
		];
		const say = (where, why, text) => {
			problems++;
			console.log(`${file} ${e.id} ${where}: ${why}\n    ${String(text).slice(0, 220)}`);
		};
		for (const [where, text] of prose) {
			if (typeof text !== 'string') continue;
			// German example sentences may talk about a real Prüfung; only the
			// English prose is held to the rule.
			const isExample = where.includes('examples') || where.startsWith('mistakes');
			if (TASK.test(text)) say(where, 'exam task number', text);
			else if (!isExample && EXAM.test(text)) say(where, 'exam framing', text);
			else if (LEVEL.test(text) && !(isExample && /Deutsch(kurs)? [ABC][12]/.test(text))) say(where, 'level reference', text);
		}
		for (const t of h.tips ?? []) if (t.kind === 'exam') say('tips', 'tip kind "exam"', t.title);
		if (skill && !h.exam) say('exam', 'skill exercise without an exam note', e.title);
		if (!skill && h.exam) say('exam', 'exam note on a non-skill exercise', h.exam);
		if (h.exam && TASK.test(h.exam)) say('exam', 'exam task number', h.exam);
	}
}
console.log(problems ? `\n${problems} problem(s)` : 'clean');
process.exitCode = problems ? 1 : 0;
