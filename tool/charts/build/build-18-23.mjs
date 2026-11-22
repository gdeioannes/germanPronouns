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


/* ================================================================== 18–23 */
const V = (t) => '<span class="v">' + t + '</span>';
const LAD = `.main { gap: .8cqw 0 }
.q { padding: .4cqw 1cqw .5cqw; gap: .2cqw }
.q h3 { font-size: 1.5cqw }
.q p { font-size: .98cqw; line-height: 1.25 }
.down { height: 1.6cqw; margin-bottom: -.8cqw }
.yes { padding-bottom: .8cqw }
.lane { grid-template-columns: 12.6cqw 1fr }
.badge b { font-size: 2.3cqw; white-space: nowrap; line-height: 1 }
.badge span { font-size: .86cqw; font-weight: 700 }
.res { display: flex; flex-direction: column; min-height: 0; min-width: 0 }
.exs { flex: 1; display: grid; grid-template-columns: repeat(3, 1fr); font-size: 1.28cqw; font-weight: 700; white-space: nowrap }
.exs > span { padding: 0 .9cqw; border-left: .12cqw solid var(--line); display: flex; flex-direction: column; justify-content: center; gap: .12cqw; min-width: 0 }
.exs > span:first-child { border-left: 0 }
.exs i { font-family: var(--serif); font-size: .92cqw; font-weight: 400; color: var(--muted) }
.exs small { font-size: .7cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: var(--terracotta-ink) }
.res .foot { margin: 0; padding: .25cqw .9cqw .3cqw; border-top: .12cqw solid var(--line); font-size: .96cqw; line-height: 1.28 }
.res .foot b { font-weight: 800 }
.sheet mark { background: var(--navy); color: #fff; font-weight: 800; padding: 0 .35cqw; border-radius: .25cqw }
.sheet mark.t { background: var(--terracotta-ink) }
.sheet mark.o { background: #fff; color: var(--ink); box-shadow: inset 0 0 0 .14cqw var(--ink) }
`;
const ask = (n, h, p, last, cls) => '<div class="ask"><div class="q' + (cls ? ' ' + cls : '') + '"><h3><b class="n"' + (cls ? ' style="background:var(--navy);color:#fff"' : '') + '>' + n + '</b>' + h + '</h3><p>' + p + '</p></div>' + (last ? '' : '<div class="down">no</div>') + '</div><div class="yes' + (last ? ' last' : '') + '">' + (last ? 'so' : 'yes') + '<i></i></div>';
const lad = (big, small, exs, foot, last) => '<div class="lane' + (last ? ' last' : '') + '"><div class="badge"><b>' + big + '</b><span>' + small + '</span></div><div class="res"><div class="exs">' + exs.map(([lab, de, en]) => '<span><small>' + lab + '</small><span class="de">' + de + '</span><i>' + en + '</i></span>').join('') + '</div><p class="foot">' + foot + '</p></div></div>';
const M = (t) => '<mark>' + t + '</mark>', MT = (t) => '<mark class="t">' + t + '</mark>', MO = (t) => '<mark class="o">' + t + '</mark>';

/* ------------------------------------------------------------------ 18 */
make({
	file: '18-articles', pageTitle: 'Article Choice Chart', n: 18, qr: 18,
	h1: 'Chart 18, der, ein or nothing', lede: 'Which article? Two questions decide between der, ein and no article at all.',
	title: 'der, ein or nothing?',
	steps: ['Do we both know which one?', 'Is it a job, stuff or a general plural?', 'Otherwise: ein'],
	key: '<b>Key:</b> ' + M('der') + ' the one we both know <span class="sp">' + MT('ein') + '</span> one of many, new in the conversation <span class="sp">' + MO('–') + '</span> no article',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span>Da ist ${MT('ein')} Hund.</span><span class="ar">→</span><span>${M('Der')} Hund ist groß.</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: the same dog, twice. New the first time, known the second.</span><span class="c2"><b>2</b>New gets <strong>ein</strong>. Known gets <strong>der</strong>.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>The article tells your listener one thing: <strong>do you already know which one I mean?</strong> Yes is der, no is ein.</p></div>
		</div>

		<div class="main" style="grid-template-rows: 1fr 1.12fr 1fr">
			${ask(1, 'Do we both know which one?', 'It was mentioned before, there is only one, or you say exactly which.')}
			${lad('der · die · das', 'the known one', [
				['mentioned before', M('Der') + ' Hund ist groß.', 'The dog is big.'],
				['only one exists', M('Die') + ' Sonne scheint.', 'The sun is shining.'],
				['you say which', M('das') + ' Auto von Anna', "Anna's car"]
			], '<b>Also for things in general:</b> ' + M('Das') + ' Leben ist schön. · ' + M('Der') + ' Mensch braucht Wasser.')}
			${ask(2, 'A job, stuff, or things in general?', 'What somebody is, something you cannot count, or a plural that means all of them.')}
			${lad('–', 'no article', [
				['job, nationality', 'Ich bin ' + MO('–') + ' Lehrer.', 'I am a teacher.'],
				['stuff, no number', 'Ich trinke ' + MO('–') + ' Kaffee.', 'I drink coffee.'],
				['plural, in general', MO('–') + ' Kinder spielen gern.', 'Children like to play.']
			], '<b>Also:</b> cities and most countries (in Berlin, aus Spanien), languages (Ich lerne Deutsch), instruments and sports (Ich spiele Gitarre), and Ich habe Hunger · Zeit · Angst.')}
			${ask(3, 'Everything else', 'One of many, or new in the conversation.', true, 'else')}
			${lad('ein · eine', 'one of many, new', [
				['new', 'Da ist ' + MT('ein') + ' Hund.', 'There is a dog.'],
				['any one', 'Ich brauche ' + MT('einen') + ' Stift.', 'I need a pen.'],
				['job + adjective', 'Sie ist ' + MT('eine') + ' gute Ärztin.', 'She is a good doctor.']
			], '<b>ein has no plural.</b> Several new things take no article: Da sind ' + MO('–') + ' Hunde. The negative is kein, see Chart 19.', true)}
		</div>

		<div class="rules">
			<div class="rl">countries</div>
			<div><b class="lead">most: no article</b>Ich wohne in Deutschland. · Sie kommt aus Italien.</div>
			<div><b class="lead">a few: always with one</b>die Schweiz · die Türkei · die USA · der Iran</div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>Ich bin ein Lehrer.</s> <span class="ok">✓</span>Ich bin Lehrer. <span class="aside">English says "a teacher"</span></div>
			<div><span class="no">✗</span><s>Ich spiele die Gitarre.</s> <span class="ok">✓</span>Ich spiele Gitarre. </div>
		</div>`,
	css: LAD + `.badge b { font-size: 1.7cqw }
.look .demo { font-size: 1.9cqw }
.look .demo mark { padding: 0 .5cqw; border-radius: .35cqw }
`
});

/* ------------------------------------------------------------------ 19 */
make({
	file: '19-kein-nicht', pageTitle: 'Kein or Nicht Chart', n: 19, qr: 19,
	h1: 'Chart 19, kein or nicht', lede: 'Saying no. One question decides between kein and nicht, and a second part shows where nicht stands.',
	title: 'kein or nicht?',
	steps: ['A noun with ein, or with no article?', 'Yes: kein', 'No: nicht'],
	key: '<b>Key:</b> ' + MT('kein') + ' says no to a noun <span class="sp">' + M('nicht') + '</span> says no to everything else <span class="v sp">kaufe</span> the verb',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span>Ich habe ${MT('kein')} Auto.</span><span>Ich fahre ${M('nicht')}.</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: what are you saying no to? A <strong>thing</strong>, or something else?</span><span class="c2"><b>2</b>kein is simply "not a" or "no": ein Auto, kein Auto.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p><strong>kein</strong> is the opposite of ein. If the sentence has ein, or a noun with no article, use kein. For everything else it is <strong>nicht</strong>.</p></div>
		</div>

		<div class="main" style="grid-template-rows: 1fr 1fr 1.05fr">
			${ask(1, 'A noun with ein, or with no article?', 'Ich habe <b>ein</b> Auto. · Ich habe Zeit. · Das sind Äpfel.')}
			${lad('kein', 'not a, no, not any', [
				['ein → kein', 'Ich habe ' + MT('kein') + ' Auto.', 'I have no car.'],
				['no article → kein', 'Ich habe ' + MT('keine') + ' Zeit.', 'I have no time.'],
				['plural → keine', 'Das sind ' + MT('keine') + ' Äpfel.', 'Those are not apples.']
			], '<b>kein takes the endings of ein:</b> kein Hund · keine Katze · keinen Hund (Akkusativ) · mit keinem Hund (Dativ).')}
			${ask(2, 'Everything else', 'A verb, an adjective, a place, a time, or a noun with der or mein.', true, 'else')}
			${lad('nicht', 'not', [
				['a verb', 'Ich schlafe ' + M('nicht') + '.', 'I am not sleeping.'],
				['an adjective', 'Das ist ' + M('nicht') + ' gut.', 'That is not good.'],
				['der, mein + noun', 'Das ist ' + M('nicht') + ' mein Auto.', 'That is not my car.']
			], '<b>Names too:</b> Das ist ' + M('nicht') + ' Anna. <b>And places and times:</b> ' + M('nicht') + ' in Berlin · ' + M('nicht') + ' heute.', true)}
			<div class="ask"><div class="q where"><h3>Where does nicht stand?</h3><p>As far back as it can, but in front of the part it says no to.</p></div></div>
			<div class="yes last">so<i></i></div>
			${lad('…nicht', 'its place', [
				['whole sentence: the end', 'Ich kaufe es ' + M('nicht') + '.', 'I am not buying it.'],
				['before the 2nd verb part', 'Ich habe ' + M('nicht') + ' gekauft.', 'I have not bought.'],
				['before adjective, place, how', 'Ich bin ' + M('nicht') + ' müde.', 'I am not tired.']
			], '<b>One part only:</b> put nicht right before it and add sondern: Ich komme ' + M('nicht') + ' heute, sondern morgen.', true)}
		</div>

		<div class="rules">
			<div class="rl">small helpers</div>
			<div><b class="lead">not yet · no longer</b>Ich bin noch nicht fertig. · Ich rauche nicht mehr.</div>
			<div><b class="lead">with kein</b>Ich habe noch kein Auto. · Ich habe kein Geld mehr.</div>
			<div class="rl">answering</div>
			<div><b class="lead">doch</b>says yes to a negative question: Hast du kein Auto? <b>Doch</b>, ich habe eins.</div>
			<div><b class="lead">alone</b>kein can stand without a noun: Hast du ein Auto? Nein, ich habe <b>keins</b>.</div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>Ich habe nicht ein Auto.</s> <span class="ok">✓</span>Ich habe ${MT('kein')} Auto.</div>
			<div><span class="no">✗</span><s>Ich nicht verstehe.</s> <span class="ok">✓</span>Ich ${V('verstehe')} ${M('nicht')}. <span class="aside">the verb stays second, see Chart 3</span></div>
		</div>`,
	css: LAD + `.look .demo { font-size: 1.9cqw; gap: 2cqw }
.look .demo mark { padding: 0 .5cqw; border-radius: .35cqw }
.q.where { background: var(--terracotta-ink) }
.q.where h3 { font-size: 1.4cqw }
.rules .v { padding: 0 .3cqw; border-radius: .25cqw }
.key .v { padding: 0 .4cqw; border-radius: .25cqw }
`
});

/* ------------------------------------------------------------------ 20 */
const own = (who, stem, en) => '<div class="ow">' + who + '</div><div class="os"><b>' + stem + '</b></div><div class="oe">' + en + '</div>';
const cell = (stem, end, noun, g, en) => '<div class="pc2"><p class="pw"><b class="st">' + stem + '</b>' + (end ? '<u class="x">' + end + '</u>' : '') + ' <span class="' + g + '">' + noun + '</span></p><p class="pen">' + en + '</p></div>';
make({
	file: '20-possessives', pageTitle: 'Possessives Chart', n: 20, qr: 20,
	h1: 'Chart 20, mein, dein, sein, ihr', lede: 'Possessives. Two separate choices: the word comes from the owner, the ending comes from the thing.',
	title: 'mein, dein, sein, ihr',
	steps: ['Who owns it? The word', 'What is owned? The ending', 'Endings as for ein'],
	key: '<b>Key:</b> <b class="st">sein</b> the word: from the owner <span class="sp">ihr<u class="x">e</u></span> the ending: from the thing owned <span class="kb gm sp">der</span> <span class="kb gf">die</span> <span class="kb gn">das</span> the gender of the thing',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span>Tom + <span class="gf">die</span> Katze</span><span class="ar">→</span><span><b class="st">sein</b><u class="x">e</u> Katze</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: two halves. <strong>sein</strong> because Tom is a he.</span><span class="c2"><b>2</b><strong>-e</strong> because Katze is a die-word. The owner and the thing never mix.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>Ask two questions, in this order. <strong>Who owns it?</strong> gives the word. <strong>What is it?</strong> gives the ending. Tom's cat is seine Katze, Anna's dog is ihr Hund.</p></div>
		</div>

		<div class="pbody">
			<div class="grid2">
				<div class="gh0"></div><div class="ghd gm">der Hund</div><div class="ghd gf">die Katze</div><div class="ghd gn">das Auto</div><div class="ghd gp">die Kinder</div>
				<div class="gr"><b>Tom</b><span>he → sein</span></div>${cell('sein', '', 'Hund', 'gm', 'his dog')}${cell('sein', 'e', 'Katze', 'gf', 'his cat')}${cell('sein', '', 'Auto', 'gn', 'his car')}${cell('sein', 'e', 'Kinder', 'gp', 'his children')}
				<div class="gr"><b>Anna</b><span>she → ihr</span></div>${cell('ihr', '', 'Hund', 'gm', 'her dog')}${cell('ihr', 'e', 'Katze', 'gf', 'her cat')}${cell('ihr', '', 'Auto', 'gn', 'her car')}${cell('ihr', 'e', 'Kinder', 'gp', 'her children')}
				<div class="gr"><b>ich</b><span>I → mein</span></div>${cell('mein', '', 'Hund', 'gm', 'my dog')}${cell('mein', 'e', 'Katze', 'gf', 'my cat')}${cell('mein', '', 'Auto', 'gn', 'my car')}${cell('mein', 'e', 'Kinder', 'gp', 'my children')}
				<div class="gnote">Read a row: the word never changes. Read a column: the ending never changes. die-words and plurals add -e.</div>
			</div>
			<div class="owners">
				<div class="oh">Who owns it?</div><div class="oh">The word</div><div class="oh">In English</div>
				${own('ich', 'mein', 'my')}${own('du', 'dein', 'your')}${own('er · es', 'sein', 'his, its')}${own('sie', 'ihr', 'her')}
				${own('wir', 'unser', 'our')}${own('ihr', 'euer', 'your (you all)')}${own('sie', 'ihr', 'their')}${own('Sie', 'Ihr', 'your (formal)')}
			</div>
		</div>

		<div class="rules">
			<div class="rl">other cases</div>
			<div><b class="lead">like ein and kein</b>Ich sehe sein<u class="x">en</u> Hund. ${TAG('akk', 'Akkusativ')} · mit sein<u class="x">em</u> Hund ${TAG('dat', 'Dativ')} </div>
			<div><b class="lead">euer loses an e</b>euer Hund, but eur<u class="x">e</u> Katze · eur<u class="x">en</u> Hund</div>
			<div class="rl">three times ihr</div>
			<div><b class="lead">her · their</b>ihr Hund = her dog, or their dog. The context tells you.</div>
			<div><b class="lead">Ihr, capital</b>= your, formal: Ist das Ihr Hund? <span class="aside">and ihr alone = you all: Ihr kommt.</span></div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>Anna und sein Hund</s> <span class="ok">✓</span>Anna und <b class="st">ihr</b> Hund. <span class="aside">the owner decides, not the dog</span></div>
			<div><span class="no">✗</span><s>sein Katze</s> <span class="ok">✓</span><b class="st">sein</b><u class="x">e</u> Katze. <span class="aside">die-word, so -e</span></div>
		</div>`,
	css: `.st { background: var(--navy); color: #fff; font-weight: 800; padding: 0 .3cqw; border-radius: .25cqw }
.gp { color: var(--pl) }
.look .demo { font-size: 2cqw }
.look .demo .gf { font-weight: 800 }
.look .demo .st { padding: 0 .5cqw }
.pbody { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 26cqw; gap: 1.2cqw }
.grid2 { display: grid; grid-template-columns: 9cqw repeat(4, 1fr); grid-template-rows: auto repeat(3, 1fr) auto; border: .4cqw solid var(--navy); min-height: 0 }
.grid2 > div { border-left: .12cqw solid var(--line); border-top: .12cqw solid var(--line); min-width: 0 }
.gh0, .ghd { border-top: 0 !important; background: var(--navy-soft); padding: .3cqw .9cqw; font-size: 1.2cqw; font-weight: 800 }
.gh0 { border-left: 0 !important }
.gr { border-left: 0 !important; background: var(--navy); color: #fff; display: flex; flex-direction: column; justify-content: center; padding: 0 .9cqw; gap: .15cqw }
.gr b { font-family: var(--serif); font-size: 1.8cqw; line-height: 1 }
.gr span { font-size: .8cqw; font-weight: 700 }
.pc2 { display: flex; flex-direction: column; justify-content: center; padding: 0 .9cqw; gap: .2cqw }
.pc2 p { margin: 0; white-space: nowrap }
.pc2 .pw { font-size: 1.5cqw; font-weight: 700 }
.pc2 .pw span { font-weight: 800 }
.pc2 .pen { font-family: var(--serif); font-style: italic; font-size: .98cqw; color: var(--muted) }
.gnote { grid-column: 1 / -1; border-left: 0 !important; padding: .35cqw .9cqw; font-size: .98cqw; font-weight: 600 }
.owners { display: grid; grid-template-columns: 1fr 1fr 1.3fr; grid-template-rows: auto repeat(8, 1fr); border: .25cqw solid var(--navy); min-height: 0 }
.owners > div { border-top: .12cqw solid var(--line); display: flex; align-items: center; padding: 0 .8cqw; font-size: 1.14cqw; white-space: nowrap }
.owners > .oh { border-top: 0; background: var(--navy-soft); color: var(--navy); font-size: .74cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; padding-block: .3cqw }
.owners .ow { font-weight: 600 }
.owners .os b { background: var(--navy); color: #fff; padding: 0 .4cqw; border-radius: .25cqw; font-size: 1.2cqw }
.owners .oe { font-family: var(--serif); font-style: italic; color: var(--muted); font-size: 1.02cqw }
.kb { display: inline-block; border: .2cqw solid currentColor; border-radius: .35cqw; padding: 0 .5cqw; font-weight: 800 }
`
});

/* ------------------------------------------------------------------ 21 */
const pr = (who, en, n, a, d, mark) => '<div class="pp' + (mark ? ' ' + mark : '') + '"><b>' + who + '</b><i>' + en + '</i></div><div class="pf2">' + C('nom', n) + '</div><div class="pf2">' + C('akk', a) + '</div><div class="pf2">' + C('dat', d) + '</div>';
make({
	file: '21-pronouns', pageTitle: 'Pronoun Chart', n: 21, qr: 21,
	h1: 'Chart 21, ich, mich, mir', lede: 'Personal pronouns. Every person has three forms: one for doing, one for being done to, one for receiving.',
	title: 'ich, mich or mir?',
	steps: ['Who is it? Find the row', 'What is its job? Find the column', 'Read the form'],
	key: '<b>Cases:</b> <span class="tag nom">Nominativ</span> does it <span class="tag akk sp">Akkusativ</span> it is done to <span class="tag dat sp">Dativ</span> gets it, or after mit, von, zu …',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span>${C('nom', 'Ich')} sehe ${C('akk', 'dich')}.</span><span>${C('nom', 'Du')} siehst ${C('akk', 'mich')}.</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: the same two people, swapped. English does this too: <strong>I</strong> see you, you see <strong>me</strong>.</span><span class="c2"><b>2</b>German just has one more form: mir, for "to me".</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>A pronoun changes with its <strong>job</strong> in the sentence. English has two forms (I, me). German has three: <strong>ich, mich, mir</strong>.</p></div>
		</div>

		<div class="prbody">
			<div class="prt">
				<div class="prh" style="border-left:0">Who</div>
				<div class="prh"><span class="tag nom">Nominativ</span> does it</div><div class="prh"><span class="tag akk">Akkusativ</span> done to</div><div class="prh"><span class="tag dat">Dativ</span> gets it</div>
				${pr('I', 'one person', 'ich', 'mich', 'mir')}
				${pr('you', 'a friend', 'du', 'dich', 'dir')}
				${pr('he', 'a der-word', 'er', 'ihn', 'ihm', 'g')}
				${pr('she', 'a die-word', 'sie', 'sie', 'ihr', 'g')}
				${pr('it', 'a das-word', 'es', 'es', 'ihm', 'g')}
				${pr('we', '', 'wir', 'uns', 'uns')}
				${pr('you all', 'friends', 'ihr', 'euch', 'euch')}
				${pr('they', 'any plural', 'sie', 'sie', 'ihnen')}
				${pr('you', 'formal', 'Sie', 'Sie', 'Ihnen')}
			</div>
			<div class="pex">
				<div class="px1"><h4>Three sentences, one person</h4>
					<p>${C('nom', 'Ich')} komme. <i>I am coming.</i></p>
					<p>Anna sieht ${C('akk', 'mich')}. <i>Anna sees me.</i></p>
					<p>Anna hilft ${C('dat', 'mir')}. <i>Anna helps me.</i></p>
					<p>Anna kommt mit ${C('dat', 'mir')}. <i>Anna comes with me.</i></p></div>
				<div class="px1"><h4>Things are he, she or it</h4>
					<p><span class="gm"><b>der</b></span> Tisch → ${C('nom', 'Er')} ist neu. <i>It is new.</i></p>
					<p><span class="gf"><b>die</b></span> Lampe → Ich kaufe ${C('akk', 'sie')}. <i>I am buying it.</i></p>
					<p><span class="gn"><b>das</b></span> Buch → ${C('nom', 'Es')} ist gut. <i>It is good.</i></p></div>
				<div class="px1"><h4>Easy to remember</h4>
					<p><b>Only er changes in the Akkusativ</b> among he, she, it: er → ihn.</p>
					<p><b>wir and ihr</b> have one form for both: uns, euch.</p>
					<p><b>Dativ ends in -m or -r:</b> ihm · ihr · mir · dir.</p></div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">two pronouns</div>
			<div><b class="lead">Akkusativ first</b>Ich gebe ${C('akk', 'es')} ${C('dat', 'dir')}. · Er zeigt ${C('akk', 'sie')} ${C('dat', 'mir')}. <span class="aside">see Chart 3</span></div>
			<div><b class="lead">du, ihr or Sie</b>du: one friend · ihr: several friends · Sie: strangers, one or many</div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>Ich helfe dich.</s> <span class="ok">✓</span>Ich helfe ${C('dat', 'dir')}. <span class="aside">helfen takes the Dativ</span></div>
			<div><span class="no">✗</span><s>Der Tisch? Es ist neu.</s> <span class="ok">✓</span>${C('nom', 'Er')} ist neu. <span class="aside">the pronoun follows the article</span></div>
		</div>`,
	css: `.look .demo { font-size: 1.9cqw; gap: 2cqw }
.look .demo em { padding: 0 .4cqw }
.prbody { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.15fr 1fr; gap: 1.2cqw }
.prt { display: grid; grid-template-columns: 11.5cqw repeat(3, 1fr); grid-template-rows: auto repeat(9, 1fr); border: .4cqw solid var(--navy); min-height: 0 }
.prt > div { border-left: .12cqw solid var(--line); border-top: .12cqw solid var(--line); display: flex; align-items: center; padding: 0 .9cqw; min-width: 0; white-space: nowrap }
.prt > .prh { border-top: 0; background: var(--navy-soft); color: var(--navy); font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; padding-block: .3cqw; gap: .5cqw }
.pp { border-left: 0 !important; gap: .6cqw; align-items: baseline !important; padding-top: 0 }
.pp b { font-size: 1.1cqw; font-weight: 800 }
.pp i { font-family: var(--serif); font-size: .88cqw; color: var(--muted) }
.pp.g { background: #f4f1ea }
.pf2 { font-size: 1.6cqw }
.pf2 em { padding: 0 .45cqw }
.prt > .pp { align-items: center !important }
.pex { display: grid; grid-template-rows: 1.25fr 1fr 1fr; gap: .7cqw; min-height: 0 }
.px1 { border: .25cqw solid var(--navy); border-radius: .8cqw; padding: .4cqw 1cqw .5cqw; display: flex; flex-direction: column; justify-content: center; gap: .22cqw; min-height: 0 }
.px1 h4 { margin: 0 0 .1cqw; font-family: var(--serif); font-size: 1.3cqw; color: var(--navy); line-height: 1.1 }
.px1 p { margin: 0; font-size: 1.1cqw; font-weight: 600; white-space: nowrap }
.px1 p i { font-family: var(--serif); font-size: .96cqw; font-weight: 400; color: var(--muted); margin-left: .6cqw }
.px1:last-child p { font-weight: 500; white-space: normal; font-size: 1.02cqw; line-height: 1.3 }
.px1:last-child p b { font-weight: 800 }
`
});

/* ------------------------------------------------------------------ 22 */
const wq = (w, en, q, a) => '<div class="wq"><b>' + w + '</b><i>' + en + '</i><p>' + q + '</p><p class="an">' + a + '</p></div>';
const who4 = (c, w, en, q, a) => '<div class="w4">' + C(c, w) + '</div><div class="w4e">' + en + '</div><div class="w4q">' + q + '</div><div class="w4a">' + a + '</div>';
make({
	file: '22-question-words', pageTitle: 'Question Words Chart', n: 22, qr: 22,
	h1: 'Chart 22, the W-words', lede: 'Question words. Asking about a person needs the right case; everything else is one word to learn.',
	title: 'wer, wen, wem?',
	steps: ['What do you want to know?', 'A person? Pick the case', 'W-word first, verb second'],
	key: '<span class="v">kommt</span> the verb: always second after a W-word <b class="sp">Cases:</b> <span class="tag nom">Nominativ</span> <span class="tag akk">Akkusativ</span> <span class="tag dat">Dativ</span> <span class="tag gen">Genitiv</span>',
	body: `<div class="focus">
			<div class="look">
				<div class="demo"><span>${C('nom', 'Wer')} ${V('hilft')} ${C('dat', 'wem')}?</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: <strong>who</strong> has four forms in German, one for each case.</span><span class="c2"><b>2</b>The answer always has the same case as the question word: Wem? Dem Kind.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>Every question word starts with <strong>W</strong> and stands first. The verb comes right after it. Only "who" changes with the case.</p></div>
		</div>

		<div class="wbody">
			<div class="who">
				<div class="wh" style="grid-column:1 / -1">Asking about a person: who?</div>
				${who4('nom', 'Wer', 'who', 'Wer ' + V('kommt') + '?', C('nom', 'Der') + ' Lehrer.')}
				${who4('akk', 'Wen', 'whom', 'Wen ' + V('siehst') + ' du?', C('akk', 'Den') + ' Lehrer.')}
				${who4('dat', 'Wem', 'to whom', 'Wem ' + V('hilfst') + ' du?', C('dat', 'Dem') + ' Lehrer.')}
				${who4('gen', 'Wessen', 'whose', 'Wessen Buch?', C('gen', 'Des') + ' Lehrers.')}
				<div class="wn" style="grid-column:1 / -1"><b>A preposition comes first:</b> Mit ${C('dat', 'wem')} ${V('kommst')} du?</div>
				<div class="wn" style="grid-column:1 / -1"><b>A thing is always was</b>, in every case: Was ${V('ist')} das? · Was ${V('kaufst')} du?</div>
			</div>
			<div class="wgrid">
				${wq('Wo', 'where', 'Wo ' + V('wohnst') + ' du?', 'In Berlin.')}
				${wq('Wohin', 'where to', 'Wohin ' + V('gehst') + ' du?', 'Nach Hause.')}
				${wq('Woher', 'where from', 'Woher ' + V('kommst') + ' du?', 'Aus Spanien.')}
				${wq('Wann', 'when', 'Wann ' + V('kommt') + ' der Bus?', 'Um acht.')}
				${wq('Wie lange', 'how long', 'Wie lange ' + V('bleibst') + ' du?', 'Zwei Tage.')}
				${wq('Warum', 'why', 'Warum ' + V('lernst') + ' du Deutsch?', 'Weil ich hier lebe.')}
				${wq('Wie', 'how', 'Wie ' + V('heißt') + ' du?', 'Ich heiße Anna.')}
				${wq('Wie viel', 'how much', 'Wie viel ' + V('kostet') + ' das?', 'Zehn Euro.')}
				${wq('Wie viele', 'how many', 'Wie viele Kinder ' + V('hast') + ' du?', 'Zwei.')}
				${wq('Welcher', 'which one', 'Welchen Bus ' + V('nimmst') + ' du?', 'Den Bus 12.')}
				${wq('Was für ein', 'what kind of', 'Was für ein Auto ' + V('hast') + ' du?', 'Ein kleines.')}
				${wq('Wie oft', 'how often', 'Wie oft ' + V('kommst') + ' du?', 'Jeden Tag.')}
			</div>
		</div>

		<div class="rules">
			<div class="rl">welcher</div>
			<div><b class="lead">takes the endings of der</b>welch<u class="x">er</u> Bus · welch<u class="x">e</u> Straße · welch<u class="x">es</u> Haus</div>
			<div><b class="lead">no W-word</b>The verb goes first: ${V('Kommst')} du? Ja. / Nein. <span class="aside">see Chart 3</span></div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>Wo gehst du?</s> <span class="ok">✓</span>Wohin gehst du? <span class="aside">movement needs wohin</span></div>
			<div><span class="no">✗</span><s>Wer siehst du?</s> <span class="ok">✓</span>${C('akk', 'Wen')} siehst du?</div>
		</div>`,
	css: `.look .demo { font-size: 2.3cqw }
.look .demo em { padding: 0 .5cqw }
.look .demo .v { padding: .04cqw .5cqw .1cqw; border-radius: .35cqw }
.wbody { flex: 1; min-height: 0; display: grid; grid-template-columns: 37cqw 1fr; gap: 1.2cqw }
.who { display: grid; grid-template-columns: 9cqw 6.2cqw 1fr 1fr; grid-template-rows: auto repeat(4, 1fr) auto auto; border: .4cqw solid var(--navy); min-height: 0 }
.who > div { border-top: .12cqw solid var(--line); display: flex; align-items: center; gap: .35cqw; padding: 0 .8cqw; white-space: nowrap; min-width: 0 }
.wh { border-top: 0 !important; background: var(--navy); color: #fff; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; padding-block: .25cqw .35cqw !important }
.w4 { font-size: 1.7cqw }
.w4 em { padding: 0 .45cqw }
.w4e { font-family: var(--serif); font-style: italic; font-size: 1cqw; color: var(--muted) }
.w4q { font-size: 1.1cqw; font-weight: 700 }
.w4a { font-size: 1.06cqw; font-weight: 500 }
.wn { display: block !important; white-space: normal !important; font-size: .98cqw; padding-block: .32cqw !important; line-height: 1.5 }
.wn b { font-weight: 800 }
.who .v, .wgrid .v { padding: 0 .3cqw; border-radius: .25cqw }
.wgrid { display: grid; grid-template-columns: repeat(3, 1fr); grid-template-rows: repeat(4, 1fr); gap: .6cqw; min-height: 0 }
.wq { border: .25cqw solid var(--navy); border-radius: .7cqw; padding: .3cqw .8cqw .35cqw; display: grid; grid-template-columns: auto 1fr; align-content: center; column-gap: .6cqw; row-gap: .12cqw; min-height: 0; min-width: 0 }
.wq b { font-family: var(--serif); font-size: 1.5cqw; color: var(--navy); line-height: 1.1; white-space: nowrap }
.wq i { font-family: var(--serif); font-size: .92cqw; color: var(--muted); align-self: end; white-space: nowrap }
.wq p { margin: 0; grid-column: 1 / -1; font-size: .98cqw; font-weight: 600; white-space: nowrap }
.wq p.an { font-weight: 400; color: var(--muted) }
.wq p.an::before { content: '→ '; color: var(--terracotta-ink); font-weight: 800 }
.rules .v, .key .v { padding: 0 .3cqw; border-radius: .25cqw }
`
});

/* ------------------------------------------------------------------ 23 */
const cmp = (a, b, c, mark) => '<div class="cm"><span>' + a + '</span></div><div class="cm"><span>' + b + '</span></div><div class="cm"><span>' + c + '</span></div>';
const X2 = (t) => '<u class="x">' + t + '</u>', UM2 = (t) => '<u class="um">' + t + '</u>';
make({
	file: '23-comparison', pageTitle: 'Comparison Chart', n: 23, qr: 23,
	h1: 'Chart 23, gut, besser, am besten', lede: 'Comparing. One ending for "more", one for "most", and a short list of adjectives that go their own way.',
	title: 'gut, besser, am besten',
	steps: ['More: add -er', 'Most: am …-sten', 'Check the short list of rebels'],
	key: '<b>Key:</b> <span>schnell' + X2('er') + '</span> the ending <span class="sp">' + UM2('ä') + 'lter</span> the vowel changes <span class="sp"><b>als</b> = than · <b>wie</b> = as</span>',
	body: `<div class="focus">
			<div class="look">
				<div class="grow"><span class="g1">schnell</span><span class="g2">schnell${X2('er')}</span><span class="g3">am schnell${X2('sten')}</span></div>
				<div class="cap1"><span class="c1"><b>1</b>Look here first: three sizes, two endings. <strong>-er</strong> for more, <strong>am …-sten</strong> for most.</span><span class="c2"><b>2</b>Never "mehr schnell". German always uses the ending, even for long words.</span></div>
			</div>
			<div class="idea"><h3>The one idea</h3>
				<p>Every adjective compares the same way: add <strong>-er</strong>, then <strong>am …-sten</strong>. interessant, interessanter, am interessantesten.</p></div>
		</div>

		<div class="cbody">
			<div class="ctab">
				<div class="chd" style="border-left:0">as it is</div><div class="chd">more</div><div class="chd">most</div>
				<div class="csec" style="grid-column:1 / -1">Regular: just the endings</div>
				${cmp('klein', 'klein' + X2('er'), 'am klein' + X2('sten'))}
				${cmp('schön', 'schön' + X2('er'), 'am schön' + X2('sten'))}
				<div class="csec" style="grid-column:1 / -1">Short words with a, o, u: the vowel changes</div>
				${cmp('alt', UM2('ä') + 'lt' + X2('er'), 'am ' + UM2('ä') + 'lt' + X2('esten'))}
				${cmp('groß', 'gr' + UM2('ö') + 'ß' + X2('er'), 'am gr' + UM2('ö') + 'ß' + X2('ten'))}
				${cmp('jung', 'j' + UM2('ü') + 'ng' + X2('er'), 'am j' + UM2('ü') + 'ng' + X2('sten'))}
				<div class="csec warn" style="grid-column:1 / -1">The rebels: learn these five</div>
				${cmp('gut', '<b>besser</b>', 'am <b>besten</b>')}
				${cmp('viel', '<b>mehr</b>', 'am <b>meisten</b>')}
				${cmp('gern', '<b>lieber</b>', 'am <b>liebsten</b>')}
				${cmp('hoch', '<b>höher</b>', 'am <b>höchsten</b>')}
				${cmp('nah', '<b>näher</b>', 'am <b>nächsten</b>')}
			</div>
			<div class="cside">
				<div class="cs1"><h4>Comparing two things</h4>
					<p class="big2">Anna ist <b>älter als</b> Tom.</p><p class="en2">Anna is older than Tom. Different → -er <b>als</b></p>
					<p class="big2">Anna ist <b>so alt wie</b> Maria.</p><p class="en2">Anna is as old as Maria. The same → so … <b>wie</b></p></div>
				<div class="cs1"><h4>In front of a noun</h4>
					<p class="big2">der schnell${X2('er')}<u class="x o">e</u> Zug</p><p class="en2">the faster train: -er, then the usual adjective ending</p>
					<p class="big2">der schnell${X2('st')}<u class="x o">e</u> Zug</p><p class="en2">the fastest train: no am, just -st + ending. See Chart 5.</p></div>
				<div class="cs1 small"><h4>Good to know</h4>
					<p><b>-esten after t, d, s, ß, z:</b> am ältesten · am kürzesten · am heißesten</p>
					<p><b>teuer and dunkel lose an e:</b> teurer · dunkler</p>
					<p><b>Also with a vowel change:</b> lang · kurz · warm · kalt · stark · arm · krank · dumm · klug</p></div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">more and more</div>
			<div><b class="lead">immer + -er</b>Es wird immer kält<u class="x">er</u>. <span class="aside">it is getting colder and colder</span></div>
			<div><b class="lead">je … desto</b>Je früh<u class="x">er</u>, desto bess<u class="x">er</u>. <span class="aside">the sooner the better</span></div>
			<div class="rl warn">watch out</div>
			<div><span class="no">✗</span><s>mehr interessant</s> <span class="ok">✓</span>interessant<u class="x">er</u> <span class="no" style="margin-left:1.2cqw">✗</span><s>besser wie</s> <span class="ok">✓</span>besser <b>als</b></div>
			<div><span class="no">✗</span><s>am gutesten · mehr gut</s> <span class="ok">✓</span>am besten · besser</div>
		</div>`,
	css: `.sheet u.um { text-decoration: none; background: var(--hi); font-weight: 800; padding: 0 .08cqw }
.sheet u.x.o { background: #fff; color: var(--terracotta-ink); box-shadow: inset 0 0 0 .14cqw var(--terracotta-ink) }
.grow { display: flex; align-items: baseline; gap: 1.3cqw; white-space: nowrap; font-weight: 800; color: var(--navy) }
.grow .g1 { font-size: 1.5cqw } .grow .g2 { font-size: 2.2cqw } .grow .g3 { font-size: 3cqw }
.cbody { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1.05fr; gap: 1.2cqw }
.ctab { display: grid; grid-template-columns: 1fr 1.15fr 1.45fr; grid-template-rows: auto auto repeat(2, 1fr) auto repeat(3, 1fr) auto repeat(5, 1fr); border: .4cqw solid var(--navy); min-height: 0 }
.ctab > div { border-left: .12cqw solid var(--line); border-top: .12cqw solid var(--line); display: flex; align-items: center; padding: 0 .9cqw; white-space: nowrap; min-width: 0 }
.ctab > div:nth-child(3n+1) { }
.chd { border-top: 0 !important; background: var(--navy); color: #fff; font-size: .8cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase; padding-block: .3cqw !important }
.csec { border-left: 0 !important; background: var(--navy-soft); color: var(--navy); font-size: .8cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; padding-block: .22cqw !important }
.csec.warn { background: var(--terracotta-ink); color: #fff }
.cm { font-size: 1.3cqw; font-weight: 600 }
.cm b { font-weight: 800; color: var(--terracotta-ink) }
.cside { display: grid; grid-template-rows: 1fr 1fr auto; gap: .7cqw; min-height: 0 }
.cs1 { border: .25cqw solid var(--navy); border-radius: .8cqw; padding: .4cqw 1cqw .5cqw; display: flex; flex-direction: column; justify-content: center; gap: .1cqw; min-height: 0 }
.cs1 h4 { margin: 0 0 .15cqw; font-family: var(--serif); font-size: 1.3cqw; color: var(--navy); line-height: 1.1 }
.cs1 p { margin: 0 }
.cs1 .big2 { font-size: 1.5cqw; font-weight: 600; white-space: nowrap }
.cs1 .big2 b { font-weight: 800; color: var(--navy) }
.cs1 .en2 { font-family: var(--serif); font-size: .98cqw; color: var(--muted); margin-bottom: .25cqw }
.cs1 .en2 b { font-family: var(--sans); color: var(--ink) }
.cs1.small p { font-size: .98cqw; line-height: 1.38 }
.cs1.small b { font-weight: 800 }
`
});
