// A source scan, in the same spirit as quiz/effect-tracking.test.ts: the
// project has no component-test harness, and this is a mistake that type
// checking and svelte-check both wave through.
//
// GermanText renders every recognised word as a <button>. Put it inside
// another <button> or an <a> and the HTML is invalid — a browser closes the
// outer element early, the layout breaks, and the word either cannot be tapped
// or swallows the tap that was meant for the option or the link. Both are easy
// to reintroduce: the obvious place to want a glossed word is a multiple-choice
// option, which is a button, and a glossary entry, which is a link.
//
// Where a quiz option really needs the English, the translation line under it
// is the place for it.

import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { globSync } from 'node:fs';
import { describe, expect, it } from 'vitest';

const files = globSync('src/**/*.svelte', { cwd: process.cwd() }).map((relative) => ({
	relative,
	source: readFileSync(join(process.cwd(), relative), 'utf8')
}));

/** The markup half of a component: everything after the last </script>. */
function markup(source: string): string {
	const at = source.lastIndexOf('</script>');
	return (at === -1 ? source : source.slice(at + 9)).replace(/<!--[\s\S]*?-->/g, '');
}

/**
 * The interactive elements still open at each <GermanText>, by scanning tags
 * in order and keeping a stack. Only button and a are tracked: they are the
 * two that may not contain a button.
 */
function enclosingInteractive(source: string): string[] {
	const open: string[] = [];
	const hits: string[] = [];
	for (const match of markup(source).matchAll(/<(\/?)(button|a|GermanText)\b([^>]*)>/g)) {
		const [, closing, tag, rest] = match;
		if (tag === 'GermanText') {
			if (open.length) hits.push(open[open.length - 1]);
			continue;
		}
		if (closing) open.pop();
		else if (!rest.trimEnd().endsWith('/')) open.push(tag);
	}
	return hits;
}

describe('GermanText placement', () => {
	it('is never nested inside a button or a link', () => {
		const bad = files
			.filter(({ source }) => source.includes('<GermanText'))
			.flatMap(({ relative, source }) =>
				enclosingInteractive(source).map((tag) => `${relative}: inside <${tag}>`)
			);
		expect(bad).toEqual([]);
	});

	it('is what renders the German in every quiz that shows a text', () => {
		// A regression guard with teeth: these are the components whose whole job
		// is to put German in front of the learner. If one stops using
		// GermanText, tapping silently dies in that exercise and nothing else
		// fails. Add to this list when a new text-bearing quiz appears.
		const expected = [
			'src/lib/components/quiz/FillBlankQuiz.svelte',
			'src/lib/components/quiz/PassageQuiz.svelte',
			'src/lib/components/quiz/DictationQuiz.svelte',
			'src/lib/components/quiz/SpeakRepeatQuiz.svelte',
			'src/lib/components/quiz/InlineClozeQuiz.svelte',
			'src/lib/components/Lesson.svelte',
			'src/lib/components/HelpMemory.svelte'
		];
		for (const path of expected) {
			const file = files.find((f) => f.relative.split('\\').join('/') === path);
			expect(file, path).toBeDefined();
			expect(file!.source, path).toContain('<GermanText');
		}
	});
});
