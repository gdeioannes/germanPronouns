// The gender colours, in one place so every view that shows a German noun
// agrees: the Word Library, the Help Memory reference table, and anything
// added later. Ported from the Dart brand palette.

export const GENDER_COLORS: Record<string, string> = {
	m: '#2E6FB7',
	f: '#C0446A',
	n: '#3F7D4E',
	// Plural-only nouns (die Eltern, die Leute) have no gender to show.
	pl: '#6B6558'
};

export const GENDER_ARTICLES: Record<string, string> = {
	m: 'der',
	f: 'die',
	n: 'das',
	pl: 'die'
};
