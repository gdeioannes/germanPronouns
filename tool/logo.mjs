// The one source of truth for the brand mark.
//
// A ring and a bar at 45°: the Q of "Quiz", and — because the bar leaves the
// ring the way a tail leaves a speech bubble — the "someone is talking" of a
// language course. Two shapes, two brand colours, no letterforms, so it holds
// together at 16px in a browser tab as well as it does on a share card.
//
// Everything is drawn in a 64×64 box centred on (32, 32), and it fills that
// box: a mark held timidly in the middle loses its counter at favicon sizes.
// The maskable icon gets its clearance by sitting the same drawing on a
// roomier tile instead, so nothing is redrawn to satisfy a launcher.
//
// The bar starts well inside the bowl and clears the ring by only a little.
// That ratio is the whole trick: a bar that starts outside the ring is a
// magnifying glass, and a bar that never leaves it is a no-entry sign.
//
// `npm run logo` renders the PNGs from here; Logo.svelte hand-mirrors the same
// geometry so the nav can draw it inline as vector. Change the shape here and
// in that component together.

export const NAVY = '#1f3a5f';
export const TERRACOTTA = '#c9683b';
export const PAPER = '#fbf8f3';

const RING = { cx: 32, cy: 32, r: 23.5, w: 9 };
const TAIL = { x1: 37.5, y1: 37.5, x2: 54, y2: 54, w: 8 };

/**
 * The bare mark, no background.
 * @param {{ ring?: string, tail?: string }} colors
 */
export function markShapes({ ring = NAVY, tail = TERRACOTTA } = {}) {
	return `<circle cx="${RING.cx}" cy="${RING.cy}" r="${RING.r}" fill="none" stroke="${ring}" stroke-width="${RING.w}"/>
  <path d="M${TAIL.x1} ${TAIL.y1}L${TAIL.x2} ${TAIL.y2}" stroke="${tail}" stroke-width="${TAIL.w}" stroke-linecap="butt"/>`;
}

/**
 * The mark as a standalone SVG document.
 * @param {{ size?: number, ring?: string, tail?: string }} opts
 */
export function markSvg({ size = 64, ...colors } = {}) {
	return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 64 64" role="img" aria-label="Language Quiz">
  ${markShapes(colors)}
</svg>`;
}

/**
 * The app icon: the mark reversed out of a navy tile.
 *
 * The tile is sized in the same 64-unit artwork units, so `box` is really a
 * padding dial — the bigger the tile, the smaller the mark sits inside it.
 * A launcher crops the corners off a maskable icon, so that one runs widest
 * and square; a favicon has 16 pixels to work with, so it runs tightest.
 *
 * @param {{ size?: number, maskable?: boolean, box?: number }} opts
 */
export function iconSvg({ size = 512, maskable = false, box = maskable ? 80 : 76 } = {}) {
	const offset = (box - 64) / 2;
	return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${box} ${box}">
  <rect width="${box}" height="${box}" rx="${maskable ? 0 : box * 0.22}" fill="${NAVY}"/>
  <g transform="translate(${offset} ${offset})">
    ${markShapes({ ring: PAPER, tail: TERRACOTTA })}
  </g>
</svg>`;
}
