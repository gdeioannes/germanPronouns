#!/usr/bin/env node
// The book's "document" pages for which no free real document exists: a
// timetable, a cinema listing, a job advert, a CV, a poster, a flyer and a
// job reference, typeset here (SVG → JPG) so no third party holds any right
// in them. The people, firms and schools in them are made up.
//
//   node tool/make-documents.mjs            all of them
//   node tool/make-documents.mjs <id> ...   only these
//
// Writes static/img/photo/<id>.jpg (print, gitignored) and
// static/img/photo/web/<id>.jpg (site and download edition), the same places a
// Commons photo goes. assets/rights/own.json registers them as our own.
// Needs the Windows fonts (Courier New, Georgia, Arial, Segoe Print, Ink Free).
import { mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT = `${root}static/img/photo/`;

const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

/** Lines of at most `n` characters, broken at spaces. */
function wrap(text, n) {
	const out = [];
	let line = '';
	for (const w of text.split(' ')) {
		if (line && (line + ' ' + w).length > n) {
			out.push(line);
			line = w;
		} else line = line ? line + ' ' + w : w;
	}
	if (line) out.push(line);
	return out;
}

/** A block of wrapped text from (x, y), `lh` apart; returns the svg and the y after it. */
function para(text, { x, y, n, size, lh = size * 1.35, font = 'Georgia', weight = 400, fill = '#222', anchor = 'start', style = 'normal' }) {
	const lines = wrap(text, n);
	const svg = lines
		.map((l, i) => `<text x="${x}" y="${y + i * lh}" font-family="${font}" font-size="${size}" font-weight="${weight}" font-style="${style}" fill="${fill}" text-anchor="${anchor}">${esc(l)}</text>`)
		.join('');
	return { svg, y: y + lines.length * lh };
}

const t = (x, y, s, size, o = {}) =>
	`<text x="${x}" y="${y}" font-family="${o.font ?? 'Georgia'}" font-size="${size}" font-weight="${o.weight ?? 400}" font-style="${o.style ?? 'normal'}" fill="${o.fill ?? '#222'}" text-anchor="${o.anchor ?? 'start'}"${o.rotate ? ` transform="rotate(${o.rotate} ${x} ${y})"` : ''}${o.spacing ? ` letter-spacing="${o.spacing}"` : ''}>${esc(s)}</text>`;

// Paper: a warm off-white with a faint grain, so a page reads as paper, not a screen.
const paper = (w, h, colour = '#f6f1e4') => `
	<defs><filter id="grain"><feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" seed="4"/><feColorMatrix values="0 0 0 0 0.45  0 0 0 0 0.38  0 0 0 0 0.25  0 0 0 0.07 0"/></filter></defs>
	<rect width="${w}" height="${h}" fill="${colour}"/>
	<rect width="${w}" height="${h}" filter="url(#grain)"/>`;

const svgDoc = (w, h, body, colour) => `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}">${paper(w, h, colour)}${body}</svg>`;

const HAND = 'Segoe Print';
const INK = '#1d3f8f';

// ── A1.2 · Die Woche: a timetable filled in by hand ─────────────────────────
function woche() {
	const W = 2400, H = 1600;
	const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'];
	const times = ['7.45 – 8.30', '8.35 – 9.20', '9.40 – 10.25', '10.30 – 11.15', '11.35 – 12.20', '12.25 – 13.10'];
	const plan = [
		['E', 'D', 'M', 'M', 'Bio', 'Reli'],
		['D', 'M', 'E', 'Sp', 'D', 'Ku'],
		['M', 'E', 'D', 'Sp', 'Mu', 'Ku'],
		['Bio', 'Ek', 'Reli', 'D', 'E', ''],
		['Mu', 'Ku', 'Sp', 'E', 'M', ''],
		['', 'Ku', '', 'Ek', '', '']
	];
	const x0 = 150, y0 = 330, cw = 330, tw = 300, rh = 170;
	let b = '';
	b += t(W / 2, 150, 'Stundenplan', 96, { anchor: 'middle', font: 'Georgia', weight: 700, fill: '#7a2e2e' });
	b += t(W / 2, 235, 'Klasse 5b · Schuljahr 1985/86', 46, { anchor: 'middle', font: HAND, fill: INK });
	// The grid.
	b += `<rect x="${x0}" y="${y0}" width="${tw + cw * 6}" height="${rh * 7}" fill="none" stroke="#7a2e2e" stroke-width="5"/>`;
	for (let r = 1; r <= 6; r++) b += `<line x1="${x0}" y1="${y0 + r * rh}" x2="${x0 + tw + cw * 6}" y2="${y0 + r * rh}" stroke="#7a2e2e" stroke-width="${r === 1 ? 4 : 2}"/>`;
	for (let c = 0; c <= 5; c++) b += `<line x1="${x0 + tw + c * cw}" y1="${y0}" x2="${x0 + tw + c * cw}" y2="${y0 + rh * 7}" stroke="#7a2e2e" stroke-width="${c === 0 ? 4 : 2}"/>`;
	b += t(x0 + tw / 2, y0 + 108, 'Zeit', 54, { anchor: 'middle', weight: 700, fill: '#7a2e2e' });
	days.forEach((d, c) => (b += t(x0 + tw + c * cw + cw / 2, y0 + 108, d, 62, { anchor: 'middle', weight: 700, fill: '#7a2e2e' })));
	times.forEach((s, r) => (b += t(x0 + tw / 2, y0 + (r + 1) * rh + 102, s, 40, { anchor: 'middle', font: 'Arial', fill: '#444' })));
	plan.forEach((row, r) =>
		row.forEach((s, c) => {
			if (s) b += t(x0 + tw + c * cw + cw / 2, y0 + (r + 1) * rh + 112, s, 72, { anchor: 'middle', font: HAND, fill: INK, rotate: ((r * 7 + c * 3) % 5) - 2 });
		})
	);
	return { w: W, h: H, svg: svgDoc(W, H, b, '#fbf8ef') };
}

// ── A2.2 · Verabredung: a city magazine's cinema page ───────────────────────
function kino() {
	const W = 2000, H = 2828;
	const films = [
		{ title: 'Singles', note: 'USA 1992 · Regie: Cameron Crowe', cinema: 'Kandelhof', times: '15.30 · 18.00 · 20.30' },
		{ title: 'Blade Runner', note: 'Director’s Cut · OmU', cinema: 'Kurbel 2', times: '17.45 · 22.45' },
		{ title: 'Und täglich grüßt das Murmeltier', note: 'USA 1993', cinema: 'Harmonie 1', times: '16.00 · 18.15 · 20.30' },
		{ title: 'Bodyguard', note: 'USA 1992', cinema: 'Friedrichsbau', times: '20.00 · 22.30' },
		{ title: 'Sister Act', note: 'USA 1992', cinema: 'Harmonie 3', times: '16.15 · 18.30' },
		{ title: 'Kinderkino: Pippi Langstrumpf', note: 'Sa + So · ab 6 Jahren', cinema: 'Kandelhof 3', times: '14.00 Uhr' }
	];
	let b = '';
	b += `<rect x="0" y="0" width="${W}" height="300" fill="#202020"/>`;
	b += t(120, 190, 'KINO', 150, { font: 'Arial Black', fill: '#f2c94c', spacing: 12 });
	b += t(W - 120, 140, 'Juni 1993', 70, { font: 'Arial', weight: 700, fill: '#fff', anchor: 'end' });
	b += t(W - 120, 220, 'Was läuft wo? Alle Filme, alle Zeiten', 44, { font: 'Arial', fill: '#ddd', anchor: 'end' });
	const bx = 120, bw = (W - 240 - 60) / 2, bh = 640;
	films.forEach((f, i) => {
		const x = bx + (i % 2) * (bw + 60);
		const y = 380 + Math.floor(i / 2) * (bh + 50);
		b += `<rect x="${x}" y="${y}" width="${bw}" height="${bh}" fill="none" stroke="#202020" stroke-width="5"/>`;
		b += `<rect x="${x}" y="${y}" width="${bw}" height="120" fill="#202020"/>`;
		b += t(x + 40, y + 82, f.cinema, 58, { font: 'Arial', weight: 700, fill: '#f2c94c' });
		const head = para(f.title, { x: x + 40, y: y + 230, n: 18, size: 72, lh: 84, font: 'Georgia', weight: 700 });
		b += head.svg;
		b += t(x + 40, head.y + 20, f.note, 42, { font: 'Arial', fill: '#555' });
		b += t(x + 40, y + bh - 60, f.times, 60, { font: 'Arial', weight: 700, fill: '#b3261e' });
	});
	b += t(W / 2, H - 70, 'OmU = Original mit Untertiteln · Kinderkino: Eintritt 4 DM', 40, { font: 'Arial', fill: '#555', anchor: 'middle' });
	return { w: W, h: H, svg: svgDoc(W, H, b, '#f7f3ea') };
}

// ── B1.1 · Bewerbung: a job advert in an East German newspaper ──────────────
function anzeige() {
	const W = 2000, H = 2828;
	let b = '';
	b += `<rect x="140" y="140" width="${W - 280}" height="${H - 280}" fill="none" stroke="#111" stroke-width="10"/>`;
	b += `<rect x="170" y="170" width="${W - 340}" height="${H - 340}" fill="none" stroke="#111" stroke-width="3"/>`;
	b += t(W / 2, 400, 'Seeleute gesucht!', 130, { font: 'Georgia', weight: 700, anchor: 'middle' });
	b += t(W / 2, 520, 'Fahren Sie mit uns auf alle Meere der Welt', 60, { font: 'Georgia', style: 'italic', anchor: 'middle' });
	b += `<line x1="320" y1="600" x2="${W - 320}" y2="600" stroke="#111" stroke-width="4"/>`;
	let y = 720;
	const p = para('Der VEB Reederei Nordstern stellt für seine Frachtschiffe im weltweiten Liniendienst ein:', { x: 300, y, n: 46, size: 58, lh: 80 });
	b += p.svg;
	y = p.y + 40;
	for (const job of ['Decksleute und Matrosen', 'Motorenhelfer und Maschinisten', 'Stewards und Stewardessen', 'Schiffsköche und Bäcker', 'Schiffselektriker']) {
		b += t(360, y, '•  ' + job, 60, { font: 'Georgia', weight: 700 });
		y += 92;
	}
	y += 30;
	const p2 = para('Arbeitsstelle: an Bord unserer Schiffe. Einsatzgebiet: alle Meere. Eine abgeschlossene Berufsausbildung ist erwünscht, aber nicht Bedingung. Wir bilden Sie aus.', { x: 300, y, n: 46, size: 56, lh: 80 });
	b += p2.svg;
	y = p2.y + 50;
	const p3 = para('Ihre Bewerbung mit Lebenslauf in doppelter Ausführung, Zeugnisabschrift und zwei Lichtbildern senden Sie bitte an:', { x: 300, y, n: 46, size: 56, lh: 80 });
	b += p3.svg;
	y = p3.y + 70;
	b += t(W / 2, y, 'VEB Reederei Nordstern', 74, { font: 'Georgia', weight: 700, anchor: 'middle' });
	b += t(W / 2, y + 95, 'Abteilung Kader · Am Seehafen 4 · Rostock', 54, { font: 'Georgia', anchor: 'middle' });
	b += `<line x1="320" y1="${H - 380}" x2="${W - 320}" y2="${H - 380}" stroke="#111" stroke-width="4"/>`;
	b += t(W / 2, H - 280, 'Ein Beruf mit Zukunft – auf allen Meeren', 52, { font: 'Georgia', style: 'italic', anchor: 'middle' });
	return { w: W, h: H, svg: svgDoc(W, H, b, '#efe9da') };
}

// ── B1.2 · Abschied: a typed CV, the last lines by hand ─────────────────────
function lebenslauf() {
	const W = 2000, H = 2828;
	const M = 'Courier New';
	let b = '';
	b += t(220, 300, 'Lebenslauf', 76, { font: M, weight: 700 });
	b += t(220, 380, 'Dipl.-Ing. Klaus-Peter Hensel, Architekt', 50, { font: M });
	b += `<line x1="220" y1="420" x2="${W - 220}" y2="420" stroke="#333" stroke-width="3"/>`;
	const rows = [
		['7.11.1930', 'geboren in Berlin'],
		['Juni 1949', 'Abitur, Oberschule Berlin-Friedenau'],
		['Okt. 1949', 'TU Berlin: Studium der Architektur'],
		['1955', 'Diplom-Ingenieur, TU Berlin'],
		['1955 - 1960', 'Assistent am Lehrstuhl für Städtebau, TU Berlin'],
		['ab 1960', 'freier Architekt in Berlin: Wohnungsbau, Schulen, Umbauten'],
		['1963', 'Preis für junge Architekten der Stadt Berlin'],
		['1968 - 1975', 'Lehrauftrag an der Hochschule der Künste'],
		['Studienreisen', 'Westeuropa, USA, Moskau']
	];
	let y = 560;
	for (const [d, what] of rows) {
		b += t(220, y, d, 46, { font: M });
		const p = para(what, { x: 720, y, n: 40, size: 46, lh: 62, font: M });
		b += p.svg;
		y = p.y + 50;
	}
	// The last lines were added later, by hand.
	y += 20;
	b += t(220, y, '1979 - 80', 54, { font: HAND, fill: INK, rotate: -1 });
	b += t(720, y, 'Gastprofessur in Wien', 54, { font: HAND, fill: INK, rotate: -1 });
	y += 110;
	b += t(220, y, 'seit 1980', 54, { font: HAND, fill: INK, rotate: -1 });
	b += t(720, y, 'eigenes Büro, Berlin-Schöneberg', 54, { font: HAND, fill: INK, rotate: -1 });
	b += t(220, H - 360, 'Berlin, den 14. März 1980', 46, { font: M });
	b += t(1180, H - 250, 'K.-P. Hensel', 80, { font: HAND, fill: INK, rotate: -4 });
	return { w: W, h: H, svg: svgDoc(W, H, b, '#f8f6f0') };
}

// ── B2.1 · Nachrichten: a poster for a local vote ───────────────────────────
function plakat() {
	const W = 2000, H = 2828;
	let b = '';
	b += `<rect x="0" y="0" width="${W}" height="${H}" fill="#ffd400"/>`;
	b += `<rect x="0" y="0" width="${W}" height="520" fill="#0b3d91"/>`;
	b += t(W / 2, 250, 'Bürgerentscheid', 150, { font: 'Arial Black', fill: '#fff', anchor: 'middle' });
	b += t(W / 2, 410, 'am 22.06.08', 120, { font: 'Arial Black', fill: '#ffd400', anchor: 'middle' });
	b += t(W / 2, 700, 'Bochumer Bürger entscheiden!', 92, { font: 'Arial', weight: 700, fill: '#0b3d91', anchor: 'middle' });
	b += t(W / 2, 900, 'Unser Gymnasium', 120, { font: 'Arial Black', fill: '#111', anchor: 'middle' });
	b += t(W / 2, 1040, 'muss bleiben!', 120, { font: 'Arial Black', fill: '#111', anchor: 'middle' });
	// The ballot: where the X goes.
	b += `<rect x="420" y="1200" width="1160" height="560" fill="#fff" stroke="#111" stroke-width="8"/>`;
	b += t(520, 1340, 'Soll das Gymnasium am', 54, { font: 'Arial', fill: '#111' });
	b += t(520, 1410, 'Stadtpark erhalten bleiben?', 54, { font: 'Arial', fill: '#111' });
	b += `<rect x="560" y="1500" width="160" height="160" fill="#fff" stroke="#111" stroke-width="7"/>`;
	b += `<path d="M585 1525 L695 1635 M695 1525 L585 1635" stroke="#c4161c" stroke-width="22" stroke-linecap="round"/>`;
	b += t(760, 1620, 'JA', 110, { font: 'Arial Black', fill: '#111' });
	b += `<rect x="1080" y="1500" width="160" height="160" fill="#fff" stroke="#111" stroke-width="7"/>`;
	b += t(1280, 1620, 'Nein', 100, { font: 'Arial', fill: '#777' });
	b += t(W / 2, 1980, 'Bildung statt Beton!', 100, { font: 'Arial Black', fill: '#c4161c', anchor: 'middle' });
	b += t(W / 2, 2120, 'Der Bürgerwille ist wichtig.', 66, { font: 'Arial', weight: 700, fill: '#111', anchor: 'middle' });
	b += t(W / 2, 2210, 'Die Stadt hat einen Fehler gemacht.', 66, { font: 'Arial', weight: 700, fill: '#111', anchor: 'middle' });
	b += t(W / 2, 2300, 'Wir wollen das Gymnasium erhalten.', 66, { font: 'Arial', weight: 700, fill: '#111', anchor: 'middle' });
	b += `<rect x="0" y="${H - 300}" width="${W}" height="300" fill="#0b3d91"/>`;
	b += t(W / 2, H - 175, 'Elterninitiative „Pro Gymnasium am Stadtpark“', 60, { font: 'Arial', weight: 700, fill: '#fff', anchor: 'middle' });
	b += t(W / 2, H - 95, 'Wahllokale geöffnet von 8 bis 18 Uhr', 50, { font: 'Arial', fill: '#ffd400', anchor: 'middle' });
	return { w: W, h: H, svg: svgDoc(W, H, b) };
}

// ── B2.2 · Fleisch: a flyer with tear-off strips ────────────────────────────
function zettel() {
	const W = 2000, H = 2828;
	let b = '';
	b += t(W / 2, 330, 'Flugscham?', 190, { font: 'Arial Black', fill: '#1b5e20', anchor: 'middle' });
	b += t(W / 2, 470, 'Du bist nicht allein!', 100, { font: 'Georgia', style: 'italic', anchor: 'middle' });
	let y = 640;
	const p = para('Selbsthilfegruppe für Vielflieger*innen, Fleischesser und Dieselfahrer, die nachts nicht mehr schlafen können.', { x: W / 2, y, n: 38, size: 62, lh: 88, anchor: 'middle' });
	b += p.svg;
	y = p.y + 70;
	for (const line of ['Wir treffen uns einmal im Monat.', 'Wir hören zu.', 'Niemand wird verurteilt.', 'Die Gruppe ist anonym.', 'Kaffee gibt es (fair gehandelt).']) {
		b += t(W / 2, y, line, 66, { font: 'Georgia', weight: 700, anchor: 'middle' });
		y += 100;
	}
	y += 40;
	const p2 = para('Erster Schritt: Reiß einen Streifen ab. Der zweite Schritt ist schwerer.', { x: W / 2, y, n: 44, size: 54, lh: 76, anchor: 'middle', style: 'italic', fill: '#444' });
	b += p2.svg;
	// Tear-off strips along the bottom, a few already gone.
	const top = H - 720, n = 9, sw = W / n;
	b += `<line x1="0" y1="${top}" x2="${W}" y2="${top}" stroke="#555" stroke-width="4" stroke-dasharray="18 14"/>`;
	for (let i = 0; i < n; i++) {
		const x = i * sw;
		if (i === 2 || i === 5 || i === 6) {
			b += `<rect x="${x + 3}" y="${top + 6}" width="${sw - 6}" height="${H - top}" fill="#6d4c41"/>`;
			continue;
		}
		if (i) b += `<line x1="${x}" y1="${top}" x2="${x}" y2="${H}" stroke="#555" stroke-width="3"/>`;
		b += t(x + sw / 2 + 18, top + 40, 'Flugscham · selbsthilfe@example.org', 38, { font: 'Arial', rotate: 90 });
	}
	return { w: W, h: H, svg: svgDoc(W, H, b, '#fffdf6') };
}

// ── C2.2 · Anspielung: a job reference in the coded language ────────────────
function zeugnis() {
	const W = 2000, H = 2828;
	let b = '';
	b += t(220, 260, 'Nordlicht Bürobedarf GmbH', 64, { font: 'Arial', weight: 700, fill: '#0d47a1' });
	b += t(220, 330, 'Großer Burstah 21 · 20457 Hamburg', 40, { font: 'Arial', fill: '#555' });
	b += `<line x1="220" y1="370" x2="${W - 220}" y2="370" stroke="#0d47a1" stroke-width="4"/>`;
	b += t(W / 2, 560, 'Arbeitszeugnis', 96, { font: 'Georgia', weight: 700, anchor: 'middle' });
	const text = [
		'Herr Thomas Kessler, geboren am 3. März 1984 in Lübeck, war vom 1. April 2015 bis zum 30. September 2019 in unserem Unternehmen als Sachbearbeiter im Einkauf tätig.',
		'Zu seinen Aufgaben gehörten die Bestellung von Büromaterial, die Pflege der Lieferantendaten und die Ablage.',
		'Herr Kessler hat sich stets bemüht, die ihm übertragenen Aufgaben zu erledigen. Er erledigte sie im Großen und Ganzen zu unserer Zufriedenheit.',
		'Mit seiner Pünktlichkeit waren wir stets zufrieden. Durch seine Geselligkeit trug er zur Verbesserung des Betriebsklimas bei. Sein Verhalten gegenüber Kunden war einwandfrei.',
		'Herr Kessler verlässt uns auf eigenen Wunsch. Wir wünschen ihm für die Zukunft alles Gute, vor allem Gesundheit.'
	];
	let y = 760;
	for (const s of text) {
		const p = para(s, { x: 220, y, n: 52, size: 54, lh: 80 });
		b += p.svg;
		y = p.y + 60;
	}
	b += t(220, y + 60, 'Hamburg, 30. September 2019', 50, {});
	b += t(260, y + 260, 'B. Albers', 90, { font: HAND, fill: INK, rotate: -3 });
	b += t(220, y + 330, 'Birgit Albers, Personalleitung', 44, { font: 'Arial', fill: '#555' });
	return { w: W, h: H, svg: svgDoc(W, H, b, '#fdfcf8') };
}

const DOCS = {
	b2a12_woche_plan: woche,
	b2a22_verabredung_kino: kino,
	b2b11_bewerbung_anzeige: anzeige,
	b2b12_abschied_cv: lebenslauf,
	b2b21_interview_plakat: plakat,
	b2b22_forschung_zettel: zettel,
	b2c22_anspielung_doc: zeugnis
};

const only = process.argv.slice(2);
mkdirSync(`${OUT}web`, { recursive: true });
for (const [id, make] of Object.entries(DOCS)) {
	if (only.length && !only.includes(id)) continue;
	const { svg } = make();
	const png = await sharp(Buffer.from(svg), { density: 96 }).png().toBuffer();
	await sharp(png).jpeg({ quality: 90, mozjpeg: true }).toFile(`${OUT}${id}.jpg`);
	await sharp(png).resize({ width: 1400, height: 1400, fit: 'inside' }).jpeg({ quality: 80, mozjpeg: true }).toFile(`${OUT}web/${id}.jpg`);
	console.log(id);
}
