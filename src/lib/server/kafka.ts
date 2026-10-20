// Die Verwandlung as web pages: the same text and the same twelve stages as
// the PDF (tool/kafka-pdf.py), cut the same way, so the book and the site can
// never disagree on where a stage starts or what its glossary says. Server
// only: the 146 KB text is read at prerender and each page gets one stage.

import source from '../../../assets/reference/kafka_die_verwandlung.txt?raw';
import spec from '../../../assets/reference/kafka_die_verwandlung_stages.json';

export interface KafkaWord {
	de: string;
	/** Plural notation: "-e", "¨e", "—" none, "pl." plural only. */
	pl?: string;
	en: string;
}

/** A run of a paragraph: plain text, or the phrase a note is about. */
export type KafkaRun = { text: string; note?: number };

export interface KafkaNote {
	n: number;
	at: string;
	/** Authored HTML (<b>, <i>). */
	html: string;
}

export interface KafkaStageSummary {
	n: number;
	chapter: string;
	title: string;
	en: string;
	words: number;
}

export interface KafkaStage extends KafkaStageSummary {
	glossary: KafkaWord[];
	paragraphs: KafkaRun[][];
	notes: KafkaNote[];
}

interface SpecStage {
	chapter: string;
	from: number;
	to: number;
	title: string;
	en: string;
	words: (KafkaWord & { form?: string })[];
	notes?: { at: string; note: string }[];
}

const STAGES = spec.stages as SpecStage[];
export const STAGE_COUNT = STAGES.length;
/** 1917 spelling next to today's: [["daß", "dass"], …]. */
export const SPELLING = spec.spelling as [string, string][];
export const REGIONAL = spec.regional as string;

/** The chapters as paragraph lists, split exactly as the PDF tool splits them. */
function chapters(): Record<string, string[]> {
	const text = source.replace(/\r\n/g, '\n');
	let body = text.split('*** START OF THE PROJECT GUTENBERG EBOOK DIE VERWANDLUNG ***')[1];
	body = body.split('*** END OF THE PROJECT GUTENBERG EBOOK DIE VERWANDLUNG ***')[0];
	body = body.slice(body.indexOf('\nI.\n'));
	const split = body.split(/\n(I{1,3})\.\n/);
	const out: Record<string, string[]> = {};
	for (let i = 1; i < split.length; i += 2) {
		out[split[i]] = split[i + 1]
			.split(/\n\s*\n/)
			.filter((p) => p.trim())
			.map((p) => p.trim().split(/\s+/).join(' '));
	}
	return out;
}

const CHAPTERS = chapters();

const ARTICLES = ['der ', 'die ', 'das ', 'sich '];

/** The part of a glossary headword to look for in the text (as in the PDF tool). */
function stem(headword: string): string {
	let w = headword.replace(/\(.*?\)/g, '').trim();
	for (const a of ARTICLES) if (w.startsWith(a)) w = w.slice(a.length);
	w = w.split(/\s+/)[0] ?? '';
	return w
		.toLowerCase()
		.replace(/[!»«]+$/, '')
		.slice(0, Math.max(4, Math.min(6, w.length - 2)));
}

/** Gutenberg's plain text writes the dash as "--". */
const dash = (s: string) => s.replaceAll('--', '–');

function paragraphsOf(s: SpecStage): string[] {
	return CHAPTERS[s.chapter].slice(s.from, s.to);
}

function summary(s: SpecStage, n: number): KafkaStageSummary {
	const words = paragraphsOf(s).reduce((sum, p) => sum + p.split(' ').length, 0);
	return { n, chapter: s.chapter, title: s.title, en: s.en, words };
}

export function kafkaStages(): KafkaStageSummary[] {
	return STAGES.map((s, i) => summary(s, i + 1));
}

export function kafkaStage(n: number): KafkaStage | null {
	const s = STAGES[n - 1];
	if (!s) return null;
	const paras = paragraphsOf(s);
	const joined = paras.join(' ').toLowerCase();

	// The glossary reads in the order the words come up in the text.
	const glossary = s.words
		.map((w) => {
			const at = joined.indexOf((w.form ?? '').toLowerCase() || stem(w.de));
			return { at: at < 0 ? joined.length : at, w };
		})
		.sort((a, b) => a.at - b.at)
		.map(({ w }) => ({ de: w.de, pl: w.pl, en: w.en }));

	// Each note is tied to an exact phrase; number them in reading order.
	const marks = (s.notes ?? [])
		.map((note) => {
			const p = paras.findIndex((para) => para.includes(note.at));
			return { p, at: p < 0 ? -1 : paras[p].indexOf(note.at), note };
		})
		.filter((m) => m.p >= 0)
		.sort((a, b) => a.p - b.p || a.at - b.at);
	const notes: KafkaNote[] = marks.map((m, i) => ({ n: i + 1, at: m.note.at, html: m.note.note }));

	const paragraphs = paras.map((para, p) => {
		const runs: KafkaRun[] = [];
		let pos = 0;
		marks.forEach((m, i) => {
			if (m.p !== p || m.at < pos) return;
			if (m.at > pos) runs.push({ text: dash(para.slice(pos, m.at)) });
			runs.push({ text: dash(m.note.at), note: i + 1 });
			pos = m.at + m.note.at.length;
		});
		if (pos < para.length) runs.push({ text: dash(para.slice(pos)) });
		return runs;
	});

	return { ...summary(s, n), glossary, paragraphs, notes };
}
