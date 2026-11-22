// Charts 15–17 (nouns): gender by ending, plural patterns, nouns that add -n.
// Built from Chart 3's skeleton, written straight into the repo's tool/charts/src.
import { readFileSync, writeFileSync } from 'node:fs';
const repo = process.argv[2];
const SRC = repo + '/tool/charts/src/';
const base = readFileSync(SRC + '03-verb-position.html', 'utf8');
const C = (c, t) => '<em class="' + c + '">' + t + '</em>';
const TAG = (c, t) => '<span class="tag ' + c + '">' + t + '</span>';

const COMMON = `.hd { gap: 1.2cqw }
.sheet h2.title { font-size: 2.8cqw }
.path { font-size: .88cqw }
.sheet { --m: #0f4a96; --f: #a81f1b; --n: #1c6a3c; --pl: #2f2d2a }
.sheet em.nom, .sheet em.akk, .sheet em.dat, .sheet em.gen { font-style: normal; font-weight: 800; padding: 0 .3cqw }
.sheet em.nom { box-shadow: inset 0 0 0 .15cqw var(--ink); color: var(--ink) }
.sheet em.akk { background: var(--hi); color: var(--ink) }
.sheet em.dat { background: var(--dat); color: #fff }
.sheet em.gen { background: var(--gen); color: #fff }
.sheet u.x { text-decoration: none; background: var(--terracotta-ink); color: #fff; font-weight: 800; padding: 0 .2cqw; border-radius: .2cqw; margin-left: .04cqw }
.gm { color: var(--m) } .gf { color: var(--f) } .gn { color: var(--n) }
.focus { display: grid; grid-template-columns: 1fr 30cqw; gap: 1.2cqw }
.look { border: .4cqw solid var(--navy); border-radius: .9cqw; padding: .5cqw 1.3cqw .55cqw; display: flex; align-items: center; gap: 2cqw }
.look .demo { font-size: 2.3cqw; font-weight: 700; white-space: nowrap; display: flex; align-items: center; gap: .7cqw }
.look .demo .ar { color: var(--terracotta-ink) }
.cap1 { display: flex; flex-direction: column; gap: .4cqw }
.cap1 span { font-size: 1.02cqw; font-weight: 700; line-height: 1.24 }
.cap1 strong { font-weight: 800; text-decoration: underline }
.cap1 .c1 { color: var(--navy) }
.cap1 .c2 { color: var(--terracotta-ink) }
.cap1 b { display: inline-block; width: 1.5cqw; line-height: 1.5cqw; border-radius: 50%; color: #fff; text-align: center; font-size: .88cqw; margin-right: .4cqw }
.cap1 .c1 b { background: var(--navy) } .cap1 .c2 b { background: var(--terracotta-ink) }
.idea { background: var(--navy); color: #fff; border-radius: .9cqw; padding: .45cqw 1.1cqw .55cqw; display: flex; flex-direction: column; justify-content: center; gap: .2cqw; font-size: 1cqw; line-height: 1.28; font-weight: 500 }
.idea h3 { margin: 0; font-family: var(--serif); font-size: 1.45cqw; font-weight: 700; line-height: 1.1 }
.idea p { margin: 0 }
.idea strong { color: var(--hi); font-weight: 800 }
.rules { font-size: 1.04cqw; grid-template-columns: 9.4cqw 1fr 1fr }
.rules > div { padding: .28cqw .9cqw .32cqw; line-height: 1.36 }
.rules .rl { font-size: .84cqw; padding-left: 1cqw }
.rules .lead { display: inline-block; font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; line-height: 1.5; color: var(--navy); background: var(--navy-soft); border-radius: .3cqw; padding: 0 .5cqw; margin-right: .8cqw; vertical-align: .08cqw }
.rules .aside { font-family: var(--serif); font-style: italic; color: var(--muted); font-size: .96cqw; margin-left: .7cqw }
.rules .no, .rules .ok { font-weight: 800; margin-right: .35cqw }
.rules .no { color: var(--terracotta-ink) }
.rules .ok { color: #1c6a3c; margin-left: .7cqw }
.key .sp { margin-left: 1.1cqw }
`;

function make({ file, pageTitle, h1, lede, n, title, steps, qr, key, body, css }) {
	let s = base;
	const rep = (a, b) => { if (!s.includes(a)) throw new Error(file + ' missing: ' + a.slice(0, 60)); s = s.split(a).join(b); };
	const cut = (from, to, w) => { const a = s.indexOf(from), b = s.indexOf(to, a); if (a < 0 || b < 0) throw new Error('marker ' + from); s = s.slice(0, a) + w + s.slice(b); };
	rep('<title>Verb Position Chart</title>', '<title>' + pageTitle + '</title>');
	rep('<h1>Chart 3, a decision path</h1>', '<h1>' + h1 + '</h1>');
	rep('<p>Word order. Three questions on the left decide where the verb goes. Each answer leads into a sentence track with fixed slots, so the eye learns the positions and not a list of rules.</p>', '<p>' + lede + '</p>');
	rep('<small>Chart 3</small>Where does the verb go?', '<small>Chart ' + n + '</small>' + title);
	rep('<span><b>1</b>Find the verb with the ending</span>', '<span><b>1</b>' + steps[0] + '</span>');
	rep('<span><b>2</b>Answer the questions</span>', '<span><b>2</b>' + steps[1] + '</span>');
	rep('<span><b>3</b>Put it in its slot</span>', '<span><b>3</b>' + steps[2] + '</span>');
	rep('data-qr="93"', 'data-qr="' + qr + '"');
	rep('<p class="note">The QR code is a placeholder. In the app, the same chart could let you drag the words into the slots.</p>', '<p class="note">The QR code is a placeholder.</p>');
	cut('<div class="key">', '</div>', '<div class="key">' + key);
	cut('<div class="main">', '<div class="key">', body + '\n\t\t');
	cut('(function () {', '// Placeholder QR', '');
	rep('</style>', COMMON + css + '</style>');
	writeFileSync(SRC + file + '.html', s);
	console.log('built', file);
}

/* ------------------------------------------------------------------ 15 */
const E = (end, exs, always) => ({ end, exs, always });
const col = (g, art, word, ends, groups) =>
	'<section class="gc ' + g + '"><header><b>' + art + '</b><span>' + word + '</span></header>' +
	'<h4>Always, no exceptions</h4><ul class="sure">' + ends.filter((e) => e.always).map((e) => '<li><b>' + e.end + '</b><span>' + e.exs + '</span></li>').join('') + '</ul>' +
	'<h4>Usually</h4><ul class="ends">' + ends.filter((e) => !e.always).map((e) => '<li><b>' + e.end + '</b><span>' + e.exs + '</span></li>').join('') + '</ul>' +
	'<h4>By meaning</h4><p class="grp">' + groups + '</p></section>';
make({
	file: '15-gender', pageTitle: 'Noun Gender Chart', n: 15, qr: 15,
	h1: 'Chart 15, der, die or das', lede: 'Noun gender. The end of the word often gives it away. One column per gender, with the endings that belong there.',
	title: 'der, die or das?',
	steps: ['Look at the end of the word', 'Find the ending in a column', 'No ending here? Learn it with its article'],
	key: '<b>Key:</b> <span class="kb gm">der</span> <span class="kb gf">die</span> <span class="kb gn">das</span> the three genders, the same colours on every chart <span class="sp">The big endings on top are right every time. The smaller ones are right most of the time.</span>',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span><span class="gf">die</span> Zeit<u class="x">ung</u></span><span><span class="gn">das</span> Mäd<u class="x">chen</u></span><span><span class="gm">der</span> Früh<u class="x">ling</u></span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: the <strong>end</strong> of the word, not its meaning.</span><span class="c2"><b>2</b>That is why a girl is das Mädchen: -chen always wins.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>You do not have to learn every article one by one. <strong>The ending often decides</strong>, and a handful of endings are right every time.</p></div>
		</div>

		<div class="gcols">
			${col('m', 'der', 'masculine', [
				E('-ling', 'Frühling · Lehrling', 1), E('-ismus', 'Tourismus · Optimismus', 1), E('-or', 'Motor · Direktor'),
				E('-ist · -ent', 'Polizist · Student'), E('-ig · -ich', 'Honig · Teppich'), E('-er', 'Lehrer · Computer · Koffer'), E('-en', 'Garten · Wagen · Regen')
			], '<b>Men and male jobs:</b> der Vater · der Arzt<br><b>Days, months, seasons:</b> der Montag · der Mai · der Sommer<br><b>Weather and compass:</b> der Regen · der Schnee · der Norden<br><b>Cars and most drinks:</b> der BMW · der Wein · der Kaffee')}
			${col('f', 'die', 'feminine', [
				E('-ung', 'Zeitung · Wohnung', 1), E('-heit · -keit', 'Freiheit · Möglichkeit', 1), E('-schaft', 'Freundschaft', 1),
				E('-ion · -tät', 'Station · Universität', 1), E('-ie · -ik · -ur', 'Familie · Musik · Natur'), E('-ei · -enz', 'Bäckerei · Konferenz'),
				E('-in', 'Lehrerin · Ärztin', 1), E('-e', 'Lampe · Straße · Tasche')
			], '<b>Women and female jobs:</b> die Mutter · die Ärztin<br><b>Numbers:</b> die Eins · die Million<br><b>Most trees, flowers, fruit:</b> die Rose · die Banane<br><b>Motorbikes and ships:</b> die Vespa · die Titanic')}
			${col('n', 'das', 'neuter', [
				E('-chen', 'Mädchen · Brötchen', 1), E('-lein', 'Büchlein · Fräulein', 1), E('-ment', 'Instrument · Dokument'), E('-um', 'Museum · Zentrum · Datum'),
				E('-ma', 'Thema · Klima · Drama'), E('-nis · -tum', 'Ergebnis · Eigentum'), E('-o', 'Auto · Kino · Büro · Foto'),
				E('Ge-', 'Gebäude · Gemüse · Gepäck'), E('verbs', 'das Essen · das Leben', 1)
			], '<b>The young:</b> das Kind · das Baby · das Kalb<br><b>Colours and languages:</b> das Blau · das Deutsch<br><b>Metals and letters:</b> das Gold · das A<br><b>Hotels, cafés, cinemas:</b> das Hilton · das Odeon')}
		</div>

		<div class="rules">
			<div class="rl">long words</div>
			<div><b class="lead">the last word decides</b><span class="gn">das</span> Haus + <span class="gf">die</span> Tür = <span class="gf">die</span> Haustür <span class="aside">see Chart 9</span></div>
			<div><b class="lead">plural</b>is always <b>die</b>, whatever the gender: die Männer · die Frauen · die Kinder</div>
			<div class="rl">no rule fits</div>
			<div><b class="lead">learn three words, not one</b>article + noun + plural: der Tisch, die Tische</div>
			<div><b class="lead">a good guess</b>short one-syllable words are often <span class="gm"><b>der</b></span>: der Tisch · der Stuhl</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">-e, but der</b>male beings: der Junge · der Kollege, and der Name · der Käse</div>
			<div><b class="lead">-er, but not der</b>die Mutter · die Butter · das Zimmer · das Wetter · das Fenster</div>
		</div>`,
	css: `.look .demo { gap: 1.8cqw; font-size: 2.1cqw }
.look .demo .gm, .look .demo .gf, .look .demo .gn { font-weight: 800 }
.gcols { flex: 1; min-height: 0; display: grid; grid-template-columns: repeat(3, 1fr); gap: 1cqw }
.gc { --g: var(--m); border: .35cqw solid var(--g); border-radius: .9cqw; overflow: hidden; display: flex; flex-direction: column; min-height: 0 }
.gc.f { --g: var(--f) } .gc.n { --g: var(--n) }
.gc header { background: var(--g); color: #fff; padding: .1cqw 1cqw .3cqw; display: flex; align-items: baseline; gap: .9cqw }
.gc header b { font-family: var(--serif); font-size: 2.6cqw; font-weight: 700; line-height: 1.05 }
.gc header span { font-size: .84cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase }
.gc h4 { margin: .4cqw 1cqw .05cqw; font-size: .74cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase; color: var(--g) }
.sure { list-style: none; margin: 0; padding: .1cqw 1cqw .2cqw; display: flex; flex-direction: column; gap: .12cqw }
.sure li { display: grid; grid-template-columns: 12.5cqw 1fr; align-items: baseline; white-space: nowrap }
.sure b { font-size: 1.85cqw; font-weight: 800; color: var(--g); line-height: 1.22 }
.sure span { font-size: 1.04cqw; font-weight: 500 }
.gc h4:first-of-type { color: #fff; background: var(--g); margin: 0; padding: 0 1cqw .4cqw; font-size: .8cqw }
.ends { flex: 1; list-style: none; margin: 0; padding: 0 1cqw; display: flex; flex-direction: column; justify-content: space-evenly; border-top: .12cqw solid var(--g); padding-top: .1cqw }
.ends li { display: grid; grid-template-columns: 8.4cqw 1fr; align-items: baseline; gap: .5cqw; border-bottom: .1cqw solid #d6d0c4; padding: .08cqw 0 .12cqw; white-space: nowrap }
.ends li:last-child { border-bottom: 0 }
.ends b { font-size: 1.1cqw; font-weight: 800; color: var(--g) }
.ends span { font-size: .98cqw; font-weight: 500 }
.ends i, .alw { font-style: normal; font-size: .64cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; background: var(--ink); color: #fff; border-radius: .25cqw; padding: .05cqw .35cqw }
.grp { margin: 0 1cqw .5cqw; font-size: .9cqw; line-height: 1.4 }
.grp b { font-weight: 800 }
.kb { display: inline-block; border: .2cqw solid currentColor; border-radius: .35cqw; padding: 0 .5cqw; font-weight: 800 }
`
});

/* ------------------------------------------------------------------ 16 */
const P = (art, g, sg, pl, en) => '<span class="pe"><span class="sg"><span class="' + g + '">' + art + '</span> ' + sg + '</span><span class="ar">→</span><b>' + pl + '</b>' + (en ? '<i>' + en + '</i>' : '') + '</span>';
const X = (t) => '<u class="x">' + t + '</u>', UM = (t) => '<u class="um">' + t + '</u>';
const lane = (end, sub, who, exs, note) => '<div class="pl"><div class="pb"><b>' + end + '</b><span>' + sub + '</span></div><div class="pw">' + who + '</div><div class="px">' + exs.join('') + '</div><div class="pn"><p>' + note + '</p></div></div>';
make({
	file: '16-plural', pageTitle: 'Plural Chart', n: 16, qr: 16,
	h1: 'Chart 16, five plurals', lede: 'The plural. German has five plural endings. The gender and the end of the word give you a good first guess.',
	title: 'One Tisch, two …?',
	steps: ['Gender and ending of the noun', 'Find its row', 'Check: does the vowel change?'],
	key: '<b>Key:</b> <span>Tisch' + X('e') + '</span> the plural ending <span class="sp">St' + UM('ü') + 'hle</span> the vowel changes: a → ä, o → ö, u → ü <b class="sp">Every plural takes the article die.</b>',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span><span class="gm">der</span> Tisch</span><span class="ar">→</span><span><span class="pld">die</span> Tisch${X('e')}</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: the article becomes <strong>die</strong> for every plural.</span><span class="c2"><b>2</b>Then the noun takes one of five endings. Its gender tells you which to try first.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>There is no single rule, but there is a <strong>best guess</strong>: die-nouns take <strong>-n</strong>, der-nouns take <strong>-e</strong>, short das-nouns take <strong>-er</strong>.</p></div>
		</div>

		<div class="plist">
			<div class="ph"><span>Ending</span><span>Who takes it</span><span>Examples</span><span>Good to know</span></div>
			${lane('-n · -en', 'the die plural', '<b>Almost every die-noun</b>, and every noun that ends in -e', [
				P('die', 'gf', 'Lampe', 'Lampe' + X('n'), 'lamps'), P('die', 'gf', 'Frau', 'Frau' + X('en'), 'women'), P('der', 'gm', 'Junge', 'Junge' + X('n'), 'boys')], 'Never an umlaut. <b>-in</b> doubles the n: Lehrerin → Lehrerin' + X('nen') + '.')}
			${lane('-e', 'the der plural', '<b>Most der-nouns</b>, and many das-nouns', [
				P('der', 'gm', 'Tisch', 'Tisch' + X('e'), 'tables'), P('der', 'gm', 'Stuhl', 'St' + UM('ü') + 'hl' + X('e'), 'chairs'), P('das', 'gn', 'Jahr', 'Jahr' + X('e'), 'years')], 'der-nouns often change the vowel. The few die-nouns here always do: Stadt → St' + UM('ä') + 'dt' + X('e') + '.')}
			${lane('-er', 'the das plural', '<b>Many short das-nouns</b>, and a few der-nouns', [
				P('das', 'gn', 'Kind', 'Kind' + X('er'), 'children'), P('das', 'gn', 'Buch', 'B' + UM('ü') + 'ch' + X('er'), 'books'), P('der', 'gm', 'Mann', 'M' + UM('ä') + 'nn' + X('er'), 'men')], 'The vowel changes whenever it can: Haus → H' + UM('äu') + 's' + X('er') + '. Never a die-noun.')}
			${lane('–', 'no ending', '<b>der- and das-nouns in -er, -el, -en</b>, and all in -chen, -lein', [
				P('der', 'gm', 'Lehrer', 'Lehrer', 'teachers'), P('das', 'gn', 'Mädchen', 'Mädchen', 'girls'), P('der', 'gm', 'Vater', 'V' + UM('ä') + 'ter', 'fathers')], 'Only the article shows the plural. Sometimes the vowel changes: Apfel → ' + UM('Ä') + 'pfel.')}
			${lane('-s', 'the import', '<b>Words from other languages</b>, short forms, and words ending in a, i, o, u', [
				P('das', 'gn', 'Auto', 'Auto' + X('s'), 'cars'), P('das', 'gn', 'Hotel', 'Hotel' + X('s'), 'hotels'), P('die', 'gf', 'Oma', 'Oma' + X('s'), 'grandmas')], 'Never an umlaut. Also names: die Müller' + X('s') + '.')}
		</div>

		<div class="rules">
			<div class="rl">Dativ plural</div>
			<div><b class="lead dt">one more -n</b>mit den Kinder${X('n')} · in den Häuser${X('n')} <span class="aside">see Chart 1</span></div>
			<div><b class="lead">not after -n or -s</b>mit den Frauen · mit den Autos</div>
			<div class="rl">no plural</div>
			<div><b class="lead">only singular</b>das Obst · die Milch · das Gepäck · die Polizei</div>
			<div><b class="lead">only plural</b>die Eltern · die Leute · die Ferien · die Geschwister</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">English habit</b><span class="no">✗</span><s>die Tischs · die Kinds</s> <span class="ok">✓</span>die Tische · die Kinder</div>
			<div><b class="lead">-nis and -us</b>das Ergebnis → Ergebnis${X('se')} · der Bus → Bus${X('se')}</div>
		</div>`,
	css: `.pld { font-weight: 800 }
.look .demo .gm { font-weight: 800 }
.sheet u.um { text-decoration: none; background: var(--hi); font-weight: 800; padding: 0 .08cqw }
.plist { flex: 1; min-height: 0; display: grid; grid-template-rows: auto repeat(5, 1fr); border: .4cqw solid var(--navy) }
.ph, .pl { display: grid; grid-template-columns: 10cqw 19cqw 1fr 22cqw; align-items: center }
.ph { background: var(--navy-soft); font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: var(--navy) }
.ph span { padding: .25cqw .9cqw }
.pl { border-top: .12cqw solid var(--line); min-height: 0 }
.pl > div { padding: 0 .9cqw; min-width: 0 }
.pb { align-self: stretch; background: var(--terracotta-ink); color: #fff; display: flex; flex-direction: column; justify-content: center; gap: .1cqw }
.pb b { font-family: var(--serif); font-size: 2.3cqw; font-weight: 700; line-height: 1; white-space: nowrap }
.pb span { font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.pw { font-size: 1.04cqw; line-height: 1.3 }
.pw b { font-weight: 800 }
.px { display: grid; grid-template-columns: repeat(3, 1fr); gap: .6cqw; border-left: .12cqw solid var(--line); align-self: stretch; align-items: center }
.pe { display: grid; grid-template-columns: auto auto; justify-content: start; column-gap: .4cqw; align-items: baseline; white-space: nowrap; line-height: 1.25 }
.pe .sg { font-size: 1cqw; font-weight: 500; grid-column: 1 / 3 }
.pe .sg span { font-weight: 800 }
.pe .ar { color: var(--terracotta-ink); font-weight: 800; font-size: 1.1cqw }
.pe b { font-size: 1.4cqw; font-weight: 800 }
.pe i { grid-column: 1 / 3; font-family: var(--serif); font-size: .9cqw; color: var(--muted) }
.pn { font-size: .98cqw; line-height: 1.32; border-left: .12cqw solid var(--line); align-self: stretch; display: flex; align-items: center }
.pn b { font-weight: 800 }
.pn p { margin: 0 }
.rules .lead.dt { background: var(--dat); color: #fff }
`
});

/* ------------------------------------------------------------------ 17 */
const N = (t) => '<u class="x">' + t + '</u>';
const crow = (c, name, sgArt, sg, plArt, pl, ex) => '<div class="cl">' + TAG(c, name) + '</div><div class="cf"><span>' + C(c, sgArt) + ' ' + sg + '</span></div><div class="cf"><span>' + C(c, plArt) + ' ' + pl + '</span></div><div class="ce"><span>' + ex + '</span></div>';
const who = (title, sub, words) => '<div class="wc"><h4>' + title + '</h4><p class="ws">' + sub + '</p><p class="ww">' + words + '</p></div>';
make({
	file: '17-n-nouns', pageTitle: 'N-Nouns Chart', n: 17, qr: 17,
	h1: 'Chart 17, nouns that add -n', lede: 'A small group of masculine nouns add -n or -en in every form except the plain one. The chart shows when, and which nouns.',
	title: 'Nouns that add -n',
	steps: ['Is it one of these masculine nouns?', 'Is it the plain subject form?', 'If not: add -n or -en'],
	key: '<b>Key:</b> <span>Student' + N('en') + '</span> the added ending <b class="sp">Cases:</b> <span class="tag nom">Nominativ</span> <span class="tag akk">Akkusativ</span> <span class="tag dat">Dativ</span> <span class="tag gen">Genitiv</span>',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span>${C('nom', 'der')} Student</span><span class="ar">→</span><span>Ich kenne ${C('akk', 'den')} Student${N('en')}.</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: the <strong>noun</strong> changes too, not only the article.</span><span class="c2"><b>2</b>Normally a German noun stays the same. These ones do not.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>Some masculine nouns have <strong>two forms</strong>: the plain one for the subject, and one with <strong>-n</strong> or <strong>-en</strong> for everything else.</p></div>
		</div>

		<div class="nbody">
			<div class="ct">
				<div class="ch" style="border-left:0">Case</div><div class="ch">One</div><div class="ch">Several</div><div class="ch">In a sentence</div>
				${crow('nom', 'Nominativ', 'der', 'Student', 'die', 'Student' + N('en'), 'Der Student lernt.')}
				${crow('akk', 'Akkusativ', 'den', 'Student' + N('en'), 'die', 'Student' + N('en'), 'Ich kenne den Student' + N('en') + '.')}
				${crow('dat', 'Dativ', 'dem', 'Student' + N('en'), 'den', 'Student' + N('en'), 'Ich helfe dem Student' + N('en') + '.')}
				${crow('gen', 'Genitiv', 'des', 'Student' + N('en'), 'der', 'Student' + N('en'), 'das Buch des Student' + N('en'))}
				<div class="cn">Seven of the eight forms are the same. Only the plain subject form, top left, is different. The Genitiv takes no -s.</div>
			</div>
			<div class="wcs">
				<div class="wt">Which nouns? Only masculine ones, and mostly people and animals.</div>
				${who('They end in -e', 'add -n', 'der Junge · der Kollege · der Kunde · der Name · der Löwe · der Affe · der Franzose · der Pole · der Türke · der Experte')}
				${who('They end in -ent, -ant, -ist, -at', 'add -en', 'der Student · der Präsident · der Praktikant · der Tourist · der Polizist · der Journalist · der Soldat · der Automat')}
				${who('A few short ones', 'add -en', 'der Mensch · der Held · der Bär · der Prinz, and with -n only: der Nachbar · der Bauer · der Herr')}
			</div>
		</div>

		<div class="rules">
			<div class="rl">quick test</div>
			<div><b class="lead">is it one of them?</b>Masculine, and the plural ends in -n or -en: der Kollege, die Kollegen.</div>
			<div><b class="lead">not these</b>der Lehrer, die Lehrer · der Freund, die Freunde: another plural, so no -n.</div>
			<div class="rl">special</div>
			<div><b class="lead">Herr</b>-n for one, -en for several: Ich sehe Herr${N('n')} Müller. · die Herr${N('en')}</div>
			<div><b class="lead">Genitiv with -ns</b>der Name → des Name${N('ns')} · also Gedanke, Buchstabe</div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>Ich frage den Kollege.</s> <span class="ok">✓</span>Ich frage ${C('akk', 'den')} Kollege${N('n')}.</div>
			<div><span class="no">✗</span><s>mit dem Tourist</s> <span class="ok">✓</span>mit ${C('dat', 'dem')} Tourist${N('en')}. <span class="aside">often dropped in speech</span></div>
		</div>`,
	css: `.look .demo { font-size: 1.9cqw; gap: .9cqw }
.look .demo em { padding: 0 .35cqw }
.nbody { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.45fr 1fr; gap: 1.2cqw }
.ct { display: grid; grid-template-columns: 8.2cqw 1fr 1fr 1.3fr; grid-template-rows: auto repeat(4, 1fr) auto; border: .4cqw solid var(--navy); min-height: 0 }
.ct > div { border-left: .12cqw solid var(--line); border-top: .12cqw solid var(--line); display: flex; align-items: center; gap: .45cqw; padding: 0 .8cqw; white-space: nowrap; min-width: 0 }
.ct > .ch { border-top: 0; background: var(--navy-soft); color: var(--navy); font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; padding-block: .3cqw }
.ct > .cl { border-left: 0 }
.cf { font-size: 1.38cqw; font-weight: 700 }
.cf i { font-family: var(--serif); font-size: .9cqw; font-weight: 400; color: var(--muted); margin-left: .3cqw }
.ce { font-size: 1.02cqw; font-weight: 500 }
.cn { grid-column: 1 / -1; border-left: 0 !important; font-size: .96cqw; font-weight: 600; padding-block: .35cqw !important; white-space: normal !important }
.wcs { display: grid; grid-template-rows: auto repeat(3, 1fr); gap: .7cqw; min-height: 0 }
.wt { font-size: 1.06cqw; font-weight: 700; color: var(--navy) }
.wc { border: .3cqw solid var(--terracotta-ink); border-radius: .8cqw; padding: .4cqw 1cqw .5cqw; display: grid; grid-template-columns: 1fr auto; align-content: center; column-gap: 1cqw; row-gap: .2cqw; min-height: 0 }
.wc h4 { margin: 0; font-family: var(--serif); font-size: 1.36cqw; color: var(--navy); line-height: 1.15 }
.wc .ws { margin: 0; font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: .1cqw .5cqw; align-self: center }
.wc .ww { margin: 0; grid-column: 1 / -1; font-size: 1.04cqw; line-height: 1.42; font-weight: 500 }
`
});
