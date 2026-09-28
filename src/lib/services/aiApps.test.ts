import { describe, expect, it } from 'vitest';
import { AI_ASSISTANTS, assistantHref } from './aiApps';

const ANDROID = 'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 Chrome/128 Mobile';
const IPHONE = 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 Safari/604.1';

const FIREFOX_ANDROID = 'Mozilla/5.0 (Android 14; Mobile; rv:128.0) Gecko/128.0 Firefox/128.0';

const gemini = AI_ASSISTANTS.find((a) => a.name === 'Gemini')!;

describe('assistantHref', () => {
	it('uses an intent URL with a web fallback on Android', () => {
		expect(assistantHref(gemini, ANDROID)).toBe(
			'intent://gemini.google.com/app#Intent;scheme=https;package=com.google.android.apps.bard;' +
				'S.browser_fallback_url=https%3A%2F%2Fgemini.google.com%2Fapp;end'
		);
	});

	it('keeps the https URL on Firefox for Android, which cannot follow intent URLs', () => {
		expect(assistantHref(gemini, FIREFOX_ANDROID)).toBe(gemini.url);
	});

	it('keeps the https URL (a Universal Link) on iOS and desktop', () => {
		expect(assistantHref(gemini, IPHONE)).toBe(gemini.url);
		expect(assistantHref(gemini, '')).toBe(gemini.url);
	});
});
