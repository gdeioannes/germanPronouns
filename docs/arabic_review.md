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
