// From B1 the course leads in German and English waits to be asked for: a
// translation sitting beside every line gets read first, and then the German
// never has to be understood. Word meanings stay in English at every level
// (flashcards, tap-a-word): that is where a translation teaches best.

/** Does this level keep its translations behind a tap? Levels look like "B1.1". */
export function hidesEnglish(level: string | undefined | null): boolean {
	return !!level && /^[BC]\d/.test(level);
}
