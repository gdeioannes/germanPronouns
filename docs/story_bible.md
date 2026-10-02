# Story bible — general foundation for gamified modules

Story-agnostic source of truth for every gamified quiz module: the art
style, the recurring cast, how characters and scenarios are created, the
language-mixing rules and the voice-casting process. Nothing in this file
belongs to one particular episode; episode-specific material (premise,
episode cast, locations, chapter plans) lives in `docs/episodes/`.

Rendered with images and audio at `/dev/story-bible` (dev builds only).
Image prompts live in `assets/images/story_manifest.json`; voice auditions
in `tool/gen-voice-refs.mjs`.

## Art style (CANON, chosen 2026-10-02 after style tests)

The live wording is the `style` field of the story manifest; in short:

> Detailed ligne claire comic illustration, like a Tintin album page: clean
> medium-weight ink-navy linework, flat colours, natural adult proportions,
> simple expressive faces, and a high level of loving detail everywhere —
> furnished environments, patterned wallpaper, parquet floors, corduroy
> ridges, small props. Brand palette (ink-navy, terracotta, mustard, sage,
> soft blue, cream). Dramatic but readable lighting chosen per scene. Bare
> hands, no gloves. No text anywhere in the image.

Rationale: simplicity reads cold in a mystery — detail is warmth, lighting
does the storytelling. Chosen over gouache-storybook and cozy-noir
directions; the lighting drama of noir survives as the "torch noir" light.

### Colour roles

| Colour | Hex | Role |
|---|---|---|
| Ink navy | #1f3a5f | linework, deep shadow |
| Terracotta | #c9683b | accents, rim light, case-board string |
| Mustard | #d9a441 | warm light, Maya's jacket |
| Sage | #7a9a7e | walls, calm surfaces |
| Soft blue | #8fb3c9 | cool half-light |
| Paper | #fbf8f3 | ground |

Mood is always warm-against-cool: one warm source against cool blue-grey
half-light. Never flat daylight, never full darkness.

### Lighting vocabulary (named per scene prompt)

| Light | Use for | Description |
|---|---|---|
| **Door shaft** (default) | investigation scenes | warm shaft through a half-open door into cool blue-grey half-light, dust motes; all detail readable |
| **Lamp cone** | discoveries, confrontations | single warm lamp, theatrical golden cone, dusky corners |
| **Dusk window** | calm narrative beats | golden-hour window light, long frame shadows |
| **Torch noir** | 2–3 peak-tension moments per episode | night, torch beam, terracotta rim light, deep shadow |

Reference images: `light_ref_doorshaft`, `light_ref_lampcone`,
`light_ref_duskwindow`, `light_ref_torchnoir`.

## Creating characters and scenarios

- Every character and recurring location gets a **block** in the story
  manifest (`blocks`), written once and spliced **verbatim** into every
  prompt (`{maya}`). Never paraphrase a block inside a prompt; edit it in
  the manifest, then regenerate.
- Character blocks pin: age and proportions ("natural adult proportions,
  realistic head-to-body ratio, never chibi"), hair, glasses/props,
  exact outfit with colours, skin tone, default expression.
- Location blocks pin: architecture, wall colour, key furniture with
  colours, floor. Lighting is NOT part of a location block — it is chosen
  per scene from the lighting vocabulary.
- A new character gets, before first use: a block, a reference sheet
  (neutral pose on plain warm background, "soft warm light from one side,
  like a figure cut out of one of the scene illustrations"), and a voice
  (see casting below).
- Recurring cast (usable in any episode) is defined here; episode-only
  characters are defined in that episode's doc but follow the same rules.
- Props that will carry readable German are drawn blank; text is HTML
  overlay (the model mangles text, and overlay stays translatable).
- Scenes 16:9, portraits/props 1:1. Regenerate:
  `npm run images -- --story <id>` (output: `src/lib/assets/story/`,
  dev-only, never shipped).

## Recurring cast

### MAYA ELLISON (the investigator — every module)

Block (see manifest for the live wording): mid-twenties, podcaster and
amateur detective, natural adult proportions, shoulder-length dark brown
curls, round amber glasses, mustard corduroy jacket over cream-and-navy
striped shirt, dark trousers, white sneakers, sage canvas messenger bag.

- **Premise:** British-American true-crime podcaster. Fluent English,
  almost no German — permanently at the learner's level, so every German
  word she decodes, the learner decodes with her. The learner is her
  remote assistant; every module is an episode of her podcast.
- **How she dresses:** the outfit above, always; pencil behind one ear;
  props are her navy notebook, phone and case board. Never a magnifying
  glass — she's a podcaster, not a cop.
- **How she speaks:** English only. Short dramatic sentences, CAPITALISED
  emphasis, trailing ellipses before reveals, podcast framing everywhere
  ("episode", "listeners", "scoop"). Warm to the learner, theatrical about
  everything else. She never teaches — she asks, and grammar help always
  sounds like case work.
- **How she reacts:** clue found → gasps, over-celebrates, writes it down.
  Learner right → her own scoop, credits "my brilliant assistant". Learner
  wrong → blames herself or the handwriting, never the learner. German
  spoken at her → panic-polite, repeats the two words she caught, turns to
  the learner. Setback → deflates theatrically, then rallies ("Okay. New
  plan. There's always a new plan.").
- **Reference images:** `maya_ref_neutral`, `maya_ref_clue`,
  `maya_ref_phone`, `maya_ref_notes`, `maya_canon_portrait`,
  `maya_canon_full`, `maya_canon_casefile`.

## Mixing English and German

- English is the frame, German is the evidence. Maya narrates in English;
  German appears only as material to decode (notes, voicemails, forms,
  chats, overheard calls).
- One language per audio clip, one voice per character; scenes interleave
  clips, never mix languages inside one.
- Maya never reads German aloud — her mangled German is a text-only gag,
  so every spoken German word the learner hears is correct and imitable.
- German inside English text is visually marked (GermanText) and tappable,
  voiced by the German speaker's voice.
- The app's quiz voice (Kore, de-DE) is reserved for the app; story
  characters never use it — quiz audio sounds like the app, story audio
  sounds like people.

## Voice casting

Every character has a fixed, named Chirp 3 HD voice, chosen by ear and
reused in every appearance. Process: **always record references before
casting** — add candidates to `tool/gen-voice-refs.mjs` with the
character's signature line, run `npm run voices`, listen on
`/dev/story-bible`, then mark the winner `chosen: true`. Clips live in
`src/lib/assets/story/voices/` (dev-only) as the permanent audition trail.

Cast 2026-10-02: Maya = Leda (en-GB) · Jonas = Puck (de-DE) · Lena = Aoede (de-DE) · Böhm = Charon (de-DE). Audition candidates stay recorded as the trail.
Episode casts keep their auditions in the same tool, grouped by character.

## Dev reference page

`/dev/story-bible` renders this bible with images and playable voice refs —
dev builds only (`import.meta.env.DEV`-guarded, `prerender = false`; assets
under `src/lib/assets/story/`, never `static/`, so none of it ships).
