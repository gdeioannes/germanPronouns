import commons from '../../../assets/rights/commons.json';
import { creditFor, creditLine, photoBanned } from '$lib/domain/credits';
import type { PageServerLoad } from './$types';

// Every Commons photo the site and the books show, with the credit its licence
// asks for (domain/credits). Each short credit under a photo links here (#id).
export const load: PageServerLoad = () => {
	const photos = Object.entries(commons as Record<string, { file: string }>)
		.filter(([id]) => !photoBanned(id))
		.map(([id, c]) => ({
			id,
			title: c.file.replace(/^File:/, '').replace(/\.[a-z]+$/i, ''),
			line: creditLine(id)!,
			fileUrl: creditFor(id)!.fileUrl,
			licenseUrl: creditFor(id)!.licenseUrl
		}))
		.sort((a, b) => a.title.localeCompare(b.title, 'de'));
	return { photos };
};
