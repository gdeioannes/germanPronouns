import { describe, expect, it } from 'vitest';
import { spokenTexts } from '$lib/audio/spoken-texts';
import { filledSentence, forSpeech, spokenVerbForm } from './spoken';

describe('filledSentence', () => {
	it.each([
		['Sie sind sehr nett, Herr ____. (you, formal)', ['Müller'], 'Sie sind sehr nett, Herr Müller.'],
		['Am Montag ____ ich Deutsch. (lernen)', ['lerne'], 'Am Montag lerne ich Deutsch.'],
		['Ich gehe ____ Arzt. (zu + dem = zum)', ['zum'], 'Ich gehe zum Arzt.'],
		['Der Bericht ist ____ (state: finished).', ['geschrieben'], 'Der Bericht ist geschrieben.'],
		['Er wollte wissen, ____ ich so lange warte. (for what → wo(r)-)', ['worauf'], 'Er wollte wissen, worauf ich so lange warte.'],
		// An answer that opens a sentence or a turn is capitalised.
		['____ seid meine Freunde. (you, plural)', ['ihr'], 'Ihr seid meine Freunde.'],
		['Das ist Anna. ____ ist nett. (she)', ['sie'], 'Das ist Anna. Sie ist nett.'],
		['Wo ist Lena? – ____ ist im Park.', ['sie'], 'Wo ist Lena? – Sie ist im Park.'],
		// …but not one in the middle.
		['Ich rufe ____ heute an. (you, informal)', ['dich'], 'Ich rufe dich heute an.'],
		// No stray space before the full stop.
		['An der Schule arbeiten viele ____ . (der Lehrer → Frauen, Plural)', ['Lehrerinnen'], 'An der Schule arbeiten viele Lehrerinnen.'],
		// A clue in German inside the sentence is part of it.
		['Viele Farben zusammen (ein Regenbogen) sind ____.', ['bunt'], 'Viele Farben zusammen (ein Regenbogen) sind bunt.'],
		['1 = ____', ['eins'], 'eins'],
		['der Fisch + die Suppe = ____', ['die Fischsuppe'], 'der Fisch, die Suppe, die Fischsuppe'],
		[
			'Das passt mir nicht. (the date) → Dieser Termin ist mir leider nicht ____.',
			['möglich'],
			'Das passt mir nicht. Dieser Termin ist mir leider nicht möglich.'
		],
		['die Gäste, die eingeladen wurden → die ____ Gäste', ['eingeladenen'], 'die Gäste, die eingeladen wurden, die eingeladenen Gäste']
	])('%s', (sentence, parts, spoken) => {
		expect(filledSentence(sentence, parts)).toBe(spoken);
	});
});

describe('forSpeech', () => {
	it('drops the grammar tag after a pattern', () => {
		expect(forSpeech('seit + Dat')).toBe('seit');
		expect(forSpeech('sich freuen auf + Akk')).toBe('sich freuen auf');
		expect(forSpeech('nennen + Akk + Akk')).toBe('nennen');
		expect(forSpeech('werden + Partizip II')).toBe('werden');
	});

	it('leaves plain German alone', () => {
		expect(forSpeech('der Apfel')).toBe('der Apfel');
		expect(forSpeech('Wie geht es Ihnen?')).toBe('Wie geht es Ihnen?');
	});
});

describe('spokenVerbForm', () => {
	it('says the first person of a shared row', () => {
		expect(spokenVerbForm({ person: 'er/sie/es', form: 'ist' })).toBe('er ist');
	});

	it('says an imperative as a command, without its bracketed person', () => {
		expect(spokenVerbForm({ person: '(du)', form: 'sei' })).toBe('Sei!');
		expect(spokenVerbForm({ person: '(Sie)', form: 'seien Sie' })).toBe('Seien Sie!');
	});
});

// Every string the app reads aloud (and the recorder records): no note for
// the reader may reach the voice. Reading and listening texts are authentic
// documents read as written, quotes and all, so they are left out.
describe('everything the app speaks', async () => {
	const texts = (await spokenTexts()).filter((s) => !/passage|question|big text/.test(s.source));

	it('ends without a bracketed note', () => {
		const noted = texts.filter((s) => /\)\s*[.!?…]*$/.test(s.text)).map((s) => `[${s.source}] ${s.text}`);
		expect(noted).toEqual([]);
	});

	it('has no arrows, and no "+"/"=" between words', () => {
		const marked = texts.filter((s) => /→|\s[+=]\s/.test(s.text)).map((s) => `[${s.source}] ${s.text}`);
		expect(marked).toEqual([]);
	});

	it('has no space before punctuation', () => {
		const spaced = texts
			.filter((s) => s.source === 'fill in the blank' && /\s[.,!?;:]/.test(s.text))
			.map((s) => s.text);
		expect(spaced).toEqual([]);
	});
});
