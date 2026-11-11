#!/usr/bin/env node
// Merges tool/turkish/tr/dictionary/part-*.json into
// assets/content/tr/dictionary.de.json  { "<de>|<pos>": "<Turkish gloss>" }.
// A key no longer in the dictionary is dropped with a note.
import { existsSync, readdirSync, writeFileSync } from 'node:fs';
import { readJson } from './lib.mjs';

const dict = readJson('assets/content/shared/dictionary/de.json');
const known = new Set(dict.entries.map((e) => `${e.de}|${e.pos}`));
const dir = 'tool/turkish/tr/dictionary';
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
writeFileSync('assets/content/tr/dictionary.de.json', JSON.stringify(out) + '\n');
console.log(`${Object.keys(out).length} Turkish glosses${stale ? `, ${stale} stale keys dropped` : ''}`);
