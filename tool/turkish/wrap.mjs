#!/usr/bin/env node
// Wraps a Svelte file's English interface text in t(), for Turkish mode.
//   node tool/turkish/wrap.mjs <file.svelte> [...]        list what it would wrap
//   node tool/turkish/wrap.mjs <file.svelte> --apply      wrap it
//   --skip "text" (repeatable)                            leave one string alone
// It looks at the markup only (not <script>, <style> or comments):
//   - text nodes with English in them: `>Some text<`  →  `>{t('Some text')}<`
//   - attributes aria-label / title / placeholder / alt / label / idk / heading
//     with a plain English value: `title="Close"`  →  `title={t('Close')}`
// Text mixed with {expressions} is listed under MANUAL and left alone, as are
// strings in elements with lang="de". Adds the t import when missing.
import { readFileSync, writeFileSync } from 'node:fs';
import { englishWords } from '../german-first/lib.mjs';

// The course's German words, from fields that hold only German.
let vocab;
function germanWords() {
	if (vocab) return vocab;
	vocab = new Set();
	const walk = (o, key = '') => {
		if (typeof o === 'string') {
			if (/^(de|acceptedAnswers|passage|inlineTemplate|passageTitle|tiles)$/.test(key))
				for (const w of o.toLowerCase().match(/\p{L}+/gu) ?? []) vocab.add(w);
		} else if (Array.isArray(o)) o.forEach((v) => walk(v, key));
		else if (o && typeof o === 'object') for (const [k, v] of Object.entries(o)) walk(v, k);
	};
	walk(JSON.parse(readFileSync('assets/content/courses/de_cert_a1.json', 'utf8')));
	return vocab;
}

const args = process.argv.slice(2);
const apply = args.includes('--apply');
const skips = new Set();
const files = [];
for (let i = 0; i < args.length; i++) {
	if (args[i] === '--skip') skips.add(args[++i]);
	else if (!args[i].startsWith('--')) files.push(args[i]);
}

// One-word labels that are English (a lone word has no stop-word to tell).
const UI_WORDS = new Set(
	'Notes More Report Learn Practise Finished Hide Close Back Next Previous Skip Done Check Continue Cancel Retry Listen Play Pause Stop Show Start Restart Menu Settings Help Hint Reveal Submit Send Copy Copied Open Words Grammar Reading Listening Writing Speaking Dictation Flashcards Score Medal Streak Mistakes Answers Answer Translation English German Example Examples Rule Rules Tip Tips Remember Trap Why Loading Saved Again Correct Wrong Right Good Great Perfect Easy Hard Results Result Summary Lesson Exercise Exercises Book Books Page Pages Chapter Level Levels Undo Clear Delete Edit Save Print Download Share Search Filter All None Any Yes No Okay Got Close'.split(
		' '
	)
);
const ATTRS = ['aria-label', 'title', 'placeholder', 'alt', 'label', 'idk', 'heading', 'aria-description'];

const isEnglish = (s) => {
	const text = s.replace(/&nbsp;/g, ' ').trim();
	if (!/[A-Za-z]{2,}/.test(text)) return false;
	if (UI_WORDS.has(text.replace(/[.!?:…]+$/, ''))) return true;
	const words = text.match(/\p{L}{2,}/gu) ?? [];
	if (words.length < 2) return false;
	if (englishWords(text) >= 1) return true;
	// No English stop-word: English still when no word is one the course's German uses.
	const german = germanWords();
	return words.every((w) => !german.has(w.toLowerCase()));
};
const quote = (s) => `'${s.replace(/\\/g, '\\\\').replace(/'/g, "\\'")}'`;

for (const file of files) {
	let src = readFileSync(file, 'utf8');
	const crlf = src.includes('\r\n');
	if (crlf) src = src.replace(/\r\n/g, '\n');
	// Mask what is not markup, keeping offsets.
	const mask = src.replace(/<script[\s\S]*?<\/script>|<style[\s\S]*?<\/style>|<!--[\s\S]*?-->/g, (m) => m.replace(/[^\n]/g, ' '));
	const edits = [];
	const manual = [];
	// Elements whose content is German: skip text inside lang="de" tags.
	const deRanges = [];
	for (const m of mask.matchAll(/<(\w+)[^>]*\blang="de"[^>]*>/g)) {
		const close = mask.indexOf(`</${m[1]}>`, m.index);
		if (close > 0) deRanges.push([m.index, close]);
	}
	const inDe = (i) => deRanges.some(([a, b]) => i > a && i < b);

	// Text nodes: between a '>' and the next '<' (Svelte files only).
	for (const m of file.endsWith('.ts') ? [] : mask.matchAll(/>([^<>]+)</g)) {
		const raw = src.slice(m.index + 1, m.index + 1 + m[1].length);
		if (!m[1].trim() || inDe(m.index)) continue;
		// Detect on the masked text; a comment in the middle means hands-on.
		if (raw !== m[1]) {
			const masked = m[1].replace(/\{[^}]*\}/g, '');
			if (isEnglish(masked)) manual.push(m[1].trim().replace(/\s+/g, ' '));
			continue;
		}
		// Strip Svelte blocks ({#if}, {/if}, {:else}, {@render …}) at the edges.
		if (/^\s*\{[#/:@]/.test(raw) && /\}\s*$/.test(raw) && !/[A-Za-z]{3,}\s+[a-z]/.test(raw.replace(/\{[^}]*\}/g, ''))) continue;
		// A '>' inside an expression (a comparison, an arrow) is not a text node.
		if (/&&|\|\||===|!==|\?\s*'|=>/.test(raw)) continue;
		const plain = raw.replace(/\{[^}]*\}/g, '');
		if (!isEnglish(plain)) continue;
		const text = raw.trim().replace(/\s+/g, ' ');
		if (skips.has(text)) continue;
		if (/[{}]/.test(raw)) {
			manual.push(text);
			continue;
		}
		const lead = raw.match(/^\s*/)[0];
		const trail = raw.match(/\s*$/)[0];
		const value = text.replace(/&nbsp;/g, ' ').replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
		edits.push({ start: m.index + 1, end: m.index + 1 + raw.length, out: `${lead}{t(${quote(value)})}${trail}`, show: value });
	}
	// Plain attributes.
	for (const a of file.endsWith('.ts') ? [] : ATTRS) {
		for (const m of mask.matchAll(new RegExp(`\\s${a}="([^"{}]*)"`, 'g'))) {
			if (!isEnglish(m[1]) || inDe(m.index) || skips.has(m[1])) continue;
			const start = m.index + 1;
			edits.push({ start, end: start + m[0].length - 1, out: `${a}={t(${quote(m[1])})}`, show: `${a}: ${m[1]}` });
		}
	}
	// String literals with English, in <script> and in markup {expressions}:
	// listed (`literal`), or wrapped with --literals when they sit in markup.
	const literals = [];
	const scriptRanges = [...src.matchAll(/<script[\s\S]*?<\/script>/g)].map((m) => [m.index, m.index + m[0].length]);
	const isTs = file.endsWith('.ts');
	const inScript = (i) => isTs || scriptRanges.some(([a, b]) => i > a && i < b);
	// <style> is never scanned: its strings are font names and grid areas.
	const noComments = src.replace(/<style[\s\S]*?<\/style>|<!--[\s\S]*?-->|\/\*[\s\S]*?\*\/|(^|[^:'"`])\/\/[^\n]*/gm, (m) => m.replace(/[^\n]/g, ' '));
	for (const m of noComments.matchAll(/(['`])((?:\\.|(?!\1)[^\\\n])*)\1/g)) {
		const body = m[2];
		const before = noComments.slice(Math.max(0, m.index - 4), m.index);
		// Machinery, never interface text: module paths, URLs, selectors, CSS, analytics ids.
		if (/^[a-z0-9]+(-[a-z0-9]+)+$|^[$./#@]|^https?:|^[a-z_]+$|\bimport\b|[[\]>=]|^\(|cubic-bezier|^\d/.test(body) || /\bfrom\s*$|import\(\s*$/.test(noComments.slice(Math.max(0, m.index - 12), m.index))) continue;
		if (m[1] === '`' && body.includes('${')) {
			if (!isEnglish(body.replace(/\$\{[^}]*\}/g, ''))) continue;
			// Simple placeholders only: ${name} or ${a.b} or ${n + 1}; anything with quotes stays manual.
			const holes = [...body.matchAll(/\$\{([^}]*)\}/g)];
			const simple = holes.every((h) => !/['"`?]/.test(h[1]));
			literals.push({ i: m.index, len: m[0].length, text: body, tpl: true, simple, holes, script: inScript(m.index) });
			continue;
		}
		if (!isEnglish(body) || skips.has(body)) continue;
		if (/\btk?\($/.test(before) || /\btn\([^)]*$/.test(noComments.slice(Math.max(0, m.index - 80), m.index))) continue;
		// A markup attribute value ("…") is the attribute pass's business.
		if (!inScript(m.index) && m[1] === '"' && /=$/.test(before)) continue;
		literals.push({ i: m.index, len: m[0].length, text: body, q: m[1], script: inScript(m.index) });
	}
	for (const l of literals) console.log(`  ${l.tpl ? (l.simple ? "template" : "TEMPLATE") : l.script ? "script " : "markup "}`, l.text.slice(0, 100));
	const doScript = args.includes('--script');
	const doTemplates = args.includes('--templates');
	if (args.includes('--literals') || doScript || doTemplates)
		for (const l of literals) {
			if (l.script && !doScript) continue;
			if (!l.tpl && (args.includes('--literals') || l.script))
				edits.push({ start: l.i, end: l.i + l.len, out: `t(${quote(l.text)})`, show: l.text });
			else if (l.tpl && l.simple && doTemplates) {
				// `Not ${n.digit}. Try again.` → t('Not {digit}. Try again.', { digit: n.digit })
				const names = [];
				let key = l.text;
				for (const h of l.holes) {
					const expr = h[1].trim();
					let name = (expr.match(/([A-Za-z_]\w*)\s*(?:\(\))?$/) ?? [])[1] ?? 'x';
					if (!/^[A-Za-z_]\w*(\.\w+)*$/.test(expr)) name = expr.match(/^[A-Za-z_]\w*/)?.[0] ?? 'x';
					while (names.some((n) => n.name === name && n.expr !== expr)) name += '2';
					if (!names.some((n) => n.name === name)) names.push({ name, expr });
					key = key.replace(h[0], `{${name}}`);
				}
				const vars = names.map((n) => (n.name === n.expr ? n.name : `${n.name}: ${n.expr}`)).join(', ');
				edits.push({ start: l.i, end: l.i + l.len, out: `t(${quote(key)}, { ${vars} })`, show: `${key}  ⟵ ${vars}` });
			}
		}
	edits.sort((x, y) => y.start - x.start);
	console.log(`=== ${file}: ${edits.length} to wrap, ${manual.length} manual`);
	for (const e of [...edits].reverse()) console.log('  +', e.show.slice(0, 110));
	for (const m of manual) console.log('  MANUAL', m.slice(0, 110));
	if (!apply || !edits.length) continue;
	for (const e of edits) src = src.slice(0, e.start) + e.out + src.slice(e.end);
	if (!/import \{[^}]*\bt\b[^}]*\} from '\$lib\/i18n\/t'/.test(src)) {
		src = file.endsWith('.ts')
			? `import { t } from '$lib/i18n/t';\n${src}`
			: src.replace(/(<script[^>]*>\n)/, `$1\timport { t } from '$lib/i18n/t';\n`);
	}
	writeFileSync(file, crlf ? src.replace(/\n/g, '\r\n') : src);
}
