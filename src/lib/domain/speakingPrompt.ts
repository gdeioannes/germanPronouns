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
	templates: Record<string, string>;
	defaults: Record<string, number>;
	triggers: Record<string, string>;
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
		referenceNotes = ''
	} = options;

	const learn = baseLang(learnLang);
	const ui = baseLang(uiLang);
	const defaults = manifest.defaults;
	const scaffolded = (exercise as { scaffolded?: boolean }).scaffolded ?? false;

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
		practisePoints: (exercise.practisePoints ?? []).join(', '),
		targetVocabulary: (exercise.targetVocabulary ?? []).join(', '),
		scoringCriteria: (exercise.scoringCriteria ?? []).join(', '),
		priorityErrors: '',
		closingLine: template.closingLine,
		durationMinutes: String(exercise.durationMinutes ?? defaults.durationMinutes),
		minExchanges: String(exercise.minExchanges ?? defaults.minExchanges),
		minQuestionsPerPoint: String(defaults.minQuestionsPerPoint),
		reportMaxWords: String(defaults.reportMaxWords),
		maxCorrections: String(defaults.maxCorrections)
	};

	// The mode instruction is itself template text carrying placeholders, so
	// it is filled before being spliced in — `fill` makes one pass per line.
	const mode = exercise.mode ?? 'conversation';
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
			...(section.bullets ?? []).map((bullet) => `- ${fill(bullet, values)}`),
			...(section.list ? listLines(section.list, lists, values) : [])
		].filter((line) => line.trim().length > 0);

		if (body.length === 0) continue;
		blocks.push([...(section.heading ? [section.heading] : []), ...body].join('\n'));
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
