/**
 * Whether a key event came from inside an open Sheet (or any modal dialog).
 * The quiz components listen on the window; a key pressed while reading the
 * notes must scroll the notes, not drive the exercise behind the scrim.
 */
export function inDialog(target: EventTarget | null): boolean {
	const el = target as HTMLElement | null;
	return !!el?.closest?.('[role="dialog"], dialog[open]');
}
