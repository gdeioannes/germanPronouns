#!/usr/bin/env node
// Writes the book PDFs' document info (title, author, subject, keywords): what
// a search engine or an AI answer shows as the file's name. Chrome's printer
// leaves the page's <title> ("… book preview") and itself as the creator.
//
//   node tool/book-pdf-meta.mjs            every free download in static/books/v2
//   node tool/book-pdf-meta.mjs <file.pdf> one file
//
// The info is APPENDED as a PDF incremental update (a new Info object, an xref
// for it, a trailer pointing back at the old one): the original bytes stay as
// they are, so git stores a few hundred bytes per book instead of a new 40 MB
// copy. Running it again with the same info changes nothing.
// gen-book2.mjs calls stampBookPdf() on every --web print.
import { readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const MARK = '%lq-meta';

const LANG_NAMES = { ar: 'Arabic', tr: 'Turkish', uk: 'Ukrainian', fr: 'French', es: 'Spanish' };

/** Level → German subtitle, read from the one list (src/lib/content/books.ts). */
function subtitles() {
	const src = readFileSync(`${root}src/lib/content/books.ts`, 'utf8');
	return Object.fromEntries([...src.matchAll(/level: '([ABC][12]\.[12])'[^}]*?sub: '([^']+)'/g)].map((m) => [m[1], m[2]]));
}

/** The info for one book: `level` like "A1.1", `lang` a second-language edition or null. */
export function bookInfo(level, lang, sub = subtitles()[level]) {
	const cefr = level.slice(0, 2);
	const edition = lang ? `, explained in ${LANG_NAMES[lang] ?? lang}` : '';
	return {
		Title: `Deutsch ${level} · ${sub}: Free German Textbook, CEFR ${cefr} (PDF${edition})`,
		Author: 'Language Quiz (languagequiz.org)',
		Subject: `Free German course book for level ${level} (CEFR ${cefr})${edition}: twelve chapters, each a real place in Germany, with words, a story, grammar, a real document and exercises. Audio, flashcards and answer checks free at languagequiz.org.`,
		Keywords: `German textbook, free German book PDF, Deutsch lernen, ${level}, CEFR ${cefr}, German grammar, German exercises, German course${lang ? `, German for ${LANG_NAMES[lang] ?? lang} speakers` : ''}`,
		Creator: 'languagequiz.org'
	};
}

/** A PDF text string: UTF-16BE hex with a byte-order mark, so any letter survives. */
const pdfString = (s) => {
	let hex = 'FEFF';
	for (const ch of s) {
		const c = ch.codePointAt(0);
		if (c > 0xffff) {
			const v = c - 0x10000;
			hex += (0xd800 + (v >> 10)).toString(16).padStart(4, '0') + (0xdc00 + (v & 0x3ff)).toString(16).padStart(4, '0');
		} else hex += c.toString(16).padStart(4, '0');
	}
	return `<${hex.toUpperCase()}>`;
};

/** The last trailer's fields and the object the current /Info points at. */
function lastTrailer(buf) {
	const tail = buf.subarray(Math.max(0, buf.length - 4096)).toString('latin1');
	const sx = tail.lastIndexOf('startxref');
	if (sx < 0) throw new Error('no startxref');
	const xrefAt = Number(tail.slice(sx + 9).trim().split(/\s+/)[0]);
	const tr = tail.lastIndexOf('trailer', sx);
	if (tr < 0) throw new Error('no classic trailer (xref stream PDFs are not handled)');
	const dict = tail.slice(tr, sx);
	const num = (k) => {
		const m = dict.match(new RegExp(`/${k}\\s+(\\d+)(?:\\s+(\\d+)\\s+R)?`));
		return m ? Number(m[1]) : null;
	};
	const rootRef = dict.match(/\/Root\s+(\d+\s+\d+\s+R)/)?.[1];
	if (!rootRef) throw new Error('no /Root');
	return { xrefAt, size: num('Size'), root: rootRef, info: num('Info'), tail };
}

/** The old info's creation date, kept so the book's age stays true. */
function creationDate(buf, xrefAt, infoNum) {
	if (infoNum == null) return null;
	// Find the object's offset in the latest xref section that lists it.
	const sect = buf.subarray(xrefAt, Math.min(buf.length, xrefAt + 64 + 20 * (infoNum + 2))).toString('latin1');
	const lines = sect.split(/\r?\n/);
	let i = 1;
	while (i < lines.length && !lines[i].startsWith('trailer')) {
		const [start, count] = lines[i].trim().split(/\s+/).map(Number);
		if (infoNum >= start && infoNum < start + count) {
			const offset = Number(lines[i + 1 + (infoNum - start)].slice(0, 10));
			const obj = buf.subarray(offset, offset + 2048).toString('latin1');
			return obj.match(/\/CreationDate\s*(\([^)]*\)|<[^>]*>)/)?.[1] ?? null;
		}
		i += 1 + count;
	}
	return null;
}

/** `buf` with `info` appended as an incremental update; `buf` itself when it already has it. */
export function stampPdf(buf, info) {
	const t = lastTrailer(buf);
	const entries = Object.entries(info).map(([k, v]) => `/${k} ${pdfString(v)}`);
	const signature = entries.join('\n');
	// Already stamped with exactly this info: leave the file alone.
	if (t.tail.includes(MARK) && t.tail.includes(signature)) return buf;
	const created = creationDate(buf, t.xrefAt, t.info);
	const d = new Date();
	const p = (n) => String(n).padStart(2, '0');
	const now = `(D:${d.getUTCFullYear()}${p(d.getUTCMonth() + 1)}${p(d.getUTCDate())}${p(d.getUTCHours())}${p(d.getUTCMinutes())}${p(d.getUTCSeconds())}Z)`;
	const objNum = t.size; // a fresh object number, so the old info stays readable as history
	const lead = buf[buf.length - 1] === 0x0a ? '' : '\n';
	const objStart = buf.length + Buffer.byteLength(`${lead}${MARK}\n`, 'latin1');
	const obj = `${objNum} 0 obj\n<<${signature}\n${created ? `/CreationDate ${created}\n` : ''}/ModDate ${now}>>\nendobj\n`;
	const xrefStart = objStart + Buffer.byteLength(obj, 'latin1');
	const update =
		`${lead}${MARK}\n${obj}` +
		// The free-list head (object 0) first, as Acrobat writes its updates: some readers want it.
		`xref\n0 1\n0000000000 65535 f \n${objNum} 1\n${String(objStart).padStart(10, '0')} 00000 n \n` +
		`trailer\n<</Size ${objNum + 1}\n/Root ${t.root}\n/Info ${objNum} 0 R\n/Prev ${t.xrefAt}>>\n` +
		`startxref\n${xrefStart}\n%%EOF\n`;
	return Buffer.concat([buf, Buffer.from(update, 'latin1')]);
}

/** Stamps one book file in place; its level and edition come from its name. */
export function stampBookPdf(file) {
	const m = file.match(/_([abc][12])_([12])(?:_([a-z]{2}))?\.pdf$/);
	if (!m) throw new Error(`not a book PDF name: ${file}`);
	const level = `${m[1].toUpperCase()}.${m[2]}`;
	const buf = readFileSync(file);
	const out = stampPdf(buf, bookInfo(level, m[3] ?? null));
	if (out === buf) return false;
	writeFileSync(file, out);
	return true;
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
	const dir = `${root}static/books/v2`;
	const files = process.argv[2]
		? [process.argv[2]]
		: readdirSync(dir)
				.filter((f) => /^de_cert_a1_[abc][12]_[12](_[a-z]{2})?\.pdf$/.test(f))
				.map((f) => `${dir}/${f}`);
	for (const f of files) console.log(`${stampBookPdf(f) ? 'stamped' : 'unchanged'}  ${f.split('/').pop()}`);
}
