# M5.5 — Case-spotting in a text  (reading quiz draft)

> Course: en_de · Module 5 "Putting the Cases Together" · quiz kind: `reading`
> Edit this file freely. When it's ready, I compile it into `en_de.json`.

## Two-phase plan

- **Phase 1 (now):** this runs as a normal `reading` quiz — passage on top, the questions
  below. No new code. This is how we ship the A2 course.
- **Phase 2 (later):** a richer "interactive text" quiz kind puts the controls *inline* on
  the words — a Nom/Akk/Dat **selector** on a marked part, or a **text input** to type the
  declined form. Same data as below, just a better interaction on top — so nothing authored
  here is wasted.

## How to edit (the format)

- Write the German passage in **Passage (DE)**.
- Mark each interactive word/phrase with `{N:phrase}`, numbered in order.
  Example: `{1:Lukas} steht früh auf.`
- Keep an English version in **Passage (EN)** (shown behind the info button).
- In **Questions**, one line per marked part, with a **mode**:
  - `select` → learner picks the case. `answer` = Nominativ | Akkusativ | Dativ | Genitiv.
  - `input`  → learner types the correct form. `answer` = the word to type (e.g. *dem*); in
    the live exercise that spot shows a blank.
- The question word + case become the answer options automatically.

---

## Passage (DE)

Es ist Montagmorgen. {1:Lukas} steht früh auf. Er macht {2:einen Kaffee} für das
Frühstück. Seine Schwester Mia schläft noch, deshalb bringt Lukas {3:ihr} den Kaffee
ans Bett. „Danke!", sagt {4:Mia}. Nach dem Frühstück gibt Mia {5:dem Hund} sein Futter.
{6:Der Hund} heißt Bello. Am Abend kocht {7:der Vater} das Essen und gibt {8:der Mutter}
einen Teller.

## Passage (EN)

It's Monday morning. Lukas gets up early. He makes a coffee for breakfast. His sister
Mia is still sleeping, so Lukas brings her the coffee in bed. "Thanks!" says Mia. After
breakfast Mia gives the dog its food. The dog is called Bello. In the evening the father
cooks dinner and gives the mother a plate.

## Questions

| N | phrase        | mode   | question / prompt           | answer     |
|---|---------------|--------|-----------------------------|------------|
| 1 | Lukas         | select | Wer steht auf?              | Nominativ  |
| 2 | einen Kaffee  | select | Was macht er?               | Akkusativ  |
| 3 | ihr           | select | Wem bringt er den Kaffee?   | Dativ      |
| 4 | Mia           | select | Wer sagt „Danke"?           | Nominativ  |
| 5 | dem Hund      | select | Wem gibt Mia das Futter?    | Dativ      |
| 6 | Der Hund      | select | Wer heißt Bello?            | Nominativ  |
| 7 | der Vater     | select | Wer kocht?                  | Nominativ  |
| 8 | der Mutter    | input  | type the article (Dativ)    | der        |

## Notes

- Teaching contrast built in: {7} der Vater (Nominativ) vs {8} der Mutter (Dativ) —
  same word "der", different case → the case comes from the job in the sentence.
- TODO ideas: make it longer · add a Genitiv · add a "same word, three cases" trick.
