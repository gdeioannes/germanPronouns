import { describe, expect, it } from 'vitest';
import { NOTE_LANGS, POLL_BOOKS, POLL_LEVELS } from './bookPoll';
import { publicDomainCutoff } from './literature';
import { UI_LANGS } from '$lib/i18n/lang.svelte';
import { existsSync } from 'node:fs';
import commons from '../../../assets/rights/commons.json';
import aiManifest from '../../../assets/images/literature_manifest.json';

describe('literature poll', () => {
	it('has five books for every level', () => {
		for (const level of POLL_LEVELS) {
			expect(POLL_BOOKS.filter((b) => b.level === level).length, level).toBe(5);
		}
	});

	it('uses ids the Firestore rule accepts, each once', () => {
		const ids = POLL_BOOKS.map((b) => b.id);
		expect(new Set(ids).size).toBe(ids.length);
		for (const id of ids) expect(id).toMatch(/^[a-z0-9-]{2,40}$/);
	});

	it('only lists public-domain books with a free source text', () => {
		const cutoff = publicDomainCutoff(new Date('2026-11-22'));
		for (const b of POLL_BOOKS) {
			expect(b.died, b.title).toBeLessThanOrEqual(cutoff);
			expect(b.source.href, b.title).toMatch(/^https:\/\/(www\.gutenberg\.org\/ebooks\/\d+|de\.wikisource\.org\/wiki\/)/);
			// Projekt Gutenberg-DE forbids reuse: never a source.
			expect(b.source.href).not.toContain('projekt-gutenberg.org');
		}
	});

	it('has a synopsis in every site language', () => {
		expect(NOTE_LANGS.map((l) => l.id).sort()).toEqual([...UI_LANGS].sort());
		for (const b of POLL_BOOKS) {
			for (const l of UI_LANGS) {
				const text = b.synopsis[l];
				expect(text?.length, `${b.id} ${l}`).toBeGreaterThan(40);
				expect(text.length, `${b.id} ${l}`).toBeLessThan(320);
			}
		}
	});

	it('has a picture for every book, free from Commons or made with AI', () => {
		const ai = new Set(aiManifest.images.map((i) => i.id));
		for (const b of POLL_BOOKS) {
			const id = `lit_${b.id}`;
			expect(existsSync(`static/img/lit/${id}.webp`), id).toBe(true);
			// One source each: a Commons credit (assets/rights/commons.json) or the AI manifest.
			expect(Number(id in commons) + Number(ai.has(id)), id).toBe(1);
		}
	});
});
