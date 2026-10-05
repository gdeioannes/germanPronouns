// The Kiez around Maya's U-Bahn stop, drawn in code in the story palette
// (ligne claire: ink-navy outlines, flat fills) so every label is real,
// tappable German instead of model-mangled text. Episodes reference its
// places and walk nodes by id; the layout is fixed so the directions in
// ep0's pools ("links, dann geradeaus" …) really lead to their street.

/** Walk junctions. Maya always starts at the square facing north (up). */
export const NODES: Record<string, { x: number; y: number }> = {
	P: { x: 200, y: 215 },
	W1: { x: 115, y: 215 },
	W2: { x: 32, y: 215 },
	E1: { x: 285, y: 215 },
	E2: { x: 370, y: 215 },
	N1: { x: 200, y: 150 },
	N2: { x: 112, y: 150 }
};

export type PlaceId =
	| 'bahnhof'
	| 'platz'
	| 'baeckerei'
	| 'park'
	| 'bruecke'
	| 'fernsehturm'
	| 'linden'
	| 'garten'
	| 'berg'
	| 'schul'
	| 'lessing'
	| 'goethe'
	| 'brunnen';

/** Tap targets: centre + generous radius (fingers, not mice). */
export const PLACES: Record<PlaceId, { x: number; y: number; r: number; de: string }> = {
	bahnhof: { x: 166, y: 244, r: 16, de: 'Bahnhof' },
	platz: { x: 200, y: 215, r: 18, de: 'Platz' },
	baeckerei: { x: 240, y: 246, r: 16, de: 'Bäckerei' },
	park: { x: 290, y: 183, r: 20, de: 'Park' },
	bruecke: { x: 200, y: 94, r: 18, de: 'Brücke' },
	fernsehturm: { x: 228, y: 38, r: 22, de: 'Fernsehturm' },
	linden: { x: 72, y: 215, r: 22, de: 'Lindenstraße' },
	garten: { x: 328, y: 215, r: 22, de: 'Gartenstraße' },
	berg: { x: 156, y: 150, r: 20, de: 'Bergstraße' },
	schul: { x: 200, y: 272, r: 18, de: 'Schulstraße' },
	// Same-initial decoys, so the smudged note has to be READ, not matched
	// by first letter: Lessing/Linden (west), Goethe/Garten (east),
	// Brunnen/Berg (north) — each pair on the same walk.
	lessing: { x: 155, y: 212, r: 14, de: 'Lessingstraße' },
	goethe: { x: 250, y: 212, r: 14, de: 'Goethestraße' },
	brunnen: { x: 345, y: 150, r: 16, de: 'Brunnenstraße' }
};

/** Where each street's name is written (street id → label anchor). */
export const STREET_LABELS: { id: PlaceId; x: number; y: number; rotate?: number }[] = [
	{ id: 'linden', x: 70, y: 218.5 },
	{ id: 'lessing', x: 142, y: 218.5 },
	{ id: 'goethe', x: 252, y: 218.5 },
	{ id: 'garten', x: 330, y: 218.5 },
	{ id: 'berg', x: 155, y: 153.5 },
	{ id: 'brunnen', x: 330, y: 153.5 },
	{ id: 'schul', x: 200, y: 265, rotate: -90 }
];
