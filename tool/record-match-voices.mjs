// Records every missing "Schreib mir!" voice clip, easiest module first, on
// the free Gemini quotas: the pro TTS model until its daily quota is spent,
// then the flash model (its own quota), then — with --wait — an hourly retry
// until nothing is missing. Missing clips fall back to the app voice in the
// meantime, so this can run over several days.
//
//   node tool/record-match-voices.mjs          one pass over both quotas
//   node tool/record-match-voices.mjs --wait   keep going until every clip exists

import { spawnSync } from 'node:child_process';
import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const DIR = join(root, 'assets', 'content', 'match');
const LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
// --pro-only: the pro model only (e.g. a paid run with TTS_BUDGET_USD set).
// --flash-only: the flash model only (cheaper, bigger daily quota).
const MODELS = process.argv.includes('--pro-only')
	? ['gemini-2.5-pro-preview-tts']
	: process.argv.includes('--flash-only')
		? ['gemini-2.5-flash-preview-tts']
		: ['gemini-2.5-pro-preview-tts', 'gemini-2.5-flash-preview-tts'];
const wait = process.argv.includes('--wait');

const chats = readdirSync(DIR)
	.filter((f) => f.endsWith('.json'))
	.map((f) => JSON.parse(readFileSync(join(DIR, f), 'utf8')))
	.sort((a, b) => LEVELS.indexOf(a.level) - LEVELS.indexOf(b.level) || (a.order ?? 50) - (b.order ?? 50));

/** Clips still missing for one chat (the audio tool's dry run lists them). */
function missing(id) {
	const r = spawnSync('node', ['tool/gen-story-audio.mjs', id, '--dry'], { cwd: root, encoding: 'utf8' });
	return (r.stdout.match(/^mc_/gm) ?? []).length;
}

function pass() {
	for (const model of MODELS) {
		let quotaGone = false;
		for (const chat of chats) {
			if (missing(chat.id) === 0) continue;
			console.log(`\n== ${chat.id} (${chat.level}) on ${model}`);
			const r = spawnSync('node', ['tool/gen-story-audio.mjs', chat.id, '--gemini-api', '--stop-on-quota'], {
				cwd: root,
				stdio: 'inherit',
				env: { ...process.env, GEMINI_TTS_MODEL: model }
			});
			if (r.status === 2) {
				quotaGone = true;
				break;
			}
			if (r.status === 3) {
				console.log('Budget reached. Stopping.');
				process.exit(3);
			}
		}
		if (!quotaGone) return true; // everything this model could do is done
	}
	return false;
}

for (;;) {
	const left = chats.reduce((n, c) => n + missing(c.id), 0);
	console.log(`\n${left} clips missing.`);
	if (left === 0) break;
	const finished = pass();
	if (finished && chats.every((c) => missing(c.id) === 0)) break;
	if (!wait) break;
	console.log('\nBoth quotas spent. Trying again in an hour.');
	await new Promise((r) => setTimeout(r, 60 * 60 * 1000));
}
console.log('\nDone for now.');
