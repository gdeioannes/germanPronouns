# Ukrainian mode: doubts for a native speaker

AI-translated. File + key + the doubt, one line each.

## Interface (src/lib/i18n/uk.ts)

- uk.ts "“Grief bacon”: …" and the other ~70 German-word jokes (Kummerspeck, Warmduscher, Torschlusspanik, Innerer Schweinehund …): rendered as literal Ukrainian calques in «…»; some may sound clumsy (e.g. «Теплий душолюб», «Розжарена груша», «Внутрішній свинопес»).
- uk.ts "“Cloud scratcher”: a skyscraper.": Ukrainian «хмарочос» is the same image, so the gloss reads «Хмарочос»: хмарочос (і німецькою так само). Better wording?
- uk.ts "Germans say “Daumen drücken”, …": rewritten to compare with Ukrainian «тримати кулаки» instead of English crossed fingers.
- uk.ts "A mobile phone. It sounds English; no English speaker says it." / "A projector. In English, a BMW.": kept the English angle (Handy, Beamer); fine for Ukrainians who know English?
- uk.ts "Learn German Free — Swipe-Through Course, A1 to C2 | Language Quiz", "Learn German from English with {n} …", "A German course for English speakers …": changed "A1 to C2" to "A1 to A2" (as Arabic did), since Ukrainian covers A1–A2 only. Confirm.
- uk.ts "· German for English speakers" → «· німецька для україномовних»; "English" (language label) → «Українська»; "Hide English"/"Show English" → «Сховати/Показати переклад» (as Arabic).
- uk.ts "{tier} medal earned." and similar: {tier} is filled with «Золото/Срібло/Бронза», so some lines read «медаль Золото». Acceptable, or should tier names be adjectives?
- uk.ts count strings ("{n} new words.", "All {n} exercises", "{n} left"): written as «Нових слів: {n}.» etc. to avoid Ukrainian plural agreement with a number.
- uk.ts gender: all lines rewritten to avoid the learner's gender (impersonal/present forms). Two dictionary-style glosses keep «хотів би / хотіла б».

## A1.1 app

- quest_a1_1_farben sentences[0].why / [3].why / [7].why: cognate claims rot ~ «рудий», gelb ~ «жовтий» (and Gold ~ «золото»), braun → «брунатний» (borrowed). Please verify they are accurate enough for learners.
- quest_a1_1_zahlen2 help.intro / tips[0].visual.caption: compares German 13–19 (unit + zehn) with Ukrainian «-надцять» (unit first). Check wording.
- quest_a1_1_laender help.intro, tips[1].text, remember[0]; book/laender grammar[0].blocks[1].blocks[0].text; quest_a1_1_wortschatz help.tips[2].text: added die Ukraine / aus der Ukraine to the article-countries list (not in the English). Keep?
- quest_a1_1_sein_haben sentences[0].english, quest_a1_1_pronomen sentences[0].english and tips[0].examples[0].en: "Ich bin müde" rendered «Я дуже хочу спати / Я хочу спати» to avoid «втомився/втомилася». Meaning shifts slightly.
- quest_a1_1_sein_haben help.context.en: "Are you tired?" rendered «Хочеш спати?» for the same reason.
- quest_a1_1_hoeren_cafe help.tips[0].examples[1].en: "I am thirsty, and you are tired" → «Мене мучить спрага, а тебе втома» (gender-neutral, a bit literary).
- quest_a1_1_zahlen_gross sentences[12].english: "I was born in 1998" → «Я 1998 року народження» (gender-neutral).
- quest_a1_1_alphabet help.intro / tips[0] / mistakes[0]: the English "E and I are swapped" trap does not exist for Ukrainians; rewritten as "vowels sound like Ukrainian, just don't read Latin letters the English way". Check it still makes sense.
- quest_a1_1_praesens tips[2]: the English "one present = three English tenses" tip rewritten as "one word, like Ukrainian"; trap now warns against adding sein ('Ich bin lerne').
- quest_a1_1_wfragen help.tips[0].trap: English "do"-support trap replaced by a word-order trap («Wo du wohnst?»). Check it is a real Ukrainian-speaker error.
- quest_a1_1_wfragen help.tips[3].text: doch compared with «Та прийду!» as an answer to «Ти не прийдеш?». OK?
- quest_a1_1_wortbildung tips[2].text: linking -s- compared with Ukrainian connecting -о- («пароплав»).
- quest_a1_1_suchbild_wohnzimmer tips[0].text: added «схоже на українські слова на -а: лампа, ваза, гітара».
- quest_a1_1_artikel englishTemplates: «Тут: {subject}.», «Це {a} {subject}.», «Це не {a} {subject}.» (the app drops {a}).
- quest_a1_1_laender englishTemplates: «Моя країна: {subject}.», «Її країна: {subject}.» etc. (country name in the nominative).

## A1.1 book

- book/zahlen grammar[0].blocks[2].blocks[1].text and grammar[0].fact: "show three fingers the English way" rewritten as "three fingers without the thumb" / "index and middle finger".
- book/cafe grammar[1].fact: "Ich bin satt" glossed «я наївся / наїлася».
- book/amt grammar[1].fact: the Nazi-era spelling-alphabet history is kept as in the English.
- book/steckbrief reading.en: Mr Ziegler's English line "The cat is on the table." stays English on purpose (build flags it as "looks English").
- book/hallo, book/markt etc. reading.en: dialogue characters keep their own gender (Maya «вчителька», Tom «голодний»).

## Tooling

- tool/turkish/ui-merge.mjs: on an empty `export const UK = {` it writes `{,` (stray comma). Fixed by hand in uk.ts this time; the script should skip the comma when the object is empty.

## A1.2

- app/quest_a1_2_perfekt_intro, war_hatte, book/gestern grammar[1].blocks[0].rows[0].en + blocks[3].items: «я» sentences and participle glosses in the past use «(-ла)» (їв(-ла), купив(-ла)), because the past tense is the point of the lesson and a neutral rephrase would hide it. Elsewhere rephrased (e.g. «Учора мені нездоровилося» for Gestern war ich krank).
- app/quest_a1_2_uhrzeit + book/bahn grammar[0].blocks[1].blocks[0].text / reading.fact: halb zehn is explained as identical to Ukrainian «пів на десяту»; the English "English speakers miss trains" joke is kept as a side remark about English speakers. Check it reads naturally.
- book/einkaufen grammar[0].blocks[3]: "Amount + thing, no of" rewritten: Ukrainian uses the genitive (кілограм яблук), German keeps the noun as is (ein Kilo Äpfel). Column header «українською».
- book/unterwegs grammar[1].blocks[2].text: die Ukraine added to the in die countries (Schweiz, Türkei, USA), same as the app wohin tip. grammar[1].blocks[1].note adds «у школі / у школу» as the Wo?/Wohin? parallel.
- book/zimmer grammar[0].blocks[2].blocks[1].text: added a third trap: German has no «свій» (Max sucht seine Jacke = «його куртку»), while the Ukrainian example glosses use «свою/свій» naturally.
- book/kurs grammar[1].blocks[2]: the English trap (will = want, must not) rewritten as «Пастка: musst nicht» (тобі не треба vs тобі не можна) + one line on ich will = «я хочу».
- book/biergarten grammar[1].blocks[0].blocks[0].note: added that helfen/danken/gefallen take the dative as in Ukrainian (допомагати кому…). document.tasks[1].items[2] options were English (welcome/good night), now «ласкаво просимо» / «на добраніч».
- book/arzt reading.en: «Три Maß (по літру)»; Max says «я дуже втомлений» (character, male).
- book/tag reading.intro: Frau Huber "first floor" = German 1. Stock, translated as «на другому поверсі» (Ukrainian counting).
- book/rezept grammar[1].blocks[1].note: the infinitive-as-order compared to Ukrainian «Не курити!».

## A2.1

- app/quest_a2_1_modal_praeteritum englishTemplates: `{subject}` is я/ти/він/вона/воно/ми/ви/вони and a Ukrainian past verb would have to agree with it, so every template uses an impersonal pattern after a colon: «{subject}: учора прийти не вийшло», «{subject}: довелося рано вставати», «{subject}: не можна було дивитися телевізор». Grammatical for every subject, but stiff. Please judge.
- Perfekt / war-hatte / sprechen files (bigtext_wochenende passageTranslation, diktat_perfekt items, perfekt_haben, perfekt_sein, sprechen_wochenende phrases, sprechen_kurzcheck): first-person past sentences use «(-ла)» (я поїхав(-ла), я зустрівся (зустрілася)). This is a past-tense module, so there are many. «У мене був/була/було» is used for hatte wherever possible, because it is gender-neutral.
- One-off characters in listening/reading texts are written in Cyrillic (Аміра, Леон, Софія, Емма, Тіна, пані Губер, Петерсен); the recurring cast stays Latin (Maya, Max, Lena, Jonas, Kim), as in A1.
- Ukrainian parallels added: helfen/danken/gefallen/antworten take the dative as in Ukrainian, but gratulieren does not («вітати кого»); «до Берліна / до лікаря» explains nach vs zu errors; seit + present matches «живу тут уже три роки»; zu Hause / nach Hause = «вдома / додому»; Wo?/Wohin? = «у школі / у школу», and «в кіно» used as the example of an ambiguous Ukrainian form; double negation («ніхто не», «нічого не») vs single niemand/nichts; «більш цікавий» vs only interessanter; gut/viel irregular like «добрий – кращий», «багато – більше»; -e nouns feminine «roughly like Ukrainian -а nouns».
- book/kaufhaus grammar[0].fact: UK→German size comparison rewritten as «український 46 приблизно відповідає німецькому 40»; shoe sizes left vague. Please check the size claim.
- book/kindheit document.fact: the English "brag about their 5" joke rewritten for the Ukrainian 12-point scale («не хвались німцям своєю «п’ятіркою»»).
- app/quest_a2_1_wetter sentences whys: the English-cognate notes (Sommer ~ summer, Herbst ~ harvest, kalt ~ cold, -ig like English -y) were replaced with Ukrainian/German-internal notes (сонце → сонячний, die Kälte, «пора жнив»).
- app/quest_a2_1_woher_wo_wohin tips[2] and book/unterwegs (A1.2): die Ukraine added to the in die countries (aus der Ukraine – in der Ukraine – in die Ukraine).
- app/quest_a2_1_wortschatz cards[200].en: English "record" translated as «рекорд» (weather records), not «платівка» as the auto-glossary suggested; cards[293] / suchbild_bahnhof "camera" as «камера».
- app/quest_a2_1_temporal_2 hook: the English "'for' hides two German words" idea is dropped, because Ukrainian uses different words anyway («уже два роки» vs «на два тижні»).

## A2.2

- app/quest_a2_2_koennte_sollte englishTemplates: these are impersonal like A2.1 («{subject}: можна було б піти в кіно (пропозиція)», «{subject}: варто було б …»), so every subject works. Please judge whether they read naturally.
- Past-tense «я» sentences in praeteritum_intro, relativ_intro, dass, gesundheit, reflexiv, grammatikwoerter, adjektiv_intro and tekamolo use «(-ла)» / «(-лася)», as in A1.2/A2.1. Sentences addressed to the learner use «ти … чи …» or a neutral wording (imperativ and suchbild intros, dass s4, wenn_deshalb s12, weil s8/s9 «(Я щаслива…)»).
- Floor numbering: app/lesen_email («на четвертому поверсі (за нашим рахунком на п’ятому)»), book/umzug reading.intro (same) and book/krimi reading.intro («на першому поверсі (за нашим рахунком на другому)»).
- One-off characters in Cyrillic: Ян, Ліза, Нора, Тім, Марі, Олена, Кая (app); Анна, Том, пані Кайзер, пан Белл (only «пане Белл» in the letters; Max stays Latin), пані Керн, пан Фогт, пан Мозер, пан Йилмаз, пані Губер, Анке, Руді, пан Бергер, пан Аренс, Тоні, Софі, пані Лінднер (book). Please check «Йилмаз» (Turkish Yılmaz) and «Скофел-Пайк».
- app/quest_a2_2_wortbildung sentences[2] and book/tracht: German size 40 glossed as Ukrainian 46, as in A2.1 (same claim to check).
- Ukrainian parallels added: Wo?/Wohin? = «на столі / на стіл» (wechsel_wo/wohin, «в кіно / в кіні»); -los = «без-» (безробітний, безхмарний, безкоштовний), un- = «не-», -bar ≈ «-ний» (їстівний); relative der/den = «який/якого» (krimi, relativ_intro); weil/dass/indirect questions keep normal Ukrainian word order, while German sends the verb to the end; wenn vs als: Ukrainian «коли» covers both; one Ukrainian past tense vs Präteritum/Perfekt (maerchen); seit + present = «з учора маю температуру»; Mir ist schlecht = «мені погано»; steht dir = «тобі личить»; die Hose singular vs «штани»; sich ≈ -ся but sich freuen = «радіти» (verabredung, wortschatz); verb prepositions: «думати про» = denken an, «цікавитися» with no preposition = sich interessieren für (verben_praep_intro trap rewritten).
- app/quest_a2_2_wortschatz: auto-glossary fixes: cards[131] Erkältung «застуда» (not «холодна»), cards[330] Präsens (not «подарунок»), cards[75] Kaution «застава (за квартиру)», cards[211] «означальне речення». The German examples and notes were copied unchanged.
- book/weimar grammar[0].blocks[0].root.yes.answer: the English "keep it" (decision tree, not a quiz) is translated as «залиш його».
- book/rekorde document.tasks[1].items[2].prompt and grammar[1].blocks[1].head[2]: "In English" became «Українською».
- book/auto reading.en: Max's over-familiar letter to the city uses «Любе Місто! … Обіймаю, твій Max» against the office's «Шановний пане Белл … З повагою».

## B1.1 English button (2026-11-20)

Done: 41 files, 2068/2068, 0 errors. Source fixed from this run: adj_komparativ sentences[11] why (höchst-:
"the c shifts" → "with umlaut; the ch stays", German and French too). Left as written: elternzeit two vs three
months (most common vs average), hoeren_umfrage check why (explains its own check question), konjunktionen
context translated from the German.

## B1.2 English button (2026-11-20)

Done: 43 files, 2160/2160, 0 errors. Source fixed from this run: passiv_modal_intro context (German said the lift
itself was ordered → „Ersatz ist aber schon bestellt worden“, re-recorded), infinitiv example (um … zu glossed as
"in order to"), infinitiv tip 3 title (Verschieden? damit / dass). Visual rows with German in the English file:
translated or kept (praet_misch infinitives).

## B2.1 English button (2026-11-20)

Done: 45 files, 2504/2504, 0 errors. Source fixed from this run: verben_praep context „aufeinander“ (re-recorded),
mittelfeld „Sie hat ____.“ split into per-answer whys (es mir had the uns-gestern why), gesellschaft list
Wahl-Entscheidung → Entscheidung, sprechen_dialog abschließend = "in conclusion" (vocab + deck card). Left as is:
„parkende Autos“ (idiomatic), „Die Ministerin“ vs neutral "the minister", möchten in indirekt_fragen.

## B2.2 English button (2026-11-20)

Done: 46 files, 2468/2468, 0 errors. No German errors found. English-only gaps (translations are complete):
"A = B" examples where the English gives one side (genitiv_praep, konsekutiv_modal_nominal, partizip_attribut,
passiversatz_intro); nominalisierung_intro visual rows written in German.

## C1.1 English button (2026-11-20)

Done: 42 files, 2188/2188, 0 errors. Source errors found, NOT yet fixed (fix in German + English + fr/uk, then
rebuild the C1.1 deck, deck-counts, re-record):
- `quest_c1_1_tempuswahl` vocab[3] (and deck cards[75]): „historische Präsens“ → „das historische Präsens“.
- C1.1 deck builder splits: cards[238]/[239] from „einer Sache müde / überdrüssig sein“ (each half broken),
  cards[211] „als wenn + Konjunktiv II“ cut from „als ob / als wenn …“, cards[194] „zu, zwecks“ = "for that
  purpose" (belongs to dazu; adverbialsaetze vocab[3]), cards[169]/[170] duplicate „Gesandte“.
- `quest_c1_1_lesen_sprachbausteine` tips[3].en.text explains schliefen … wach geblieben waren, which is in
  neither example of that tip.

C1.1 fixed the same day: slash entries split in the source vocab (einer Sache müde sein / überdrüssig sein,
als ob / als wenn + Konjunktiv II, damit, um … zu / dazu), so the deck no longer cuts them; sprachbausteine tip 3
now explains the verbs of its own examples (lasen … kannten / lesen gelernt hatten). Recorded the 5 new texts.
Left: „historische Präsens“ with article das reads „das historische Präsens“ (correct); der/die Gesandte = two
cards by design, like Wahlberechtigte.

## C1.2 (button layer)

Done 2026-11-20: 42 files, 2214/2214, 0 errors. Source notes (not fixed):
- `quest_c1_2_wortschatz` cards[84] (from `quest_c1_2_modal_hoerensagen` vocab[2] „will … haben / sein“): the deck card's German is just „sein“ with "claims to have"; the slash entry is split by the deck builder. Rendered «стверджує, що зробив / був».
- `quest_c1_2_wortschatz` cards[224] (from `quest_c1_2_redemittel_vortrag` vocab[3] „stammen aus / von“): card German is just „von“ = "to come from"; same split. Also cards[203]/[204] „dies“ / „das“ and cards[46]–[48] from slash entries (harmless, but the „von“ and „sein“ cards are broken).
- `quest_c1_2_relativ_advanced` help.vocab[7] (and deck cards[52]): „weiterführende Nebensatz“ lacks its article/strong ending: „der weiterführende Nebensatz“ or „weiterführender Nebensatz“.
- `quest_c1_2_modal_vermutung` help.tips[3].examples[0]/[1] German contains English labels: „(ability)“, „(possibility)“, „(obligation)“, „(inference)“.
- `quest_c1_2_praefixe` help.tips[3].examples[0]/[1] German contains English: „(through the window)“, „(the plan)“, „(the post)“, „(the city)“.
- `quest_c1_2_wortbildung_vor` help.tips[3].examples[0]/[1] German contains English: „(not: geerreicht)“, „(separable: ge- in the middle)“.
- `quest_c1_2_hoeren_traeume` help.tips[0].en.text: "Always inseparable: wiederholen, unterhalten" contradicts `quest_c1_2_praefixe` (wíederholen = fetch back, únterhalten = hold underneath, both separable). Translated as written.
- `quest_c1_2_lesen_tatort` help.tips[1].examples[0]: „Die Reihe hat über 1.300 Folgen, aber keine Serie“ reads oddly ("has … but no series"); probably „ist aber keine Serie“. Ukrainian follows the meaning («але це не серіал»).
- `quest_c1_2_modal_vermutung` help.tips[1].examples[1]: „Jemand muss sie vergessen haben abzuschließen“ is awkward; more natural „Jemand muss vergessen haben, sie abzuschließen“.
- `quest_c1_2_konj2_kritik` help.tips[0].examples[0]: English "The customers ought to have been informed" is passive; the German „Man hätte die Kunden … informieren müssen“ is active with man (Ukrainian follows the German).
- `quest_c1_2_hoeren_uebersetzerin` help.hookEn: "She wrote a quarter of all novels" (a quarter of novels are translations, not hers). Translated as written.
- Minor English gaps, Ukrainian made from the German: `lesen_experten` tips[0].examples[1] and tips[2].examples[1] (English cut short), `hoeren_hoerspiel` tips[2].examples[0] (threshold missing), `modal_hoerensagen` tips[3].examples (English gives one side of „A = B“), `umformung_1` help.context.en (the „(= …)“ glosses dropped).

Ukrainian renderings to check:
- Idiom equivalents chosen in `quest_c1_2_redewendungen` (auf die lange Bank schieben = «відкладати в довгий ящик», ins Fettnäpfchen treten = «сісти в калюжу», die Flinte ins Korn werfen = «опустити руки», aus allen Wolken fallen = «остовпіти»); unter die Haut gehen = «пробирати до кісток» in `hoeren_traeume`.
- Konjunktiv I / soll / will rendered with «нібито», «мовляв», «стверджує, що» throughout; a short note on this was added to the intros of `konjunktiv1_indirekte_rede` and `modal_hoerensagen`.
- Names in translated example sentences are transliterated (Анна, Айх, Броєр, пан Браун), as in earlier levels; Anna Petrova in the e-mail signatures kept in Latin letters.

## C2.1 (button layer)

Done 2026-11-20: 38 files, 2094/2094, 0 errors, 0 flags. Source notes (not fixed):
- `quest_c2_1_konj1_lit` sentences[16].whyEn: "warteten … kämen — the Konjunktiv II fallbacks": warteten is identical to the Präteritum, which `quest_c2_1_lesen_artikel` (tips[0].en.text, rememberEn[1]) says marks nothing; würden … warten would be the clear fallback. Translated as written.
- `quest_c2_1_valenz` sentences[13].whyEn: "den Gefangenen (a weak noun)": der Gefangene is an adjectival noun, not a weak (n-declension) noun. Ukrainian says «субстантивований прикметник».
- `quest_c2_1_konnotation` sentences[0].whyEn: "sparsam (neutral)" contradicts the tips and intro, which give sparsam as the positive word (+). Translated as written.
- `quest_c2_1_suchbild_tischlerei` help.tips[2].en.text: "A device named … with -er is masculine: der Akkuschrauber, der Hobel, der Klüpfel": Hobel and Klüpfel end in -el, not -er (title says "Tools in -er are der").
- `quest_c2_1_komposita` help.tips[1].en.text: "No -s- after most feminine nouns not ending in those suffixes (Buchhandlung? no: Buch is neuter and takes none)" is muddled (Buch is the first part, not a feminine noun; Liebesbrief in the same tip has -s- after a feminine). Translated as written.
- Sentence counts in intros don't match the items: `abtoenung` "fifteen" (17 whys), `konnotation` "eighteen" (20), `stilmittel` "seventeen" (19), `konj2_nuancen` "17" (19), `konj1_lit` "fifteen" (17), `konnektoren_nuancen` "16" (18), `praefixe_semantik` "18" (20), `sprichwoerter` "sixteen" (18), `umformung_2` "seventeen" (19). Kept as written.
- `quest_c2_1_register` help.tips[3].examples[0]/[1] German contains English labels „(up)“, „(down)“.
- `quest_c2_1_wortschatz`: deck builder splits slash entries: cards[74]–[76] (widersprechen / ausweichen / begegnen + Dat: only begegnen keeps „+ Dat“), cards[77]–[79] (kosten / lehren / nennen + Akk + Akk: only nennen keeps the case note), cards[239] German is the fragment „Wo gehobelt wird“ (proverb cut at the comma), cards[292]–[297] German is an English label („über- inseparable“, „unter- separable“ …) instead of the verb. Ukrainian glosses follow the intended word.
- `quest_c2_1_wirtschaft` help.tips[0].en.trap (Vergleich / Berufung / Einspruch) sits in the economy tip, not the law tip, and ends with "not 'a speech'", which explains nothing; the Ukrainian drops that last bit.
- English shorter than the German, Ukrainian made from the German: `komposita` tips[0].examples[0], tips[3].examples[0]/[1]; `stilmittel` tips[0].examples[0], tips[3].examples[0]; `wirtschaft` tips[3].examples[0]; `stilmittel` help.context.en ("not exactly a success" vs „nicht unbedingt gelungen“).

Ukrainian renderings to check:
- Proverb equivalents in `quest_c2_1_sprichwoerter` (and deck): Krug/Brunnen = «Доти глек воду носить, доки йому вухо не відірветься», Die Katze lässt das Mausen nicht = «Вовк линяє, але норову не міняє», Tag/Abend = «Не кажи «гоп», поки не перескочиш», Hänschen/Hans = «Чого Івась не навчився, того Іван не знатиме», Viele Köche = literal + «у семи няньок дитя без ока».
- Colloquial register words in `quest_c2_1_register`: Kohle = «бабло», kapieren = «допетрати», Typ = «чувак», klauen = «поцупити».
- Craft words in the two picture hunts: Klüpfel = «столярна киянка», Streichmaß = «рейсмус», Senklot = «висок», Lochwand = «перфорована панель для інструментів», Raufe = «ясла для сіна», Kummet = «хомут», Dreschflegel = «ціп», Gatter = «ворітця, загорожа».
- Konjunktiv I in example translations rendered with «мовляв» (as in C1.2); names transliterated (Вендт, Ортман, Кесслер, Брандт, Їлмаз, Бреннер, Рут).

## C2.2 (button layer)

Done 2026-11-20: 42 files, 2352/2352, 0 errors, 0 flags. Source notes (not fixed):
- `quest_c2_2_wortschatz` cards[57]: the "German" of the card is the English fragment „empty formula“ (deck builder split "set phrase, empty formula" from `anspielung` vocab[5] Floskel). Ukrainian gloss «порожня формула, стала фраза».
- `quest_c2_2_wortschatz` other builder artefacts: cards[124]/[125] split „zu dem Ergebnis“ / „Schluss kommen“ from „zu dem Ergebnis / Schluss kommen“; cards[39] „allein“ alone glossed "the mere thought"; cards[103]–[106], [208]–[212], [231]–[238], [258]–[276], [312]–[314], [330]–[332] carry cue labels („Schach und Bahn“, „Möglichkeit als Wendung“, „Werk einführen“ …) instead of the target word; cards[74] helfen glossed as noun "help". Ukrainian glosses follow the intended word (verbs in the infinitive).
- `quest_c2_2_behoerdensprache`: rememberEn[1] and tips[1].en.text say Bescheid → bestandskräftig, while help.context.en and tips[4].examples[0] have a Bußgeldbescheid becoming rechtskräftig; only mistakes[3] explains the exception. Worth one line in tips[1].
- `quest_c2_2_anspielung` sentences[6].whyEn "The understatement (litotes) shrinks the danger" reads against tips[1].en.trap (nicht ganz ungefährlich after a rescue = life-threatening). Ukrainian: «зменшує небезпеку на словах».
- `quest_c2_2_hoeren_capstone` help.tips[1].check.whyEn: "her support only holds if residents take part": no residents in this panel (AI and jobs); the check seems to come from another text. Translated as written.
- `quest_c2_2_lesen_capstone` help.tips[1].check.whyEn: „auf sie“ is explicitly ruled out, but the text rules out the grandfather („auch nicht auf den Großvater“), not „sie“. Translated as written.
- `quest_c2_2_appositionen` help.tips[3].en.title "als and wie" but the tip covers only als; tips[2].examples[0] English lacks the German parenthesis „oder, gehobener, roten Weins“.
- `quest_c2_2_streitgespraech`, `analyse`, `dialog`, `diktat_wissenschaft` and others: long dashes (—) in the English prose; the Ukrainian uses colons/full stops. German lines keep their „–“.
- `quest_c2_2_lesen_reform`, `lesen_unwort`, `lesen_dach` etc.: "you practised last" in intros; Ukrainian «ти щойно тренуєш».
- `quest_c2_2_praepositionen_schriftsprache` sentences[17].whyEn: "zuzüglich — the opposite of 'including'" (rather: "plus, added on top"). Kept.

Ukrainian renderings to check:
- Idioms in `quest_c2_2_redewendungen` (and deck): Kind mit dem Bade = «виплеснути дитину разом із водою», Bärendienst = «ведмежа послуга», Flinte ins Korn = «опустити руки», lange Bank = «відкласти в довгу шухляду», das Wasser reichen = «зрівнятися», reinen Wein einschenken = «сказати чисту правду»; mistakes[0] now refers to the Ukrainian «вода» instead of English bathwater.
- Philosophy terms in `quest_c2_2_philosophie`: Vernunft = «розум», Verstand = «розсудок», Unmündigkeit = «неповноліття», Gesinnungsethik = «етика переконань»; Kant's definition rendered «вихід людини зі стану неповноліття, у якому вона перебуває з власної вини».
- `quest_c2_2_fremdwoerter` tips[3] keeps the English false friends (eventually, sensible, pregnant) as "if you know English"; intro adds that many Latinisms are familiar to Ukrainians (очевидний, де-факто, статус-кво).
- `quest_c2_2_fokus`: added that Ukrainian «ще» before a comparative matches noch, and one line on Ukrainian free word order in tips[3]; `appositionen` tips[0].en.trap and hookEn now say Ukrainian appositions agree in case too.
- `quest_c2_2_amtsdeutsch` officialese examples rendered as deliberately stiff Ukrainian («буде приведена до утримання», «набуває застосування») to mirror the German.
- Harbour/antique words: Duckdalben = «швартовна палева група (дукдальб)», Poller = «швартовна тумба», Fender = «кранець», Butterfass = «маслоробка», Ohrensessel = «крісло з «вухами»», Balkenwaage = «терези з коромислом».
- Puns in `quest_c2_2_wortspiel` cannot survive translation: examples keep the German word in brackets (die Steuer / am Steuer, vor Gericht / sein Gericht).

## C1.2–C2.2 source notes: what was done (2026-11-20)

Fixed in German, English, French and Ukrainian:
- Decks: `tool/build-vocabulary.mjs` now skips the hint-label rows of `c2_1_praefixe_semantik`, `c2_2_anspielung`, `paraphrase`, `wortspiel`, `modalverben_system`, `passiv_meisterschaft`, `rezension_redemittel` (CUE_GRIDS), and no longer cuts a short sentence at its comma („Wo gehobelt wird, fallen Späne.“). Slash entries split or rewritten at the source: will … haben (oder sein), stammen aus (oder von), widersprechen / ausweichen / begegnen (+ Dat), kosten / lehren / nennen (+ Akk + Akk), allein der Gedanke, zu dem Ergebnis kommen. Decks rebuilt (C1.2 416, C2.1 355, C2.2 368 cards), fr/uk card meanings re-pointed.
- English labels in German examples (modal_vermutung, praefixe, wortbildung_vor, register); „Jemand muss vergessen haben, sie abzuschließen“; „ist aber keine Serie“; hoeren_traeume „in ihrer üblichen Bedeutung untrennbar“; the translator hook; konj2_kritik English; konj1_lit, valenz, konnotation, anspielung, zuzüglich whys; Hobel/Klüpfel (-el); komposita joint tip; nine C2.1 intro counts; the law trap moved to the law tip in wirtschaft; Bußgeldbescheid exception in behoerdensprache; appositionen tip title and wine example.

Checked and left as they are (not errors): `relativ_advanced` „weiterführende Nebensatz“ (shown with its article der); the C2.2 capstone check whys (the German check question does mention die Anwohner and „auf sie“); redewendungen / fremdwoerter paraphrase cards (correct German with correct meanings). Minor English-shorter-than-German examples not changed.
