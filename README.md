# Germanquiz

A Flutter app for learning German, from single-word grammar drills up to a full
**A1–C2 certification course**. It pairs quick, repeatable fill-in-the-blank
quizzes (pronoun case endings, `der`/`die`/`das` articles, noun genders) with
listening, dictation, reading-comprehension and "speak & repeat" pronunciation
exercises, all read aloud by a premium cloud voice.

## Features

### Grammar drills

- **Pronoun Quiz** — personal, reflexive, and possessive pronouns across
  accusative, dative, and genitive case, with a built-in reference ("Help
  Memory") of pronoun and article ending tables.
- **Artikel Quiz** — practice choosing `der`/`die`/`das` for German nouns.
- **Nouns & Articles** — a guided progression through ~30 themed noun
  categories (kitchen, animals, professions, weather, etc.), unlocked one at
  a time by reaching a 10-answer streak, finishing with an "All Nouns" final
  challenge.
- **Prepositions** and other targeted grammar sets.

### Certification course (A1 → C2)

- A gated CEFR progression covering every sub-level (A1.1 … C2.2). Passing a
  quiz unlocks the next link in the chain, so learners move through the course
  in order.
- **Multiple quiz kinds** (`QuizKind`): `fillBlank`, `reading`
  (multiple-choice comprehension), `listening`, `dictation` (type what you
  hear), and `speakRepeat` (listen, then repeat into the mic — uses
  speech-to-text, never required to advance).
- Quizzes are **config-driven and data-seeded**: shipped content lives in
  `assets/seed/quiz_content.json` and is stamped with a version
  (`kDataVersion`); bumping it auto-reseeds installs on next launch.

### Across the app

- **Sentence context** — questions are presented in example sentences. Tap any
  recognized noun to see its article, gender-colored display, English
  translation, and (where applicable) its plural ending in dictionary notation
  (e.g. `-e`, `¨-er`, `-n`).
- **Sentence Info panel** — a per-question grammar explanation (case, meaning,
  and the reasoning behind the correct answer).
- **Word Library** — browse all nouns by category, with English meanings and
  gender coloring.
- **Premium voice** — phrases are spoken by a cloud neural voice (Azure, with
  Google as fallback), degrading gracefully to the on-device voice offline.
  See [Cloud TTS & the Wrangler proxy](#cloud-tts--the-wrangler-proxy).
- **Progress tracking** — score, streak, answer history, and a per-category
  performance heatmap, persisted locally via `shared_preferences`.
- **Back office** — a teacher login over a local (sembast) database for
  authoring quizzes and editing the navigation layout.
- **PDF export** — export the Help Memory reference tables as a branded PDF.

## Project structure

```
lib/
  app_router.dart   # go_router routes (param routes keyed by path param)
  data/             # Static + seeded content: nouns, pronouns, articles,
                    #   sentences, prepositions, the quest/certification
                    #   chains (quest/), course catalog, and the local DB seam
  models/           # QuizConfig, QuizContent/QuizKind, NounSettings, etc.
  pages/            # Top-level pages (the quiz kinds, library, settings,
                    #   back office)
  widgets/          # Shared UI: QuizPage core, AppDrawer, VoiceStatusChip,
                    #   fireworks
  services/tts/     # Premium cloud TTS → on-device fallback chain
  l10n/             # Localized UI strings
  theme/            # App-wide visual theme (brand palette, fonts)
cloudflare-tts-proxy/  # Cloudflare Worker that holds the cloud TTS keys (web)
```

## Getting started

This is a standard Flutter project.

```bash
flutter pub get
flutter run
```

With no TTS keys configured the app still runs — the cloud voices self-disable
and playback falls back to the on-device voice. To check for issues without
running:

```bash
flutter analyze
```

> Note: `flutter analyze` treats lint **infos** as failures in this project, so
> keep the analyzer clean.

## Local development

### Run with the premium cloud voice (desktop / mobile)

On native targets the keys are not shipped publicly, so the app calls Azure /
Google directly. Put the keys in a **gitignored** `tts_secrets.json` at the repo
root:

```json
{
  "AZURE_TTS_KEY": "…",
  "AZURE_TTS_REGION": "germanywestcentral",
  "GOOGLE_TTS_KEY": "…"
}
```

Then pass it at launch:

```bash
flutter run --dart-define-from-file=tts_secrets.json
```

### Run the web app against the Wrangler proxy

On **web** the keys must never be baked into the JS bundle, so the app routes
TTS through the Cloudflare Worker instead and is pointed at it with the
`TTS_PROXY_URL` define (a URL, not a secret).

Against the **deployed** Worker:

```bash
flutter run -d chrome --web-port=8080 --dart-define=TTS_PROXY_URL=https://german-tts-proxy.gdeioannes.workers.dev
```

Against a **local** Worker (full local loop — see the proxy setup below). In one
terminal start the Worker, in another start Flutter pointed at it:

```bash
# terminal 1 — serves http://localhost:8787
cd cloudflare-tts-proxy
npm run dev

# terminal 2 — repo root
flutter run -d chrome --web-port=8080 --dart-define=TTS_PROXY_URL=http://localhost:8787
```

> `--web-port=8080` is deliberate: the Worker only answers origins in its
> `ALLOWED_ORIGINS` allowlist, which already includes `http://localhost:8080`
> (see `cloudflare-tts-proxy/wrangler.toml`). If you serve the web app on a
> different port, add that origin there or the proxy will CORS-block it.

When the proxy is reachable the in-app voice status chip shows **"HD voice ·
Cloud"**; otherwise it falls back to the on-device voice.

## Cloud TTS & the Wrangler proxy

The `cloudflare-tts-proxy/` directory is a tiny [Cloudflare
Worker](https://developers.cloudflare.com/workers/) (managed with
[Wrangler](https://developers.cloudflare.com/workers/wrangler/)) that exists so
the **published web app never ships the cloud keys**. The browser POSTs
`{ "text": "…", "locale": "de-DE" }`; the Worker adds the secret key, calls Azure
(then Google as fallback), and returns `audio/mpeg`.

```bash
cd cloudflare-tts-proxy
npm install
npx wrangler login                       # free Cloudflare account, no card
npx wrangler secret put AZURE_TTS_KEY    # set the secrets in Cloudflare
npx wrangler secret put GOOGLE_TTS_KEY
npm run dev                              # local: http://localhost:8787
npm run deploy                           # or: npx wrangler deploy
```

Non-secret config (the Azure region, the CORS allowlist) lives in
`wrangler.toml`. See [`cloudflare-tts-proxy/README.md`](cloudflare-tts-proxy/README.md)
for the full setup, secret list, and how to test the Worker with `curl`.

## Deployment

The web app deploys to GitHub Pages via
[`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml) on
push to `main`. The build sets the project sub-path and the proxy URL:

```bash
flutter build web --release --base-href "/germanPronouns/" --dart-define=TTS_PROXY_URL=https://german-tts-proxy.gdeioannes.workers.dev
```

## Tech stack

- Flutter / Dart, Material 3
- `go_router` for navigation
- `shared_preferences` for progress; `sembast` for the back-office content DB
- `flutter_tts`, `audioplayers`, and `speech_to_text` for the voice features
- `google_fonts` (Source Serif 4 + Inter) for the app's editorial look
- `flutter_colorpicker` for gender color customization
- `pdf` / `printing` for exporting reference tables
- A Cloudflare Worker (`wrangler`) as the server-side TTS proxy for web
