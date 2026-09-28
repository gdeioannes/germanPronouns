// Links to the AI assistants the speaking exercise hands off to, opening the
// native app when the learner has it installed.
//
// A web page cannot ask which apps are installed, so each platform does the
// check for us:
// - Android Chrome (and other Chromium browsers): an intent:// URL naming
//   the app's package. Chrome launches the app if it is installed, otherwise
//   follows S.browser_fallback_url to the web version. Firefox for Android
//   does not know the scheme (and ignores the fallback), so it gets the
//   plain https URL, which Android App Links open in the app anyway.
// - iOS: the plain https URL. All three domains are Universal Links, so
//   Safari opens the app when installed and the site when not. (Custom URL
//   schemes would show a "cannot open page" error when the app is missing.)
// - Desktop: the plain https URL.

export interface AiAssistant {
	name: string;
	url: string;
	androidPackage: string;
}

export const AI_ASSISTANTS: AiAssistant[] = [
	{ name: 'Claude', url: 'https://claude.ai/new', androidPackage: 'com.anthropic.claude' },
	{ name: 'ChatGPT', url: 'https://chatgpt.com/', androidPackage: 'com.openai.chatgpt' },
	{
		name: 'Gemini',
		url: 'https://gemini.google.com/app',
		androidPackage: 'com.google.android.apps.bard'
	}
];

/** Android in a Chromium browser — the only place an intent:// URL works. */
export function isAndroidChromium(userAgent: string): boolean {
	return /Android/i.test(userAgent) && /Chrome\//i.test(userAgent) && !/Firefox/i.test(userAgent);
}

/** The href that opens the assistant's app if installed, its website if not. */
export function assistantHref(ai: AiAssistant, userAgent: string): string {
	if (!isAndroidChromium(userAgent)) return ai.url;
	const { host, pathname, search } = new URL(ai.url);
	return (
		`intent://${host}${pathname}${search}#Intent;scheme=https;` +
		`package=${ai.androidPackage};` +
		`S.browser_fallback_url=${encodeURIComponent(ai.url)};end`
	);
}
