# German first: review list for the correction pass

The German explanations of B1.1 to C2.2 were written by agents following
`docs/german_first_guide.md`. This list is for whoever corrects them.

**Where to correct:** the source of the German is `tool/german-first/de/<level>/{app,book}/<id>.json`.
After editing, run `node tool/german-first/apply.mjs <level>`, then
`node tool/apply-authoring.mjs de_cert_a1 <level>`. The English originals are in
`tool/german-first/en/<level>/`.

**What to check first:** correct German above all, since learners copy it. Then whether
the difficulty fits the level, whether the jokes survived, and whether exercises still
work with their answers.

## Doubts raised while writing

### Existing German (kept as it was)

- B1.1 app, `relativ` says genitive relatives come in the next quiz, `relativ_praep` says later.
- B1.1 app, `wortschatz` check: "Angestellte, wie eine alte" is an odd comparison without an article.
- B2.1 book: `Du bist stumm` for "on mute"; normally `stummgeschaltet`.
- B2.1 app, `gesellschaft`: "die Regierung bildet / stürzt".
- B2.1 app, `konj1_vergangenheit`: „Ich habe / hatte / schickte den Brief“ has no participle.
- B2.2 book, `miete`: heading "Sich einräumen, dann drängen" looks wrong.
- B2.2 book, `fleisch`: `*Vielflieger*in*` had broken markup and was reworded.
- B2.2 app, `passiversatz`: „Hier kann man nicht parken“ = „darf nicht geparkt werden“ mixes kann and darf.
- B2.2 app, `nominalisierung`: „Ge-…-e“, but das Geschrei has no -e.
- B2.2 app, `fvg`: in Betracht ziehen = erwägen in the table, berücksichtigen in the visual.
- C1.1 book, `konzern`: check `Wasserwagen` against the scan; the intro now says `Wasserwaagen`.
- C1.1 book: source counts kept: "vier" Konjunktionen over 5 rows (`boerse`), "Vier mit Haken" over 3 rows (`zollverein`).
- C1.1 book, `konzern`: "elf Silben für *nutzen*" looks doubtful.
- C1.1 app, `tempuswahl` table, Futur II row: "Bis dahin werden wir fertig sein" is Futur I.
- C1.2 book, `boulevard` grammar[1].check: options "ist sei", "hat habe", "gibt gebe", "ermittelt ermittle" look wrong.
- C1.2 book, `festrede`: "mal ein" looks wrong.
- C1.2 app, `wortbildung_vor` mistakes[2]: "Die Zeit ist verlaufen"; better `verstrichen`.
- C1.2 app, `praefixe`: "úbergehen" has an accent on u; probably marks stress, confirm it is meant.
- C2.1 book, `kreisliga`: has both "bei weitem" and "bei Weitem".
- C2.1 app, `kollokationen` tips[2].trap: „ein großer Verlust erleiden“ should be „einen großen Verlust erleiden“.
- C2.1 app, `valenz` intro: lists nennen + Nominativ, but nennen takes Akk + Akk.
- C2.2 book, `rezension`: Ringelnatz line "Denn auf den letzten Teil"; the original may have "Dann". Unverified.

### Wording decisions to confirm

- Book instructions use the imperative `Kreise … ein`.
- B1.1 app: `er – es – es` became `er, es, es`; dashes removed from German question-and-answer prose. Dashes in quoted German forms (`gehen – ging – gegangen`) were kept.
- B1.1 app, `futur` tips[3]: check options rewritten, now using "Bald ist mein Bruder Lehrer."
- B1.1 app, `email_redemittel` and `schreiben_email`: "register marks" became wording about tone, with no marks.
- B1.1 book, `kirmes`: flow answers are `Zukunft`, `wird gemacht`, `etwas werden`; cues became (Plan), (Versprechen), (Vermutung).
- B1.1 book, `koenig`: English sentence glosses became German. Cues now read like `(jetzt)`.
- B1.1 book: stale cross-references were changed: "Topic 8" to `nächstes Kapitel`, "topics 2–4" to `die du schon kennst`.
- B1.2 book, `hochwasser`: cues (because of/despite/during) became (weil/obwohl/Zeit).
- B1.2 book, `abschied`: the level name B1 stays in a fact about citizenship.
- `Verbindungswort` is used for a conjunction in B1.1, B1.2 and B2.1. Later levels were told to use `Konjunktion` and explain it once.
- B2.1 book: "little word" became `Präposition`; indicative became `normale Form`.
- B2.1 book, `club` practise[0]: instruction says `sonst einen Strich`; the answer stays `–`.
- B2.1 book, `finanzamt`: `verrät der, die oder das`; the heading keeps `Genus`.
- Word lists keep English meanings at every level, including C1 and C2.
- B2.1 app, `konj1_vergangenheit` intro: reworded because "wir sind" is not a form clash.
- B2.1 app: terms `Zugeständnis`, `Zusammenfalten`, `Auffalten`.
- B2 app: an English `check.q` stays when its options are German, because it is the question.
- B2.2 book, `dorf`: "drei Wörter" became "vier" (*Das ist eben so*).
- B2.2 book: *The Gambler* became *Der Spieler*; "light verb" became `Funktionsverb`, explained once.
- B2.2 book: sentence-translation columns mostly stay English; `dorf`, `forschung` and `buchmesse` got German glosses instead.
- B2.2 app: suffix-meaning cells in `adjektivbildung` and `nominalisierung` are German; genitive-preposition meanings stay English.
- C1.1 book, `boerse` grammar[0].fact: the word "exams" was removed.
- C1.1 book: *Hund's rules* became *Hundschen Regeln*; "hammer and mallet" became "Schlägel und Eisen".
- C1.1 book: `zollverein` explanatory columns became German; `karlsruhe` meanings stay English.
- C1.1 app, `konnektoren_zweiteilig` trap: "*aber lässt…" failed the balance check, rewritten as „…“ ist falsch.
- C1.1 app, `partizipialattribute`: "*die teilgenommenen…, *der geschlafene…" uses a star for wrong forms; check it does not render as emphasis.
- C1.1 app, `konnektoren` intro: dropped "four", because it lists more.
- C1.2 book, `gender` reading.fact: *Student*innen* had an odd star count, now written "mit Sternchen".
- C1.2 book: kept English in `kabarett` idiom meanings and matching, the `literatur` gesture column and translate prompts.
- C1.2 book: exam and level mentions removed; `literatur`: "this site" became "unserer Website".
- C1.2 app: whole-sentence "means" cells became German; word glosses stayed English, including mixed `praefixe` table cells.
- C1.2 app, `modal_vermutung` check.q: a dash in quoted German became a colon.
- C1.2 app, `hoerensagen`: adds „Arzt geworden“; short German glosses added elsewhere.
- C2.1 book: `en:true` columns stay English, except jokes and leanings in `talkshow`, `digital`, `bauernhof`.
- C2.1 book, `werkstatt` intro: forms changed to *schreibst*, *verschreibst du dich*, against the keep-forms rule; confirm.
- C2.1 book: level names removed ("C2 German", "C2.2"); terms `Rektion`, `Fuge`, `Anlauf`; `talkshow` situation prompts now German. It runs at 101% of the English, 97–104% per chapter, so check fit.
- C2.1 app: two English-option checks were translated: `konnektoren` tips[1], `konnotation` tips[3].
- C2.1 app, `bigtext`: "die Spitze des Betriebsrats", because Ortmann's gender is unknown.
- C2.2 book: "weak verb" became "blasses Verb", since "schwach" is a grammar term; focus-word meanings and du-offer `.en` stay English; the Litotes "gemeint" column became German.
- C2.1 book, `gericht` document.fact: shortened by hand so it clears the footer; a sentence about Swiss official German was cut.
- C2.2 app, `antiquitaeten`: the English said clocks have "two different last parts", but both end in Uhr; reworded.
- C2.2 app, `fokus`: keeps English `even` once, because the cues are English.
- C2.2 app, `philosophie` intro: "der kategorische Imperativ", adjusted for the added article.
- C2.2 app, `eroerterung`: "examiner" became "aufmerksame Leser"; its English `check.q` still says "steelmanned".
- C2.2 book, `studie` document.intro and document.fact: shortened so the page clears its footer. The intro lost "Baujahr, Fenster, Keller" and now says "nur handschriftlich" instead of "nur ein handschriftlicher Vermerk"; the fact box keeps "Krieg und Vertreibung". Sensitive topic: read it closely.
- C2.2 book, `knoellchen` p. 54: `der Abschleppwagen` now breaks across two lines with no hyphen, because the column is narrow.
- Book opening pages from B1 say the app has an English button at every rule. Covers and back covers stay in English on purpose: they are the sales text.
- About 3,600 rarer words in the German explanations have no tap-for-meaning entry yet (each level is 90–95% covered).

## Correction pass (Fable, 2026-11-07)

Every German overlay in `tool/german-first/de/` was read in full (app and book, B1.1 to C2.2); 66 strings were changed, then `apply.mjs`, `apply-authoring.mjs` and the eight book reprints were rerun. Items from the list above that are now resolved:

- B1.1 app `wortschatz` check: "Angestellte, mit -e wie bei nette (Frau)".
- B2.1 app `gesellschaft`: "eine Regierung bilden / stürzen"; `konj1_vergangenheit`: „Ich habe geschickt“ / „Ich schickte“ / „Ich hatte geschickt“.
- B2.1 book `homeoffice`: "stummgeschaltet". B2.2 book `spielbank`: "erklärt jedem, der stehen bleibt, sein System".
- B2.2 app `konzessiv` and B2.2 book `buchmesse`: the so … auch pattern now reads so + Adjektiv, Subjekt, auch, Verb.
- C1.1 app `tempuswahl` table: the Futur II example is now "Bis dahin werden wir es erledigt haben"; `partizipialattribute` trap no longer uses stars for wrong forms; `nominalisierung` "arm an Verben" (was the coined "verbarm").
- C1.1 book `konzern`: "sechs Silben für nutzen"; the intro notes the old spelling Wasserwagen in the scan. `presse`: "den Druckfehlerteufel". `boerse` intro reworded.
- C1.2 book `boulevard` check: the doubled distractors (ist sei …) became ist, hat, gibt, ermittelt; `festrede` check: "mal ein" became "wieder". `trauer`: "mit dem sorgfältigsten Deutsch".
- C1.2 app `wortbildung_vor`: verlaufen = ablaufen (Die Sitzung verlief gut), mistake 3 corrected to "Die Zeit ist verstrichen"; `praefixe`: "úbergehen" fixed.
- C2.1 app `kollokationen`: „einen großen Verlust erleiden“; `valenz`: Prädikative are sein, bleiben, werden, heißen (nennen removed).
- C2.2 Ringelnatz: "Dann auf den letzten Teil der Reise" (was "Denn") in the app passage, the quiz item, the book, the companion and their sources.
- Smaller: stray " ." before a closing ellipsis in several C-level texts; "Du suchst der Kran" in the B2.1 Baustelle intro; "das richtige Ding" in B1.1 Suchbild intros; "als ob … ist" for two "als legt er / als ist dir" clauses in B1.1 book facts.

Left as they were (judged acceptable): "bei weitem" and "bei Weitem" both valid; "Vier Konjunktionen" over five rows in C1.1 `boerse`; the cow sentence in C2.1 `bauernhof` (the source joke); level names in B1.2 `abschied`.

