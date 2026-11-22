// Chart 28 (verbs with Dativ, and two objects): writes tool/charts/src/28-dativ-verbs.html on the
// 15-gender.html skeleton. Left: verbs that take only a Dativ, in two groups (a person does it to
// someone / a thing does it to a person: Das gefällt mir). Right: the order of two objects on a
// slot line, and the verbs that give someone something. Course level A2.1 → A2.2.
// Run from the repo root: node tool/charts/build/build-28.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/28-dativ-verbs.html';

const PERSON = [
	['helfen', 'to help', 'Ich helfe [dir].'], ['danken', 'to thank', 'Wir danken [Ihnen].'], ['antworten', 'to answer', 'Antworte [mir]!'],
	['glauben', 'to believe', 'Ich glaube [dir].'], ['gratulieren', 'to congratulate', 'Wir gratulieren [dem Team].'], ['zuhören', 'to listen to', 'Hör [mir] zu!'],
	['folgen', 'to follow', 'Folgen Sie [dem Bus]!'], ['vertrauen', 'to trust', 'Ich vertraue [ihr].'], ['begegnen', 'to run into', 'Ich bin [ihm] begegnet.']
];
const THING = [
	['gefallen', 'to please', 'Der Film gefällt [mir].'], ['schmecken', 'to taste good', 'Die Suppe schmeckt [uns].'], ['gehören', 'to belong to', 'Das Buch gehört [ihm].'],
	['passen', 'to fit', 'Die Hose passt [mir] nicht.'], ['stehen', 'to suit', 'Das Kleid steht [dir].'], ['fehlen', 'to be missed', 'Du fehlst [mir].'],
	['wehtun', 'to hurt', 'Der Kopf tut [mir] weh.'], ['leidtun', 'to be sorry', 'Es tut [mir] leid.'], ['gelingen', 'to work out', 'Der Kuchen ist [mir] gelungen.']
];
const GIVE = ['geben', 'schenken', 'zeigen', 'schicken', 'bringen', 'erklären', 'leihen', 'empfehlen', 'sagen', 'erzählen', 'kaufen', 'schreiben'];

let count = 0;
const dat = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="dat">$1</b>');
const list = (rows) => rows.map(([v, en, s]) => { count += 2; return `<div class="vr"><span class="vb">${v}<small>${en}</small></span><span class="vs">${dat(s)}</span></div>`; }).join('');
const slot = (cls, t) => `<span class="sl ${cls}">${t}</span>`;

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Ich helfe <b class="dat">dir</b>.</div><small><b>helfen</b> you get the help</small></div>
					<div class="dm"><div class="w">Das gefällt <b class="dat">mir</b>.</div><small><b>gefallen</b> it pleases me</small></div>
					<div class="dm"><div class="w">Ich gebe <b class="dat">dir</b> <b class="akk">das Buch</b>.</div><small><b>geben</b> you get the book</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Most verbs take an Akkusativ. A few take a Dativ: the person who gets help, thanks, an answer, or who is pleased. With give-verbs, the person who gets something is Dativ, the thing is Akkusativ.</span><span class="c2"><b>2</b>Left: learn the Dativ verbs in two groups. Right: the order when a sentence has two objects.</span></div><h3 class="lt">Look here first: <strong>the person who receives is Dativ</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>who gets it? Dativ</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Ich gebe <b class="dat">dem Kind</b> <b class="akk">den Ball</b>.</span></span><p>Who gets something? Dativ. What is given? Akkusativ.</p></div></div>
		</div>

		<div class="dv">
			<div class="bx l"><div class="bh"><b>Verbs with a Dativ</b><span>no Akkusativ at all</span></div>
				<div class="cols">
					<div class="g"><div class="gh">A person does it to someone</div>${list(PERSON)}</div>
					<div class="g"><div class="gh">A thing does it to a person</div>${list(THING)}</div>
				</div>
			</div>
			<div class="right">
				<div class="bx o"><div class="bh"><b>Two objects: which goes first?</b></div>
					<div class="sr"><span class="sn">two nouns</span><span class="line">${slot('s', 'Ich')}${slot('v', 'gebe')}${slot('d', 'dem Kind')}${slot('a', 'den Ball')}</span><span class="rule">Dativ, then Akkusativ</span></div>
					<div class="sr"><span class="sn">one pronoun</span><span class="line">${slot('s', 'Ich')}${slot('v', 'gebe')}${slot('a', 'ihn')}${slot('d', 'dem Kind')}</span><span class="rule">the pronoun first</span></div>
					<div class="sr"><span class="sn">one pronoun</span><span class="line">${slot('s', 'Ich')}${slot('v', 'gebe')}${slot('d', 'ihm')}${slot('a', 'den Ball')}</span><span class="rule">the pronoun first</span></div>
					<div class="sr"><span class="sn">two pronouns</span><span class="line">${slot('s', 'Ich')}${slot('v', 'gebe')}${slot('a', 'ihn')}${slot('d', 'ihm')}</span><span class="rule">Akkusativ, then Dativ</span></div>
				</div>
				<div class="bx gv"><div class="bh"><b>Give-verbs</b><span>someone (Dativ) something (Akkusativ)</span></div>
					<div class="gl">${GIVE.map((v) => { count++; return `<span>${v}</span>`; }).join('')}</div>
					<div class="ge"><span>Ich schenke <b class="dat">meiner Mutter</b> <b class="akk">Blumen</b>.</span><span>Kannst du <b class="dat">mir</b> <b class="akk">das</b> erklären?</span><span>Er zeigt <b class="dat">uns</b> <b class="akk">die Stadt</b>.</span></div>
				</div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">English vs German</div>
			<div><b class="lead">I like it = it pleases me</b>I like the film → Der Film gefällt <b class="dat">mir</b> · I like the soup → Die Suppe schmeckt <b class="dat">mir</b></div>
			<div><b class="lead">I'm sorry, it hurts</b>Es tut <b class="dat">mir</b> leid · Mein Bein tut <b class="dat">mir</b> weh · Mir ist kalt <span class="aside">see Chart 21</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">these take Akkusativ</b>Ich frage <b class="akk">dich</b> · Ich rufe <b class="akk">dich</b> an · Ich besuche <b class="akk">dich</b> · Ich brauche <b class="akk">dich</b></div>
			<div><b class="lead">helfen: no Akkusativ</b><s>Ich helfe dich.</s> → Ich helfe <b class="dat">dir</b>. · <s>Ich danke dich.</s> → Ich danke <b class="dat">dir</b>.</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="dat">dir</b> = Dativ, the one who gets or is helped</span> <span class="sp"><b class="akk">das Buch</b> = Akkusativ, the thing</span> <span class="sp">the case colours of Chart 1</span></div>
`;

const css = `
/* dativ verbs version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.9cqw }
.dm small b { color: var(--navy) }
b.dat { background: var(--dat); color: #fff; border-radius: .25cqw; padding: 0 .25cqw; font-weight: 800 }
b.akk { background: var(--hi); border-radius: .25cqw; padding: 0 .25cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.5cqw }
.dv { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.2fr 1fr; gap: .9cqw }
.right { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.bx { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--dat); border-radius: .8cqw; overflow: hidden; background: #fff }
.bh { display: flex; align-items: baseline; gap: .8cqw; padding: .1cqw .9cqw .25cqw; background: var(--dat); color: #fff }
.bx.o, .bx.gv { border-color: var(--navy) } .bx.o .bh, .bx.gv .bh { background: var(--navy) }
.bh b { font-family: var(--serif); font-size: 1.5cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.cols { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr }
.g { display: flex; flex-direction: column; min-height: 0 }
.g + .g { border-left: .15cqw solid #ddd3f5 }
.gh { font-size: .78cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--dat); padding: .35cqw .8cqw .25cqw; border-bottom: .15cqw solid #ddd3f5; background: #f5f2fc }
.vr { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; padding: 0 .8cqw; border-top: .1cqw solid #eeeaf7; gap: .05cqw }
.gh + .vr { border-top: 0 }
.vb { font-family: var(--serif); font-size: 1.2cqw; font-weight: 700; color: var(--dat); line-height: 1.1 }
.vb small { font-family: var(--sans); font-size: .7cqw; font-weight: 700; color: var(--muted); margin-left: .5cqw }
.vs { font-family: var(--serif); font-size: 1.15cqw; font-weight: 600; white-space: nowrap; line-height: 1.25 }
.bx.o { flex: 1.15 } .bx.gv { flex: 1 }
.sr { flex: 1; min-height: 0; display: grid; grid-template-columns: 6.2cqw 1fr; grid-template-rows: auto auto; align-items: center; column-gap: .6cqw; padding: .15cqw .9cqw; border-top: .1cqw solid #dde3ec }
.bh + .sr { border-top: 0 }
.sn { grid-row: 1 / 3; font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--muted) }
.line { display: flex; gap: .35cqw }
.sl { font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; border-radius: .3cqw; padding: .05cqw .45cqw; white-space: nowrap }
.sl.s { box-shadow: inset 0 0 0 .14cqw var(--ink) } .sl.v { background: var(--terracotta-ink); color: #fff }
.sl.d { background: var(--dat); color: #fff } .sl.a { background: var(--hi) }
.rule { font-size: .8cqw; font-weight: 700; color: var(--navy) }
.gl { display: flex; flex-wrap: wrap; gap: .3cqw .5cqw; padding: .45cqw .9cqw .3cqw; font-family: var(--serif); font-size: 1.22cqw; font-weight: 700; color: var(--navy) }
.gl span { background: var(--navy-soft); border-radius: .3cqw; padding: 0 .35cqw }
.ge { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: space-evenly; padding: .1cqw .9cqw .3cqw; border-top: .1cqw solid #dde3ec; font-family: var(--serif); font-size: 1.18cqw; font-weight: 600 }
.ge span { white-space: nowrap }
.rules s { color: #8b857c }
.key .sp b.dat, .key .sp b.akk { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Dativ Verbs Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 28, verbs with Dativ</h1>\n\t\t<p>Verbs that take a Dativ, and the order of two objects.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 28</small>helfen, danken, gefallen');
rep('data-qr="15"', 'data-qr="28"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Is it a Dativ verb?</span>
				<span><b>2</b>Who gets something? Dativ</span>
				<span><b>3</b>Two objects? Check the order</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 28 built', Math.round(html.length / 1024) + ' KB,', count, 'verbs and sentences');
