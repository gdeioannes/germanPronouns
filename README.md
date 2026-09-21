# Language Quiz

A free German course for English speakers: 214 interactive exercises — fill-in,
reading, listening, dictation, listen-and-repeat and AI speaking practice —
with audio on every sentence and a gated CEFR ladder. Published at
[languagequiz.org](https://languagequiz.org).

A SvelteKit app, prerendered to static HTML and served from GitHub Pages. It
replaced a Flutter build that shipped ~10 MB of renderer before any content and
painted into a canvas, so crawlers saw nothing; this one is ~35 KB gzipped on
first load and prerenders one real page per exercise.

**This README is developer documentation** — how to run, test, build and deploy.

## Common commands

```bash
npm install
npm run dev      # local dev server
npm test         # domain-logic unit tests
npm run check    # typecheck (svelte-check)
npm run build    # prerender every route into build/
npm run preview  # serve that build locally
```

## Project structure

```
src/
  lib/content/     # The content contract (types.ts) and the bundle loaders
  lib/domain/      # The pure rules: tiers, gating, answer + speech matching,
                   #   the shuffle bag, the speaking prompt, the worksheet
                   #   builder. No framework imports — unit-tested, and
                   #   portable to a Capacitor build untouched
  lib/services/    # The platform seams: speech.ts (TTS/STT), storage.ts,
                   #   analytics.ts
  lib/state/       # progress.svelte.ts — the rune store for learner progress
  lib/components/  # One renderer per quiz type, plus shared UI
  routes/          # The prerendered pages
assets/content/    # The course content: typed JSON, one bundle per course,
                   #   plus the shared noun and verb collections
static/            # Favicons, the PWA manifest, robots.txt, the social card
cloudflare-tts-proxy/  # The Worker that holds the cloud TTS keys
```

## Content

`assets/content/` is the source of truth: `catalog.json` lists the courses and
`courses/<id>.json` carries one course's nav and every quiz, typed by
`src/lib/content/types.ts`. It is imported through the `$content` alias, so the
catalog is baked into the prerendered HTML and each course bundle is loaded
only by its own route.

Editing content means editing that JSON. (It used to be generated from Dart
sources by `tool/generate_content.dart`; that generator went with the Flutter
app.) The build prerenders every quiz, so a bundle no renderer can handle fails
CI rather than shipping a blank page.

## Storage compatibility

`src/lib/domain/keys.ts` mirrors the Dart storage keys verbatim. A learner who
used the Flutter build in the same browser keeps their scores, streaks and
unlocked levels. **Never rename one of those keys.**

## Speech

`src/lib/services/speech.ts` is a chain: the premium neural voice via the
Cloudflare Worker in `cloudflare-tts-proxy/` first, the browser's own voice
when it can't answer — offline, CORS-blocked, or the settings page's "use this
device's voice only" ticked. The Worker holds the Azure/Google keys server-side
(`wrangler secret put ...`); nothing secret ships in the bundle. Its
`ALLOWED_ORIGINS` list is why an origin that isn't the live site falls back to
the device voice.

Recognition uses the Web Speech API, which Chrome supports and Safari only
partly, so every speaking exercise also offers a play-through path.

## Analytics

Cookieless usage analytics (Aptabase), posted straight to the ingestion API:
no cookie, no persistent identifier, no personal data — which is why there is
no consent banner. Disable it for a build with an empty
`PUBLIC_APTABASE_APP_KEY`.

## Deploying

`.github/workflows/deploy-site.yml` typechecks, tests, builds and publishes
`build/` to GitHub Pages on every push to `main`; pull requests run everything
but the deploy. The apex domain is bound by the `CNAME` the workflow writes.

## Going mobile later

Everything platform-touching sits behind `TtsProvider`, `SttProvider` and
`KeyValueStore`. Wrapping with Capacitor means adding one implementation per
interface — a native TTS plugin, a native speech-recognition plugin (Web Speech
recognition is unreliable in iOS WKWebView), and Preferences instead of
`localStorage` (WKWebView can evict it). No component changes.
