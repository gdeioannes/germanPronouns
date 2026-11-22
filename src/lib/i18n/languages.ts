// The languages the site explains German in, as the language pickers show
// them (home picker, Settings): each name and note in its own language, so
// whoever is lost in the current one still finds theirs.
import type { UiLang } from './lang.svelte';

export interface LangOption {
	code: UiLang;
	/** The language's own name for itself. */
	name: string;
	/** What it offers, in that language. */
	note: string;
	dir: 'ltr' | 'rtl';
	/**
	 * Asked inside the course before switching to this language on a level it
	 * does not explain ({level} is the sub-level), with the two answers.
	 */
	missing: { text: string; kept: string; yes: string; no: string };
}

// After English: French, Spanish, Turkish, Ukrainian, then Arabic.
// Each note ends with the levels explained in that language: A1–A2 fully,
// above that through the explanation button (an overlay per level). The range
// must follow assets/content/<lang>/de_cert_a1/: i18n.test.ts checks it.
export const LANG_OPTIONS: LangOption[] = [
	{
		code: 'en',
		name: 'English',
		note: 'German explained in English · A1–C2',
		dir: 'ltr',
		missing: {
			text: '{level} is not explained in English yet: the explanations stay in German, and the help button shows them in English.',
			kept: 'Your progress is kept.',
			yes: 'Switch anyway',
			no: 'Cancel'
		}
	},
	{
		code: 'fr',
		name: 'Français',
		note: "L'allemand expliqué en français · A1–C2",
		dir: 'ltr',
		missing: {
			text: "Le niveau {level} n'est pas encore expliqué en français : les explications restent en allemand et le bouton d'aide les montre en anglais.",
			kept: 'La progression est conservée.',
			yes: 'Changer quand même',
			no: 'Annuler'
		}
	},
	{
		code: 'es',
		name: 'Español',
		note: 'El alemán explicado en español · A1–C2',
		dir: 'ltr',
		missing: {
			text: 'El nivel {level} todavía no se explica en español: las explicaciones siguen en alemán y el botón de ayuda las muestra en inglés.',
			kept: 'Tu progreso se conserva.',
			yes: 'Cambiar de todos modos',
			no: 'Cancelar'
		}
	},
	{
		code: 'tr',
		name: 'Türkçe',
		note: 'Türkçe açıklamalı Almanca · A1–A2',
		dir: 'ltr',
		missing: {
			text: '{level} seviyesi henüz Türkçe açıklanmıyor: açıklamalar Almanca kalır, yardım düğmesi onları İngilizce gösterir.',
			kept: 'İlerleme korunur.',
			yes: 'Yine de değiştir',
			no: 'Vazgeç'
		}
	},
	{
		code: 'uk',
		name: 'Українська',
		note: 'Німецька з поясненнями українською · A1–C2',
		dir: 'ltr',
		missing: {
			text: 'Рівень {level} ще не пояснено українською: пояснення лишаються німецькою, а кнопка допомоги показує їх англійською.',
			kept: 'Прогрес зберігається.',
			yes: 'Усе одно змінити',
			no: 'Скасувати'
		}
	},
	{
		code: 'ar',
		name: 'العربية',
		note: 'الألمانية بشرح عربي · A1–A2',
		dir: 'rtl',
		missing: {
			text: 'المستوى {level} غير مشروح بالعربية بعد: تبقى الشروح بالألمانية، ويعرضها زر المساعدة بالإنجليزية.',
			kept: 'يبقى التقدّم محفوظًا.',
			yes: 'غيّر على أي حال',
			no: 'إلغاء'
		}
	}
];

/** "Language" in every offered language, for the pickers' labels. */
export const LANGUAGE_LABEL = 'Language / Langue / Idioma / Dil / Мова / اللغة';
