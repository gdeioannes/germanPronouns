#!/usr/bin/env node
// One-off, safe to re-run: renames keys in tool/turkish/tr/**.json that were
// written before keys holding a dot got the `["key"]` form, to match the
// English file next to them. Run after extract.mjs.
import { existsSync, readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const legacy = (path) => path.replace(/\["((?:[^"\\]|\\.)*)"\]/g, (m, k) => `.${JSON.parse(`"${k}"`)}`).replace(/^\./, '');
let renamed = 0;
(function walk(dir) {
	for (const f of readdirSync(dir)) {
		const p = join(dir, f);
		if (statSync(p).isDirectory()) walk(p);
		else if (f.endsWith('.json')) {
			const enPath = p.replace(/tool[\\/]turkish[\\/]tr/, 'tool/turkish/en');
			if (!existsSync(enPath)) continue;
			const en = JSON.parse(readFileSync(enPath, 'utf8'));
			const tr = JSON.parse(readFileSync(p, 'utf8'));
			const byLegacy = new Map(Object.keys(en).filter((k) => k.includes('["')).map((k) => [legacy(k), k]));
			let changed = false;
			const out = {};
			for (const [k, v] of Object.entries(tr)) {
				const now = !(k in en) && byLegacy.get(k);
				if (now) {
					out[now] = v;
					changed = true;
					renamed++;
				} else out[k] = v;
			}
			if (changed) writeFileSync(p, JSON.stringify(out, null, 1));
		}
	}
})('tool/turkish/tr');
console.log(`${renamed} keys renamed`);
