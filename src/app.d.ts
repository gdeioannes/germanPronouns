// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		interface PageState {
			/** A book page's quiz list switched to another page of the chapter without loading (shallow routing). */
			bookPart?: string;
		}
		// interface Platform {}
	}
}

export {};
