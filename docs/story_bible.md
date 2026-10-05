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

- **Premise:** American true-crime podcaster. Fluent English,
  almost no German — permanently at the learner's level, so every German
  word she decodes, the learner decodes with her. The learner is her
  remote assistant; every module is an episode of her podcast.
- **How she dresses:** the outfit above, always; pencil behind one ear;
  props are her navy notebook, phone and case board, and a small handheld
  recorder (Episode 0, when the phone is dead). Her luggage is always the
  same large ink-navy hard-shell suitcase (manifest block `{suitcase}`;
  the model drifts to a brown leather case without it). Never a magnifying
  glass — she's a podcaster, not a cop.
- **Timeline:** Episode 0 is her first day in Berlin — she arrives with
  zero German, meets the learner at the airport and moves into Jonas's WG
  without meeting him. Episode 1 is a few weeks later.
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

## Story formula (every episode)

The mystery changes; the formula doesn't — that's the cohesion between
stories. Rendered at /dev/story-bible/formula.

- **Frame:** every episode is an episode of Maya's podcast; the learner is
  her assistant, addressed as `{user}`. One mystery per episode, honestly
  solvable from the German evidence alone at the episode's half-level.
  Cozy stakes (reputations, secrets, surprises), never danger; failure
  costs Maya's credibility, not the learner's score.
- **Skeleton (7 chapters):** intro hook (2 panels + recruit) → two linear
  evidence chapters → hub of three leads in any order (one heard, one
  written/filled-in, one to re-order), each granting a clue → finale
  unlocked by all clues, a live conversation where the learner builds
  Maya's German → honest resolution + one-question cliffhanger.
- **Numbers (gate-tested):** ≥8 min error-free; ≥3 questions per evidence
  chapter; bigText ≥6 blanks; sorts ≥6 items; credibility 3 with 5–8
  critical beats; every memorizable fact from a pool of ≥3 variants with
  audio per variant; a Maya micro-text after (nearly) every chapter;
  torch-noir light at most 2–3 times.
- **Cohesion:** same cast rules (character checklist before first use),
  same Berlin world (locations join the scenario catalog and may return),
  same language contract, same ligne claire look, and each episode plants
  one continuity hook a later episode pays off (tracked in the episode
  docs).
- **Prologue exception (Episode 0 only, agreed 2026-10-05):** the episode
  for learners with no German at all keeps the skeleton but has a 7-minute
  floor, numbers as digits only, tap-only answers, and survival German
  instead of grammar topics — see `docs/episodes/ep0_lost_in_berlin.md`.
- **Podcast facts:** 3–4 real Berlin facts per episode, told by Maya in
  English and then pinned to one German word the learner taps in the scene
  (der Fernsehturm, das Ampelmännchen …). Facts must be true; keep them short.
- **Review:** every new episode goes through the review loop in
  `docs/story_review.md` (scorecard, playtest bot, two reviewer passes) for
  at least three rounds before it ships.

## Interactions (playful, never a test)

The learner's hands should be busy, and every question is a case action —
never "what does X mean?". The player's mechanics (schema:
`docs/story_module_schema.md`):

| Mechanic | Feels like | Use for |
|---|---|---|
| `dialogue` | a live chat; characters' lines are voiced, the learner picks or builds Maya's reply | every conversation with a stranger |
| `hotspot` | tap the right thing in the picture; German on props is overlaid | signs, plates, landmarks, the bakery counter |
| `map` | the code-drawn Kiez map (`KiezMap.svelte`): find a place, or steer Maya with links/rechts/geradeaus | orientation, directions, the walk to a finale |
| `stops` | a U-Bahn ride: hear "Nächster Halt …", get off at the right one | listening for one name |
| `orderedPick` | dial a number, order tiles | numbers, word order, sorting evidence |
| `inlineCloze` / `bigText` | restore a damaged note, fill in a form | reading |
| `banter` | Maya asks, every option gets her reaction | warm-up, sign-offs |
| `select` / `recall` | pin a fact to the case board, remember a detail | ≤ 25 % of exercises |

Every wrong option carries an in-character reply; hidden hotspots start to
glow after two misses. Words land in the notebook with a play button.

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

Cast 2026-10-02: Maya = Achernar (en-US) · Jonas = Puck (de-DE) · Lena = Aoede (de-DE) · Böhm = Charon (de-DE). Audition candidates stay recorded as the trail.
Episode 0 (2026-10-05, cast from the Chirp 3 HD voice descriptions — recast
by ear if one sounds off): the passer-by = Zephyr · Frau Demir, the baker =
Sulafat · the airport stranger = Achird · the U-Bahn announcer = Schedar
(all de-DE). Herr Böhm recurs (Ep 0 intercom, Ep 1 caretaker) and counts as
recurring cast from now on.
Episode casts keep their auditions in the same tool, grouped by character.

## Dev reference page

`/dev/story-bible` renders this bible with images and playable voice refs —
dev builds only (`import.meta.env.DEV`-guarded, `prerender = false`; assets
under `src/lib/assets/story/`, never `static/`, so none of it ships).
