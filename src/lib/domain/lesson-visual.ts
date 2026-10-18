// The lesson diagrams' geometry and their data check. Pure, so the content
// gate test can validate every `tip.visual` in the course against the same
// rules the renderer (components/lesson/LessonVisual.svelte) relies on.

import type { LessonVisual, TreeNode } from '$lib/content/types';

/** Every diagram kind the renderer draws. */
export const VISUAL_KINDS: readonly string[] = [
	'bracket',
	'caseGrid',
	'people',
	'timeline',
	'scale',
	'tree',
	'pairs',
	'blocks',
	'clock',
	'places',
	'moves',
	'textMap',
	'pictures'
];

const SPOTS = ['on', 'under', 'in', 'over', 'beside', 'front', 'behind', 'between', 'at'];
const MODES = ['wo', 'wohin', 'woher'];
const ROLES = ['stem', 'prefix', 'suffix', 'ending', 'joint', 'gone'];

/** A timeline position (-3 … 3) as a percentage across the axis. */
export function timelineX(at: number): number {
	const clamped = Math.max(-3, Math.min(3, at));
	return 6 + ((clamped + 3) / 6) * 88;
}

/**
 * Gives each timeline mark a label row so neighbouring labels never sit on
 * top of each other: a mark takes the first row whose last label is far
 * enough to the left.
 */
export function spread<T extends { at: number; to?: number }>(marks: T[]): (T & { row: number })[] {
	const order = marks
		.map((m, i) => ({ m, i, x: timelineX(m.to !== undefined ? (m.at + m.to) / 2 : m.at) }))
		.sort((a, b) => a.x - b.x);
	const lastX: number[] = [];
	const rows: number[] = [];
	for (const { i, x } of order) {
		let row = lastX.findIndex((last) => x - last >= 44);
		if (row === -1) row = lastX.length;
		lastX[row] = x;
		rows[i] = row;
	}
	return marks.map((m, i) => ({ ...m, row: rows[i] }));
}

/** Hand angles (degrees from 12) and the shaded minute wedge for "H:MM". */
export function clockHands(time: string): { hourAngle: number; minuteAngle: number; minute: number; wedge: string } {
	const [h, m] = time.split(':').map(Number);
	const minute = m || 0;
	const minuteAngle = minute * 6;
	const hourAngle = ((h % 12) + minute / 60) * 30;
	const r = 40;
	const rad = ((minuteAngle - 90) * Math.PI) / 180;
	const x = 50 + r * Math.cos(rad);
	const y = 50 + r * Math.sin(rad);
	const large = minuteAngle > 180 ? 1 : 0;
	const wedge = `M50 50 L50 ${50 - r} A${r} ${r} 0 ${large} 1 ${x.toFixed(2)} ${y.toFixed(2)} Z`;
	return { hourAngle, minuteAngle, minute, wedge };
}

function treeProblems(node: TreeNode | undefined, path: string): string[] {
	if (!node) return [`${path}: missing branch`];
	if (node.answer) return node.q ? [`${path}: a leaf cannot also ask`] : [];
	if (!node.q) return [`${path}: neither question nor answer`];
	return [...treeProblems(node.yes, `${path}.yes`), ...treeProblems(node.no, `${path}.no`)];
}

/** What is wrong with a visual's data, or an empty list when it will draw. */
export function visualProblems(v: LessonVisual): string[] {
	const out: string[] = [];
	if (!VISUAL_KINDS.includes(v.kind)) return [`unknown visual kind "${(v as { kind: string }).kind}"`];
	switch (v.kind) {
		case 'bracket': {
			const n = v.columns?.length ?? 4;
			if (!v.rows?.length) out.push('bracket: no rows');
			v.rows?.forEach((r, i) => {
				if (r.cells.length > n) out.push(`bracket row ${i}: ${r.cells.length} cells for ${n} columns`);
				if (!r.cells.some(Boolean)) out.push(`bracket row ${i}: empty`);
			});
			v.hot?.forEach((c) => c >= n && out.push(`bracket: hot column ${c} out of range`));
			break;
		}
		case 'caseGrid': {
			const n = v.columns?.length ?? 4;
			if (!v.rows?.length) out.push('caseGrid: no rows');
			v.rows?.forEach((r, i) => r.cells.length !== n && out.push(`caseGrid row ${i}: ${r.cells.length} cells for ${n} columns`));
			v.hot?.forEach(([r, c]) => (r >= (v.rows?.length ?? 0) || c >= n) && out.push(`caseGrid: hot cell ${r},${c} out of range`));
			break;
		}
		case 'people': {
			const n = v.persons?.length ?? 6;
			if (!v.columns?.length) out.push('people: no columns');
			v.columns?.forEach((c) => c.forms.length !== n && out.push(`people "${c.label}": ${c.forms.length} forms for ${n} persons`));
			v.hot?.forEach((r) => r >= n && out.push(`people: hot row ${r} out of range`));
			break;
		}
		case 'timeline':
			if (!v.marks?.length) out.push('timeline: no marks');
			v.marks?.forEach((m, i) => {
				if (Math.abs(m.at) > 3 || (m.to !== undefined && Math.abs(m.to) > 3)) out.push(`timeline mark ${i}: outside -3 … 3`);
				if (!m.label) out.push(`timeline mark ${i}: no label`);
			});
			break;
		case 'scale':
			if (!v.points?.length) out.push('scale: no points');
			v.points?.forEach((p, i) => (p.at < 0 || p.at > 100) && out.push(`scale point ${i}: outside 0 … 100`));
			break;
		case 'tree':
			out.push(...treeProblems(v.root, 'tree'));
			break;
		case 'pairs':
			if (!v.rows?.length) out.push('pairs: no rows');
			v.rows?.forEach((r, i) => (!r.a || !r.b) && out.push(`pairs row ${i}: missing a side`));
			break;
		case 'blocks':
			if (!v.rows?.length) out.push('blocks: no rows');
			v.rows?.forEach((r, i) => {
				if (!r.parts?.length || !r.result) out.push(`blocks row ${i}: needs parts and a result`);
				r.parts?.forEach((p) => p.role && !ROLES.includes(p.role) && out.push(`blocks row ${i}: unknown role ${p.role}`));
			});
			break;
		case 'clock':
			if (!v.faces?.length) out.push('clock: no faces');
			v.faces?.forEach((f, i) => !/^\d{1,2}:\d{2}$/.test(f.time) && out.push(`clock face ${i}: time "${f.time}" is not H:MM`));
			break;
		case 'places':
			if (!v.items?.length) out.push('places: no items');
			v.items?.forEach((it, i) => {
				if (!SPOTS.includes(it.spot)) out.push(`places item ${i}: unknown spot ${it.spot}`);
				if (!MODES.includes(it.mode)) out.push(`places item ${i}: unknown mode ${it.mode}`);
			});
			break;
		case 'moves':
			if (!v.moves?.length) out.push('moves: no moves');
			v.moves?.forEach((m, i) => (!m.label || !m.de?.length) && out.push(`moves ${i}: needs a label and phrases`));
			break;
		case 'pictures':
			if (!v.items?.length) out.push('pictures: no items');
			v.items?.forEach((it, i) => {
				if (!it.de) out.push(`pictures item ${i}: no German`);
				if (!it.image === !it.color) out.push(`pictures item ${i}: needs exactly one of image or color`);
				if (it.color && !/^#[0-9a-f]{6}$/i.test(it.color)) out.push(`pictures item ${i}: color must be #rrggbb`);
			});
			break;
		case 'textMap':
			if (!v.blocks?.length) out.push('textMap: no blocks');
			v.blocks?.forEach((b, i) => {
				if (!b.label || !b.de) out.push(`textMap block ${i}: needs a label and text`);
				b.focus?.forEach((f) => !b.de.includes(f) && out.push(`textMap block ${i}: focus "${f}" not in the text`));
			});
			break;
	}
	return out;
}
