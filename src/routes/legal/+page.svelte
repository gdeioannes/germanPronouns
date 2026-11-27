<script lang="ts">
	// Imprint (Impressum, §5 DDG) and privacy notice (Art. 13 GDPR). One page,
	// linked from every footer. The postal address below is still a placeholder:
	// a German imprint needs a "ladungsfähige Anschrift" (a real street address
	// that can receive served mail — a P.O. box is not enough). GDI is deciding
	// between the home address and a virtual-address service.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { breadcrumbLd } from '$lib/seo';
	import { page } from '$app/state';
	import { OPERATOR } from '$lib/operator';

	// The operator's name and address live in $lib/operator (the books print them too).

	const UPDATED = '2026-11-27';
</script>

<Seo
	title="Legal and privacy — Language Quiz"
	description="Imprint and privacy notice for Language Quiz: who runs the site, what is stored, and which services are involved."
	path="/legal"
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Legal and privacy', path: '/legal' }])]}
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>
	<h1>Legal and privacy</h1>
	<p class="lede">
		Who runs Language Quiz, and what happens with your data. Short version: no cookies,
		no advertising, no tracking across sites. Your learning progress stays in your browser
		unless you sign in.
	</p>

	<nav class="toc" aria-label="On this page">
		<a href="#imprint">Imprint</a>
		<a href="#privacy">Privacy notice</a>
		<a href="#newsletter">Newsletter</a>
		<a href="#forum">Forum</a>
		<a href="#rights">Your rights</a>
	</nav>

	<section id="imprint">
		<h2>Imprint <span class="de" lang="de">(Impressum)</span></h2>
		<p>Information according to §&nbsp;5 DDG (Digitale-Dienste-Gesetz):</p>
		<address>
			{OPERATOR.name}<br />
			{OPERATOR.street}<br />
			{OPERATOR.city}<br />
			{OPERATOR.country}
		</address>
		<p>
			Email: <a href="mailto:{OPERATOR.email}">{OPERATOR.email}</a>
		</p>
		<p>
			Responsible for the content according to §&nbsp;18 Abs.&nbsp;2 MStV: {OPERATOR.name}, address as above.
		</p>
		<p>
			Language Quiz is a private, non-commercial project. It is an independent study aid, not
			affiliated with or endorsed by any examination body, publisher or language institute.
		</p>
		<h3>Dispute resolution</h3>
		<p>
			The European Commission provides a platform for online dispute resolution at
			<a href="https://ec.europa.eu/consumers/odr" rel="noopener">ec.europa.eu/consumers/odr</a>.
			We are neither obliged nor willing to take part in dispute-resolution proceedings before a
			consumer arbitration board.
		</p>
	</section>

	<section id="privacy">
		<h2>Privacy notice <span class="de" lang="de">(Datenschutzerklärung)</span></h2>
		<p>
			The controller in the sense of the General Data Protection Regulation (GDPR) is the person
			named in the imprint above. Last updated: <time datetime={UPDATED}>27 November 2026</time>.
		</p>

		<h3>1. What the site itself stores</h3>
		<p>
			The site sets no cookies. Your settings, scores, streaks and medals are kept in your
			browser's local storage and never leave it. You can delete them at any time under
			<a href="/settings">Settings → Start over</a>, or by clearing the site's data in your
			browser.
		</p>

		<h3>2. Hosting (GitHub Pages)</h3>
		<p>
			The site is served as static files by GitHub Pages, a service of GitHub, Inc., 88 Colin P
			Kelly Jr St, San Francisco, CA 94107, USA. When you open a page, your browser sends the
			request to GitHub's servers, which may log your IP address, the page requested, the time,
			and your browser's identification string for security and operation of the service. GitHub
			takes part in the EU-US Data Privacy Framework. Legal basis: Art.&nbsp;6(1)(f) GDPR, our
			legitimate interest in running the site reliably. See
			<a href="https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement" rel="noopener">GitHub's privacy statement</a>.
		</p>

		<h3>3. Usage statistics (Aptabase)</h3>
		<p>
			To see which parts of the course are used, the site sends anonymous events (for example
			"an exercise was finished", "a page was opened", and whether the visit came from a search
			engine or a shared link) to Aptabase, hosted in the European Union. No cookie and no
			identifier is set; the only thing kept on your device for this purpose is the date of your
			first visit, so that new and returning visitors can be told apart in aggregate. IP addresses
			are not stored by Aptabase. Legal basis: Art.&nbsp;6(1)(f) GDPR, our legitimate interest in
			improving the course. Statistics are sent only after you actually tap something on a page,
			so a page merely opened is never counted. A browser content blocker stops them entirely,
			and the site works the same without them.
		</p>

		<h3>4. Optional account (Firebase)</h3>
		<p>
			You can use everything without an account. If you choose to sign in, your email address is
			sent to Firebase Authentication to send you a sign-in link, and your scores and medals are
			stored in Cloud Firestore so they follow you to another device. Firebase is a service of
			Google Ireland Limited, Gordon House, Barrow Street, Dublin 4, Ireland; data may be
			processed on Google servers outside the EU under the EU-US Data Privacy Framework and
			standard contractual clauses. What is stored: your email address, a technical user ID, the
			time of sign-in, and your learning progress (which exercises you finished and your scores).
			Legal basis: Art.&nbsp;6(1)(b) GDPR, providing the sync you asked for. Signing out under
			<a href="/settings">Settings</a> stops the backup but keeps the data for your next visit.
			Under <a href="/settings#your-data">Settings → Your data</a> you can close the account
			yourself at any time: that deletes your synced progress, your forum name, topics, replies and
			likes, and your sign-in address, straight away. (Likes given before 11 November 2026 can't
			be found automatically; write to us and we remove them.) You can also write to the address
			in the imprint and we delete it for you within a few days.
		</p>

		<h3>5. Spoken audio (text-to-speech)</h3>
		<p>
			Most German you hear is pre-recorded and served as static files, which involves no personal
			data. For text that is not recorded yet, the site can ask a text-to-speech service to read
			it. That request goes through a relay we run on Cloudflare Workers (Cloudflare, Inc., 101
			Townsend St, San Francisco, CA 94107, USA) to Google Cloud Text-to-Speech or Microsoft Azure
			Speech. Only the German text to be read and your IP address, as part of any web request,
			are transmitted; nothing is stored by us. Under
			<a href="/settings">Settings → Voice</a> you can choose "offline only", and then the
			browser's own voice is used instead and nothing is sent. Legal basis: Art.&nbsp;6(1)(f)
			GDPR, providing audio for every exercise.
		</p>

		<h3>6. Links to other sites</h3>
		<p>
			The site links to other websites, for example to Amazon for the printed books and to
			Wikimedia Commons for picture sources. Those sites have their own privacy notices; nothing is
			loaded from them until you follow a link.
		</p>

		<h3>7. Problem reports and contact</h3>
		<p>
			If you write to us by email, we keep the message as long as needed to answer it and to
			fix what it reports, and then delete it. Legal basis: Art.&nbsp;6(1)(f) GDPR.
		</p>

		<h3 id="feedback">8. Ratings and feedback</h3>
		<p>
			In some places the site asks what you think: a star rating for the site, for a book or for a
			grammar chart, with a box for a comment, and, when you download a book, who it is for.
			Answering is voluntary and needs no account. What is stored when you answer: the stars, the
			text you write, the page you were on, the book or chart it is about, the site language and
			the time. No name, email address or user ID is stored with it, so we cannot tell who gave an
			answer; please do not write personal details into the box. If you offer a sentence about a
			book for publication and tick the box that allows it, that sentence, with the first name you
			give, may be shown on the books page until you ask us to take it down. The answers are kept
			in Cloud Firestore (Google Ireland Limited, see section 4) and are read only by the operator
			of this site. Legal basis: Art.&nbsp;6(1)(f) GDPR, our legitimate interest in finding
			mistakes and improving the material; for a published sentence, your consent, Art.&nbsp;6(1)(a)
			GDPR, which you can withdraw at any time. To have an answer deleted, write to the address in
			the imprint and say what you wrote and roughly when, so that we can find it.
		</p>
	</section>

	<section id="newsletter">
		<h2>Newsletter</h2>
		<p>
			You can sign up for a weekly email about what is new in the course. Signing up is voluntary
			and separate from the optional account: an address used to sign in is never added to the
			newsletter.
		</p>
		<p>
			<strong>What is stored:</strong> your email address, and as proof of your consent the time of
			signing up and of confirming, and the IP address it was done from. Nothing else is asked for.
		</p>
		<p>
			<strong>Double opt-in:</strong> after you sign up you get one email with a link. Only when you
			click it is your address put on the list. If you don't click, no newsletter is sent.
		</p>
		<p>
			<strong>Service provider:</strong> the sign-up form and the emails are handled by Brevo
			(Sendinblue SAS, 9-17 rue Salneuve, 75017 Paris, France), which stores the data in the
			European Union and processes it on our behalf under a data processing agreement
			(Art.&nbsp;28 GDPR). The form sends your entry straight to Brevo; nothing from Brevo is loaded
			on this site before you press Subscribe. Brevo may also use some of the data itself to keep its
			platform secure, see <a href="https://www.brevo.com/legal/privacypolicy/" rel="noopener">Brevo's
			privacy policy</a>.
		</p>
		<p>
			<strong>Delivery statistics:</strong> Brevo records whether an email was delivered and may
			record whether it was opened and which links in it were clicked. We look at these figures only
			in total, to see whether the newsletter is useful, never per person.
		</p>
		<p>
			<strong>Legal basis and unsubscribing:</strong> your consent, Art.&nbsp;6(1)(a) GDPR. You can
			withdraw it at any time with the unsubscribe link at the end of every email, or by writing to
			the address in the imprint. Your address is then taken off the list straight away; the record
			that you once consented and then withdrew is kept as long as we may need to prove it, and no
			longer than three years.
		</p>
	</section>

	<section id="forum">
		<h2>Forum</h2>
		<p>
			Posting in the forum needs the optional account above. A post stores the name you chose,
			your technical user ID, the text, and the time. Posts are public: anyone can read them,
			with or without an account, and they can be found by search engines. You can delete your
			own posts and topics at any time; a moderator may remove posts that break the
			<a href="/forum">house rules</a>. Likes are stored with your user ID so that you can take
			them back.
		</p>
	</section>

	<section id="rights">
		<h2>Your rights</h2>
		<p>
			Under the GDPR you have the right to information about the personal data we hold about you
			(Art.&nbsp;15), to rectification (Art.&nbsp;16), to erasure (Art.&nbsp;17), to restriction of
			processing (Art.&nbsp;18), to data portability (Art.&nbsp;20), and to object to processing
			based on legitimate interest (Art.&nbsp;21). You also have the right to complain to a
			supervisory authority; in Germany, the data-protection authority of your federal state.
			<a href="/settings#your-data">Settings → Your data</a> lets you download everything stored
			about you as one file (Art.&nbsp;15 and 20) and close your account (Art.&nbsp;17) without
			writing to anyone. Write to the address in the imprint for any of the others.
		</p>
	</section>
</main>

<SiteFooter />

<style>
	.toc {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem 1.2rem;
		margin: 0 0 2rem;
		font-size: var(--step--1);
	}

	section {
		margin: 0 0 2.5rem;
	}

	h2 {
		margin: 0 0 0.75rem;
	}

	h3 {
		margin: 1.4rem 0 0.4rem;
		font-size: var(--step-0);
	}

	.de {
		font-weight: 400;
		color: var(--ink-muted);
	}

	address {
		font-style: normal;
		line-height: 1.5;
		margin: 0 0 0.75rem;
	}

	p {
		max-width: 68ch;
	}
</style>
