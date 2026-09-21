# site — the SvelteKit port

The learner app, being ported from Flutter (`../lib`) to SvelteKit.

```bash
npm install
npm run dev      # local dev server
npm test         # domain-logic unit tests
npm run check    # typecheck
npm run build    # prerender every route into build/
```

## Why this exists

The Flutter web build shipped a renderer before it shipped any content:
~6.3 MB of `main.dart.js` plus 3.5–6.9 MB of CanvasKit/skwasm wasm, and it
painted into a canvas, so crawlers saw nothing and `web/index.html` had to
carry a hand-maintained copy of the landing copy and JSON-LD. This build is
~35 KB gzipped on first load and prerenders one real HTML page per quiz.

## Shared content, not copied content

Both apps read the same JSON in `../assets/content/**`, aliased here as
`$content`. Regenerate it the same way as before:

```bash
cd .. && dart run tool/generate_content.dart
```

Nothing is re-authored during the port, and the two apps cannot drift.

## Layout

| Path | What lives there |
| --- | --- |
| `src/lib/content/` | The content contract (`types.ts`) and the loaders |
| `src/lib/domain/` | Pure ported rules: tiers, gating, answers, shuffle bag, the speaking prompt builder. No framework imports — unit-tested, and portable to a Capacitor build untouched |
| `src/lib/services/` | The platform seams: `speech.ts` (TTS/STT) and `storage.ts` |
| `src/lib/state/` | `progress.svelte.ts` — the rune store for learner progress |
| `src/lib/components/quiz/` | One renderer per quiz type |
| `src/routes/` | Prerendered pages |

## Storage compatibility

`src/lib/domain/keys.ts` mirrors the Dart storage keys verbatim. A learner who
used the Flutter build in the same browser keeps their scores, streaks and
unlocked levels. **Never rename one of those keys.**

## Going mobile later

Everything platform-touching sits behind `TtsProvider`, `SttProvider` and
`KeyValueStore`. Wrapping with Capacitor means adding one implementation per
interface — a native TTS plugin, a native speech-recognition plugin (Web Speech
recognition is unreliable in iOS WKWebView), and Preferences instead of
`localStorage` (WKWebView can evict it). No component changes.

## Not ported yet

- PDF worksheet export (`../lib/theme/exercise_sheet_pdf.dart`)
- The teacher back office (`../lib/pages/back_office/`)
- Analytics
