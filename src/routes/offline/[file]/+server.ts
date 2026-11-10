import { error, json } from '@sveltejs/kit';
import { offlineLevel, offlineLevels } from '$lib/server/offlineLevel';
import type { EntryGenerator, RequestHandler } from './$types';

// The list "Save this level for offline" downloads: /offline/A1.1.json.
export const prerender = true;

export const entries: EntryGenerator = async () => (await offlineLevels()).map((level) => ({ file: `${level}.json` }));

export const GET: RequestHandler = async ({ params }) => {
	const level = params.file.replace(/\.json$/, '');
	if (!(await offlineLevels()).includes(level)) error(404, 'No such level');
	return json(await offlineLevel(level));
};
