# French mode: open doubts

Written by the translator agent: file + key + doubt. Checked by a native speaker later.

## tool/turkish/ui/fr.json (interface strings)

- `The language the site explains German in. In Turkish, Arabic and Ukrainian, levels A1 and A2 are available.`: French added to the list (« En turc, en arabe, en ukrainien et en français… »), since the French reader is in French mode. Drop it if French is listed elsewhere.
- `Learn German Free — Swipe-Through Course, A1 to C2 | Language Quiz`, `Learn German from English with {n} free…`, `A German course for English speakers living in Germany…`: "A1 to C2" changed to « de A1 à A2 » and "from English / for English speakers" to « en français / pour francophones », as the Ukrainian table does. The placement/word-check SEO lines keep A1 à C2 (the test covers all levels).
- `English`, `Hide English`, `Show English`, `Show the English`, `Hide the English`, `EN shows it in English` (Schreib mir! help): the toggle reveals the translation line, which is French in French mode, so « Français » / « Masquer la traduction » / « Afficher la traduction ». `Show it in English` (untranslated pages) stays « Afficher en anglais ».
- `The rest of the chapter's words, with pictures. Cover the English, test yourself.` / `The English is underneath, small.`: rendered as « Cachez le français » / « La traduction est en dessous », assuming the French books print French under the German.
- `Mistakes English speakers make` → « Erreurs fréquentes des francophones »; `Ten beers, ordered without a word of English…` → « sans un mot de français ». Check the section content matches.
- German-word cards (`“Grief bacon”: …` to `“Storm-free”: …`): literal French glosses in « »; a French equivalent added in brackets where one exists (l'esprit de l'escalier, château en Espagne, haut comme trois pommes, faire le pont). `Germans say “Daumen drücken”… where English crosses fingers` → « là où en français on croise les doigts ». Some literal glosses may want a native touch (« Doucheur à l'eau chaude », « Gareur à l'ombre »).
- `In German the moon is masculine and the sun is feminine…`: added « L'inverse du français. »; `Germans write 3,5 kg…: a comma, not a point.` → « une virgule, comme en français ».
- About page (`Creator of Language Quiz…`, `Independent developer and course author`, `Hi — I'm GDI…`, `I build this on my own…`): the English keeps GDI's gender open (they/themself), so the French avoids gendered forms (« À l'origine de Language Quiz », « Développement indépendant et rédaction du cours », « Je vis en Allemagne depuis 2019 », « sans équipe »). Check it still reads naturally.
- `Every page you write on has a small code at the top. Scan it and choose Book or App…`: the buttons show t('Book') → « Livre » and a literal « App », so the text says « Livre ou App ». Other lines say « choisissez App ».
- `Which number did you hear?` / `Tap this number` (number board, 0–10) → « nombre »; phone-number screens use « numéro ».
- `Adventurous` (deck pace) → « Aventureux », read as describing the pace (le rythme), not the learner. `Fast learner` → « Rapide ».
- `What is` (contact captcha, followed by "{a} + {b}?") → « Combien font »; the "?" after it is hard-coded without the narrow space.
- quest_a1_1_diktat_steckbrief · help.tips[2].visual.rows[1].a · the English source has no key for this row ("“ee” — see"), so it stays English in French mode; only rows[0] and rows[2] could be translated.
- quest_a1_1_farben · help.intro / help.remember[1] · the English says orange never takes an ending, but help.tips[2] says standard German does inflect it (ein oranges T-Shirt). Translated as written; the source contradicts itself.
- quest_a1_1_alphabet · help.tips[0] (title, text, trap, visual), help.remember[0], help.mistakes[0].why · rewritten for French speakers: the English E/I swap ("ay"/"ee") is not a French problem, so the tip is now about E = « é » and U = « ou ». The check keeps its fixed answer I (« dit « i » »), which is now easy for a French speaker.
- quest_a1_1_laender · englishTemplates (Woher / Himmelsrichtung) · country subjects have no article, so "I come from {subject}" became « {subject} : je viens de là-bas. » (avoids de/d'/du/des). Check it reads naturally in the app.
- quest_a1_1_plural · englishTemplates.Plural (die …)[1] · "Here are many {pl}." became « Ici, il y a des {pl} partout. » because « beaucoup de {pl} » would need d' before a vowel (enfants, hommes), which the template cannot do.
- quest_a1_1_artikel · subjects[20] · bread → « un pain » so the templates work (« C'est un pain », « Le pain est ici »); slightly odd for a non-count noun, but correct French.
- quest_a1_1_sprechen_vorstellung · phrases[6].translation · Freut mich → « Ça me fait plaisir. (pour dire « enchanté ») » to avoid the gendered « enchanté(e) » the learner would say; check it reads well.
- quest_a1_1_sprechen_kurzcheck · speaking.material (and other speaking.* prompt text) · the learner's instructions to the AI use « tu » (as tr/uk do); the learner is still « vous » everywhere else.
- quest_a1_1_sprechen_vorstellung / quest_a1_1_sprechen_zahlen / quest_a1_1_zahlen · help.tips (pronunciation) · English respellings replaced by French ones (« tsvaï », « tsén », « vaïne », « viin », « TSVAN-tsich »); the ich-sound is written « ch » with a description. Approximations, worth a native check.
- quest_a1_1_zahlen_gross · help.intro / help.tips[1] · rewritten: French already uses the decimal comma, so the trap is now the German thousands point replacing the French space (French sentences write 1 200 with a narrow no-break space). Also added the French traps « mille neuf cent » (years) and « le trois juin » (ordinal dates).
- quest_a1_1_pronomen / quest_a1_1_zahlen_gross · sentences (« Je suis fatigué », « Je suis né en 1998 ») · first-person example sentences are translations of the German and use the masculine as default; change if a neutral wording is preferred.
- quest_a1_1_zahlen · englishTemplates.Auf Deutsch[1] · "Platform {subject}" → « Voie {subject} » (French railway word).
- quest_a1_1_wfragen · sentences[n].english · the cue sentences keep the ____ blank inside a French question (« ____ habites-tu ? (où) »); the hint gives the French word (« En français : où »).
- quest_a1_1_sein_haben · help.tips[2] · rewritten for French: avoir faim/soif/peur = Hunger/Durst/Angst haben (same as French); the trap is now age (« j'ai vingt ans » = Ich bin zwanzig).

## a1_1 book

- amt · grammar[0].blocks[0].tiles[3,4,8,12,13,14,15,17,20].say · the English source has no keys for these respellings (D "day", E "ay", I "ee", M "em", N "en", O "oh", P "pay", R "air", U "oo"), so they stay English in the French book; only the listed tiles could get French respellings (bé, tsé, yott, faou, vé, tsètt…). E "ay", I "ee" and U "oo" are misleading for a French reader.
- amt · grammar[0].blocks[0].note / grammar[0].blocks[1].blocks[0].text · the six marked letters (E, I, J, V, W, Z) are fixed in the layout; rewritten for French speakers (E = « é », I = « i » like French) and the U = « ou » trap added in words, since it is not marked.
- amt · grammar[0].check.items[4] · the German line "E klingt wie englisch ___" (answer A) stays as it is (German never changes); it tests an English comparison a French reader does not need. Same for grammar[1].check.items[3] ("ä klingt wie ___ (anglais)", answer "bed"): an English word in a French book.
- zahlen · grammar[0].blocks[2].blocks[1].text / grammar[0].fact · the English contrast (English fingers vs German thumb counting) does not travel: French speakers in France also count from the thumb. Rewritten as « comme souvent en France », the trap being « deux » shown with index + middle finger. Check for Belgium/Switzerland/Canada readers.
- zahlen / markt · grammar[1].blocks[2].blocks[1] / grammar[0].blocks[3] (point and comma) · rewritten: French already uses the decimal comma, so the trap is only the thousands point (1.200) replacing the French space.
- markt · grammar[0].fact · "not the 454 g of the English pound" replaced by « comme la livre des marchés français » (500 g in France too).
- laender · reading.tasks[0].instruction · the English says "Write M or the man's country" but the task is a circle with options Maya / der Mann; translated as « Entourez la bonne réponse ». Check the source.
- laender · document.tasks[1].items[n].before, document.tasks[2].items[n].prompt · board city names stay in English as printed on the board (Luxembourg, Basle, Munich, Cologne, Nuremberg); the instruction says the board writes them in English.
- hallo · grammar[0].blocks[0].rows[n][0] · English "you" questions given in both French forms (« Comment t'appelles-tu / vous appelez-vous ? »), since the table has du and Sie columns. Longer than the English; shorten if the cell overflows.
- wohnung · document.fact · Mensch ärgere Dich nicht glossed as « ne t'énerve pas », « cousin des petits chevaux » added.
- familie · words.verbs[1].en · "I have no brothers or sisters" → « Je n'ai ni frère ni sœur ».
- cafe / familie · grammar[1].blocks[1].blocks[0] (Hungry? Use haben) · rewritten as a similarity (« Comme en français, on a faim »), the trap kept for age (Ich bin zwanzig = j'ai vingt ans).
- steckbrief · reading.en · Mr Ziegler's school English "The cat is on the table." kept in English (a character quoting English); Maya's reply is the German line, translated.

## a1_2 app (batch akkusativ … lesen_mauer)

- quest_a1_2_hoeren_geburtstag · help.hook · the English says Ben picks Elif up "at half past seven", but the transcript and questions[3] say halb sieben (6:30); the French says « six heures et demie ». Check the English source.
- quest_a1_2_dativ_pronomen_intro · subjects[n].english / subjects[9–11].display · pronoun pairs rendered with the French COI forms (« je → me, à moi », « il → lui », « ils/elles → leur », « à eux, leur »); er and sie both give « lui », which is French reality but may look odd side by side.
- quest_a1_2_dativ_pronomen_intro · help.tips[1].trap · rewritten for French: aider/remercier take a COD in French (je l'aide, je le remercie) but helfen/danken take the Dativ; gefallen presented as « plaire à » (same structure as French).
- quest_a1_2_bigtext_meintag · inlineBlanks[1,5,6,7].hint · English "a (der …)" rendered « un/une (der …) » for every indefinite hint, so the French gender (une pomme for der Apfel) never hints at the German article; « le/la (der Bus) », « pas de (das Auto) ».
- quest_a1_2_datum · sentences[0–6].why · the English etymology notes (Tuesday, Thursday, Friday) rewritten with French day names (lundi = Mond/lune, mardi = Mars, jeudi = Jupiter dieu du tonnerre, vendredi = Vénus/Freya, samedi = sabbat).
- quest_a1_2_datum · help.tips[2].text / help.mistakes[1].why · added the French trap: French dates use the cardinal (le trois mai) except « le premier »; German always the ordinal.
- quest_a1_2_hoeflich · help.tips[3].trap · English "would like" trap rewritten: French « je voudrais » is a conditional of vouloir, but German has no „Ich würde wollen / mögen“: möchte / hätte gern.
- quest_a1_2_hoeflich · help.tips[0].visual.points[1,2] · English gives "I'd like a loaf." twice (hätte gern / möchte); French distinguishes them as « J'aimerais avoir un pain. » / « Je voudrais un pain. ».
- quest_a1_2_bigtext_meintag / quest_a1_2_koerper · passageTranslation, sentences[4].english · first-person narrators default to the masculine (« je suis très fatigué », « je suis assis »), as in A1.1.
- quest_a1_2_lesen_anzeigen · passageTranslation · Volkshochschule rendered « université populaire »; times written « 18–20 h ».

## a1_2 app (batch lesen_muenster … wortschatz, _syllabus)

- quest_a1_2_lesen_pfand / quest_a1_2_lesen_sonntag · passageTranslation, questions[n].questionTranslation · the German texts address the reader with du (Du kaufst…, Du bist neu…); the French keeps « tu » to mirror the German (and the du-imperatives the lesson teaches). Sonntag's « Tu es nouveau » is masculine by default.
- quest_a1_2_possessiv · englishTemplates (sein/ihr) · French « son/sa » cannot show the owner, so the templates add « (à lui) » / « (à elle) »; help.tips[2].text/trap rewritten around this (French looks at the noun, German sein/ihr at the owner).
- quest_a1_2_pronomen_akk · help.intro, help.tips[1].trap, sentences[11,13] · "it" rewritten as French « le/la », with the warning that the German gender decides (der Schlüssel → ihn though « la clé »; das Fenster → es though « la fenêtre »). The cue "(it — der Schlüssel)" in the German sentences became « (le/la : der Schlüssel) ».
- quest_a1_2_negation · help.intro, help.tips[1].trap · rewritten with the French pair « ne … pas » / « pas de »; the trap now says French « pas un » exists but German nicht ein does not.
- quest_a1_2_perfekt_intro · help.tips[2].trap · English "only have" trap replaced: French être-verbs match (je suis allé/resté, il est arrivé); added the one snag, fahren = « conduire » takes avoir in French but sein in German.
- quest_a1_2_satzbau / quest_a1_2_schreiben_absage · sentences/subjects with denn · denn translated « car » (keeps word order, like German denn), weil glossed « parce que ».
- quest_a1_2_war_hatte · help.intro, help.tips[2].trap · war/hatte presented as covering both the imparfait and the passé composé (j'étais / j'ai été); trap: do not calque « j'ai été » as ich bin gewesen.
- quest_a1_2_uhrzeit / quest_a1_2_sprechen_alltag / quest_a1_2_wortschatz · help.tips[0].trap etc. · halb trap rewritten for French (« huit heures et demie » = 8:30 ≠ halb acht); nach/vor glossed as « et » / « moins » (et quart, moins le quart).
- quest_a1_2_wann_praepositionen · help.tips[0].text, help.tips[3] · added French contrasts: « lundi », « le soir » have no preposition in French but am in German; « en 1995 » vs bare year.
- quest_a1_2_wohin · help.intro, help.tips[2] · zu with people glossed as French « chez »; trap rewritten (French « à » covers à Berlin, au cinéma, à la gare).
- quest_a1_2_suchbild_kueche · help.intro · one sentence added that French gender does not help (la porte / die Tür, la fenêtre / das Fenster). Not in the English.
- quest_a1_2_sprechen_einkaufen · help.intro, help.tips[2] · ö explained as French « eu », ä as « è »; Ich hätte gern rendered « j'aimerais (avoir) » to keep it distinct from möchte « je voudrais ».
- quest_a1_2_modalverben · help.vocab[3], help.tips[3] · möchten glossed « aimer bien, vouloir (poli) » / « je voudrais »; können sentences with swimming/cooking translated « savoir » (je sais nager), which is the natural French.

## a1_2 book (all twelve chapters + _front)

- arzt · grammar[1].blocks[0].rows[n][0] · the doctor's table glosses müssen nicht as « pas besoin de » and brauchen as « il vous faut », to keep « vous ne devez pas » for dürfen nicht; check against the German column.
- biergarten · grammar[1].blocks[0].blocks[0].note · added a French trap not in the English: « on aide quelqu'un, mais Ich helfe dir » (aider takes a COD in French, helfen the Dativ).
- einkaufen · grammar[0].blocks[3].title · "Amount + thing, no 'of'" rewritten as « Quantité + chose, sans « de » »; the French column shows « un kilo de pommes » etc. Subject/object rows rendered « qui fait l'action (sujet) » / « ce qui subit l'action (COD) », note adds « comme il devient le ».
- einkaufen · grammar[1].blocks[1].note · kein glossed « pas de », nicht « ne … pas ».
- gestern · grammar[1].subheading, practise · "past form" rendered « participe » throughout; subheading adds « Comme le passé composé ». grammar[0].blocks[2].blocks[0].text adds the French « j'ai été / j'ai eu » calque warning.
- kurs · grammar[1].blocks[2] · English trap "will / must not" rewritten as « Piège : musst nicht » (French « tu ne dois pas » = du darfst nicht); können with skills rendered « savoir » (je sais nager).
- nachricht · grammar[0].blocks[1].tiles[3] etc. · denn rendered « car », as in the app.
- rezept · grammar[1].blocks[1].note · added that French recipes use the infinitive too (« Couper les oignons »).
- tag · grammar[0].subheading · "front part" rendered « particule »; subheading adds the French contrast (revenir stays whole), which makes it longer than the English.
- woche · grammar[0].blocks[2].note, grammar[1].blocks[0].note · added French contrasts: « lundi / le soir » without preposition vs am Montag; « le trois mai » (cardinal, except « le premier ») vs the German ordinal. Both notes are longer than the English; check print space.
- zimmer · grammar[0].blocks[0] · the "in English" column shows French possessives with « (à lui) / (à elle) »; note adds that French looks only at the thing, German first at the owner. grammar[1].blocks[2] « le/la suit l'article allemand » with the der Schlüssel → ihn / « la clé » warning.
- bahn · grammar[1].fact · ":42" rendered « xx:42 » to avoid a lone colon after « à ».

## a2_1 app (batch 1: bigtext … lesen_hamburg)

- quest_a2_1_dativ_akkusativ · sentences[1].sentence, sentences[15].sentence, help.tips[2].check.q · cue "(it)" rendered by the German gender, (le) for der Garten, (la) for die Tasche (« le sac » is masculine in French, so the why says so); "(it to you)" → « (te le) ». help.tips[2].text and sentences[14].why add the French order contrast (« je te le / vous les » vs es dir / sie Ihnen).
- quest_a2_1_dativ_artikel · help.tips[2].text, sentences[1].why, sentences[16].why · added a French trap not in the English: aider / remercier / féliciter take a COD in French, helfen / danken / gratulieren the Dativ. sentences[13].english (schmecken) rephrased « La glace est bonne, l'enfant l'aime bien ».
- quest_a2_1_komparativ · help.intro, help.tips[0].trap, help.remember[1] · English "more interesting" angle rewritten for French « plus + adjectif » (« mehr groß » as the francophone error); gut → besser bridged with bon → meilleur.
- quest_a2_1_indefinitpronomen · help.intro, tips[0], tips[2].trap · man presented as the French « on »; trap rewritten around « ne … rien » (one negative in German); etwas Neues glossed « quelque chose de nouveau ». The English trap about the general "you" kept as the French general « vous/tu ».
- quest_a2_1_dativ_praep · help.tips[3] · seit + present presented as identical to French « depuis » + présent (the English warns against a perfect).
- quest_a2_1_hoeren_ankunft · passageTranslation · the reporter says tu to Amira (German: Hat dich jemand abgeholt?), and Amira's advice is in tu (Frag jemanden).
- quest_a2_1_hoeren_geschenk · passageTranslation · "Eighty is almost gold" rendered « c'est presque des noces d'or » to keep the joke readable; check if it sounds natural.
- quest_a2_1_lesen_adler, quest_a2_1_lesen_dom · passageTranslation etc. · Nürnberg → Nuremberg, Köln → Cologne in French text (German quotes untouched). help.vocab[1].en « locomotive » is the same word as the English.
- quest_a2_1_diktat_perfekt · help.exam · "A2 Schreiben: the marker…" rendered « À l'écrit de niveau A2, le correcteur… » (no German section label).
- quest_a2_1_bigtext_wochenende · passageTranslation · first-person narrator masculine (« je suis rentré »), as in A1.
- quest_a2_1_modal_praeteritum · englishTemplates.* · pronoun-subject templates rewritten one-form-for-all after a colon (« {subject} : il a fallu travailler tard hier », « {subject} : la consigne, c'était de… » for sollen, « {subject} : ça, pas question » for "did not want that"); check they read naturally in the table.
- quest_a2_1_perfekt_sein · help.intro, help.tips[0].trap, sentences[8/11].why · added that laufen, schwimmen, reisen, umziehen take sein although French says « j'ai couru / nagé / voyagé / déménagé »; and that « être » itself takes « avoir » (j'ai été) while sein takes sein.
- quest_a2_1_pronomen_dativ · help.tips[1].visual.rows[*].a · the "English" column now shows the French « J'aime la ville » etc.; gefallen explained as « plaire » (le livre me plaît). Also noted helfen/danken take the dative where « aider / remercier » take a COD.
- quest_a2_1_wetter · sentences[3,4,7,12,13].why · English-etymology whys (harvest, "same word as English", "k for c") replaced by plain French notes.
- quest_a2_1_lesen_wetter · passageTranslation, questions[4/5] · Freiburg → Fribourg-en-Brisgau, Duisburg → Duisbourg, Hamburg → Hambourg in French text; thousands written 2 962 with a narrow no-break space. help.tips[1].text: Aprilwetter compared with « giboulées de mars » (my addition).
- quest_a2_1_war_hatte · help.intro, help.tips[0].text · war/hatte (background) vs Perfekt (events) bridged to imparfait vs passé composé.
- quest_a2_1_schreiben_wochenende, quest_a2_1_sprechen_dialog · writing.topic, speaking.material · rephrased to keep the learner's gender open (« où vous avez passé le week-end », « Le moyen de transport », « ou une surprise »).
- quest_a2_1_wortschatz · cards[101], help.vocab Strandkorb · « fauteuil-cabine de plage (Strandkorb) »; cards[35] Kutsche « calèche ».

## a2_1 book (bodensee … wetter, _front)

- kaufhaus · grammar[0].fact · UK-size comparison replaced by French sizes: « un 40 français ≈ un 38 allemand », shoes same scale, « retirez deux à votre taille »; please confirm the rule of thumb (women's sizes; men's may differ).
- kaufhaus · grammar[1].blocks[1].text · rewritten for French « j'aime » (covers like and love): warns that « j'aime » is not *ich liebe*. grammar[1].blocks[0].note bridges gefallen with « plaire » (le manteau me plaît).
- kindheit · document.fact · English joke about foreigners bragging about their 5 replaced by a Swiss note (« En Suisse, c'est l'inverse : 6 est la meilleure note »), my addition for Swiss readers.
- kindheit · grammar[1].blocks[1].text · war/hatte vs Perfekt bridged to imparfait vs passé composé.
- ostsee · grammar[0].blocks[1].rows[*][2] · French column shows the French auxiliary (« a couru · a nagé », « a déménagé », « a été ») so the contrast with sein is visible; note says sein ≈ être.
- fundbuero · grammar[1].blocks[2].note · added « même si le français dit « aider quelqu'un » » (helfen + Dativ vs COD in French).
- geschenke · grammar[1].blocks[1].note · added « (comme « je le lui donne ») » for the pronoun order.
- hamburg · grammar[1].blocks[1].blocks[0] · "man is not a man" rewritten as « man, c'est « on » ».
- heidelberg · grammar[1].blocks[0].blocks[1].text · zu Hause / nach Hause: French says « à la maison » for both (English angle "one word / two" dropped).
- sonntag · grammar[0].fact · Präteritum compared with the French passé simple (books, news).
- ulm · grammar[0].blocks[0].note · « Jamais « mehr interessant », même si le français dit « plus intéressant » ».
- wetter · grammar[0].blocks[1].note · es ≈ « il » (il pleut), plus the trap « il fait froid » = es ist kalt (my addition).
- heidelberg · practise[4].instruction · "Your friend" → « Une amie » (gender of the friend fixed to keep it short); prompts in tu to match the German answer (Dann biege links ab).
- bodensee · grammar[1].blocks[0].blocks[0].rows[*].en · these "en" values are German in the English too (beim Arzt…), kept German.
- a2_2 genitiv_s_datum · subjects[5..14] · French dates use cardinals (« le trois »); the "on the …" subjects (am …) got « , à cette date » to keep them apart from der … ones. Clunky, please check.
- a2_2 genitiv_s_datum · help.tips[0].trap / help.tips[3].trap · rewritten for French (« la voiture d'Anna » word order; « le douze mars » cardinal vs German ordinal); one line kept about the English 's.
- a2_2 grammatikwoerter · sentences[11].english, help.tips[1].examples[1].en · French « aider qqn » is direct, so "Whom are you helping?" cannot be « À qui… »; written « Tu aides qui ? (helfen prend le datif) ».
- a2_2 grammatikwoerter · subjects[9], subjects[10] · nominatif and accusatif are both « qui ? » in French; told apart with (sujet) / (COD).
- a2_2 koennte_sollte · englishTemplates.sollte (Ratschlag)[0] · "{subject} should sleep more (advice)." exists in the course but has no key in en/; it will stay English unless extract picks it up.
- a2_2 adjektiv_intro · subjects · « J'ai un vieil homme », « Je vois un pull chaud » are odd but mirror the English templates.
- a2_2 hoeren_werbinich · help.tips[1].text · added: sich weigern = « refuser » without « se », and the reflexive Perfekt takes haben, not « être » (my addition).
- a2_2 lesen_formular · passageTranslation · "Adult Education Centre" (Volkshochschule) rendered « Université populaire Nord »; dates kept as 12.03.1995 since French also writes day.month.year (intro and tips[1] rewritten to say so instead of warning about the US order).
- a2_2 lesen_grimm · passageTranslation · book title given as « Contes de l'enfance et du foyer » (usual French title of the Kinder- und Hausmärchen); Bremen → Brême, Kassel kept as Kassel (not the old « Cassel »).
- a2_2 lesen_tracht · help.tips[1].text, .check.why · English "die Hose is singular in German!" rewritten: French « le pantalon » is singular too, so the warning now points at the gender (feminine) instead.
- a2_2 passiv_intro · subjects/sentences · some French renderings use « on … » or « en réparation / en construction » rather than a literal passive (Ici, on parle allemand; Le magasin ouvre à neuf heures), because a French être-passive would read as a state, which is exactly the trap the lesson warns about.
- a2_2 relativ_intro · help.intro, help.tips[1] · rewritten around French « qui » (Nominativ) / « que » (Akkusativ); the English trap (dropping "that") replaced by a gender trap (« que » vs den/die). sentences[8] « les amis à qui nous rendons visite » keeps besuchen's accusative explained in the why.
- a2_2 reflexiv · help.tips[1].trap · rewritten to compare with French verbes pronominaux (match: se dépêcher, se souvenir; mismatch: sich freuen = être content, sich erkälten = prendre froid, se promener = spazieren gehen). Please check that the mismatch examples are what you want.
- a2_2 sprechen_dialog · help.tips[0].text · "English says 'to Munich on Saturday'" now compares with French « à Munich samedi ».
- a2_2 schreiben_email · subjects[1], subjects[2], sentences[1–2].english · "Dear Mr Braun" → « Monsieur, » / « Monsieur Braun, » (French formal letters don't use « Cher Monsieur Braun »); "Yours sincerely" → « Salutations distinguées ».
- a2_2 superlativ · help.intro, help.remember[0] · added the French bridge « le plus … » vs am …-sten (no word for « plus », like the Komparativ file); many sentences[*].english rendered as « C'est X qui est le plus … » to keep the adverbial superlative natural.
- a2_2 tekamolo · help.intro, help.tips[0].trap · English "reverse of English" rewritten: French is flexible and often puts place before time (« je vais à Berlin en train demain »); please check the claim is not overstated.
- a2_2 verben_praep_intro · help.intro, help.tips[3].text, sentences[14/16].why · da-/wo- compounds bridged to French « y » / « en » (ich denke daran = j'y pense); trap rewritten around attendre (no preposition) and s'intéresser à ≠ für.
- a2_2 verben_praep_intro · subjects[0..1], help.vocab[0..1], wortschatz cards[94..95] · sich freuen auf / über as « se réjouir de (à venir) » / « être content de (déjà là) ».
- a2_2 weil · sentences[8].english · German glücklich rendered « de bonne humeur » to avoid gendered « heureux/heureuse » in a je-sentence; tips[1].examples[0] "I'm tired" → « J'ai sommeil » for the same reason. Fronted weil-clauses translated with « Comme … ».
- a2_2 weil · help.tips[2] · denn bridged to French « car » (verb second), weil = « parce que ».
- a2_2 wenn_deshalb · help.tips[3] · rewritten: French « quand » covers both wenn and als; deshalb = « c'est pourquoi » throughout.
- a2_2 wortbildung · help.intro · added French parallels (-er ≈ -eur, -ung ≈ -tion/-ment, un- ≈ in-/mal-, -bar ≈ -able/-ible); subjects[8] "friendly → unfriendly" = « aimable → désagréable »; sentences[15].english uses « la cheffe ».
- a2_2 wortschatz · cards[311].en · Es tut mir leid → « Je regrette. (Désolé.) » (gender-neutral first meaning); cards[190], [193] könnten/sollten written per person.
- a2_2 book camping · grammar[1].fact · added the French equivalent saying « Avec des si, on mettrait Paris en bouteille » after the translated Wenn-das-Wörtchen-wenn proverb (my addition, can be cut for space).
- a2_2 book camping · grammar[1].blocks[2].text · added « Le français dit « quand » dans les deux cas » (wenn vs als).
- a2_2 book weimar · grammar[0].blocks[0].note · "ob = whether, if" rewritten: ob = si (question), and the conditional « si » is wenn (practise[2] has the wenn/ob trap).
- a2_2 book verabredung · grammar[1].blocks[0].head[2] etc. · "in English" column → « en français » with French verb+preposition meanings; added « La préposition française aide rarement » and the « y / en » bridge for darauf/daran.
- a2_2 book krimi · grammar[1].blocks[1].text · added the qui → der / que → den bridge (as in relativ_intro).
- a2_2 book kur · grammar[0].blocks[2].blocks[0].text · "Like seit in A2.1" replaced by « Comme « depuis » en français : au présent » (French uses the present with depuis too).
- a2_2 book maerchen · names · Hameln rendered « Hamelin » in French prose (usual French name); German captions keep Hameln. Fairy Tale Road = « Route allemande des contes » (as in lesen_grimm).
- a2_2 book auto · reading.en · Max's informal letter to the office uses tu/« Chère Ville » to keep the joke; formal replies use « Monsieur, » / « Salutations distinguées » (as in schreiben_email).
- dictionary part-01–06 · all · German quoted inside glosses uses „…“ (no spaces), French quotations « … » with U+202F; English " — " separators became commas or « : » (no long dashes).
- dictionary part-03 · doch|particle · English example softener 'do come in, won't you' rendered as the French « entrez donc » (not a German example): check it reads well in the popup.
- dictionary part-05/06 · Zett, Jot, Vau, We, Be, Ka · English pronunciation hints re-spelled for French readers (« tsètt », « yott », « faou », « vé », « bé », « ka »).
- dictionary part-06 · modal|adjective · rendered « de manière » (the connector sense: temporal/kausal/modal/lokal); French « modal » alone would suggest modal verbs.
