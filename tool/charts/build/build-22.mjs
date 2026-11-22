// Chart 22 (question words), reworked: writes tool/charts/src/22-question-words.html on the
// 15-gender.html skeleton. Six boxes by what you want to know (who, what, where, when, how much
// and how, why); each row = question word, a real question, and the answer with the piece it asks
// for marked [like this]. wer/wen/wem/wessen wear the case colours. Course level A1.1 → A2.2.
// Run from the repo root: node tool/charts/build/build-22.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/22-question-words.html';

// [title, English, rows]; row = [word, case class or '', question, answer]
const BOXES = [
	['Who?', 'a person', [
		['wer', 'nom', 'Wer kommt heute?', '[Der Lehrer] kommt.'],
		['wen', 'akk', 'Wen siehst du?', 'Ich sehe [den Lehrer].'],
		['wem', 'dat', 'Wem hilfst du?', 'Ich helfe [dem Lehrer].'],
		['wessen', 'gen', 'Wessen Tasche ist das?', 'Die Tasche [des Lehrers].'],
		['mit wem', 'dat', 'Mit wem gehst du ins Kino?', 'Mit [Anna].'],
		['für wen', 'akk', 'Für wen ist das Geschenk?', 'Für [dich]!']
	]],
	['What?', 'a thing, an action', [
		['was', '', 'Was machst du?', 'Ich [koche].'],
		['was', '', 'Was ist das?', 'Das ist [ein Tisch].'],
		['welcher', '', 'Welcher Bus fährt zum Bahnhof?', '[Die Linie 5].'],
		['was für ein', '', 'Was für ein Auto hast du?', 'Ein [kleines, rotes].'],
		['womit', '', 'Womit schreibst du?', 'Mit [einem Bleistift].']
	]],
	['Where?', 'a place', [
		['wo', '', 'Wo wohnst du?', '[In Berlin].'],
		['wohin', '', 'Wohin fährst du im Sommer?', '[Nach Italien].'],
		['woher', '', 'Woher kommst du?', '[Aus Spanien].'],
		['wie weit', '', 'Wie weit ist der Bahnhof?', '[Zehn Minuten] zu Fuß.']
	]],
	['When?', 'a time', [
		['wann', '', 'Wann hast du Zeit?', '[Morgen].'],
		['um wie viel Uhr', '', 'Um wie viel Uhr beginnt der Kurs?', '[Um acht].'],
		['seit wann', '', 'Seit wann wohnst du hier?', '[Seit zwei Jahren].'],
		['wie lange', '', 'Wie lange bleibst du?', '[Eine Woche].'],
		['wie oft', '', 'Wie oft gehst du schwimmen?', '[Zweimal] pro Woche.'],
		['bis wann', '', 'Bis wann arbeitest du?', '[Bis fünf].']
	]],
	['How much? How?', 'an amount, a way', [
		['wie viel', '', 'Wie viel kostet das?', '[Zehn Euro].'],
		['wie viele', '', 'Wie viele Kinder hast du?', '[Zwei].'],
		['wie alt', '', 'Wie alt ist deine Tochter?', 'Sie ist [sechs].'],
		['wie', '', 'Wie fährst du zur Arbeit?', '[Mit dem Rad].'],
		['wie', '', 'Wie geht es dir?', '[Gut], danke!']
	]],
	['Why?', 'a reason, a purpose', [
		['warum', '', 'Warum lernst du Deutsch?', '[Weil ich hier arbeite].'],
		['wieso', '', 'Wieso bist du so müde?', '[Ich habe schlecht geschlafen].'],
		['wozu', '', 'Wozu brauchst du das Messer?', '[Zum Kochen].'],
		['wofür', '', 'Wofür sparst du?', '[Für eine Reise].']
	]]
];

let count = 0;
const boxes = BOXES.map(([t, en, rows]) => `<div class="qb"><div class="qh"><b>${t}</b><span>${en}</span></div>${rows.map(([w, c, q, a]) => {
	count++;
	return `<div class="qr2"><span class="qw ${c}">${w}</span><span class="qa"><span class="qq">${q}</span><span class="aa">${a.replace(/\[([^\]]+)\]/g, `<b class="${c}">$1</b>`)}</span></span></div>`;
}).join('')}</div>`).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w"><span class="qw">wo</span> <b>In</b> Berlin.</div><small><b>where</b> the place you are in</small></div>
					<div class="dm"><div class="w"><span class="qw">wohin</span> <b>Nach</b> Berlin.</div><small><b>where to</b> the place you go to</small></div>
					<div class="dm"><div class="w"><span class="qw">woher</span> <b>Aus</b> Berlin.</div><small><b>where from</b> the place you come from</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Every question word asks for one piece of information: a person, a thing, a place, a time, an amount or a reason. The answer can be just that piece.</span><span class="c2"><b>2</b>Find what you want to know in a box. The marked part of each answer is the piece the question asks for. wer, wen, wem, wessen all mean who, in the four cases.</span></div><h3 class="lt">Look here first: <strong>each question word asks for one piece</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>ask for the missing piece</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><span class="qw">Wann</span> kommt der Bus? <b>Um acht.</b></span></span><p>Question word first, verb second. The answer does not need a full sentence.</p></div></div>
		</div>

		<div class="qgrid">${boxes}</div>

		<div class="rules">
			<div class="rl">word order</div>
			<div><b class="lead">question word: verb second</b><span class="qw">Wo</span> <i class="vb">wohnst</i> du? · <span class="qw">Wann</span> <i class="vb">kommt</i> der Zug? <span class="aside">see Chart 3</span></div>
			<div><b class="lead">yes or no: verb first</b><i class="vb">Wohnst</i> du in Berlin? Ja. · <i class="vb">Kommt</i> der Zug? Nein, noch nicht.</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">wer = who, wo = where</b>not the English way round: <span class="qw">Wer</span> ist das? = Who is that? · <span class="qw">Wo</span> ist das? = Where is that?</div>
			<div><b class="lead">wie viel or wie viele?</b>wie viel + money, time, stuff: Wie viel Zeit? · wie viele + plural: Wie viele Leute?</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><span class="qw">wo</span> = the question word</span> <span class="sp"><b class="kk">In Berlin</b> = the piece it asks for</span> <span class="sp">Who in four cases: <span class="qw nom">wer</span> <span class="qw akk">wen</span> <span class="qw dat">wem</span> <span class="qw gen">wessen</span>, the case colours of Chart 1</span></div>
`;

const css = `
/* question words version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.9cqw; display: flex; align-items: center; gap: .5cqw }
.dm .w b { color: var(--terracotta-ink) }
.dm small b { color: var(--navy) }
.qw { display: inline-block; font-family: var(--serif); font-weight: 700; color: #fff; background: var(--navy); border-radius: .35cqw; padding: 0 .4cqw .05cqw; line-height: 1.25; white-space: nowrap }
.qw.nom { background: #fff; color: var(--ink); box-shadow: inset 0 0 0 .16cqw var(--ink) }
.qw.akk { background: var(--hi); color: var(--ink) }
.qw.dat { background: var(--dat) } .qw.gen { background: var(--gen, #0b6e74) }
.idea .chip .w { font-size: 1.5cqw }
.idea .chip .w b { color: var(--terracotta-ink) }
.qgrid { flex: 1; min-height: 0; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); grid-template-rows: 1fr 1fr; gap: .6cqw .9cqw }
.qb { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.qh { background: var(--navy); color: #fff; display: flex; align-items: baseline; gap: .8cqw; padding: .05cqw .9cqw .2cqw }
.qh b { font-family: var(--serif); font-size: 1.45cqw; font-weight: 700; line-height: 1.2 }
.qh span { font-size: .75cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase }
.qr2 { flex: 1; min-height: 0; display: grid; grid-template-columns: 6.6cqw 1fr; align-items: center; gap: .5cqw; padding: 0 .7cqw; border-top: .1cqw solid #dde3ec }
.qh + .qr2 { border-top: 0 }
.qr2 .qw { font-size: 1.08cqw; justify-self: start; white-space: normal; line-height: 1.1; padding: .05cqw .35cqw .1cqw }
.qa { display: flex; flex-direction: column; min-width: 0; line-height: 1.12 }
.qa .qq { font-family: var(--serif); font-size: 1.12cqw; font-weight: 700; white-space: nowrap }
.qa .aa { font-size: .92cqw; font-weight: 500; color: var(--muted); white-space: nowrap }
.qa .aa b { font-weight: 800; color: var(--ink); background: #e8edf4; border-radius: .2cqw; padding: 0 .2cqw }
.qa .aa b.akk { background: #fff4b3 } .qa .aa b.dat { background: #e6defa } .qa .aa b.gen { background: #d6eeee } .qa .aa b.nom { background: #fff; box-shadow: inset 0 0 0 .1cqw var(--ink) }
.rules .qw { font-size: 1cqw; padding: 0 .3cqw }
.rules i.vb { font-style: normal; font-weight: 800; color: var(--terracotta-ink) }
.key .qw { font-size: .95cqw; padding: 0 .3cqw }
.key b.kk { background: #e8edf4; padding: 0 .25cqw; border-radius: .2cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Question Words Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 22, question words</h1>\n\t\t<p>All the question words, by what you want to know, each with a real answer.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 22</small>wer, wo, wann, warum?');
rep('data-qr="15"', 'data-qr="22"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>What do you want to know?</span>
				<span><b>2</b>Find that box</span>
				<span><b>3</b>Question word first, verb second</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 22 built', Math.round(html.length / 1024) + ' KB,', count, 'question and answer pairs');
