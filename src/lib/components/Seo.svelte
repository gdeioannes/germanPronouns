<script lang="ts">
	// The head tags every indexable page carries: title, description, the
	// canonical URL (the same form the sitemap lists), the social card, the
	// language links, and any structured data. One component so no route can
	// ship without them.
	import {
		DEFAULT_IMAGE,
		DEFAULT_IMAGE_ALT,
		DEFAULT_LANG,
		LOCALES,
		SITE_NAME,
		absoluteUrl,
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
		lang = DEFAULT_LANG,
		alternates = [],
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

	const url = $derived(absoluteUrl(path));
	const ogLocale = $derived(LOCALES[lang]?.ogLocale ?? LOCALES[DEFAULT_LANG].ogLocale);
	// hreflang is reciprocal: the page lists itself along with its twins, and
	// x-default names the version a reader of no listed language should get.
	const langLinks = $derived(
		alternates.length
			? [
					{ lang, path },
					...alternates,
					{ lang: 'x-default', path: [{ lang, path }, ...alternates].find((a) => a.lang === DEFAULT_LANG)?.path ?? path }
				]
			: []
	);
	// A closing script tag inside a JSON string would end the tag early.
	const ld = $derived(
		jsonLd.map((o) => JSON.stringify(o).replaceAll(String.fromCharCode(60), '\\u003c'))
	);
</script>

<svelte:head>
	<title>{title}</title>
	<meta name="description" content={description} />
	{#if noindex}
		<meta name="robots" content="noindex" />
	{:else}
		<link rel="canonical" href={url} />
		{#each langLinks as link (link.lang)}
			<link rel="alternate" hreflang={link.lang} href={absoluteUrl(link.path)} />
		{/each}
	{/if}

	<meta property="og:type" content={type} />
	<meta property="og:url" content={url} />
	<meta property="og:site_name" content={SITE_NAME} />
	<meta property="og:title" content={ogTitle ?? title} />
	<meta property="og:description" content={ogDescription ?? description} />
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
	<meta name="twitter:title" content={ogTitle ?? title} />
	<meta name="twitter:description" content={ogDescription ?? description} />
	<meta name="twitter:image" content={image} />
	<meta name="twitter:image:alt" content={imageAlt} />

	{#each ld as json, i (i)}
		{@html `<script type="application/ld+json">${json}<\/script>`}
	{/each}
</svelte:head>
