// Chart 36 (da- and wo- words): writes tool/charts/src/36-da-wo.html on the 15-gender.html
// skeleton. Left: how they are built (da- / wo- + preposition, with -r- before a vowel), fourteen
// prepositions. Right: thing or person? Six verbs from the Verb + preposition chart, each with the
// thing sentence → da-word / wo-question, and the person sentence → pronoun / wen-wem question.
// Course level B1.1 → B1.2.
// Run from the repo root: node tool/charts/build/build-36.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/36-da-wo.html';

const PLAIN = ['mit', 'für', 'von', 'zu', 'bei', 'nach', 'durch', 'gegen'];
const VOWEL = ['an', 'auf', 'über', 'um', 'in', 'aus'];
// [verb + prep, thing sentence, da-version, wo-question, person sentence, pronoun version, person question]
// [x] = da-/wo- word, {x} = preposition + pronoun
const VERBS = [
	['warten auf', 'Ich warte auf den Bus.', 'Ich warte [darauf].', '[Worauf] wartest du?', 'Ich warte auf Anna.', 'Ich warte {auf sie}.', '{Auf wen} wartest du?'],
	['denken an', 'Ich denke an die Prüfung.', 'Ich denke [daran].', '[Woran] denkst du?', 'Ich denke an meinen Vater.', 'Ich denke {an ihn}.', '{An wen} denkst du?'],
	['sprechen über', 'Wir sprechen über den Film.', 'Wir sprechen [darüber].', '[Worüber] sprecht ihr?', 'Wir sprechen über Tom.', 'Wir sprechen {über ihn}.', '{Über wen} sprecht ihr?'],
	['Angst haben vor', 'Sie hat Angst vor Spinnen.', 'Sie hat Angst [davor].', '[Wovor] hat sie Angst?', 'Sie hat Angst vor dem Chef.', 'Sie hat Angst {vor ihm}.', '{Vor wem} hat sie Angst?'],
	['träumen von', 'Er träumt von einem Haus.', 'Er träumt [davon].', '[Wovon] träumt er?', 'Er träumt von Lisa.', 'Er träumt {von ihr}.', '{Von wem} träumt er?'],
	['fragen nach', 'Er fragt nach dem Weg.', 'Er fragt [danach].', '[Wonach] fragt er?', 'Er fragt nach Maria.', 'Er fragt {nach ihr}.', '{Nach wem} fragt er?']
];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="dw">$1</b>').replace(/\{([^}]+)\}/g, '<b class="pw2">$1</b>');
const build = (list, r) => list.map((p) => { count += 2; return `<span class="bp">${p}</span><span class="bd">da${r ? '<i>r</i>' : ''}<b>${p}</b></span><span class="bd wo">wo${r ? '<i>r</i>' : ''}<b>${p}</b></span>`; }).join('');
const verbs = VERBS.map(([v, t, td, tq, p, pd, pq]) => { count += 6; return `<div class="vr"><span class="vv">${v}</span>
	<span class="vt"><span>${t}</span><span class="va">→ ${fx(td)}</span><span class="vq">${fx(tq)}</span></span>
	<span class="vt ps"><span>${p}</span><span class="va">→ ${fx(pd)}</span><span class="vq">${fx(pq)}</span></span></div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">auf den Bus → <b class="dw">darauf</b></div><small><b>a thing</b> da- + preposition</small></div>
					<div class="dm"><div class="w">auf Anna → <b class="pw2">auf sie</b></div><small><b>a person</b> preposition + pronoun</small></div>
					<div class="dm"><div class="w"><b class="dw">Worauf</b>? · <b class="pw2">Auf wen</b>?</div><small><b>questions</b> thing · person</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Many verbs come with a preposition: warten auf, denken an (Chart 7). When you do not repeat the thing, German glues the preposition to da-: Ich warte auf den Bus → Ich warte darauf (I am waiting for it).</span><span class="c2"><b>2</b>That only works for things. For people keep the preposition and add a pronoun: auf sie, an ihn. Questions work the same way: wo- for things (Worauf?), wen or wem for people (Auf wen?).</span></div><h3 class="lt">Look here first: <strong>a thing or a person?</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>things get da-, people get a pronoun</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Ich denke <b class="dw">daran</b>. · Ich denke <b class="pw2">an ihn</b>.</span></span><p>daran = about it (the exam). an ihn = about him (my father).</p></div></div>
		</div>

		<div class="dawo">
			<div class="bb"><div class="bh2"><b>How to build them</b><span>da- for answers, wo- for questions</span></div>
				<div class="bt">${build(PLAIN, false)}</div>
				<div class="bsep">a vowel next? add <i>r</i></div>
				<div class="bt">${build(VOWEL, true)}</div>
			</div>
			<div class="vb2"><div class="bh2"><b>Thing or person?</b><span>six verbs with a preposition</span></div><div class="vhr"><span></span><em>a thing → da- · wo-</em><em>a person → pronoun · wen, wem</em></div>${verbs}</div>
		</div>

		<div class="rules">
			<div class="rl">pointing ahead</div>
			<div><b class="lead">da- + dass / zu</b>Ich freue mich <b class="dw">darauf</b>, dass du kommst. · Ich denke <b class="dw">daran</b>, die Milch zu kaufen.</div>
			<div><b class="lead">spoken German</b>Ich warte drauf. · Da denke ich nicht dran. (dr- for dar-, when talking)</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">never da- for people</b><s>Ich warte darauf</s> (Anna) → Ich warte <b class="pw2">auf sie</b></div>
			<div><b class="lead">wen or wem?</b>The preposition decides: auf wen (Akkusativ) · von wem, mit wem (Dativ) <span class="aside">see Chart 22</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="dw">darauf</b> = da- or wo- word, for things</span> <span class="sp"><b class="pw2">auf sie</b> = preposition + pronoun, for people</span> <span class="sp"><i class="ri">r</i> = added before a vowel</span></div>
`;

const css = `
/* da wo version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.85cqw }
.dm small b { color: var(--navy) }
b.dw { background: var(--navy); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 700 }
b.pw2 { color: var(--navy); box-shadow: inset 0 0 0 .14cqw var(--navy); border-radius: .3cqw; padding: 0 .3cqw; font-weight: 700 }
.idea .chip .w { font-size: 1.42cqw }
.dawo { flex: 1; min-height: 0; display: grid; grid-template-columns: .68fr 2fr; gap: .9cqw }
.bb, .vb2 { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.bh2 { display: flex; align-items: baseline; flex-wrap: wrap; column-gap: .7cqw; background: var(--navy); color: #fff; padding: .1cqw .8cqw .25cqw }
.bh2 b { font-family: var(--serif); font-size: 1.3cqw; font-weight: 700 }
.bh2 > span { font-size: .64cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase }
.bt { flex: 8; min-height: 0; display: grid; grid-template-columns: 3.2cqw 1fr 1fr; grid-auto-rows: 1fr; align-items: center; padding: .1cqw .8cqw; column-gap: .4cqw }
.bt + .bsep + .bt { flex: 6 }
.bp { font-size: .82cqw; font-weight: 800; color: var(--muted) }
.bd { font-family: var(--serif); font-size: 1.22cqw; font-weight: 600; color: var(--navy) }
.bd b { font-weight: 800 }
.bd.wo { color: #5f5a52 }
.bd i, i.ri { font-style: normal; color: var(--terracotta-ink); font-weight: 800; text-decoration: underline; text-decoration-thickness: .12cqw; text-underline-offset: .15cqw }
.bsep { margin: 0 .8cqw; padding: .15cqw 0; border-top: .12cqw solid var(--navy-soft); border-bottom: .12cqw solid var(--navy-soft); font-size: .66cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--terracotta-ink); text-align: center }
.bsep i { font-style: normal; font-size: .95cqw; text-transform: none }
.vhr { display: grid; grid-template-columns: 7.6cqw minmax(0,1fr) minmax(0,1fr); column-gap: .7cqw; padding: .3cqw .8cqw 0 }
.vhr em { font-style: normal; font-size: .66cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: var(--navy); padding-left: .6cqw }
.vr { flex: 1; min-height: 0; display: grid; grid-template-columns: 7.6cqw minmax(0,1fr) minmax(0,1fr); align-items: stretch; column-gap: .7cqw; padding: 0 .8cqw; border-top: .1cqw solid #e3e8ef }
.vhr + .vr { border-top: 0 }
.vv { align-self: center; font-family: var(--serif); font-size: 1.1cqw; font-weight: 700; color: var(--navy); line-height: 1.15 }
.vt { display: grid; grid-template-columns: auto 1fr; grid-template-rows: 1fr 1fr; align-items: center; column-gap: .5cqw; padding: .1cqw .6cqw; background: #f4f6fa; border-radius: .4cqw; margin: .2cqw 0 }
.vt.ps { background: #fff; box-shadow: inset 0 0 0 .1cqw #d5dce6 }
.vt > span:first-child { grid-column: 1 / 3; font-family: var(--serif); font-size: .98cqw; font-weight: 500; color: var(--muted); white-space: nowrap }
.va, .vq { font-family: var(--serif); font-size: 1.04cqw; font-weight: 600; white-space: nowrap }
.vq { justify-self: end }
.rules s { color: #8b857c }
.key b.dw, .key b.pw2 { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>da- and wo- Words Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 36, da- and wo- words</h1>\n\t\t<p>darauf, worauf, auf ihn: replacing a thing or a person after a preposition.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 36</small>darauf, worauf, auf ihn');
rep('data-qr="15"', 'data-qr="36"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Thing or person?</span>
				<span><b>2</b>Thing: da- + preposition</span>
				<span><b>3</b>Person: preposition + pronoun</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 36 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
