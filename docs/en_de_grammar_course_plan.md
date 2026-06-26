# German Grammar in Detail — Course Plan

> Course id: `en_de` · uiLang `en` · learnLocale `de-DE` · English speakers learning German grammar.
> Status: **proposed** (not yet built). Updated 2026-06-26.

## The approach

Rebuild `en_de` from its 4 big reference quizzes into a **step-by-step grammar course**, built
the same way as the sister course `de_es` (gated modules, authored in JSON, no engine changes).

Four rules guide the design:

1. **One thing per module.** Each hard point is met in isolation, drilled, then reused later.
2. **Natural case order:** Nominative → Accusative → Dative → Genitive (frequency-first).
3. **Prerequisites first.** A structure only appears once its pieces exist.
4. **Practice it four ways:** see the form → use it in a sentence → read it in a text → **hear
   and say it** (audio). Direct knowledge first, context second, ear & mouth third.

**The heart of the course is M3–M11 (A2).** A1 is the on-ramp; B1/B2 are depth.

## Quiz types used

**Written (the `fillBlank` / `reading` engines):**
1. **`fill_blank_table`** — asks the **form directly** (paradigm drill): *der → den*.
2. **`fill_blank_sentence`** — the form **in a standalone sentence**: *Ich sehe ____ Hund*.
3. **`fill_blank_long_text_reading`** — marked spots **inside one connected passage**; pick the
   case (Wer→Nom/Wen→Akk/Wem→Dat) or type the form. The "big text". *(Phase 1: runs as a
   `reading` quiz; Phase 2: a new page puts the selector/input inline — same data, no rewrite.)*
4. **`reading_comprehension`** — a passage + multiple-choice questions about its **meaning**.

**Audio — 🔊 (the TTS/STT engines, already used by `de_cert_a1`):**
5. **`speak_repeat`** — the app says it, the learner **repeats aloud** (STT). Production.
6. **`dictation`** — the app says it, the learner **types what they hear**. ⭐ Best for the
   unstressed endings (dem/den, -e/-en/-em) you must catch by ear.
7. **`listening`** — the app reads a **hidden** passage, the learner **answers**. Comprehension
   & audible case contrasts (*„in den"* vs *„im"*).

## Authoring principle — one example set per module

Write **one coherent set of sentences + one short text per module**, engineered to:
- **cover every subject/form** the module teaches (every case, gender, preposition, verb …), and
- **demonstrate the key contrast** (e.g. *Ich sehe den Hund* (m, changes) **vs** *die Katze*
  (f, unchanged) — the whole point of the accusative in one pair).

Then **reuse the same German everywhere**: as the worked examples in **Help Memory**, as the
**`fill_blank_sentence`** bank, as the **`fill_blank_long_text_reading`** passage, and read
aloud for the **🔊 audio** (`speak_repeat` / `dictation` / `listening`). Write it once — it
teaches, tests in a sentence, tests in a text, and is heard and said.

## Authoring principle — make the texts worth reading

Every passage must be **memorable**: funny, surprising, or genuinely interesting — never dry
(*"Ich sehe den Hund. Ich sehe die Katze."*). Pick a theme that **naturally forces the target
grammar** *and* makes the learner smile, while still showing the concept cleanly and covering
every form. The joke and the grammar should be the same thing:

- **Accusative** → a hungry monster that **eats everything** (every object = accusative):
  *Das Monster frisst den Tisch, die Lampe, das Sofa und sogar die Hausaufgaben!*
- **Dative** → an over-generous grandma who **gives presents to everyone** (recipients = dative).
- **Two-way prepositions** → a cat that **won't stay put** (auf den Tisch / unter dem Stuhl …).
- **Perfekt** → "my disastrous weekend" — everything went wrong (a chain of past actions).

Optional through-line: a **recurring cast** (the monster, Oma, the cat) across modules, so the
course reads like a little world the learner returns to — familiarity makes it stickier.

---

## Modules → quizzes (with type)

### A1 · Foundations

**M1 — Present Tense & Word Order**
- **1.1** `fill_blank_table` — present tense regular verbs (machen/wohnen/spielen)
- **1.2** `fill_blank_table` — *sein* & *haben*
- **1.3** `fill_blank_sentence` — the verb-second (V2) rule
- **1.4** `fill_blank_sentence` — yes/no & W-questions
- **1.5** `fill_blank_long_text_reading` — „Das bin ich" (self-introduction)
- **1.6** 🔊 `speak_repeat` — greetings & introductions, said aloud
- **1.7** 🔊 `dictation` — short present-tense sentences (catch the verb ending)

**M2 — Gender & the Nominative**
- **2.1** `fill_blank_table` — der/die/das of common nouns (colour-coded by gender)
- **2.2** `fill_blank_sentence` — gender by ending (-ung→die, -chen→das, -er→der …)
- **2.3** `fill_blank_sentence` — ein/eine/kein
- **2.4** `fill_blank_table` — personal pronouns (nominative)
- **2.5** `fill_blank_long_text_reading` — „Meine Familie" (find each subject = Nominativ)
- **2.6** 🔊 `speak_repeat` — „der Hund · die Katze · das Kind" (article + noun aloud)
- **2.7** 🔊 `dictation` — hear a noun, write **article + noun** (gender by ear; das Mädchen!)

**M3 — The Accusative**
- **3.1** `fill_blank_table` — accusative articles (only der→den)
- **3.2** `fill_blank_sentence` — haben/möchte + accusative
- **3.3** `fill_blank_table` — accusative pronouns (mich/dich/ihn)
- **3.4** `fill_blank_sentence` — accusative prepositions (durch, für, gegen, ohne, um)
- **3.5** `fill_blank_long_text_reading` — „Im Supermarkt" (spot/produce the accusative)
- **3.6** 🔊 `speak_repeat` — „Im Geschäft" (Ich möchte einen Kaffee)
- **3.7** 🔊 `dictation` — der vs den by ear (Ich sehe **den** Hund)

**M4 — The Dative**
- **4.1** `fill_blank_table` — dative articles (dem/der/dem/den +n)
- **4.2** `fill_blank_table` — dative pronouns (mir/dir/ihm)
- **4.3** `fill_blank_sentence` — dative verbs (helfen, gehören, gefallen, danken)
- **4.4** `fill_blank_sentence` — dative prepositions (aus, bei, mit, nach, seit, von, zu)
- **4.5** `fill_blank_long_text_reading` — „Ein Brief an Oma" (spot/produce the dative)
- **4.6** 🔊 `speak_repeat` — „Geschenke" (Ich danke dir · Das gefällt mir)
- **4.7** 🔊 `dictation` — ⭐ dem / den / der discrimination

**M5 — Putting the Cases Together** *(integration ladder + big text)*
- **5.1** `fill_blank_long_text_reading` — just the **question** (Wer? / Wen? / Wem?)
- **5.2** `fill_blank_long_text_reading` — just the **case** (Nominativ / Akkusativ / Dativ)
- **5.3** `fill_blank_long_text_reading` — **both** (Wer→Nom · Wen→Akk · Wem→Dat)
- **5.4** `fill_blank_sentence` — **produce** the article, all 3 cases mixed
- **5.5** `fill_blank_long_text_reading` — the **big text** („Ein Montagmorgen")
- **5.6** 🔊 `dictation` — write mixed-case sentences (catch every ending)
- **5.7** 🔊 `listening` — hear a sentence → which case is the marked part?

**M6 — Two-Way Prepositions**
- **6.1** `fill_blank_table` — the 9 Wechselpräpositionen
- **6.2** `fill_blank_sentence` — **Wohin?** (motion) → accusative
- **6.3** `fill_blank_sentence` — **Wo?** (location) → dative
- **6.4** `fill_blank_sentence` — mixed; choose the case from the verb
- **6.5** `fill_blank_long_text_reading` — „In der Stadt" (Wo/Wohin in a passage)
- **6.6** 🔊 `listening` — ⭐ „in den" vs „im" — hear the case
- **6.7** 🔊 `speak_repeat` — Wo/Wohin sentences aloud

**M7 — Adjective Endings (intro)**
- **7.1** `fill_blank_sentence` — predicate adjectives, no ending (*Das Haus ist alt*)
- **7.2** `fill_blank_table` — after der/die/das, nominative
- **7.3** `fill_blank_sentence` — after der/die/das, accusative
- **7.4** `fill_blank_table` — after ein/mein, nominative
- **7.5** `fill_blank_long_text_reading` — „Die neue Wohnung" (type the endings in a text)
- **7.6** 🔊 `dictation` — ⭐ write the adjective endings you hear (-e / -en / -er)
- **7.7** 🔊 `speak_repeat` — „der nette Mann · ein netter Mann"

**M8 — The Perfekt (spoken past)**
- **8.1** `fill_blank_table` — regular participles (ge-…-t)
- **8.2** `fill_blank_table` — strong participles (ge-…-en + vowel change)
- **8.3** `fill_blank_sentence` — *haben* or *sein*?
- **8.4** `fill_blank_sentence` — word order (participle at the end)
- **8.5** 🔊 `speak_repeat` — „Mein Wochenende" (narrate in Perfekt)
- **8.6** 🔊 `listening` — „Eine Reise" (hear a past narrative, answer)

**M9 — Modal & Separable Verbs**
- **9.1** `fill_blank_table` — modal conjugation (können/müssen/wollen/sollen/dürfen/mögen)
- **9.2** `fill_blank_sentence` — modal + main verb at the end
- **9.3** `fill_blank_sentence` — separable verbs (aufstehen, einkaufen …)
- **9.4** `fill_blank_sentence` — imperative (du / ihr / Sie)
- **9.5** `fill_blank_long_text_reading` — „Mein Tag" (modals/separables in a text)
- **9.6** 🔊 `speak_repeat` — daily routine with separable verbs
- **9.7** 🔊 `dictation` — catch the separable prefix at the end

**M10 — Comparisons**
- **10.1** `fill_blank_table` — comparative & superlative (incl. gut/besser/am besten)
- **10.2** `fill_blank_sentence` — *als* / *wie*
- **10.3** `reading_comprehension` — „Stadt oder Land?"
- **10.4** 🔊 `speak_repeat` — comparisons aloud (größer als …)
- **10.5** 🔊 `listening` — hear two things compared → answer

**M11 — Connecting Sentences**
- **11.1** `fill_blank_sentence` — coordinating: und / aber / oder / denn (no change)
- **11.2** `fill_blank_sentence` — *weil* (verb to the end)
- **11.3** `fill_blank_sentence` — *dass*
- **11.4** `fill_blank_sentence` — *wenn*
- **11.5** `fill_blank_long_text_reading` — „Warum lernst du Deutsch?" (connectors in a text)
- **11.6** 🔊 `listening` — hear a *weil*-reason, pick the matching clause
- **11.7** 🔊 `dictation` — write subordinate clauses (verb at the end)

### B1 · Detail & Depth

**M12 — Full Adjective Declension**
- **12.1** `fill_blank_table` — weak (after der-words)
- **12.2** `fill_blank_table` — mixed (after ein-words)
- **12.3** `fill_blank_table` — strong (no article)
- **12.4** `fill_blank_sentence` — all three, mixed across the four cases
- **12.5** `fill_blank_long_text_reading` — adjective-rich description (type the endings)
- **12.6** 🔊 `dictation` — ⭐ write the endings you hear
- **12.7** 🔊 `speak_repeat` — declined phrases aloud

**M13 — Genitive & Präteritum**
- **13.1** `fill_blank_sentence` — genitive (des/der + -s)
- **13.2** `fill_blank_sentence` — genitive vs *von* + dative
- **13.3** `fill_blank_sentence` — n-declension (der Junge → den Jungen)
- **13.4** `fill_blank_table` — Präteritum (war/hatte/konnte + strong verbs)
- **13.5** 🔊 `listening` — „Ein Märchen" (Präteritum narrative, heard)
- **13.6** 🔊 `dictation` — Präteritum forms (ging/kam/sah …)

**M14 — Relative Clauses**
- **14.1** `fill_blank_table` — relative pronouns (der/die/das/dem/den/dessen/deren)
- **14.2** `fill_blank_sentence` — case set by the verb inside the clause
- **14.3** `fill_blank_sentence` — preposition + relative pronoun
- **14.4** `fill_blank_long_text_reading` — find each relative pronoun's case in a text
- **14.5** 🔊 `speak_repeat` — definitions („Ein Arzt ist jemand, der …")
- **14.6** 🔊 `listening` — „Der Mann, der …" (a profile, heard)

**M15 — Konjunktiv II & Reflexive Verbs**
- **15.1** `fill_blank_table` — würde / wäre / hätte / könnte
- **15.2** `fill_blank_sentence` — *würde* + infinitive
- **15.3** `fill_blank_sentence` — polite requests & wishes
- **15.4** `fill_blank_sentence` — reflexive verbs (sich; mich vs mir)
- **15.5** 🔊 `speak_repeat` — „Wünsche & Höflichkeit" (Könnten Sie …?)
- **15.6** 🔊 `dictation` — write the umlaut forms (wäre / hätte)

### B2 · Advanced — *optional ceiling*

**M16 — The Passive**
- **16.1** `fill_blank_table` — werden + participle (Vorgangspassiv)
- **16.2** `fill_blank_sentence` — passive in all tenses (wurde / ist…worden)
- **16.3** `fill_blank_sentence` — passive with modals
- **16.4** `fill_blank_sentence` — sein-passive (Zustandspassiv) + alternatives (man, sich lassen)
- **16.5** `fill_blank_long_text_reading` — „Wie wird Brot gemacht?" (passive in a process text)
- **16.6** 🔊 `listening` — a process description, heard
- **16.7** 🔊 `dictation` — passive sentences

**M17 — Indirect Speech & Participles**
- **17.1** `fill_blank_table` — Konjunktiv I forms (sei, habe, gehe, könne)
- **17.2** `fill_blank_sentence` — reported speech
- **17.3** `fill_blank_sentence` — Partizip I / II as adjectives
- **17.4** `fill_blank_sentence` — advanced connectors (deshalb, trotzdem, obwohl)
- **17.5** `reading_comprehension` — „In den Nachrichten"
- **17.6** 🔊 `listening` — news in indirect speech, heard
- **17.7** 🔊 `speak_repeat` — report what someone said

### ★ Mastery & Reference (the existing 4 quizzes)
The current `article`, `pronoun`, `pronoun_article`, `preposition` mega-quizzes stay as the
comprehensive end-game drills. The existing **Noun Categories** chain stays as supporting
vocabulary.

---

## Totals & build order

- 17 modules · ~110 quizzes (each module: written drills + one long text + 🔊 audio block).
- Every module now practices its content **four ways**: form (table) → sentence → long text →
  audio (say it / hear-and-type it / listen & answer).
- **Build module-by-module, verified as we go.** Suggested first slice: **M3 + M4 + M5**
  (Accusative → Dative → integration) — the heart of A2.

## Technical notes

- All JSON, no Dart (Phase 1). The 🔊 audio types (`speak_repeat`, `dictation`, `listening`)
  already run in `de_cert_a1`; this is `en_de`'s first use of them. Each module = a gated
  `NavGroup`. Regenerate with `dart run tool/generate_content.dart`.
- Audio uses the existing TTS voice chain; set `voiceGender` per quiz where a speaker differs.
- Bump `version` in `en_de.json` (currently `1.5.0`). **Storage-key prefixes are immutable.**
- Working drafts for hand-authored long texts live in `docs/en_de/` (e.g. `m5_cases_text.md`).

## Sources
- Goethe-Institut course levels A1–C2: https://www.goethe.de/en/spr/kur/stu.html
- Beyond German — Grammar A1→C2 map: https://www.beyondgerman.com/grammar
- DaF case-teaching order (frequency-first): german.net, germanwithlaura.com, nthuleen.com
