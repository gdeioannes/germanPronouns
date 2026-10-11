// The speaking prompt builder, ported from lib/services/speaking_prompt.dart.
//
// The app does not run the conversation: it renders a ready-made prompt the
// learner copies into their own AI, talks through there in voice mode, and
// comes back to type the score. That trade is deliberate — live conversational
// AI is the one thing the app can't host for free.
//
// The rendering rules that matter:
//   * `{placeholder}` substitution is a SINGLE pass per line, so a value that
//     itself contains placeholders (modeInstruction) is filled beforehand.
//   * A section with `families` renders only for the exercise's mode family,
//     so a drill prompt never carries the no-drills rule.
//   * A section with `optional` is dropped WHOLE when its placeholder resolves
//     empty — otherwise a heading would be left stranded over a missing body.

import type { SpeakingExercise } from '$lib/content/types';

export const REPORT_START = '===== REPORT START =====';
export const REPORT_END = '===== REPORT END =====';

export type SpeakingFamily = 'conversation' | 'drill' | 'presentation' | 'writing';

const MODE_FAMILIES: Record<string, SpeakingFamily> = {
	conversation: 'conversation',
	interview: 'conversation',
	roleplay: 'conversation',
	storytelling: 'conversation',
	vocabDrill: 'drill',
	translationDrill: 'drill',
	wordGame: 'drill',
	listenRetell: 'presentation',
	readingQa: 'presentation',
	readingGen: 'presentation',
	writing: 'writing'
};

export function familyFor(mode: string | undefined): SpeakingFamily {
	return MODE_FAMILIES[mode ?? 'conversation'] ?? 'conversation';
}

export interface TemplateSection {
	id: string;
	heading?: string;
	lines?: string[];
	bullets?: string[];
	list?: string;
	optional?: string;
	families?: string[];
}

export interface SpeakingTemplate {
	uiLang: string;
	languageNames: Record<string, string>;
	modes: Record<string, string>;
	closingLine: string;
	sections: TemplateSection[];
}

export interface SpeakingManifest {
	templateVersion: number;
	defaults: Record<string, number>;
	triggers: Record<string, string>;
	/** How the tutor should speak, per level band (A1…C2). */
	levelGuides?: Record<string, string>;
	/** How long the tutor's own turns may be, per level band. */
	turnLengths?: Record<string, string>;
	/** How to score a long turn, per level band (C1, C2). */
	scoringNotes?: Record<string, string>;
}

/** 'B1.2' → 'B1'; the band a level-specific rule is keyed by. */
export function levelBand(cefr: string): string {
	return cefr.trim().slice(0, 2).toUpperCase();
}

const BANDS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/**
 * Whether a banked correction belongs in this session: a fix from a level at
 * or below the current one may be woven in; one from above it would drag a
 * beginner into grammar they have not met. A fix without a level (legacy) is
 * kept.
 */
export function fixFitsLevel(fixLevel: string | undefined, cefr: string): boolean {
	if (!fixLevel) return true;
	const a = BANDS.indexOf(levelBand(fixLevel));
	const b = BANDS.indexOf(levelBand(cefr));
	return a === -1 || b === -1 || a <= b;
}

/** 'de-DE' → 'de'; a bare code is left alone. */
export function baseLang(locale: string): string {
	return locale.split(/[-_]/)[0].toLowerCase();
}

export interface RenderOptions {
	exercise: SpeakingExercise;
	template: SpeakingTemplate;
	manifest: SpeakingManifest;
	/** BCP-47 of the language being learned. */
	learnLang: string;
	/** BCP-47 of the learner's own language. */
	uiLang: string;
	cefr: string;
	/** Recent corrections, woven back in as the PERSONAL FOCUS section. */
	personalFocus?: string[];
	/** The quiz's Help Memory, flattened — the COURSE NOTES section. */
	referenceNotes?: string;
	/** The scene the learner is looking at, in words — the PICTURE section. */
	pictureDescription?: string;
	/**
	 * The text the learner wrote in the app, carried into the prompt as MY TEXT
	 * so their own AI corrects that rather than setting a fresh task. Writing
	 * only; empty switches the prompt back to "give me the task and wait".
	 */
	learnerText?: string;
	/** The writing task's length, so the tutor can hold the learner to it. */
	charBounds?: { min: number; max: number };
}

const PLACEHOLDER = /\{(\w+)\}/g;

function fill(text: string, values: Record<string, string>): string {
	return text.replace(PLACEHOLDER, (whole, key: string) => values[key] ?? whole);
}

/** Renders the exercise into the text the learner copies into their AI. */
export function renderSpeakingPrompt(options: RenderOptions): string {
	const {
		exercise,
		template,
		manifest,
		learnLang,
		uiLang,
		cefr,
		personalFocus = [],
		referenceNotes = '',
		pictureDescription = '',
		learnerText = '',
		charBounds
	} = options;

	const learn = baseLang(learnLang);
	const ui = baseLang(uiLang);
	const defaults = manifest.defaults;
	const scaffolded = exercise.scaffolded ?? false;
	const band = levelBand(cefr);
	const mode = exercise.mode ?? 'conversation';
	const minExchanges = exercise.minExchanges ?? defaults.minExchanges;
	// Inviting the learner to ask questions only earns its two exchanges in a
	// session long enough to spare them, and only where the learner is not
	// already the one talking (storytelling) or being interviewed.
	const askBack = minExchanges >= 8 && (mode === 'conversation' || mode === 'roleplay');

	const lists: Record<string, string[]> = {
		practisePoints: exercise.practisePoints ?? [],
		targetVocabulary: exercise.targetVocabulary ?? [],
		personalFocus
	};

	const values: Record<string, string> = {
		targetLanguageName: template.languageNames[learn] ?? learn,
		uiLanguageName: template.languageNames[ui] ?? ui,
		reportLanguageName: template.languageNames[ui] ?? ui,
		triggerPhrase: manifest.triggers[learn] ?? manifest.triggers.en ?? "Let's go",
		cefr,
		topic: exercise.topic,
		material: typeof exercise.material === 'string' ? exercise.material : '',
		reportStartMarker: REPORT_START,
		reportEndMarker: REPORT_END,
		// Non-empty switches the optional scaffolding section on, and its
		// inverse the immersion variant. The values themselves never render.
		scaffolding: scaffolded ? 'yes' : '',
		noScaffolding: scaffolded ? '' : 'yes',
		personalFocus: personalFocus.join(', '),
		referenceNotes,
		pictureDescription,
		// A writing task where the learner has already written switches the
		// rules from "set me a task and wait" to "correct what follows". The
		// inverse flag drives the optional section the other way, the same
		// trick `scaffolding` uses.
		learnerText: learnerText.trim(),
		noLearnerText: learnerText.trim() ? '' : 'yes',
		practisePoints: (exercise.practisePoints ?? []).join('; '),
		targetVocabulary: (exercise.targetVocabulary ?? []).join(', '),
		scoringCriteria: (exercise.scoringCriteria ?? []).join(', '),
		priorityErrors: (exercise.priorityErrors ?? []).join(', '),
		closingLine: template.closingLine,
		levelGuide: manifest.levelGuides?.[band] ?? '',
		turnLength: manifest.turnLengths?.[band] ?? '',
		// An exercise's own scoring rule rides with the band's note.
		scoringNote: [manifest.scoringNotes?.[band] ?? '', exercise.scoringNote ?? '']
			.filter(Boolean)
			.join(' '),
		// Conditional RULES bullets: an empty one is dropped by the renderer.
		askBackLine: askBack
			? 'At least twice, invite me to ask YOU a question - asking is part of speaking, and my questions count as exchanges.'
			: '',
		hintLine: scaffolded
			? "If I'm stuck, one short hint - in {targetLanguageName} first, in {uiLanguageName} if that does not help - then move on."
			: "If I'm stuck, one short hint in {targetLanguageName}, then move on.",
		minChars: charBounds ? String(charBounds.min) : '',
		maxChars: charBounds ? String(charBounds.max) : '',
		durationMinutes: String(exercise.durationMinutes ?? defaults.durationMinutes),
		minExchanges: String(minExchanges),
		minQuestionsPerPoint: String(defaults.minQuestionsPerPoint),
		reportMaxWords: String(exercise.reportMaxWords ?? defaults.reportMaxWords),
		maxCorrections: String(exercise.maxCorrections ?? defaults.maxCorrections)
	};

	// The mode instruction is itself template text carrying placeholders, so
	// it is filled before being spliced in — `fill` makes one pass per line.
	values.modeInstruction = fill(template.modes[mode] ?? '', values);

	const family = familyFor(mode);
	const blocks: string[] = [];

	for (const section of template.sections) {
		if (section.families && !section.families.includes(family)) continue;
		if (section.optional !== undefined && !fill(section.optional, values).trim()) {
			continue;
		}

		const body: string[] = [
			...(section.lines ?? []).map((line) => fill(line, values)),
			// A bullet whose value is a placeholder that resolved empty is left out,
			// so a conditional rule does not leave a bare "- " behind. A value may
			// itself carry placeholders (the hint line), hence the second pass.
			...(section.bullets ?? [])
				.map((bullet) => fill(fill(bullet, values), values).trim())
				.filter((bullet) => bullet.length > 0)
				.map((bullet) => `- ${bullet}`),
			...(section.list ? listLines(section.list, lists, values) : [])
		].filter((line) => line.trim().length > 0);

		if (body.length === 0) continue;
		const heading = section.heading ? [fill(section.heading, values)] : [];
		blocks.push([...heading, ...body].join('\n'));
	}

	return blocks.join('\n\n');
}

/** A list-valued placeholder renders as one `- ` bullet per entry. */
function listLines(
	token: string,
	lists: Record<string, string[]>,
	values: Record<string, string>
): string[] {
	const key = token.replace(/[{}]/g, '');
	const items = lists[key];
	if (!items) return [fill(token, values)];
	return items.map((item) => `- ${item}`);
}

/** The session values an exercise actually runs with, after defaults. */
export function resolveSession(exercise: SpeakingExercise, manifest: SpeakingManifest) {
	return {
		durationMinutes: exercise.durationMinutes ?? manifest.defaults.durationMinutes,
		minExchanges: exercise.minExchanges ?? manifest.defaults.minExchanges,
		passScore: exercise.passScore ?? manifest.defaults.passScore
	};
}
