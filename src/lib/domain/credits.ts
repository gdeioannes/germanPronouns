// Photo credits, the way the licences ask for them (docs/rights_audit.md).
//
// Every Commons photo the site and the books show is credited from the data
// Wikimedia Commons itself publishes for the file (assets/rights/commons.json,
// written by tool/commons-verify.mjs), never from a hand-copied name:
//   - the author as the author asks to be named (Commons' "Attribution" field),
//     else the artist;
//   - the licence by name and by link;
//   - a link to the file;
//   - "modified": every copy we show is cropped and warm-graded.
// CC0 and public-domain photos need none of this; they are credited all the
// same, as a courtesy and so that every picture says where it is from.
import commons from '../../../assets/rights/commons.json';
import review from '../../../assets/rights/review.json';

interface CommonsEntry {
	file: string;
	pageid: number | null;
	artist: string;
	license: string;
	licenseUrl: string;
	attribution: string | null;
}

export interface Credit {
	/** The author as they ask to be named. */
	author: string;
	/** "CC BY-SA 4.0", "CC0", "public domain". */
	license: string;
	/** The licence text, or null for the public domain. */
	licenseUrl: string | null;
	/** The file on Wikimedia Commons. */
	fileUrl: string;
	/** Short form of fileUrl for print: commons.wikimedia.org/?curid=… */
	fileShort: string;
}

const data = commons as Record<string, CommonsEntry>;
const decisions = (review as { photos: Record<string, { decision: string; credit?: string }> }).photos;

/** Commons signatures and user-page leftovers out of a name ("( talk ) 16:14, 12 November 2021 (UTC)"). */
function cleanName(s: string): string {
	return s
		.replace(/\(\s*talk(\s*·\s*contribs)?\s*\)/gi, '')
		.replace(/\d{1,2}:\d{2},\s*\d{1,2}\s+\w+\s+\d{4}\s*\(UTC\)/g, '')
		.replace(/^--/, '')
		.replace(/(Unknown author\s*)+/gi, 'Unknown author ')
		.replace(/\(\s*User:\s*([^)]+)\)/gi, '($1)')
		.replace(/^User:\s*/i, '')
		// Commons' Flickr import note ("This image was originally posted to Flickr … reviewed …") is not the author.
		.replace(/\s*This image was originally posted to Flickr[\s\S]*$/i, '')
		.replace(/\s+/g, ' ')
		.replace(/\s+\)/g, ')')
		.replace(/\(\s+/g, '(')
		.trim();
}

export function creditFor(id: string): Credit | null {
	const c = data[id];
	if (!c) return null;
	const author = decisions[id]?.credit ?? ((c.attribution ? c.attribution : cleanName(c.artist)) || 'Unknown author');
	const pd = /^public domain$/i.test(c.license);
	return {
		author,
		license: pd ? 'public domain' : c.license,
		licenseUrl: pd ? null : c.licenseUrl || null,
		fileUrl: c.pageid ? `https://commons.wikimedia.org/?curid=${c.pageid}` : `https://commons.wikimedia.org/wiki/${encodeURIComponent(c.file.replace(/ /g, '_'))}`,
		fileShort: c.pageid ? `commons.wikimedia.org/?curid=${c.pageid}` : c.file
	};
}

/** True when a photo must not ship (the zero-doubt review). */
export function photoBanned(id: string): boolean {
	// A rejected file, not a rejected id: a replaced photo keeps its id with a new file.
	const d = decisions[id];
	return d?.decision === 'replace' && d.file === (commons as Record<string, { file: string }>)[id]?.file;
}

const short = (url: string) => url.replace(/^https?:\/\//, '').replace(/\/$/, '');

/** One printed line: author, licence and its link, the file, "modified". */
export function creditLine(id: string, german = false): string | null {
	const c = creditFor(id);
	if (!c) return null;
	const lic = c.licenseUrl ? `${c.license} (${short(c.licenseUrl)})` : german ? 'gemeinfrei' : 'public domain';
	return `${c.author}, ${lic}, via Wikimedia Commons, ${c.fileShort}, ${german ? 'bearbeitet' : 'modified'}`;
}

/** The short form under a photo on screen: "Author, CC BY-SA 4.0"; the full credit is on /credits. */
export function creditShort(id: string): string | null {
	const c = creditFor(id);
	return c ? `${c.author}, ${c.license}` : null;
}
