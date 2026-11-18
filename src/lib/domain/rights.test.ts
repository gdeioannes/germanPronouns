import { describe, expect, it } from 'vitest';
import { ALLOWED, audit, commonsCredits } from '../../../tool/rights-audit.mjs';
import commons from '../../../assets/rights/commons.json';
import review from '../../../assets/rights/review.json';

// The rights audit (docs/rights_audit.md): every picture the site and the
// books ship is traced to its source, every photo licence allows commercial
// use, and no photo the zero-doubt review rejected is still used.
type Row = { file: string; source: string };

describe('rights audit', () => {
	const { rows } = audit() as { rows: Row[] };

	it('traces every shipped picture to a Commons photo, a Gemini prompt or our own work', () => {
		expect(rows.filter((r) => r.source === 'unknown').map((r) => r.file)).toEqual([]);
	});

	it('only uses photo licences that allow commercial use and changes', () => {
		const bad = Object.entries(commonsCredits() as Record<string, { license: string }>).filter(([, c]) => !ALLOWED.test(c.license));
		expect(bad.map(([id, c]) => `${id}: ${c.license}`)).toEqual([]);
	});

	it('matches every licence we print with what Wikimedia Commons publishes for the file', () => {
		const ours = commonsCredits() as Record<string, { license: string }>;
		const theirs = commons as Record<string, { license: string; found: boolean }>;
		const bad = Object.keys(ours).filter((id) => !theirs[id]?.found || theirs[id].license !== ours[id].license);
		expect(bad).toEqual([]);
	});

	it('no longer uses any Commons file the zero-doubt review rejected', () => {
		// The review names the rejected file; the id that credited it may live
		// on with another photo (a quiz keeps its id), but never with that file.
		const banned = new Set(
			Object.values((review as { photos: Record<string, { decision: string; file: string }> }).photos)
				.filter((d) => d.decision === 'replace')
				.map((d) => d.file.replace(/^File:/, ''))
		);
		const fileOf = (src: string) => decodeURIComponent(src.replace(/^.*\/wiki\/File:/, '')).replace(/_/g, ' ');
		const still = Object.entries(commonsCredits() as Record<string, { source: string }>)
			.filter(([, c]) => banned.has(fileOf(c.source)))
			.map(([id, c]) => `${id}: ${fileOf(c.source)}`);
		expect(still).toEqual([]);
	});
});
