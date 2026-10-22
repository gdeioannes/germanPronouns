// Where a menu page's back arrow goes. The pages the menu opens (the word
// library, workbooks, stories, literature, songs, settings, about, the forum…)
// are side trips: their arrow returns to the page the trip started from —
// home when you came from home, your deck when you came from the deck —
// instead of a fixed "Home". Browsing between side-trip pages keeps the
// start, so Word library → Nouns → Word library → back still lands there.
// Kept in sessionStorage so a reload mid-trip remembers it.

const SIDE_TRIPS = [
	/^\/words(\/|$)/,
	/^\/stories\/?$/,
	/^\/literature\/?$/,
	/^\/songs?(\/|$)/,
	/^\/settings\/?$/,
	/^\/about\/?$/,
	/^\/contact\/?$/,
	/^\/changelog\/?$/,
	/^\/forum(\/|$)/,
	/^\/signin\/?$/,
	/^\/course\/[^/]+\/(worksheet|workbook)(\/|$)/
];

const KEY = 'returnTo';

function stored(): string {
	try {
		return sessionStorage.getItem(KEY) ?? '/';
	} catch {
		return '/';
	}
}

export const returnTo = $state({ path: '/' });

let loaded = false;

/** Called after every navigation (root layout): a page that is not a side trip becomes the way back. */
export function noteVisit(pathname: string, search = ''): void {
	if (!loaded) {
		loaded = true;
		returnTo.path = stored();
	}
	if (SIDE_TRIPS.some((re) => re.test(pathname))) return;
	returnTo.path = pathname + search;
	try {
		sessionStorage.setItem(KEY, returnTo.path);
	} catch {
		// Private window or blocked storage: the in-memory value still works.
	}
}

/** The arrow's label: "Home", "Your deck", or a plain "Back" for any other page. */
export function returnLabel(path: string): string {
	const bare = path.split(/[?#]/)[0];
	if (bare === '/' || bare === '') return 'Home';
	if (/^\/course\/[^/]+\/?$/.test(bare)) return 'Your deck';
	return 'Back';
}
