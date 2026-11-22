// Chart 35 (reflexive verbs): writes tool/charts/src/35-reflexive.html on the 15-gender.html
// skeleton. Left: the reflexive pronouns in Akkusativ and Dativ (only ich and du differ). Middle:
// twelve everyday reflexive verbs with a sentence each. Right: mich or mir? pairs (another object
// → Dativ) and verbs that always take the Dativ pronoun. Course level A2.1 → A2.2.
// Run from the repo root: node tool/charts/build/build-35.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/35-reflexive.html';

const PRON = [['ich', 'mich', 'mir', true], ['du', 'dich', 'dir', true], ['er · sie · es', 'sich', 'sich'], ['wir', 'uns', 'uns'], ['ihr', 'euch', 'euch'], ['sie · Sie', 'sich', 'sich']];
// [verb, English, sentence]; [x] = Akkusativ pronoun, {x} = Dativ pronoun
const AKK = [
	['sich freuen', 'be happy', 'Ich freue [mich] auf das Wochenende.'],
	['sich setzen', 'sit down', 'Setz [dich] doch!'],
	['sich beeilen', 'hurry', 'Wir müssen [uns] beeilen.'],
	['sich treffen', 'meet', 'Wir treffen [uns] um acht.'],
	['sich erinnern', 'remember', 'Erinnerst du [dich] an ihn?'],
	['sich interessieren', 'be interested', 'Sie interessiert [sich] für Kunst.'],
	['sich ärgern', 'be annoyed', 'Ich ärgere [mich] über den Lärm.'],
	['sich ausruhen', 'rest', 'Ruh [dich] ein bisschen aus!'],
	['sich verlieben', 'fall in love', 'Er hat [sich] in Lisa verliebt.'],
	['sich entschuldigen', 'say sorry', 'Ich entschuldige [mich].'],
	['sich fühlen', 'feel', 'Wie fühlst du [dich]?'],
	['sich gewöhnen', 'get used to', 'Ihr gewöhnt [euch] an das Wetter.']
];
const PAIRS = [
	['Ich wasche [mich].', 'Ich wasche {mir} die Hände.'],
	['Ich ziehe [mich] an.', 'Ich ziehe {mir} eine Jacke an.'],
	['Du kämmst [dich].', 'Du kämmst {dir} die Haare.'],
	['Ich rasiere [mich].', 'Ich rasiere {mir} den Bart.'],
	['Ich verletze [mich].', 'Ich breche {mir} den Arm.']
];
const DAT = [
	['sich etwas vorstellen', 'Ich stelle {mir} das schwer vor.'],
	['sich etwas wünschen', 'Ich wünsche {mir} ein Fahrrad.'],
	['sich etwas ansehen', 'Sieh {dir} das an!'],
	['sich etwas merken', 'Ich kann {mir} keine Namen merken.'],
	['sich etwas leisten', 'Das kann ich {mir} nicht leisten.'],
	['sich etwas kaufen', 'Ich kaufe {mir} ein Eis.'],
	['sich die Zähne putzen', 'Ich putze {mir} die Zähne.']
];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="ra">$1</b>').replace(/\{([^}]+)\}/g, '<b class="rd">$1</b>');
const pron = PRON.map(([p, a, d, diff]) => { count += 2; return `<span class="rp">${p}</span><span class="rx${diff ? ' df' : ''}"><b class="ra">${a}</b></span><span class="rx${diff ? ' df' : ''}"><b class="rd">${d}</b></span>`; }).join('');
const akk = AKK.map(([v, en, s]) => { count++; return `<div class="rv"><span class="rn"><b>${v}</b><small>${en}</small></span><span class="rs">${fx(s)}</span></div>`; }).join('');
const pairs = PAIRS.map(([a, b]) => { count += 2; return `<div class="rpair"><span class="rs">${fx(a)}</span><span class="rar">→</span><span class="rs">${fx(b)}</span></div>`; }).join('');
const dat = DAT.map(([v, s]) => { count++; return `<div class="rv"><span class="rn"><b>${v}</b></span><span class="rs">${fx(s)}</span></div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Ich wasche <b class="ra">mich</b>.</div><small><b>myself</b> nothing else</small></div>
					<div class="dm"><div class="w">Ich wasche <b class="rd">mir</b> die Hände.</div><small><b>for myself</b> + another thing</small></div>
					<div class="dm"><div class="w">Er freut <b class="ra">sich</b>.</div><small><b>he, she, it, they</b> always sich</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>A reflexive verb points back at the person doing it: Ich setze mich (I sit myself down). Many verbs come with sich in the dictionary: sich freuen, sich beeilen. Learn sich with the verb.</span><span class="c2"><b>2</b>The pronoun is mich or mir, dich or dir: the same rule as Chart 21. Nothing else in the sentence → mich. Another thing is there (die Hände, eine Jacke) → mir. With er, sie, es and Sie it is always sich.</span></div><h3 class="lt">Look here first: <strong>the action comes back to me</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>another thing? then mir</strong></h3>
				<div class="proof"><span class="chip"><span class="w">ziehe <b class="ra">mich</b> an · ziehe <b class="rd">mir</b> Schuhe an</span></span><p>When the sentence names another thing, that thing takes the Akkusativ, and mich turns into mir.</p></div></div>
		</div>

		<div class="refl">
			<div class="rb"><div class="rh"><b>The pronouns</b><span>only ich and du change</span></div>
				<div class="rt"><span></span><span class="rq">Akkusativ</span><span class="rq">Dativ</span>${pron}</div></div>
			<div class="rb"><div class="rh"><b>Everyday reflexive verbs</b><span>with mich, dich, sich</span></div>${akk}</div>
			<div class="rcol">
				<div class="rb ac"><div class="rh dh2"><b>mich or mir?</b><span>is there another thing?</span></div>${pairs}</div>
				<div class="rb ac"><div class="rh dh2"><b>Always mir</b><span>sich + a thing</span></div>${dat}</div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">word order</div>
			<div><b class="lead">sich comes early</b>Ich habe <b class="ra">mich</b> gefreut. · …, weil ich <b class="ra">mich</b> freue.</div>
			<div><b class="lead">each other</b>Wir treffen <b class="ra">uns</b>. · Sie lieben <b class="ra">sich</b>. · Ihr kennt <b class="ra">euch</b> schon?</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">sich only for 3rd person</b><s>ich freue sich</s> → ich freue <b class="ra">mich</b></div>
			<div><b class="lead">same verb, no sich</b>Ich wasche <b class="ra">mich</b>. · Ich wasche das Auto. <span class="aside">see Chart 21</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="ra">mich</b> = Akkusativ: the person alone</span> <span class="sp"><b class="rd">mir</b> = Dativ: there is another thing</span> <span class="sp">the case colours of Chart 1</span></div>
`;

const css = `
/* reflexive version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.85cqw }
.dm small b { color: var(--navy) }
b.ra { background: #fff4b3; box-shadow: inset 0 0 0 .12cqw #d9b600; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
b.rd { background: #e6defa; color: #3d2380; box-shadow: inset 0 0 0 .12cqw #7b5fc9; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.45cqw }
.refl { flex: 1; min-height: 0; display: grid; grid-template-columns: .62fr 1.25fr 1.3fr; gap: .8cqw }
.rcol { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.rb { flex: 1; min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.rb.ac { border-color: #7b5fc9 }
.rh { display: flex; flex-direction: column; background: var(--navy); color: #fff; padding: .1cqw .8cqw .25cqw }
.rh.dh2 { flex-direction: row; align-items: baseline; gap: .7cqw; background: #5b3aa8 }
.rh b { font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; line-height: 1.2 }
.rh span { font-size: .64cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase }
.rt { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.3fr 1fr 1fr; grid-template-rows: auto; grid-auto-rows: 1fr; align-items: center; padding: .2cqw .7cqw .3cqw; column-gap: .3cqw }
.rq { font-size: .58cqw; font-weight: 800; letter-spacing: .03em; text-transform: uppercase; color: var(--muted); padding-bottom: .2cqw }
.rp { font-size: .86cqw; font-weight: 700; color: var(--muted); line-height: 1.15 }
.rx { font-family: var(--serif); font-size: 1.3cqw }
.rx.df b { font-size: 1.5cqw }
.rv { flex: 1; min-height: 0; display: grid; grid-template-columns: 10.6cqw 1fr; align-items: center; column-gap: .6cqw; padding: 0 .8cqw; border-top: .1cqw solid #e3e8ef }
.rh + .rv { border-top: 0 }
.rcol .rv { grid-template-columns: 12.6cqw 1fr }
.rn { display: flex; flex-direction: column; line-height: 1.1 }
.rn b { font-family: var(--serif); font-size: 1.05cqw; font-weight: 700; color: var(--navy) }
.rn small { font-size: .62cqw; font-weight: 700; color: var(--muted) }
.rs { font-family: var(--serif); font-size: 1.08cqw; font-weight: 600; white-space: nowrap }
.rpair { flex: 1; min-height: 0; display: grid; grid-template-columns: auto auto 1fr; align-items: center; column-gap: .5cqw; padding: 0 .8cqw; border-top: .1cqw solid #ece6f8 }
.rh + .rpair { border-top: 0 }
.rar { color: #7b5fc9; font-weight: 800 }
.rules s { color: #8b857c }
.key b.ra, .key b.rd { padding: 0 .25cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Reflexive Verbs Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 35, reflexive verbs</h1>\n\t\t<p>ich freue mich, ich wasche mir die Hände: mich or mir with reflexive verbs.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 35</small>ich freue mich');
rep('data-qr="15"', 'data-qr="35"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Is sich part of the verb?</span>
				<span><b>2</b>Another thing there?</span>
				<span><b>3</b>No: mich · Yes: mir</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 35 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
