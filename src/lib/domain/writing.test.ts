import { describe, expect, it } from 'vitest';
import {
	asSpeakingExercise,
	BOLD,
	canSubmit,
	charBoundsFor,
	countChars,
	countWords,
	fillOf,
	GERMAN_KEYS,
	ITALIC,
	markersToHtml,
	plainText,
	serialiseMarkers,
	writingState,
	type MarkerNode
} from './writing';
import { familyFor, renderSpeakingPrompt, type SpeakingManifest, type SpeakingTemplate } from './speakingPrompt';
import type { WritingExercise } from '$lib/content/types';
import manifest from '../../../assets/content/speaking/manifest.json';
import template from '../../../assets/content/speaking/template.en.json';

const exercise: WritingExercise = {
	topic: 'Write an email to your landlord about the broken heating.',
	practisePoints: ['say what is wrong', 'ask for a repair date'],
	scoringCriteria: ['a greeting and a sign-off']
};

describe('the writing character bound', () => {
	it('scales with the level', () => {
		expect(charBoundsFor(exercise, 'A1.1')).toEqual({ min: 120, max: 300 });
		expect(charBoundsFor(exercise, 'B1.2')).toEqual({ min: 400, max: 900 });
		expect(charBoundsFor(exercise, 'C2.2')).toEqual({ min: 1200, max: 2500 });
	});

	it('falls back to A1 for an unknown or missing level', () => {
		expect(charBoundsFor(exercise, undefined)).toEqual({ min: 120, max: 300 });
		expect(charBoundsFor(exercise, 'Z9.9')).toEqual({ min: 120, max: 300 });
	});

	it('lets a quiz override either end', () => {
		expect(charBoundsFor({ ...exercise, charMax: 400 }, 'A1.1')).toEqual({ min: 120, max: 400 });
		expect(charBoundsFor({ ...exercise, charMin: 50 }, 'A1.1')).toEqual({ min: 50, max: 300 });
	});

	it('cannot be inverted by an author overriding one end past the other', () => {
		// charMax below the band's minimum would otherwise make every text "over".
		expect(charBoundsFor({ ...exercise, charMax: 80 }, 'A1.1')).toEqual({ min: 80, max: 120 });
	});
});

describe('counting what the learner wrote', () => {
	it('ignores padding that is not writing', () => {
		expect(countChars('  hallo  ')).toBe(5);
		expect(countChars('ein    Wort')).toBe('ein Wort'.length);
		expect(countChars('eins\n\n\n\nzwei')).toBe('eins\nzwei'.length);
	});

	it('keeps a single paragraph break', () => {
		expect(countChars('eins\nzwei')).toBe(9);
	});

	it('treats an empty box as zero', () => {
		expect(countChars('')).toBe(0);
		expect(countChars('   \n  ')).toBe(0);
	});
});

describe('counting words, the unit a task is set in', () => {
	it('counts words, not spaces', () => {
		expect(countWords('Ich habe einen Kaffee getrunken')).toBe(5);
		expect(countWords('  Ich   habe \n\n gewartet ')).toBe(3);
	});

	it('counts a compound and a hyphenated word once each', () => {
		expect(countWords('Die Kursgebühr-Rückerstattung kam spät')).toBe(4);
		expect(countWords('Donaudampfschifffahrtsgesellschaft')).toBe(1);
	});

	it('does not count stray punctuation as a word', () => {
		expect(countWords('Hallo , - ! Max')).toBe(2);
		expect(countWords('')).toBe(0);
	});
});

describe('emphasis markers', () => {
	it('are stripped back out to leave the German', () => {
		expect(plainText('Das ist **sehr** wichtig')).toBe('Das ist sehr wichtig');
		expect(plainText('Ich war *gestern* da')).toBe('Ich war gestern da');
	});

	it('do not count towards the length, so a text cannot be padded with them', () => {
		const plain = 'Das ist sehr wichtig';
		expect(countChars('Das ist **sehr** wichtig')).toBe(countChars(plain));
		expect(countChars('*'.repeat(400))).toBe(0);
	});

	it('do not inflate the word count either', () => {
		expect(countWords('Das ist **sehr** wichtig')).toBe(4);
		expect(countWords('** ** **')).toBe(0);
	});

	it('are the Markdown pair the prompt tells the tutor to ignore', () => {
		expect(BOLD).toBe('**');
		expect(ITALIC).toBe('*');
	});
});

describe('the editor surface and the marker text', () => {
	// A stand-in for the DOM nodes the browser builds, so the conversion can be
	// tested without one.
	const t = (data: string): MarkerNode => ({
		nodeType: 3,
		nodeName: '#text',
		data,
		childNodes: []
	});
	const e = (nodeName: string, ...childNodes: MarkerNode[]): MarkerNode => ({
		nodeType: 1,
		nodeName,
		childNodes
	});

	it('reads bold and italic back as markers', () => {
		const root = e('DIV', e('DIV', t('Das ist '), e('STRONG', t('sehr')), t(' wichtig')));
		expect(serialiseMarkers(root)).toBe('Das ist **sehr** wichtig');
		const it2 = e('DIV', e('DIV', t('Ich war '), e('EM', t('gestern')), t(' da')));
		expect(serialiseMarkers(it2)).toBe('Ich war *gestern* da');
	});

	it('accepts whatever tag the browser chose for the same thing', () => {
		expect(serialiseMarkers(e('DIV', e('B', t('fett'))))).toBe('**fett**');
		expect(serialiseMarkers(e('DIV', e('I', t('kursiv'))))).toBe('*kursiv*');
	});

	it('turns blocks and line breaks into newlines', () => {
		const root = e('DIV', e('DIV', t('eins')), e('DIV', t('zwei')));
		expect(serialiseMarkers(root)).toBe('eins\nzwei');
		expect(serialiseMarkers(e('DIV', t('eins'), e('BR'), t('zwei')))).toBe('eins\nzwei');
	});

	it('never emits an empty marker pair', () => {
		// An emphasis button pressed with nothing selected and nothing typed
		// would otherwise leave **** in the learner's German.
		expect(serialiseMarkers(e('DIV', e('STRONG')))).toBe('');
		expect(serialiseMarkers(e('DIV', e('STRONG', t('  '))))).toBe('  ');
	});

	it('builds the surface back from a saved draft', () => {
		expect(markersToHtml('Das ist **sehr** wichtig')).toBe(
			'<div>Das ist <strong>sehr</strong> wichtig</div>'
		);
		expect(markersToHtml('eins\nzwei')).toBe('<div>eins</div><div>zwei</div>');
		expect(markersToHtml('')).toBe('<div><br></div>');
	});

	it('escapes a draft rather than letting it become markup', () => {
		expect(markersToHtml('<script>alert(1)</script>')).not.toContain('<script>');
		expect(markersToHtml('a < b & c')).toContain('a &lt; b &amp; c');
	});

	it('round-trips a draft through the surface and back', () => {
		const original = 'Hallo Max,\nDas war **sehr** gut und *wirklich* schön.';
		// What markersToHtml produces, parsed back by the same rules.
		const rebuilt = e(
			'DIV',
			e('DIV', t('Hallo Max,')),
			e(
				'DIV',
				t('Das war '),
				e('STRONG', t('sehr')),
				t(' gut und '),
				e('EM', t('wirklich')),
				t(' schön.')
			)
		);
		expect(serialiseMarkers(rebuilt)).toBe(original);
	});
});

describe('the length rail', () => {
	const bounds = { min: 100, max: 200 };

	it('fills towards the minimum', () => {
		expect(fillOf('', bounds)).toBe(0);
		expect(fillOf('a'.repeat(50), bounds)).toBeCloseTo(0.5);
		expect(fillOf('a'.repeat(100), bounds)).toBe(1);
	});

	it('stays full rather than overflowing once the minimum is passed', () => {
		expect(fillOf('a'.repeat(500), bounds)).toBe(1);
	});
});

describe('the German letters the toolbar offers', () => {
	it('covers the ones a non-German keyboard cannot reach', () => {
		expect(GERMAN_KEYS).toEqual(['ä', 'ö', 'ü', 'ß', 'Ä', 'Ö', 'Ü']);
	});

	it('offers no capital ß, which is not what a learner needs to type', () => {
		expect(GERMAN_KEYS).not.toContain('ẞ');
	});
});

describe('whether a text may be sent for correction', () => {
	const bounds = { min: 10, max: 20 };

	it('is short until the minimum is reached', () => {
		expect(writingState('too short', bounds)).toBe('short');
		expect(canSubmit('too short', bounds)).toBe(false);
	});

	it('is ready inside the bound, at either edge', () => {
		expect(writingState('exactly ten', bounds)).toBe('ready');
		expect(writingState('a'.repeat(20), bounds)).toBe('ready');
		expect(writingState('a'.repeat(10), bounds)).toBe('ready');
		expect(canSubmit('a'.repeat(15), bounds)).toBe(true);
	});

	it('is over past the maximum', () => {
		expect(writingState('a'.repeat(21), bounds)).toBe('over');
		expect(canSubmit('a'.repeat(21), bounds)).toBe(false);
	});
});

describe('the prompt a writing task renders', () => {
	const render = (learnerText: string) =>
		renderSpeakingPrompt({
			exercise: asSpeakingExercise(exercise),
			template: template as SpeakingTemplate,
			manifest: manifest as SpeakingManifest,
			learnLang: 'de-DE',
			uiLang: 'en-GB',
			cefr: 'B1.1',
			learnerText
		});

	it('runs in the writing family', () => {
		expect(familyFor(asSpeakingExercise(exercise).mode)).toBe('writing');
	});

	it('carries the learner’s own text, so the AI corrects that', () => {
		const prompt = render('Ich habe gegangen zum Supermarkt.');
		expect(prompt).toContain('MY TEXT');
		expect(prompt).toContain('Ich habe gegangen zum Supermarkt.');
		expect(prompt).toContain('Correct that text.');
		// The task is still there, as the standard to judge against.
		expect(prompt).toContain(exercise.topic);
		expect(prompt).toContain('ask for a repair date');
	});

	it('never asks the AI to set a task when a text is attached', () => {
		const prompt = render('Ich habe gegangen zum Supermarkt.');
		expect(prompt).not.toContain('Give me the task exactly as MATERIAL describes it');
	});

	it('asks for the same delimited report the app already parses', () => {
		const prompt = render('Ich habe gegangen zum Supermarkt.');
		expect(prompt).toContain('===== REPORT START =====');
		expect(prompt).toContain('===== REPORT END =====');
		expect(prompt).toContain('SCORE=');
		expect(prompt).toContain('FIX:');
	});

	it('leaves MY TEXT out, and waits for a task, while nothing is written', () => {
		const prompt = render('');
		expect(prompt).not.toContain('MY TEXT');
		expect(prompt).toContain('Give me the task exactly as MATERIAL describes it');
	});

	it('does not ask for voice, which a written text has no use for', () => {
		const prompt = render('Ich habe gegangen zum Supermarkt.');
		expect(prompt).not.toContain('voice mode');
	});

	// A correction has no turns, no trigger phrase and nothing to pronounce, so
	// the sections written for a spoken session must not reach it. Each of
	// these was in the prompt before the writing family was scoped.
	it('leaves out everything that assumes a spoken session', () => {
		const prompt = render('Ich habe gegangen zum Supermarkt.');
		expect(prompt).not.toContain('HOW TO SPEAK TO ME');
		expect(prompt).not.toContain('Los geht');
		expect(prompt).not.toContain('the next question is the last one');
		expect(prompt).not.toContain('pronunciation slips');
		expect(prompt).not.toContain('Work one or two of them in naturally');
	});

	it('tells the AI to go straight to the correction', () => {
		const prompt = render('Ich habe gegangen zum Supermarkt.');
		expect(prompt).toContain('WHAT TO DO - IN ORDER');
		expect(prompt).toContain('Do not wait for me');
		expect(prompt).toContain('There are no turns in this exercise');
	});

	it('asks whether the banked mistakes show up again, rather than weaving them in', () => {
		const prompt = renderSpeakingPrompt({
			exercise: asSpeakingExercise(exercise),
			template: template as SpeakingTemplate,
			manifest: manifest as SpeakingManifest,
			learnLang: 'de-DE',
			uiLang: 'en-GB',
			cefr: 'B1.1',
			personalFocus: ['"ich habe gegangen" -> "ich bin gegangen"'],
			learnerText: 'Ich habe gegangen zum Supermarkt, und dann habe ich eingekauft.'
		});
		expect(prompt).toContain('PERSONAL FOCUS');
		expect(prompt).toContain('Check whether any of them show up in my text');
		expect(prompt).toContain('ich bin gegangen');
	});
});

describe('the spoken prompts keep what the writing family dropped', () => {
	// Scoping a shared section to the spoken families must not take it away
	// from a speaking exercise.
	const spoken = renderSpeakingPrompt({
		exercise: {
			topic: 'Ordering in a cafe',
			practisePoints: ['order a drink'],
			scoringCriteria: ['politeness'],
			mode: 'roleplay'
		},
		template: template as SpeakingTemplate,
		manifest: manifest as SpeakingManifest,
		learnLang: 'de-DE',
		uiLang: 'en-GB',
		cefr: 'A2.1',
		personalFocus: ['"x" -> "y"']
	});

	it('still carries the session plan, the speaking guide and the focus weave', () => {
		expect(spoken).toContain('SESSION PLAN');
		expect(spoken).toContain('HOW TO SPEAK TO ME');
		expect(spoken).toContain('Work one or two of them in naturally');
		expect(spoken).toContain('the next question is the last one');
	});

	it('is never given the writing rules or a MY TEXT block', () => {
		expect(spoken).not.toContain('MY TEXT');
		expect(spoken).not.toContain('There are no turns in this exercise');
		expect(spoken).not.toContain('SCORING THE TEXT');
	});
});
