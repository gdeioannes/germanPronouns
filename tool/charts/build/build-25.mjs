// Chart 25 (present tense, with vowel-change verbs): writes tool/charts/src/25-present.html on the
// 15-gender.html skeleton. Left: the six persons with their endings, three regular model verbs
// (plain, stem in -t, stem in -ß) and sein / haben / werden. Right: verbs whose vowel changes, and
// only with du and er/sie/es. Endings and changed vowels in terracotta (the verb colour of the book).
// Course level A1.1 → A1.2. Run from the repo root: node tool/charts/build/build-25.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/25-present.html';

const PERSONS = [['ich', 'I'], ['du', 'you'], ['er · sie · es', 'he, she, it'], ['wir', 'we'], ['ihr', 'you all'], ['sie · Sie', 'they · you, polite']];
const ENDINGS = ['-e', '-st', '-t', '-en', '-t', '-en'];
// stem|ending
const REG = [
	['machen', 'mach|e mach|st mach|t mach|en mach|t mach|en'],
	['arbeiten', 'arbeit|e arbeit|est arbeit|et arbeit|en arbeit|et arbeit|en'],
	['heißen', 'heiß|e heiß|t heiß|t heiß|en heiß|t heiß|en']
];
const IRR = [
	['sein', 'bin bist ist sind seid sind'],
	['haben', 'habe hast hat haben habt haben'],
	['werden', 'werde wirst wird werden werdet werden']
];
// vowel families: [title, rows]; {i} = changed vowel
const FAM = [
	['e → i', [['essen', 'du {i}sst', 'er {i}sst'], ['geben', 'du g{i}bst', 'er g{i}bt'], ['helfen', 'du h{i}lfst', 'er h{i}lft'], ['nehmen', 'du n{i}mmst', 'er n{i}mmt'], ['sprechen', 'du spr{i}chst', 'er spr{i}cht'], ['treffen', 'du tr{i}ffst', 'er tr{i}fft'], ['vergessen', 'du verg{i}sst', 'er verg{i}sst']]],
	['e → ie', [['lesen', 'du l{ie}st', 'er l{ie}st'], ['sehen', 'du s{ie}hst', 'er s{ie}ht']]],
	['a → ä · au → äu', [['fahren', 'du f{ä}hrst', 'er f{ä}hrt'], ['schlafen', 'du schl{ä}fst', 'er schl{ä}ft'], ['tragen', 'du tr{ä}gst', 'er tr{ä}gt'], ['waschen', 'du w{ä}schst', 'er w{ä}scht'], ['halten', 'du h{ä}ltst', 'er h{ä}lt'], ['laufen', 'du l{äu}fst', 'er l{äu}ft']]]
];

let count = 0;
const reg = (f) => { count++; const [s, e] = f.split('|'); return `${s}<b>${e}</b>`; };
const vow = (f) => { count++; return f.replace(/\{([^}]+)\}/g, '<b>$1</b>').replace(/^(du|er) /, '<small>$1</small> '); };

let table = `<div class="th p"></div><div class="th e">ending</div>${REG.map(([v]) => `<div class="th">${v}</div>`).join('')}${IRR.map(([v]) => `<div class="th ir">${v}</div>`).join('')}`;
for (let i = 0; i < 6; i++) {
	const hot = i === 1 || i === 2 ? ' hot' : '';
	table += `<div class="pp${hot}"><b>${PERSONS[i][0]}</b><span>${PERSONS[i][1]}</span></div><div class="en${hot}">${ENDINGS[i]}</div>`;
	table += REG.map(([, f]) => `<div class="fm${hot}">${reg(f.split(' ')[i])}</div>`).join('');
	table += IRR.map(([, f]) => { count++; return `<div class="fm ir${hot}">${f.split(' ')[i]}</div>`; }).join('');
}

const fams = FAM.map(([t, rows]) => `<div class="fam"><div class="fh">${t}</div>${rows.map(([inf, du, er]) => `<div class="vr"><span class="inf">${inf}</span><span class="vf">${vow(du)}</span><span class="vf">${vow(er)}</span></div>`).join('')}</div>`).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">mach<s>en</s> → mach</div><small><b>stem</b> drop -en</small></div>
					<div class="dm"><div class="w">du mach<b class="t">st</b></div><small><b>ending</b> the person picks it</small></div>
					<div class="dm"><div class="w">er f<b class="t">ä</b>hrt</div><small><b>vowel</b> changes in some verbs</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Take the verb and drop -en: that is the stem (machen → mach). Then add the ending of the person who does it: ich mache, du machst, er macht.</span><span class="c2"><b>2</b>In some verbs the vowel changes too, but only with du and er, sie, es (right). sein, haben and werden do their own thing: learn them as they are.</span></div><h3 class="lt">Look here first: <strong>the person picks the ending</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>stem + ending</strong></h3>
				<div class="proof"><span class="chip"><span class="w">wohn + <b class="t">st</b> → du wohn<b class="t">st</b></span></span><p>Six endings, the same for nearly every verb: <span style="white-space:nowrap">-e, -st, -t, -en, -t, -en</span>.</p></div></div>
		</div>

		<div class="pres">
			<div class="tbl">${table}</div>
			<div class="vow">
				<div class="vh"><b>The vowel changes</b><span>only with du and er · sie · es</span></div>
				<div class="demo"><span>ich nehme</span><span class="hot">du n<b>i</b>mmst</span><span class="hot">er n<b>i</b>mmt</span><span>wir nehmen</span><span>ihr nehmt</span><span>sie nehmen</span></div>
				<div class="fams">${fams}</div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">special stems</div>
			<div><b class="lead">stem ends in -t or -d: add -e-</b>du arbeit<b class="t">est</b> · er arbeit<b class="t">et</b> · du find<b class="t">est</b> · ihr find<b class="t">et</b> · er red<b class="t">et</b></div>
			<div><b class="lead">stem ends in -s, -ß, -z: only -t</b>du heiß<b class="t">t</b> · du tanz<b class="t">t</b> · du reis<b class="t">t</b> · du sitz<b class="t">t</b> (not du heißst)</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">ich weiß, er weiß: no ending</b>wissen: ich weiß, du weißt, er weiß · the same in kann, muss, will <span class="aside">see Chart 14</span></div>
			<div><b class="lead">Sie, sie, sie</b>Sie wohnen (you, polite) · sie wohnen (they) · sie wohnt (she): the ending tells you which</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp">mach<b class="t">st</b> = the ending, it changes with the person</span> <span class="sp">f<b class="t">ä</b>hrt = the vowel changes</span> <span class="sp"><span class="kh">du · er</span> = the two persons where vowels change</span> <span class="sp"><span class="ki">sein</span> = irregular, learn as it is</span></div>
`;

const css = `
/* present tense version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 2.1cqw }
.dm .w s { color: #9a948a; text-decoration-thickness: .2cqw }
.dm small b { color: var(--terracotta-ink) }
b.t { color: var(--terracotta-ink); font-weight: 800 }
.idea .chip .w { font-size: 1.7cqw }
.pres { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.08fr 1fr; gap: 1cqw }
.tbl { min-height: 0; display: grid; grid-template-columns: 7.4cqw 4cqw repeat(6, minmax(0, 1fr)); grid-template-rows: auto repeat(6, 1fr); border: .3cqw solid var(--navy); border-radius: .9cqw; overflow: hidden; background: #fff }
.th { background: var(--navy); color: #fff; font-family: var(--serif); font-size: 1.25cqw; font-weight: 700; padding: .35cqw .5cqw; text-align: center; align-self: stretch }
.th.e { font-family: var(--sans); font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; display: flex; align-items: center; justify-content: center }
.th.ir { background: #47617f }
.pp, .en, .fm { display: flex; align-items: center; border-top: .12cqw solid #d5dce6; min-width: 0 }
.pp { flex-direction: column; align-items: flex-start; justify-content: center; padding: 0 .7cqw; gap: .05cqw }
.pp b { font-family: var(--serif); font-size: 1.35cqw; font-weight: 700; line-height: 1.05; white-space: nowrap }
.pp span { font-size: .72cqw; font-weight: 600; color: var(--muted); white-space: nowrap }
.en { justify-content: center; font-family: var(--serif); font-size: 1.7cqw; font-weight: 700; color: #fff; background: var(--terracotta-ink); border-top-color: #c98d6f }
.fm { justify-content: center; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; white-space: nowrap }
.fm b { color: var(--terracotta-ink); font-weight: 800 }
.fm.ir { background: #eef1f6; border-left: .12cqw solid #d5dce6 }
.pp.hot, .fm.hot:not(.ir) { background: #fdf3ec }
.vow { min-height: 0; display: flex; flex-direction: column; border: .3cqw solid var(--terracotta-ink); border-radius: .9cqw; overflow: hidden; background: #fff }
.vh { background: var(--terracotta-ink); color: #fff; display: flex; align-items: baseline; gap: .9cqw; padding: .2cqw 1cqw .35cqw }
.vh b { font-family: var(--serif); font-size: 1.75cqw; font-weight: 700 }
.vh span { font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.demo { display: flex; justify-content: space-between; gap: .4cqw; padding: .55cqw .9cqw; border-bottom: .12cqw solid #e6cfc2; font-family: var(--serif); font-size: 1.12cqw; font-weight: 700; color: #7a746b }
.demo span { white-space: nowrap }
.demo .hot { color: var(--ink); background: #fdf3ec; border-radius: .3cqw; padding: 0 .3cqw }
.demo b, .vf b { color: var(--terracotta-ink); font-weight: 800; text-decoration: underline; text-decoration-thickness: .18cqw; text-underline-offset: .15cqw }
.fams { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: auto 1fr; gap: 0 1cqw; padding: .35cqw .9cqw .45cqw }
.fam:first-child { grid-row: 1 / 3 }
.fam { display: flex; flex-direction: column; min-height: 0 }
.fam:nth-child(3) { margin-top: .5cqw }
.fh { font-family: var(--serif); font-size: 1.45cqw; font-weight: 700; color: var(--terracotta-ink); border-bottom: .15cqw solid var(--terracotta-ink); padding-bottom: .1cqw; margin-bottom: .1cqw }
.vr { flex: 1; display: grid; grid-template-columns: 5.6cqw 1fr 1fr; align-items: center; gap: .3cqw; border-bottom: .1cqw solid #f0e2d9; min-height: 0 }
.fam:first-child .vr { grid-template-columns: 5.6cqw 1fr 1fr }
.inf { font-size: .95cqw; font-weight: 700; color: var(--muted); white-space: nowrap }
.vf { font-family: var(--serif); font-size: 1.28cqw; font-weight: 700; white-space: nowrap }
.vf small { font-family: var(--sans); font-size: .78cqw; font-weight: 700; color: var(--muted) }
.key .kh { background: #fdf3ec; padding: 0 .3cqw; border-radius: .25cqw; font-weight: 700 }
.key .ki { background: #eef1f6; padding: 0 .3cqw; border-radius: .25cqw; font-weight: 700 }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Present Tense Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 25, the present tense</h1>\n\t\t<p>The six endings, sein, haben, werden, and the verbs whose vowel changes.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 25</small>ich mache, du machst');
rep('data-qr="15"', 'data-qr="25"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Drop -en: the stem</span>
				<span><b>2</b>Who does it? Find the row</span>
				<span><b>3</b>Add that ending</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 25 built', Math.round(html.length / 1024) + ' KB,', count, 'verb forms');
