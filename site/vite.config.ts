import adapter from '@sveltejs/adapter-static';
import { sveltekit } from '@sveltejs/kit/vite';
import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';

// The content bundles live outside this project, in the repo's shared
// `assets/content/` — the same files the Flutter app ships. Aliasing rather
// than copying keeps one source of truth while both apps are alive.
const content = fileURLToPath(new URL('../assets/content', import.meta.url));

export default defineConfig({
	resolve: { alias: { $content: content } },
	// Vite refuses to serve files above the project root unless told to.
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
			// time and served from GitHub Pages. This is what makes crawlers see the
			// content directly, instead of the hand-maintained pre-render block the
			// Flutter build needs in web/index.html.
			adapter: adapter({ fallback: '404.html' })
		})
	]
});
