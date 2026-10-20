import type { PageServerLoad } from './$types';
import { REGIONAL, SPELLING, kafkaStages } from '$lib/server/kafka';

export const load: PageServerLoad = () => ({
	stages: kafkaStages(),
	spelling: SPELLING,
	regional: REGIONAL
});
