// Chart 31 (Konjunktiv II): writes tool/charts/src/31-konjunktiv.html on the 15-gender.html
// skeleton. Top right: the forms (würde + infinitive for most verbs, own forms for the frequent
// ones). Four cards = four uses: polite requests, wishes, unreal conditions, advice. Real vs unreal
// side by side in the intro. Course level B1.1 → B1.2.
// Run from the repo root: node tool/charts/build/build-31.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/31-konjunktiv.html';

const USES = [
	['Being polite', 'requests, orders, offers', ['[Könnten] Sie mir helfen?', 'Ich [hätte] gern einen Kaffee.', '[Würden] Sie das Fenster öffnen?', '[Wäre] es möglich, morgen zu kommen?', '[Dürfte] ich kurz stören?']],
	['Wishing', 'what is not true, but you want', ['Ich [hätte] gern mehr Zeit.', 'Wenn ich doch reich [wäre]!', 'Ich [würde] so gern Spanisch [sprechen].', 'Wenn es nur nicht so kalt [wäre]!', '[Wäre] das schön!']],
	['If … (unreal)', 'wenn + Konjunktiv II, then Konjunktiv II', ['Wenn ich Zeit [hätte], [würde] ich [kommen].', 'Wenn ich du [wäre], [würde] ich [gehen].', 'Wenn er mehr [lernte], [könnte] er bestehen.', 'Ich [würde] es [kaufen], wenn es billiger [wäre].']],
	['Giving advice', 'what someone should do', ['Du [solltest] mehr schlafen.', 'An deiner Stelle [würde] ich zum Arzt [gehen].', 'Sie [könnten] es morgen noch einmal versuchen.', 'Es [wäre] besser, jetzt zu gehen.']]
];
const FORMS = [['sein', 'wäre'], ['haben', 'hätte'], ['werden', 'würde'], ['können', 'könnte'], ['müssen', 'müsste'], ['dürfen', 'dürfte'], ['sollen', 'sollte'], ['wollen', 'wollte'], ['wissen', 'wüsste'], ['kommen', 'käme'], ['gehen', 'ginge'], ['geben', 'gäbe']];
const PERS = [['ich', 'würde', 'wäre'], ['du', 'würdest', 'wärst'], ['er · sie · es', 'würde', 'wäre'], ['wir', 'würden', 'wären'], ['ihr', 'würdet', 'wärt'], ['sie · Sie', 'würden', 'wären']];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="k2">$1</b>');
const uses = USES.map(([t, sub, ex], i) => { count += ex.length; return `<div class="uc"><div class="uh"><b>${i + 1}</b><span><strong>${t}</strong>${sub}</span></div>${ex.map((e) => `<div class="ue"><span>${fx(e)}</span></div>`).join('')}</div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Ich <b class="real">habe</b> Zeit.</div><small><b>real</b> it is true</small></div>
					<div class="dm"><div class="w">Wenn ich Zeit <b class="k2">hätte</b> …</div><small><b>unreal</b> it is not true</small></div>
					<div class="dm"><div class="w"><b class="k2">Könnten</b> Sie …?</div><small><b>polite</b> softer than können</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>The Konjunktiv II talks about what is not real: wishes, dreams, "if only". The same forms also make a request polite: Könnten Sie mir helfen? sounds softer than Können Sie …?</span><span class="c2"><b>2</b>For most verbs use würde + infinitive. A dozen frequent verbs have their own form: hätte, wäre, könnte … (top right). Below: the four situations where you need it.</span></div><h3 class="lt">Look here first: <strong>not real, or extra polite</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>würde + infinitive</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Ich <b class="k2">würde</b> gern <b class="k2">reisen</b>.</span></span><p>würde in second place, the infinitive at the end: that works for almost every verb.</p></div></div>
		</div>

		<div class="kon">
			<div class="uses">${uses}</div>
			<div class="forms">
				<div class="fb"><div class="fh"><b>The forms</b><span>würde + infinitive, and sein</span></div>
					<div class="pt"><span class="pq"></span><span class="pq">würde + verb</span><span class="pq">sein → wäre</span>${PERS.map(([p, w, ww]) => { count += 2; return `<span class="pp">${p}</span><span class="pw">${w}</span><span class="pw">${ww}</span>`; }).join('')}</div>
				</div>
				<div class="fb own"><div class="fh"><b>Own forms</b><span>use these, not würde</span></div>
					<div class="ft">${FORMS.map(([v, k]) => { count++; return `<span><small>${v}</small><b>${k}</b></span>`; }).join('')}</div>
				</div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">the past</div>
			<div><b class="lead">hätte or wäre + participle</b>Wenn ich Zeit gehabt <b class="k2">hätte</b>, <b class="k2">wäre</b> ich gekommen. · Das <b class="k2">hätte</b> ich nicht gedacht.</div>
			<div><b class="lead">wenn can go</b>Hätte ich Zeit, würde ich kommen. = Wenn ich Zeit hätte, … (the verb comes first)</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">never würde + sein, haben</b><s>ich würde Zeit haben</s> → ich <b class="k2">hätte</b> Zeit · <s>ich würde reich sein</s> → ich <b class="k2">wäre</b> reich</div>
			<div><b class="lead">möchte = would like</b>Ich möchte einen Tee = Ich hätte gern einen Tee: both polite <span class="aside">see Chart 14</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="k2">hätte</b> = Konjunktiv II, not real or polite</span> <span class="sp"><b class="real">habe</b> = real, the normal form</span> <span class="sp">ich and er are the same: ich wäre, er wäre</span></div>
`;

const css = `
/* konjunktiv version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.9cqw }
.dm small b { color: var(--navy) }
b.k2 { background: #e6defa; color: #3d2380; box-shadow: inset 0 0 0 .12cqw #7b5fc9; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
b.real { background: var(--navy-soft); color: var(--navy); border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.7cqw }
.kon { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.65fr 1fr; gap: .9cqw }
.uses { min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: 1fr 1fr; gap: .6cqw }
.uc { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.uh { background: var(--navy); color: #fff; display: flex; align-items: center; gap: .6cqw; padding: .15cqw .8cqw .25cqw }
.uh > b { font-family: var(--serif); font-size: 2cqw; font-weight: 700; line-height: 1 }
.uh span { display: flex; flex-direction: column; font-size: .7cqw; font-weight: 700; letter-spacing: .03em; text-transform: uppercase; line-height: 1.2 }
.uh strong { font-family: var(--serif); font-size: 1.3cqw; letter-spacing: 0; text-transform: none }
.ue { flex: 1; min-height: 0; display: flex; align-items: center; padding: 0 .8cqw; border-top: .1cqw solid #e3e8ef; font-family: var(--serif); font-size: 1.12cqw; font-weight: 600; white-space: nowrap }
.uh + .ue { border-top: 0 }
.ue b.k2 { padding: 0 .2cqw }
.forms { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.fb { flex: 1; min-height: 0; display: flex; flex-direction: column; border: .25cqw solid #7b5fc9; border-radius: .8cqw; overflow: hidden; background: #fff }
.fb.own { flex: 1.15 }
.fh { background: #5b3aa8; color: #fff; display: flex; align-items: baseline; gap: .7cqw; padding: .1cqw .8cqw .25cqw }
.fh b { font-family: var(--serif); font-size: 1.35cqw; font-weight: 700 }
.fh span { font-size: .7cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase }
.pt { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.2fr 1fr 1fr; grid-auto-rows: 1fr; align-items: center; padding: .1cqw .9cqw .2cqw; column-gap: .5cqw }
.pq { font-size: .66cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: #5b3aa8; align-self: end }
.pp { font-size: .9cqw; font-weight: 700; color: var(--muted) }
.pw { font-family: var(--serif); font-size: 1.25cqw; font-weight: 700; color: #3d2380 }
.ft { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr 1fr; grid-auto-rows: 1fr; padding: .2cqw .7cqw .3cqw; gap: .2cqw .4cqw }
.ft span { display: flex; flex-direction: column; justify-content: center; border-bottom: .08cqw solid #ece6f8 }
.ft small { font-size: .68cqw; font-weight: 700; color: var(--muted) }
.ft b { font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; color: #3d2380; line-height: 1.1 }
.rules s { color: #8b857c }
.key b.k2, .key b.real { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Konjunktiv II Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 31, Konjunktiv II</h1>\n\t\t<p>würde, hätte, wäre: being polite, wishing, unreal conditions and advice.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 31</small>würde, hätte, wäre');
rep('data-qr="15"', 'data-qr="31"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Not real, or polite?</span>
				<span><b>2</b>Own form or würde?</span>
				<span><b>3</b>Infinitive at the end</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 31 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
