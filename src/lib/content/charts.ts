// The grammar charts book: A4 landscape wall charts, one PDF. Everything here
// comes from charts.json, which `npm run charts` (tool/gen-charts.mjs) writes
// next to the PDF it builds, so the page count, the size and the list of
// charts on the site are never a hand-kept copy of the book.

import manifest from './charts.json';
import { mediaUrl } from '$lib/media';

export interface ChartQuiz {
	quiz: string;
	/** The part of the chart it practises. */
	for: string;
	/** What you do in it. */
	note: string;
}

export interface GrammarChart {
	n: number;
	title: string;
	/** One line on what the chart covers. */
	topic: string;
	/** The kind of diagram: Table, Timeline, Map, Pictures … */
	kind: string;
	/** The course levels it spans: "A1 → B1", "A2". */
	level: string;
	/** Its address: /charts/<slug>, where the printed QR code points. */
	slug: string;
	/** The app quizzes that practise it, easiest first (tool/charts/quizzes.mjs). */
	quizzes: ChartQuiz[];
	/** A preview of the page, 1100 px wide. */
	img: string;
}

export interface ChartsBook {
	edition: string;
	/** When the free download stops (ISO date-time, set in tool/charts/charts.json), or null: no end. */
	downloadUntil: string | null;
	pdf: string;
	pages: number;
	megabytes: number;
	cover: string;
	charts: GrammarChart[];
}

/** The PDF's href points at the media bucket when there is one (lib/media). */
export const CHARTS_BOOK: ChartsBook = { ...manifest, pdf: mediaUrl(manifest.pdf) };

/** One chart by its address, or undefined. */
export function chartBySlug(slug: string): GrammarChart | undefined {
	return CHARTS_BOOK.charts.find((c) => c.slug === slug);
}

/** The course the charts' quizzes come from. */
export const CHARTS_COURSE = 'de_cert_a1';

/** The moment the free download stops, in epoch ms, or null when it has no end (or the date is unreadable). */
export function chartsDownloadEnds(): number | null {
	const at = CHARTS_BOOK.downloadUntil ? Date.parse(CHARTS_BOOK.downloadUntil) : NaN;
	return Number.isFinite(at) ? at : null;
}

/** A span of time for the countdown: "1 day 13 h 05 min", "4 h 12 min 09 s", "0 s". */
export function timeLeft(ms: number): string {
	const s = Math.max(0, Math.floor(ms / 1000));
	const d = Math.floor(s / 86400), h = Math.floor((s % 86400) / 3600), m = Math.floor((s % 3600) / 60), sec = s % 60;
	const two = (n: number) => String(n).padStart(2, '0');
	if (d > 0) return `${d} ${d === 1 ? 'day' : 'days'} ${h} h ${two(m)} min`;
	if (h > 0) return `${h} h ${two(m)} min ${two(sec)} s`;
	if (m > 0) return `${m} min ${two(sec)} s`;
	return `${sec} s`;
}

/** The file name a download is saved under. */
export const CHARTS_FILENAME = 'German Grammar Charts - Language Quiz.pdf';
