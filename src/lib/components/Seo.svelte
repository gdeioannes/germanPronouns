<script lang="ts">
	// The head tags every indexable page carries: title, description, the
	// canonical URL (the same form the sitemap lists), the social card, the
	// language links, and any structured data. One component so no route can
	// ship without them.
	//
	// Pages pass their bare path; the language comes from the address. A
	// page with Turkish and Arabic twins (/tr/…, /ar/…) links all three.
	import { page } from '$app/state';
	import { levelTranslated } from '$lib/i18n/available';
	import { stripBidi } from '$lib/i18n/bidi';
	import { PREFIX_LANGS, PREFIX_ROUTES, pathLang, withLang } from '$lib/i18n/paths';
	import {
		DEFAULT_IMAGE,
		DEFAULT_IMAGE_ALT,
		DEFAULT_LANG,
		LOCALES,
		SITE_NAME,
		absoluteUrl,
		clip,
		type Alternate
	} from '$lib/seo';

	let {
		title,
		description,
		path,
		type = 'website',
		ogTitle,
		ogDescription,
		image = DEFAULT_IMAGE,
		imageAlt = DEFAULT_IMAGE_ALT,
		noindex = false,
		lang: langProp,
		alternates: alternatesProp,
		jsonLd = []
	}: {
		title: string;
		description: string;
		path: string;
		type?: 'website' | 'article';
		ogTitle?: string;
		ogDescription?: string;
		image?: string;
		imageAlt?: string;
		noindex?: boolean;
		/** The language this page is written in. */
		lang?: string;
		/**
		 * This page's translated twins. Only listed when they exist: a
		 * hreflang pointing at a missing page does more harm than none.
		 */
		alternates?: Alternate[];
		jsonLd?: object[];
	} = $props();

	// The page's language is its address's; its own path carries the prefix.
	const pre = $derived(pathLang(page.url.pathname));
	const lang = $derived(langProp ?? pre ?? DEFAULT_LANG);
	const here = $derived(withLang(pre, path));
	// A level-bound page (a level, an exercise) has twins only for A1–A2.
	const pageLevel = $derived(page.params.levelId ?? (page.data as { quiz?: { level?: string } }).quiz?.level ?? null);
	const twinned = $derived(
		!!page.route.id && PREFIX_ROUTES.has(page.route.id) && (pageLevel === null || levelTranslated(pageLevel))
	);
	const alternates = $derived<Alternate[]>(
		alternatesProp ??
			(twinned
				? [{ lang: DEFAULT_LANG, path }, ...PREFIX_LANGS.map((l) => ({ lang: l, path: withLang(l, path) }))].filter(
						(a) => a.lang !== lang
					)
				: [])
	);
	const url = $derived(absoluteUrl(here));
	// Arabic text carries invisible direction marks around its German (bidi.ts):
	// right for the page, noise in a search result.
	const plain = stripBidi;
	const desc = $derived(plain(clip(description, 160)));
	const shownTitle = $derived(plain(title));
	const ogLocale = $derived(LOCALES[lang]?.ogLocale ?? LOCALES[DEFAULT_LANG].ogLocale);
	// hreflang is reciprocal: the page lists itself along with its twins, and
	// x-default names the version a reader of no listed language should get.
	const langLinks = $derived(
		alternates.length
			? [
					{ lang, path: here },
					...alternates,
					{ lang: 'x-default', path: [{ lang, path: here }, ...alternates].find((a) => a.lang === DEFAULT_LANG)?.path ?? here }
				]
			: []
	);
	// A closing script tag inside a JSON string would end the tag early.
	const ld = $derived(
		jsonLd.map((o) => JSON.stringify(o).replaceAll(String.fromCharCode(60), '\\u003c'))
	);
</script>

<svelte:head>
	<title>{shownTitle}</title>
	<meta name="description" content={desc} />
	{#if noindex}
		<meta name="robots" content="noindex" />
	{:else}
		<!-- Lets a result and Discover show the share image large, and a snippet
		     run as long as the engine likes. -->
		<meta name="robots" content="max-image-preview:large, max-snippet:-1" />
		<link rel="canonical" href={url} />
		{#each langLinks as link (link.lang)}
			<link rel="alternate" hreflang={link.lang} href={absoluteUrl(link.path)} />
		{/each}
	{/if}

	<meta property="og:type" content={type} />
	<meta property="og:url" content={url} />
	<meta property="og:site_name" content={SITE_NAME} />
	<meta property="og:title" content={plain(ogTitle ?? title)} />
	<meta property="og:description" content={ogDescription ? plain(ogDescription) : desc} />
	<meta property="og:image" content={image} />
	<meta property="og:image:width" content="1200" />
	<meta property="og:image:height" content="630" />
	<meta property="og:image:alt" content={imageAlt} />
	<meta property="og:locale" content={ogLocale} />
	{#each alternates as alt (alt.lang)}
		{#if LOCALES[alt.lang]}
			<meta property="og:locale:alternate" content={LOCALES[alt.lang].ogLocale} />
		{/if}
	{/each}
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content={plain(ogTitle ?? title)} />
	<meta name="twitter:description" content={ogDescription ? plain(ogDescription) : desc} />
	<meta name="twitter:image" content={image} />
	<meta name="twitter:image:alt" content={imageAlt} />

	{#each ld as json, i (i)}
		{@html `<script type="application/ld+json">${json}<\/script>`}
	{/each}
</svelte:head>
