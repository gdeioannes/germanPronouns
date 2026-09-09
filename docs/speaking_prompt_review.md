# Speaking-prompt generator — review (2026-09-09)

A review of the prompt the learner copies into their own AI, as produced by
`SpeakingPromptBuilder` (`lib/services/speaking_prompt.dart`) from the
templates in `assets/content/speaking/` and the exercises authored through
`enDeAiEx` (`lib/data/courses/en_de_ai/en_de_ai_builder.dart`). Based on
reading the English template and rendering `en_de_ai_m7_scaffolds`
(vocabDrill, scaffolded, B2) end to end.

## What the prompt already carries — and does well

- Role, target language, CEFR level, learner's native language.
- A start trigger ("Los geht's"), a text-mode fallback, and a sign-off.
- The exercise payload: topic, MATERIAL verbatim, practise points, hidden
  target vocabulary, scoring criteria, level-appropriate priority errors.
- Session shape (minutes, minimum exchanges, questions per practise point).
- The rules that make the feature work: no corrections during the talk, a
  mandatory short report with a fixed format, and the machine-readable
  `SCORE=` last line (double-anchored against the `FINAL SCORE: __/100`
  header so `parseSpeakingScore` prefers the right one).
- Optional sections drop cleanly (no orphan headings), placeholders in mode
  lines are pre-filled, and the manifest carries a `templateVersion` so a
  stored score can be traced to the wording that produced it.

The static rulebook is genuinely good. The problems below are almost all
**mode-mismatch problems**: one conversation-shaped rulebook is bolted onto
eleven very different exercise types, and for the non-conversation modes the
prompt argues with itself. Weak free-tier models — the explicit target — lose
exactly these arguments.

## Contradictions in the rendered prompt (worst first)

1. **The no-drills rule contradicts the drill modes.** `vocabDrill` /
   `translationDrill` mode lines say "the no-drills rule below does not
   apply", but STAY IN THE EXERCISE still states, categorically and *after*
   the exception: "Do not give me sentences to translate, gap-fills, or
   drills. Ask real questions and let me answer freely." An exception that
   points at a rule which then restates itself unconditionally is a coin
   flip on a weak model. The rule must simply not render for drill modes.

2. **"German only" contradicts scaffolding — in every exercise of this
   course.** `enDeAiEx` defaults `scaffolded: true` at all levels, so every
   prompt contains both "German only, B2 speed" (HOW TO RUN IT) and "give
   instructions and explanations in English" (TEACH FIRST). The model must
   guess which wins.

3. **Report language is a topic-text hack that loses to the template.**
   B2.1+ topics append "Write the final report in German", but the REPORT
   section later commands "Write it in English" (from `{uiLanguageName}`).
   The later, explicit rule tends to win — the German-report request
   silently fails exactly at the levels that ask for it. This needs to be a
   first-class field (`reportLanguage` on `SpeakingExercise` →
   `{reportLanguage}` in the template), not free text in the topic.

4. **"Keep your own turns to 1–2 sentences" breaks presentation modes.**
   `readingQa`/`readingGen` must display a full passage, `listenRetell` must
   perform a piece, `wordGame` must explain rules. The turn-length cap
   should exempt the presented material.

5. **Scoring is per-answer-summing-to-100, which fits nothing but
   conversation.** A 12-item vocab drill, a single written text graded
   "against the rubric" (writing mode), and a 7-exchange conversation all
   get the same "grade each answer; all answers add up to 100". Writing
   mode is the worst: there is one answer. Each mode family needs its own
   one-line scoring rule (per item for drills, rubric-out-of-100 for
   writing, per answer for conversation-like modes).

6. **"Cover every practise point with at least 1 question each" is
   conversation-shaped.** In drills the items come from MATERIAL, not from
   practise points; in storytelling the learner talks in long turns. Minor,
   but it invites the model to bolt quiz questions onto a drill.

7. **The voice framing leaks into text-only modes.** `writing` says "voice
   is not needed", yet the prompt still demands the trigger be said "out
   loud" and the fallback speaks of bad connections. Cosmetic, but it reads
   sloppy and costs trust in the other rules.

## Information that is missing

- **A session plan.** The prompt never states the order of phases. With
  scaffolding on, is the teach phase before or after the trigger? When does
  the scored part start relative to `minExchanges`? A numbered plan
  ("1. wait for trigger → 2. teach, unscored → 3. announce the scored part
  → 4. run N exchanges → 5. report") is the single highest-value addition
  for weak models, which otherwise improvise the structure.
- **What to do with meta-questions.** "If I'm stuck, one short hint" covers
  silence, but not "was heißt X?" mid-scored-part. Does answering it break
  immersion? Cost points? One line settles it.
- **Do the teach-phase and hint content count toward the score?** Stated
  for scaffolding ("unscored") but not for hints or re-asked drill items.
- **How to end.** The AI is told to wrap up after ~N exchanges but not to
  warn the learner ("last question") — sessions end abruptly or overrun.
- **No mid-session recovery.** Voice sessions drop; nothing tells the AI
  what to do if the learner returns after an interruption (resume vs.
  report what happened so far). The "cut short → still report" rule covers
  only the AI-side cutoff.
- **A one-exchange example.** The report has a worked format; the
  conversation has none. One two-line example of a good exchange (question →
  answer → neutral reaction, no correction) would anchor the no-corrections
  behaviour far better than the rule alone. Costs ~40 tokens.
- **The learner's history.** The app knows past scores and weak spots but
  sends none of it. Even one optional line ("last time I struggled with:
  …") would make repeat sessions adaptive. (Bigger feature — noted, not
  urgent.)

## Recommended mechanics (template-level, no per-exercise rework)

1. Add per-section mode gating to the template schema — e.g. `"notModes":
   ["vocabDrill", "translationDrill"]` on the no-drills bullet, `"modes":
   [...]` for mode-specific scoring lines — mirroring the existing
   `optional:` gate. This one mechanism fixes findings 1, 4, 5, 6, 7.
2. Make the "German only" bullet scaffolding-aware (two variants of the
   bullet gated on `{scaffolding}`), fixing finding 2.
3. Add `reportLanguage` to `SpeakingExercise` + manifest default, render it
   in the REPORT section, and strip the "Write the final report in German"
   sentences from the B2.1+ topics, fixing finding 3.
4. Add a numbered SESSION PLAN section near the top (after the trigger),
   with the scaffolded and unscaffolded variants gated like today's
   sections.
5. Bump `templateVersion` when any of this ships — the version is already
   stored with each score, so old results stay interpretable.

Items 1–4 are template/JSON edits plus ~3 small code touches
(`SpeakingSection` gaining the mode filter, `SpeakingExercise.reportLanguage`,
the builder passing the mode into `render`). The 120 authored exercises
stay untouched except for deleting the report-language sentence from B2.1+
topics.

---

# Part 2 — the redesign: doing this much better

The fixes above patch contradictions. This part rethinks the feature. The
prompt is not really a text — it is a **protocol between the app and a
foreign LLM**, with a human courier in the middle. Today that protocol is
one-way and lossy: ~700 words go out, two digits come back. Everything
below follows from taking the protocol seriously in both directions.

## 1. Compose the prompt per mode — a contract, not a rulebook

Kill the "one rulebook + exceptions" shape entirely. The builder assembles
each prompt from blocks, and only blocks that apply to this mode render:

    ROLE            (shared, 1 line)
    SESSION PLAN    (numbered state machine, per mode-family)
    EXERCISE        (topic + material + practise points, as today)
    RULES           (per mode-family: conversation / drill / presentation /
                     writing — 4 families cover all 11 modes)
    SCORING         (per family, with an anchored rubric — see §3)
    REPORT          (shared)
    SCORE LINE      (shared, verbatim)

Two structural wins. **No contradictions by construction** — a drill prompt
never contains the no-drills rule, a writing prompt never mentions voice.
And **~40% shorter prompts**: the rendered B2 drill above spends more than
half its words on rules that don't apply to it. Weak models degrade with
length; every dropped irrelevant rule buys compliance on the rules that
remain.

The template schema changes from `sections: [...]` to
`{shared: [...], families: {conversation: [...], drill: [...],
presentation: [...], writing: [...]}}` plus a `family` lookup per
`SpeakingMode`. Exercises are untouched.

## 2. A numbered session plan as the spine

LLMs follow state machines far better than rule lists. Every prompt opens
with the plan, and every rule hangs off a phase number:

    SESSION PLAN
    1. Wait until I say "Los geht's". Nothing before that.
    2. TEACH (unscored): walk me through MATERIAL in small chunks,
       English explanations, German examples, one try each.
    3. Say "Jetzt zählt es" — the scored part begins.
    4. Run the exercise: [mode-family line]. Minimum 8 exchanges.
    5. Before ending, announce the last question.
    6. REPORT (see below), ending with the SCORE= line.

Phase 3's announcement fixes the teach/scored ambiguity; phase 5 fixes
abrupt endings; "if interrupted, resume at the phase we were in" is one
line instead of a paragraph. The plan also makes the learner's experience
predictable across all 120 exercises — same shape, different content.

## 3. Anchored scoring — comparable numbers instead of vibes

Today "grade each answer; all add up to 100" produces whatever number the
model feels like: scores are not comparable across sessions, models, or
even reruns — and medals, gates and placement hang off those numbers.
Anchor it:

    SCORING (per answer: 0 / 1 / 2)
    2 = correct and complete for B2 (small slips allowed)
    1 = understandable, but a practise-point error (dass-clause order,
        je…desto)
    0 = wrong, off-topic, or not in German
    FINAL SCORE = points ÷ maximum × 100. Say nothing about points
    during the exercise.

A 3-band per-answer rubric is the largest unit a weak model applies
consistently, and the practise points become the *definition* of band 1,
which focuses the grading on what the exercise teaches. Score inflation
drops, medals start meaning the same thing everywhere.

## 4. Bring the whole report home, not just the score

The report the AI writes — grouped mistakes, corrections, "improve next
time" — is the most valuable artifact of the session, and today it dies in
the other app. The score field already accepts a full pasted report
(`parseSpeakingScore` finds the `SCORE=` line anywhere in it). Go one step
further:

- Encourage pasting the full report (UI copy: "paste the AI's report —
  the app reads the score out of it").
- Ask the AI to tag corrections in a fixed one-per-line shape (it already
  nearly does): `FIX: <what I said> -> <correct German>`.
- Parse and store those lines with the result.

Suddenly the app has, per learner: their actual mistakes, in their actual
German, over time. That feeds three existing features for free — the
worksheet's weak-spots scope, the Word Library ("your words"), and §5.

## 5. Close the loop: a coach that remembers

With stored corrections, the builder gains one optional section:

    PERSONAL FOCUS
    Last time I mixed up these — work one or two of them in naturally,
    and tell me in the report whether I've improved:
    - "ich habe gegangen" -> "ich bin gegangen"
    - dass-clause word order

Rendered from the learner's last 2–3 stored corrections (matching the
course), capped, and dropped when empty. This is spaced repetition over
the learner's *personal* errors — the thing a human tutor does and no
static course can. It is also the moment the product stops being "120
prompts" and becomes "a coach". No server, no account: it all lives in
the same local store as everything else.

## 6. Smaller upgrades that ride along

- **Prompt language follows the level**: from B2.1 write the whole prompt
  in German. Immersion, primes the model into German, and makes the
  German-language report natural instead of contested. (The template
  system already supports per-language templates — this adds a per-level
  template choice, not new machinery.)
- **`reportLanguage` as a field** (from Part 1), rendered in the REPORT
  block.
- **A self-check line before the report**: "Check: every practise point
  covered? every MATERIAL item used? Then write the report." One line,
  measurably better coverage on weak models.
- **One worked exchange** in conversation-family prompts (question →
  imperfect answer → neutral reaction) to anchor the no-corrections rule
  by example rather than prohibition.
- **Honest-mode nudge, not enforcement**: scores are self-reported and
  always will be; pasting reports (§4) adds natural friction and makes
  the honest path the convenient one. Don't build anti-cheat.

## 6b. Additions (2026-09-09, second pass)

- **A delimited report the student can't miss.** The report renders between
  unmistakable marker lines — `===== REPORT START =====` … `SCORE=<n>` …
  `===== REPORT END =====` — so the learner knows exactly what to copy, and
  the app can extract the report (and its `FIX:` lines) from any paste that
  contains the markers. The score line stays inside the block, right before
  the end marker.
- **The worksheet PDF joins the course.** en_de_ai is all speaking quizzes,
  which the worksheet builder currently skips (`_printable` → false), so
  the course has no PDF at all. But the MATERIAL payloads are printable
  curriculum: every `german = meaning` pair (the `·`-separated chunk lists
  of drills and vocab exercises) becomes a fold-away worksheet item —
  German chunk on the left, meaning in the answer column. Exercises whose
  material has no pairs simply contribute nothing.
- **"Train what you're failing".** Once `FIX:` corrections are stored
  (§4), the course home offers a generated exercise built from the
  learner's own recent mistakes: a translation drill whose material *is*
  their fix log ("what I said → correct German"). It reuses the existing
  speaking prompt machinery — a synthetic exercise, not new plumbing — and
  appears once enough corrections have accumulated.

## 7. Delivery in three self-contained phases

1. **Template v3** (§1 + §2 + §3 + §6 fields): builder composes per
   mode-family; bump `templateVersion` to 3; gate test extends to "no
   family renders a contradicting rule" (assert the no-drills text never
   co-renders with drill modes, etc.). All 120 exercises untouched.
2. **Report capture** (§4): `FIX:` line format in the report block, a
   parser next to `parseSpeakingScore`, storage alongside the saved
   score, UI copy change on the score field.
3. **Personal focus** (§5): builder reads stored corrections, renders the
   optional section; worksheet weak-spots and Word Library integration.

Each phase ships alone and improves the feature on its own; §5 is the one
that changes what the product *is*.
