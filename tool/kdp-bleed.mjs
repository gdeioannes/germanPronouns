#!/usr/bin/env node
// KDP wants an interior whose pictures run to the edge printed with bleed: each
// page 0.125 in (3.175 mm) wider on the outer edge and 0.125 in taller at top
// and bottom, so A4 (210 × 297 mm) becomes 213.175 × 303.35 mm. The trimmer
// then cuts the extra away.
//
//   node tool/kdp-bleed.mjs <interior.pdf> <out.pdf>
//
// Each A4 page is placed on the bigger sheet at its trim position (inner edge
// flush with the spine side). Behind it goes a copy of the same page, enlarged
// from the spine edge just enough to fill the bleed, so a full-bleed photo or the
// chapter's coloured edge tab carries on into the part that is cut off. Page 1
// is a right-hand page, so odd pages bleed to the right and even ones to the left.
import { readFileSync, writeFileSync } from 'node:fs';
import { PDFDocument } from 'pdf-lib';

const [src, out] = process.argv.slice(2);
if (!src || !out) throw new Error('usage: kdp-bleed.mjs <interior.pdf> <out.pdf>');

const MM = 72 / 25.4;
const BLEED = 3.175 * MM;
const doc = await PDFDocument.load(readFileSync(src));
const outDoc = await PDFDocument.create();
const embedded = await outDoc.embedPdf(doc, doc.getPageIndices());

embedded.forEach((page, i) => {
	const w = page.width;
	const h = page.height;
	const W = w + BLEED;
	const H = h + 2 * BLEED;
	const sheet = outDoc.addPage([W, H]);
	const right = i % 2 === 0; // page 1, 3, 5 … are right-hand pages
	// The trim box sits flush with the spine edge, BLEED up from the bottom.
	const x = right ? 0 : BLEED;
	// Underlay: scaled from the spine edge's middle so it covers the outer and
	// top/bottom bleed.
	const s = Math.max((w + BLEED) / w, (h + 2 * BLEED) / h);
	const uw = w * s;
	const uh = h * s;
	sheet.drawPage(page, { x: right ? 0 : W - uw, y: (H - uh) / 2, width: uw, height: uh });
	sheet.drawPage(page, { x, y: BLEED, width: w, height: h });
	sheet.setTrimBox(x, BLEED, w, h);
	sheet.setBleedBox(0, 0, W, H);
});

writeFileSync(out, await outDoc.save());
console.log(`${out}: ${embedded.length} pages, ${(213.175).toFixed(3)} × ${(303.35).toFixed(2)} mm`);
