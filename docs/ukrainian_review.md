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
