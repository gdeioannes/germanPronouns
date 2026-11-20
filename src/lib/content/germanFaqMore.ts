// German FAQ, second batch: 24 more questions. Same shape and rules as the
// first twelve in germanFaq.ts (plain answer first, then the full
// explanation, `*word*` = German). Merged into GERMAN_FAQ there.
import type { FaqEntry } from './germanFaq';

export const MORE_FAQ: FaqEntry[] = [
	// -- Spelling and sounds ------------------------------------------------
	{
		slug: 'how-to-pronounce-german-ch',
		question: 'How do you pronounce the German "ch"?',
		short:
			'German ch has two sounds. After a, o, u and au it is the throaty sound of Scottish "loch": *Bach, Buch, auch*. Everywhere else it is softer, like the h in "huge" said with more breath: *ich, Milch, Mädchen*. And chs sounds like ks: *sechs*.',
		group: 'sounds',
		body: [
			{
				p: [
					'The vowel in front decides which of the two sounds you use. Neither of them is “k” or “sh”, the sounds English speakers usually reach for.'
				]
			},
			{
				h: 'The two sounds',
				table: {
					head: ['After', 'Sound', 'Examples'],
					rows: [
						['*a, o, u, au*', 'back of the mouth, like Scottish “loch”', '*Bach, Nacht, Buch, doch, auch*'],
						['*e, i, ä, ö, ü, ei, eu*, a consonant', 'front, soft: the “h” of “huge”, with more air', '*ich, recht, Bücher, leicht, Milch, durch*'],
						['the ending *-chen*', 'the soft sound', '*Mädchen, Brötchen*']
					]
				}
			},
			{
				h: 'How to find the soft sound',
				p: [
					'Say “huge” slowly and hold the first sound: *hhhh-uge*. Now whisper it harder, with your tongue close to the roof of your mouth. That hiss is the *ich*-sound. Keep your tongue away from your teeth, or it turns into “sh”.'
				]
			},
			{
				h: 'The exceptions',
				list: [
					'*chs* usually sounds like “ks”: *sechs, Fuchs, wachsen*.',
					'Words borrowed from other languages keep their own sound: *Chef* (sh), *Chor* (k).',
					'*-ig* at the end of a word is said like *ich* in standard German: *zwanzig, wichtig*. In the south many people say “-ik”, and both are understood.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_alphabet', label: 'The alphabet and spelling' },
			{ quiz: 'quest_a1_1_zahlen3', label: 'Numbers 20–100 (zwanzig, dreißig, achtzig)' },
			{ quiz: 'quest_a1_1_sprechen_zahlen', label: 'Speaking: numbers and prices' },
			{ quiz: 'quest_a1_1_hoeren_buchstabieren', label: 'Listening: spelling out words' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'ich, mich, dich, doch, auch: tap any word to hear it.' },
			{ href: '{course}/level/A1.1', label: 'Level A1.1', note: 'the first sounds, numbers and greetings, every sentence spoken.' }
		],
		related: ['how-to-pronounce-the-german-r', 'how-to-pronounce-german-umlauts', 'why-is-w-pronounced-v-in-german']
	},
	{
		slug: 'how-to-pronounce-the-german-r',
		question: 'How do you pronounce the German R?',
		short:
			'At the start of a syllable, standard German says R at the back of the throat, like a soft gargle: *rot, Reise*. After a vowel it mostly turns into a short "uh": *der, Bier, Wasser*. A rolled tongue-tip R, as in Bavaria and Austria, is correct too.',
		group: 'sounds',
		body: [
			{
				p: [
					'German has two R sounds, and the more common one is not a gargle at all.'
				]
			},
			{
				h: 'R before a vowel: in the throat',
				p: [
					'In *rot, Rad, Brot, fahren* the R is made where the back of your tongue meets the soft palate, the same place as *ch* in *Bach*. The trick: say *ach*, then add your voice to it. That buzzing version is very close to the German R. Keep it short and light; nobody wants the full gargle.'
				]
			},
			{
				h: 'R after a vowel: almost a vowel',
				p: ['At the end of a word or syllable, the R mostly melts into a short, open “uh”. The ending *-er* sounds close to the “a” in “sofa”.'],
				examples: [
					{ de: 'der, mir, Bier, Uhr', en: 'said roughly “dea, mia, bia, ua”' },
					{ de: 'Wasser, Lehrer, Mutter', en: '-er sounds like a short “a”' }
				]
			},
			{
				h: 'And the rolled R?',
				p: [
					'A rolled R with the tip of the tongue, like in Spanish or Scottish English, is heard in Bavaria, Austria and Switzerland, and on the classical stage. It is perfectly correct German. What does not work is the English R: it makes *rot* sound foreign straight away.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_sprechen_vorstellung', label: 'Speaking: introducing yourself' },
			{ quiz: 'quest_a1_1_alphabet', label: 'The alphabet and spelling' },
			{ quiz: 'quest_a1_2_sprechen_alltag', label: 'Speaking: everyday life and time' },
			{ quiz: 'quest_a1_1_hoeren_buchstabieren', label: 'Listening: spelling out words' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'every noun has a recording: listen to the R in Brot, Rad, Uhr.' },
			{ href: '{course}/level/A1.1', label: 'Level A1.1', note: 'listen-and-repeat drills from the very first lesson.' }
		],
		related: ['how-to-pronounce-german-ch', 'how-to-pronounce-german-umlauts', 'ei-or-ie-in-german']
	},
	{
		slug: 'why-is-w-pronounced-v-in-german',
		question: 'Why is W pronounced like V in German (and V like F)?',
		short:
			'German letters keep one sound each, and some differ from English: w sounds like English v (*Wasser*), v mostly like f (*Vater, viel*), z like ts (*Zeit*), j like y (*ja*). S before a vowel sounds like z (*Sonne*), and sp, st at the start sound like shp, sht (*Sport, Straße*).',
		group: 'sounds',
		body: [
			{
				p: [
					'Once you know which sound each letter makes, German spelling is far more regular than English. A letter nearly always says the same thing, so you can read a new word aloud correctly the first time.'
				]
			},
			{
				h: 'The letters that surprise English speakers',
				table: {
					head: ['Letter', 'Sounds like', 'Examples'],
					rows: [
						['*w*', 'English v', '*Wasser, wie, Wien*'],
						['*v*', 'f (in German words)', '*Vater, viel, vier*'],
						['*z*', 'ts', '*Zeit, Zug, zehn*'],
						['*j*', 'English y', '*ja, Jahr, jung*'],
						['*s* before a vowel', 'English z', '*Sonne, sagen, Rose*'],
						['*sp, st* at the start', 'shp, sht', '*Sport, spielen, Straße, Stadt*'],
						['*sch*', 'sh', '*Schule, schön*']
					]
				}
			},
			{
				h: 'Why they differ',
				p: [
					'Both languages use the Latin alphabet, but each attached its own sounds to it. German *w* once said “w”, like English. Over the centuries the sound moved to “v”, and the spelling stayed. The *v* in old German words like *Vater* and *viel* has said “f” for a very long time. In borrowed words it keeps the “v”: *Vase, Klavier, Video*.'
				]
			},
			{
				h: 'A sentence to practise',
				examples: [{ de: 'Wie viel Wasser will Werner?', en: 'How much water does Werner want? (four v-sounds and an f)' }]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_alphabet', label: 'The alphabet and spelling' },
			{ quiz: 'quest_a1_1_hoeren_buchstabieren', label: 'Listening: A wie Anton' },
			{ quiz: 'quest_a1_1_diktat_steckbrief', label: 'Dictation: a profile' },
			{ quiz: 'quest_a1_1_zahlen', label: 'Numbers 0–10 (vier, zwei, zehn)' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'wie, wo, wer, was, warum: tap to hear each one.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'a falling-blocks word game: say the words to yourself as you pair them.' }
		],
		related: ['ei-or-ie-in-german', 'how-to-pronounce-german-ch', 'what-is-the-german-ss-eszett']
	},
	{
		slug: 'ei-or-ie-in-german',
		question: 'How do you pronounce ei and ie in German?',
		short:
			'Say the second letter as English says it: ei sounds like the English letter I ("eye"), as in *mein, Wein, drei*, and ie like the English letter E ("ee"), as in *Wien, Liebe, Bier*. So *Wein* is wine and *Wien* is Vienna. Eu and äu sound like "oy": *neu, Häuser*.',
		group: 'sounds',
		body: [
			{
				p: ['These two are easy to mix up, and *Wein* (wine) and *Wien* (Vienna) is the classic mistake. One rule sorts them every time.']
			},
			{
				h: 'Say the second letter',
				p: [
					'Look at the second letter of the pair and say its English name. In *ei* the second letter is *i*, which English calls “eye”: *Wein* is “vine”. In *ie* it is *e*, which English calls “ee”: *Wien* is “veen”.'
				],
				examples: [
					{ de: 'Wein / Wien', en: 'wine / Vienna' },
					{ de: 'Bein / Biene', en: 'leg / bee' },
					{ de: 'Leid / Lied', en: 'sorrow / song' }
				]
			},
			{
				h: 'The other pairs',
				table: {
					head: ['Letters', 'Sound', 'Examples'],
					rows: [
						['*ei* (also *ai*)', '“eye”', '*mein, drei, Mai*'],
						['*ie*', '“ee”', '*vier, Liebe, Bier*'],
						['*eu, äu*', '“oy”', '*neu, Freund, Häuser*'],
						['*au*', '“ow”, as in “how”', '*Haus, Frau, auch*']
					]
				}
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_zahlen', label: 'Numbers 0–10 (drei, vier, neun)' },
			{ quiz: 'quest_a1_1_alphabet', label: 'The alphabet and spelling' },
			{ quiz: 'quest_a1_1_diktat_steckbrief', label: 'Dictation: a profile' },
			{ quiz: 'quest_a1_1_laender', label: 'Countries, languages, nationalities' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'hear Wein, Biene, Freund and hundreds more, each with its article.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'match falling German words to their English.' }
		],
		related: ['why-is-w-pronounced-v-in-german', 'how-to-pronounce-german-umlauts', 'why-do-germans-say-numbers-backwards']
	},

	// -- Nouns, genders and cases -------------------------------------------
	{
		slug: 'how-do-german-plurals-work',
		question: 'How do German plurals work?',
		short:
			'German has five plural patterns: -e (*Tag, Tage*), -er often with umlaut (*Kind, Kinder; Haus, Häuser*), -n or -en (*Frau, Frauen*), -s (*Auto, Autos*), and no ending (*Lehrer, Lehrer*), sometimes with umlaut (*Apfel, Äpfel*). The plural article is always *die*.',
		group: 'nouns',
		body: [
			{
				p: [
					'There are five patterns, and the good part is that the article never changes: every plural is *die*. Here are the five, and the hints that tell you which one a noun probably takes.'
				]
			},
			{
				h: 'The five patterns',
				table: {
					head: ['Pattern', 'Examples', 'Typical for'],
					rows: [
						['*-e* (often with umlaut)', '*der Tag, die Tage; der Stuhl, die Stühle*', 'short masculine nouns'],
						['*-er* (umlaut if possible)', '*das Kind, die Kinder; das Haus, die Häuser*', 'short neuter nouns'],
						['*-n / -en*', '*die Frau, die Frauen; die Lampe, die Lampen*', 'almost all feminine nouns'],
						['*-s*', '*das Auto, die Autos; das Handy, die Handys*', 'words from English and French, words ending in a vowel other than -e'],
						['no ending (sometimes umlaut)', '*der Lehrer, die Lehrer; der Apfel, die Äpfel*', 'masculine and neuter nouns in -er, -el, -en, and -chen, -lein']
					]
				}
			},
			{
				h: 'One extra -n in the dative',
				p: [
					'In the dative plural, add *-n* if the plural does not already end in *-n* or *-s*: *mit den Kindern, in den Häusern*, but *mit den Autos*.'
				]
			},
			{
				h: 'How to learn them',
				p: [
					'The hints above are tendencies, not laws, so learn each noun as a set of three: *der Tisch, die Tische*. It is one extra syllable per word, and it saves you from guessing for the rest of your German life.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_plural', label: 'Plural of nouns' },
			{ quiz: 'quest_a1_1_artikel', label: 'Articles in the nominative' },
			{ quiz: 'quest_a1_1_wortschatz', label: 'Flashcards: A1.1 words' },
			{ quiz: 'quest_a2_1_dativ_artikel', label: 'Dative articles (mit den Kindern)' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'every noun with its article and its plural, sorted by theme.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'name the article of each falling word.' }
		],
		related: ['der-die-das-how-to-know', 'how-to-pronounce-german-umlauts', 'what-are-the-four-german-cases']
	},
	{
		slug: 'german-adjective-endings-explained',
		question: 'Why do German adjective endings change?',
		short:
			'An adjective before a noun takes an ending that shows gender, case and number, unless the article already shows it. After der, die, das the ending is just -e or -en (*der alte Mann, den alten Mann*). After ein, or with no article, the adjective shows more (*ein alter Mann, kalter Kaffee*).',
		group: 'nouns',
		body: [
			{
				p: [
					'There is one idea behind every ending: something in front of the noun has to show its gender and case. If the article does it, the adjective relaxes. If the article does not, the adjective does the job.'
				]
			},
			{
				h: 'No ending at all',
				p: [
					'After the noun, or after *sein, werden, bleiben*, an adjective never changes: *Der Mann ist alt. Die Häuser sind alt.* The endings only appear when the adjective stands in front of a noun.'
				]
			},
			{
				h: 'After der, die, das: -e or -en',
				p: ['The article has already said everything, so the adjective only takes *-e* or *-en*. *-e* appears in five places; everything else is *-en*.'],
				table: {
					head: ['', 'masculine', 'feminine', 'neuter', 'plural'],
					rows: [
						['Nominative', '*der alte Mann*', '*die alte Frau*', '*das alte Haus*', '*die alten Leute*'],
						['Accusative', '*den alten Mann*', '*die alte Frau*', '*das alte Haus*', '*die alten Leute*'],
						['Dative', '*dem alten Mann*', '*der alten Frau*', '*dem alten Haus*', '*den alten Leuten*']
					]
				}
			},
			{
				h: 'After ein, or with no article: the adjective shows it',
				p: [
					'*Ein* looks the same for masculine and neuter, so the adjective adds the missing signal: *ein alter Mann* (the *-er* of *der*), *ein altes Haus* (the *-s* of *das*). With no article at all, the adjective takes the article’s ending itself: *kalter Kaffee, frische Milch, kaltes Wasser*.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a2_2_adjektiv_intro', label: 'Adjectives before a noun: first steps' },
			{ quiz: 'quest_b1_1_adj_bestimmt', label: 'Adjective endings after der, die, das' },
			{ quiz: 'quest_b1_1_adj_unbestimmt', label: 'Adjective endings after ein' },
			{ quiz: 'quest_b1_1_adj_nullartikel', label: 'Adjective endings with no article' },
			{ quiz: 'quest_a2_2_sprechen_person', label: 'Speaking: describing people' }
		],
		more: [
			{ href: '{course}/level/B1.1', label: 'Level B1.1', note: 'the full set of adjective endings, step by step.' },
			{ href: '/books', label: 'The books', note: 'printable B1.1 book with the endings tables and exercises on paper.' }
		],
		related: ['what-are-the-four-german-cases', 'der-die-das-how-to-know', 'is-the-german-genitive-dying']
	},
	{
		slug: 'in-dem-or-in-den-two-way-prepositions',
		question: 'When is it "in dem" and when "in den"? (two-way prepositions)',
		short:
			'Nine prepositions take two cases: *an, auf, hinter, in, neben, über, unter, vor, zwischen*. For a location (Wo?) use the dative: *Das Buch liegt auf dem Tisch*. For a movement to a place (Wohin?) use the accusative: *Ich lege das Buch auf den Tisch*.',
		group: 'nouns',
		body: [
			{
				p: [
					'The noun does not change gender. What changes is the question the sentence answers: where something is, or where something goes.'
				]
			},
			{
				h: 'Wo? or Wohin?',
				table: {
					head: ['Question', 'Case', 'Example'],
					rows: [
						['*Wo?* (where is it?)', 'dative', '*Die Katze schläft auf dem Sofa.*'],
						['*Wohin?* (where to?)', 'accusative', '*Die Katze springt auf das Sofa.*'],
						['*Wo?*', 'dative', '*Wir sind in der Stadt.*'],
						['*Wohin?*', 'accusative', '*Wir fahren in die Stadt.*']
					]
				}
			},
			{
				h: 'The verb pairs that go with it',
				p: ['German has a verb for being somewhere and a different one for putting something there. The first takes the dative, the second the accusative.'],
				examples: [
					{ de: 'liegen / legen', en: 'Das Handy liegt auf dem Tisch. / Ich lege das Handy auf den Tisch.' },
					{ de: 'stehen / stellen', en: 'Die Flasche steht im Kühlschrank. / Ich stelle die Flasche in den Kühlschrank.' },
					{ de: 'sitzen / setzen', en: 'Er sitzt neben mir. / Er setzt sich neben mich.' }
				]
			},
			{
				h: 'The short forms',
				p: [
					'Some combinations merge: *in dem* becomes *im*, *in das* becomes *ins*, *an dem* becomes *am*, *an das* becomes *ans*. So the everyday versions are *im Kino* (in the cinema) and *ins Kino* (to the cinema).'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a2_2_wechsel_wo', label: 'Two-way prepositions: Wo?' },
			{ quiz: 'quest_a2_2_wechsel_wohin', label: 'Two-way prepositions: Wohin?' },
			{ quiz: 'quest_a2_1_woher_wo_wohin', label: 'Woher? Wo? Wohin?' },
			{ quiz: 'quest_a2_2_sprechen_kurzcheck', label: 'Speaking check: wo or wohin?' },
			{ quiz: 'quest_a2_2_bigtext_zimmer', label: 'Long text: my room' }
		],
		more: [
			{ href: '/words/verbs/legen', label: 'legen', note: 'and its partner liegen: every form, with audio.' },
			{ href: '/words/verbs/stellen', label: 'stellen', note: 'and stehen, the “upright” pair.' },
			{ href: '{course}/level/A2.2', label: 'Level A2.2', note: 'where the two-way prepositions are taught.' }
		],
		related: ['what-are-the-four-german-cases', 'what-does-es-gibt-mean', 'der-die-das-how-to-know']
	},
	{
		slug: 'is-the-german-genitive-dying',
		question: 'Is the German genitive dying?',
		short:
			'Not in writing: news, books and official German use it all the time. In everyday speech, though, Germans often swap it for *von* + dative (*das Auto von meinem Bruder* instead of *das Auto meines Bruders*) and say *wegen dem* instead of *wegen des*. Learn to understand it, use it in writing.',
		group: 'nouns',
		body: [
			{
				p: [
					'Keep learning it. The genitive has retired from a lot of everyday conversation, but it still works full-time in newspapers, emails to officials and anything formal.'
				]
			},
			{
				h: 'Spoken and written side by side',
				table: {
					head: ['Everyday speech', 'Writing, formal German', 'Meaning'],
					rows: [
						['*das Auto von meinem Bruder*', '*das Auto meines Bruders*', 'my brother’s car'],
						['*wegen dem Wetter*', '*wegen des Wetters*', 'because of the weather'],
						['*trotz dem Regen*', '*trotz des Regens*', 'despite the rain']
					]
				}
			},
			{
				h: 'The famous joke',
				p: [
					'A bestselling book about German usage was called *Der Dativ ist dem Genitiv sein Tod*: “The dative is the death of the genitive”, written in the very style it mocks. The title became a saying, and the genitive is still here.'
				]
			},
			{
				h: 'The part you need every day',
				p: [
					'With names, the genitive is simple and very much alive: add *-s*, with no apostrophe. *Annas Auto, Peters Wohnung, Deutschlands Hauptstadt.*'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a2_2_genitiv_s_datum', label: 'Genitive -s with names, and dates' },
			{ quiz: 'quest_b1_1_genitiv', label: 'The genitive' },
			{ quiz: 'quest_b1_2_trotz_wegen', label: 'trotz, wegen, während + genitive' },
			{ quiz: 'quest_b2_2_genitiv_praep', label: 'Genitive prepositions (advanced)' }
		],
		more: [
			{ href: '{course}/level/B1.1', label: 'Level B1.1', note: 'the genitive in context, with reading and listening.' },
			{ href: '/literature', label: 'Literature', note: 'Kafka in the original: written German, genitive and all, with notes.' }
		],
		related: ['what-are-the-four-german-cases', 'german-adjective-endings-explained']
	},

	// -- Verbs and tenses ---------------------------------------------------
	{
		slug: 'perfekt-or-praeteritum-german-past-tense',
		question: 'Which German past tense do you use: Perfekt or Präteritum?',
		short:
			'In speech, use the Perfekt for most verbs: *Ich habe gegessen. Ich bin gefahren.* The Präteritum (*ich aß, ich fuhr*) is the tense of books and news, but in speech too for *sein*, *haben* and modal verbs: *Ich war müde. Ich hatte Zeit. Ich musste arbeiten.* Both mean the same.',
		group: 'verbs',
		body: [
			{
				p: [
					'It is not the same as in English. In German both tenses describe the same finished past. What differs is where you use them: one in conversation, one on paper.'
				]
			},
			{
				h: 'Speaking: Perfekt',
				examples: [
					{ de: 'Gestern habe ich Pizza gegessen.', en: 'Yesterday I ate pizza.' },
					{ de: 'Wir sind nach Hamburg gefahren.', en: 'We went to Hamburg.' }
				],
				p: ['Use the Perfekt in conversation, messages and emails to friends, even for things that happened long ago.']
			},
			{
				h: 'The exceptions everyone uses',
				p: ['A handful of very common verbs sound more natural in the Präteritum, even in speech:'],
				examples: [
					{ de: 'Ich war gestern krank.', en: 'I was ill yesterday. (not: ich bin gewesen)' },
					{ de: 'Wir hatten keine Zeit.', en: 'We had no time.' },
					{ de: 'Ich musste lange warten.', en: 'I had to wait for a long time.' },
					{ de: 'Es gab ein Problem.', en: 'There was a problem.' }
				]
			},
			{
				h: 'Writing: Präteritum',
				p: [
					'Novels, fairy tales and news reports tell the past in the Präteritum: *Es war einmal ein König …* You need to recognise these forms early; you need to produce them mostly at B1 and up. In the north of Germany people also say the Präteritum more often than in the south, where the Perfekt rules almost alone.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_perfekt_intro', label: 'Perfekt: first steps' },
			{ quiz: 'quest_a1_2_war_hatte', label: 'war and hatte' },
			{ quiz: 'quest_a2_1_perfekt_haben', label: 'Perfekt with haben' },
			{ quiz: 'quest_a2_1_modal_praeteritum', label: 'Modal verbs in the Präteritum' },
			{ quiz: 'quest_a2_2_praeteritum_intro', label: 'Präteritum: first steps' },
			{ quiz: 'quest_a2_2_lesen_grimm', label: 'Reading: Es war einmal (fairy-tale Präteritum)' }
		],
		more: [
			{ href: '/words/verbs/fahren', label: 'fahren', note: 'every tense on one page: ich fuhr, ich bin gefahren, with audio.' },
			{ href: '/words/verbs', label: 'Verb library', note: 'every verb in the course, each with its full conjugation.' }
		],
		related: ['haben-or-sein-in-the-perfekt', 'german-future-tense-werden', 'why-is-the-verb-at-the-end-in-german']
	},
	{
		slug: 'haben-or-sein-in-the-perfekt',
		question: 'Haben or sein: which do you use in the German Perfekt?',
		short:
			'Most verbs use *haben*. Use *sein* for movement from one place to another (*Ich bin nach Berlin gefahren*), for a change of state (*Ich bin eingeschlafen*), and with *sein*, *bleiben* and *werden* themselves (*Ich bin zu Hause geblieben*).',
		group: 'verbs',
		body: [
			{
				p: [
					'Think of *sein* verbs as the ones where the subject ends up somewhere else, or in a different state, than where it started. Everything else takes *haben*.'
				]
			},
			{
				h: 'The sein verbs',
				table: {
					head: ['Group', 'Examples'],
					rows: [
						['movement from A to B', '*gehen, fahren, fliegen, kommen, laufen, reisen: Ich bin nach Hause gegangen.*'],
						['change of state', '*aufstehen, einschlafen, aufwachen, sterben, wachsen: Er ist um sechs aufgestanden.*'],
						['three special verbs', '*sein, bleiben, werden: Ich bin krank gewesen. Sie ist Ärztin geworden.*'],
						['happening', '*passieren, geschehen: Was ist passiert?*']
					]
				}
			},
			{
				h: 'Everything else: haben',
				p: [
					'Most verbs, and every verb with an accusative object, take *haben*: *Ich habe gegessen, gearbeitet, das Buch gelesen.* Reflexive verbs too: *Ich habe mich gefreut.*'
				]
			},
			{
				h: 'Two details',
				list: [
					'Movement with an object switches back to *haben*: *Ich bin nach Rom gefahren*, but *Ich habe das Auto gefahren.*',
					'In southern Germany, Austria and Switzerland people say *ich bin gesessen, gestanden, gelegen*; in the north it is *ich habe gesessen*. Both are standard.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a2_1_perfekt_sein', label: 'Perfekt with sein' },
			{ quiz: 'quest_a2_1_perfekt_haben', label: 'Perfekt with haben' },
			{ quiz: 'quest_a2_1_diktat_perfekt', label: 'Dictation: in the Perfekt' },
			{ quiz: 'quest_a2_1_sprechen_kurzcheck', label: 'Speaking check: Perfekt' },
			{ quiz: 'quest_a2_1_sprechen_wochenende', label: 'Speaking: my weekend' }
		],
		more: [
			{ href: '/words/verbs/gehen', label: 'gehen', note: 'every form, including ich bin gegangen, with audio.' },
			{ href: '/words/verbs/bleiben', label: 'bleiben', note: 'a sein verb without movement: worth a look.' },
			{ href: '/words/verbs', label: 'Verb library', note: 'each verb page shows whether it takes haben or sein.' }
		],
		related: ['perfekt-or-praeteritum-german-past-tense', 'why-do-german-verbs-split', 'german-reflexive-verbs-sich']
	},
	{
		slug: 'what-is-konjunktiv-2-wuerde-haette-waere',
		question: 'What is the German Konjunktiv II (würde, hätte, wäre)?',
		short:
			'It is the German "would" form, for wishes, polite requests and things that are not real. Most verbs use *würde* + infinitive: *Ich würde gern kommen.* Sein, haben and the modal verbs have their own forms: *wäre, hätte, könnte, müsste*: *Wenn ich Zeit hätte, käme ich mit.*',
		group: 'verbs',
		body: [
			{
				p: [
					'You have used it already if you have ever ordered a coffee in German: *Ich hätte gern einen Kaffee* is Konjunktiv II.'
				]
			},
			{
				h: 'Three jobs',
				table: {
					head: ['Use', 'Example', 'English'],
					rows: [
						['being polite', '*Könnten Sie mir helfen? Ich hätte gern ein Brötchen.*', 'Could you help me? I’d like a roll.'],
						['wishes', '*Ich wäre jetzt gern am Meer.*', 'I wish I were at the seaside now.'],
						['unreal conditions', '*Wenn ich reich wäre, würde ich reisen.*', 'If I were rich, I would travel.']
					]
				}
			},
			{
				h: 'Which form?',
				list: [
					'Most verbs: *würde* + infinitive. *Ich würde das kaufen. Würdest du mitkommen?*',
					'*sein* → *wäre*, *haben* → *hätte*: never *würde sein* or *würde haben* in good German.',
					'Modal verbs: *könnte, müsste, dürfte, sollte, wollte*.',
					'A few common verbs keep their own short forms, especially in writing: *käme, ginge, wüsste, gäbe*.'
				]
			},
			{
				h: 'The past: hätte or wäre + participle',
				examples: [
					{ de: 'Wenn ich das gewusst hätte, wäre ich gekommen.', en: 'If I had known that, I would have come.' },
					{ de: 'Hätte ich doch den früheren Zug genommen!', en: 'If only I had taken the earlier train!' }
				]
			}
		],
		practice: [
			{ quiz: 'quest_b1_1_konj2_wuerde', label: 'Konjunktiv II: würde + infinitive' },
			{ quiz: 'quest_b1_1_konj2_haette', label: 'Konjunktiv II: hätte, wäre, könnte' },
			{ quiz: 'quest_a2_2_koennte_sollte', label: 'Suggestions and advice: könnte, sollte' },
			{ quiz: 'quest_b1_2_irreale_wuensche', label: 'Unreal wishes: Hätte ich doch …!' },
			{ quiz: 'quest_b2_2_konj2_verg', label: 'Konjunktiv II in the past' },
			{ quiz: 'quest_b1_2_hoeren_zug', label: 'Listening: the earlier train' }
		],
		more: [
			{ href: '/words/verbs/haben', label: 'haben', note: 'the verb page shows Konjunktiv II next to every other tense.' },
			{ href: '{course}/level/B1.1', label: 'Level B1.1', note: 'where würde, hätte and wäre are taught in full.' }
		],
		related: ['does-muss-nicht-mean-must-not', 'german-future-tense-werden', 'what-does-bitte-mean']
	},
	{
		slug: 'does-muss-nicht-mean-must-not',
		question: 'Does "ich muss nicht" mean "I must not"?',
		short:
			'No. *Ich muss nicht* means "I don\'t have to". For "must not" German uses *nicht dürfen*: *Hier darfst du nicht rauchen* means "you must not smoke here". Another trap: *ich will* means "I want", not "I will".',
		group: 'verbs',
		body: [
			{
				p: [
					'*Nicht müssen* removes the obligation; it does not forbid anything. To forbid, German uses *nicht dürfen*. So *Du musst morgen nicht kommen* is good news: you can take the day off.'
				]
			},
			{
				h: 'Must, must not, need not',
				table: {
					head: ['German', 'English', 'Example'],
					rows: [
						['*müssen*', 'must, have to', '*Ich muss arbeiten.*'],
						['*nicht müssen*', 'don’t have to', '*Du musst nicht kommen.*'],
						['*nicht dürfen*', 'must not, may not', '*Du darfst hier nicht parken.*'],
						['*nicht brauchen zu*', 'needn’t', '*Du brauchst nicht zu kommen.*']
					]
				}
			},
			{
				h: 'All six modal verbs',
				table: {
					head: ['Verb', 'Meaning', 'Example'],
					rows: [
						['*können*', 'can, be able to', '*Ich kann schwimmen.*'],
						['*müssen*', 'must, have to', '*Ich muss gehen.*'],
						['*dürfen*', 'may, be allowed to', '*Darf ich hier sitzen?*'],
						['*sollen*', 'should, be supposed to', '*Was soll ich machen?*'],
						['*wollen*', 'want to (not “will”)', '*Ich will nach Hause.*'],
						['*mögen / möchten*', 'like / would like', '*Ich möchte einen Tee.*']
					]
				},
				p: ['The other verb goes to the end of the sentence, in the infinitive: *Ich kann heute nicht kommen.*']
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_modalverben', label: 'Modal verbs' },
			{ quiz: 'quest_a2_1_modal_praeteritum', label: 'Modal verbs in the past' },
			{ quiz: 'quest_b2_1_brauchen_zu', label: 'nicht / nur brauchen + zu' },
			{ quiz: 'quest_a1_2_lesen_anzeigen', label: 'Reading: notices and signs' },
			{ quiz: 'quest_c2_2_modalverben_system', label: 'Modal verbs: the whole system (advanced)' }
		],
		more: [
			{ href: '/words/verbs/muessen', label: 'müssen', note: 'every form of müssen, with audio.' },
			{ href: '/words/verbs/duerfen', label: 'dürfen', note: 'and its forms: darf, durfte, dürfte.' },
			{ href: '/words/verbs/wollen', label: 'wollen', note: 'the “want” verb English speakers confuse with “will”.' }
		],
		related: ['german-future-tense-werden', 'what-is-konjunktiv-2-wuerde-haette-waere', 'german-false-friends-bekommen-become']
	},
	{
		slug: 'german-reflexive-verbs-sich',
		question: 'What are German reflexive verbs (sich)?',
		short:
			'A reflexive verb comes with *sich*, a pronoun that points back to the subject: *ich wasche mich, du freust dich, er setzt sich*. Many verbs are reflexive in German but not in English: *sich freuen* (to be glad), *sich erinnern* (to remember), *sich beeilen* (to hurry).',
		group: 'verbs',
		body: [
			{
				p: [
					'*Sich* is part of the verb, the way “oneself” is part of “to enjoy oneself”. German just needs it far more often.'
				]
			},
			{
				h: 'The pronouns',
				table: {
					head: ['', 'accusative', 'example'],
					rows: [
						['*ich*', '*mich*', '*Ich freue mich.*'],
						['*du*', '*dich*', '*Freust du dich?*'],
						['*er, sie, es*', '*sich*', '*Sie freut sich.*'],
						['*wir*', '*uns*', '*Wir freuen uns.*'],
						['*ihr*', '*euch*', '*Freut ihr euch?*'],
						['*sie, Sie*', '*sich*', '*Sie freuen sich.*']
					]
				}
			},
			{
				h: 'Reflexive in German, not in English',
				examples: [
					{ de: 'Ich freue mich auf das Wochenende.', en: 'I’m looking forward to the weekend.' },
					{ de: 'Erinnerst du dich an mich?', en: 'Do you remember me?' },
					{ de: 'Wir müssen uns beeilen.', en: 'We have to hurry.' },
					{ de: 'Setz dich!', en: 'Sit down!' }
				]
			},
			{
				h: 'When there is another object: mir, dir',
				p: [
					'If the sentence already has an accusative object, the reflexive pronoun moves to the dative. Only *ich* and *du* show it: *Ich wasche mich* (I wash), but *Ich wasche mir die Hände* (I wash my hands).'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a2_2_reflexiv', label: 'Reflexive verbs' },
			{ quiz: 'quest_a1_2_pronomen_akk', label: 'Personal pronouns in the accusative' },
			{ quiz: 'quest_a2_1_pronomen_dativ', label: 'Personal pronouns in the dative' },
			{ quiz: 'quest_b1_1_verben_praep', label: 'Verbs with prepositions (sich freuen auf)' }
		],
		more: [
			{ href: '/words/verbs/freuen', label: 'freuen', note: 'sich freuen in every tense, with audio.' },
			{ href: '/words/verbs/waschen', label: 'waschen', note: 'the classic reflexive verb.' },
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'mich, dich, sich, uns, euch: each one explained.' }
		],
		related: ['why-do-germans-say-mir-ist-kalt', 'haben-or-sein-in-the-perfekt', 'what-are-the-four-german-cases']
	},
	{
		slug: 'german-future-tense-werden',
		question: 'How do you talk about the future in German?',
		short:
			'Usually with the present tense and a time word: *Ich fahre morgen nach Berlin.* The future with *werden* (*Ich werde nach Berlin fahren*) exists, but Germans use it mostly for promises, predictions and guesses: *Es wird regnen.* Careful: *ich will* means "I want", not "I will".',
		group: 'verbs',
		body: [
			{
				p: [
					'German does not need a special tense for it when a time word already says “later”.'
				]
			},
			{
				h: 'Most of the time: present + time word',
				examples: [
					{ de: 'Ich komme morgen.', en: 'I’m coming tomorrow. / I’ll come tomorrow.' },
					{ de: 'Nächste Woche fliegen wir nach Rom.', en: 'Next week we’re flying to Rome.' }
				]
			},
			{
				h: 'When werden is the right choice',
				table: {
					head: ['Use', 'Example', 'English'],
					rows: [
						['a promise', '*Ich werde dich anrufen.*', 'I will call you.'],
						['a prediction', '*Morgen wird es regnen.*', 'It will rain tomorrow.'],
						['a guess about now', '*Er wird wohl krank sein.*', 'He’s probably ill.'],
						['no time word to help', '*Ich werde Ärztin.*', 'I’m going to be a doctor.']
					]
				}
			},
			{
				h: 'The will / will trap',
				p: [
					'*Ich will* comes from *wollen* and means “I want”. *Ich will nach Hause* is “I want to go home”, not “I will go home”. The future is *werden*: *Ich werde nach Hause gehen.*'
				]
			}
		],
		practice: [
			{ quiz: 'quest_b1_1_futur', label: 'Futur I' },
			{ quiz: 'quest_b1_1_hoeren_elternzeit', label: 'Listening: I will stay at home' },
			{ quiz: 'quest_b2_2_futur1_vermutung', label: 'Futur I for guesses (advanced)' },
			{ quiz: 'quest_a1_2_wann_praepositionen', label: 'When? Time expressions' },
			{ quiz: 'quest_a1_2_modalverben', label: 'Modal verbs (wollen)' }
		],
		more: [
			{ href: '/words/verbs/werden', label: 'werden', note: 'all its jobs: become, future, passive, with every form.' },
			{ href: '/words/verbs/wollen', label: 'wollen', note: 'the “want” verb that looks like “will”.' }
		],
		related: ['does-muss-nicht-mean-must-not', 'perfekt-or-praeteritum-german-past-tense', 'german-false-friends-bekommen-become']
	},

	// -- Sentences and little words -----------------------------------------
	{
		slug: 'kein-or-nicht-in-german',
		question: 'What is the difference between kein and nicht?',
		short:
			'Use *kein* to say "no" or "not a" before a noun with *ein* or with no article: *Ich habe kein Auto. Ich trinke keinen Kaffee.* Use *nicht* for everything else: verbs, adjectives, and nouns with *der, die, das* or a name: *Ich komme nicht. Das ist nicht teuer.*',
		group: 'sentences',
		body: [
			{
				p: ['One question sorts them: would the positive sentence have *ein* or no article in front of the noun? Then it is *kein*. Otherwise, *nicht*.']
			},
			{
				h: 'kein: instead of ein, or no article',
				examples: [
					{ de: 'Ich habe ein Auto. → Ich habe kein Auto.', en: 'I don’t have a car.' },
					{ de: 'Ich trinke Kaffee. → Ich trinke keinen Kaffee.', en: 'I don’t drink coffee.' },
					{ de: 'Wir haben Zeit. → Wir haben keine Zeit.', en: 'We have no time.' }
				],
				p: ['*Kein* takes the same endings as *ein*: *keinen Kaffee, keine Zeit, mit keinem Wort*.']
			},
			{
				h: 'nicht: everything else',
				examples: [
					{ de: 'Ich komme heute nicht.', en: 'I’m not coming today.' },
					{ de: 'Das Essen ist nicht teuer.', en: 'The food isn’t expensive.' },
					{ de: 'Das ist nicht der Bus nach Köln.', en: 'That isn’t the bus to Cologne.' }
				]
			},
			{
				h: 'Where nicht goes',
				p: [
					'By default *nicht* goes near the end, after the objects: *Ich kenne den Mann nicht.* It moves in front of the part it negates when that part is an adjective, a place or a second verb: *Ich bin nicht müde. Er wohnt nicht in Berlin. Ich kann nicht schwimmen.*'
				]
			},
			{
				h: 'And doch',
				p: ['To answer “yes” to a negative question, Germans say *doch*: *Kommst du nicht mit? – Doch!* (Yes, I am!)']
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_negation', label: 'Negation: kein and nicht' },
			{ quiz: 'quest_a1_2_akkusativ', label: 'Accusative articles (keinen)' },
			{ quiz: 'quest_a1_2_satzbau', label: 'Word order: position 2' },
			{ quiz: 'quest_a1_2_lesen_sonntag', label: 'Reading: Sonntag ist Sonntag' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'kein, nicht, doch, nichts, niemand: each with examples.' },
			{ href: '/play/schreib-mir', label: 'Schreib mir!', note: 'a chat game: say no politely in German, built from word tiles.' }
		],
		related: ['what-do-doch-ja-mal-mean-in-german', 'why-is-the-verb-at-the-end-in-german', 'what-are-the-four-german-cases']
	},
	{
		slug: 'wenn-wann-als-difference',
		question: 'What is the difference between wenn, wann and als?',
		short:
			'*Wann* asks "when?": *Wann kommst du?* *Wenn* means "if", or "when(ever)" for the present, future and repeated events: *Wenn es regnet, bleibe ich zu Hause.* *Als* is "when" for one event or period in the past: *Als ich ein Kind war, …*',
		group: 'sentences',
		body: [
			{
				p: ['Two questions sort them, asked in this order.']
			},
			{
				h: 'The flowchart',
				list: [
					'Is it a question, direct or indirect? → *wann*. *Wann fährt der Zug? Weißt du, wann der Zug fährt?*',
					'Is it one event or one period in the past? → *als*. *Als ich in Berlin ankam, regnete es.*',
					'Everything else (if, whenever, when in the future) → *wenn*. *Wenn ich in Berlin bin, besuche ich dich.*'
				]
			},
			{
				h: 'Side by side',
				table: {
					head: ['German', 'Meaning', 'Example'],
					rows: [
						['*wann*', 'when? (question)', '*Wann hast du Geburtstag?*'],
						['*wenn*', 'if', '*Wenn du Zeit hast, komm vorbei.*'],
						['*wenn*', 'whenever (repeated, also past)', '*Immer wenn ich Oma besuchte, gab es Kuchen.*'],
						['*als*', 'when (once, past)', '*Als ich 18 war, zog ich nach Wien.*']
					]
				}
			},
			{
				h: 'Remember the word order',
				p: [
					'*Wenn* and *als* start a clause that sends the verb to the end: *…, wenn ich Zeit habe.* And *als* has another job you already know: “than”. *Er ist größer als ich.*'
				]
			}
		],
		practice: [
			{ quiz: 'quest_b1_1_konjunktionen', label: 'Clauses with wenn, als, obwohl' },
			{ quiz: 'quest_a2_2_wenn_deshalb', label: 'wenn and deshalb' },
			{ quiz: 'quest_a1_1_wfragen', label: 'W-questions (wann, wo, wer)' },
			{ quiz: 'quest_a2_2_indirekte_fragen', label: 'Indirect questions: ob and W-words' },
			{ quiz: 'quest_b1_2_temporalsaetze', label: 'Time clauses: nachdem, bevor, während' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'wenn, wann, als, ob, dass: the joining words, with examples.' },
			{ href: '{course}/level/B1.1', label: 'Level B1.1', note: 'where wenn and als are taught side by side.' }
		],
		related: ['why-is-the-verb-at-the-end-in-german', 'kein-or-nicht-in-german', 'what-do-doch-ja-mal-mean-in-german']
	},
	{
		slug: 'what-does-es-gibt-mean',
		question: 'What does "es gibt" mean in German?',
		short:
			'*Es gibt* means "there is" or "there are", for one thing or many, and is followed by the accusative: *Es gibt einen Park hier. Es gibt viele Cafés.* For where something is, Germans often prefer a position verb: *Auf dem Tisch liegt ein Buch.*',
		group: 'sentences',
		body: [
			{
				p: [
					'*Es gibt* is a fixed phrase. Nobody is giving anything, the same way English “there is” does not point at any place called “there”.'
				]
			},
			{
				h: 'How it works',
				list: [
					'It never changes for plural: *Es gibt ein Problem. Es gibt zwei Probleme.*',
					'What follows is in the accusative: *Es gibt einen Supermarkt in der Nähe.*',
					'In the past: *Es gab* (there was, there were). *Früher gab es hier ein Kino.*'
				]
			},
			{
				h: 'Everyday phrases with geben',
				table: {
					head: ['German', 'English'],
					rows: [
						['*Was gibt’s?*', 'What’s up?'],
						['*Was gibt es zum Essen?*', 'What’s for dinner?'],
						['*Das gibt’s doch nicht!*', 'I don’t believe it!'],
						['*Gibt es hier WLAN?*', 'Is there Wi-Fi here?']
					]
				}
			},
			{
				h: 'When to use liegen, stehen, hängen instead',
				p: [
					'For something in a particular spot, German likes to say how it is there: *Auf dem Tisch liegt ein Buch. In der Ecke steht ein Schrank. An der Wand hängt ein Bild.* *Es gibt* is for existence in general: *In Hamburg gibt es viele Brücken.*'
				]
			}
		],
		practice: [
			{ quiz: 'quest_b1_1_es', label: 'es-expressions: es gibt, es geht, es lohnt sich' },
			{ quiz: 'quest_a1_2_akkusativ', label: 'Accusative articles' },
			{ quiz: 'quest_a2_2_wechsel_wo', label: 'Two-way prepositions: Wo?' },
			{ quiz: 'quest_a1_1_suchbild_wohnzimmer', label: 'Picture hunt: the living room' }
		],
		more: [
			{ href: '/words/verbs/geben', label: 'geben', note: 'gibt, gab, hat gegeben: every form with audio.' },
			{ href: '/words/verbs/liegen', label: 'liegen', note: 'the verb Germans use for where things lie.' }
		],
		related: ['in-dem-or-in-den-two-way-prepositions', 'what-are-the-four-german-cases', 'kein-or-nicht-in-german']
	},
	{
		slug: 'what-do-doch-ja-mal-mean-in-german',
		question: 'What do doch, ja and mal mean in German?',
		short:
			'They are flavouring particles: they change the tone of a sentence, not its facts. *Mal* softens a request (*Komm mal her*), *doch* adds encouragement or contradiction (*Komm doch mit! Das ist doch klar*), and *ja* marks something obvious or surprising (*Das ist ja toll!*).',
		group: 'sentences',
		body: [
			{
				p: [
					'They do what your tone of voice does in English. Leave them out and the sentence is correct, but it can sound blunt or cold. Put them in and you sound natural.'
				]
			},
			{
				h: 'The most common ones',
				table: {
					head: ['Particle', 'What it adds', 'Example'],
					rows: [
						['*mal*', 'makes a request casual', '*Kannst du mal kommen?* (Can you come for a sec?)'],
						['*doch*', 'urging, or “come on, you know”', '*Komm doch mit! Das weißt du doch!*'],
						['*ja*', '“as we both know”, or surprise', '*Das ist ja super! Du bist ja schon da!*'],
						['*denn*', 'makes a question friendlier', '*Was machst du denn hier?*'],
						['*eigentlich*', '“by the way”, “actually”', '*Wie heißt du eigentlich?*']
					]
				}
			},
			{
				h: 'Doch as an answer',
				p: [
					'On its own, *doch* is a “yes” that contradicts a negative: *Du hast keine Zeit, oder? – Doch!* (Yes, I do!). English needs a whole sentence for that; German needs one word.'
				]
			},
			{
				h: 'How to start using them',
				p: [
					'Begin with *mal* in requests and *denn* in questions. They are safe, frequent and instantly make you sound friendlier: *Sag mal, wo wohnst du denn?*'
				]
			}
		],
		practice: [
			{ quiz: 'quest_b1_2_modalpartikeln_intro', label: 'Modal particles: denn, doch, eigentlich, ja, mal' },
			{ quiz: 'quest_a1_2_imperativ', label: 'The imperative (Komm mal!)' },
			{ quiz: 'quest_b2_2_modalpartikeln', label: 'Modal particles (B2)' },
			{ quiz: 'quest_c1_2_modalpartikeln', label: 'Modal particles (C1)' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'doch, ja, mal, denn, eigentlich: every particle with examples.' },
			{ href: '/play/schreib-mir', label: 'Schreib mir!', note: 'a chat game full of natural, particle-rich German.' }
		],
		related: ['kein-or-nicht-in-german', 'what-does-bitte-mean', 'du-or-sie-in-german']
	},

	// -- Everyday German ----------------------------------------------------
	{
		slug: 'halb-drei-telling-time-in-german',
		question: 'Why does "halb drei" mean 2:30 in German?',
		short:
			'Because German counts the half hour towards the next hour: *halb drei* is "half to three", 2:30. *Viertel nach drei* is 3:15 and *Viertel vor drei* 2:45. Timetables and official times use the 24-hour clock: 14:30 is *vierzehn Uhr dreißig*.',
		group: 'everyday',
		body: [
			{
				p: [
					'English counts the half hour from the last hour (“half past two”); German counts it towards the next one (“half on the way to three”). It is the easiest way to arrive an hour late in Germany.'
				]
			},
			{
				h: 'Everyday time',
				table: {
					head: ['Time', 'German', 'Word for word'],
					rows: [
						['2:30', '*halb drei*', 'half three (half on the way to three)'],
						['3:15', '*Viertel nach drei*', 'quarter after three'],
						['2:45', '*Viertel vor drei*', 'quarter before three'],
						['2:25', '*fünf vor halb drei*', 'five before half three'],
						['2:35', '*fünf nach halb drei*', 'five after half three']
					]
				}
			},
			{
				h: 'Official time: the 24-hour clock',
				p: [
					'Trains, shops, appointments and the radio use the 24-hour clock, read as hours plus minutes: *14:30* is *vierzehn Uhr dreißig*, *9:05* is *neun Uhr fünf*. If in doubt, say this one: nobody can misunderstand it.'
				]
			},
			{
				h: 'A regional bonus',
				p: [
					'In parts of eastern and southern Germany you may hear *Viertel vier* for 3:15 and *drei viertel vier* for 3:45: a quarter, or three quarters, of the way to four. If someone says it, check the number on your phone.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_uhrzeit', label: 'Telling the time' },
			{ quiz: 'quest_a1_2_hoeren_termine', label: 'Listening: appointments and times' },
			{ quiz: 'quest_a1_2_hoeren_bahnhof', label: 'Listening: a station announcement' },
			{ quiz: 'quest_a1_2_sprechen_alltag', label: 'Speaking: everyday life and time' },
			{ quiz: 'quest_a1_2_hoeren_baecker', label: 'Listening: getting up at three' }
		],
		more: [
			{ href: '{course}/level/A1.2', label: 'Level A1.2', note: 'time, days and months, with listening practice.' },
			{ href: '{course}/worksheet', label: 'Printable sheets', note: 'print exercises to practise on paper.' }
		],
		related: ['why-do-germans-say-numbers-backwards', 'what-does-bitte-mean', 'du-or-sie-in-german']
	},
	{
		slug: 'what-does-bitte-mean',
		question: 'What does "bitte" mean? (please, you\'re welcome, pardon?)',
		short:
			'*Bitte* is a word of many jobs: "please" (*Einen Kaffee, bitte*), "you\'re welcome" (*Danke! – Bitte!*), "here you are" when handing something over (*Bitte schön*), "pardon?" when you did not hear (*Wie bitte?*), and "go ahead" (*Darf ich? – Bitte!*).',
		group: 'everyday',
		body: [
			{
				p: [
					'Say *bitte* at the right moment and every door opens. Here are its jobs, in the order you will meet them at a bakery counter.'
				]
			},
			{
				h: 'Bitte at the bakery',
				table: {
					head: ['Situation', 'German', 'English'],
					rows: [
						['the assistant is ready', '*Bitte schön?*', 'What can I get you?'],
						['you order', '*Zwei Brötchen, bitte.*', 'Two rolls, please.'],
						['you didn’t hear the price', '*Wie bitte?*', 'Pardon?'],
						['she hands them over', '*Bitte schön.*', 'Here you are.'],
						['you thank her', '*Danke! – Bitte!*', 'Thanks! – You’re welcome!']
					]
				}
			},
			{
				h: 'Other ways to say you’re welcome',
				list: [
					'*Gern geschehen* or just *Gern!*: my pleasure.',
					'*Kein Problem*: no problem.',
					'*Nichts zu danken*: don’t mention it.'
				]
			},
			{
				h: 'A polite request without bitte',
				p: [
					'German politeness often lives in the verb, not in *bitte*: *Könnten Sie mir helfen?* or *Ich hätte gern einen Kaffee* already sound polite. Add *bitte* and you are as polite as German gets.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_hoeflich', label: 'Asking and ordering politely' },
			{ quiz: 'quest_a1_2_hoeren_cafe', label: 'Listening: in the café' },
			{ quiz: 'quest_a1_2_sprechen_einkaufen', label: 'Speaking: shopping and ordering' },
			{ quiz: 'quest_a1_2_einkaufen_mengen', label: 'Shopping: amounts and prices' },
			{ quiz: 'quest_a1_1_hoeren_cafe', label: 'Listening: in the coffee house' }
		],
		more: [
			{ href: '/play/schreib-mir', label: 'Schreib mir!', note: 'a chat game: order, thank and apologise in German.' },
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'bitte, danke, gern and the other polite words.' }
		],
		related: ['du-or-sie-in-german', 'what-do-doch-ja-mal-mean-in-german', 'how-to-say-i-like-in-german']
	},
	{
		slug: 'german-false-friends-bekommen-become',
		question: 'Does "bekommen" mean "become"? German false friends',
		short:
			'No: *bekommen* means "to get" or "to receive". "To become" is *werden*. Other traps: *Gift* is poison (a present is a *Geschenk*), *Handy* is a mobile phone, *also* means "so", *eventuell* means "possibly", and *Chef* means "boss".',
		group: 'everyday',
		body: [
			{
				p: [
					'*Ich bekomme ein Steak* means “I’ll have a steak”, not “I become a steak”: *bekommen* is “to get”. Here are the false friends that cause real trouble.'
				]
			},
			{
				h: 'The usual suspects',
				table: {
					head: ['German', 'Means', 'Not'],
					rows: [
						['*bekommen*', 'to get, to receive', 'to become (*werden*)'],
						['*das Gift*', 'poison', 'a gift (*das Geschenk*)'],
						['*das Handy*', 'mobile phone', 'handy (*praktisch*)'],
						['*also*', 'so, therefore', 'also (*auch*)'],
						['*eventuell*', 'possibly, maybe', 'eventually (*schließlich*)'],
						['*aktuell*', 'current, up to date', 'actual (*eigentlich, wirklich*)'],
						['*der Chef*', 'the boss', 'a cook (*der Koch*)'],
						['*sensibel*', 'sensitive', 'sensible (*vernünftig*)'],
						['*bald*', 'soon', 'bald (*kahl*)'],
						['*der Rat*', 'advice, council', 'a rat (*die Ratte*)']
					]
				}
			},
			{
				h: 'The good news',
				p: [
					'Most German–English look-alikes are true friends: *Haus, Hand, Finger, Butter, Wasser, warm, kalt, alt, neu*. The false ones are a short list, and once you have laughed at them, you remember them.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a2_1_hoeren_geschenk', label: 'Listening: a present for grandma (Geschenk)' },
			{ quiz: 'quest_b1_2_technik', label: 'Technology and media (das Handy)' },
			{ quiz: 'quest_a1_1_wortschatz', label: 'Flashcards: A1.1 words' },
			{ quiz: 'quest_c1_2_lesen_anglizismen', label: 'Reading: English words in German (advanced)' }
		],
		more: [
			{ href: '/words/verbs/bekommen', label: 'bekommen', note: 'every form of “to get”, with audio.' },
			{ href: '/words/verbs/werden', label: 'werden', note: 'the real “to become”.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'a word game that pairs German words with their real English.' }
		],
		related: ['does-muss-nicht-mean-must-not', 'german-future-tense-werden', 'why-are-german-words-so-long']
	},
	{
		slug: 'why-do-germans-say-mir-ist-kalt',
		question: 'Why do Germans say "mir ist kalt" and not "ich bin kalt"?',
		short:
			'Because how your body feels is said with the dative: *Mir ist kalt* (I\'m cold), *Mir ist schlecht* (I feel sick). *Ich bin kalt* describes you as a person: cold-hearted. The same goes for *Mir ist langweilig* (I\'m bored) and *Ich bin langweilig* (I\'m boring).',
		group: 'everyday',
		body: [
			{
				p: [
					'*Ich bin langweilig* means “I am boring”. To say you are bored, you need *Mir ist langweilig*: “to me it is boring”. German says how something feels to you with the dative pronoun.'
				]
			},
			{
				h: 'Feelings with mir',
				table: {
					head: ['Say this', 'Meaning', 'Not this'],
					rows: [
						['*Mir ist kalt.*', 'I’m cold.', '*Ich bin kalt.* (I’m cold-hearted)'],
						['*Mir ist langweilig.*', 'I’m bored.', '*Ich bin langweilig.* (I’m boring)'],
						['*Mir ist schlecht.*', 'I feel sick.', '*Ich bin schlecht.* (I’m bad)']
					]
				}
			},
			{
				h: 'The same pattern in daily German',
				examples: [
					{ de: 'Wie geht es dir? – Mir geht es gut.', en: 'How are you? – I’m fine.' },
					{ de: 'Es tut mir leid.', en: 'I’m sorry.' },
					{ de: 'Das gefällt mir.', en: 'I like that.' },
					{ de: 'Mir tut der Kopf weh.', en: 'My head hurts.' }
				],
				p: ['For other people, swap the pronoun: *dir* (you), *ihm* (him), *ihr* (her), *uns* (us), *Ihnen* (you, polite).']
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_dativ_pronomen_intro', label: 'mir, dir, Ihnen: dative pronouns' },
			{ quiz: 'quest_a1_2_koerper', label: 'Body and how you feel' },
			{ quiz: 'quest_a2_1_pronomen_dativ', label: 'Personal pronouns in the dative' },
			{ quiz: 'quest_a2_2_gesundheit', label: 'Body and health' },
			{ quiz: 'quest_a1_2_hoeren_arzt', label: 'Listening: at the doctor’s' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'mir, dir, ihm, ihr, uns, Ihnen: all the dative pronouns.' },
			{ href: '{course}/level/A1.2', label: 'Level A1.2', note: 'where mir and dir first appear.' }
		],
		related: ['how-to-say-i-like-in-german', 'german-reflexive-verbs-sich', 'what-are-the-four-german-cases']
	},
	{
		slug: 'how-to-say-i-like-in-german',
		question: 'How do you say "I like" in German: mögen, gern or gefallen?',
		short:
			'Use *gern* with a verb for things you like doing: *Ich schwimme gern.* Use *mögen* for food, things and people: *Ich mag Kaffee.* Use *gefallen* for what pleases you to see or experience: *Die Stadt gefällt mir.* And *möchte* means "would like": *Ich möchte einen Tee.*',
		group: 'everyday',
		body: [
			{
				p: ['Each of the four has its own job, and the job is easy to spot.']
			},
			{
				h: 'Which one?',
				table: {
					head: ['Use', 'For', 'Example'],
					rows: [
						['verb + *gern*', 'activities', '*Ich lerne gern Deutsch. Ich koche gern.*'],
						['*mögen*', 'things, food, people', '*Ich mag Schokolade. Ich mag dich.*'],
						['*gefallen* + dative', 'what you see or experience', '*Dein Kleid gefällt mir. Hat dir der Film gefallen?*'],
						['*schmecken* + dative', 'how food tastes', '*Die Suppe schmeckt mir.*'],
						['*möchte*', 'would like (to order, to want politely)', '*Ich möchte ein Wasser.*']
					]
				}
			},
			{
				h: 'Watch the subject of gefallen',
				p: [
					'With *gefallen*, the thing you like is the subject, and you are in the dative: *Die Stadt gefällt mir* is literally “the city pleases me”. That is why the verb changes with the thing: *Die Schuhe gefallen mir.*'
				]
			},
			{
				h: 'Stronger and weaker',
				list: [
					'*sehr gern, am liebsten*: very much, most of all. *Ich trinke am liebsten Tee.*',
					'*lieben* is real love, for people and big passions. Don’t say it about a sandwich unless you mean it.',
					'*nicht gern, nicht mögen*: dislike. *Ich mag keinen Fisch.*'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_modalverben', label: 'Modal verbs (möchte, mögen)' },
			{ quiz: 'quest_a1_2_dativ_pronomen_intro', label: 'mir, dir, Ihnen: dative pronouns' },
			{ quiz: 'quest_a1_2_hoeflich', label: 'Asking and ordering politely' },
			{ quiz: 'quest_a1_1_praesens', label: 'Regular verbs in the present' }
		],
		more: [
			{ href: '/words/verbs/moegen', label: 'mögen', note: 'mag, mochte, möchte: every form with audio.' },
			{ href: '/words/verbs/gefallen', label: 'gefallen', note: 'the “pleases me” verb, with every form.' },
			{ href: '/play/ja-nein', label: 'Ja oder Nein?', note: 'a quick game of German likes and dislikes: nothing to get wrong.' }
		],
		related: ['why-do-germans-say-mir-ist-kalt', 'what-does-bitte-mean', 'does-muss-nicht-mean-must-not']
	},
	{
		slug: 'how-long-does-it-take-to-learn-german',
		question: 'How long does it take to learn German?',
		short:
			'For an English speaker, everyday conversation (level B1) usually takes several hundred hours of study, and working-level German (B2–C1) closer to a thousand or more. English speakers have a head start, since thousands of words are shared. Steady short practice beats rare long sessions.',
		group: 'everyday',
		body: [
			{
				p: [
					'German comes in levels, and you can use each one as soon as you reach it. How fast you get there depends mostly on how often you practise.'
				]
			},
			{
				h: 'The levels',
				table: {
					head: ['Level', 'What you can do', 'Rough total study time'],
					rows: [
						['A1', 'introduce yourself, shop, ask simple questions', 'about 100–150 hours'],
						['A2', 'everyday errands, talk about your past', 'about 200–300 hours'],
						['B1', 'manage daily life and work small talk', 'about 350–500 hours'],
						['B2', 'follow the news, work in German', 'about 550–750 hours'],
						['C1', 'study or work at a professional level', 'about 800–1,100 hours']
					]
				},
				p: [
					'These are rough figures that course providers often quote, not promises. English speakers have a head start: thousands of German words look like English ones, from *Haus* to *Finger*.'
				]
			},
			{
				h: 'What speeds it up',
				list: [
					'Every day beats once a week: fifteen minutes daily adds up to 90 hours a year.',
					'Listen a lot. Your ear learns cases and genders before your head does.',
					'Learn nouns with their article from day one.',
					'Speak early, badly and often. Germans are patient with learners who try.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_pronomen', label: 'First lesson: personal pronouns' },
			{ quiz: 'quest_a1_1_artikel', label: 'Articles in the nominative' },
			{ quiz: 'quest_a1_1_wortschatz', label: 'Flashcards: A1.1 words' },
			{ quiz: 'quest_a1_1_hoeren_vorstellung', label: 'Listening: introducing yourself' }
		],
		more: [
			{ href: '/level-check', label: 'Your level', note: 'a two-minute word check that tells you where you stand.' },
			{ href: '/start', label: 'Start the course', note: 'begin from zero, take a test, or pick your level.' },
			{ href: '/books', label: 'The books', note: 'twelve free printable books, A1.1 to C2.2.' }
		],
		related: ['der-die-das-how-to-know', 'why-are-german-nouns-capitalized', 'what-are-the-four-german-cases']
	}
];
