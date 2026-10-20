import { error } from '@sveltejs/kit';
import type { EntryGenerator, PageServerLoad } from './$types';
import { STAGE_COUNT, kafkaStage } from '$lib/server/kafka';

/** One prerendered page per reading stage: /literature/die-verwandlung/stage-1 … */
export const entries: EntryGenerator = () =>
	Array.from({ length: STAGE_COUNT }, (_, i) => ({ stage: `stage-${i + 1}` }));

export const load: PageServerLoad = ({ params }) => {
	const n = Number(/^stage-(\d+)$/.exec(params.stage)?.[1]);
	const stage = kafkaStage(n);
	if (!stage) error(404, 'No such stage');
	return { stage, count: STAGE_COUNT };
};
