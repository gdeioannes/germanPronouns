// Cuts a long text into pages that each fit one screen, so a reading passage
// or a cloze becomes a few sections to move through instead of a scroll.
//
// Breaks are taken at the most natural boundary that works: between
// paragraphs first, then between lines (a dialogue's turns), then between
// sentences. A text is never cut mid-sentence, so a page can run over the
// budget when one sentence alone does.

/** Characters per page: about a phone screen of serif prose. */
export const PAGE_BUDGET = 520;

export type ClozePart = { text: string } | { blank: number };

const BOUNDARIES = [/(\n[ \t]*\n\s*)/, /(\n)/, /([.!?…]["»“”)]?[ \t]+)/];

/**
 * What a stretch of text costs on the page, in characters. Without a line
 * width it is just its length. With one, a line that ends in a line break
 * takes a whole line however short it is — an address block of five short
 * lines is as tall as five full lines of prose, and a blank line costs a line.
 */
export function textCost(text: string, lineWidth?: number): number {
	if (!lineWidth) return text.length;
	const lines = text.split('\n');
	let cost = 0;
	lines.forEach((line, i) => {
		if (i === lines.length - 1) cost += line.length;
		else cost += Math.max(1, Math.ceil(line.length / lineWidth)) * lineWidth;
	});
	return cost;
}

/** Splits `text` at `pattern`, keeping each separator on the piece before it. */
function splitKeeping(text: string, pattern: RegExp): string[] {
	const raw = text.split(pattern);
	const out: string[] = [];
	for (let i = 0; i < raw.length; i += 2) {
		const piece = raw[i] + (raw[i + 1] ?? '');
		if (piece) out.push(piece);
	}
	return out;
}

/**
 * Units small enough to pack: the text broken at the first boundary kind,
 * with any piece still over budget broken again at the next kind.
 */
function units(text: string, budget: number, lineWidth?: number, level = 0): string[] {
	if (textCost(text, lineWidth) <= budget || level >= BOUNDARIES.length) return [text];
	return splitKeeping(text, BOUNDARIES[level]).flatMap((piece) =>
		units(piece, budget, lineWidth, level + 1)
	);
}

/** Greedily fills pages with units, never leaving a page empty. */
function pack<T>(items: T[], size: (item: T) => number, budget: number): T[][] {
	const pages: T[][] = [];
	let page: T[] = [];
	let used = 0;
	for (const item of items) {
		const n = size(item);
		if (page.length > 0 && used + n > budget) {
			pages.push(page);
			page = [];
			used = 0;
		}
		page.push(item);
		used += n;
	}
	if (page.length) pages.push(page);
	return pages;
}

/**
 * A passage as pages of text; a short one stays a single page. `lineWidth`
 * (characters per displayed line) makes line breaks cost what they take.
 */
export function paginate(text: string, budget = PAGE_BUDGET, lineWidth?: number): string[] {
	const pages = pack(units(text, budget, lineWidth), (unit) => textCost(unit, lineWidth), budget);
	return pages.map((page) => page.join('').trim()).filter(Boolean);
}

/**
 * A cloze template (text with blanks in it) as pages. Blanks are never
 * separated from the text around them except at a boundary, and a blank
 * counts as `blankSize` characters — it takes a field and a hint line.
 */
export function paginateCloze(
	parts: ClozePart[],
	budget = PAGE_BUDGET,
	blankSize = 24,
	lineWidth?: number
): ClozePart[][] {
	const size = (part: ClozePart) => ('text' in part ? textCost(part.text, lineWidth) : blankSize);
	const segmentSize = (segment: ClozePart[]) => segment.reduce((n, part) => n + size(part), 0);
	if (segmentSize(parts) <= budget) return [parts];

	// Segments: runs of parts between boundaries — paragraphs, and any still
	// over budget broken again at lines, then sentences.
	function segments(run: ClozePart[], level: number): ClozePart[][] {
		if (segmentSize(run) <= budget || level >= BOUNDARIES.length) return [run];
		const pattern = BOUNDARIES[level];
		const out: ClozePart[][] = [[]];
		for (const part of run) {
			if (!('text' in part)) {
				out[out.length - 1].push(part);
				continue;
			}
			const pieces = splitKeeping(part.text, pattern);
			pieces.forEach((piece, i) => {
				out[out.length - 1].push({ text: piece });
				// A piece that ended on a separator closes its segment.
				const ends = i < pieces.length - 1 || new RegExp(`${pattern.source}$`).test(piece);
				if (ends) out.push([]);
			});
		}
		return out
			.filter((segment) => segment.length > 0)
			.flatMap((segment) => segments(segment, level + 1));
	}

	return pack(segments(parts, 0), segmentSize, budget).map((page) => trimPage(page.flat()));
}

/** Drops the whitespace a page would otherwise start or end on. */
function trimPage(page: ClozePart[]): ClozePart[] {
	const out = [...page];
	const first = out[0];
	if (first && 'text' in first) out[0] = { text: first.text.trimStart() };
	const lastIndex = out.length - 1;
	const last = out[lastIndex];
	if (last && 'text' in last) out[lastIndex] = { text: last.text.trimEnd() };
	return out.filter((part) => !('text' in part) || part.text.length > 0);
}
