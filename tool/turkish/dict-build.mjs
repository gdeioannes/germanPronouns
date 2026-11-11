#!/usr/bin/env node
// Merges tool/turkish/<lang>/dictionary/part-*.json into
// assets/content/<lang>/dictionary.de.json  { "<de>|<pos>": "<gloss>" }  (--lang ar; Turkish by default).
// A key no longer in the dictionary is dropped with a note.
import { existsSync, mkdirSync, readdirSync, writeFileSync } from 'node:fs';
import { LANG, readJson } from './lib.mjs';

const dict = readJson('assets/content/shared/dictionary/de.json');
const known = new Set(dict.entries.map((e) => `${e.de}|${e.pos}`));
const dir = `tool/turkish/${LANG}/dictionary`;
const out = {};
let stale = 0;
if (existsSync(dir))
	for (const f of readdirSync(dir).filter((f) => f.endsWith('.json')).sort())
		for (const [k, v] of Object.entries(readJson(`${dir}/${f}`))) {
			if (!known.has(k)) {
				stale++;
				continue;
			}
			if (typeof v === 'string' && v.trim()) out[k] = v.trim();
		}
mkdirSync(`assets/content/${LANG}`, { recursive: true });
writeFileSync(`assets/content/${LANG}/dictionary.de.json`, JSON.stringify(out) + '\n');
console.log(`${Object.keys(out).length} ${LANG} glosses${stale ? `, ${stale} stale keys dropped` : ''}`);
