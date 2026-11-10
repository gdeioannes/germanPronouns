// The adapter's SPA fallback (build/404.html, served by GitHub Pages for any
// unknown address and for the one non-prerendered route, a forum topic) is an
// empty shell until the app boots: no title, no visible text. This runs after
// `vite build` and gives it a head and a static "Page not found" body, so a
// bad link shows a real page even before (or without) JavaScript. When the
// router then renders a live route into the same container, the placeholder
// is removed.
import { readFileSync, writeFileSync } from 'node:fs';

const path = 'build/404.html';
const html = readFileSync(path, 'utf8');
if (html.includes('id="nf"')) process.exit(0);

const head = `<title>Page not found — Language Quiz</title>
		<meta name="robots" content="noindex" />`;

const body = `<div id="nf" style="font-family: system-ui, sans-serif; max-width: 34rem; margin: 18vh auto 0; padding: 0 16px; line-height: 1.5">
			<h1 style="font-size: 1.6rem; margin: 0 0 0.5rem">Page not found</h1>
			<p style="margin: 0 0 1rem">This address does not lead to a page. The start page lists everything the site has.</p>
			<p style="margin: 0"><a href="/" style="color: inherit">Back to the start</a></p>
		</div>
		<script>
			// The app mounts into the same container; once anything else
			// appears beside the placeholder, the placeholder goes.
			(() => {
				const nf = document.getElementById('nf');
				const host = nf.parentNode;
				new MutationObserver(() => {
					if ([...host.children].some((c) => c !== nf && c.tagName !== 'SCRIPT')) nf.remove();
				}).observe(host, { childList: true });
			})();
		</script>`;

const out = html
	.replace('</head>', `	${head}\n	</head>`)
	.replace('<div style="display: contents">', `<div style="display: contents">\n		${body}`);

if (!out.includes('id="nf"')) {
	console.error('patch-404: could not find the body container in build/404.html');
	process.exit(1);
}
writeFileSync(path, out);
console.log('patch-404: 404.html now has a title and a static not-found body');
