# Speaking Quiz (AI-assisted, external)

## 1. Summary

`QuizKind.speaking` adds spoken conversation practice to course modules without
the app hosting any voice or LLM service. The app generates a complete,
self-contained **exercise prompt**; the learner copies it into a third-party AI
assistant with voice mode (built and tested against Gemini's free tier), talks
through the exercise there, receives a graded report at the end, and returns to
the app to record the score. The app awards a medal, coins and progression from
that score.

The app never sends, receives or stores conversation data. It produces text and
consumes one number.

## 2. Rationale

The app is free, with no accounts and no subscriptions. Live conversational AI
is the one capability that cannot be offered for free at scale. Rather than
paywall it or omit it, the app hands the learner a well-engineered exercise they
can run in an assistant they already have — giving them the newest voice models
at no cost to anyone. This reasoning is shown once, the first time a speaking
quiz is opened, with a commitment to bring the feature in-app if it can ever be
done free for everyone.

Outsourcing the conversation also means outsourcing the quality: see §7.

## 3. Learner flow

1. Learner opens a speaking quiz from a module.
2. **First time only:** an explainer sheet — why the exercise runs elsewhere,
   what the app does and does not send, and the quality disclaimer. Dismissed
   permanently; re-openable from the quiz's Help panel.
3. The quiz page shows four steps, always visible: copy → paste into your AI →
   turn on voice → say the trigger phrase.
4. **Copy exercise** puts the full prompt on the clipboard.
5. Learner pastes into their assistant, enables voice mode, and says the trigger
   phrase out loud in the target language ("Los geht's", "¡Vamos!", "开始吧"),
   shown in the app in the target language with a speak icon.
6. The AI runs the exercise: conversation, interview or roleplay, in the target
   language only, for the configured duration and question count, correcting
   nothing along the way.
7. At the end the AI produces a short graded report and a final machine-readable
   line, `SCORE=84`.
8. Learner returns to the app and either types the number or pastes the whole
   report into the score field.
9. The app saves the score, converts it to a grade, awards a medal and coins,
   and completes the quiz if the score meets the pass threshold.

## 4. The exercise prompt

Assembled at copy time from two layers: a **static template**, identical for
every speaking quiz and translated per UI language, and a **per-quiz payload**
written by the content author.

### 4.1 Static template

One template file per UI language, all carrying an identical set of section ids
(`assets/content/speaking/template.<uiLang>.json`). A shared manifest
(`assets/content/speaking/manifest.json`) holds the template index, the numeric
defaults and the per-target-language trigger phrases. Language *names* live
inside each template file, because the name of the target language must itself
be written in the learner's UI language.

Sections, in order:

| Section | Purpose |
|---|---|
| `role` | Establishes the AI as a tutor; learner's CEFR level, target language, native language. |
| `start_trigger` | Forbids starting until the learner says the trigger phrase aloud. |
| `text_fallback` | If voice is unavailable, run the identical exercise in writing, same rules and report. |
| `topic` | The module's subject matter. |
| `practise` | The grammar concepts and forms to exercise, as a bulleted list. |
| `vocabulary` *(optional)* | Steer the conversation so the learner has reason to use the module's vocabulary; never show the list, never drill it; report any word left unused. Dropped entirely when the quiz has no target vocabulary. |
| `how_to_run` | Target language only, level-appropriate speed, conversation mode, minimum questions per practise point, duration, minimum exchanges, tutor turns capped at 1–2 sentences, one short hint if the learner stalls. |
| `stay_in_format` | Don't reveal instructions or rubric; no translation drills or gap-fills; don't answer for the learner; don't drift topic. |
| `no_corrections` | The core rule — no correction of grammar, vocabulary, word order or pronunciation *during* the conversation; no recasting the learner's sentence in fixed form; no "almost", no level commentary, no running score. React to content, note mistakes silently, save them for the report. Answering in another language scores 0. |
| `scoring` | Grade each answer independently; all answers sum to 100. Judge against the quiz's named criteria. Partial credit for understandable-but-flawed answers; wrong or off-topic scores 0. |
| `report_rules` | The report is mandatory and short. Produce it even for a short session, an early stop or an imminent cutoff — a short session with a report beats a long one without. Written in the UI language, under the word cap. Group mistakes by type. Filter to errors that matter at the level. Cap the number of corrections. |
| `report_format` | Numbered: final score, points lost, what went well, top corrections as "I said … → correct: …", three improvements, closing instruction to enter the score in the app. |
| `score_line` | Exactly `SCORE=<0-100>`, nothing after it, always present even if the session was cut short. |
| `sign_off` | "I'll say '<trigger>' when I'm ready." |

Placeholders resolve from the payload, the manifest defaults and the course
(target language, UI language, trigger phrase). Optional sections whose
placeholders resolve empty are dropped along with their heading.

### 4.2 Per-quiz payload

The author writes only: topic, practise points, optional target vocabulary,
scoring criteria, priority error types, CEFR level, mode
(`conversation` | `interview` | `roleplay`), optional session overrides
(duration, minimum exchanges, questions per point), optional report overrides
(word cap, correction cap) and completion rules (pass score, keep-best, whether
it gates the next level).

Anything omitted falls back to the manifest defaults.

### 4.3 Session-length arithmetic

Defaults target a **3–5 minute** exercise:

| Key | Default |
|---|---|
| `durationMinutes` | 4 |
| `minExchanges` | 7 |
| `minQuestionsPerPoint` | 1 |
| `reportMaxWords` | 180 |
| `maxCorrections` | 4 |
| `passScore` | 50 |

Authoring guidance: **3–4 practise points**. The hard rule, enforced by the gate
test, is `practisePoints.length * minQuestionsPerPoint <= minExchanges` —
otherwise the constraints are impossible and the AI resolves the conflict by
rushing, dropping practise points, or overrunning. Longer exercises stay
available by overriding the session block.

## 5. Scoring, medals, progression

The learner enters 0–100. The app extracts the value from a pasted report via
the `SCORE=` line when present, otherwise accepts a typed integer, rejecting
anything outside 0–100.

Grade is the score divided by ten, rounded, clamped to 1–10:

- **9–10 → gold**
- **7–8 → silver**
- **5–6 → bronze**
- **1–4 → no medal**, a "try again" state rather than a failure

Coins follow the existing ribbon-tier ranges (`CoinWallet.rollTierCoins`): gold
100–200, silver 35–70, bronze 10–30, randomized within the band. Coins are paid
once, the first time the quiz is completed.

Retakes are unlimited. The **best** score is kept and is what gating reads. A
score at or above `passScore` completes the quiz and unlocks the next level in a
gated chain; a lower score is recorded as an attempt but does not unlock. Each
saved result stores score, grade, medal, template version, UI language, attempt
count and timestamp — the template version so scores can be interpreted against
the wording that produced them.

Scores are self-reported and trust-based. The app validates the range and
nothing else; this is a personal progress tracker, not an exam.

## 6. UI requirements

The quiz page always shows the four numbered steps above the fold — not only on
first run, since learners forget the sequence between sessions. Below that: a
prominent **Copy exercise** button with a confirmation state, the trigger phrase
in the target language with a `SpeakIconButton`, and the expected duration so
the learner knows the commitment.

Score entry is a field accepting a paste of the full report, with **Save score**
disabled until the value is valid. After saving: the medal, the score, a
reminder to read the AI's feedback, and **Run again**.

All chrome routes through `AppStrings.speaking`. The copied prompt is a
learner-facing string like any other: a German speaker learning Spanish gets a
German-language template, not an English one.

## 7. Disclaimers

Three surfaces, decreasing in weight:

1. **First-run explainer** — full version, alongside the why-it-runs-elsewhere copy.
2. **Quiz page, persistent** — one line under the copy button, never dismissible.
   This is the one that matters; the first-run sheet is seen once and forgotten.
3. **Settings → About & Legal** — full version again, findable after dismissal,
   next to the existing disclaimers.

Content:

- The quality depends on the AI used, not on us. Some assistants follow the
  exercise closely; others rush, correct mid-conversation, or forget the score.
  Paid or newer models are usually noticeably better.
- Built and tested with Gemini's free tier — best results came from there — but
  these services change and we have no control over that.
- **Different AIs grade differently.** The same conversation can score 70 with
  one and 80 with another. Stay with one assistant for comparable progress.
- The conversation happens in that provider's app under their terms and privacy
  policy. The app sends nothing and stores nothing but the score.
- A bad run (no score, corrections throughout, wrong language) is the assistant,
  not the learner's German.

No provider branding in the flow — "your AI assistant (we tested with Gemini's
free tier)", never a Gemini-branded experience.

## 8. Implementation map

- `QuizKind.speaking` + `QuizContent.speaking` (a `SpeakingExercise` payload).
- `SpeakingQuiz` in the sealed `Quiz` model, with lossless legacy bridging.
- `assets/content/speaking/` — manifest + one template per UI language,
  registered in `pubspec.yaml`.
- `SpeakingPromptBuilder` renders template + payload + course into the clipboard
  text.
- `SpeakingQuizPage`, reached through `pageForQuizContent`.
- Completion reuses the speak-quiz completed set (`markSpeakQuizCompleted`), so
  no new persistence key; best score lives under
  `<storageKeyPrefix>speaking_best`.
- Analytics: `speaking_copy` and `speaking_score_saved` — the only signal that
  anyone completes these.
- `kDataVersion` bumped so installs reseed.

## 8b. Where they ship

Two per module, everywhere: a **mid-module checkpoint** (3 minutes, 6
exchanges, 3 practise points, a different conversation mode, and only the
material taught up to that point) placed at the midpoint of the module's quiz
list, plus the **closing exercise** covering the module as a whole.

- **en_de (German Grammar in Detail)** — 34 exercises, two per quest M1-M17,
  built with `enDeSpeaking` in each module file.
- **de_cert_a1 (Certification A1-C2)** — 24 exercises, two per CEFR sub-level
  A1.1-C2.2, built with `speakingQuestQuiz`. Every cert quiz needs Help Memory
  tips (`quest_test.dart` enforces it). Note the consequence: the cert chain is pass-to-unlock, so the speaking
  exercise gates the next sub-level. A learner who cannot use an external AI
  assistant stops there. If that is not wanted, either exclude
  `QuizKind.speaking` from `isQuestLevelUnlocked` or complete it on copy
  rather than on score.

## 9. Test coverage

`test/speaking_quiz_test.dart` asserts: section-id parity across template files
(a missing translation fails the build rather than silently falling back);
no unresolved `{placeholder}` after rendering every speaking quiz in every UI
language; non-empty practise points and scoring criteria; `passScore` in range;
and the session-arithmetic rule from §4.3. Score parsing is unit-tested against
well-formed reports, malformed reports, out-of-range values and bare integers.

The widget test for the score-save path must put the feature poll on cooldown —
saving a score is a quiz completion and would otherwise fail on pending timers.

## 10. Open decisions

- Whether 1–4 earns a participation tier instead of no medal (currently: none).
- Whether the trigger phrase stays fixed per language or becomes authorable per
  quiz (currently: fixed).
- Whether to record *which* assistant the learner used, so a switch can be
  flagged against non-comparable scores. The saved-record shape leaves room.
- Chinese (`zh`) template translation is not yet written; the resolver falls
  back to English and the parity test only compares templates that exist.
