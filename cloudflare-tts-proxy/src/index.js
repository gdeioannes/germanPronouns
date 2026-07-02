// Cloudflare Worker: TTS proxy.
//
// Holds the Azure/Google cloud keys server-side so the published web app
// (GitHub Pages) never ships them. The browser POSTs { text, locale, gender };
// the Worker adds the key, calls the cloud TTS API, and returns MP3 bytes. It
// tries Azure first (clearest German), then Google as a fallback. `gender`
// ('male'/'female', default female) selects a male or female neural voice.
//
// Secrets/vars are set with wrangler — see README.md. Nothing secret lives in
// this file or in wrangler.toml.

export default {
  async fetch(request, env) {
    const cors = corsHeaders(request, env);

    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: cors });
    }
    if (request.method !== 'POST') {
      return json({ error: 'POST only' }, 405, cors);
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return json({ error: 'invalid JSON' }, 400, cors);
    }

    const text = String(body.text ?? '').trim();
    const locale = String(body.locale ?? 'de-DE');
    // 'male' picks a male voice; anything else (incl. missing) stays female.
    const gender = body.gender === 'male' ? 'male' : 'female';
    if (!text) return json({ error: 'missing text' }, 400, cors);
    if (text.length > 600) return json({ error: 'text too long' }, 413, cors);

    let audio = await azureSynthesize(text, locale, gender, env);
    if (!audio) audio = await googleSynthesize(text, locale, gender, env);
    if (!audio) return json({ error: 'tts unavailable' }, 502, cors);

    return new Response(audio, {
      status: 200,
      headers: { ...cors, 'Content-Type': 'audio/mpeg', 'Cache-Control': 'no-store' },
    });
  },
};

// --- CORS --------------------------------------------------------------------

function corsHeaders(request, env) {
  const origin = request.headers.get('Origin') || '';
  const allowed = String(env.ALLOWED_ORIGINS || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  // Empty allowlist => allow any origin (handy for the first smoke test).
  // Lock this down by setting ALLOWED_ORIGINS to your Pages URL before real use.
  const ok = allowed.length === 0 || allowed.includes(origin);
  return {
    'Access-Control-Allow-Origin': ok ? origin || '*' : 'null',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    Vary: 'Origin',
  };
}

function json(obj, status, cors) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { ...cors, 'Content-Type': 'application/json' },
  });
}

// --- Providers ---------------------------------------------------------------

// Female voices are the app's long-standing defaults; male voices are their
// matching neural counterparts. Keyed by full lowercase locale first (so en-GB
// gets a British voice) and then by bare language as the fallback for any
// regional variant.
const AZURE_VOICES = {
  de: { female: 'de-DE-KatjaNeural', male: 'de-DE-ConradNeural' },
  es: { female: 'es-ES-ElviraNeural', male: 'es-ES-AlvaroNeural' },
  en: { female: 'en-US-JennyNeural', male: 'en-US-GuyNeural' },
  'en-gb': { female: 'en-GB-SoniaNeural', male: 'en-GB-RyanNeural' },
  cs: { female: 'cs-CZ-VlastaNeural', male: 'cs-CZ-AntoninNeural' },
  fr: { female: 'fr-FR-DeniseNeural', male: 'fr-FR-HenriNeural' },
  zh: { female: 'zh-CN-XiaoxiaoNeural', male: 'zh-CN-YunxiNeural' },
};
const GOOGLE_VOICES = {
  de: { female: 'de-DE-Neural2-C', male: 'de-DE-Neural2-B' },
  es: { female: 'es-ES-Neural2-A', male: 'es-ES-Neural2-B' },
  en: { female: 'en-US-Neural2-C', male: 'en-US-Neural2-D' },
  'en-gb': { female: 'en-GB-Neural2-A', male: 'en-GB-Neural2-B' },
  cs: { female: 'cs-CZ-Wavenet-A', male: 'cs-CZ-Wavenet-B' },
  fr: { female: 'fr-FR-Neural2-A', male: 'fr-FR-Neural2-B' },
  // Google names its Mandarin voices cmn-CN (not zh-CN); the request's
  // languageCode is derived from the voice name so the pair always matches.
  zh: { female: 'cmn-CN-Wavenet-A', male: 'cmn-CN-Wavenet-B' },
};

const langOf = (locale) => (locale.split('-')[0] || 'de').toLowerCase();

// Full-locale entry first (en-gb), then the bare language (en).
const voiceFor = (table, locale, gender) =>
  (table[locale.toLowerCase()] || table[langOf(locale)])?.[gender];

const escapeXml = (s) =>
  s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');

async function azureSynthesize(text, locale, gender, env) {
  const key = env.AZURE_TTS_KEY;
  const region = env.AZURE_TTS_REGION;
  if (!key || !region) return null;
  const voice = voiceFor(AZURE_VOICES, locale, gender);
  if (!voice) return null;
  const ssml =
    `<speak version="1.0" xml:lang="${locale}">` +
    `<voice xml:lang="${locale}" name="${voice}">${escapeXml(text)}</voice>` +
    `</speak>`;
  try {
    const resp = await fetch(
      `https://${region}.tts.speech.microsoft.com/cognitiveservices/v1`,
      {
        method: 'POST',
        headers: {
          'Ocp-Apim-Subscription-Key': key,
          'Content-Type': 'application/ssml+xml',
          'X-Microsoft-OutputFormat': 'audio-24khz-48kbitrate-mono-mp3',
          'User-Agent': 'german-tts-proxy',
        },
        body: ssml,
      }
    );
    if (!resp.ok) return null;
    return await resp.arrayBuffer();
  } catch {
    return null;
  }
}

async function googleSynthesize(text, locale, gender, env) {
  const key = env.GOOGLE_TTS_KEY;
  if (!key) return null;
  const voice =
    voiceFor(GOOGLE_VOICES, locale, gender) || GOOGLE_VOICES.de[gender];
  // The voice name leads with its own language code (e.g. cmn-CN-Wavenet-A);
  // send that as languageCode so voice/language always agree, even where the
  // app's locale differs from Google's naming (zh-CN vs cmn-CN, en-GB vs en-US).
  const languageCode = voice.split('-').slice(0, 2).join('-');
  try {
    const resp = await fetch(
      `https://texttospeech.googleapis.com/v1/text:synthesize?key=${key}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          input: { text },
          voice: { languageCode, name: voice },
          audioConfig: { audioEncoding: 'MP3' },
        }),
      }
    );
    if (!resp.ok) return null;
    const data = await resp.json();
    if (!data.audioContent) return null;
    return base64ToArrayBuffer(data.audioContent);
  } catch {
    return null;
  }
}

function base64ToArrayBuffer(b64) {
  const bin = atob(b64);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return bytes.buffer;
}
