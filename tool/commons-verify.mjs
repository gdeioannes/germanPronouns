#!/usr/bin/env node
// Reads every credited Commons photo's licence data straight from Wikimedia
// Commons (the file page's structured metadata), so the credit we print is the
// one the author asked for, not a hand-copied one.
//
//   node tool/commons-verify.mjs     writes assets/rights/commons.json
//
// Per photo: the artist as plain text, the licence and its URL, whether the
// author asks for a specific attribution (Commons' "Attribution" field) and
// the exact text, and any extra terms the author wrote on the page (flagged for
// the zero-doubt review in docs/rights_audit.md).
import { readFileSync, writeFileSync } from 'node:fs';

const root = new URL('..', import.meta.url);
const read = (p) => JSON.parse(readFileSync(new URL(p, root), 'utf8'));
const credits = { ...read('assets/content/book2/de_cert_a1/_photos.json'), ...read('assets/content/chapters/de_cert_a1/_photos.json') };

const fileOf = (src) => decodeURIComponent(src.replace(/^.*\/wiki\/File:/, '')).replace(/_/g, ' ');
const strip = (html) =>
	String(html ?? '')
		.replace(/<[^>]+>/g, ' ')
		.replace(/&nbsp;/g, ' ')
		.replace(/&amp;/g, '&')
		.replace(/&quot;/g, '"')
		.replace(/&#039;/g, "'")
		.replace(/\s+/g, ' ')
		.trim();

const ids = Object.keys(credits);
const out = {};
const UA = 'GermanCourseRightsAudit/1.0 (rights audit of credited photos; contact via languagequiz.org)';
for (let i = 0; i < ids.length; i += 40) {
	const batch = ids.slice(i, i + 40);
	const titles = batch.map((id) => 'File:' + fileOf(credits[id].source));
	const url = 'https://commons.wikimedia.org/w/api.php?' + new URLSearchParams({ action: 'query', format: 'json', prop: 'imageinfo', iiprop: 'extmetadata|url', titles: titles.join('|'), formatversion: '2' });
	// Commons limits anonymous clients: wait and try again when it says so.
	let json = null;
	for (let tryNo = 0; tryNo < 8 && !json; tryNo++) {
		const res = await fetch(url, { headers: { 'User-Agent': UA } });
		const text = await res.text();
		try {
			json = JSON.parse(text);
		} catch {
			await new Promise((r) => setTimeout(r, 5000 * (tryNo + 1)));
		}
	}
	if (!json) throw new Error(`Commons refused batch at ${i}`);
	const byTitle = new Map();
	const norm = new Map((json.query?.normalized ?? []).map((n) => [n.from, n.to]));
	for (const p of json.query?.pages ?? []) byTitle.set(p.title, p);
	for (const id of batch) {
		const t = 'File:' + fileOf(credits[id].source);
		const page = byTitle.get(norm.get(t) ?? t);
		const m = page?.imageinfo?.[0]?.extmetadata ?? {};
		out[id] = {
			file: page?.title ?? t,
			pageid: page?.pageid ?? null,
			found: !!page && !page.missing,
			artist: strip(m.Artist?.value),
			credit: strip(m.Credit?.value),
			license: strip(m.LicenseShortName?.value),
			licenseUrl: strip(m.LicenseUrl?.value),
			attributionRequired: m.AttributionRequired?.value ?? null,
			attribution: strip(m.Attribution?.value) || null,
			usageTerms: strip(m.UsageTerms?.value),
			restrictions: strip(m.Restrictions?.value) || null,
			ours: { author: credits[id].author, license: credits[id].license }
		};
	}
	process.stdout.write(`\r${Math.min(i + 40, ids.length)} / ${ids.length}`);
	await new Promise((r) => setTimeout(r, 2500));
}
writeFileSync(new URL('assets/rights/commons.json', root), JSON.stringify(out, null, 1) + '\n');
console.log('\nwrote assets/rights/commons.json');
