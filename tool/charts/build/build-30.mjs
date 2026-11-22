// Chart 30 (irregular verbs in sound families): writes tool/charts/src/30-irregular-verbs.html on
// the 15-gender.html skeleton. Ten cards: eight vowel families, the mixed verbs (vowel change + -te)
// and the big ones. Each verb with infinitive, Präteritum and Partizip II; the vowel that carries
// the family tune is highlighted, * = Perfekt with sein. Course level A2.1 → B1.1.
// Run from the repo root: node tool/charts/build/build-30.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/30-irregular-verbs.html';

// [tune (vowels or ''), title, rows 'inf past part']
const FAM = [
	[['ei', 'ie', 'ie'], 'ei · ie · ie', ['bleiben blieb *geblieben', 'schreiben schrieb geschrieben', 'scheinen schien geschienen', 'steigen stieg *gestiegen', 'leihen lieh geliehen', 'schweigen schwieg geschwiegen']],
	[['ei', 'i', 'i'], 'ei · i · i', ['schneiden schnitt geschnitten', 'reiten ritt *geritten', 'beißen biss gebissen', 'streiten stritt gestritten', 'greifen griff gegriffen', 'leiden litt gelitten']],
	[['ie', 'o', 'o'], 'ie · o · o', ['fliegen flog *geflogen', 'verlieren verlor verloren', 'schließen schloss geschlossen', 'ziehen zog gezogen', 'riechen roch gerochen', 'bieten bot geboten']],
	[['i', 'a', 'u'], 'i · a · u', ['trinken trank getrunken', 'finden fand gefunden', 'singen sang gesungen', 'springen sprang *gesprungen', 'sinken sank *gesunken', 'zwingen zwang gezwungen']],
	[['e', 'a', 'o'], 'e · a · o', ['sprechen sprach gesprochen', 'helfen half geholfen', 'nehmen nahm genommen', 'treffen traf getroffen', 'werfen warf geworfen', 'sterben starb *gestorben']],
	[['e', 'a', 'e'], 'e · a · e', ['essen aß gegessen', 'geben gab gegeben', 'lesen las gelesen', 'sehen sah gesehen', 'vergessen vergaß vergessen', 'treten trat *getreten']],
	[['a', 'ie', 'a'], 'a · ie · a', ['schlafen schlief geschlafen', 'fallen fiel *gefallen', 'halten hielt gehalten', 'lassen ließ gelassen', 'laufen lief *gelaufen', 'braten briet gebraten']],
	[['a', 'u', 'a'], 'a · u · a', ['fahren fuhr *gefahren', 'tragen trug getragen', 'waschen wusch gewaschen', 'schlagen schlug geschlagen', 'einladen lud_ein eingeladen', 'wachsen wuchs *gewachsen']],
	[['', 'te', 't'], 'mixed: new vowel + -te', ['bringen brachte gebracht', 'denken dachte gedacht', 'kennen kannte gekannt', 'wissen wusste gewusst', 'nennen nannte genannt', 'rennen rannte *gerannt']],
	[null, 'the big ones', ['sein war *gewesen', 'haben hatte gehabt', 'werden wurde *geworden', 'gehen ging *gegangen', 'kommen kam *gekommen', 'stehen stand gestanden', 'tun tat getan', 'sitzen saß gesessen']]
];

let count = 0;
const PRE = /^(einge|ge|ver|ein)/;
const mark = (form, v) => {
	if (!v) return form;
	const m = form.match(PRE), pre = m ? m[0] : '', rest = form.slice(pre.length);
	if (v === 'te' || v === 't') { const i = rest.lastIndexOf(v); return i < 0 ? form : pre + rest.slice(0, i) + `<b>${v}</b>` + rest.slice(i + v.length); }
	const i = rest.indexOf(v);
	if (i < 0) return form;
	// do not split ie / ei when looking for a single vowel
	if ((v === 'i' && rest[i - 1] === 'e') || (v === 'e' && rest[i + 1] === 'i')) { const j = rest.indexOf(v, i + 2); if (j < 0) return form; return pre + rest.slice(0, j) + `<b>${v}</b>` + rest.slice(j + 1); }
	return pre + rest.slice(0, i) + `<b>${v}</b>` + rest.slice(i + v.length);
};
const cards = FAM.map(([tune, title, rows], k) => `<div class="fc${tune ? '' : ' big'}${k === 8 ? ' mix' : ''}"><div class="fh">${title}</div>${rows.map((r) => {
	const [inf, past, part] = r.split(' ').map((x) => x.replace('_', ' '));
	count++;
	const sein = part.startsWith('*'), p = part.replace('*', '');
	return `<div class="vr"><span>${mark(inf, tune && tune[0])}</span><span>${mark(past, tune && tune[1])}</span><span>${sein ? `<em class="sw">${mark(p, tune && tune[2])}</em>` : mark(p, tune && tune[2])}</span></div>`;
}).join('')}</div>`).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">tr<b>i</b>nken · tr<b>a</b>nk · getr<b>u</b>nken</div><small><b>i · a · u</b> one tune</small></div>
					<div class="dm"><div class="w">s<b>i</b>ngen · s<b>a</b>ng · ges<b>u</b>ngen</div><small><b>i · a · u</b> the same tune</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Irregular verbs change their vowel in the past and in the participle. Many change it the same way, so they come in families: trinken, trank, getrunken sounds just like singen, sang, gesungen.</span><span class="c2"><b>2</b>Each row: the verb, the past (Präteritum, mostly written) and the participle for the Perfekt. A shaded participle takes sein in the Perfekt: ist geblieben.</span></div><h3 class="lt">Look here first: <strong>irregular verbs come in sound families</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>learn the tune, not the list</strong></h3>
				<div class="proof"><span class="chip"><span class="w">i · a · u</span></span><p>trinken, finden, singen, springen: learn one, and the tune gives you the others.</p></div></div>
		</div>

		<div class="irr">${cards}</div>

		<div class="rules">
			<div class="rl">prefixes</div>
			<div><b class="lead">a prefix verb follows its base verb</b>verstehen → verstand → verstanden · aufstehen → stand auf → <i class="ist">ist</i> aufgestanden · bekommen → bekam → bekommen</div>
			<div><b class="lead">past in speech: the Perfekt</b>Ich <b>habe</b> getrunken (spoken) · Ich trank (written) · but war, hatte, wusste in speech too <span class="aside">see Chart 26</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">i · a · o, not i · a · u</b>beginnen, begann, begonnen · schwimmen, schwamm, <i class="ist">ist</i> geschwommen · gewinnen, gewann, gewonnen</div>
			<div><b class="lead">same start, other family</b>sprechen → gesprochen, but sehen → gesehen · liegen → lag → gelegen: learn the participle with the verb</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp">tr<b class="kv">a</b>nk = the vowel that carries the tune</span> <span class="sp"><em class="sw">gefahren</em> = Perfekt with sein: ist gefahren</span> <span class="sp">order in each row: verb · Präteritum · Partizip II</span></div>
`;

const css = `
/* irregular verbs version */
.lk.a .trio { justify-content: flex-start; gap: 4cqw }
.dm .w { font-size: 1.9cqw }
.dm .w b, .vr b, .key b.kv { color: var(--terracotta-ink); font-weight: 800; text-decoration: underline; text-decoration-thickness: .16cqw; text-underline-offset: .15cqw }
.dm small b { color: var(--terracotta-ink) }
.idea .chip .w { font-size: 2cqw; color: var(--terracotta-ink) }
.irr { flex: 1; min-height: 0; display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); grid-template-rows: 1fr 1fr; gap: .6cqw }
.fc { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .22cqw solid var(--navy); border-radius: .7cqw; overflow: hidden; background: #fff }
.fc.big { border-color: var(--terracotta-ink); background: #fdf6f1 }
.fh { background: var(--navy); color: #fff; font-family: var(--serif); font-size: 1.35cqw; font-weight: 700; padding: .05cqw .7cqw .15cqw; line-height: 1.25; white-space: nowrap }
.fc.mix .fh { font-size: 1.05cqw; padding-top: .2cqw; padding-bottom: .25cqw }
.fc.big .fh { background: var(--terracotta-ink) }
.vr { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr .78fr 1.3fr; align-items: center; gap: .4cqw; padding: 0 .4cqw; border-top: .08cqw solid #e3e8ef; font-family: var(--serif); font-size: .92cqw; font-weight: 700; line-height: 1.1 }
.fh + .vr { border-top: 0 }
.vr span { white-space: nowrap; min-width: 0 }
.vr span:nth-child(2) { color: #4a4640 }
em.sw, .key em.sw { font-style: normal; background: #f8d9c6; border-radius: .2cqw; padding: 0 .2cqw; box-shadow: inset .25cqw 0 0 var(--terracotta-ink) }
i.ist { font-style: normal; font-family: var(--sans); font-size: .56cqw; font-weight: 800; color: #fff; background: var(--terracotta-ink); border-radius: .2cqw; padding: 0 .12cqw; margin-right: .12cqw; vertical-align: .12cqw }
.rules i.ist, .key i.ist { font-size: .8cqw; vertical-align: .05cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Irregular Verbs Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 30, irregular verbs</h1>\n\t\t<p>Irregular verbs in sound families, with past and participle.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 30</small>singen, sang, gesungen');
rep('data-qr="15"', 'data-qr="30"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Find the family of your verb</span>
				<span><b>2</b>Hear its tune</span>
				<span><b>3</b>Past and participle follow</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 30 built', Math.round(html.length / 1024) + ' KB,', count, 'verbs (x3 forms)');
