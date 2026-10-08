// Builds the tap-a-word dictionary: every German word the app puts in front of
// a learner, mapped to its English meaning.
//
// Three sources, merged in this order so the most specific wins:
//
//   1. the shared noun collection — 759 nouns, with gender and plural
//   2. the shared verb collection — 166 verbs, whose conjugation sets hand us
//      every inflected surface ("bin", "warst", "gegangen") for free
//   3. core.de.json — the hand-authored core: the function words, pronouns,
//      prepositions, adverbs and adjectives that carry running text and that no
//      other collection knows. Machine translation is poor at exactly these
//      ("sich", "doch", "zu"), so they are written by hand.
//
// The output is one committed file, assets/content/shared/dictionary/de.json,
// keyed by surface form so the runtime lookup is a single map hit with no
// stemming to guess at.
//
//   node tool/build-dictionary.mjs            # build and write
//   node tool/build-dictionary.mjs --report   # what the content uses that we
//                                             # still cannot gloss, by frequency
//
// The report is the authoring queue: it reads the real content, so the core
// wordlist grows to fit what was actually written rather than to fit a guess.

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';

const ROOT = new URL('../', import.meta.url);
const read = (path) => JSON.parse(readFileSync(new URL(path, ROOT), 'utf8'));
const CONTENT = 'assets/content/';
const OUT = `${CONTENT}shared/dictionary/de.json`;
const CORE = `${CONTENT}shared/dictionary/core.de.json`;

// ---------------------------------------------------------------- extraction

// The course bundle holds German and English side by side. These are the keys
// whose strings are German; every other key is skipped outright, so an English
// translation or a help-memory explanation can never reach the word list.
const GERMAN_KEYS = new Set([
	'de',
	'sentence',
	'passage',
	'passageTitle',
	'text',
	'form',
	'noun',
	'verb',
	'tiles',
	'inlineTemplate'
]);

// Two things share a key name with German content and are English:
//
//   help.tips[].text — a HelpTip explains the grammar in English, and a
//                      SpokenLine holds German, both under `text`
//   answer/accepted  — a grammar quiz answers in metalanguage ("Dat", "nominal")
//
// A key allowlist alone cannot tell them apart, so these subtrees are cut off
// before the walk reaches them. The German inside a help tip is in `de`, which
// the allowlist still picks up through its examples.
//
// `subjects[].display` is left out for the same reason: a grammar quiz labels
// its rows in English ("I (after the verb)"), and the German subjects are nouns
// the shared collection already knows.
const SKIP_SUBTREES = new Set([
	'help',
	'exam',
	'mistakes',
	'studyLinks',
	'answer',
	'accepted',
	'acceptedAnswers',
	'options'
]);

// Stories and the mini-games mix the learner's English with the German they are
// learning under the same `text` key, so for those only `de` is trusted.
const DE_ONLY = new Set(['de']);

/** Every German string in a parsed JSON tree, under the given key allowlist. */
function germanStrings(node, allow, key = null, out = []) {
	if (SKIP_SUBTREES.has(key)) return out;
	if (typeof node === 'string') {
		if (allow.has(key)) out.push(node);
	} else if (Array.isArray(node)) {
		// An array inherits its parent key: `tiles: [...]` is German throughout.
		for (const item of node) germanStrings(item, allow, key, out);
	} else if (node && typeof node === 'object') {
		for (const [k, v] of Object.entries(node)) germanStrings(v, allow, k, out);
	}
	return out;
}

function contentFiles() {
	const files = [];
	const bundles = `${CONTENT}courses/`;
	for (const name of readdirSync(new URL(bundles, ROOT))) {
		if (name.endsWith('.json')) files.push([bundles + name, GERMAN_KEYS]);
	}
	for (const dir of [`${CONTENT}stories/`, `${CONTENT}tasks/`]) {
		if (!existsSync(new URL(dir, ROOT))) continue;
		for (const name of readdirSync(new URL(dir, ROOT))) {
			if (name.endsWith('.json')) files.push([dir + name, DE_ONLY]);
		}
	}
	return files;
}

/** Surface form -> how many times the content uses it. */
function surfaceFrequency() {
	const freq = new Map();
	for (const [path, allow] of contentFiles()) {
		for (const text of germanStrings(read(path), allow)) {
			// A cloze sentence can carry an English cue in brackets — "Ich wohne
			// ____ meinen Eltern. (at the home of)" — which is a hint for the
			// learner, not German. Keep the umlauts and the eszett; drop the
			// bracketed cues, the cloze markers and the digits.
			for (const [word] of text.replace(/\([^)]*\)/g, ' ').matchAll(/\p{L}[\p{L}ß]*/gu)) {
				freq.set(word, (freq.get(word) ?? 0) + 1);
			}
		}
	}
	return freq;
}

// ------------------------------------------------------------------- merging

/**
 * One dictionary entry. `de` is the dictionary form the panel shows, `en` the
 * meaning, `pos` the part of speech it is labelled with. Nouns carry gender so
 * the panel can colour them, and `slug` tells the panel when a full Word
 * Library page exists to link to.
 */
const entryFor = ({ de, en, pos, gender, plural, slug }) => {
	const entry = { de, en, pos };
	if (gender) entry.gender = gender;
	if (plural) entry.plural = plural;
	if (slug) entry.slug = slug;
	return entry;
};

// Ported from src/lib/domain/words.ts — a build script cannot import the
// TypeScript module, so these three are duplicated and dictionary.test.ts
// checks the generated file against the real implementations.
const umlaut = (stem) => {
	const map = { a: 'ä', o: 'ö', u: 'ü', A: 'Ä', O: 'Ö', U: 'Ü' };
	let at = -1;
	for (let i = 0; i < stem.length; i++) if (map[stem[i]]) at = i;
	if (at < 0) return stem;
	if (stem[at].toLowerCase() === 'u' && stem[at - 1]?.toLowerCase() === 'a') at -= 1;
	return stem.slice(0, at) + map[stem[at]] + stem.slice(at + 1);
};

const pluralForm = (noun, notation) => {
	if (!notation || notation === '—') return null;
	const m = notation.match(/^(¨)?-(.*)$/);
	if (!m) return notation;
	return (m[1] ? umlaut(noun) : noun) + m[2];
};

const dativePlural = (plural) => (/[ns]$/.test(plural) ? plural : `${plural}n`);

/**
 * The regular (weak) conjugation of an infinitive: present, simple past and
 * past participle. A German text says "prüft", "teilte", "geplant" far more
 * often than "prüfen", and a weak verb is entirely predictable, so the core
 * wordlist names the infinitive and these fall out of it.
 *
 * A stem ending in d, t or a consonant cluster takes a linking -e- ("arbeitet",
 * "redete"); a stem already ending in -s or -ß keeps one -t. An irregular verb
 * is listed in its entry's own `forms`, which is claimed before these, and the
 * 166-verb collection covers the common strong verbs in full anyway.
 */
function weakForms(infinitive) {
	const m = infinitive.match(/^(.*?)(e?n)$/);
	if (!m) return [];
	const stem = m[1];
	const link = /[dt]$|[bcdfghjklmnpqrstvwxzß][mn]$/.test(stem) ? 'e' : '';
	const t = /[sßxz]$/.test(stem) ? 't' : `${link}t`;
	// The ge- of the participle goes after a separable prefix, not before it:
	// "aufmachen" gives "aufgemacht", never "geaufmacht". A prefix that is not
	// separable (be-, ent-, er-, ver-, zer-, miss-) takes no ge- at all.
	const separable = stem.match(
		/^(ab|an|auf|aus|bei|ein|her|hin|los|mit|nach|vor|weg|zu|zurück|zusammen)(.+)/
	);
	const unstressed = /^(be|emp|ent|er|ge|miss|ver|zer)/.test(stem);
	const participle = separable
		? `${separable[1]}ge${separable[2]}${t}`
		: unstressed
			? `${stem}${t}`
			: `ge${stem}${t}`;
	return [
		`${stem}e`,
		`${stem}${link}st`,
		`${stem}${t}`,
		`${stem}en`,
		`${stem}${link}te`,
		`${stem}${link}test`,
		`${stem}${link}ten`,
		`${stem}${link}tet`,
		participle
	];
}

const wordSlug = (word) =>
	word
		.toLowerCase()
		.replace(/ä/g, 'ae')
		.replace(/ö/g, 'oe')
		.replace(/ü/g, 'ue')
		.replace(/ß/g, 'ss')
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/^-|-$/g, '');

function build() {
	const entries = [];
	const surfaces = new Map();

	// Collected first, claimed second. Every entry's own dictionary form is
	// claimed before any inflection is, because an inflection of one word is
	// very often the dictionary form of another: "werden" is both the infinitive
	// of werden and part of "sein"'s passive set, and a learner who taps it
	// wants the verb, not whichever entry happened to be generated first. Within
	// each pass it is still first-come, so a noun entry beats a core-wordlist
	// guess at the same spelling.
	const inflections = [];
	const add = (entry, forms) => {
		const index = entries.push(entry) - 1;
		for (const form of forms ?? []) inflections.push([form, index]);
		return index;
	};
	const claim = (surface, index) => {
		if (!surface || surfaces.has(surface)) return;
		surfaces.set(surface, index);
	};

	// 1. Nouns, with the forms their own plural notation spells out: the
	//    collection already says "¨-e", so "Bücher", "Häuser", "Städte" and the
	//    dative plural "Büchern" cost nothing but the same arithmetic the Word
	//    Library does, and a text says "Jahren" far more often than "Jahr".
	//    src/lib/domain/noun-surface-forms.ts handles the rest at runtime.
	for (const noun of read(`${CONTENT}shared/nouns/de.json`).nouns) {
		const plural = pluralForm(noun.noun, noun.plural);
		add(
			entryFor({
				de: noun.noun,
				en: noun.english,
				pos: 'noun',
				gender: noun.gender,
				plural: noun.plural,
				slug: wordSlug(noun.noun)
			}),
			plural ? [plural, dativePlural(plural)] : []
		);
	}

	// 2. Verbs, plus every conjugated form their sets spell out. A form can be
	//    two words ("bin gegangen"); each word points back at the verb.
	for (const verb of read(`${CONTENT}shared/verbs/de.json`).verbs) {
		const forms = [];
		for (const set of verb.sets ?? []) {
			for (const { form } of set.forms ?? []) {
				for (const word of String(form).split(/[\s/]+/)) if (word) forms.push(word);
			}
		}
		add(
			entryFor({ de: verb.verb, en: verb.english, pos: 'verb', slug: wordSlug(verb.verb) }),
			forms
		);
	}

	// 3. The hand-authored core, with the one inflection that is mechanical
	//    enough to generate: a German adjective takes -e/-en/-em/-er/-es, and
	//    writing five forms out by hand for two hundred adjectives would be five
	//    hundred chances to mistype. Anything irregular — "hoch" -> "hohe",
	//    "teuer" -> "teure" — is listed in the entry's own `forms`, which is
	//    claimed first either way.
	const core = existsSync(new URL(CORE, ROOT)) ? read(CORE).entries : [];
	for (const item of core) {
		const forms = [...(item.forms ?? [])];
		if (item.pos === 'adjective') {
			const stem = item.de.replace(/e$/, '');
			for (const ending of ['e', 'en', 'em', 'er', 'es']) forms.push(stem + ending);
		}
		if (item.pos === 'verb') forms.push(...weakForms(item.de));
		add(entryFor(item), forms);
	}

	for (const [index, entry] of entries.entries()) claim(entry.de, index);
	for (const [form, index] of inflections) claim(form, index);

	return { entries, surfaces, coreCount: core.length };
}

// ------------------------------------------------------------------ commands

const { entries, surfaces, coreCount } = build();

// A capitalised word at the start of a sentence is the same word as lowercase,
// and the runtime falls back to a case-folded lookup. The report must fold the
// same way or it would queue "Und" and "und" as two separate jobs.
const resolved = (word) =>
	surfaces.has(word) ||
	surfaces.has(word.toLowerCase()) ||
	surfaces.has(word[0].toUpperCase() + word.slice(1));

if (process.argv.includes('--report')) {
	const freq = surfaceFrequency();
	const missing = [...freq.entries()].filter(([w]) => !resolved(w)).sort((a, b) => b[1] - a[1]);
	const tokens = [...freq.values()].reduce((a, b) => a + b, 0);
	const covered = [...freq.entries()]
		.filter(([w]) => resolved(w))
		.reduce((sum, [, count]) => sum + count, 0);

	console.log(`entries ${entries.length} (core ${coreCount})  surfaces ${surfaces.size}`);
	console.log(
		`content: ${freq.size} distinct surfaces, ${tokens} tokens — ` +
			`${((covered / tokens) * 100).toFixed(1)}% of running text covered, ` +
			`${missing.length} surfaces missing`
	);
	const limit = Number(process.argv[process.argv.indexOf('--report') + 1]) || 400;
	console.log(
		missing
			.slice(0, limit)
			.map(([word, count]) => `${word} ${count}`)
			.join('\n')
	);
} else {
	writeFileSync(
		new URL(OUT, ROOT),
		JSON.stringify({ entries, surfaces: Object.fromEntries(surfaces) }) + '\n'
	);
	const bytes = readFileSync(new URL(OUT, ROOT)).length;
	console.log(
		`${OUT}: ${entries.length} entries, ${surfaces.size} surfaces, ${(bytes / 1024).toFixed(0)} KB`
	);
}
