# Germanquiz

A Flutter language-learning app running on web, mobile and desktop, built
around a local content database, a cloud text-to-speech chain with an on-device
fallback, and a teacher back office for authoring content.

**This README is developer documentation** — how to run, test, build and deploy
the app.

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

Quizzes are config-driven and data-seeded rather than hand-built pages: each is
a `QuizContent` of some `QuizKind` (`fillBlank`, `reading`, `listening`,
`dictation`, `speakRepeat`, `draw`), authored in `lib/data/` and published into
`assets/content/**` and `assets/seed/quiz_content.json` by the two generators
below. The seed carries a `kDataVersion` stamp; bumping it reseeds existing
installs on next launch.

## Common commands

A standard Flutter project — all commands run from the repo root. Examples use
`bash`; where Windows PowerShell needs different syntax it is called out.

### Run the app

The everyday command — Chrome on port 8080, with the premium cloud voice served
by the deployed Wrangler proxy:

```bash
flutter run -d chrome --web-port=8080 --dart-define=TTS_PROXY_URL=https://german-tts-proxy.gdeioannes.workers.dev
```

`--web-port=8080` is not optional: the Worker only answers origins on its
`ALLOWED_ORIGINS` allowlist, and `http://localhost:8080` is already on it. On
any other port the proxy CORS-blocks the app and the voice silently falls back
to the on-device one.

Other targets:

```bash
flutter pub get              # after cloning, or whenever pubspec changes
flutter devices              # list the devices you can target
flutter run                  # default device, debug mode
flutter run -d chrome        # web, no cloud voice
flutter run -d windows       # Windows desktop
flutter run -d <deviceId>    # a specific device from `flutter devices`
flutter run --release        # without debug overhead (no hot reload)
```

With no TTS defines the app still runs — the cloud voices self-disable and
playback falls back to the on-device voice. For the native cloud-voice setup and
a fully local proxy loop, see [Local development](#local-development).

### Hot reload and hot restart

While `flutter run` is attached, type into that terminal:

| Key | Does |
| --- | --- |
| `r` | **Hot reload** — reapplies changed code, keeps app state |
| `R` | **Hot restart** — rebuilds and restarts, resets all state |
| `h` | List every available key |
| `v` | Open DevTools in the browser |
| `c` | Clear the screen |
| `q` | Quit and detach |

In VS Code, saving a file hot-reloads automatically; `Ctrl+Shift+F5` hot
restarts.

> Hot reload does **not** re-run `main()` or rebuild existing state. After
> changing `main()`, a singleton's initialization (`NounSettings`,
> `CourseSession`, `CoinWallet`), anything read once in `initState`, `const`
> data, or `kDataVersion`, press `R` — otherwise you are still looking at the
> old values. Asset changes (`assets/content/**`, `assets/seed/**`) also need a
> hot restart, and a new asset *file* needs a full stop and `flutter run`.

### Check without running

```bash
flutter analyze
```

> `flutter analyze` treats lint **infos** as failures in this project, so keep
> the analyzer clean.

### Tests

```bash
flutter test                                       # the whole suite
flutter test test/feature_poll_test.dart           # one file
flutter test test/coin_wallet_test.dart test/course_test.dart
flutter test --plain-name "pays coins"             # tests whose name contains this
flutter test --coverage                            # writes coverage/lcov.info
```

`flutter test` only picks up files ending in `_test.dart`, which is what keeps
the dev previews below out of the suite.

### Dev previews (render a PNG and look at it)

Files named `test/_*.dart` are **developer previews, not pass/fail tests**: they
paint a widget and write a PNG through the golden machinery so the artwork can
be eyeballed. Run one explicitly, then open the image it names.

```bash
flutter test --update-goldens test/_feature_poll_preview.dart      # the feature poll, phone + desktop
flutter test --update-goldens test/_furniture_contact_sheet.dart   # every room piece, paged
flutter test --update-goldens test/_style_preview.dart             # furniture style variants
flutter test --update-goldens test/_gallery.dart                   # the Plants shelf
flutter test --update-goldens test/_login_preview.dart             # the login poster
```

They register real Windows fonts, so text renders as glyphs instead of
flutter_test's Ahem boxes.

### Refreshing the content goldens

`test/content_fidelity_test.dart` and `test/storage_keys_test.dart` pin the
content snapshot and the quiz storage-key prefixes. When a content change is
intentional, refresh them and **review the diff**:

```bash
UPDATE_GOLDEN=1 flutter test test/content_fidelity_test.dart test/storage_keys_test.dart
```

PowerShell has no inline env-var prefix, so there it is:

```powershell
$env:UPDATE_GOLDEN = '1'
flutter test test/content_fidelity_test.dart test/storage_keys_test.dart
$env:UPDATE_GOLDEN = $null
```

### Regenerate content assets

```bash
dart run tool/generate_content.dart   # → assets/content/** (per-course bundles)
dart run tool/generate_seed.dart      # → assets/seed/quiz_content.json (DB seed)
```

These are two different pipelines: the bundles drive the drawer's nav headers,
the seed drives the quiz tiles and the running quizzes. After changing content,
bump `kDataVersion` in `lib/data/data_version.dart` so existing installs reseed
on next launch.

### Build

```bash
flutter build web --release --base-href "/germanPronouns/" --dart-define=TTS_PROXY_URL=https://german-tts-proxy.gdeioannes.workers.dev
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android, for Play
flutter build windows --release
```

### Housekeeping

```bash
flutter clean && flutter pub get     # when the build goes strange
flutter pub outdated                 # what could be upgraded
```

> This project does **not** use `dart format` — the source is hand-wrapped at 80
> columns and running the formatter would rewrite most of the tree. `flutter
> analyze` is the gate; keep it clean and match the style of the file you are
> editing.

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

Against the **deployed** Worker, that is the everyday command in
[Run the app](#run-the-app).

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
