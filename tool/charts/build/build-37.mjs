// Chart 37 (werden): writes tool/charts/src/37-werden.html on the 15-gender.html skeleton.
// Three columns, one per job of werden, told apart by what stands at the end of the sentence:
// an adjective or noun (become), an infinitive (future, a guess), a participle (passive). Each
// column: a slot line, eight sentences, its past forms. Bottom strip: the present forms and
// würde as a pointer to Konjunktiv II. Course level A2.2 → B1.2.
// Run from the repo root: node tool/charts/build/build-37.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/37-werden.html';

// [x] = form of werden, {x} = the word at the end that decides
const JOBS = [
	['1', 'become', 'werden + adjective or noun', 'a change: something is different afterwards', 'en1',
		['Es [wird] {dunkel}.', 'Ich [werde] {müde}.', 'Sie [wird] {Ärztin}.', 'Er [wird] morgen {30}.', 'Das Wetter [wird] {besser}.', 'Mir [wird] {schlecht}.', 'Was willst du [werden]?', 'Die Kinder [werden] schnell {groß}.', 'Er [wird] bald {Vater}.'],
		['Es [wurde] {dunkel}.', 'Sie ist {Ärztin} [geworden].']],
	['2', 'will', 'werden + infinitive', 'the future, a promise, a guess', 'en2',
		['Ich [werde] dich {anrufen}.', 'Morgen [wird] es {regnen}.', 'Wir [werden] {sehen}.', 'Du [wirst] das {schaffen}!', 'Ich [werde] nie {aufgeben}.', 'Das [wird] schon {klappen}.', 'Er [wird] wohl krank {sein}.', 'Sie [wird] jetzt zu Hause {sein}.', 'Wann [wirst] du {kommen}?'],
		['no past: use the Perfekt', 'Er [wird] es {vergessen haben}. (guess)']],
	['3', 'is done', 'werden + participle', 'the passive: what happens, not who does it', 'en3',
		['Das Haus [wird] {gebaut}.', 'Hier [wird] Deutsch {gesprochen}.', 'Die Post [wird] um acht {gebracht}.', 'Der Müll [wird] {abgeholt}.', 'Ich [werde] {operiert}.', 'Das Fenster [wird] {geöffnet}.', 'Die Kinder [werden] {abgeholt}.', 'Es [wird] viel {gelacht}.', 'Das Auto [wird] {repariert}.'],
		['Das Haus [wurde] 1990 {gebaut}.', 'Ich bin {operiert} [worden].']]
];
const FORMS = [['ich', 'werde'], ['du', 'wirst'], ['er · sie · es', 'wird'], ['wir', 'werden'], ['ihr', 'werdet'], ['sie · Sie', 'werden']];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="wv">$1</b>').replace(/\{([^}]+)\}/g, (m, x) => `<b class="we">${x}</b>`);
const cols = JOBS.map(([n, en, how, what, cls, ex, past]) => {
	count += ex.length + past.length;
	return `<div class="wj ${cls}"><div class="wjh"><b>${n}</b><span><strong>werden = ${en}</strong>${how}</span></div>
		<p class="wwhat">${what}</p>
		<div class="wsl"><span class="wsv">werden</span><span class="wsd">…</span><span class="wse">${how.split('+ ')[1]}</span></div>
		<div class="wex">${ex.map((e) => `<span><i>${fx(e)}</i></span>`).join('')}</div>
		<div class="wpa"><small>past</small>${past.map((p) => `<span>${fx(p)}</span>`).join('')}</div></div>`;
}).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Es <b class="wv">wird</b> <b class="we e1">dunkel</b>.</div><small><b>become</b> adjective at the end</small></div>
					<div class="dm"><div class="w">Es <b class="wv">wird</b> <b class="we e2">regnen</b>.</div><small><b>will</b> infinitive at the end</small></div>
					<div class="dm"><div class="w">Es <b class="wv">wird</b> <b class="we e3">gebaut</b>.</div><small><b>is done</b> participle at the end</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>werden has three jobs. On its own it means become: Es wird dunkel. With an infinitive it talks about the future: Es wird regnen. With a participle it makes the passive: Das Haus wird gebaut.</span><span class="c2"><b>2</b>You cannot tell them apart from werden itself. Look at the end of the sentence: an adjective or noun, an infinitive, or a participle (ge…t, ge…en). Below: one column per job, with eight sentences each.</span></div><h3 class="lt">Look here first: <strong>one verb, three jobs</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>look at the end</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Sie <b class="wv">wird</b> <b class="we e1">Ärztin</b> · <b class="we e2">kommen</b> · <b class="we e3">gefragt</b></span></span><p>Same start, three endings: she becomes a doctor, she will come, she is asked.</p></div></div>
		</div>

		<div class="werd">${cols}</div>

		<div class="rules">
			<div class="rl">the forms</div>
			<div class="wfo">${FORMS.map(([p, f]) => { count++; return `<span>${p} <b class="wv">${f}</b></span>`; }).join('')}</div>
			<div><b class="lead">würde = would</b>Ich <b class="wv">würde</b> gern kommen. <span class="aside">see Chart 31</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">future: often just the present</b>Ich komme morgen. = Ich <b class="wv">werde</b> morgen kommen. <span class="aside">see Chart 6</span></div>
			<div><b class="lead">geworden or worden?</b>become → ist <b class="wv">geworden</b> · passive → ist gebaut <b class="wv">worden</b> (no ge-) <span class="aside">see Chart 8</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="wv">wird</b> = a form of werden</span> <span class="sp"><b class="we e1">dunkel</b> <b class="we e2">regnen</b> <b class="we e3">gebaut</b> = the word at the end that tells the job</span></div>
`;

const css = `
/* werden version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 2cqw }
.dm small b { color: var(--navy) }
b.wv { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
b.we { border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
b.we.e1, .en1 b.we { color: #1f3a5f; box-shadow: inset 0 0 0 .14cqw #1f3a5f; background: #e8edf4 }
b.we.e2, .en2 b.we { color: #1f3a5f; box-shadow: inset 0 0 0 .14cqw #1f3a5f; background: #e8edf4 }
b.we.e3, .en3 b.we { color: #1f3a5f; box-shadow: inset 0 0 0 .14cqw #1f3a5f; background: #e8edf4 }
.idea .chip .w { font-size: 1.4cqw }
.werd { flex: 1; min-height: 0; display: grid; grid-template-columns: repeat(3, 1fr); gap: .9cqw }
.wj { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid; border-radius: .8cqw; overflow: hidden; background: #fff }
.wj.en1 { border-color: #1f3a5f } .wj.en2 { border-color: #1f3a5f } .wj.en3 { border-color: #1f3a5f }
.wjh { display: flex; align-items: center; gap: .7cqw; color: #fff; padding: .15cqw .9cqw .3cqw }
.en1 .wjh { background: #1f3a5f } .en2 .wjh { background: #1f3a5f } .en3 .wjh { background: #1f3a5f }
.wjh > b { font-family: var(--serif); font-size: 2.2cqw; font-weight: 700; line-height: 1 }
.wjh span { display: flex; flex-direction: column; font-size: .7cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; line-height: 1.25 }
.wjh strong { font-family: var(--serif); font-size: 1.45cqw; letter-spacing: 0; text-transform: none }
.wwhat { margin: 0; padding: .3cqw .9cqw 0; font-size: .8cqw; font-weight: 600; color: var(--muted) }
.wsl { display: flex; align-items: center; gap: .4cqw; padding: .35cqw .9cqw .35cqw; border-bottom: .1cqw solid #e3e8ef }
.wsl span { font-size: .78cqw; font-weight: 800; border-radius: .3cqw; padding: .05cqw .45cqw; text-transform: uppercase; letter-spacing: .03em }
.wsv { background: var(--terracotta-ink); color: #fff }
.wsd { color: var(--muted); flex: 1; text-align: center; border-bottom: .12cqw dashed #c9c2b6; line-height: .2 }
.wse { border: .14cqw solid currentColor }
.en1 .wse { color: #1f3a5f } .en2 .wse { color: #1f3a5f } .en3 .wse { color: #1f3a5f }
.wex { flex: 1; min-height: 0; display: flex; flex-direction: column; padding: 0 .9cqw }
.wex span { flex: 1; display: flex; align-items: center; border-top: .08cqw solid #eceff3 }
.wex span:first-child { border-top: 0 }
.wex i { font-style: normal; font-family: var(--serif); font-size: 1.22cqw; font-weight: 600; white-space: nowrap }
.wpa { display: grid; grid-template-columns: 3cqw 1fr; column-gap: .4cqw; padding: .25cqw .9cqw .3cqw; background: #f6f4f0; border-top: .12cqw solid #e3ded5 }
.wpa small { grid-row: 1 / 3; align-self: center; font-size: .66cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--muted) }
.wpa span { font-family: var(--serif); font-size: 1.04cqw; font-weight: 600; white-space: nowrap; line-height: 1.4 }
.rules .wfo { display: flex; flex-wrap: wrap; gap: .1cqw 1cqw; align-items: center }
.key b.wv, .key b.we { padding: 0 .25cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>werden Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 37, werden</h1>\n\t\t<p>werden has three jobs: become, the future and the passive.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 37</small>werden: three jobs');
rep('data-qr="15"', 'data-qr="37"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Find werden</span>
				<span><b>2</b>Look at the end</span>
				<span><b>3</b>Become, will or is done?</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 37 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
