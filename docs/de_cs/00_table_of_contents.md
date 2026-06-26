# Tschechisch entdecken (`de_cs`) — Table of Contents

A **deep introductory taster** for a native **German speaker who teaches French**,
learning Czech. 🇩🇪 → 🇨🇿 · `uiLang: UiLang.de` · `learnLocale: 'cs-CZ'`.

**3 modules · 23 quizzes · ~110 min.** Short by design, deep by obligation. The
signature is a **trilingual contrastive spine (Czech ↔ German ↔ French)**; the
final module ends on a deliberate hook into the full course.

## Conventions

- **Type** = `QuizContent.kind`: `fillBlank` (knowledge, German prompt → Czech
  answer), `speakRepeat` (Czech read aloud, German shown — listen & repeat),
  `reading` (Czech passage, German behind info, MC questions).
- **Gate**: *streak* (fillBlank) · *play-through* (speakRepeat, never needs a mic)
  · *score* ≥ ⅔ (reading).
- **Interleave**: never two `fillBlank` back-to-back without a `speakRepeat`/
  `reading` between them.
- **Spine**: `Tn` references the trilingual point (see `de_cs_intro_plan.md` /
  `GENERATION_PROMPT.md`). **⚑** = dedicated contrastive quiz. Every quiz also
  carries `helpMemoryIntro` + ≥1 tip; the meaty ones carry **both** a
  `⚠️ Für Deutschsprachige` and a `🇫🇷 Brücke aus dem Französischen` tip.
- **Cast**: **Klára** (German Romanistik student newly in Prague) and **Tomáš**
  (a local) recur in the passages.
- **Sprechen als 🇨🇿–🇩🇪–🇫🇷-Triade**: in every `speakRepeat` item the German
  `prompt` line (shown under the spoken Czech) ends with a short bracketed
  **micro-tip** that embeds the **actual French parallel phrase** — real French
  text (*Je m'appelle…*, *Au revoir*, *J'ai lu*), not a paraphrase — plus a
  pronunciation cue, false friend, etymology, or aspect note. So the learner
  repeats the Czech while *seeing* the German meaning **and** the French anchor she
  already owns. Each module has one extra speak quiz built entirely around this
  (full item lists in [§ Sprechen als Triade](#sprechen-als-triade--volle-item-listen)).

## Totals at a glance

| Metric | Count |
|--------|------|
| Modules | 3 |
| Quizzes | **23** — `fillBlank` 10 · `speakRepeat` 9 · `reading` 4 |
| Reading passages | 4 (3–6 questions each) |
| Audio (speakRepeat) sets | 9 (6–8 spoken lines each) — incl. 3 "Tipp"-Sets |
| Dedicated contrastive quizzes (⚑) | 7 |
| Est. first-completion time | ~110 min |

---

## Modul 1 — `de_cs_m1` · ERSTE KLÄNGE

*The Czech sound system as the seduction, plus survival courtesy.*

**Kann-Beschreibung (CEFR A1):** recognise and produce the Czech sounds, greet
formally/informally, say yes/no/please/thank you/sorry, ask and answer “how are
you”, grasp the `tykání`/`vykání` (T/V) register split.
**Fokus:** phonology — háček consonants, phonemic vowel length, fixed
first-syllable stress, `ř`, syllabic `l`/`r`; first contact with `být` + pro-drop.
**Wortschatz:** pozdravy, zdvořilost, otázka „Jak se máš?“.

| # | Quiz | id | Type | Gate | Spine | Tip flavours |
|---|------|----|------|------|-------|--------------|
| 1 | Pozdravy a zdvořilost | `de_cs_m1_pozdravy` | fillBlank | streak | T1 | ⚠️ |
| 2 | Hlásky a háčky (das Lautsystem) | `de_cs_m1_hlasky` | speakRepeat | play-through | **⚑ T10**, T9 | ⚠️ 🇫🇷 |
| 3 | Délka a přízvuk | `de_cs_m1_delka_prizvuk` | fillBlank | streak | **⚑ T8**, T9 | ⚠️ 🇫🇷 |
| 4 | Der ř-Laut & Zungenbrecher | `de_cs_m1_r_hacek` | speakRepeat | play-through | **⚑ T11**, T12 | ⚠️ 🇫🇷 |
| 5 | Jak se máš? (tykání/vykání) | `de_cs_m1_jak_se_mas` | fillBlank | streak | T7 | ⚠️ 🇫🇷 |
| 6 | Lesen: *Ahoj, jsem Klára* | `de_cs_m1_cteni_ahoj` | reading | score | T7, T1 | ⚠️ |
| 7 | 🗣️ Sprechen: Klang & Bedeutung (Triade) | `de_cs_m1_zvuky_slov` | speakRepeat | play-through | T10, T8 | 🇩🇪 🇫🇷 |

**Detail-Anker (was jede Hilfe liefern soll):**
- **#1** `Dobrý den` / `Ahoj` / `Na shledanou` / `Prosím` / `Děkuji` (`Díky`) /
  `Ano` / `Ne` / `Promiňte`. ⚠️ kein Artikel und kein „es gibt“-Subjekt — `Dobrý
  den`, nicht *„einen guten Tag“* (T1).
- **#2** Háček-Konsonanten als Tabelle: **`ž` = das französische `j` in *jour*
  [ʒ]** (🇫🇷-Anker), `š` = dt. *sch*, `č` = dt. *tsch*, `ň` ≈ frz./ital. *gn*.
  Vokallänge `a/á, e/é, i/í, o/ó, u/ú/ů` — wie *Staat/Stadt* (dt. Brücke), anders
  als im Frz. (T9, T10).
- **#3** Minimalpaare zur Länge: `byt` (Wohnung) / `být` (sein); `dráha` (Bahn) /
  `drahá` (teuer, f.). **Fester Erstsilben-Akzent** — wie die dt. Tendenz, das
  *Gegenteil* des frz. Endsilben-Akzents; Akzent ≠ Länge (T8).
- **#4** `řeka`, `tři`, `dobře`, `Dvořák`; silbenbildendes `l`/`r`:
  *Strč prst skrz krk*. Mechanik des `ř` erklären (gehobener alveolarer Vibrant
  mit Reibung) — den lernen selbst tschechische Kinder zuletzt (T11, T12).
- **#5** `Jak se máš?` (du) vs `Jak se máte?` (Sie); `Mám se dobře, díky. A ty?`
  🇫🇷 die T/V-Unterscheidung kennt sie doppelt: `tu/vous` **und** `du/Sie` — Tschechisch
  macht sie genauso (T7).
- **#6** 3–4 Sätze: *„Ahoj! Jsem Klára. Jsem z Německa. Učím se česky.“* — Pro-Drop
  sichtbar machen (`jsem`, kein `já`). Fragen auf Tschechisch mit dt. Glossen.
- **#7** 🗣️ Triade-Sprechen (volle Liste unten): die Höflichkeits- und Klangwörter
  laut sprechen, jede dt. Zeile mit frz. Paralleltext + Klang-Tipp
  (`Na shledanou` ≈ *Au revoir*, `ě`/`ň`-Erweichung).

---

## Modul 2 — `de_cs_m2` · ICH, DU UND DIE ANDEREN

*People, identity, and the first real grammar — including the no-article
revelation and a gentle first look at the case idea.*

**Kann-Beschreibung:** introduce yourself (name, origin, profession, languages),
address people by name, identify a noun’s gender, count 1–10.
**Fokus:** personal pronouns + pro-drop; full present of `být` (+ negation);
**nouns without articles**; three genders **+ animacy**; the **Vocative**;
numbers 1–10 with the **genitive-of-counting** teaser; the *concept* of case via
the German bridge.
**Wortschatz:** národnosti a jazyky, povolání, lidé, čísla 1–10.

| # | Quiz | id | Type | Gate | Spine | Tip flavours |
|---|------|----|------|------|-------|--------------|
| 1 | Osobní zájmena | `de_cs_m2_zajmena` | fillBlank | streak | **⚑ T7** | ⚠️ 🇫🇷 |
| 2 | Sprechen: Jmenuji se… | `de_cs_m2_predstaveni` | speakRepeat | play-through | T7 | 🇫🇷 |
| 3 | Sloveso «být» + zápor | `de_cs_m2_byt` | fillBlank | streak | T7 | ⚠️ |
| 4 | 🗣️ Sprechen: Menschen & Wörter mit Geschichte (Triade) | `de_cs_m2_lide_vztahy` | speakRepeat | play-through | T17, T20 | 🇩🇪 🇫🇷 |
| 5 | Lesen: *Klára v Praze* | `de_cs_m2_cteni_klara` | reading | score | T1 | ⚠️ |
| 6 | Bez členů: rod a životnost | `de_cs_m2_rod_zivotnost` | fillBlank | streak | **⚑ T1**, **⚑ T19** | ⚠️ 🇫🇷 |
| 7 | Sprechen: Oslovení (5. pád) | `de_cs_m2_osloveni` | speakRepeat | play-through | **⚑ T13** | ⚠️ 🇫🇷 |
| 8 | Čísla 1–10 a počítání | `de_cs_m2_cisla` | fillBlank | streak | **⚑ T18** | ⚠️ |

**Detail-Anker:**
- **#1** `já, ty, on/ona/ono, my, vy, oni`; im Plural die 3. Person `oni`
  (m. belebt) / `ony` / `ona` andeuten. ⚠️🇫🇷 Pro-Drop: das Subjektpronomen
  entfällt meist (`Jsem učitelka`), anders als im Dt. **und** Frz. (T7).
- **#2** `Jak se jmenuješ? – Jmenuji se…`, `Jsem z Německa.`, `Jsem učitelka /
  učitel.`, `Mluvím německy, francouzsky a trochu česky.` 🇫🇷 `jmenuji se` ≈
  *je m’appelle* (reflexiv) — Brücke zum frz. `se`.
- **#3** `jsem, jsi, je, jsme, jste, jsou`; Zápor: `nejsem … není … nejsou`
  (⚠️ `není`, nicht *„nejje“* — unregelmäßige Verneinung).
- **#4** 🗣️ Triade-Sprechen (volle Liste unten): Menschen/Beziehungen, jede dt.
  Zeile mit frz. Paralleltext + Tipp (`kamarád` ← *camarade*, `-ová`, Vokativ).
- **#5** Klára stellt sich voll vor (Herkunft, Studium, Sprachen). Czech zuerst,
  dt. Übersetzung hinter dem Info-Button; 4 Fragen, Czech mit dt. Glossen.
- **#6** **Keine Artikel** — `káva`, nicht *„ein/​der Kaffee“*; trotzdem drei
  Genera + **Belebtheit** (`pán`/`student` belebt vs `hrad`/`stůl` unbelebt).
  ⚠️ weniger Genera als gefühlt, aber neue Zuordnung; 🇫🇷 das frz. Genus-System
  hat nur zwei und *Artikel* tragen es — hier trägt es die Endung (T1, T19).
- **#7** **Vokativ**: `Petr → Petře!`, `Pavel → Pavle!`, `Tomáš → Tomáši!`,
  `Klára → Kláro!`, `paní Nováková → paní Nováková`. ⚠️ das Dt. hat keinen
  morphologischen Vokativ; 🇫🇷 das Frz. hat ihn verloren — aber das **Latein**
  hatte ihn (philologischer Genuss) (T13).
- **#8** `jedna/jeden/jedno, dva/dvě, tři, čtyři, pět … deset`; **Zähl-Genitiv**:
  `pět korun`, `pět studentů`, Paukal `dva studenti / dvě koruny`. ⚠️ Zahlen
  *regieren* den Kasus — das kennen weder Dt. noch Frz. (T18).

---

## Modul 3 — `de_cs_m3` · TUN & SEIN: ERSTER BLICK AUF DEN ASPEKT

*A real first taste of the Czech verb — built on the French passé composé /
imparfait bridge — plus the instrumental, reflexives, and the closing hook.*

**Kann-Beschreibung:** say what you do, distinguish a habitual/ongoing action from
a completed one (aspect, in essence), say “by car / with a friend”, use basic
reflexive verbs, and see the road ahead.
**Fokus:** present of a regular `-at` verb; **verbal aspect (perfective vs
imperfective)** via the French bridge; the **Instrumental**; reflexive `se/si`
and 2nd-position clitics; a deliberate preview of the full case + aspect systems.
**Wortschatz:** každodenní činnosti, doprava, volný čas.

| # | Quiz | id | Type | Gate | Spine | Tip flavours |
|---|------|----|------|------|-------|--------------|
| 1 | Pravidelné sloveso «dělat» | `de_cs_m3_sloveso` | fillBlank | streak | T7 | ⚠️ |
| 2 | Sprechen: Co děláš každý den? | `de_cs_m3_kazdy_den` | speakRepeat | play-through | T3 | 🇫🇷 |
| 3 | Vid: dokonavý / nedokonavý | `de_cs_m3_aspekt` | fillBlank | streak | **⚑ T3**, **⚑ T4**, T5 | ⚠️ 🇫🇷 |
| 4 | 🗣️ Sprechen: Vid v akci (Triade) | `de_cs_m3_aspekt_mluvit` | speakRepeat | play-through | **⚑ T3**, T5 | 🇩🇪 🇫🇷 |
| 5 | Lesen: *Klářin den v Praze* | `de_cs_m3_cteni_den` | reading | score | T3, T5 | 🇫🇷 |
| 6 | Instrumentál: autem, s kamarádem | `de_cs_m3_instrumental` | fillBlank | streak | **⚑ T14** | ⚠️ 🇫🇷 |
| 7 | Sprechen: Reflexiva se/si | `de_cs_m3_se_si` | speakRepeat | play-through | **⚑ T16**, T17 | ⚠️ 🇫🇷 |
| 8 | Lesen: *Co bude dál?* (Ausblick) | `de_cs_m3_co_dal` | reading | score | T2, T3 | ⚠️ 🇫🇷 |

**Detail-Anker:**
- **#1** `dělám, děláš, dělá, děláme, děláte, dělají` — die `-at`-Klasse; Pro-Drop
  bleibt sichtbar.
- **#2** Alltagssätze: `Ráno piju kávu.`, `Každý den se učím česky.` 🇫🇷 das
  Gewohnheitsmäßige ≈ das frz. *imparfait*-Gefühl, hier im Präsens vorbereitet (T3).
- **#3** **Das Kronjuwel.** Aspektpaare `dělat/udělat`, `psát/napsat`,
  `kupovat/koupit`. 🇫🇷 imperfektiv = Verlauf/Gewohnheit ≈ *imparfait*; perfektiv
  = abgeschlossen/begrenzt ≈ *passé composé*. ⚠️ das Dt. hat **kein**
  grammatisches Aspekt-System; **`udělám` (perfektives Präsens) = Zukunft** (T5) —
  der Aspekt steckt im **Stamm**, nicht in der Zeit (T3, T4, T5).
- **#4** 🗣️ Triade-Sprechen (volle Liste unten): Aspekt im Satz — jede dt. Zeile
  zeigt den frz. Paralleltext (*je lisais* vs *j'ai lu*), damit perfektiv/
  imperfektiv über das Frz. *gefühlt* statt nur gelernt wird (T3, T5).
- **#5** Kláras Tag — Erzähltext, der Gewohntes (nedokonavý) und Abgeschlossenes
  (dokonavý) mischt, damit der Aspekt *fühlbar* wird. 🇫🇷 wie der Wechsel
  *imparfait* ↔ *passé composé* in einer frz. Erzählung.
- **#6** `autem` (mit dem Auto — **bloßer Instrumental, keine Präposition!**),
  `vlakem`, `s kamarádem` / `s kamarádkou`, `jíst lžící`. ⚠️ dt. `mit` + Dativ;
  🇫🇷 `en voiture` / `avec` — Tschechisch macht es mit einer Endung (T14).
- **#7** `jmenuji se`, `učím se česky`, `dám si kávu`. **Klitika in zweiter
  Position** (`se/si/mi` im Wackernagel-Slot). ⚠️ Reflexiv wie dt. `sich`
  (Akk/Dat-Split — Brücke!); 🇫🇷 **wie `je le lui donne`** kennt sie die
  Klitik-Reihenfolge schon (T16, T17).
- **#8** **Der Haken.** Eine kurze, warme Notiz „von Klára“, die weiterlockt; die
  Help Memory zeigt erstmals die **volle 7-Kasus-Tabelle** eines Substantivs
  (z. B. `student` oder `Praha`) und eine Liste echter Aspektpaare als Vorschau —
  „das alles wartet im Aufbaukurs“. 🇫🇷⚠️ Brücke: ihre vier dt. Fälle + ihr frz.
  Aspektgefühl sind schon das halbe Fundament (T2, T3).

---

## Sprechen als Triade — volle Item-Listen

The three extra speak quizzes, fully authored. Each item is a
`CourseItem(prompt: <German + 🇫🇷 + Tipp>, answer: <Czech, gesprochen>)`: the app
**speaks the Czech** (`answer`) in the Czech neural voice; the learner sees the
**German meaning, the real French parallel, and a micro-tip** (`prompt`) and
repeats. Keep the bracket tight — one fact per line.

### M1 · `de_cs_m1_zvuky_slov` — „Klang & Bedeutung“
*Intro: „Sag die wichtigsten Wörter laut — und nimm bei jedem einen Klang- oder
Sprachtipp mit. Was du schon auf Französisch fühlst, hilft dir hier.“*

| Gesprochen 🇨🇿 (`answer`) | Angezeigt 🇩🇪 + 🇫🇷 + Tipp (`prompt`) |
|---------------------------|----------------------------------------|
| `Dobrý den.` | Guten Tag (🇫🇷 *Bonjour* — wörtl. „guter Tag“; Akzent immer auf **DOB**-rý, nie auf der Endung; kein Artikel). |
| `Děkuji.` | Danke (🇫🇷 *Merci* — `ě` erweicht das `d`: „**ďe**-ku-ji“, mouilliert wie *gn*). |
| `Prosím.` | Bitte / gern geschehen (🇫🇷 *S'il vous plaît* / *je vous en prie* — ein Wort, zwei Funktionen; langes `í`). |
| `Ano. / Ne.` | Ja. / Nein. (🇫🇷 *Oui / Non* — Achtung: kurzes „no“ heißt umgangssprachlich „ja“ — falscher Freund!). |
| `Na shledanou.` | Auf Wiedersehen (🇫🇷 *Au revoir* — beide wörtl. „auf das Wiedersehen“; `shl` ohne Vokal sprechbar). |
| `Promiňte.` | Entschuldigung (🇫🇷 *Pardon / excusez-moi* — `ň` = das frz. *gn* in *Espagne*; Sie-Form auf `-te`). |
| `Těší mě.` | Freut mich (🇫🇷 *Enchanté(e)* — `ě` erweicht `t` → „**ťe**-ší“; `mě` klingt „mňe“). |

### M2 · `de_cs_m2_lide_vztahy` — „Menschen & Wörter mit Geschichte“
*Intro: „Über Menschen sprechen — und nebenbei sehen, wie viele tschechische
Wörter aus dem Französischen oder Deutschen kommen.“*

| Gesprochen 🇨🇿 (`answer`) | Angezeigt 🇩🇪 + 🇫🇷 + Tipp (`prompt`) |
|---------------------------|----------------------------------------|
| `Jmenuji se Klára.` | Ich heiße Klára (🇫🇷 *Je m'appelle Klára* — reflexives `se` genau wie im Frz.!). |
| `Mluvím francouzsky.` | Ich spreche Französisch (🇫🇷 *Je parle français* — Sprache **klein** `francouzsky`, kein Artikel, anders als *le français*). |
| `To je můj kamarád.` | Das ist mein Freund (🇫🇷 *camarade* — `kamarád` ist dasselbe Lehnwort, das sie schon kennt). |
| `Tomáš je Čech.` | Tomáš ist Tscheche (🇫🇷 *Tchèque* — Nation **groß** `Čech`, Sprache **klein** `česky`). |
| `To je paní Nováková.` | Das ist Frau Nováková (🇫🇷 *Madame Nováková* — `-ová` = weibliche Nachnamen-Endung, sogar „Macronová“!). |
| `Petře, pojď sem!` | Petr, komm her! (🇫🇷 *Pierre, viens !* — **Vokativ** `Petře!`, die Anrede-Endung, die das Frz. verlor). |
| `Kdo je to?` | Wer ist das? (🇫🇷 *Qui est-ce ?* — Frage ohne Hilfsverb; Wortstellung frei dank Kasus). |

### M3 · `de_cs_m3_aspekt_mluvit` — „Vid v akci / Aspekt im Satz“
*Intro: „Den Aspekt fühlst du über das Französische: imperfektiv ≈ imparfait,
perfektiv ≈ passé composé. Sprich die Paare laut und höre den Unterschied.“*

| Gesprochen 🇨🇿 (`answer`) | Angezeigt 🇩🇪 + 🇫🇷 + Tipp (`prompt`) |
|---------------------------|----------------------------------------|
| `Každý den čtu noviny.` | Jeden Tag lese ich Zeitung (🇫🇷 *Je lisais le journal* — imperfektiv `čtu` = Gewohnheit, das *imparfait*-Gefühl). |
| `Včera jsem přečetl knihu.` | Gestern habe ich das Buch ausgelesen (🇫🇷 *J'ai lu le livre* — perfektiv `přečetl`, Präfix `pře-` = „fertig“, das *passé composé*-Gefühl). |
| `Píšu dopis.` | Ich schreibe (gerade) einen Brief (🇫🇷 *Je suis en train d'écrire* — imperfektiv, Verlauf). |
| `Napíšu ti zítra.` | Ich schreibe dir morgen (🇫🇷 *Je t'écrirai* — perfektives **Präsens = Zukunft**! `na-` macht's vollendet). |
| `Vždycky kupuju chleba.` | Ich kaufe immer Brot (🇫🇷 *J'achète toujours* — imperfektiv `kupuju`, Gewohnheit). |
| `Dnes koupím víno.` | Heute kaufe ich Wein (🇫🇷 *J'achèterai* — perfektiv `koupím`, einmalig; anderes Verb im Paar, gleicher Sinn). |
| `Dám si kávu.` | Ich nehme einen Kaffee (🇫🇷 *Je prends un café* — `si` = Dativ-Reflexiv, „ich gebe mir“). |

> **Authoring note for `deCsSpeak`:** put the whole German+French+tip string in
> `CourseItem.prompt` and the bare Czech sentence in `answer` (only the `answer`
> is sent to TTS, so the French text is *shown, never mis-pronounced* by the Czech
> voice). Mirror this 🇨🇿–🇩🇪–🇫🇷 prompt pattern in the **other** speak quizzes too
> (`de_cs_m1_hlasky`, `_r_hacek`, `de_cs_m2_predstaveni`, `_osloveni`,
> `de_cs_m3_kazdy_den`, `_se_si`).

---

## Build order (when authoring)

1. Lock this TOC (ids, types, gates, interleave) — done above.
2. `de_cs_builder.dart` (mirror `de_es_builder.dart`, Czech-framed).
3. `de_cs_m1.dart` → `m2` → `m3`, then `de_cs_content.dart` (`deCsContent`).
4. Register (`quiz_content_library.dart`, `tool/generate_content.dart`,
   `course_catalog.dart` with `_deCsNav`, `assets/content/catalog.json` + version).
5. Add the `cs` voice to both `_voiceFor` switches in `cloud_tts_provider.dart`.
6. Bump `kDataVersion`; regenerate seed (`generate_content.dart`,
   `generate_seed.dart`).
7. `flutter analyze` clean · `flutter test` green.
