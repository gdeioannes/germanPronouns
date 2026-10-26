# Games by level — "Ja oder Nein?" and "Schreib mir!"

Written 2026-10-25, after the site review. The question was "only A1, really?".
The answer differs for the two games, so the plan does too.

## Where each game stands

**Schreib mir!** already covers every sub-level. The 51 personas in
`assets/content/match/` carry a `level` field: 7 at A1.1, 7 at A1.2, 6 at A2.1,
6 at A2.2, 5 at B1.1, 5 at B1.2, 4 at B2.1, 4 at B2.2, 2 at C1.1, 2 at C1.2,
2 at C2.1 and 1 at C2.2 (the queue in `docs/match_chat_queue.md`, spread
"A 25, B 18, C 7", is done). The deck already deals the chat of the learner's
level. What is thin is C: one or two chats per sub-level means a C2 learner has
seen the whole shelf after one evening.

**Ja oder Nein?** has ten themes in `assets/content/janein/` (deutsch, essen,
freund, getränk, jahreszeit, party, reise, stadt, tier, wg), each 10 rounds of
12 swipes, and **no level at all**. Every question is a one-line A1/A2 sentence
(*Du hast Hausschuhe für Gäste?*), so the game is fun at any level but teaches
nothing new past A2. The deck deals a theme regardless of level.

## The plan

### 1. Ja oder Nein?: level the themes, then add one theme per level band

Add a `level` field to each theme file and to the validator
(`tool/check-janein.mjs`), and let the deck surprise (`src/lib/domain/deck.ts`,
`deckSurprise`) prefer the themes at or below the learner's level, the way chats
are already picked. The ten existing themes are A1–A2.

Then write new themes whose *questions* use the level's grammar, one per band,
in this order (the result page, the personas and the share card need no change):

| Band | Theme (working title) | What the 120 questions practise |
|---|---|---|
| B1 | *Welcher Kollege bist du?* (the office) | weil/obwohl clauses, Konjunktiv II requests, Präteritum of modal verbs |
| B1 | *Welcher Nachbar bist du?* | relative clauses, two-part connectors, Perfekt vs Präteritum |
| B2 | *Welcher Diskutierer bist du?* (debate style) | concessive and adversative connectors, Passiv, Partizip as adjective |
| B2 | *Welcher Mieter bist du?* | nominal style of letters, Konjunktiv II irreal, indirect questions |
| C1 | *Welcher Leser bist du?* | modal supposition (dürfte, soll, will), participial attributes, hedging |
| C2 | *Welcher Redner bist du?* | focus particles (ausgerechnet, erst), Konjunktiv I reports, idioms |

Each theme: 5 personas, 10 rounds × 12 questions, every question a joke or a
twist (the fun-not-lesson rule), validated with `tool/check-janein.mjs`, then
recorded with `npm run audio -- --source "ja oder nein"`. One theme is roughly
one authoring session; six themes is six sessions.

### 2. Schreib mir!: fill C to the same depth as B

Bring C1.1, C1.2, C2.1 and C2.2 from one or two chats to four each, twelve new
chats, one batch of five at a time by the recipe in
`docs/match_chat_authoring.md` and `docs/match_chat_queue.md`. Premises first,
as with the songs: pitch twelve one-line premises, GDI picks, then write.
Candidates in the house style (absurd situation, grammar hidden in it):

- C1.1 — a Nobel committee calling the wrong person; a building's lift that only
  answers in nominal style
- C1.2 — a cultural attaché who hedges everything (dürfte, soll); a book reviewer
  who speaks only in participial attributes
- C2.1 — a notary reading a will in three registers; a radio host who quotes
  everyone in Konjunktiv I
- C2.2 — a philosophy seminar's coffee machine; an Austrian and a Swiss arguing
  about the word for January; a crossword setter paying in puns

Each chat needs its image (`tool/build-match-images.mjs`) and voice lines
(`tool/record-match-voices.mjs`), both run with the keys in `.env`.

### 3. Not in this plan

- Pictures per deck card for B and C: a separate pass with the image key, by
  level as decided (the A sets as the pattern, same count for B, new for C).
- A third game. Two games with twelve levels of content beat three games at A1.
