// Chart 38 (indirect speech): writes tool/charts/src/38-indirect-speech.html on the 15-gender.html
// skeleton. Left: Konjunktiv I forms of five verbs; where a form looks like the present tense it is
// struck through and replaced by Konjunktiv II (violet, as on the Konjunktiv II chart). Right: four
// kinds of sentence (statement, question, request, past), direct → indirect. Bottom strip: what
// shifts (person, time, place). Course level B2.1 → C1.1.
// Run from the repo root: node tool/charts/build/build-38.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/38-indirect-speech.html';

// per person: one cell per verb; 'x' = Konjunktiv I, 'old>new' = looks like the present, use Konjunktiv II
const VERBS = ['sein', 'haben', 'werden', 'können', 'kommen'];
const ROWS = [
	['ich', ['sei', 'habe>hätte', 'werde>würde', 'könne', 'komme>käme']],
	['du', ['sei(e)st', 'habest', 'werdest', 'könnest', 'kommest']],
	['er · sie · es', ['sei', 'habe', 'werde', 'könne', 'komme'], true],
	['wir', ['seien', 'haben>hätten', 'werden>würden', 'können>könnten', 'kommen>kämen']],
	['ihr', ['seiet', 'habet', 'werdet>würdet', 'könnet', 'kommet']],
	['sie · Sie', ['seien', 'haben>hätten', 'werden>würden', 'können>könnten', 'kommen>kämen']]
];
// [kind, how, [direct, indirect]...]; [x] = Konjunktiv I, {x} = Konjunktiv II, <x> = linking word
const KINDS = [
	['Statements', 'dass is optional', [
		['„Ich bin krank.“', 'Er sagt, er [sei] krank.'],
		['„Wir haben keine Zeit.“', 'Sie sagen, sie {hätten} keine Zeit.'],
		['„Der Zug ist pünktlich.“', 'Sie meint, <dass> der Zug pünktlich [sei].']]],
	['Questions', 'ob, or the question word', [
		['„Kommt Anna mit?“', 'Sie fragt, <ob> Anna mit[komme].'],
		['„Wo wohnt Ihr Sohn?“', 'Er fragt, <wo> mein Sohn [wohne].'],
		['„Wann beginnt der Kurs?“', 'Sie will wissen, <wann> der Kurs [beginne].']]],
	['Requests', 'sollen, or mögen (polite)', [
		['„Ruf mich an!“', 'Er sagt, ich [solle] ihn anrufen.'],
		['„Bitte warten Sie.“', 'Sie bittet, man [möge] warten.'],
		['„Mach das Fenster zu!“', 'Sie sagt, ich [solle] das Fenster zumachen.']]],
	['The past', 'one form: sei or habe + participle', [
		['„Ich war krank.“', 'Er sagt, er [sei] krank gewesen.'],
		['„Ich habe es gesehen.“', 'Sie sagt, sie [habe] es gesehen.'],
		['„Wir kamen zu spät.“', 'Sie sagen, sie [seien] zu spät gekommen.']]]
];
const SHIFT = [['ich', 'er, sie'], ['heute', 'an dem Tag'], ['morgen', 'am nächsten Tag'], ['gestern', 'am Tag davor'], ['hier', 'dort'], ['jetzt', 'damals']];

let count = 0;
const cell = (c) => { count++; if (!c.includes('>')) return `<span class="kc"><b class="k1">${c}</b></span>`; const [o, n] = c.split('>'); return `<span class="kc"><s>${o}</s><b class="k2b">${n}</b></span>`; };
const table = ROWS.map(([p, cells, star]) => `<span class="kp${star ? ' st' : ''}">${p}${star ? '<small>you need this most</small>' : ''}</span>${cells.map(cell).join('')}`).join('');
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="k1">$1</b>').replace(/\{([^}]+)\}/g, '<b class="k2b">$1</b>').replace(/<(dass|ob|wo|wann)>/g, '<u>$1</u>');
const kinds = KINDS.map(([k, how, pairs]) => `<div class="ik"><div class="ikh"><b>${k}</b><span>${how}</span></div>${pairs.map(([d, i]) => { count += 2; return `<div class="ip"><span class="id">${d}</span><span class="ia">→</span><span class="ii2">${fx(i)}</span></div>`; }).join('')}</div>`).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">„Ich bin krank.“ → er <b class="k1">sei</b> krank</div><small><b>Konjunktiv I</b> reported, not my words</small></div>
					<div class="dm"><div class="w">„Wir haben …“ → sie <b class="k2b">hätten</b></div><small><b>Konjunktiv II</b> if Konjunktiv I = present</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Indirect speech reports what someone else said, without quotation marks: Er sagt, er sei krank. The special verb form (Konjunktiv I) shows the words are his, not the writer's. News, reports and articles use it all the time.</span><span class="c2"><b>2</b>You mostly need er, sie, es: sei, habe, werde, könne, komme (the stem + -e). When a Konjunktiv I form looks exactly like the present (sie haben), German switches to Konjunktiv II (sie hätten). Below: the forms, then four kinds of sentence.</span></div><h3 class="lt">Look here first: <strong>he says, not I say</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>stem + e, for er, sie, es</strong></h3>
				<div class="proof"><span class="chip"><span class="w">er komm<b class="k1">e</b> · er hab<b class="k1">e</b> · er könn<b class="k1">e</b> · er <b class="k1">sei</b></span></span><p>Take the infinitive, drop -en, add -e. Only sein is different: sei.</p></div></div>
		</div>

		<div class="ind">
			<div class="kb2"><div class="kbh"><b>The forms</b><span>struck out = looks like the present → Konjunktiv II</span></div>
				<div class="kt"><span></span>${VERBS.map((v) => `<span class="kv">${v}</span>`).join('')}${table}</div>
			</div>
			<div class="iks">${kinds}</div>
		</div>

		<div class="rules">
			<div class="rl">what shifts</div>
			<div class="shf">${SHIFT.map(([a, b]) => { count++; return `<span>${a} → <b>${b}</b></span>`; }).join('')}</div>
			<div><b class="lead">the future</b>„Ich komme morgen.“ → Er sagt, er <b class="k1">werde</b> am nächsten Tag kommen.</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">talking: no Konjunktiv I</b>In speech people say: Er sagt, er <b class="k2b">wäre</b> krank, or simply: Er sagt, er ist krank.</div>
			<div><b class="lead">not doubt, distance</b>Konjunktiv I does not say it is false: it says who said it. <span class="aside">see Chart 31</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="k1">sei</b> = Konjunktiv I</span> <span class="sp"><b class="k2b">hätten</b> = Konjunktiv II, the colour of Chart 31</span> <span class="sp"><s>haben</s> = looks like the present, not used</span> <span class="sp"><u>ob</u> = the linking word</span></div>
`;

const css = `
/* indirect speech version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.75cqw }
.dm small b { color: var(--navy) }
b.k1 { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
b.k2b { background: #e6defa; color: #3d2380; box-shadow: inset 0 0 0 .12cqw #7b5fc9; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.45cqw }
.idea .chip b.k1 { padding: 0 .12cqw }
.ind { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1.55fr; gap: .9cqw }
.kb2 { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.kbh { display: flex; flex-direction: column; background: var(--navy); color: #fff; padding: .1cqw .8cqw .25cqw }
.kbh b { font-family: var(--serif); font-size: 1.3cqw; font-weight: 700 }
.kbh span { font-size: .62cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase }
.kt { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.25fr repeat(5, 1fr); grid-template-rows: auto; grid-auto-rows: 1fr; align-items: center; padding: .2cqw .7cqw .3cqw; column-gap: .3cqw }
.kv { font-family: var(--serif); font-size: 1cqw; font-weight: 700; color: var(--navy); padding-bottom: .2cqw; border-bottom: .12cqw solid var(--navy-soft); align-self: end }
.kp { font-size: .82cqw; font-weight: 700; color: var(--muted); display: flex; flex-direction: column; line-height: 1.15 }
.kp.st { color: var(--terracotta-ink); font-weight: 800 }
.kp small { font-size: .52cqw; font-weight: 800; letter-spacing: .03em; text-transform: uppercase }
.kc { display: flex; flex-direction: column; align-items: flex-start; font-family: var(--serif); font-size: 1.02cqw; line-height: 1.2 }
.kc s { font-size: .78cqw; color: #8b857c }
.kc b { padding: 0 .18cqw }
.iks { min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: 1fr 1fr; gap: .6cqw }
.ik { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.ikh { display: flex; align-items: baseline; gap: .6cqw; background: var(--navy); color: #fff; padding: .1cqw .8cqw .22cqw }
.ikh b { font-family: var(--serif); font-size: 1.25cqw; font-weight: 700 }
.ikh span { font-size: .6cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase }
.ip { flex: 1; min-height: 0; display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto auto; align-content: center; column-gap: .4cqw; padding: 0 .8cqw; border-top: .1cqw solid #e3e8ef }
.ikh + .ip { border-top: 0 }
.id { grid-column: 1 / 3; font-family: var(--serif); font-size: .92cqw; font-weight: 500; color: var(--muted); white-space: nowrap }
.ia { color: var(--terracotta-ink); font-weight: 800; font-size: .95cqw }
.ii2 { font-family: var(--serif); font-size: 1.04cqw; font-weight: 600; white-space: nowrap }
.ii2 b { padding: 0 .18cqw }
u, .key u { text-decoration: none; box-shadow: inset 0 -.25cqw 0 #ffe14d }
.rules .shf { display: flex; flex-wrap: wrap; gap: .1cqw 1cqw; align-items: center }
.rules .shf b { color: var(--navy); font-weight: 800 }
.rules s, .key s { color: #8b857c }
.key b.k1, .key b.k2b { padding: 0 .25cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Indirect Speech Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 38, indirect speech</h1>\n\t\t<p>er sagt, er sei krank: Konjunktiv I for reporting what others said.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 38</small>er sagt, er sei krank');
rep('data-qr="15"', 'data-qr="38"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Who said it?</span>
				<span><b>2</b>Stem + e (sein: sei)</span>
				<span><b>3</b>Like the present? Konjunktiv II</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 38 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
