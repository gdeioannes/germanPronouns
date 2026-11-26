# Arabic: doubts for a native speaker

The Arabic in Arabic mode was written by an AI. Lines the translator was unsure of are listed
here (file, key, doubt) for a native speaker to check.


## tool/turkish/ui/ar.json (interface strings, batch 1)

- "English" / "Hide English" / "Show English" / "Hide the English" / "Show the English": rendered as «العربية» (the translation language), as Turkish does with «Türkçe». "Show it in English" (NotInLanguage) and "EN shows it in English" (Schreib mir!) stay «بالإنجليزية» because there it really is English.
- "Mistakes English speakers make" → «أخطاء يقع فيها الناطقون بالعربية»: the box content must then be about Arabic speakers, or the heading misleads.
- "· German for English speakers" → «· الألمانية للناطقين بالعربية».
- Loading tips (literal translations of German compounds, e.g. «لحم الحزن» for Kummerspeck, «فكرة العرق» for Schnapsidee): literal on purpose; a native speaker may prefer other renderings. "I only understand train station: it is all Greek to me" → «لا أفهم شيئًا على الإطلاق» (no Arabic idiom used).
- "In German the moon is masculine and the sun is feminine" → added «كما في العربية» (true and helpful; guide says it is luck, not a rule).
- "Gift means poison in German" kept the English-gift angle («لا هدية كما بالإنجليزية»), since the joke needs it. "A projector. In English, a BMW." (Beamer) also kept.
- "Ten beers, ordered without a word of English" → «دون كلمة واحدة بغير الألمانية».
- "Hovering around" (level-check, before a level) → «حوالي»; "Released." (SwipeDeck) → «أُفلتت.» — check in context.
- "Not sure of the words yet? \"Cards\" turns..." → «البطاقات» as the label; check it matches the Arabic button text of that tab.
- Fragmented sentences (e.g. "Blue words are" / ", red words" / ", green words"; "Paste the whole report... The" + "line is read automatically") translated as fragments; word order should be checked on the live page.
- Arrows "→" / "←" kept as in English (e.g. "Let's go (→)", "Skip (←)"); in RTL layout the direction may need flipping.

## tool/turkish/ui/about.ar.svelte (About page)

- Followed the Turkish structure; the Turkish "Türkçe" bullet in the AI list became an «العربية» bullet saying the Arabic was translated by Claude and not yet fully checked by a native speaker. Please confirm that claim stays true.
- "Learning beats testing" → «التعلّم أهم من الاختبار»; "Privacy is ... the architecture" → «بل هي أساس البناء». Check tone.

## tool/turkish/ar/a1_1/app (A1.1 exercises)

- quest_a1_1_artikel englishTemplates: Arabic has no bare-noun form that works for every gender after «هذا/هذه» and cannot glue «ال», so: bestimmt → «{subject}؟ هنا.», unbestimmt → «ما هذا؟ {a} {subject}.», verneint → «لا يوجد هنا {a} {subject}.» (the last is "there is no X here", not literally "that is not a X"). Check they read naturally in the drill.
- quest_a1_1_plural englishTemplates: «أرى اثنين: {pl}.» and «هنا {pl}، بأعداد كثيرة.» (bare singular noun, gender-neutral).
- quest_a1_1_laender: added a short note that der Irak, der Libanon, der Jemen, der Sudan take an article (aus dem Irak), plus Arabisch and aus Damaskus as examples, because Arabic readers need it. Not in the English. Also «Syrer / Syrerin» added as an -in example.
- quest_a1_1_zahlen3 / zahlen_gross: rewrote "German says numbers backwards" as "German says 21 like Arabic: واحد وعشرون"; years before 2000 said in hundreds is noted as different from Arabic.
- Pronunciation checks (zahlen tips[2], sprechen_zahlen tips[0], sprechen_vorstellung tips[1]): options rewritten in Arabic letters («تسڤاي / سڤاي / زڤي», «-تسيش / -زيك / -سيك», «ڤاين / واين / ڤين»). The soft ch / -ig is written «يش»; a native speaker may prefer another spelling.
- quest_a1_1_alphabet: letter names in Arabic letters: E «إيه», I «إي», W «ڤيه», Z «تسيت», J «يوت», V «فاو». Check E vs I is clear to Levantine/Iraqi/Maghrebi readers.
- quest_a1_1_farben: the English cognate tricks in the whys (rot ~ rouge, gelb ~ gold, schwarz ~ swarthy) were replaced with pronunciation hints in Arabic letters.
- quest_a1_1_praesens tips[2].trap: replaced the English-speaker error ("Ich bin lernen") with the typical learner error of leaving the infinitive ("Ich lernen Deutsch") plus the bin-error; mistakes[0] (wrong form in the German data) still says "no continuous form".
- quest_a1_1_wfragen: doch = «بلى» (exact match); the three "where"s match أين / إلى أين / من أين. The sentence prompts are Arabic with the gap where the question word goes («تسأل عن شخص: ____ هذا؟ (مَن)»).
- quest_a1_1_pronomen cue «(هو، لغير العاقل)» for es is used even for das Kind / das Baby (guide's cue); might confuse since a child is عاقل. The hint line says «هو، لاسم das».
- quest_a1_1_sein_haben: added that Arabic says «أنا متعب» / «عندي» with no verb, so learners drop sein ("Ich müde").
- quest_a1_1_wortbildung: compounds compared with الإضافة in reverse order (Haustür = باب البيت).
- Dialogue and spelling separators "–" kept as in the English (they separate turns/letters, not prose).

## tool/turkish/ar/a1_1/book (A1.1 book)

- book/steckbrief reading.en: the build flags it as "looks English" because Mr Ziegler's line "The cat is on the table." stays in English on purpose (the joke is his school English). Intended.
- Table head "in English" (column of meanings) is rendered «بالعربية» throughout (hallo, wohnung, tag, woerter), since that column now holds Arabic.
- Pronunciation tiles (zahlen, amt) rewritten in Arabic letters: ines «آينس», tsvai «تسڤاي», noyn «نوين», tsvölf «تسڤولف»; letter names bay «بيه», tsay «تسيه», gay «غيه», vay «ڤيه», üp-si-lon «أوپ-سي-لون», ess-tset «إس-تسيت». The guide's «ق/پ» conventions applied; check readability.
- amt grammar[1].blocks[1].text: ä/ö/ü explained with Arabic sounds instead of English words (bed, fur, ee) — «إ» مفتوحة، «إ» بشفتين مستديرتين، «ي» بشفتين مستديرتين.
- amt grammar[0].blocks[0].note "the six letters English speakers get wrong" → "the ones many people get wrong, especially if they know English". The Arabic-specific p/b problem is not mentioned in the book (no key for it).
- laender grammar[0].blocks[1].blocks[0].text: added aus dem Irak / aus dem Libanon (as in the app, approved).
- markt: "ein Kilo Äpfel" compared with «كيلو تفاح»; familie: mein/meine compared with Arabic «ـي» for all genders; woerter: compounds compared with الإضافة read in reverse.
- zahlen grammar[1].blocks[1]: title "21–99: say it backwards" changed to «الصغير أولًا، كما في العربية»; the "old English four-and-twenty" comparison replaced with «واحد وعشرون».
- tag grammar[0].blocks[1].blocks[1] "One present, three Englishes" → «مضارع واحد، كما في العربية».
- Pfund kept as «نصف كيلو» in word lists; grammar fact keeps the comparison with the English pound (454 g).
- Kinship: Lena's uncle Jan / aunt Lisa rendered «خالي / خالتي» (mother's side assumed; the German Onkel/Tante does not say). Check.
- The word «Altbau», «Späti», «Baumarkt», «Bürgeramt», «Kiez» kept in German inside Arabic prose, with a short gloss the first time.

## tool/turkish/ar/a1_2/app (A1.2 exercises)

- Case wording: Akkusativ = «حالة النصب» / «المفعول به»; Dativ = «حالة الجر بعد بعض الأفعال والحروف (Dativ)» on first use, then "Dativ". In akkusativ the intro compares with i'rab (رأى الرجلُ الكلبَ) and notes that German marks the article, not the ending.
- praepositionen: added that in Arabic every noun after a preposition is مجرور, while durch/für/gegen/ohne/um take the Akkusativ (counter-intuitive for Arabic speakers).
- dativ_pronomen_intro: helfen and danken are transitive in Arabic (يساعدني، أشكرك) — flagged as the Arabic-speaker trap; gefallen compared with «يعجبني» (same structure as German).
- pronomen_akk: object pronouns compared with attached Arabic pronouns (أراه، يراني) and «وجدتُه / وجدتُها» for things; cues for "it — der X" rendered «(للشيء: der Schlüssel)».
- akkusativ englishTemplates: «أمامي {subject}.» (definite) and «عندي {a} {subject}.» (indefinite), gender-neutral; possessiv templates «{subject}: هذا لي / لك / له / لها.» Check they read naturally.
- uhrzeit: halb vs Arabic «الثانية والنصف» (hour first) explained; Viertel vor = «إلا ربعًا», like Arabic.
- datum: weekday whys (English cognates Thor, Freya…) replaced with Arabic notes (week starts Monday; Samstag ≈ السبت; pronunciations in Arabic letters). Months use يناير/فبراير…; Levantine/Iraqi readers say كانون الثاني/شباط — consider adding them.
- einkaufen_mengen: "no 'of'" compared with Arabic «كيلو تفاح» (إضافة).
- koerper: «رأسي يؤلمني» same structure as Mein Kopf tut weh; trap rewritten for Arabic genders (العين/الأذن feminine in Arabic, das Auge/das Ohr neuter).
- hoeflich: Könnten Sie ≈ «ممكن …؟ / لو سمحت».
- war_hatte: war compared with «كان».
- Mrs/Frau addressed in masculine «حضرتك» forms in most sentences (guide: masculine singular), but a few lines use feminine verb forms for a woman (e.g. «ماذا تودّين حضرتك أن تطلبي، يا سيدة Klein؟»). Unify if preferred.

## Month names (decision 2026-11-11)

- Every Arabic month name now carries the Levantine/Iraqi name in brackets: «مايو (أيار)»; inside an existing bracket it is «(يناير / كانون الثاني)». Applied to A1.1 app+book, A1.2 app+book. Repeated mentions in one text also get both names; trim to the first mention if it reads heavy.

## tool/turkish/ar/a1_2/book (A1.2 book)

- Speaker labels in German in the English (Verkäufer, Kellner, Ärztin, Durchsage, Oma, Mann) rendered in Arabic inside reading.en (البائع، النادل، الطبيبة، الإعلان، الجدة، رجل); Frau Huber addresses Maya as «آنسة Maya» for "Frau Maya".
- kurs: "English trap: will and must not" became «فخّان: will وmusst nicht» (Ich will = أريد not "سوف"; du musst nicht = لست مضطرًا vs du darfst nicht = ممنوع).
- bahn: Max reads halb zehn as «العاشرة والنصف»; kept, since Arabic speakers make the same slip. reading.fact "English speakers miss trains" → «متعلمو الألمانية».
- unterwegs: added «in den Irak، in den Libanon» to the countries-with-article note (consistent with A1.1).
- einkaufen / unterwegs: notes that Arabic puts a noun after a preposition in الجر, while durch/für/… take Akkusativ.
- Matching-exercise right-hand meanings (tag practise[3].right, kurs practise[3].right) are Arabic; the answer key pairs them by position, check the printed key still lines up.

## tool/turkish/ar/a2_1 (A2.1 app + book)

- Terms carried over: Perfekt «الماضي التام» / «الـ Perfekt»; Präteritum «الماضي البسيط»; Partizip II «اسم المفعول»; Modalverb «الفعل المساعد الدال على الإمكان أو الرغبة»; Hilfsverb haben/sein «الفعل المساعد»; Komparativ compared with أفعل التفضيل («أكبر من» = größer als).
- modal_praeteritum englishTemplates are impersonal because {subject} can't be conjugated in Arabic: «{subject}: لم يكن بالإمكان المجيء أمس.», «في الطفولة، {subject}: كان اللعب طويلًا مسموحًا.» Check they read acceptably.
- Arabic comparisons added where they help: seit + present = «أسكن هنا منذ سنتين» (temporal_2, bodensee); gefallen = «يعجبني» with the thing as subject (kaufhaus, dativ verbs); German compounds vs Arabic إضافة, head first in Arabic, last in German (suchbild_badezimmer); man ≈ Arabic passive «لا يُسمح بالوقوف هنا» (hamburg); es regnet needs a dummy subject where Arabic says «تمطر» (wetter); war/hatte vs Perfekt ≈ «كان الجو باردًا، فاشتريتُ معطفًا» (kindheit, war_hatte); "never mehr interessant" linked to Arabic «أكثر إثارة» (ulm).
- Dialogue turn separators « – » inside example pairs (Wie war dein Tag? – Gut.) are kept as in the German; they are not prose dashes.
- Speaker labels in reading.en rendered in Arabic (الموظف، البائع، الرجل، الطفل، المدير); names (Frau Huber, Petersen, Tina) kept. Frau Huber says «يا آنسة Maya» as in A1.2.
- Weather vocabulary in the A2.1 radio forecast uses Hamburg/München in Arabic script (هامبورغ، ميونخ) inside translations; German place names in German examples untouched.
- wortschatz: the deck has 31 station words (no umbrella), so it doesn't simply mirror the 32 suchbild spots; check welcher/welche/welches and dieser/diese/dieses glosses «أيّ (مذكر / مؤنث وجمع / محايد)», «هذا / هذه».
- Month names: both names on first mention (A2.1: يوليو (تموز)، سبتمبر (أيلول)، أكتوبر (تشرين الأول)، ديسمبر (كانون الأول)، مايو (أيار)، أغسطس (آب)، نوفمبر (تشرين الثاني)). Note: the month helper script missed a month directly followed by «،»; fixed by hand in mauer grammar[1].fact.
- geschenke listen.intro and ulm listen.intro describe a bathroom / station picture (the English does too); probably a mismatch in the source, not in the translation.

## tool/turkish/ar/a2_2 (A2.2 app + book)

- New terms: Passiv = «المبني للمجهول» (compared with «تُصلَّح السيارة»); Relativsatz = «جملة الصلة», relative pronoun = «ضمير الوصل» (compared with الذي/التي/الذين and the Arabic عائد: «الرجل الذي أعرفه»); Konjunktiv II könnte/sollte = «بالإمكان / ينبغي»; Superlativ = «صيغة التفضيل العليا» (الأسرع، الأكبر); Wechselpräpositionen = «حروف الجر ذات الاتجاهين» (compared with «في» vs «إلى»); reflexive verbs compared with Arabic افتعل/تفعّل (اغتسل، التقى، تذكّر); Wortbildung compared with Arabic patterns (سائق، «غير»، «قابل لـ»); dass ≈ «أنّ», ob ≈ «هل / إن كان», als ≈ «لمّا».
- grammatikwoerter: German grammar terms mapped to Arabic ones (اسم، فعل، صفة، حرف جر، الرفع، النصب، Genitiv = «حالة الملكية»). The intro now says Arabic grammar works the same way (اسم وفعل وحرف، رفع ونصب وجر). Dativ is still described rather than equated with الجر.
- Templates without person agreement again: koennte_sollte «{subject}: بالإمكان الذهاب إلى السينما (اقتراح).»; adjektiv_intro «أمامي {a} {subject}.», «عندي {a} {subject}.», «أرى {a} {subject}.», and «أين {subject}؟ (المعروف)» for the definite "Where is the {subject}?", because the subject list is indefinite (طاولة جديدة). Please check the last one.
- English-only traps rewritten for Arabic speakers: Hose is singular like «بنطال»; TeKaMoLo: Arabic word order is flexible, German fixes time–manner–place; verb prepositions: «ينتظر» has no preposition but warten auf; wenn vs als ≈ «إذا» vs «لمّا».
- Book: brauerei (beer brewery, Oktoberfest beer, casino in kur) is translated as is. Flag in case the Arabic edition wants softer content there.
- Speaker labels in reading.en in Arabic (الشرطي/الشرطية، البائعة، الطبيبة، السيدة، الرجل، المدينة، المدير); names kept (Frau Huber → «السيدة Huber», Herr Vogt → «السيد Vogt»).
- Oktoberfest is written «الـ Oktoberfest», not «مهرجان أكتوبر», so the month script does not treat it as a month.
- A bug in the month helper (a month before «،» was skipped) is fixed in the copy used for A2.2. A date inside brackets is written «(12 مارس / آذار)» to avoid nested brackets.
- Book matching exercises (krimi practise[3].right) have Arabic right-hand meanings; check the printed key.

## tool/turkish/ar/dictionary (tap-a-word, 1868 glosses)

- Verbs are glossed in the present 3rd person («يذهب»). Modal verbs are glossed as «يستطيع، يجب عليه، يريد، ينبغي عليه، يُسمح له». Pronoun glosses use Arabic attached pronouns («ـني (نصب)», «لي (Dativ)»).
- Case labels: Akkusativ = «نصب», Dativ kept as «Dativ», Genitiv = «حالة الملكية (Genitiv)». The German hints «(+ Dativ)» and «(+ Genitiv)» are kept, and «(+ accusative)» is written «(+ نصب)».
- Month names carry both forms («مارس (آذار)»). Letters are written «حرف A». Personal names are written «Anna، اسم شخصي». Cities and countries are in Arabic script.
- To check: Gott → «الله؛ إله»; prost → «في صحتك!»; Bier → «جعة (بيرة)»; Gesundheit! → «يرحمك الله!» (the natural Arabic reply to a sneeze).

## Batch A (2026-11-26): A1–A2 gaps closed (32 reading/listening exercises, flags, 192 glosses)

- New files: the 8 hoeren/lesen exercises per level in a1_1, a1_2, a2_1, a2_2. Speaker genders follow the German passage (Ärztin → «الطبيبة», Reporterin → «المراسلة», Verkäuferin, Apothekerin, Touristin, Hörerin, Vermieterin), not the gender-neutral English.
- Numbers inside Arabic text follow the German notation (4,20; 2.500; 1,3 km), not the English 4.20 / 2,500. Check that this reads naturally.
- Place names: well-known cities and all countries in Arabic script (هامبورغ، برلين، ميونخ، فيينا، زيورخ، جنيف، باريس، موسكو); smaller towns stay Latin (Konstanz, Freiburg, Münster, Kassel, Bamberg, Nürnberg, Köln…). Rivers/streets stay Latin (Elbe, Spree, Weberstraße).
- Month names: both forms on first mention per file and again on first mention in passageTranslation (as decided 2026-11-11).
- lesen_bier / lesen_tracht: Oktoberfest is written «مهرجان أكتوبر (Oktoberfest)» / «مهرجان أكتوبر», unlike the A2.2 book («الـ Oktoberfest»). The month helper was not run on it; the phrase is left without a month bracket on purpose.
- lesen_bier: Hopfen = «حشيشة الدينار» (also known as «الجنجل»); a native speaker may prefer one. Beer texts (lesen_bier, lesen_adler «برميلان من البيرة», hoeren_cafe) translated as is.
- hoeren_buchstabieren: German letter sounds written in Arabic letters: E «إيه»، I «إي»، A «آ»، V «فاو»، W «ڤيه»، Z «تسيت»، J «يوت». The English "the opposite of English" was dropped.
- Arabic comparisons added where the English compared with English: 89 = neunundachtzig like «تسعة وثمانون» (lesen_hamburg); surnames from jobs like الحداد والنجار والخياط (lesen_mueller); compound head last vs Arabic إضافة head first (lesen_mueller); accusative pronouns like attached object pronouns (hoeren_geburtstag); helfen + Dativ vs «ساعدني» (hoeren_weg); seit vs vor where Arabic says «منذ» for both (lesen_dom); -er als like «أفعل من» (lesen_wetter); Passiv like «يُصنَع» (lesen_bier); relative der/die/das like الذي/التي (lesen_grimm); die Hose singular like «بنطال» (lesen_tracht); weil does not move the verb in Arabic «لأن» (lesen_wohnen).
- lesen_grimm: tale names «هانسل وغريتل»، «ذات الرداء الأحمر» (also «ليلى والذئب»)، «بياض الثلج»، «سندريلا».
- hoeren_werbinich: the song title is translated with the German in brackets: «ما زالت لي حقيبة في برلين (Ich hab noch einen Koffer in Berlin)». Frack = «بدلة رسمية بذيل (Frack)».
- hoeren_wohnung: Kaltmiete / Warmmiete explained in brackets inside the passage translation («إيجارًا باردًا (Kaltmiete، دون تكاليف)»).
- Templates added for flags: quest_a1_1_laender englishTemplates["Sprache — Man spricht …"][0] «{subject}: ما اللغة التي يتكلمها الناس هناك؟»; quest_a1_2_possessiv englishTemplates["mein (my, Akk.)"][0] «{subject}: أراه، هو لي.» (no person agreement possible with a bare noun; please check); quest_a2_2_koennte_sollte englishTemplates["sollte (Ratschlag)"][0] «{subject}: ينبغي النوم أكثر (نصيحة).»; zahlen/zahlen2/zahlen3 «Auf Deutsch»[0] = «{subject}».
- wortschatz flags (a1_1, a1_2, a2_1, a2_2 cards[i].note / .example) and book/woche grammar[1].check.items[3]: the values are German (participles, example sentences, «der siebte»), copied unchanged.
- Flag left on purpose: a1_1 book/steckbrief reading.en "looks English": the Arabic is complete; the English it sees is Herr Ziegler's quoted «The cat is on the table.» and the name Mimi.
- Dictionary: 192 glosses added (verbs in the «يذهب» style). dict-build reports 2059, not 2060: Gäste|noun is in en and ar part-02 but no longer in the shared dictionary, so it is dropped as stale (the Turkish build still carries it from before).
- Leftovers (14 in all) are German passages/questions and mixed Arabic+German lines, not English, except the SOURCE line on lesen_anzeigen below.
- SOURCE: quest_a2_2_hoeren_wohnung help.tips[1].examples[1].en: the English "The landlady will call you at home by phone this evening" drops the reason "wegen der Wohnung" and adds "by phone"; the German (heute Abend wegen der Wohnung zu Hause) is a te-ka-mo-lo example, so the English should keep all four parts. Translated from the German.
- SOURCE: quest_a1_2_lesen_anzeigen help.tips[2].examples[0].de: the German field contains English ("650 Euro pro Monat — not 60 (m²), not 2 (Zimmer)"); it should read "nicht 60 (m²), nicht 2 (Zimmer)" or the note belongs in .en. leftovers.mjs reports it.
- SOURCE: quest_a1_2_lesen_brot help.intro says the Brötchen "has ten names"; the text names four (Schrippe, Semmel, Rundstück, Weckle). Translated as written.

## B1–C2 button layer (2026-11-26)

### b1_1

#### Arabic B1.1 button layer (batch b1_1)

Doubts:

- quest_b1_1_futur, `help.tips[0].visual.rows[0..1].en`: the English source values are German ("ein Versprechen", "eine Vorhersage"); copied as German per the "whole value is German" rule. If these are meant as glosses, Arabic would be «وعد» / «توقّع».
- quest_b1_1_relativ, `help.tips[0].visual.rows[0..1].en`: same situation ("der: Subjekt von wohnt", "den: Objekt von gesehen"), copied as German.
- quest_b1_1_diktat_konjunktiv, `help.tips[0].en.text`: the English sound hints ("ä like 'bed'", "ü = 'ee' with rounded lips") rewritten for Arabic: ä = between fatha and kasra, like e in Bett; ü = «ي» with rounded lips.
- English-comparison traps rewritten with Arabic comparisons (doubt: check they read naturally): adj_komparativ mistakes[0] (أكثر + مصدر vs -er), futur trap (سـ/سوف), konjunktionen hook/intro (عندما covers als and wenn), relativ trap (الذي/التي change by gender, not case), relativ_praep trap + intro (Arabic keeps the preposition in the صلة with a resumptive pronoun), verben_praep trap (يفكر في / يخاف من / يهتم بـ) and tips[3] (da- ≈ attached pronoun به/عنه), sprechen_bitten trap, indirekte_fragen trap, falls_da_trotzdem trap[1] (da ≠ "there", rewritten as Ich bin da), genitiv trap (possessor after, like الإضافة), infinitiv_zu intro (أنْ + الفعل).
- quest_b1_1_email_redemittel, `help.tips[3].examples[0]`: the English gives only "Could you let me know?"; the German has a formal and an informal version, so both are translated, from the German.
- Number format: "1.2 million", "1,200 euros", "900,000", "600,000" written the German way (1,2 مليون، 1.200 يورو، 900.000، 600.000) as in the German text; the check accepted it.
- quest_b1_1_wortschatz: glosses reused from the level's other quizzes; cards with no single-word source gloss (Chef/Chefin split, Liebe/Lieber, welcher/welche/welches, deshalb/deswegen, Komparativ adjectives) taken from the paired entry in the source quiz.
- quest_b1_1_hoeren_elternzeit: hook says fathers "mostly take only two months", intro says "on average three months". Checked against the German listening text: both are right (most take the two partner months; the average is three). Not a source error.

SOURCE lines: none.

### b1_2

#### Arabic B1.2 button layer (batch b1_2)

Doubts:

- Arrows (all files): the guide says keep `→`, but in an RTL paragraph a `→` between two Arabic words, or between Arabic and German, points backwards. Rule used: `→` kept where both neighbours are German (bleiben → blieb, weil → deshalb), `←` where a neighbour is Arabic (الفاعل نفسه ← um … zu). Earlier Arabic levels mix the two. Check in the app with the real `dir`.
- `visual.*.en` whose English source value is German: quest_b1_2_praet_misch `help.tips[0].visual.rows[0..3]` (bringen, denken, kennen, wissen) copied as German. quest_b1_2_partizip_adj_intro `help.tips[2].visual.items[0..1]` ("das kochende Wasser (passiert gerade)", "das gekochte Ei (fertig)") and quest_b1_2_zustandspassiv `help.tips[1].visual.items[0..1]` ("passiert gerade (Handlung)", "ist zu (Zustand)") given as Arabic glosses (الماء الذي يغلي (يحدث الآن)، البيضة المسلوقة (جاهزة)، يحدث الآن (فعل)، مغلق (حالة)) because they sit under a German example as its meaning. quest_b1_2_passiv_praet `help.tips[1].visual.rows[0..1]` keep the German labels with an Arabic note: «Präteritum (schreiben، أي للكتابة): …». Check which reading the app expects.
- quest_b1_2_partizip_adj_intro `help.introEn`: "the English line tells you whether the meaning is active … or done" rendered as «سطر الترجمة». In Arabic mode the `sentences[].english` cue lines are not in the button layer, so they probably stay English (leftovers.mjs lists them). Same for every "English line / cue" mention.
- English-comparison traps rewritten with Arabic comparisons (check they read naturally): bigtext_ritter trap (كان ← كانوا, the verb changes for plural too); sprechen_geschichte trap (Arabic uses one past for everything); passiv_modal_intro trap (يُصلح is one word, German needs two at the end); indem_sodass trap (بالطبخ / بأن أطبخ); modalpartikeln_intro (doch ≈ «بلى» added to the text, check and mistakes); konnektoren_zweiteilig trap (كلما … كلما does not move the verb); plusquamperfekt trap and irreale_wuensche trap (كان قد / ليتني كنت with every verb vs war/hatte, wäre/hätte); trotz_wegen trap (Arabic shows the case with a vowel, German with des + -s); n_deklination trap (Arabic case vowels are not written, so "dem Student" can feel complete); relativ_dat trap (dessen/deren decided by the possessor, like the Arabic resumptive pronoun الذي سيارته / التي أطفالها); damit_umzu trap + tips[3] (لكي covers both; test for a new person after لكي/حتى); infinitiv trap (Arabic purpose with لـ alone vs German um); passiv trap (Arabic passive by vowel change vs werden); zustandspassiv trap + intro (Arabic already separates يُغلق / مغلق); temporalsaetze tips[1] (Arabic says منذ أن سكنتُ in the past), tips[2] (als ≈ لمّا, wenn ≈ عندما/كلما/إذا); partizip_adj_intro tips[3] title + intro (Partizip I ≈ اسم الفاعل, Partizip II ≈ اسم المفعول); passiv_praet intro (وُلد is passive in Arabic too); praet_unreg intro (internal vowel change is familiar from Arabic); suchbild_park tips[1] (final -e ≈ التاء المربوطة, "roughly"); suchbild_garage tips[1] (-er tools ≈ اسم الآلة); wortbildung intro (suffix ≈ Arabic word pattern); wortschatz tips[0] (plurals learnt per noun like جمع التكسير); hoeren_zug tips[0] (ليتني / لو … لـ).
- quest_b1_2_technik: the English-loanword discussion is kept (the German words really come from English, and most readers know them), with Arabic meanings added; das Handy note says «تبدو الكلمة إنجليزية لكنها ليست كذلك»; WLAN pronunciation given as «ڤي-لان»; tips[3] "the English download/upload is the same pair" → «تنزيل / رفع».
- quest_b1_2_wortbildung `sentences[1].whyEn`: "you 'meet' a decision" explained as eine Entscheidung treffen (treffen = يلتقي) «أي تتخذه».
- Examples whose English source holds two German sentences joined by "—" (praet_reg tips[2].examples[0], trotz_wegen tips[3].examples[1], infinitiv tips[3].examples[0..1], passiv_modal_intro tips[3].examples[0], partizip_adj_intro tips[2].examples): dash replaced by a full stop (no long dashes in prose); "(spoken)/(written)/(CV)" labels from the German added in brackets in praet_reg.
- passiv tips[2].examples: Arabic avoids «من قِبل» in active-sounding prose, so the example is translated actively with a literal passive in brackets (حرفيا: تُكتب الرسالة من قِبل السكرتيرة) to keep the von-point visible.
- Month names written both ways («آب/أغسطس»، «تشرين الأول/أكتوبر»، «أيار/مايو») so Levantine/Iraqi and Egyptian/Gulf readers both recognise them.
- "the B1 exam" kept as «امتحان B1» (no brand name, same amount of exam talk as the English).
- quest_b1_2_wortschatz: 250 glosses reused automatically from the same German word in this level's other quizzes; the rest written in the same style (verbs in the present «يحفظ», Präteritum forms as Arabic past «ذهب»). Three wortschatz glosses differ from their source quiz on purpose: cards[27]/[28] without "(gehen)/(kommen)" because the English card has none, cards[175] with "(den Praktikanten)" as in the English card.
- Flag left by the check: praet_unreg `help.tips[1].en.text` "looks English", a false positive (it is a list of German verb pairs with Arabic separators).

SOURCE lines: none.

### b2_1

#### Arabic B2.1 button layer (batch b2_1)

Doubts:

- English comparisons rewritten for Arabic readers (please check they read naturally):
  - quest_b2_1_brauchen_zu, `help.tips[1].en.text` and `help.introEn`: "must not" vs "don't have to" becomes «يجب ألا» (ban) vs «لا يجب عليك» / «لا يلزمك» (no obligation).
  - quest_b2_1_passiv_perfekt, `help.tips[0].en.trap`: the English "been twice" angle dropped; kept "sein once, worden once, never geworden".
  - quest_b2_1_je_desto, `help.tips[1].en.trap` and quest_b2_1_konnektoren, `help.tips[0].en.trap`: English word order comparison dropped; the rule stated directly.
  - quest_b2_1_passiv_subjektlos, `help.tips[0].en.trap` and `help.introEn`: compared with the Arabic impersonal passive («لا يُدخَّن هنا»، «احتُفل بالفائزين»، الجار والمجرور نائب فاعل).
  - quest_b2_1_zustandspassiv, `help.tips[0].en.trap` and `help.introEn`: «يُفتح المحل» (Vorgang) vs «المحل مفتوح» (Zustand); Arabic makes the same split.
  - quest_b2_1_dass_infinitiv, `help.tips[0].en.trap`: Arabic «أرجو أن أنجح / أن تنجح» works with أنْ for both subjects; German does not.
  - quest_b2_1_infinitivsaetze, `help.tips[0].en.trap`: «لكي» works for both subjects in Arabic.
  - quest_b2_1_temporal_nominal, `help.tips[0].en.trap`: vor/bevor compared with «قبل» / «قبل أن»; `help.tips[1].en.text`: the subject as possessive compared with «وصوله».
  - quest_b2_1_kausal_nominal, `help.tips[1].en.trap`: «بسببِ المطرِ» + إضافة; `help.tips[2].en.text`: aus ≈ المفعول لأجله («خوفا»)، vor ≈ «من شدة».
  - quest_b2_1_adjektive_praep / quest_b2_1_nomen_praep / quest_b2_1_verben_praep, traps: "don't translate the preposition" now about Arabic prepositions (مهتم بـ، فخور بـ، مسؤول عن، يعتمد على).
  - quest_b2_1_indirekt_fragen, `help.tips[0].en.trap`: rewritten without English tense backshift.
  - quest_b2_1_konj1 (`help.tips[0].en.trap`, `help.introEn`) and quest_b2_1_konj1_vergangenheit (`help.tips[0].en.trap`): Arabic has no reported-speech mood («قال إنّ» + normal tense); German marks it in the verb. Added «وزعم الوزير أن…» as the journalistic-distance example.
  - quest_b2_1_lassen, `help.tips[0].en.trap`: Arabic «صلّحت سيارتي» is said even when the mechanic did it; German needs lassen.
  - quest_b2_1_mittelfeld, `help.tips[0].en.trap`: Arabic tends to put time at the end; German puts it first. intro: «أعطيته إياه» for es ihm.
  - quest_b2_1_partizip_adj, `help.tips[4]` (title, text, check, examples): "-end = -ing, ge- = -ed" becomes Partizip I ≈ اسم الفاعل, Partizip II ≈ اسم المفعول (kochend «يغلي»، gekocht «مغلي»).
  - quest_b2_1_nachsilben_genus, `help.tips[1].en.trap`: added that das Mädchen being neutral is odd for Arabic speakers (البنت مؤنثة); intro compares suffixes with التاء المربوطة.
  - quest_b2_1_gesellschaft, `help.tips[1].en.trap`: die Stimme = voice and vote "as in Arabic" (صوت).
  - quest_b2_1_stellungnahme, `help.tips[1].en.trap`: added a warning against translating «في رأيي أنّ…» literally.
- Dialogue turn dashes (" – ") removed inside Arabic translations of dialogues, as in b1_1 (passiv_perfekt `help.context.en`, mittelfeld `help.tips[1].examples[0].en`, sprechen_kurzcheck `help.tips[2].examples[1].en`, verben_praep `help.tips[2].examples[0..1].en`). Dashes between German labels (Te – Ka – Mo – Lo, Einleitung – Pro – …, Bezug – Standpunkt – …) kept, since they are German.
- quest_b2_1_mittelfeld, `help.tips[0].en.text`: "wann → warum → wie → wo/wohin" is German in the English source and stays German.
- quest_b2_1_bigtext_presse, `help.tips[0].examples[0].en` and `help.tips[2].examples[0].en`: the German has "Die Ministerin"; translated from the German as «الوزيرة» (English says only "the minister").
- quest_b2_1_brauchen_zu, `help.context.en`: the letter addresses Frau Kaya, so feminine address (تحتاجين) is used there; elsewhere masculine singular.
- Names in Arabic prose transliterated as in b1_1 (السيدة كايا، السيدة ألبرس، السيدة كيلر، السيد براندت، فيلدهايم، بونتيفيدرا); names inside German quotes untouched.
- Numbers written the German way as in b1_1 (6,7 مليون طن، 289.000).
- quest_b2_1_konnektoren, `help.tips[2].visual.points[0..2].en`: the English source holds English glosses here (not German), so they are translated.
- quest_b2_1_wortschatz: glosses reused from the level's other quizzes by matching the German word. Split where the source quiz had a combined entry (Bürger / Bürgerin, Befürworter / Gegner, Sprecher / Sprecherin, womit / worauf / wovon, mit wem / auf wen, wohin / woher, steigend / sinkend, öffnen / geöffnet etc., aus Angst / Neugier). Cards without a source gloss written new: the bare verbs, adjectives and nouns with "(preposition)" (cards 94–105, 117–131, 142–156), geworden (319), the Redemittel labels (386–395) and dafür spricht (419).

SOURCE lines: none.

### b2_2

#### Arabic B2.2 button layer (batch b2_2)

Arrows: `→` kept everywhere as in the English (per the brief); no `←` written.

Doubts:

- quest_b2_2_nominalisierung_intro `help.tips[3].visual.rows[0..3]` and quest_b2_2_wortschatz `help.tips[0].visual.rows[1]`: the English source value is German ("der Infinitiv: immer das", "-ion: die" …), copied unchanged.
- quest_b2_2_adjektivbildung `help.tips[1].visual.rows[0..1]` ("can be eaten", "thrifty", no German shown by de-context): glossed in Arabic (صالح للأكل، مقتصد).
- quest_b2_2_nominalisierung_intro `help.tips[3].examples[1].en`: the English "one noun of each gender pair" does not translate the German line (der Lehrer (der) · das Gerede (das) · die Prüfung (die)); translated the English as written («اسم واحد من كل جنس»).
- English-comparison traps rewritten with Arabic comparisons (check they read naturally): als_ob trap + intro (كأنّ does not change the verb); irreal trap + tips[3] + intro (لو vs إنْ); konj2_gegenwart intro (لو + كان vs Konjunktiv on the verb); konj2_verg trap («كان سيذهب»); futur1_vermutung trap («لا بد أنه / لعله»); futur2 trap («يكون قد فاته», helper first in Arabic); fvg trap («اتخذ قرارا» tempts nehmen; «طرح سؤالا» ≈ stellen); konzessiv trap (Arabic «رغم أن … إلا أن» doubles the concession, German must not); indefinit trap (واحد/واحدة show gender only); konditional_nominal trap (Arabic case vowels unwritten, so the learner drops the dative ending); partizip_attribut trap (Arabic adjective always after the noun); relativ_dessen_deren tips[0] + trap + tips[3] + intro (resumptive pronoun الذي زوجته / التي كلبها; Arabic puts the preposition at the end: التي نشأت فيها); relativ_wer_was trap («مَن» does not decline); verweiswoerter trap + check (بذلك is one word like damit); modalpartikeln trap (adverb meanings given in Arabic) and tips[2].check (doch ≈ بلى); umwelt tips[1].trap (dropped "not protektieren", which only works for English) and tips[3].check («اتخذ إجراءات»).
- quest_b2_2_modalpartikeln: eben/halt rendered with «ببساطة»; the intro compares the particles to spoken fillers «يعني» «طيب» «هيا» (colloquial on purpose, as an analogy). Check the tone.
- quest_b2_2_hoeren_hitze `help.vocab[3]` Kreislauf ("circulation"): glossed as the body's circulation (الدورة الدموية), which fits a heat talk.
- `help.examEn` everywhere: "the B2 exam" rendered «امتحان مستوى B2», no brand.

SOURCE:

- SOURCE: quest_b2_2_sprechen_kurzcheck `help.tips[0].examples[0].en`: English "People should have been informed in time." vs German "Man hätte die Bürger rechtzeitig informieren müssen" (müssen = had to; and the German is active, "the citizens"). Translated from the German («كان يجب إبلاغ المواطنين في الوقت المناسب»).
- SOURCE: quest_b2_2_diktat_irreal `help.tips[2].examples[0].en`: English "I would have known it long ago" vs German "wüsste ich sie längst" (present Konjunktiv: "I would know it by now"). Translated from the German.

### c1_1

#### Arabic B1–C2 button layer: c1_1 (42 files)

#### Doubts

- quest_c1_1_bigtext_hinweise · help.introEn: "The hints give you the verb or the English meaning" rendered as «التلميحات تعطيك الفعل أو معناه» (no "English"), since in Arabic mode the hint may or may not be in English. Check what the hint shows in ar mode.
- quest_c1_1_tempuswahl · help.tips[1].en.trap: the English "I saw / I have seen" comparison replaced with Arabic (Arabic has one past form, رأيتُ, so look for no Präteritum/Perfekt match in it). Same content otherwise.
- quest_c1_1_passiversatz · help.tips[1].en.trap: "English has this as its normal passive" replaced with the Arabic equivalent (أُعطي الكتابَ: the recipient becomes نائب الفاعل). tips[2].en.text: added one short clause comparing the reflexive middle with Arabic المطاوعة (انفتح الباب).
- quest_c1_1_attribute · help.tips[0].en.trap: "English has no case to match" replaced with: like the Arabic بدل, which follows the case of what it explains.
- quest_c1_1_adjektive_praep_kasus · help.tips[0].en.trap: "English uses 'of'" replaced with "Arabic uses a preposition here (واعٍ بـ، جدير بـ)".
- quest_c1_1_funktionsverbgefuege · help.mistakes[3]: "English make a decision" → «بالعربية «يتخذ قرارا»». quest_c1_1_wortschatz · help.tips[0].en.text: added the same Arabic parallel (اتخذ قرارا، لا فعل قرارا).
- quest_c1_1_bildung · sentences[4].whyEn: "you ZIEHT (draw) it, like in English" → like Arabic «يستخلص النتيجة».
- Several sentences[i].whyEn have no Arabic left once "dative/accusative" become the German terms (e.g. adjektive_praep_kasus sentences[5] "behilflich + Dativ: mir.", bildung sentences[3] "die Auswertung: auswerten + -ung."). The English long dashes in them became «:». Kept that way on purpose; build reports 0 flags.
- Terms used: Partizipialsatz = «جملة اسم الفاعل أو المفعول»; Funktionsverbgefüge = «التركيب الفعلي الاسمي» (German term kept beside it); Gerundivum, Konjunktiv I/II, Präteritum, Perfekt, Plusquamperfekt, Futur II left in German; Apposition = «البدل»; Attribut = «التابع»; Nominalisierung = «التحويل إلى اسم / الاسم المشتق من الفعل».
- quest_c1_1_wortschatz · cards[279] Leiter (head) and cards[382] Leiter (ladder): same German, two meanings; glossed separately («رئيس، مدير» / «سلّم»).

#### SOURCE

- SOURCE: several examples translate only one side of a German "A → B" pair, so the English has no arrow while the German does (e.g. quest_c1_1_sprechen_kurzcheck help.tips[0].examples[0], quest_c1_1_nominalisierung help.tips[0].examples[0..1] and tips[3].examples[0], quest_c1_1_verbalisierung help.tips[0].examples[0], tips[1].examples[0], tips[2].examples[0], tips[3].examples[0], quest_c1_1_partizipialattribute help.tips[0..3].examples). Translated as the English stands (arrow counts kept). Fine if intended; otherwise the English should carry both halves.
- SOURCE: quest_c1_1_wortschatz cards[169] and cards[170] are both "Gesandte" = "envoy" (probably der/die Gesandte, but the two cards look identical). Both glossed «مبعوث».
- SOURCE: quest_c1_1_wortschatz cards[159] indes = "meanwhile", cards[160] indessen = "however": both words carry both meanings (see quest_c1_1_konjunktionaladverbien vocab[5] "meanwhile; however"). Translated as given.
- SOURCE: quest_c1_1_lesen_saetze_einordnen help.tips[1].examples[0]: the German starts with the gap number "[5]", the English drops it. Minor; translated the English.

### c1_2

#### Arabic C1.2 button layer (batch c1_2)

Arrows: `→` and `↔` kept everywhere as in the English (per the brief); no `←` written. Names transliterated as in b2_1/b2_2 (هارتمان، ألبرس، آنا بيتروفا …).

Doubts:

- quest_c1_2_wortschatz `cards[34]` (banal): the English gloss happens to be spelled like the German word; treated as an English gloss and rendered «تافه، مبتذل» (same as quest_c1_2_hoeren_tagebuecher `help.vocab[12]`), not copied.
- quest_c1_2_wortschatz `cards[146]` (Umschlag): the deck gloss "turnover; envelope" follows lesen_anglizismen («تداول؛ ظرف، غلاف»), not hoeren_uebersetzerin where the same word means a book cover («غلاف (الكتاب)»).
- quest_c1_2_lesen_experten `help.introEn`: genders taken from the German authoring text (Vogt = Kulturökonomin «خبيرة»، Aydin = Museumsdirektor «مدير»، Sölle = Kulturjournalistin «صحفية»).
- quest_c1_2_register_formell `help.context.en` and `help.tips[0/1/3].examples`: the informal chat side is rendered in casual but plain MSA («هل ترسل التقرير؟ لا يعجبني … هذا لا يصح»), no dialect, so the register contrast is weaker than in German. Check it still reads as "chat".
- quest_c1_2_modalpartikeln `help.introEn`: "English uses tone, tags or words like just, really…" rewritten for Arabic with MSA words «أصلا»، «إذن»، «فعلا»، «يا ترى» (no colloquial fillers this time, unlike b2_2).
- quest_c1_2_sprechen_ironie `help.tips[0].examples[1]`: "You're early, aren't you." → «أتيت مبكرا جدا، أليس كذلك؟»; irony depends on tone in Arabic too.
- English-comparison passages rewritten with Arabic comparisons (check they read naturally): konj2_kritik trap («كان ينبغي أن»: Arabic also uses two verbs, but German puts sollen last); numerus_gender trap (Arabic «الأثاث» singular vs die Möbel plural, «الأمتعة» plural vs das Gepäck singular; English "informations/advices" angle dropped); suchbild_flughafen tips[1] and suchbild_redaktion rememberEn[2] (نظارة / مقص are singular in Arabic too); relativ_advanced tips[0].trap (Arabic resumptive pronoun «الذي … بمساعدته» vs mit dessen Hilfe) and tips[1].en.text («وهو ما»); lesen_bauhaus tips[1].en.text (added one sentence comparing «الذي لا يزال كرسيه» with dessen); lesen_literatur tips[0].en.text (added: compare Arabic الحال «جلست مبتسمة»); modal_vermutung tips[3].en.text (added: Arabic separates «يجب أن» / «لا بد أن»); wortbildung_nach tips[2].en.text (added Arabic root families علم، عالِم، علمي); wortbildung_vor tips[0].en.text (added: Arabic verbs that take the object directly); redewendungen tips[1].trap + sentences[8]/[11] (Arabic shares «يصب الزيت على النار»، «يغض الطرف»); konjunktiv1 intro (added: Arabic needs «قال إن», German the verb form); schreiben_nominalstil intro (Arabic masdar style «بسبب نقص المستندات»); register_formell intro (likened to colloquial vs formal Arabic); wortschatz tips[0] («اتخذ قرارا» not «أخذ قرارا»).
- quest_c1_2_lesen_anglizismen `help.hookEn`: "what a download has in common with a window" kept as Download / Fenster (German words) so the pun on loanwords stays visible.
- quest_c1_2_kohaesion `help.tips[2].en.trap`: "English tolerates repeating the noun" softened to a general statement (no English comparison).
- `sentences[i].whyEn` in kultur, redemittel_vortrag, register_formell, schreiben_nominalstil, umformung_1: "+ genitive/accusative" rendered «+ حالة Genitiv / Akkusativ».
- `help.examEn` everywhere: "the C1 exam" rendered «امتحان مستوى C1», no brand.
- Dashes: the only dash left is inside German in redemittel_vortrag `help.rememberEn[0]` ("zunächst–anschließend–abschließend", copied as in the source). Dash-separated English sequences (titles like "open – structure – transition – close", lesen_kolumne rememberEn[0], forum_beschwerde tips[3]) became «،» lists.

SOURCE:

- SOURCE: quest_c1_2_diktat_idiom `help.tips[1].examples[1].en`: English "The residents probably ought to have been involved earlier" is passive; the German "Man hätte die Anwohner wohl früher einbeziehen müssen" is active with man and müssen ("one should have involved"). Translated from the German («كان ينبغي على الأرجح إشراك السكان في وقت أبكر»).
- SOURCE: quest_c1_2_hoeren_hoerspiel `help.tips[2].check.whyEn`: says "als hätte … introduces an image of how she looks", but the tip's own example is "als müsse er …" about the old man. Probably refers to the check sentence; translated as written.
- SOURCE: quest_c1_2_modal_hoerensagen `help.tips[3].examples[0..1].en`: the English gives only the first half of the German pair ("Der Minister soll zurückgetreten sein. = Es heißt, der Minister sei zurückgetreten."); translated the English half only. Same pattern in quest_c1_2_modal_vermutung `help.tips[3].examples` (German labels Fähigkeit / Möglichkeit / Pflicht / Schlussfolgerung not in the English).
- SOURCE: quest_c1_2_sprechen_kurzcheck `help.tips[1].en.text` quotes 'Man sagt, sie hat gewonnen' (indicative) while the tip's German example is "Man sagt, sie habe gewonnen" (Konjunktiv I). German left exactly as in the English.

### c2_1

#### Arabic B1–C2 button layer: c2_1

#### Doubts

- Several files (bigtext_vorstand `help.introEn`, konnektoren_nuancen `help.introEn`, sprichwoerter `help.introEn`, praefixe_semantik `help.introEn`): the English says the gap cue "gives the English" meaning. The cues are not in the button layer, so they presumably stay English in Arabic mode; I kept «المعنى بالإنجليزية». If the cues are ever shown in Arabic, these four lines need «بالعربية».
- abtoenung, konj2_nuancen, komparation_advanced `help.introEn`: "the English cue" written as «التلميح» without naming the language.
- register, schreiben_register, sprechen_kurzcheck, sprechen_dialog: the colloquial German examples (kriegen, Kohle, halt, salopp gesagt) are rendered in plain, informal-sounding MSA, not dialect (e.g. «الرجل غاضب لأن عمله ضاع»، «يلقي نظرة» for checken, «مال (لفظ عامي)» for Kohle). The register contrast is therefore weaker in Arabic than in English; the German carries it.
- Whys that are only German + a grammar word (valenz `sentences[*]`, kollokationen `sentences[1]`, `[10]`, praefixe_semantik `sentences[10]`, `[18]`, adjektivbildung `sentences[15]`) stay German with the German term (Genitiv, Dativ, Akkusativ), as in c1_1.
- komposita `help.tips[3].en.text`: the English has `←` arrows (Gericht ← Verfassung(s) ← Bund(es)); I copied them unchanged, since they are in the source. Check how the RTL arrow flip treats `←`.
- Added short Arabic comparisons where they help: idafa head-first vs German head-last (komposita tip 0), كاد / ليت / لولا for Konjunktiv II (konj2_nuancen), «أجاب عن السؤال / أجاب السؤالَ» for be- (praefixe_semantik tip 2), Arabic balagha terms (stilmittel), «اتهمه بـ» and transitive قابل / ناقض vs German Dativ (valenz tips 1–2), Arabic proverb equivalents (sprichwoerter: حبل الكذب قصير، من حفر حفرة لأخيه وقع فيها، الطبع يغلب التطبع، التعلم في الصغر كالنقش على الحجر …).
- sprichwoerter `help.vocab[*]` and wortschatz cards 234–240: Arabic equivalent proverbs, not literal translations; the literal image is in `sentences[*].whyEn`.
- wortschatz: glosses reused from this level's quizzes; homonym fixed: card 12 Vergleich = «تسوية (قانونية)» (law), not «تشبيه» (stilmittel). Split cards given their own glosses: keineswegs / mitnichten, einigermaßen / leidlich, indes / indessen, Euphemismus / Dysphemismus.
- praefixe_semantik `help.tips[0].visual.rows[1]` "give away" is verschenken (checked in the authoring file): «يهب، يعطي مجانا».

#### SOURCE

- SOURCE: komposita `help.tips[0].examples[0].en`: the English ("the station bookshop = the bookshop at the station") drops the second half of the German ("der Buchhandlungsbahnhof wäre ein Bahnhof"). Arabic follows the German in full.
- SOURCE: wirtschaft `help.tips[3].examples[0].en`: English "turnover, profit, return" while the German is "Umsatz 10 Mio., Gewinn 1 Mio., Rendite 5 %." Arabic follows the German (with figures).
- SOURCE: komposita `help.tips[3].examples[0..1].en`: English gives only the compound's meaning, the German adds "= der Beitrag zur Versicherung der Arbeitslosen" / "= das Verfahren zur Zulassung an der Hochschule". Arabic follows the English (no `=`), to keep the counts equal.
- SOURCE: lesen_kurzgeschichte `help.tips[2].check.whyEn`: "leaving the coat where it was" — the story's object is the blue cup, not a coat. Probably refers to the check question; translated as written. Worth checking the check.
- SOURCE: stilmittel `help.tips[3].examples[0].en`: English drops the quoted question („Wer von uns hat nicht schon einmal eine Frist versäumt?“); Arabic includes it from the German.
- SOURCE: lesen_champions `help.hookEn` says 1,500 Hidden Champions in Germany; the intro says "almost half" of about 3,400 (≈1,700). Translated as written.

### c2_2

#### Arabic C2.2 button layer (batch c2_2)

Arrows: `→`, `↔` and the one `←` (quest_c2_2_nominalstil `help.introEn`, "after the arrow (←)") kept exactly as in the English; no `←` added anywhere else. Dashes left only inside German (quotations, rememberEn lines, "WIEN – MONTREAL", "ihr – mir – raffinier- – Tier") and year ranges (1883–1934). `+ genitive/dative/accusative` in why lines rendered with the German term (+ Genitiv / Dativ / Akkusativ). "the C2 exam" rendered «امتحان مستوى C2», no brand.

Doubts:

- quest_c2_2_wortschatz: 333 of 368 card glosses copied from the same German word + same English gloss in this level's other exercises (vocab/spots), so the homonym pairs follow their own card: Steuer (tax «ضريبة» / helm «مقود، دفة»), See (sea «بحر» / lake «بحيرة»), Verdienst (merit «فضل، استحقاق» / earnings «أجر، دخل»), Kiefer (jaw «فك» / pine «صنوبر»), Tor (fool «أحمق (أدبي)» cards[80] / gate «بوابة» cards[366]). The rest (selbst/sogar, gerade/genau/eben, nur/bloß/lediglich, the academic phrases, Zumutbarkeit, Gemeinwohl, Verhältnismäßigkeit, Maßstab) reuse the glosses of fokus / wissenschaftssprache / schreiben_eroerterung by hand. cards[257–259] and [275–277] have paraphrase German in de-context ("keinen Erfolg haben", "vorzeitig aufgeben", "heimlich etwas planen", "von vornherein", "bestehende Zustand", "Voraussetzung eines Schlusses"): glossed from the English.
- quest_c2_2_fokus: English "even / only" explanations rewritten around Arabic «حتى» / «فقط» / «لم … إلا» / «بالذات»; tips[3].en.text adds the Arabic fronted object «الأولَ رفضتُ» as a comparison. visual.rows[1] "THAT I didn't say" (caps for stress) → «هذا بالذات لم أقله».
- quest_c2_2_passiv_meisterschaft `help.tips[0].en.trap`: "English 'the door was closed' is ambiguous" replaced by the Arabic contrast «أُغلق الباب» / «كان الباب مغلقا»; tips[2].en.text adds Arabic impersonal passive «سُهر حتى الصباح».
- quest_c2_2_appositionen `help.tips[0].en.trap`: "English shows no case" replaced by "Arabic البدل also copies the i'rab, German shows it on the article"; intro adds «كما في العربية». hookEn's English example "with Mr Roth, the new mayor" rendered in Arabic.
- quest_c2_2_lesen_fremdwort: intro likens Apposition to Arabic البدل; tips[1].en.text adds one sentence «والعربية عرفت الجدل نفسه بين «الهاتف» و«التلفون»» (التلفون is a quoted loanword, not used as prose). Remove if it reads as colloquial.
- quest_c2_2_fremdwoerter `help.tips[3]` (false friends with English: eventuell/eventually, sensibel/sensible, prägnant/pregnant…): kept as a warning about look-alikes "in other European languages like English and French", with the wrong meanings given in Arabic, since many Arab learners also know English/French. Check whether to drop the English angle entirely.
- quest_c2_2_redewendungen: "throw the baby out with the bathwater" rendered literally once in tips[2].examples[0] with an explanation («أي يتخلص من الجيد مع الرديء»), elsewhere as «يرمي الجيد مع الرديء»; Bärendienst explained with the Arabic proverb of the bear («كالدبة التي قتلت صاحبها»). mistakes[0] "the English bathwater does not carry over" → «الصورة لا تُنقل كلمة بكلمة».
- quest_c2_2_wortspiel: the puns cannot survive in Arabic; examples/context translated for meaning, with the German word added where the pun is the point (tips[1].examples[1] «(Gericht = محكمة وطبق)», tips[4].examples keep Zug / Steuer). tips[1].en.text adds Arabic «عين»; tips[3].en.text adds «ضرب موسى عيسى» as the classic Arabic subject/object ambiguity.
- quest_c2_2_dach_varianten `help.tips[3].en.text`: adds one clause comparing standard vs dialect with فصحى vs العامية.
- quest_c2_2_lesen_reform tips[0].en.text, quest_c2_2_nominalstil tips[0].en.text / tips[4].en.text: added a short comparison with the Arabic masdar style («بعد انقضاء المهلة»).
- quest_c2_2_anspielung: tips[1].en.text adds «ليس بالهيّن» as Arabic litotes; tips[3].en.text likens the rhetorical question to الاستفهام الإنكاري.
- quest_c2_2_hoeren_dolmetscher intro: added one sentence that verb-first Arabic does the opposite of the German verb-final bracket; tips[1].en.text adds Arabic equivalents «لا بد أنه نسي / يُقال إنه قال / يزعم أنه».
- quest_c2_2_lesen_amtliches_schreiben `help.rememberEn[0]`: written «1 أسبوع» / «2 أسبوع» to keep the English digits; reads a bit stiff (natural: «أسبوع واحد» / «أسبوعين»). Other digits in prose kept as Western numerals (القرن الـ 12، الموضع 1).
- quest_c2_2_behoerdensprache `help.context.en`: "Mr Ruiz" transliterated «السيد رويث» (Spanish z); names elsewhere transliterated (زولّه، برغر، فيبر، كلاين، برغ) or kept in Latin where the English lists them as names in a German frame (Söll, Kaya, Weber in hoeren_capstone).
- quest_c2_2_sprechen_kurzcheck / sprechen_dialog: 'Ende' and ‘Los geht’s’ kept in their English quote marks.

SOURCE:

- SOURCE: quest_c2_2_suchbild_antiquitaeten `help.tips[1].en.text`: "Two clocks, two different last parts: die Standuhr and die Sanduhr both end in die Uhr" contradicts itself (same last part). Translated as «ساعتان: die Standuhr وdie Sanduhr تنتهيان كلتاهما بـ die Uhr». Should read "Two clocks, the same last part" or similar.
- SOURCE: quest_c2_2_hoeren_lesung `help.tips[1].check.whyEn` speaks of "the lamp" and `help.tips[2].check.whyEn` of "das Meer", neither of which is in the suitcase story the tip describes; presumably about the check sentences (not in the file). Translated as written.
- SOURCE: quest_c2_2_hoeren_capstone `help.tips[1].check.whyEn` ("her support only holds if residents take part") does not match the panel on AI and jobs; probably about the check sentence. Translated as written.
- Note (not a source error): quest_c2_2_nominalstil `help.tips[4].examples[0].en` paraphrases a German triple-genitive chain; the Arabic adds «(بثلاث إضافات متتالية)» so the point stays visible.

### Fixed in the source on 2026-11-26 (all languages)

- a2_2 hoeren_wohnung example (kept "about the flat"), a1_2 lesen_anzeigen German field (nicht 60 … nicht 2), a1_2 lesen_brot intro (no "ten names"), b2_2 sprechen_kurzcheck and diktat_irreal examples (follow the German), c2_2 suchbild_antiquitaeten ("one last part"). The check whys flagged in c1_2/c2_1/c2_2 refer to the check sentence and are right. B1.2: the hand-turned arrows were set back; the app now turns arrows in Arabic text itself (bidi.ts turnArrows).

