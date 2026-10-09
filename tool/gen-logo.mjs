// Renders every file the brand mark has to exist as: the tab favicon, the
// PWA icons (plain and maskable), the Apple touch icon, and the two SVGs the
// site serves directly. All of them come out of tool/logo.mjs, so the mark is
// drawn once and never hand-traced again.
//
// Run `npm run logo` after changing the geometry or the palette. The outputs
// are committed, so the build does not depend on this.

import { Resvg } from '@resvg/resvg-js';
import { mkdirSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { iconSvg } from './logo.mjs';

const root = fileURLToPath(new URL('..', import.meta.url));

const png = (svg, size) =>
	new Resvg(svg, { fitTo: { mode: 'width', value: size } }).render().asPng();

const outputs = [
	// The tab icon is the tile, not the bare mark: at 16px a navy block is what
	// makes it findable in a row of pinned tabs, and it survives a dark tab bar
	// that a navy-on-nothing mark would vanish into. It runs tight, because the
	// padding an app icon needs would cost it the pixels it does not have.
	['static/favicon.png', png(iconSvg({ box: 68 }), 64)],
	['static/icons/Icon-192.png', png(iconSvg(), 192)],
	['static/icons/Icon-512.png', png(iconSvg(), 512)],
	['static/icons/Icon-maskable-192.png', png(iconSvg({ maskable: true }), 192)],
	['static/icons/Icon-maskable-512.png', png(iconSvg({ maskable: true }), 512)],
	['static/icons/apple-touch-icon.png', png(iconSvg(), 180)],
	// Served as-is: the tile for browsers that take an SVG favicon.
	['static/favicon.svg', Buffer.from(iconSvg({ size: 64, box: 68 }), 'utf8')]
];

mkdirSync(`${root}static/icons`, { recursive: true });
for (const [path, data] of outputs) {
	writeFileSync(`${root}${path}`, data);
	console.log(`${path} (${(data.length / 1024).toFixed(1)} KB)`);
}
