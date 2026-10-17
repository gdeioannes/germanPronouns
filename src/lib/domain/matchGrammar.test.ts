// The sentence checker on the structures the B and C chats need: verb-final
// subordinate clauses, the Perfekt / modal bracket, an opening weil-clause,
// two-way prepositions by turn, genitive prepositions, dative verbs, and
// word-level fixes with a note (collocations, register).
import { describe, expect, it } from 'vitest';
import { gradeSentence, QUESTION, STOP, type Lexicon } from './matchChat';

const lex: Lexicon = {
	nouns: {
		Hund: 'm', Hause: 'n', Regens: 'm', Katze: 'f', Limonade: 'f', Eis: 'n', Stuhl: 'm', Zimmer: 'pl', Paket: 'n', Herr: 'm', Mann: 'm', Mitbewohner: 'm', Hut: 'm', Unterschrift: 'f', Schokolade: 'f', Platten: 'pl', Haus: 'n', Tisch: 'm', Regen: 'm', Party: 'f', Nachbarn: 'm', Auto: 'n',
		Entscheidung: 'f', Kuchen: 'm', Buch: 'n', Freundin: 'f', Bahnhof: 'm', Wetters: 'n'
	},
	names: ['Anna', 'Wolf'],
	verbs: ['nehme', 'will', 'kam', 'kostet', 'öffnete', 'sah', 'fehlt', 'sind', 'gibt', 'kommst', 'kommen', 'werden', 'schenke', 'suche', 'geputzt', 'bin', 'ist', 'habe', 'hat', 'komme', 'kommt', 'muss', 'kann', 'gehe', 'glaube', 'weiß', 'wäre', 'würde', 'gebe', 'helfe', 'treffe', 'mache', 'lege', 'liegt', 'stelle'],
	nonfinite: ['essen', 'gefahren', 'gefeiert', 'getanzt', 'geputzt', 'werden', 'klettern', 'fliegen', 'gegessen', 'gekommen', 'arbeiten', 'gemacht', 'kommen', 'gewesen', 'gehen'],
	imperatives: ['komm', 'gib'],
	accVerbs: ['will', 'gibt', 'öffnete', 'suche', 'habe', 'hat', 'mache', 'treffe', 'lege', 'stelle', 'gib'],
	datVerbs: ['gebe', 'helfe', 'schenke'],
	adjectives: ['krank', 'schön', 'rot', 'groß', 'schlecht', 'klein', 'ruhig', 'ordentlich']
};

const grade = (sentence: string, opts: { wrong?: Record<string, string | { to: string; note?: string }>; prepCase?: Record<string, 'acc' | 'dat'> } = {}) => {
	const tokens = sentence
		.replace(/[,!]/g, '')
		.split(/\s+/)
		.flatMap((w) => (w.endsWith('.') ? [w.slice(0, -1), STOP] : w.endsWith('?') ? [w.slice(0, -1), QUESTION] : [w]))
		.filter(Boolean);
	while (tokens.at(-1) === STOP) tokens.pop();
	return gradeSentence(tokens, lex, opts.wrong ?? {}, 'Sam', opts.prepCase ?? {});
};

describe('subordinate clauses', () => {
	it.each([
		['Ich komme nicht weil ich krank bin.', 100],
		['Ich komme nicht weil ich bin krank.', 70],
		['Ich glaube dass Anna kommt.', 100],
		['Ich glaube dass Anna kommt nicht.', 70],
		['Weil ich krank bin komme ich nicht.', 100],
		['Weil ich krank bin ich komme nicht.', 70],
		['Weil ich krank bin.', 100],
		['Ich weiß dass ich arbeiten muss.', 100],
		['Ich weiß dass ich muss arbeiten.', 70]
	])('%s → %i', (s, score) => expect(grade(s).score).toBe(score));

	it('punctuates the commas', () => {
		expect(grade('Weil ich krank bin komme ich nicht.').text).toBe('Weil ich krank bin, komme ich nicht.');
		expect(grade('Ich komme nicht weil ich krank bin.').text).toBe('Ich komme nicht, weil ich krank bin.');
	});

	it('während before an article is a preposition with the genitive', () => {
		expect(grade('Während des Regens gehe ich nicht.').score).toBe(100);
		expect(grade('Während dem Regen gehe ich nicht.').score).toBe(85);
	});
});

describe('the verb bracket', () => {
	it.each([
		['Ich habe den Kuchen gegessen.', 100],
		['Ich habe gegessen den Kuchen.', 70],
		['Ich bin gestern gekommen.', 100],
		['Ich muss heute arbeiten.', 100],
		['Ich muss arbeiten heute.', 70],
		['Gestern habe ich den Kuchen gegessen.', 100]
	])('%s → %i', (s, score) => expect(grade(s).score).toBe(score));
});

describe('cases', () => {
	it('accusative with a pronoun subject', () => {
		expect(grade('Ich habe einen Hund.').score).toBe(100);
		expect(grade('Ich habe ein Hund.').score).toBe(85);
	});
	it('a noun subject leaves the case open, so OVS is not "corrected"', () => {
		expect(grade('Den Kuchen hat Anna.').score).toBe(100);
	});
	it('dative verbs accept the dative', () => {
		expect(grade('Ich helfe der Freundin.').score).toBe(100);
		expect(grade('Ich gebe dem Hund den Kuchen.').score).toBe(100);
	});
	it('two-way prepositions follow the turn: Wohin is accusative', () => {
		expect(grade('Ich lege das Buch auf den Tisch.', { prepCase: { auf: 'acc' } }).score).toBe(100);
		expect(grade('Ich lege das Buch auf dem Tisch.', { prepCase: { auf: 'acc' } }).score).toBe(85);
		expect(grade('Das Buch liegt auf dem Tisch.').score).toBe(100);
	});
	it('wegen takes the genitive', () => {
		expect(grade('Ich komme nicht wegen des Regens.').score).toBe(100);
	});
	it('a genitive attribute after a noun is fine', () => {
		expect(grade('Das ist das Auto des Nachbarn.').score).toBe(100);
	});
	it('adjective endings by case', () => {
		expect(grade('Ich habe einen großen Hund.').score).toBe(100);
		expect(grade('Ich habe einen große Hund.').score).toBe(85);
		expect(grade('Mit dem roten Auto komme ich.').score).toBe(100);
	});
});

describe('imperatives and word fixes', () => {
	it('an imperative may open the sentence', () => {
		expect(grade('Komm.').score).toBe(100);
		expect(grade('Gib den Kuchen.').score).toBe(100);
	});
	it('a wrong word costs 15 and carries its note', () => {
		const g = grade('Ich mache eine Entscheidung.', {
			wrong: { mache: { to: 'treffe', note: 'You "treffen" a decision.' } }
		});
		expect(g.score).toBe(85);
		expect(g.corrections[0]).toMatchObject({ from: 'mache', to: 'treffe', kind: 'word', note: 'You "treffen" a decision.' });
		expect(g.fixed).toBe('Ich treffe eine Entscheidung.');
	});
});

describe('the second round: what the writers ran into', () => {
	it.each([
		// questions
		['Kommst du?', 100],
		['Wann kommst du?', 100],
		['Kommst du morgen?', 100],
		// a second verb sharing the subject
		['Ich öffnete den Hut und sah nichts.', 100],
		['Ich habe gefeiert und getanzt.', 100],
		['Ich bin zum Bahnhof gekommen und nach Hause gefahren.', 100],
		['Ich habe den Kuchen gegessen und das Buch.', 70],
		['Ich kann klettern und fliegen.', 100],
		// what may stand in the first slot
		['Die Limonade mit Eis kostet zwei Euro.', 100],
		['Der Stuhl rechts ist frei.', 100],
		['Herr Wolf kommt morgen.', 100],
		['Um halb acht komme ich.', 100],
		['Nur noch deine Unterschrift fehlt.', 100],
		['Alle Zimmer sind geputzt.', 100],
		['Gestern um acht kam ich.', 100],
		// still wrong
		['Ich morgen komme.', 70],
		['Gestern ich kam.', 70]
	])('%s → %i', (s, score) => expect(grade(s).score).toBe(score));

	it('a listed question word opens a direct question', () => {
		const withWh = { ...lex, subordinators: ['welches', 'was'], nouns: { ...lex.nouns, Formular: 'n' as const }, verbs: [...lex.verbs, 'brauche'] };
		const tokens = ['welches', 'Formular', 'brauche', 'ich', QUESTION];
		expect(gradeSentence(tokens, withWh, {}, 'Sam').score).toBe(100);
		const indirect = ['ich', 'weiß', 'nicht', 'welches', 'Formular', 'ich', 'brauche'];
		expect(gradeSentence(indirect, withWh, {}, 'Sam').score).toBe(100);
	});
	it('a question ends with a question mark', () => {
		expect(grade('Kommst du?').text).toBe('Kommst du?');
	});
	it('a phrase right after "und" with nothing before it takes the case its verb gives', () => {
		expect(grade('Ich will nicht arbeiten und den Kuchen essen.').score).toBe(100);
	});
	it('an adjective with its noun left out keeps its ending', () => {
		expect(grade('Ich nehme das rote.').score).toBe(100);
	});
	it('a name addressing someone stands outside the sentence', () => {
		expect(grade('Anna ich komme morgen.').score).toBe(100);
	});
	it('es gibt takes the accusative', () => {
		expect(grade('Es gibt einen Stuhl.').score).toBe(100);
		expect(grade('Es gibt ein Stuhl.').score).toBe(85);
	});
	it('rosa never takes an ending and does not break the adjective before it', () => {
		expect(grade('Das ist das kleine rosa Paket.').score).toBe(100);
	});
	it('two adjectives joined by und both agree', () => {
		expect(grade('Ich suche einen ruhigen und ordentlichen Mitbewohner.').score).toBe(100);
		expect(grade('Ich suche einen ruhigen und ordentliche Mitbewohner.').score).toBe(85);
	});
	it('"ihr" before a feminine or plural noun is "to her", not her possessive', () => {
		expect(grade('Ich schenke ihr Schokolade.').score).toBe(100);
	});
	it('seit before an adverb is a preposition, before a pronoun a clause', () => {
		expect(grade('Seit gestern habe ich einen Hund.').score).toBe(100);
	});
	it('werden after a participle closes the passive', () => {
		expect(grade('Das muss gemacht werden.').score).toBe(100);
	});
	it('a sentence with "es" and no verb is missing its verb', () => {
		expect(grade('Es mir leid.').score).toBe(50);
	});
});
