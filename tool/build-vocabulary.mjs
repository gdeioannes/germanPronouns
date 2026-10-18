#!/usr/bin/env node
// Builds one vocabulary deck per sub-level from the words its quizzes already
// carry — every Help Memory `vocab` entry and every grid subject that has an
// English meaning — and reports the nouns still missing an article.
//
//   node tool/build-vocabulary.mjs de_cert_a1 A1.1          # report only
//   node tool/build-vocabulary.mjs de_cert_a1 A1.1 --write  # also insert/replace the deck in the bundle
//
// A card is `{ de, en, kind, article?, plural?, sourceQuizId }`. `kind` is
// 'noun' when the word carries an article or a noun gender, or is capitalised
// (German nouns are); everything else is 'word'. Missing articles and plurals
// are filled from the shared noun library where the noun is known.

import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, join } from 'node:path';

const args = process.argv.slice(2);
const write = args.includes('--write');
const [courseId, level] = args.filter((a) => !a.startsWith('--'));
if (!courseId || !level) {
	console.error('usage: node tool/build-vocabulary.mjs <courseId> <level> [--write]');
	process.exit(1);
}

const root = resolve(import.meta.dirname, '..');
const bundlePath = join(root, 'assets/content/courses', `${courseId}.json`);
const bundle = JSON.parse(readFileSync(bundlePath, 'utf8'));
const shared = JSON.parse(readFileSync(join(root, 'assets/content/shared/nouns/de.json'), 'utf8'));

const ARTICLE = { m: 'der', f: 'die', n: 'das' };
const byNoun = new Map(shared.nouns.map((n) => [n.noun, n]));

/** Pronouns and forms of address that are capitalised but are not nouns. */
const NOT_NOUNS = new Set(['Sie', 'Ihr', 'Ihnen', 'Ihre', 'Ihren', 'Ihrem', 'Ihrer']);

/**
 * Hand decisions for the few words the rules cannot place: nouns whose
 * article no source records, proper names glossed in lower case ("to
 * Spain"), and labels that are not vocabulary at all.
 */
const OVERRIDES = {
	Zuhause: { article: 'das' },
	Neugier: { article: 'die' },
	Forderung: { article: 'die', plural: '-en' },
	Überleitung: { article: 'die', plural: '-en' },
	Relativsatz: { article: 'der', plural: '¨-e' },
	Mittelkonstruktion: { article: 'die', plural: '-en' },
	Handlungseinsatz: { article: 'der', plural: '¨-e' },
	Erzählperspektive: { article: 'die', plural: '-n' },
	Gesamturteil: { article: 'das', plural: '-e' },
	Empfehlung: { article: 'die', plural: '-en' },
	Praktikum: { article: 'das', plural: 'Praktika' },
	Wert: { article: 'der', plural: '-e' },
	Ausnahme: { article: 'die', plural: '-n' },
	Kalorien: { article: 'die', plural: '(Pl.)' },
	Spanien: { kind: 'name' },
	Berlin: { kind: 'name' },
	Anna: { kind: 'name' },
	Folgendes: { kind: 'word' },
	Liebe: { kind: 'word' },
	Lieber: { kind: 'word' },
	'Klempner-Witz': { drop: true },
	einen: { drop: true },
	Antecedent: { drop: true },
	'strukturelle Mehrdeutigkeit': { drop: true },
	'Werkstatt-Witz': { drop: true },
	// English descriptions used as grid row labels (C2.2 philosophy, focus,
	// implicature): a label, not a German word to learn.
	'categorical imperative': { drop: true },
	'means and end': { drop: true },
	'instrumental reason': { drop: true },
	'Weber’s two ethics': { drop: true },
	'contrastive fronting': { drop: true },
	'precisely because': { drop: true },
	'statement as request': { drop: true },
	'veiled criticism': { drop: true },
	'saying the opposite': { drop: true },
	'playing danger down': { drop: true },
	'unstated reference': { drop: true },
	'host at midnight': { drop: true },
	'loaded question': { drop: true },
	'rhetorical question': { drop: true },
	'saying too little': { drop: true },
	'reference-letter code': { drop: true }
};

/**
 * Cards a bad split of a grammar entry produces ("wo? – in / bei / an" →
 * "an = where?", "die da" → "da = that one"), keyed `de|en` because the same
 * word is a fine card elsewhere.
 */
const DROP_PAIRS = new Set([
	'an|where?',
	'wo?|where? in',
	'da|that one',
	'hier|this one',
	'die da|that one',
	'Montag|Monday to Friday',
	// "mit dessen / deren Hilfe" is one expression, not two alternatives: the
	// slash splitter cuts it in half and each half means nothing on its own.
	'mit dessen|with whose help',
	'deren Hilfe|with whose help'
]);

const levelQuizzes = bundle.quizzes.filter((q) => q.level === level && q.type !== 'vocabulary');
const cards = new Map();

/** An English gloss that opens with a preposition the German label may not carry. */
const LEADING_EN_PREP = /^(in|on|at|for|after|before|from|until|till|by|during|within)\s/;
/** A German label that brings its own preposition, so the gloss above is honest. */
const LEADING_DE_PREP =
	/^(an|auf|aus|bei|beim|bis|durch|für|gegen|hinter|in|im|ins|mit|nach|neben|ohne|seit|über|um|unter|von|vom|vor|während|wegen|zu|zum|zur|am|ab)\s/i;

/**
 * Grids that prompt in English and hold the German in the category value. Their
 * subject labels are English, so none of them is a word to learn. A grid counts
 * as English-prompted when half or more of its labelled rows look English:
 * the label equals its own gloss, the gloss begins with it, or it is an English
 * infinitive.
 */
const englishPrompted = new Set(
	levelQuizzes
		.filter((q) => {
			const rows = (q.subjects ?? []).filter((s) => s.english);
			if (rows.length < 4) return false;
			const english = rows.filter((s) => {
				const d = (s.display ?? '').trim();
				const e = s.english.trim();
				return d === e || e.startsWith(d) || /^to\s+\w/.test(d);
			}).length;
			return english * 2 >= rows.length;
		})
		.map((q) => q.id)
);

/**
 * A vocab entry may bundle two words ("der Großvater / Opa",
 * "der / die Freund / Freundin"); each becomes its own card.
 */
function expand(raw) {
	const de = (raw.de ?? '').trim();
	if (!de.includes(' / ') || de.includes('(')) return [raw];
	const m = /^(?:(der|die|das)(?: \/ (der|die|das))? )?(.+)$/.exec(de);
	if (!m) return [raw];
	const words = m[3].split(' / ').map((w) => w.trim());
	// The article may sit inline ("der / die Freund / Freundin") or in its own
	// field written the same way.
	const fieldArticles = (raw.article ?? '').split(' / ').map((x) => x.trim()).filter(Boolean);
	const articles = fieldArticles.length ? fieldArticles : [m[1], m[2]];
	// Only pair meanings with words when they line up one to one; otherwise
	// every card keeps the whole gloss. A slash list inside brackets ("one
	// (Nom / Akk / Dat)") pairs its parts and keeps the words around them.
	const gloss = (raw.en ?? '').trim();
	const bracket = /^([^()]*)\(([^()]*)\)([^()]*)$/.exec(gloss);
	const inner = bracket ? bracket[2].split(' / ').map((e) => e.trim()) : [];
	const ens =
		inner.length === words.length
			? inner.map((e) => `${bracket[1]}(${e})${bracket[3]}`.trim())
			: gloss.split(/ \/ |; /).map((e) => e.trim());
	const balanced = ens.every((e) => (e.match(/\(/g) ?? []).length === (e.match(/\)/g) ?? []).length);
	const paired = ens.length === words.length && balanced;
	return words.map((w, i) => ({
		...raw,
		de: w,
		article: articles[i] ?? articles[0],
		en: paired ? ens[i] : gloss,
		plural: i === 0 ? raw.plural : undefined
	}));
}

function add(raw, sourceQuizId) {
	let de = (raw.de ?? '').trim();
	const en = (raw.en ?? '').trim();
	if (!de || !en) return;
	// Half of a parenthesis means an entry was cut in the wrong place.
	if ((de.match(/\(/g) ?? []).length !== (de.match(/\)/g) ?? []).length) return;
	// A frame with a slot ("hätte … gesagt", "um … zu"), a transformation
	// ("wegen → weil") or a slash list ("er/sie/es") is grammar, drilled in its
	// own quiz, and cannot be typed as one answer: not a flashcard.
	if (/[…→]/.test(de) || /[…→]/.test(en) || /^[/,]/.test(de)) return;
	// A bracketed note ("fahren (fährt)", "verzichten auf (+ Akk)") is shown
	// on the back of the card, never demanded in the answer.
	const notes = [...de.matchAll(/\s*\(([^)]*)\)/g)].map((m) => m[1].trim()).filter(Boolean);
	de = de.replace(/\s*\([^)]*\)/g, '').trim();
	// "essen – gegessen", "alt – älter": ask for the first form, show the rest.
	if (de.includes(' – ')) {
		const [first, ...rest] = de.split(' – ').map((p) => p.trim());
		de = first;
		notes.unshift(rest.join(' – '));
	}
	// Stress marks ("umfáhren") are a reading aid, not something to type.
	// A German stress mark sits on an interior syllable ("umfáhren"); an
	// acute on the final letter belongs to the word itself (Café, Varietié)
	// and must survive.
	de = de
		.normalize('NFD')
		.replace(/́(?=[^])/g, '')
		.normalize('NFC');
	// A bare number or year is not vocabulary.
	if (/^[\d\s.,:]+$/.test(de)) return;
	if (!de || de.includes('/')) return;
	// A letter of the alphabet ("J", "ß", "ä") is pronunciation, drilled in the
	// alphabet quiz, not a word to learn.
	if ([...de].length === 1) return;
	// "der/die Angestellte": one noun, two genders — one card for each.
	const both = /^(der|die|das)\s*\/\s*(der|die|das)$/.exec(raw.article ?? '');
	if (both) {
		for (const a of [both[1], both[2]]) add({ ...raw, de, article: a }, sourceQuizId);
		return;
	}
	// A whole sentence (a proverb, a model line) belongs to its own quiz.
	if (de.split(/\s+/).length > 6) return;
	// "verärgert, ungehalten" or "die Stelle, die Position": synonyms. The
	// card asks for the first and accepts any of them.
	let also;
	const parts = de.split(/,\s*/);
	if (
		parts.length > 1 &&
		parts.every((p) => p && p.length >= 4 && p.split(/\s+/).length <= 3)
	) {
		de = parts[0];
		const rest = parts.slice(1);
		const restArticle = rest.map((p) => /^(der|die|das) /.exec(p)?.[1]);
		also = rest;
		// Keep the article of the first synonym for the card.
		if (!raw.article && restArticle[0] && !/^(der|die|das) /.test(de)) de = `${restArticle[0]} ${de}`;
	}
	const note = notes.join('; ') || undefined;
	// A vocab entry written as "der Tisch" or "die hohen Kosten" carries its
	// article inline; "das ist nicht mein Bier" or "der hier" starts with a
	// pronoun, not an article.
	const inline = /^(der|die|das) ((?:\S+ )?[A-ZÄÖÜ]\S*)$/.exec(de);
	const word = inline ? inline[2] : de;
	let article = raw.article ?? (inline ? inline[1] : undefined);
	let plural = raw.plural;
	const override = OVERRIDES[word];
	if (override?.drop) return;
	if (DROP_PAIRS.has(`${word}|${en}`)) return;
	if (override?.article) article = override.article;
	if (override?.plural) plural = override.plural;
	const capitalised = /^[A-ZÄÖÜ]/.test(word) && !NOT_NOUNS.has(word);
	// A phrase ("Wie spät ist es?", "Nimm!", "Sehr geehrte") or a prefix
	// ("Lieblings-") is learnt as it stands: never a noun, never a name.
	const phrase = /[\s!?.,…:;–]/.test(word) || /-$/.test(word);
	// Names — countries, cities, people, companies — are
	// capitalised but take no article, so none is demanded. A capitalised
	// single word glossed with a capitalised English word is a proper noun.
	const isName =
		override?.kind === 'name' ||
		(!override &&
			!article &&
			!raw.gender &&
			capitalised &&
			!phrase &&
			(/^[A-Z]/.test(en) || /\(Firma\)/.test(word)));
	const isNoun =
		!isName &&
		override?.kind !== 'word' &&
		(!!article || !!raw.gender || (capitalised && !phrase));
	if (isNoun) {
		if (!article && raw.gender) article = ARTICLE[raw.gender];
		const known = byNoun.get(word);
		if (known) {
			if (!article) article = ARTICLE[known.gender];
			if (!plural && known.plural) plural = known.plural;
		}
	}
	const kind = isNoun ? 'noun' : isName ? 'name' : 'word';
	const key = isNoun ? `${article ?? '?'} ${word}` : word.toLowerCase();
	if (cards.has(key)) return;
	const card = { de: word, en, kind, sourceQuizId };
	if (article) card.article = article;
	if (plural) card.plural = plural;
	if (note) card.note = note;
	if (also?.length) card.also = also;
	cards.set(key, card);
}

for (const q of levelQuizzes) {
	for (const v of q.help?.vocab ?? []) for (const one of expand(v)) add(one, q.id);
	for (const s of q.subjects ?? []) {
		if (!s.english) continue;
		// Authored-sentence quizzes label their rows with an English sentence
		// or a task ("Präsens: muss gelöst werden"); only a word-sized German
		// label with its own meaning is vocabulary.
		const display = (s.display ?? '').trim();
		const english = s.english.trim();
		const words = display.split(/\s+/).length;
		if (display === english) continue;
		if (words > 3 || /[.?!:→=(,]/.test(display)) continue;
		// A row label glossed with an example sentence ("Gegenwart" = "He acts
		// as if…") or a derivation ("Wert" = "value → valuable") is a grammar
		// label, not a word to learn.
		if (/[.?!]$/.test(english) || english.split(/\s+/).length > 5 || english.includes('→')) continue;
		// A destination row ("Spanien" = "to Spain", "meine Oma" = "to my
		// grandma's") glosses the preposition the German label leaves out.
		if (/^to /.test(english) && /^[A-ZÄÖÜ]/.test(display.split(/\s+/).at(-1))) continue;
		// The same trap without "to": a time row is labelled with the bare noun
		// ("der Abend", "8 Uhr", "das Essen") while the gloss carries the
		// preposition the exercise is about ("in the evening", "after the
		// meal"). As a flashcard that teaches a meaning the word does not have.
		// A German label that brings its own preposition ("zu Hause" = "at
		// home") is a real phrase and stays.
		if (
			LEADING_EN_PREP.test(english) &&
			!LEADING_DE_PREP.test(display) &&
			/^[A-ZÄÖÜ]/.test(display.split(/\s+/).at(-1))
		)
			continue;
		// Some grids prompt in English and put the German in the category value
		// ("to deny outright", "home"). Those displays are not German words.
		if (/^to\s+\w/.test(display) || english.startsWith(display)) continue;
		if (englishPrompted.has(q.id)) continue;
		add({ de: display, en: s.english, gender: s.gender }, q.id);
	}
}

const deck = [...cards.values()];
const nouns = deck.filter((c) => c.kind === 'noun');
const missingArticle = nouns.filter((c) => !c.article);
const missingPlural = nouns.filter((c) => c.article && !c.plural);

const names = deck.filter((c) => c.kind === "name");
if (process.env.SHOW_NAMES) console.log("NAMES:", names.map((c) => `${c.de}=${c.en}`).join(" | "));
console.log(`${level}: ${deck.length} cards — ${nouns.length} nouns, ${names.length} names, ${deck.length - nouns.length - names.length} other words`);
console.log(`nouns missing an article: ${missingArticle.length}`);
for (const c of missingArticle) console.log(`  ? ${c.de} = ${c.en}   (${c.sourceQuizId})`);
console.log(`nouns missing a plural: ${missingPlural.length}`);
for (const c of missingPlural) console.log(`  ${c.article} ${c.de} = ${c.en}   (${c.sourceQuizId})`);

if (write) {
	const slug = level.toLowerCase().replace('.', '_');
	const id = `quest_${slug}_wortschatz`;
	const existing = bundle.quizzes.find((q) => q.id === id);
	// Pictures are attached to a card after the deck is built (see
	// tool/gen-images.mjs), so a rebuild must carry them over or every
	// level's "words in pictures" page comes back empty.
	const art = new Map(
		(existing?.cards ?? [])
			.filter((c) => c.image)
			.map((c) => [c.de, { image: c.image, imageHint: c.imageHint }])
	);
	for (const card of deck) {
		const found = art.get(card.de);
		if (!found) continue;
		card.image = found.image;
		if (found.imageHint !== undefined) card.imageHint = found.imageHint;
	}
	const quiz = {
		id,
		type: 'vocabulary',
		// The nav already shows the level, and a level prefix in an exercise
		// title is against the house rule the content test enforces. An
		// existing deck keeps whatever title it was given.
		title: 'Wortschatz',
		storageKeyPrefix: `${id}_`,
		level,
		cards: deck,
		...(existing?.help ? { help: existing.help } : {}),
		...(existing?.covers ? { covers: existing.covers } : {})
	};
	if (existing) Object.assign(existing, quiz);
	else {
		const last = bundle.quizzes.map((q) => q.level).lastIndexOf(level);
		bundle.quizzes.splice(last + 1, 0, quiz);
	}
	writeFileSync(bundlePath, JSON.stringify(bundle, null, 2) + '\n');
	console.log(`${existing ? 'replaced' : 'inserted'} ${id} in ${bundlePath}`);
}
