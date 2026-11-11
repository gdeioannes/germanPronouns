#!/usr/bin/env node
// What still reads as English in a second language (--lang ar; Turkish by default): applies each level's overlay to
// its exercises (as the app does) and lists strings with English words left.
//   node tool/turkish/leftovers.mjs [a1_1 …]
import { LANG, LEVELS, COURSE, levelName, plainArgs, readJson } from './lib.mjs';

const EN = /(?<!\p{L})(the|and|with|your|you|this|that|these|from|is|are|was|were|what|which|who|when|where|it|its|not|for|of|to)(?!\p{L})/giu;
const parse = (p) => [...p.matchAll(/\[("(?:[^"\\]|\\.)*")\]|\[(\d+)\]|([^.[\]]+)/g)].map((m) => (m[1] ? JSON.parse(m[1]) : m[2] ? Number(m[2]) : m[3]));
const bundle = readJson(`assets/content/courses/${COURSE}.json`);
for (const level of plainArgs().length ? plainArgs() : LEVELS) {
	const overlay = readJson(`assets/content/${LANG}/${COURSE}/${level}.json`);
	let hits = 0;
	for (const quiz of bundle.quizzes.filter((q) => q.level === levelName(level))) {
		const q = structuredClone(quiz);
		for (const [path, [en, tr]] of Object.entries(overlay.quizzes[quiz.id] ?? {})) {
			const keys = parse(path);
			let at = q;
			for (const k of keys.slice(0, -1)) at = at?.[k];
			if (at && at[keys.at(-1)] === en) at[keys.at(-1)] = tr;
		}
		const walk = (o, p, key) => {
			if (typeof o === 'string') {
				const t = overlay.text[o] ?? o;
				if (/^(id|image|storageKeyPrefix|type|level|covers|kind|scene|sourceQuizId|subjectKey|imageDescription)$/.test(key)) return;
				if ((t.match(EN) ?? []).length >= 2) {
					hits++;
					if (hits <= 25) console.log(`${level} ${quiz.id} ${p}: ${t.slice(0, 90)}`);
				}
			} else if (Array.isArray(o)) o.forEach((v, i) => walk(v, `${p}[${i}]`, key));
			else if (o && typeof o === 'object') for (const [k, v] of Object.entries(o)) walk(v, p ? `${p}.${k}` : k, k);
		};
		walk(q, '', '');
	}
	console.log(`${level}: ${hits} English-looking strings left`);
}
