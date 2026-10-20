import { describe, expect, it } from 'vitest';
import spec from '../../../assets/reference/kafka_die_verwandlung_stages.json';
import { STAGE_COUNT, kafkaStage, kafkaStages } from './kafka';

describe('Die Verwandlung online', () => {
	it('has the twelve stages of the book, each with text', () => {
		expect(STAGE_COUNT).toBe(12);
		for (const s of kafkaStages()) expect(s.words).toBeGreaterThan(500);
	});

	it('places every note on its phrase, numbered in reading order', () => {
		const authored = spec.stages.reduce((sum, s) => sum + (s.notes?.length ?? 0), 0);
		let placed = 0;
		for (let n = 1; n <= STAGE_COUNT; n++) {
			const stage = kafkaStage(n)!;
			const marked = stage.paragraphs.flat().filter((r) => r.note).map((r) => r.note);
			expect(marked).toEqual(stage.notes.map((note) => note.n));
			placed += marked.length;
		}
		expect(placed).toBe(authored);
	});

	it('keeps every glossary word and loses none of the text', () => {
		for (let n = 1; n <= STAGE_COUNT; n++) {
			const stage = kafkaStage(n)!;
			expect(stage.glossary).toHaveLength(spec.stages[n - 1].words.length);
			const words = stage.paragraphs.map((runs) => runs.map((r) => r.text).join('')).join(' ').split(' ').length;
			expect(words).toBe(stage.words);
			expect(stage.paragraphs.flat().some((r) => r.text.includes('--'))).toBe(false);
		}
	});

	it('has no stage past the last', () => {
		expect(kafkaStage(0)).toBeNull();
		expect(kafkaStage(STAGE_COUNT + 1)).toBeNull();
	});
});
