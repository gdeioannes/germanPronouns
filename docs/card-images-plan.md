# Card pictures for every exercise: plan v2 (shared pictures)

**Goal:** every card in the swipe deck shows a picture in its cream art band.
The picture belongs to the **card**. The exercise does not have to show it.
**Constraint:** generate as few new images as possible. Each level gets one
shared picture per exercise type, and only hard topics get a picture of their
own.

## Where things stand (2026-10-01)

| Type | Exercises | Have a picture |
|---|---:|---:|
| reading / bigtext | 43 | 43, each its own (keep) |
| listening | 27 | 27, each its own (keep) |
| speaking | 24 | 24, borrowed from the level's scene (keep) |
| fillBlank (grammar drill) | 226 | 0 |
| speakRepeat (repeat aloud) | 24 | 0 |
| dictation | 11 | 0 |
| vocabulary (flashcards) | 12 | 0 |

## What gets generated: 72 images (≈ $3), down from 273 (≈ $11)

| Group | Count | Who uses it |
|---|---:|---|
| Shared **grammar drill** picture per level | 12 | every grammar drill in that level that is not a hard topic (~200 cards) |
| Shared **repeat aloud** picture per level | 12 | the 2 repeat-aloud exercises in that level |
| Shared **dictation** picture per level | 12 | the dictation in that level (11 levels have one; C2.2 has none, so its entry is spare) |
| Shared **flashcards** picture per level | 12 | the level's Wortschatz deck |
| Own picture for a **hard topic** | 24 | that one exercise only |

Reading, listening and speaking exercises stay as they are; none of them
needs a new picture.

Within a level, the four shared pictures use the same setting (the level's
theme), and each one shows a different activity, so the type reads at a
glance. Example: at B1.1 (work), the grammar picture is a colleague's desk
with a notebook, repeat aloud is someone speaking at a meeting, dictation is
someone writing down a voicemail, and flashcards is a flat-lay of office
things. Within one level the deck stays varied, and from one level to the
next the pictures change.

## How it works

1. **Manifest ids.** The shared pictures get ids
   `card_<type>_<level>`, for example `card_grammar_a1_1`, `card_repeat_b2_2`,
   `card_dictation_c1_1`, `card_words_a2_1`. A hard topic uses its quiz id,
   like the reading scenes do. All of them are 4:3 and their prompts start
   with `scene:`.
2. **Linking.** `linkImages()` in `tool/gen-images.mjs` gets one fallback. A
   quiz with no scene of its own gets `card_<type>_<level>` when that WebP
   exists. Speaking keeps its current borrowing. The fields stay the same: it
   is still `quiz.image`.
3. **Not in the quiz.** The grammar drill, dictation, repeat-aloud and
   flashcard pages never render `quiz.image`. So the picture appears on the
   deck card (and the level-page thumbnail) and nowhere inside the exercise.
4. **Looks good in the band.** The band is 42% of the card height and uses
   `object-fit: cover`, so prompts ask for a wide, low composition with the
   subject in the middle and empty paper margins. The house style still
   applies: no text, letters or digits, and the backdrop is levelled to
   #fbf5e4.
5. **Run it.** Do A1.1 first (6 pictures: the 4 shared ones and its 2 hard
   topics) and check them on the deck. Then run the remaining 66.
6. **Guard it.** Add a test in `content.test.ts` so that every non-placeholder
   quiz has an `image` whose WebP exists.

## Shared pictures (48): one per type per level

| Level | Theme / setting | Grammar drill | Repeat aloud | Dictation | Flashcards |
|---|---|---|---|---|---|
| A1.1 | first days, café & numbers | a learner at a café table with a notebook and pencil | a person saying hello to a neighbour, hand raised | a learner with headphones writing in a notebook at a café | flat-lay: apple, key, cup, book |
| A1.2 | daily routine & shopping | a kitchen table with a notebook beside a breakfast plate | a shopper speaking to a market vendor | a person writing a shopping list while listening to a phone | flat-lay: clock, shopping bag, ticket, mug |
| A2.1 | weekend & travel | a traveller studying in a train compartment | a tourist asking a passer-by, both talking | a traveller writing a postcard on a suitcase | flat-lay: umbrella, sunglasses, map, scarf |
| A2.2 | home & health | a cosy living room desk with a notebook and plant | a person describing their room with open arms | a person at home writing notes with headphones | flat-lay: toothbrush, plaster, coat, keys |
| B1.1 | work | an office desk with an open notebook and coffee | a colleague speaking at a meeting table | an office worker writing down a voicemail | flat-lay: briefcase, laptop, badge, coffee |
| B1.2 | stories, tech & media | a sofa with a tablet and notebook | a storyteller speaking to a small audience | a person transcribing a podcast at a laptop | flat-lay: phone, headphones, charger, remote |
| B2.1 | society & opinion | a library table with newspapers and a notebook | a speaker at a small community podium | a reporter writing in a notepad at a press event | flat-lay: newspaper, ballot, megaphone, globe |
| B2.2 | science & environment | a field-station desk with a notebook and leaf samples | a scientist presenting beside wind turbines | a researcher writing notes outdoors with a recorder | flat-lay: microscope, leaf, flask, solar cell |
| C1.1 | education & research | a university study carrel with stacked books | a lecturer speaking at a lectern | a student writing fast in a lecture hall | flat-lay: graduation cap, books, glasses |
| C1.2 | culture & media | a theatre-café table with a programme and notebook | an actor speaking on a small stage | a critic writing in a dark cinema by a reading light | flat-lay: film reel, camera, ticket, newspaper |
| C2.1 | economy & law | a lawyer's desk with a fountain pen and documents | a speaker addressing a formal assembly | a court stenographer at work | flat-lay: gavel, contract, coins, briefcase |
| C2.2 | philosophy & thought | a study with an armchair, a lamp and an open book | two debaters at facing lecterns | a writer with a quill at an old desk, listening | flat-lay: lantern, quill, globe, telescope |

## Hard topics with their own picture (24): my pick, 2 per level

These are the grammar points learners find hardest. Each one gets its own
picture, which shows the idea as one everyday moment. Swap any you disagree
with. The count stays the same.

| Level | Quiz id | Topic | Scene |
|---|---|---|---|
| A1.1 | a1_1_artikel | der / die / das | a table with a lamp, a cup and a book set side by side |
| A1.1 | a1_1_vokalwechsel | irregular verbs | a man reading a newspaper while a woman eats breakfast |
| A1.2 | a1_2_akkusativ | Akkusativ | a woman putting bread and apples into a shopping basket |
| A1.2 | a1_2_modalverben | Modalverben | a child wanting an ice cream, a parent shaking a finger |
| A2.1 | a2_1_perfekt_haben | Perfekt | a person who has just painted a fence, brush in hand |
| A2.1 | a2_1_dativ_akkusativ | Dativ + Akkusativ | a grandfather handing a child a book |
| A2.2 | a2_2_wechsel_wohin | Wechselpräpositionen | a person placing a vase onto a table by a window |
| A2.2 | a2_2_relativ_intro | Relativsätze | a woman pointing at the man in a yellow hat in a crowd |
| B1.1 | b1_1_adj_bestimmt | adjective endings | a shop window with a striped scarf on a mannequin |
| B1.1 | b1_1_konj2_wuerde | Konjunktiv II | an office worker daydreaming of a beach |
| B1.2 | b1_2_passiv | Passiv | a parcel being loaded into a delivery van |
| B1.2 | b1_2_plusquamperfekt | Plusquamperfekt | a person reaching the platform as the train leaves |
| B2.1 | b2_1_konj1 | Konjunktiv I / indirect speech | a news reporter with a microphone outside a building |
| B2.1 | b2_1_partizip_adj | participle as adjective | a freshly painted bench, still glossy |
| B2.2 | b2_2_konj2_verg | Konjunktiv II past | a person soaked in the rain, umbrella left at home |
| B2.2 | b2_2_partizip_attribut | extended participle | a long, freshly baked loaf cooling on a rack |
| C1.1 | c1_1_nominalisierung | Nominalisierung | a scientist at a desk under stacks of papers |
| C1.1 | c1_1_partizipialsatz | Partizipialsätze | a person walking home humming, grocery bags in hand |
| C1.2 | c1_2_modal_hoerensagen | hearsay modals (soll, will) | a row of people passing a whisper ear to ear |
| C1.2 | c1_2_redewendungen | idioms | a cat sneaking out of an open bag |
| C2.1 | c2_1_stilmittel | rhetoric | an orator gesturing dramatically on stone steps |
| C2.1 | c2_1_konnotation | connotation | a slim cat and a plump cat side by side |
| C2.2 | c2_2_anspielung | implicature | a person winking while handing over a gift |
| C2.2 | c2_2_behoerdensprache | officialese | a bewildered citizen at a counter with a long form |

## Open questions

- **"Module" = sub-level** (A1.1, A1.2, …), giving 12 modules. If you meant
  the CEFR level (A1, A2, …), the shared pictures drop from 48 to 24.
- **Hard topics:** is two per level right, or should it be more or fewer?
