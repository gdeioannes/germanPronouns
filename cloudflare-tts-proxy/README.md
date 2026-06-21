# German TTS proxy (Cloudflare Worker)

A tiny serverless proxy so the **published web app never ships the cloud keys**.
The browser POSTs `{ "text": "...", "locale": "de-DE" }`; the Worker adds the
secret key, calls Azure (then Google as fallback), and returns `audio/mpeg`.

Why this exists: on web, a `--dart-define` key is compiled into `main.dart.js`
and visible to every visitor, and Azure's REST endpoint CORS-blocks browsers.
Routing through this Worker keeps the key server-side and makes Azure work again.
Desktop/mobile builds skip the proxy and call the clouds directly.

## One-time setup

```bash
cd cloudflare-tts-proxy
npm install
npx wrangler login          # opens the browser; free Cloudflare account, no card
```

## Configure secrets (kept in Cloudflare, never in git)

```bash
npx wrangler secret put GOOGLE_TTS_KEY     # paste the Google key
npx wrangler secret put AZURE_TTS_KEY      # paste the Azure key (optional)
```

The Azure **region** and the CORS allowlist are non-secret and live in
`wrangler.toml`:

- `AZURE_TTS_REGION` — already set to `germanywestcentral`.
- `ALLOWED_ORIGINS` — already locked to `https://gdeioannes.github.io` (the
  GitHub Pages origin — domain only, no `/germanPronouns/` path). Add more
  origins comma-separated if needed, e.g. a custom domain or
  `http://localhost:PORT` while testing locally.

## Deploy

```bash
npx wrangler deploy
```

This prints your Worker URL, e.g. `https://german-tts-proxy.<you>.workers.dev`.

## Point the web app at it

Build the Flutter web app with that URL (not a secret, so a plain define). For
the GitHub Pages project site the build also needs the sub-path as base href:

```bash
flutter build web \
  --base-href=/germanPronouns/ \
  --dart-define=TTS_PROXY_URL=https://german-tts-proxy.<you>.workers.dev
```

Then publish `build/web` to GitHub Pages however you do today. On web the app
uses the proxy as its premium voice (the status chip shows **"HD voice · Cloud"**),
falling back to the on-device voice if the proxy is unreachable.

## Test it directly

```bash
curl -X POST "https://german-tts-proxy.<you>.workers.dev" \
  -H "Content-Type: application/json" \
  -d '{"text":"Hallo Welt","locale":"de-DE"}' \
  --output test.mp3
```

A valid `test.mp3` (a few KB) means the proxy is working end to end.

## Local development

Put keys in a gitignored `.dev.vars` file:

```
GOOGLE_TTS_KEY=...
AZURE_TTS_KEY=...
AZURE_TTS_REGION=germanywestcentral
```

Then `npm run dev` and POST to the printed `http://localhost:8787`.
