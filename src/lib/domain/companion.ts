// The study companion: a level's printed book written for paper, not printed
// from the app. Where the workbook (domain/workbook) lays every quiz out in
// the app's own order, the companion is authored: one topic per two-page
// spread — the left page teaches with schemas and pictures, the right page
// practises with things paper is good at (writing, matching, labelling) — and
// the answers at the back. A level that has a companion file prints it
// instead of the generated workbook; the PDF button doesn't change.
//
// Content: assets/content/companion/<course>/<level>.json, e.g. a1_1.json.
// The rules every book follows (schemas, gender colours, pictures, paper
// wording) are in docs/study_companion_guide.md.
// Text fields take two marks: *focus* (the bit to notice, accent + underline)
// and **bold**.

/** A piece of a built word: drei|zehn, sech|s|zehn with the s cut. */
export interface BuildPart {
	text: string;
	/** joint: und; suffix: the part that repeats (-zehn, -zig); cut: dropped letters, struck through. */
	role?: 'joint' | 'suffix' | 'cut';
}

export type LearnBlock =
	| {
			kind: 'tiles';
			title: string;
			note?: string;
			/** Columns of the grid (default 6). */
			cols?: number;
			/** Smaller tiles, for a grid that shares a row with another block. */
			small?: boolean;
			/** swatch: a colour patch under the word, for the colours. */
			tiles: { big: string; word: string; say?: string; mark?: boolean; swatch?: string }[];
	  }
	| {
			kind: 'build';
			title: string;
			note?: string;
			rows: { parts: BuildPart[]; result: string; en: string }[];
	  }
	| {
			/** A two-digit number read right to left: 47 → sieben-und-vierzig. */
			kind: 'flip';
			title: string;
			text: string;
			number: string;
			unit: string;
			ten: string;
			examples: { n: string; de: string; note?: string }[];
	  }
	| {
			kind: 'pairs';
			title: string;
			note?: string;
			rows: { a: string; b: string }[];
	  }
	| {
			kind: 'box';
			tone: 'watch' | 'culture' | 'tip';
			title: string;
			text: string;
			image?: string;
	  }
	| {
			/** A phrase table. Columns flagged `en` are English and set quieter. */
			kind: 'table';
			title: string;
			note?: string;
			/** Heads that read der, die, das or plural get the gender colours (blue, red, green). */
			genders?: boolean;
			head: { text: string; en?: boolean }[];
			rows: string[][];
	  }
	| {
			/** The words the practice page uses that the rest of the page doesn't teach. */
			kind: 'words';
			title: string;
			cols?: number;
			items: { de: string; en: string }[];
	  }
	| {
			/** A three-generation family tree of fixed shape; each person has a name and a family word. */
			kind: 'tree';
			title: string;
			note?: string;
			people: Record<FamilyRole, { name: string; word: string }>;
	  }
	| {
			/**
			 * Sentences cut into their places, one framed box per place: who | verb |
			 * what, or where nicht and the second verb go. `hot` places (0-based)
			 * are framed in the accent — the verb in second place, the end slot.
			 */
			kind: 'slots';
			title: string;
			note?: string;
			/** A label over each place (English). */
			head?: string[];
			hot?: number[];
			rows: { cells: SlotCell[]; en?: string }[];
	  }
	| {
			/** A yes/no decision drawn as a tree: follow the branches to the answer (kein or nicht?). */
			kind: 'flow';
			title: string;
			note?: string;
			root: FlowNode;
	  }
	| {
			/**
			 * Two inputs that each give a piece, joined into one word: the owner
			 * gives ihr, the thing gives -e → ihre Tasche.
			 */
			kind: 'merge';
			title: string;
			note?: string;
			/** English labels of the two inputs (owner, thing). */
			labels: [string, string];
			rows: { a: string; aTo: string; b: string; bTo: string; result: string; en?: string }[];
	  }
	| {
			/** Who does it, an arrow with the verb, and who or what it happens to; `ask` labels the two ends (wer? wen?). */
			kind: 'arrow';
			title: string;
			note?: string;
			ask?: [string, string];
			rows: { who: string; verb: string; whom: string; en?: string }[];
	  }
	| {
			/**
			 * Clock faces, each with its hands, the digits and the German. `dial`
			 * first draws the guide: nach on the right, vor on the left, halb at the
			 * bottom (heading for the next hour).
			 */
			kind: 'clock';
			title: string;
			note?: string;
			dial?: boolean;
			/** Faces per row (default 4). */
			cols?: number;
			clocks: { time: string; de: string; mark?: boolean }[];
	  }
	| {
			/**
			 * Time words on a line with now in the middle (−4 … 4): a dot for a
			 * moment (vor zwei Jahren, in einer Woche), a bar for a stretch (seit,
			 * für). One row per mark.
			 */
			kind: 'timeline';
			title: string;
			note?: string;
			marks: { de: string; en?: string; at?: number; from?: number; to?: number }[];
	  }
	| {
			/**
			 * Labelled pictures that teach by showing: the cat on, in, under the
			 * basket; the weather. The practice page then asks with other pictures.
			 */
			kind: 'pictures';
			title: string;
			note?: string;
			/** Pictures per row (default 6). */
			cols?: number;
			items: { image: string; de: string; en?: string }[];
	  }
	| { kind: 'columns'; blocks: LearnBlock[] };

/** A question with a branch for yes and for no, or an answer at the end of a branch. */
export type FlowNode = { q: string; yes: FlowNode; no: FlowNode } | { answer: string; example?: string };

/** The German a decision tree prints: its answers and examples (the questions are English). */
const flowGerman = (n: FlowNode): string[] =>
	'q' in n ? [...flowGerman(n.yes), ...flowGerman(n.no)] : [n.answer, n.example ?? ''];

/** One place in a sentence; `tag` is a small English label under it (who, what); `hot` frames this one place. */
export interface SlotCell {
	de: string;
	tag?: string;
	hot?: boolean;
}

export type FamilyRole = 'opa' | 'oma' | 'vater' | 'mutter' | 'tante' | 'bruder' | 'ich' | 'schwester';

export type Exercise = {
	title: string;
	instruction: string;
	/** Prints the spread's Listen code beside the exercise. */
	listen?: boolean;
	/** A picture beside the exercise (the room for Wo?), or above it for a colouring page. */
	image?: string;
} & (
	| {
			/** Prompt → a line to write on. */
			kind: 'write';
			cols?: number;
			/** The prompts aren't German to read: English cues ("a child"), letters, word fragments ("Tsch _ ss"). */
			notGerman?: boolean;
			items: { prompt: string; answer: string }[];
	  }
	| {
			/** Draw a line from each left item to its partner. answers[i] = index on the right. */
			kind: 'match';
			/** The words are built by the page's rule (number words): matching them is the exercise. */
			built?: boolean;
			left: string[];
			right: string[];
			answers: number[];
	  }
	| {
			/** Pictures with a blank tag each. */
			kind: 'tags';
			/** Printed at the end of each tag (€ for prices). */
			unit?: string;
			items: { image: string; label: string; answer: string }[];
	  }
	| {
			/** Circle the right word: before ( a / b ) after. */
			kind: 'circle';
			cols?: number;
			items: { before: string; options: string[]; after?: string; answer: string }[];
	  }
	| {
			/** Write each word in its column (der | die | das). answers[i] = the column of words[i]. */
			kind: 'sort';
			columns: string[];
			words: string[];
			answers: number[];
	  }
	| {
			/** Do what each sentence says to the picture (colour it in). Checked against the sentences. */
			kind: 'colour';
			sentences: string[];
	  }
	| {
			/**
			 * Clock faces. `draw`: a blank face under the German — the reader draws
			 * the hands (the key gives the time). Otherwise the face shows the time
			 * and the reader writes the German.
			 */
			kind: 'clocks';
			draw?: boolean;
			items: { time: string; de: string }[];
	  }
	| {
			/** Sentences with a gap: before ___ after. A gap with no answer is the reader's own. */
			kind: 'gaps';
			items: { before: string; after?: string; answer?: string }[];
			/** For the key, when the gaps are the reader's own. */
			note?: string;
	  }
);

export interface Spread {
	id: string;
	/** The German title, big. */
	title: string;
	/** What it covers, in English. */
	subtitle: string;
	/** One line that says why it is worth the page. */
	hook: string;
	hero?: { image: string; caption?: string };
	/** The quiz a "More practice in the app" code opens. */
	quiz?: string;
	/**
	 * A review spread: no teaching, exercises on both pages — `left` on the
	 * left, `practise` on the right — over the topics before it.
	 */
	review?: boolean;
	left?: Exercise[];
	/** The quiz whose audio the Listen code plays. */
	listenQuiz?: string;
	learn: LearnBlock[];
	practise: Exercise[];
	/** "I can …" lines, ticked at the foot of the practice page. */
	canDo: string[];
}

export interface Credit {
	what: string;
	source: string;
	licence: string;
}

export interface Companion {
	courseId: string;
	level: string;
	title: string;
	/** Cover picture id under /img. */
	cover: string;
	/** The inside-cover welcome. */
	welcome: string[];
	spreads: Spread[];
	/** The people the book's sentences are about: names count as known German. */
	names?: string[];
	/** Topics still to be written, listed greyed in the contents. */
	planned?: { title: string; subtitle: string }[];
	/** One page with the level's grammar at a glance, after the topics. */
	overview?: { title: string; blocks: LearnBlock[] };
	/** Two pages of pictured words, after the overview. */
	dictionary?: { title: string; note: string; words: { de: string; en: string; image: string }[] };
	credits: Credit[];
}

/** The file stem for a level: "A1.1" → "a1_1". */
export const companionStem = (level: string) => level.toLowerCase().replace(/\./g, '_');

const escape = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

/** Authored text → HTML: escaped, then **bold** and *focus*. */
export function rich(text: string): string {
	return escape(text)
		.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>')
		.replace(/\*(.+?)\*/g, '<em class="focus">$1</em>');
}

/** Text without its marks, for the answer key and for tests. */
export const plain = (text: string) => text.replace(/\*\*?(.+?)\*\*?/g, '$1');

/** A spread's exercises in page order: the left page's (reviews), then the right's. */
export const exercisesOf = (spread: Spread): Exercise[] => [...(spread.left ?? []), ...spread.practise];

/** One exercise in the answer key. */
export interface KeyEntry {
	exercise: number;
	title: string;
	/** q: what the item showed (muted in the key), a: the answer (bold). */
	answers: { q?: string; a: string }[];
	note?: string;
}

/** The answers to one exercise, in the order its items are printed. */
export function answersOf(ex: Exercise): { answers: KeyEntry['answers']; note?: string } {
	switch (ex.kind) {
		case 'write':
			return { answers: ex.items.map((i) => ({ q: plain(i.prompt), a: i.answer })) };
		case 'match':
			return { answers: ex.left.map((l, i) => ({ q: l, a: ex.right[ex.answers[i]] })) };
		case 'tags':
			return { answers: ex.items.map((i) => ({ q: i.label || undefined, a: i.answer })) };
		case 'circle':
			return { answers: ex.items.map((i) => ({ a: i.answer })) };
		case 'sort':
			return { answers: ex.columns.map((c, col) => ({ q: c, a: ex.words.filter((_, i) => ex.answers[i] === col).join(', ') })) };
		case 'colour':
			return { answers: [], note: 'Check your picture against each sentence.' };
		case 'gaps':
			return { answers: ex.items.filter((i) => i.answer).map((i) => ({ a: i.answer! })), note: ex.note };
		case 'clocks':
			return { answers: ex.items.map((i) => (ex.draw ? { q: i.de, a: i.time } : { q: i.time, a: i.de })) };
	}
}

/** The key for one spread. */
export const answerKey = (spread: Spread): KeyEntry[] =>
	exercisesOf(spread).map((ex, e) => ({ exercise: e + 1, title: ex.title, ...answersOf(ex) }));

/** The German a learn block teaches, as it is printed. */
export function germanOf(block: LearnBlock): string[] {
	switch (block.kind) {
		case 'tiles':
			return block.tiles.flatMap((t) => [t.big, t.word]);
		case 'build':
			return block.rows.flatMap((r) => [r.result, ...r.parts.filter((p) => p.role !== 'cut').map((p) => p.text)]);
		case 'flip':
			return [block.unit, block.ten, `${block.unit}und${block.ten}`, ...block.examples.map((e) => e.de)];
		case 'pairs':
			return block.rows.map((r) => r.b);
		case 'words':
			return block.items.map((i) => i.de);
		case 'table':
			return block.rows.flatMap((r) => r.filter((_, i) => !block.head[i]?.en));
		case 'tree':
			return Object.values(block.people).flatMap((p) => [p.name, p.word]);
		case 'slots':
			return block.rows.flatMap((r) => r.cells.map((c) => c.de));
		case 'flow':
			return flowGerman(block.root);
		case 'merge':
			return block.rows.flatMap((r) => [r.a, r.aTo, r.b, r.bTo, r.result]);
		case 'arrow':
			return block.rows.flatMap((r) => [r.who, r.verb, r.whom]);
		case 'clock':
			return block.clocks.map((c) => c.de);
		case 'timeline':
			return block.marks.map((m) => m.de);
		case 'pictures':
			return block.items.map((i) => i.de);
		case 'columns':
			return block.blocks.flatMap(germanOf);
		case 'box':
			return [];
	}
}

/** The German an exercise asks the reader to read (not what it asks them to produce). */
export function germanAskedBy(ex: Exercise): string[] {
	switch (ex.kind) {
		case 'write':
			return ex.notGerman ? [] : ex.items.map((i) => i.prompt);
		case 'tags':
			return ex.items.map((i) => i.label);
		case 'gaps':
			return ex.items.flatMap((i) => [i.before, i.after ?? '']);
		case 'circle':
			// The wrong options are wrong on purpose (fahrst, sprichen): only the right one is German to learn.
			return ex.items.flatMap((i) => [i.before, i.answer, i.after ?? '']);
		case 'colour':
			return ex.sentences;
		case 'sort':
			return [...ex.columns, ...ex.words];
		case 'match':
			return ex.built ? [] : [...ex.left, ...ex.right];
		case 'clocks':
			return ex.draw ? ex.items.map((i) => i.de) : [];
	}
}

/** Lower-cased German words in a text, digits and punctuation dropped. */
export const wordsIn = (text: string) => plain(text).toLowerCase().match(/[a-zäöüß]+/g) ?? [];

/** Every picture a companion prints, for the credits and the tests. */
export function imagesOf(companion: Companion): string[] {
	const out = new Set<string>([companion.cover]);
	const walk = (b: LearnBlock) => {
		if (b.kind === 'box' && b.image) out.add(b.image);
		if (b.kind === 'pictures') b.items.forEach((i) => out.add(i.image));
		if (b.kind === 'columns') b.blocks.forEach(walk);
	};
	for (const s of companion.spreads) {
		if (s.hero) out.add(s.hero.image);
		s.learn.forEach(walk);
		for (const ex of exercisesOf(s)) {
			if (ex.image) out.add(ex.image);
			if (ex.kind === 'tags') ex.items.forEach((i) => out.add(i.image));
		}
	}
	companion.overview?.blocks.forEach(walk);
	companion.dictionary?.words.forEach((w) => out.add(w.image));
	return [...out];
}

const files = import.meta.glob<{ default: Omit<Companion, 'courseId' | 'level'> }>('$content/companion/*/*.json', { eager: true });

/** The companion for a level, when one has been written. */
export function loadCompanion(courseId: string, level: string): Companion | null {
	const stem = companionStem(level);
	for (const [path, mod] of Object.entries(files)) {
		const m = /\/companion\/([^/]+)\/([^/]+)\.json$/.exec(path);
		if (m && m[1] === courseId && m[2] === stem) return { courseId, level, ...mod.default };
	}
	return null;
}
