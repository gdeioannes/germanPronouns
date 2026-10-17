# Match chat: Oma Helga, techno DJ (A1)

**Built** as "Schreib mir!" at `/play/schreib-mir`. Content:
`assets/content/match/helga.json`. Engine and tests: `src/lib/domain/matchChat.ts`.
Pictures: `assets/images/match_manifest.json` (`node tool/gen-images.mjs --story
--manifest assets/images/match_manifest.json`). Voice: `npm run story-audio --
helga --gemini-api`. The techno loop and record scratch: `npm run story-sfx`.

The first complete script for the match chat game. Swipe a character, match,
chat to reach a goal. Every chat happens **once**: no retry, a deleted match is
gone. A won chat ends with a like and the character saved to your contacts.

## The character

```
┌──────────────────────────────┐
│  🎧  Oma Helga, 81           │
│  "Ich bin 81. Ich bin DJ.    │
│   Ich schlafe nie."          │
│                              │
│  GOAL: Get on the guest list │
│  for Saturday's party in     │
│  her cellar club.            │
│                              │
│  Interest  ■■■■■▢▢▢▢▢        │
│  Every chat happens once.    │
│  Choose your words.          │
└──────────────────────────────┘
```

- **Level:** A1.
- **Grammar practised:** verb endings (ich tanze, ich heiße), telling the time,
  kein / keine, links / rechts, mein / meine, auf der Liste.
- **Listening and reading:** a flyer photo, two voice notes, a back-yard photo.
- **Turns:** 8, plus 2 in the secret branch.

## Rules of the engine

### The player always builds the answer

There are no answer options. Every turn gives a **word bank** of 12 to 20
tiles, and the player builds one or more sentences from it.

- The bank holds the words for **every branch** of that turn, so the player
  decides what to say: yes or no, dance or drink, alone or with Opa Günther.
- It also holds **wrong forms** next to the right ones: tanze / tanzt,
  kein / keine, mein / meine. Picking the right form is the grammar practice.
- Each tile can be used once. A word needed twice appears twice.
- Capitals at the start of a sentence and the final punctuation are fixed
  automatically, so the bank never needs both "Ich" and "ich".
- Short answers without a verb are fine when they answer the question
  naturally, such as "Um elf." or "Die Tür rechts."

### Keywords pick the branch

Each turn lists **intents**. An intent matches when the sentence contains its
keywords. They are checked from top to bottom, and the first match wins.

- **Negation flips meaning.** "Ich tanze gern" and "Ich tanze nicht gern" hit
  different intents. A verb with *nicht* beats a leading Ja or Nein.
- **Flags remember what the player said**, written as `flag` below. A later
  intent can be a contradiction of an earlier flag.
- **No intent matched** means the sentence doesn't answer the question.

### The sentence score

Every sent sentence gets a **score from 0 to 100**, shown as a small badge on
the chat bubble. It starts at 100, and each mistake takes points off.

| Mistake | Points off | Example |
|---|---|---|
| Wrong verb ending | −20 | ich tanzt |
| Wrong article, possessive or adjective form | −15 | kein Fotos, mein Hose |
| Verb in the wrong position | −30 | Ich gern tanze. |
| A full sentence with no verb | −50 | Ich gern Techno. |

The badge has three looks:

```
  Ja, ich tanze sehr gern!   ✓ 100
  Ich tanzt gern.            ~ 80
  Ich gern Techno.          ✗ 50
```

Tapping the badge shows what was taken off, for example
"−20 ich tanzt → ich tanze". The score is the learning feedback. Interest
decides the story.

**What the score does in the chat:**

| Score | Helga | Form bonus |
|---|---|---|
| 100 | Answers naturally | +1 |
| 60 to 99 | Understands and says the right form back | 0 |
| Below 60 | "Hä?" She can't follow, and the chat moves on | The turn counts as −1 |

### Interest

Interest starts at 5, is capped at 10, and the match is deleted the moment it
reaches 0. Each turn changes it by **the intent's value plus the form bonus**.

| Intent value | Meaning |
|---|---|
| +2 | A great answer for this turn |
| +1 | A good answer |
| 0 | Honest but not what she hoped for |
| −1 | A wrong answer, or no intent matched (no form bonus) |
| −2 | A contradiction or a lost negation (no form bonus) |

### Media

- **Photos** come in from the character and are part of the question.
- **Voice notes** play twice at most. The transcript only appears in the
  recap. A transcript button exists for deaf learners and uses up one play.
- **The player's own photos** are picked by what they *wrote*. Saying
  "Ich trage Schwarz" sends the all-black picture.

`{Name}` is the learner's display name, offered as a tile.

---

## Turn 1: Hello

> **Helga:** Hallo! Ich bin Helga. Ich bin 81. Ich bin DJ. 🎧 Und du? Wie heißt du?

```
[ Hallo ] [ ich ] [ ich ] [ heiße ] [ heißt ] [ bin ] [ {Name} ] [ und ] [ du ]
[ komme ] [ aus ] [ Berlin ] [ tanze ] [ gern ]
```

| Intent | Keywords | Value | Helga |
|---|---|---|---|
| Name | {Name} | +1 | Hallo, {Name}! Schöner Name. Wie ein DJ-Name! |
| Greeting only | Hallo, no name | −1 | Hallo! Und dein Name? Egal. Weiter. |

| Player builds | Score | Interest |
|---|---|---|
| Hallo! Ich heiße {Name}. | 100 | +2 |
| Ich bin {Name}. Ich tanze gern. | 100 | +2 |
| Ich heißt {Name}. | 80. Helga: Du *heißt* {Name}! Schön. | +1 |
| Ich {Name} heiße. | 70. Helga: Ah, du heißt {Name}! | +1 |
| Hallo! | 100, but no name | −1 |

## Turn 2: Do you dance?

> **Helga:** Am Samstag ist Party in meinem Keller. 🪩 Tanzt du gern?

```
[ ja ] [ nein ] [ ich ] [ ich ] [ tanze ] [ tanzt ] [ sehr ] [ gern ]
[ nicht ] [ aber ] [ trinke ] [ nur ] [ Walzer ] [ liebe ] [ Techno ]
```

| Intent | Keywords | Value | Helga | Flag |
|---|---|---|---|---|
| Waltz | Walzer | +1 | Walzer! Wie mein Mann und ich, 1962. Süß. | `waltz` |
| Drink | trinke | 0 | Ehrlich. Das mag ich. Aber nur Wasser, ja? | `honest` |
| Loves techno | liebe + Techno | +2 | Du liebst Techno? Du bist mein Mensch! | `dances` |
| No | tanze + nicht, or Nein | −1 | Nicht? Auf meiner Party tanzt jeder. Auch die Wand. | `noDance` |
| Yes | tanze + gern, or Ja | +1 | Wunderbar! Ich tanze seit 1955. | `dances` |

| Player builds | Score | Intent | Interest |
|---|---|---|---|
| Ja, ich tanze sehr gern! | 100 | Yes | +2 |
| Gern! Ich liebe Techno. | 100 | Loves techno | +3 |
| Nein, aber ich trinke gern. | 100 | Drink | +1 |
| Ich tanze nur Walzer. | 100 | Waltz | +2 |
| Ich tanzt gern. | 80 | Yes | +1 |
| Ich tanze nicht gern. | 100 | No | −1 |
| Ich gern Techno. | 50 | Hä? | −1 |

"Nein, ich tanze nicht, aber ich trinke gern" hits **Drink** first, because
drink is checked before no. Honesty beats a flat no.

## Turn 3: The flyer (photo)

> **Helga:** Hier ist der Flyer. 📷

```
┌──────────────────────────────┐
│        KELLERBEBEN           │
│   Samstag 23 Uhr bis         │
│   Sonntag 14 Uhr             │
│   DJ Oma Helga               │
│   Eintritt: 10 €             │
└──────────────────────────────┘
```

Image: a photocopied black-and-white flyer taped to a lamp post, Helga in
sunglasses behind turntables. The flyer text is drawn as an overlay so it's
always correct. Alt text is the flyer text itself.

> **Helga:** Also, wann beginnt die Party?

```
[ die ] [ Party ] [ beginnt ] [ beginnen ] [ um ] [ elf ]
[ dreiundzwanzig ] [ vierzehn ] [ zwei ] [ Uhr ] [ am ] [ Samstag ] [ Sonntag ]
```

| Intent | Keywords | Value | Helga |
|---|---|---|---|
| Right time | elf, dreiundzwanzig | +1 | Genau! Und dann bis Sonntag. 😎 |
| End time | vierzehn | −1 | Um vierzehn Uhr ist die Party *zu Ende*! Lies noch mal. |
| Middle of the night | zwei | −1 | Um zwei spiele ich mein bestes Set. Aber die Party beginnt um elf. |

| Player builds | Score | Interest |
|---|---|---|
| Um dreiundzwanzig Uhr. | 100 | +2 |
| Die Party beginnt am Samstag um elf. | 100 | +2 |
| Die Party beginnen um elf. | 80. Helga: Ja, die Party *beginnt* um elf! | +1 |
| Um elf die Party beginnt. | 70 | +1 |
| Um vierzehn Uhr. | 100 | −1 |

## Turn 4: The rules (voice note)

> **Helga:** 🎤 Voice note, 0:08

Audio, Helga shouting over loud techno from the cellar:
"Wichtig! Im Club gibt es zwei Regeln. Erstens: keine Fotos! Zweitens: nur
schwarze Kleidung! Schwarz! Verstanden?"

> **Helga:** Was sind die Regeln?

```
[ Keine ] [ Kein ] [ Fotos ] [ und ] [ nur ] [ schwarze ] [ schwarz ]
[ Kleidung ] [ Bier ] [ Handys ] [ Tanzen ] [ viel ]
```

| Intent | Keywords | Value | Helga | Flag |
|---|---|---|---|---|
| Lost negation | Fotos without keine / kein | −2 | Fotos?! NEIN! KEINE Fotos! 😱 | `saidBlack` if schwarz |
| Both rules | keine + Fotos and schwarz | +2 | Perfekt! Du hörst besser als mein DJ-Kollege. | `saidBlack` |
| No photos | keine + Fotos | +1 | Gut! Und die Kleidung? Schwarz! | |
| Black | schwarz | +1 | Ja! Und keine Fotos, okay? | `saidBlack` |
| Beer | Bier | −1 | Bier ist keine Regel. Bier ist eine Lebensweise. | |

| Player builds | Score | Interest |
|---|---|---|
| Keine Fotos und nur schwarze Kleidung. | 100 | +3 |
| Keine Fotos. | 100 | +2 |
| Kein Fotos und schwarz Kleidung. | 70. Helga: Ja! *Keine* Fotos, *schwarze* Kleidung. | +2 |
| Fotos und schwarze Kleidung. | 100 | −2 |
| Viel Bier und Tanzen. | 100 | −1 |

Perfect German doesn't save a lost negation. That's the lesson of this turn.

## Turn 5: Your outfit

> **Helga:** Was trägst du am Samstag? Schick mir ein Foto! 👗

```
[ Ich ] [ trage ] [ trägst ] [ Schwarz ] [ Gelb ] [ alles ] [ Mein ] [ Meine ]
[ Pullover ] [ Hose ] [ ist ] [ sind ] [ schwarz ] [ gelb ] [ eine ] [ ein ]
[ Lederhose ] [ Dirndl ] [ und ]
```

The app sends the photo that matches what the player wrote.

| Intent | Keywords | Photo sent | Value | Helga |
|---|---|---|---|---|
| Contradiction | gelb, with `saidBlack` | Neon yellow tracksuit | −2 | Du hast "schwarz" gesagt! Und dann GELB?! |
| Bee | schwarz + gelb | Black and yellow stripes | −1 | Schwarz und Gelb? Wie eine Biene. Hm. |
| Yellow | gelb | Neon yellow tracksuit | −1 | Gelb?! Hast du meine Sprachnachricht nicht gehört? |
| Costume | Lederhose, Dirndl | Lederhosen or dirndl | 0 | Ha! Das ist so falsch, dass es wieder cool ist. |
| Black | schwarz | All black, hoodie and boots | +1 | Perfekt. Du siehst aus wie ein Türsteher. 🖤 |

| Player builds | Score | Interest |
|---|---|---|
| Ich trage alles schwarz. | 100 | +2 |
| Meine Hose und mein Pullover sind schwarz. | 100 | +2 |
| Mein Hose ist schwarz. | 85. Helga: *Deine* Hose ist schwarz? Gut! | +1 |
| Ich trage ein Dirndl. | 100 | +1 |
| Ich trage eine Lederhose. | 100 | +1 |
| Ich trage Gelb. (with `saidBlack`) | 100 | −2 |

## Turn 6: The secret door (photo)

> **Helga:** Der Eingang ist geheim. Die Tür ist schwarz. Vor der Tür steht ein
> rotes Fahrrad.

> **Helga:** 📷 Welche Tür ist es?

Image (`match_backyard`): a Berlin back yard at night, flat front view, three
doors in a row. The clue was rewritten to fit the picture the model drew.

- **Left:** black, a yellow bike beside it.
- **Middle:** green, an old man glaring from its window (Herr Lehmann).
- **Right:** black, a red bike in front of it. This is the one.

```
[ die ] [ der ] [ Tür ] [ links ] [ rechts ] [ in der Mitte ] [ es ] [ ist ]
[ schwarze ] [ grüne ] [ mit ] [ dem ] [ roten ] [ gelben ] [ Fahrrad ]
```

| Intent | Keywords | Value | Helga |
|---|---|---|---|
| Right door | rechts | +1 | Ja! Du hast gute Augen. 👀 |
| Red bike | roten | +1 | Ja! Das rote Fahrrad. Du hast gute Augen. |
| Yellow bike | gelben | −1 | Gelb? Ich habe „rot“ gesagt! Das ist die falsche Tür. |
| Middle door | in der Mitte, grüne | −1 | Grün? Das ist die Tür von Herrn Lehmann. Er ist 90 und hasst Techno. |
| Left door | links | −1 | Fast! Aber das Fahrrad da ist gelb. |
| Too vague | schwarze or Fahrrad, without a side | 0 | Welche? Zwei Türen sind schwarz! Die rechte, mit dem roten Fahrrad. |

| Player builds | Score | Interest |
|---|---|---|
| Die Tür rechts. | 100 | +2 |
| Die Tür mit dem roten Fahrrad. | 100 | +2 |
| Es ist die schwarze Tür rechts. | 100 | +2 |
| Der Tür rechts. | 85 | +1 |
| Die Tür mit dem Fahrrad. | 100, too vague | +1 |
| Die grüne Tür. | 100 | −1 |

Alt text, in German as part of the challenge: "Ein Hof. Drei Türen. Links:
eine schwarze Tür, daneben ein gelbes Fahrrad. In der Mitte: eine grüne Tür,
ein alter Mann schaut aus dem Fenster. Rechts: eine schwarze Tür, davor ein
rotes Fahrrad."

## Turn 7: Who are you bringing?

> **Helga:** Kommst du allein oder mit Freunden?

```
[ ich ] [ komme ] [ kommst ] [ allein ] [ mit ] [ meinem ] [ meiner ] [ Opa ]
[ Schwester ] [ Freunden ] [ fünf ] [ einem ] [ Freund ] [ er ] [ heißt ]
[ Günther ] [ nicht ]
```

The Günther tile is just sitting there. Curious players will use it.

| Intent | Keywords | Value | Helga | Next |
|---|---|---|---|---|
| Günther | Günther | 0, no form bonus | … | Secret branch |
| Big group | fünf | −1 | Fünf?! Mein Keller ist klein. Einer. Maximal. | Turn 8 |
| Plus one | Schwester, einem Freund | 0 | Okay. Eine Person passt noch in die Ecke. | Turn 8 |
| Alone | allein, without nicht | +1 | Gut. Ich passe auf dich auf. | Turn 8 |

| Player builds | Score | Interest |
|---|---|---|
| Ich komme allein. | 100 | +2 |
| Ich komme mit meiner Schwester. | 100 | +1 |
| Ich komme mit meinem Schwester. | 85 | 0 |
| Ich komme mit fünf Freunden. | 100 | −1 |
| Ich komme mit meinem Opa. Er heißt Günther. | 100 | 0, secret branch |

### Secret branch, turn 7a: Günther (voice note)

> **Helga:** 🎤 Voice note, 0:07

Audio: a record scratch, the music stops.
"GÜNTHER?! Groß, Glatze, Hawaiihemd? Er war DJ in meinem Keller. 1999. Er hat
meine Platten gestohlen!"

> **Helga:** Ist er nett, dein Günther?

### Secret branch, turn 7b

```
[ ja ] [ nein ] [ er ] [ ist ] [ bist ] [ sehr ] [ nett ] [ nicht ]
[ ich ] [ weiß ] [ es ] [ tanzt ] [ gern ] [ hat ] [ Platten ] [ viele ]
```

| Intent | Keywords | Value | Helga | Flag |
|---|---|---|---|---|
| Not nice | nett + nicht | +1 | Ha! Ich wusste es! Komm allein. | |
| Doesn't know | weiß + nicht | −2 | Du weißt es nicht? Er ist dein Opa! | |
| Records | Platten | +1 | Viele Platten? MEINE Platten! … Bring ihn mit. Ich will sie zurück. | `guntherNice` |
| Nice | nett, tanzt | +1 | Hm. Vielleicht ist er jetzt anders. Okay. Bring ihn mit. | `guntherNice` |

| Player builds | Score | Interest |
|---|---|---|
| Ja, er ist sehr nett. | 100 | +2 |
| Er hat viele Platten. | 100 | +2 |
| Er bist nett. | 80. Helga: Er *ist* nett? Hm. Okay. | +1 |
| Nein, er ist nicht nett. | 100 | +2 |
| Ich weiß es nicht. | 100 | −2 |

The branch rejoins at turn 8.

## Turn 8: At the door

> **Helga:** Letzte Frage. Samstag, an der Tür. Der Türsteher fragt: "Wer bist
> du?" Was sagst du?

```
[ ich ] [ ich ] [ bin ] [ bin ] [ heiße ] [ {Name} ] [ auf ] [ der ] [ die ]
[ Liste ] [ Gästeliste ] [ von ] [ Helga ] [ und ] [ hallo ]
```

| Intent | Keywords | Value | Helga |
|---|---|---|---|
| I am Helga | bin + Helga, without Liste | −2 | Du bist nicht Helga. ICH bin Helga. Es gibt nur eine Helga. |
| On the list | Liste or Gästeliste, with Helga | +1 | Perfekt. So macht man das. |
| Name only | {Name} | −1 | Und? Der Türsteher kennt dich nicht! Sag: Liste! |

| Player builds | Score | Interest |
|---|---|---|
| Hallo! Ich bin {Name}. Ich bin auf der Liste von Helga. | 100 | +2 |
| Ich heiße {Name}. Gästeliste Helga. | 100 | +2 |
| Ich bin auf die Liste von Helga. | 85. Helga: Auf *der* Liste. Genau. | +1 |
| Ich bin {Name}. | 100 | −1 |
| Ich bin Helga. | 100 | −2 |

---

## Endings

The ending is decided after turn 8, unless interest hit 0 earlier.

| Ending | Condition |
|---|---|
| 🎧 **Back to back** (secret) | `guntherNice` and interest ≥ 7 |
| ❤️ **On the list** (win) | Interest ≥ 7 |
| 😬 **Record carrier** | Interest 4 to 6 |
| 💔 **Deleted** | Interest below 4 at the end, or 0 at any moment |

The **average sentence score** is shown on every ending as "Dein Deutsch".
With an average of 90 or more, the contact card gets a badge:
"Helga sagt: spricht super Deutsch".

### ❤️ On the list: the like and the contact

> **Helga:** Okay, {Name}. Du bist auf der Liste. Samstag, 23 Uhr. Schwarze Tür.
> Komm nicht zu spät. 🖤

```
┌──────────────────────────────┐
│                              │
│     ❤️  Helga hat dich        │
│         geliked!             │
│                              │
│  Dein Deutsch: 94  ⭐         │
├──────────────────────────────┤
│  📇 Neuer Kontakt gespeichert │
│                              │
│  🎧 Helga                     │
│  DJ · 81 · Kellerbeben       │
│                              │
│  Helga weiß über dich:       │
│  💃 tanzt gern                │
│  🖤 trägt Schwarz             │
│  🚪 findet geheime Türen      │
│  ⭐ spricht super Deutsch     │
│                              │
│  [ Share ]  [ Next match ]   │
└──────────────────────────────┘
```

"Helga weiß über dich" is built from the flags, the outfit and the door.

**The contact stays alive.** On Sunday at 14:05 the contacts tab shows a new
voice note from Helga, a single-turn mini chat:
"Wo warst du um sechs Uhr? Mein bestes Set! Nächstes Mal, ja?"
This is the hook for later content: contacts text you again.

### 🎧 Back to back (secret)

> **Helga:** 🎤 Voice note: "Günther hat angerufen. Er bringt meine Platten
> zurück. Nach 27 Jahren! Samstag spielen wir zusammen. Wegen dir."

Same like and contact screen, plus:

```
│  ✨ Neues Match freigeschaltet │
│  🎛️ Opa Günther               │
│  "Ich war DJ, bevor Helga    │
│   DJ war."                   │
```

### 😬 Record carrier (partial)

> **Helga:** Na gut. Du bist auf der Liste. Aber du trägst meine Platten. Die
> ganze Nacht. Zwölf Kisten. 📦📦📦

No like and no contact. The chat is over, and Helga goes into
"Begegnungen" (people you met) with this last line.

### 💔 Deleted

The deleting line depends on what pushed interest to 0, or on the worst turn
for an end-of-chat deletion.

| Cause | Helga's last line |
|---|---|
| Yellow outfit | Gelb. In meinem Keller. Nein. Tschüss. 💛🗑️ |
| Lost "keine Fotos" | Fotos im Club? Du bist ein Tourist. Gelöscht. |
| "Ich bin Helga" | Es gibt nur eine Helga. Und das bin ich. Tschüss. |
| Too many "Hä?" | Ich verstehe dich nicht. Und du verstehst mich nicht. Tschüss. |
| Anything else | Hm. Du bist nett, aber nicht für meinen Keller. |

```
┌──────────────────────────────┐
│  💔  Helga hat das Match      │
│      gelöscht.               │
│                              │
│  "Gelb. In meinem Keller.    │
│   Nein. Tschüss."            │
│                              │
│  Dein Deutsch: 93            │
│                              │
│  What went wrong:            │
│  • You said black, then sent │
│    yellow                    │
│  • "Fotos" without "keine"   │
│                              │
│  [ Share ]  [ Next match ]   │
└──────────────────────────────┘
```

Good German and a bad chat can go together. The score and the ending are
separate on purpose.

---

## Three playthroughs

**Perfect path.**

| Turn | Player builds | Score | Interest |
|---|---|---|---|
| Start | | | 5 |
| 1 | Hallo! Ich heiße {Name}. | 100 | 7 |
| 2 | Ja, ich tanze sehr gern! | 100 | 9 |
| 3 | Um dreiundzwanzig Uhr. | 100 | 10 |
| 4 | Keine Fotos und nur schwarze Kleidung. | 100 | 10 |
| 5 | Ich trage alles schwarz. | 100 | 10 |
| 6 | Die Tür rechts. | 100 | 10 |
| 7 | Ich komme allein. | 100 | 10 |
| 8 | Ich bin auf der Liste von Helga. | 100 | 10 → ❤️, Deutsch 100 |

**Messy but saved.**

| Turn | Player builds | Score | Interest |
|---|---|---|---|
| Start | | | 5 |
| 1 | Ich heißt {Name}. | 80 | 6 |
| 2 | Nein, aber ich trinke gern. | 100 | 7 |
| 3 | Die Party beginnen um elf. | 80 | 8 |
| 4 | Kein Fotos. | 85 | 9 |
| 5 | Ich trage ein Lederhose. | 85 | 9 |
| 6 | Die Tür links. | 100 | 8 |
| 7 | Ich komme mit fünf Freunden. | 100 | 7 |
| 8 | Ich bin auf die Liste von Helga. | 85 | 8 → ❤️, Deutsch 89 |

**Deleted at turn 5, with good German.**

| Turn | Player builds | Score | Interest |
|---|---|---|---|
| Start | | | 5 |
| 1 | Hallo! | 100 | 4 |
| 2 | Ich trinke gern. | 100 | 5 |
| 3 | Um zwei. | 100 | 4 |
| 4 | Fotos und schwarze Kleidung. | 100 | 2 |
| 5 | Ich trage Gelb. | 100 | 0 → 💔, Deutsch 100 |

## Recap screen (all endings)

- Every sentence with its score badge, and what was taken off.
- Every correction, for example `ich heißt → ich heiße`. These go to the fix
  log, so the mistake trainer can drill them.
- Both voice note transcripts, now unlocked.
- New words from the chat, with a tap to add them to the Word Library.

## Assets to make

| Asset | Count | Source |
|---|---|---|
| Helga profile picture | 1 | Image pipeline, picture-book style |
| Flyer photo | 1 | Image pipeline, text drawn as an overlay |
| Outfit photos | 4 | Image pipeline: black, yellow, bee stripes, traditional costume |
| Back yard with three doors | 1 | Image pipeline, flat front view |
| Günther contact picture | 1 | Shared with his own match later |
| Helga's text lines read aloud | about 45 | Recorded TTS, same as all audio |
| Voice notes with background | 3 | Recorded TTS mixed with a techno loop, a record scratch, room tone |

## Near-answers (added after the first playtest)

A playtester answered "Ich komme mit Freunden." and got "Das war nicht meine
Frage", because only "fünf Freunden" was covered. Every turn now has an intent
for the obvious near-answers, so the off-topic reply is only for real
off-topic sentences.

| Turn | Player builds | Intent | Value | Helga |
|---|---|---|---|---|
| 1 | Ich komme aus Berlin. | origin | 0 | Berlin! Schön. Und wie heißt du? |
| 1 | Ich tanze gern. | dance | 0 | Du tanzt gern? Super! Aber wie heißt du? |
| 3 | Am Samstag. | day | 0 | Ja, am Samstag! Aber um wie viel Uhr? |
| 3 | Am Sonntag. | sunday | −1 | Am Sonntag ist die Party zu Ende! Lies noch mal. |
| 4 | Keine Handys. | phones | +1 | Keine Handys, keine Fotos. Gleiche Sache. Gut! |
| 4 | Handys. | phonesLost | −2 | Handys?! NEIN! Keine Fotos, keine Handys! |
| 4 | Tanzen. | dance | 0 | Tanzen ist keine Regel. Tanzen ist Pflicht! |
| 5 | Ich trage eine Hose. | noColour | 0 | Und welche Farbe? Schwarz, hoffe ich! |
| 7 | Ich komme mit Freunden. | friends | 0 | Mit Freunden? Okay, aber nur einer! Mein Keller ist klein. |
| 7 | Ich komme nicht allein. | notAlone | 0 | Nicht allein? Okay, aber nur eine Person! |
| 7 | Ich komme mit meinem Opa. | opa | 0 | Mit deinem Opa? Süß! Opas tanzen gut. |
| 7b | Ja. / Nein. | nice / no | +1 | (same replies as "nett" / "nicht nett") |
| 8 | Ich bin auf der Liste. | list | +1 | Perfekt. So macht man das. ("Helga" no longer required) |

**Authoring rule:** for every question, list the answers a learner would
naturally give from the bank, and give each one an intent, even a neutral
one. The off-topic reply is a last resort.
