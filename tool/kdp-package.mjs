#!/usr/bin/env node
// The folder to upload the twelve books to Amazon KDP from:
//
//   kdp/
//     README.txt                       the settings that are the same for every book
//     01 Deutsch A1.1/interior.pdf     the KDP interior: print originals, 3.175 mm bleed
//     01 Deutsch A1.1/cover.pdf        the wrap cover, spine sized to the page count
//     01 Deutsch A1.1/listing.txt      every field KDP asks for, ready to copy
//     …
//
//   node tool/kdp-package.mjs [A1.1 …] [--paper premium|standard] [--skip-print]
//
// Needs the dev server (tool/gen-book2.mjs prints from it) and the print
// originals in static/img/photo/. Refuses while the publisher's address in
// src/lib/operator.ts is a placeholder: German press law wants it in the book.
// --draft builds anyway (the imprint then shows the placeholder; do not upload).
// --skip-print reuses static/books/v2/*_print.pdf from an earlier run.
// kdp/ is gitignored: the PDFs are large and are rebuilt from the content.
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { PDFDocument } from 'pdf-lib';

const args = process.argv.slice(2);
const flag = (n, d) => (args.includes(n) ? args[args.indexOf(n) + 1] : d);
const paper = flag('--paper', 'premium');
const ALL = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
const levels = ALL.filter((l) => args.includes(l)).length ? ALL.filter((l) => args.includes(l)) : ALL;

const operator = readFileSync('src/lib/operator.ts', 'utf8');
const draft = /street: '\[|city: '\[/.test(operator);
const DRAFT_NOTE = `
*** DRAFT: the publisher address in src/lib/operator.ts is still a placeholder,
*** so the imprint in every interior.pdf shows it. Fill it in and rebuild before uploading.

`;
if (draft && !args.includes('--draft')) {
	console.error('The publisher address in src/lib/operator.ts is still a placeholder. Fill it in first: every printed book sold in Germany must name the publisher with an address (Landespressegesetz). --draft builds the folder anyway, marked as a draft.');
	process.exit(1);
}
const name = operator.match(/name: '([^']+)'/)[1];

const node = (...a) => execFileSync(process.execPath, a, { stdio: 'inherit' });
const stem = (l) => l.toLowerCase().replace('.', '_');
const english = (l) => /^A/.test(l);

// What each level is, for the listing. Titles stay plain: no exam brand names.
const BADGE = { A1: 'Beginner', A2: 'Elementary', B1: 'Intermediate', B2: 'Upper intermediate', C1: 'Advanced', C2: 'Proficiency' };

function listing(level, book, pages) {
	const n = ALL.indexOf(level) + 1;
	const cefr = level.slice(0, 2);
	const spineMm = Math.round(pages * (paper === 'premium' ? 0.0596 : 0.0572) * 100) / 100;
	const chapters = book.chapters.map((c) => `${c.n}. ${c.title}`).join('\n');
	const lede = book.cover?.lede ?? '';
	const explain = english(level)
		? 'Explanations and instructions are in English; the German is what you learn.'
		: 'From B1 on, explanations and instructions are in German, written for learners at this level.';
	return `KDP LISTING · ${book.title} · ${book.subtitle}
Copy each field into KDP (Bookshelf → + Create → Paperback).
==============================================================

PAPERBACK DETAILS
-----------------
Language:
${english(level) ? 'English  (the instructions are English; the book teaches German)' : 'German'}

Book title:
${book.title}

Subtitle:
${book.subtitle}. ${english(level) ? `German course book ${level}, CEFR level ${cefr} (${BADGE[cefr].toLowerCase()}), with exercises and answer key` : `Deutsch-Lehrbuch ${level}, Niveau ${cefr}, mit Übungen und Lösungen`}

Series (create it once, then add each book):
Series name: Language Quiz German
Volume / number: ${n}

Edition number:
1

Author (Primary author or contributor):
${name}

Description (paste into the description box):
${lede}

${english(level) ? `Deutsch ${level} is book ${n} of twelve that take you from your first German word to C2. Each of its twelve chapters is a real place in Germany, with a photo you can step into, the words you need there, a short reading, a grammar page with a picture that explains it, a real-life document to read, and exercises with an answer key at the back.` : `Deutsch ${level} ist Band ${n} von zwölf, vom ersten deutschen Wort bis C2. Jedes der zwölf Kapitel spielt an einem echten Ort in Deutschland: ein Foto zum Hineingehen, die Wörter, die man dort braucht, ein Lesetext, eine Grammatikseite mit einem Bild, das sie erklärt, ein Dokument aus dem Alltag und Übungen mit Lösungen am Ende des Buches.`}

${explain}
Every page has a code: type it on languagequiz.org and the free app checks your answers, reads the texts aloud and gives you more exercises for that page.

${english(level) ? 'The chapters:' : 'Die Kapitel:'}
${chapters}

Publishing rights:
"I own the copyright and I hold the necessary publishing rights."
(The photos are used under their free licences, credited at the back of the book.)

Primary audience:
Sexually explicit images or title: No
Reading age: leave empty (adult learners)

Primary marketplace:
${english(level) ? 'Amazon.com (or Amazon.de if you sell mainly in Germany)' : 'Amazon.de'}

Categories (choose up to three):
1. Foreign Language Study & Reference › German
2. Foreign Language Study & Reference › Vocabulary
3. Education & Teaching › Studying & Workbooks

Keywords (seven boxes, one per line):
learn German ${cefr}
German ${level} workbook
Deutsch ${cefr} Lehrbuch
German grammar exercises with answers
German reading practice ${BADGE[cefr].toLowerCase()}
Deutsch lernen ${cefr} Übungen
German as a foreign language course book

AI-generated content (KDP asks this at the end of the details page):
Did you use AI tools in creating texts, images, and/or translations? Yes
Texts: Entire work, with extensive editing  (written with Anthropic Claude, checked and edited by you)
Images: Some images, with extensive editing  (the word pictures, made with Google Gemini; the photos are not AI)
Translations: None  (the German edition has no translation)
Answer what is true for your own process; the above is what the project files record.

PAPERBACK CONTENT
-----------------
Print ISBN:
Get a free KDP ISBN (imprint: "Independently published"), or enter your own.
An own ISBN from the German agency (MVB, isbn.de) lets you name yourself as the
publisher and list the book in German bookshops (VLB); KDP's free ISBN works only on Amazon.

Publication date: leave empty (today)

Print options:
Ink and paper type: ${paper === 'premium' ? 'Premium colour on white paper' : 'Standard colour on white paper'}
Trim size: 8.27 x 11.69 in (21 x 29.7 cm, A4)
Bleed settings: Bleed
Paperback cover finish: Matte

Manuscript: upload interior.pdf (this folder)
  ${pages} pages, ${(213.175).toFixed(3)} × 303.35 mm with bleed.
Book cover: "Upload a cover you already have", then cover.pdf (this folder)
  Spine ${spineMm} mm for ${pages} pages on ${paper} colour paper. If KDP's preview
  shows a different page count, rebuild the cover:
  node tool/gen-book2.mjs ${level} --cover --pages <count> --paper ${paper}

AI-generated content: as above.

Launch the previewer and look at every opener spread and the last page before you approve.

PAPERBACK RIGHTS & PRICING
--------------------------
Territories: All territories (worldwide rights)
Primary marketplace: as above
Pricing: KDP shows the printing cost for ${pages} pages once the files are in.
Royalty is 60% of the list price minus that printing cost. ${paper === 'premium' ? `Premium colour at A4 is expensive to print, so set the list price well above the printing cost KDP shows.` : ''}
Expanded distribution: optional (lower royalty, reaches bookshops and libraries).
`;
}

mkdirSync('kdp', { recursive: true });
for (const level of levels) {
	const book = JSON.parse(readFileSync(`assets/content/book2/de_cert_a1/${stem(level)}.json`, 'utf8'));
	const dir = `kdp/${String(ALL.indexOf(level) + 1).padStart(2, '0')} ${book.title}`;
	mkdirSync(dir, { recursive: true });
	const print = `static/books/v2/de_cert_a1_${stem(level)}_print.pdf`;
	if (!args.includes('--skip-print') || !existsSync(print)) node('tool/gen-book2.mjs', level);
	node('tool/kdp-bleed.mjs', print, `${dir}/interior.pdf`);
	const pages = (await PDFDocument.load(readFileSync(print))).getPageCount();
	node('tool/gen-book2.mjs', level, '--cover', '--pages', String(pages), '--paper', paper, '--out', `${dir}/cover.pdf`);
	writeFileSync(`${dir}/listing.txt`, listing(level, book, pages));
	console.log(`${dir}: ${pages} pages`);
}

writeFileSync(
	'kdp/README.txt',
	`THE TWELVE BOOKS FOR AMAZON KDP
================================
${draft ? DRAFT_NOTE : ''}One folder per book: interior.pdf (the inside, with bleed), cover.pdf (back,
spine and front on one sheet) and listing.txt (every field KDP asks for).

Before you publish
- The publisher name and address printed in each book's imprint (last page) come
  from src/lib/operator.ts. They must be correct: German press law requires them.
- Have the open points in docs/rights_audit.md checked by a lawyer for German
  copyright and media law.
- Order one printed proof copy of the first book (KDP: "Request printed proofs")
  and check the colour, the opener spreads and the spine before going live.

The same for every book
- Format: Paperback. Trim 8.27 x 11.69 in (A4). Bleed: yes. Ink: ${paper} colour, white paper.
- Cover finish: matte.
- Series: "Language Quiz German", volumes 1–12, in the order of the folders.
- The books do not name any exam brand. Keep it that way in titles, subtitles,
  keywords and descriptions (no Goethe, telc, TestDaF, ÖSD), so nothing suggests
  an affiliation.
- AI disclosure: say yes for texts and for images (see each listing.txt).

Rebuild after any content change
  npx vite dev                         (the books print from the dev server)
  node tool/kdp-package.mjs            (all twelve; or name levels: A1.1 B2.2)
`
);
console.log('kdp/ ready');
