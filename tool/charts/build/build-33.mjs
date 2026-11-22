// Chart 33 (imperative): writes tool/charts/src/33-imperative.html on the 15-gender.html skeleton.
// Left: a table of twelve verbs × du / ihr / Sie, each form built from the present tense. Right:
// how it sounds (bitte, mal, doch) and everyday commands. Course level A1.2 → A2.1.
// Run from the repo root: node tool/charts/build/build-33.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/33-imperative.html';

// [infinitive, group, du, ihr, Sie]; [x] = imperative verb, {x} = split-off prefix
const VERBS = [
	['machen', 'regular', '[Mach]!', '[Macht]!', '[Machen] Sie!'],
	['kommen', 'regular', '[Komm]!', '[Kommt]!', '[Kommen] Sie!'],
	['warten', '-t, -d: keeps -e', '[Warte]!', '[Wartet]!', '[Warten] Sie!'],
	['nehmen', 'e → i stays', '[Nimm]!', '[Nehmt]!', '[Nehmen] Sie!'],
	['essen', 'e → i stays', '[Iss]!', '[Esst]!', '[Essen] Sie!'],
	['lesen', 'e → ie stays', '[Lies]!', '[Lest]!', '[Lesen] Sie!'],
	['fahren', 'ä goes: a', '[Fahr]!', '[Fahrt]!', '[Fahren] Sie!'],
	['schlafen', 'ä goes: a', '[Schlaf]!', '[Schlaft]!', '[Schlafen] Sie!'],
	['anrufen', 'prefix to the end', '[Ruf] {an}!', '[Ruft] {an}!', '[Rufen] Sie {an}!'],
	['aufstehen', 'prefix to the end', '[Steh] {auf}!', '[Steht] {auf}!', '[Stehen] Sie {auf}!'],
	['sein', 'its own forms', '[Sei]!', '[Seid]!', '[Seien] Sie!'],
	['haben', 'its own forms', '[Hab]!', '[Habt]!', '[Haben] Sie!']
];
const TONE = [
	['bitte', 'polite', '[Komm] bitte!', 'Bitte [warten] Sie hier.'],
	['mal', 'casual, quick', '[Komm] mal her!', '[Schau] mal!'],
	['doch', 'go on, why not', '[Komm] doch mit!', '[Setzen] Sie sich doch!'],
	['nicht', 'a warning', '[Vergiss] das nicht!', '[Fahr] nicht so schnell!']
];
const LIFE = [
	['at home', '[Mach] die Tür {zu}!', '[Räum] dein Zimmer {auf}!'],
	['in class', '[Hört] gut {zu}!', '[Seid] bitte leise!'],
	['at work', '[Schicken] Sie mir die Datei.', '[Rufen] Sie mich morgen {an}.'],
	['on the street', '[Geh] geradeaus!', '[Pass] {auf}!'],
	['with friends', '[Sei] nicht traurig!', '[Hab] keine Angst!']
];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="iv">$1</b>').replace(/\{([^}]+)\}/g, '<b class="ix">$1</b>');
const table = VERBS.map(([inf, g, du, ihr, sie]) => { count += 3; return `<span class="ii"><b>${inf}</b><small>${g}</small></span><span class="ic"><span>${fx(du)}</span></span><span class="ic"><span>${fx(ihr)}</span></span><span class="ic"><span>${fx(sie)}</span></span>`; }).join('');
const tone = TONE.map(([w, m, a, b]) => { count += 2; return `<div class="tr"><span class="tw"><b>${w}</b><small>${m}</small></span><span class="ts">${fx(a)}</span><span class="ts">${fx(b)}</span></div>`; }).join('');
const life = LIFE.map(([w, a, b]) => { count += 2; return `<div class="tr"><span class="tw"><small>${w}</small></span><span class="ts">${fx(a)}</span><span class="ts">${fx(b)}</span></div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">du kommst → <b class="iv">Komm</b>!</div><small><b>one friend</b> drop du and -st</small></div>
					<div class="dm"><div class="w">ihr kommt → <b class="iv">Kommt</b>!</div><small><b>several friends</b> drop ihr</small></div>
					<div class="dm"><div class="w"><b class="iv">Kommen</b> Sie!</div><small><b>formal</b> keep Sie, after the verb</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>The imperative tells someone what to do: Komm! Wartet! Setzen Sie sich! German has three, because there are three ways to say you: du, ihr and Sie.</span><span class="c2"><b>2</b>Each one comes from the present tense (Chart 25). The verb goes first, and a split-off prefix goes to the end: Ruf mich an! Below: twelve verbs, then how to make it sound friendly.</span></div><h3 class="lt">Look here first: <strong>three ways to say do it!</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>start from the present</strong></h3>
				<div class="proof"><span class="chip"><span class="w">du nimmst → <b class="iv">Nimm</b>!</span></span><p>Take the du form, drop du and -st. What is left is the command, and e → i stays: Nimm!</p></div></div>
		</div>

		<div class="imp">
			<div class="ib">
				<div class="ihd"><span></span><span><b>du</b>one friend</span><span><b>ihr</b>several friends</span><span><b>Sie</b>formal, one or many</span></div>
				<div class="it">${table}</div>
			</div>
			<div class="tb">
				<div class="th"><b>How it sounds</b><span>small words change the tone</span></div>
				${tone}
				<div class="th two"><b>Every day</b><span>commands you hear</span></div>
				${life}
			</div>
		</div>

		<div class="rules">
			<div class="rl">also</div>
			<div><b class="lead">wir: let's</b><b class="iv">Gehen</b> wir! · <b class="iv">Fangen</b> wir <b class="ix">an</b>! · <b class="iv">Machen</b> wir eine Pause!</div>
			<div><b class="lead">sich: dich, euch, sich</b><b class="iv">Setz</b> dich! · <b class="iv">Beeilt</b> euch! · <b class="iv">Setzen</b> Sie sich! <span class="aside">see Chart 35</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">no -st, no du</b><s>Kommst!</s> <s>Komm du!</s> → <b class="iv">Komm</b>! · an extra -e is old: Komme! Gehe!</div>
			<div><b class="lead">ä loses its dots</b>du fährst → <b class="iv">Fahr</b>! · but e → i stays: <b class="iv">Gib</b>! <b class="iv">Hilf</b>!</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="iv">Komm</b> = the imperative, first in the sentence</span> <span class="sp"><b class="ix">an</b> = split-off prefix, at the end</span> <span class="sp">! = said firmly, a full stop = said calmly</span></div>
`;

const css = `
/* imperative version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.9cqw }
.dm small b { color: var(--terracotta-ink) }
b.iv { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
b.ix { color: var(--terracotta-ink); box-shadow: inset 0 0 0 .14cqw var(--terracotta-ink); border-radius: .3cqw; padding: 0 .25cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.7cqw }
.imp { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.45fr 1fr; gap: .9cqw }
.ib, .tb { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.ihd { display: grid; grid-template-columns: 1.15fr 1fr 1fr 1.25fr; background: var(--navy); color: #fff; padding: .15cqw .9cqw .3cqw; column-gap: .6cqw }
.ihd span { display: flex; flex-direction: column; font-size: .66cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; line-height: 1.2 }
.ihd b { font-family: var(--serif); font-size: 1.5cqw; letter-spacing: 0; text-transform: none }
.it { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.15fr 1fr 1fr 1.25fr; grid-auto-rows: 1fr; padding: 0 .9cqw; column-gap: .6cqw }
.it > span { display: flex; align-items: center; border-top: .1cqw solid #e3e8ef; min-height: 0 }
.it > span:nth-child(-n+4) { border-top: 0 }
.ii { flex-direction: column; align-items: flex-start !important; justify-content: center }
.ii b { font-family: var(--serif); font-size: 1.15cqw; font-weight: 700; color: var(--navy); line-height: 1.1 }
.ii small { font-size: .62cqw; font-weight: 700; color: var(--muted); letter-spacing: .02em }
.ic { font-family: var(--serif); font-size: 1.22cqw; font-weight: 600; white-space: nowrap }
.ic b.iv, .ts b.iv { padding: 0 .2cqw }
.th { display: flex; align-items: baseline; gap: .7cqw; background: var(--navy); color: #fff; padding: .1cqw .8cqw .25cqw }
.th.two { background: var(--terracotta-ink) }
.th b { font-family: var(--serif); font-size: 1.3cqw; font-weight: 700 }
.th span { font-size: .66cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase }
.tr { flex: 1; min-height: 0; display: grid; grid-template-columns: 5.4cqw 1fr; grid-template-rows: auto auto; align-content: center; column-gap: .6cqw; padding: 0 .8cqw; border-top: .1cqw solid #e3e8ef }
.th + .tr { border-top: 0 }
.tw { grid-row: 1 / 3; display: flex; flex-direction: column; justify-content: center }
.tw b { font-family: var(--serif); font-size: 1.2cqw; font-weight: 700; color: var(--terracotta-ink); line-height: 1.1 }
.tw small { font-size: .6cqw; font-weight: 800; letter-spacing: .03em; text-transform: uppercase; color: var(--muted) }
.ts { font-family: var(--serif); font-size: 1.05cqw; font-weight: 600; white-space: nowrap; line-height: 1.35 }
.rules s { color: #8b857c }
.key b.iv, .key b.ix { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Imperative Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 33, the imperative</h1>\n\t\t<p>Komm! Kommt! Kommen Sie!: telling someone what to do.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 33</small>Komm! Kommt! Kommen Sie!');
rep('data-qr="15"', 'data-qr="33"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>du, ihr or Sie?</span>
				<span><b>2</b>Present form, drop the person</span>
				<span><b>3</b>Verb first, prefix last</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 33 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
