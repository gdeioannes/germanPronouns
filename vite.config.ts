import adapter from '@sveltejs/adapter-static';
import { sveltekit } from '@sveltejs/kit/vite';
import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';

// The content bundles: typed JSON, one per course, plus the shared noun and
// verb collections. Aliased rather than imported by relative path so a route
// five folders deep still says `$content/...`.
const content = fileURLToPath(new URL('./assets/content', import.meta.url));

export default defineConfig({
	resolve: { alias: { $content: content } },
	// `assets/` sits outside the folders SvelteKit's dev server serves from
	// (src, static, node_modules), so dev 404s the course bundles without this.
	// The production build doesn't care: bundles are imported at prerender time.
	server: { fs: { allow: [content] } },
	plugins: [
		sveltekit({
			// Declared here (not as a hand-written tsconfig `paths` entry) so
			// SvelteKit generates the TypeScript mapping alongside $lib.
			alias: { $content: content },
			compilerOptions: {
				// Force runes mode for the project, except for libraries.
				runes: ({ filename }) =>
					filename.split(/[/\\]/).includes('node_modules') ? undefined : true
			},

			// Fully static output: every route is prerendered to real HTML at build
			// time and served from GitHub Pages, so crawlers see the content itself.
			adapter: adapter({ fallback: '404.html' })
		})
	]
});
