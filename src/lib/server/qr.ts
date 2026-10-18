// QR codes as inline SVG, for the printed books. Vector, so they print crisp
// at any size; ink-navy on nothing, so they sit on the paper like the rest.
//
// Drawn as filled squares, not the library's stroked lines: Chrome's print
// path leaves hairline gaps between stroked rows, and a code with gaps in it
// does not scan. The squares overlap by a hair so no seam can appear.

import QRCode from 'qrcode';

const cache = new Map<string, string>();

/** Quiet zone in modules: the codes sit next to text on the page. */
const MARGIN = 2;

export async function qrSvg(url: string): Promise<string> {
	const hit = cache.get(url);
	if (hit) return hit;
	const code = QRCode.create(url, { errorCorrectionLevel: 'M' });
	const size = code.modules.size;
	const data = code.modules.data;
	const total = size + MARGIN * 2;
	let d = '';
	for (let y = 0; y < size; y++) {
		for (let x = 0; x < size; x++) {
			if (!data[y * size + x]) continue;
			d += `M${x + MARGIN} ${y + MARGIN}h1.04v1.04h-1.04z`;
		}
	}
	const svg =
		`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${total} ${total}" shape-rendering="crispEdges" role="img" aria-label="QR code">` +
		`<path fill="#1f3a5f" d="${d}"/></svg>`;
	cache.set(url, svg);
	return svg;
}
