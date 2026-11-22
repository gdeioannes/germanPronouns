// Chart 32 (zu + infinitive): writes tool/charts/src/32-zu-infinitive.html on the 15-gender.html
// skeleton. Left: after which words zu + infinitive follows (verbs, Es ist + adjective, nouns).
// Middle: um … zu, ohne … zu, statt … zu. Right: no zu (modals and friends), and zu inside
// split verbs. zu + infinitive = terracotta outline chip at the end. Course level B1.1.
// Run from the repo root: node tool/charts/build/build-32.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/32-zu-infinitive.html';

const AFTER = [
	['after verbs', ['Ich versuche, pünktlich {zu kommen}.', 'Er hat vergessen, mich {anzurufen}.', 'Wir hoffen, dich bald {zu sehen}.', 'Fang an {zu essen}!'], 'versuchen · vergessen · hoffen · anfangen · aufhören · beginnen · vorhaben · planen · sich freuen'],
	['Es ist + adjective', ['Es ist schwer, Deutsch {zu lernen}.', 'Es ist schön, dich {zu sehen}.', 'Es ist wichtig, viel Wasser {zu trinken}.'], 'schwer · leicht · wichtig · schön · gut · verboten · möglich'],
	['after nouns', ['Ich habe keine Zeit, {zu kochen}.', 'Hast du Lust, ins Kino {zu gehen}?', 'Ich habe Angst, Fehler {zu machen}.'], 'Zeit · Lust · Angst · die Idee · der Plan · die Möglichkeit']
];
const LINK = [
	['um … zu', 'in order to', 'Ich lerne Deutsch, [um] in Berlin {zu arbeiten}.', 'Er spart, [um] ein Auto {zu kaufen}.'],
	['ohne … zu', 'without …ing', 'Sie ging, [ohne] Tschüss {zu sagen}.', 'Er isst, [ohne] {zu kauen}.'],
	['statt … zu', 'instead of …ing', '[Statt] {zu lernen}, spielt er.', 'Ruf an, [statt] eine Mail {zu schreiben}!']
];
const NOZU = [['modal verbs', 'Ich kann schwimmen. · Ich muss gehen.'], ['werden (future)', 'Ich werde kommen.'], ['lassen', 'Ich lasse das Auto reparieren.'], ['gehen, kommen', 'Wir gehen essen. · Kommst du schwimmen?'], ['sehen, hören', 'Ich höre ihn singen.'], ['bleiben', 'Bleib sitzen!']];
const SPLIT = [['anrufen', 'anzurufen'], ['aufstehen', 'aufzustehen'], ['einkaufen', 'einzukaufen'], ['mitkommen', 'mitzukommen'], ['besuchen', 'zu besuchen'], ['verstehen', 'zu verstehen']];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="lk2">$1</b>').replace(/\{([^}]+)\}/g, '<b class="zi">$1</b>');
const after = AFTER.map(([h, ex, words]) => { count += ex.length + words.split(' · ').length; return `<div class="ag"><div class="ah">${h}</div>${ex.map((e) => `<div class="ae"><span>${fx(e)}</span></div>`).join('')}<div class="aw">${words}</div></div>`; }).join('');
const link = LINK.map(([w, en, a, b]) => { count += 2; return `<div class="lr"><div class="lw"><b>${w}</b><span>${en}</span></div><div class="le"><span>${fx(a)}</span><span>${fx(b)}</span></div></div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Ich <b class="v2">kann</b> schwimmen.</div><small><b>modal verb</b> no zu</small></div>
					<div class="dm"><div class="w">Ich <b class="v2">versuche</b>, <b class="zi">zu schwimmen</b>.</div><small><b>other verbs</b> zu + infinitive</small></div>
					<div class="dm"><div class="w">…, <b class="lk2">um</b> fit <b class="zi">zu bleiben</b>.</div><small><b>um … zu</b> in order to</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>When a second verb depends on the first, it goes to the end as an infinitive. After modal verbs it stands alone; after most other verbs, adjectives and nouns it needs zu.</span><span class="c2"><b>2</b>Left: where zu + infinitive follows. Middle: um, ohne, statt + zu. Right: the verbs that never take zu, and where zu goes in a split verb.</span></div><h3 class="lt">Look here first: <strong>zu + infinitive goes at the end</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>a comma, then zu + infinitive last</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Ich habe keine Zeit, <b class="zi">zu kochen</b>.</span></span><p>The second part starts after the comma; zu + infinitive closes it.</p></div></div>
		</div>

		<div class="zz">
			<div class="bx a"><div class="bh"><b>When do you need zu?</b><span>the infinitive goes last</span></div>${after}</div>
			<div class="bx l"><div class="bh"><b>um, ohne, statt + zu</b><span>a purpose, a missing action</span></div>${link}
				<div class="dz"><b>dass or zu?</b><span>Same person: Ich hoffe, <b class="zi">zu gewinnen</b>.</span><span>Another person: Ich hoffe, dass <b>du</b> gewinnst.</span></div>
			</div>
			<div class="right">
				<div class="bx n"><div class="bh"><b>No zu after these</b></div>${NOZU.map(([v, e]) => { count++; return `<div class="nr"><span class="nv">${v}</span><span class="ne">${e}</span></div>`; }).join('')}</div>
				<div class="bx sv"><div class="bh"><b>zu in split verbs</b><span>it goes in the middle</span></div><div class="sg">${SPLIT.map(([a, b]) => { count++; return `<span><small>${a}</small><b>${b.replace('zu', '<u>zu</u>')}</b></span>`; }).join('')}</div></div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">comma</div>
			<div><b class="lead">a comma before um, ohne, statt</b>Ich lerne<b>,</b> um zu arbeiten. · Er ging<b>,</b> ohne zu fragen.</div>
			<div><b class="lead">brauchen + nicht zu</b>Du brauchst nicht <b class="zi">zu kommen</b> = Du musst nicht kommen</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">um … zu or damit?</b>same person: Ich lerne, um <b class="zi">zu bestehen</b> · another person: Ich erkläre es, damit <b>du</b> es verstehst</div>
			<div><b class="lead">two verbs: zu before the last</b>Ich hoffe, dich besuchen <b class="zi">zu können</b>. · Es ist schön, eingeladen <b class="zi">zu werden</b>.</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="zi">zu kochen</b> = zu + infinitive</span> <span class="sp"><b class="v2">versuche</b> = the first verb</span> <span class="sp"><b class="lk2">um</b> = linking word</span> <span class="sp">split verbs: Chart 11</span></div>
`;

const css = `
/* zu infinitive version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.55cqw }
.dm small b { color: var(--navy) }
b.zi { box-shadow: inset 0 0 0 .14cqw var(--terracotta-ink); color: var(--terracotta-ink); border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
b.v2 { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
b.lk2 { background: var(--navy); color: #fff; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.5cqw }
.zz { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.15fr 1fr .85fr; gap: .8cqw }
.right { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.bx { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.bx.n { border-color: #8b95a3; flex: 1.2 } .bx.sv { border-color: var(--terracotta-ink); flex: 1 }
.bh { background: var(--navy); color: #fff; display: flex; flex-direction: column; padding: .1cqw .8cqw .25cqw }
.bx.n .bh { background: #6b7684 } .bx.sv .bh { background: var(--terracotta-ink) }
.bh b { font-family: var(--serif); font-size: 1.35cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .68cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.ag { flex: 1; min-height: 0; display: flex; flex-direction: column; padding: .2cqw .8cqw .25cqw; border-top: .12cqw solid #dde3ec }
.bh + .ag { border-top: 0 }
.ah { font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--navy) }
.ae { flex: 1; display: flex; align-items: center; font-family: var(--serif); font-size: 1.1cqw; font-weight: 600; white-space: nowrap; min-height: 0 }
.aw { font-size: .78cqw; font-weight: 600; color: var(--muted); line-height: 1.3 }
.lr { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; gap: .2cqw; padding: 0 .8cqw; border-top: .12cqw solid #dde3ec }
.bh + .lr { border-top: 0 }
.lw { display: flex; align-items: baseline; gap: .6cqw }
.lw b { font-family: var(--serif); font-size: 1.5cqw; font-weight: 700; color: var(--navy) }
.lw span { font-size: .74cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--muted) }
.le { display: flex; flex-direction: column; gap: .15cqw; font-family: var(--serif); font-size: 1.1cqw; font-weight: 600 }
.le span { white-space: nowrap }
.dz { display: flex; flex-direction: column; gap: .15cqw; padding: .4cqw .8cqw .5cqw; background: var(--navy-soft); border-top: .15cqw solid var(--navy); font-family: var(--serif); font-size: 1.02cqw; font-weight: 600 }
.dz > b { font-family: var(--sans); font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--navy) }
.dz span { white-space: nowrap }
.nr { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; padding: 0 .8cqw; border-top: .1cqw solid #e3e6ea }
.bh + .nr { border-top: 0 }
.nv { font-size: .74cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: #555e6a }
.ne { font-family: var(--serif); font-size: 1.02cqw; font-weight: 600; white-space: nowrap }
.sg { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-auto-rows: 1fr; gap: 0 .6cqw; padding: .2cqw .8cqw .3cqw }
.sg span { display: flex; flex-direction: column; justify-content: center; border-bottom: .08cqw solid #f0e2d9 }
.sg small { font-size: .7cqw; font-weight: 700; color: var(--muted) }
.sg b { font-family: var(--serif); font-size: 1.22cqw; font-weight: 700; line-height: 1.1 }
.sg u { color: var(--terracotta-ink); text-decoration: none; background: #fbe3d4; border-radius: .2cqw; padding: 0 .08cqw }
.key b.zi, .key b.v2, .key b.lk2 { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>zu + Infinitive Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 32, zu + infinitive</h1>\n\t\t<p>When the second verb needs zu, um … zu, ohne … zu, and when there is no zu.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 32</small>zu, um … zu, ohne … zu');
rep('data-qr="15"', 'data-qr="32"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Modal verb? No zu</span>
				<span><b>2</b>Otherwise: comma, then zu</span>
				<span><b>3</b>Infinitive at the end</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 32 built', Math.round(html.length / 1024) + ' KB,', count, 'examples and words');
