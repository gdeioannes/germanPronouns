// German FAQ: the questions English speakers type into a search box about
// German ("why are German nouns capitalized?"), one page each.
//
// Every page leads with `short`, a plain answer a search engine can quote,
// then explains it in full and links to the exercises that drill it.
// `*word*` marks German inside English text (rendered lang="de").

import { MORE_FAQ } from './germanFaqMore';

export type FaqTable = { head: string[]; rows: string[][] };

export type FaqBlock = {
	h?: string;
	p?: string[];
	/** German example sentences with their English. */
	examples?: { de: string; en: string }[];
	table?: FaqTable;
	/** A short list, for rules a reader scans. */
	list?: string[];
};

export type FaqEntry = {
	slug: string;
	/** The question as people search it: the page's title and heading. */
	question: string;
	/** The plain answer, first on the page and the search description. */
	short: string;
	group: 'sounds' | 'nouns' | 'verbs' | 'sentences' | 'everyday';
	/** The full explanation, in sections. */
	body: FaqBlock[];
	/** Course exercises that drill it (quiz ids in de_cert_a1). */
	practice: { quiz: string; label: string }[];
	/**
	 * Other material on the site that helps: the word library, a verb's
	 * page, a game, a level overview, the books. `{course}` in an href is
	 * the course's own path.
	 */
	more: { href: string; label: string; note: string }[];
	related: string[];
};

export const FAQ_GROUPS: { id: FaqEntry['group']; title: string }[] = [
	{ id: 'sounds', title: 'Spelling and sounds' },
	{ id: 'nouns', title: 'Nouns, genders and cases' },
	{ id: 'verbs', title: 'Verbs and tenses' },
	{ id: 'sentences', title: 'Sentences and little words' },
	{ id: 'everyday', title: 'Everyday German' }
];

const FIRST_FAQ: FaqEntry[] = [
	{
		slug: 'why-are-german-nouns-capitalized',
		question: 'Why are all German nouns capitalized?',
		short:
			'German writes every noun with a capital letter: *der Hund, die Freiheit, das Essen*. Printers began capitalizing important nouns in the 16th century, by the 18th century it covered all nouns, and the 1901 spelling rules made it official.',
		group: 'sounds',
		body: [
			{
				p: [
					'The capitals are deliberate, and German has used them for about four hundred years. Here is the rule, where it came from, and why it actually helps you read.'
				]
			},
			{
				h: 'The rule',
				p: [
					'Every noun starts with a capital letter, wherever it stands in the sentence. That includes things you can touch (*der Tisch*), ideas you cannot (*die Angst*), and words that only became nouns a second ago: *essen* is "to eat", but *beim Essen* is "while eating", so it takes a capital.'
				],
				examples: [
					{ de: 'Der Hund hat Angst vor dem Gewitter.', en: 'The dog is afraid of the thunderstorm.' },
					{ de: 'Beim Essen spricht man nicht.', en: 'You don’t talk while eating.' },
					{ de: 'Wir treffen uns heute Abend.', en: 'We are meeting this evening.' }
				]
			},
			{
				h: 'Where it came from',
				p: [
					'Early printers capitalized words they wanted to stress: God, rulers, important things. During the 1500s and 1600s the habit spread, and by the 1700s every noun got one. When German spelling was fixed for the whole language in 1901, the capitals were written into the rules.',
					'Not everyone liked it. Jacob Grimm, of the fairy-tale brothers, wrote his great German dictionary with small letters on purpose. Danish once capitalized its nouns too, and dropped the habit in 1948. German kept it, and the 1996 spelling reform even added a few capitals: *heute Abend* used to be *heute abend*.'
				]
			},
			{
				h: 'Why it is useful',
				p: [
					'Once you are used to it, the capitals are a free reading aid. They show you where the nouns are before you know what the words mean, which helps a lot in long sentences. Germans like to prove it with a pair that sounds the same: *der gefangene Floh* is “the captured flea”, while *der Gefangene floh* is “the prisoner fled”. Only the capitals tell them apart.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_artikel', label: 'Articles: der, die, das' },
			{ quiz: 'quest_a1_1_wortbildung', label: 'Word building and compounds' },
			{ quiz: 'quest_a1_1_diktat_steckbrief', label: 'Dictation: a profile' },
			{ quiz: 'quest_a1_1_wortschatz', label: 'Flashcards: A1.1 words' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'every noun in the course, capital letter, article and plural.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'a falling-blocks word game: name the article of each noun.' }
		],
		related: ['der-die-das-how-to-know', 'why-are-german-words-so-long', 'what-is-the-german-ss-eszett']
	},
	{
		slug: 'der-die-das-how-to-know',
		question: 'How do you know if a German noun is der, die or das?',
		short:
			'Mostly you learn the article together with the noun, but many endings tell you: -ung, -heit, -keit, -schaft, -ion and -tät are always die, -chen and -lein are always das, and days, months and seasons are der. In a compound, the last word decides.',
		group: 'nouns',
		body: [
			{
				p: [
					'There is no complete list. But about half of all nouns give their article away through their ending, and the rest you learn the way native speakers did: one noun at a time, always with its article.'
				]
			},
			{
				h: 'Endings that decide',
				table: {
					head: ['Article', 'Ending or group', 'Examples'],
					rows: [
						['*die*', '-ung, -heit, -keit, -schaft, -ion, -tät, -ei', '*die Zeitung, die Freiheit, die Nation, die Bäckerei*'],
						['*die*', 'most nouns in -e (about nine in ten)', '*die Lampe, die Straße*, but *der Junge, das Auge*'],
						['*das*', '-chen, -lein (always)', '*das Mädchen, das Fräulein*'],
						['*das*', 'verbs used as nouns, most words in -um and -ment', '*das Essen, das Museum, das Dokument*'],
						['*der*', 'days, months, seasons, weather', '*der Montag, der Mai, der Winter, der Regen*'],
						['*der*', '-ling, -ismus, most words in -or', '*der Frühling, der Tourismus, der Motor*']
					]
				}
			},
			{
				h: 'Compounds: the last word decides',
				p: [
					'German glues nouns together, and the whole word takes the article of its last part. *Das Haus* plus *die Tür* is *die Haustür*. *Die Hand* plus *der Schuh* is *der Handschuh*, the glove. So once you know the short words, the long ones come free.'
				]
			},
			{
				h: 'The habit that works',
				list: [
					'Never learn a bare noun. Learn *der Tisch*, not *Tisch*.',
					'Learn the plural with it: *der Tisch, die Tische*.',
					'Say it out loud. Your ear remembers *die Milch* long after a list is forgotten.',
					'When you guess, guess *die* for words in -e and *der* for people and animals that are male.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_artikel', label: 'Articles in the nominative' },
			{ quiz: 'quest_a1_1_plural', label: 'Plural of nouns' },
			{ quiz: 'quest_a1_1_wortbildung', label: 'Word building and compounds' },
			{ quiz: 'quest_b2_1_nachsilben_genus', label: 'Endings and gender (advanced)' },
			{ quiz: 'quest_a1_1_wortschatz', label: 'Flashcards: A1.1 words' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'every noun with its article and plural, by theme.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'catch falling nouns and name der, die or das.' },
			{ href: '/books', label: 'The books', note: 'printable books where every noun is listed with its article.' }
		],
		related: ['why-is-it-das-maedchen', 'why-is-the-sun-female-in-german', 'what-are-the-four-german-cases']
	},
	{
		slug: 'why-is-it-das-maedchen',
		question: 'Why is it "das Mädchen" and not "die Mädchen"?',
		short:
			'Because the ending -chen makes every noun neuter, whoever it describes. *Mädchen* comes from *Magd* (maid) plus *-chen*, "little maid", so it is *das Mädchen*. *Die Mädchen* exists too: it is the plural, "the girls".',
		group: 'nouns',
		body: [
			{
				p: [
					'German is not calling a girl a thing. German genders belong to words, not to the people or objects they name, and in this case the word’s ending wins.'
				]
			},
			{
				h: 'The ending decides',
				p: [
					'*-chen* and *-lein* make things small and cute, and every noun with them is *das*. It does not matter what the noun was before: *der Hund* becomes *das Hündchen*, *die Katze* becomes *das Kätzchen*. *Mädchen* was once *Mägdchen*, a little *Magd* (maid), and the *das* came with the ending.'
				],
				examples: [
					{ de: 'das Mädchen, das Fräulein, das Brötchen', en: 'the girl, the young lady (old-fashioned), the bread roll' },
					{ de: 'Die Mädchen spielen Fußball.', en: 'The girls are playing football. (plural)' }
				]
			},
			{
				h: 'Then is she "es"?',
				p: [
					'Strictly, the pronoun follows the noun: *Das Mädchen ist neu, es kommt aus Wien.* In everyday speech most people switch to *sie* as soon as they talk about the girl rather than the word, especially a sentence or two later. Both are correct, and nobody will look at you strangely for either.'
				]
			},
			{
				h: 'It happens in English too',
				p: [
					'English calls a ship "she" and a baby "it". Grammar and the real world do not always agree in any language. German simply shows it on every noun.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_artikel', label: 'Articles in the nominative' },
			{ quiz: 'quest_a1_1_plural', label: 'Plural of nouns' },
			{ quiz: 'quest_a1_1_familie', label: 'Family and people' },
			{ quiz: 'quest_b1_2_wortbildung', label: 'Word building: -heit, -keit, -ung, -schaft' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'Mädchen, Brötchen, Hähnchen: the -chen nouns with audio.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'practise articles as a game.' }
		],
		related: ['der-die-das-how-to-know', 'why-is-the-sun-female-in-german']
	},
	{
		slug: 'why-is-the-sun-female-in-german',
		question: 'Why is the sun feminine and the moon masculine in German?',
		short:
			'German genders are grammar, not meaning, and German inherited *die Sonne* and *der Mond* from its oldest ancestors. In Latin, and in French, Spanish and Italian today, it is the other way round. Neither is more logical: each language kept what it was handed.',
		group: 'nouns',
		body: [
			{
				p: [
					'These genders are very old. Old High German already said *sunna* (feminine) and *māno* (masculine), and the older Germanic languages before it did the same.'
				]
			},
			{
				h: 'Gender is a word’s, not a thing’s',
				p: [
					'A grammatical gender is a class a noun belongs to. It decides the article and the endings around the noun, and that is all. It says nothing about whether the thing is male, female, strong or gentle. That is why the spoon is *der Löffel*, the fork *die Gabel* and the knife *das Messer*, all on one table.'
				]
			},
			{
				h: 'Every language assigns its own',
				table: {
					head: ['', 'sun', 'moon'],
					rows: [
						['German', '*die Sonne* (f)', '*der Mond* (m)'],
						['Latin', 'sol (m)', 'luna (f)'],
						['Spanish', 'el sol (m)', 'la luna (f)'],
						['English', 'the sun', 'the moon']
					]
				},
				p: [
					'English dropped grammatical gender about 700 years ago, so it has no side in this argument. Old English, its ancestor, had three genders just like German.'
				]
			},
			{
				h: 'What to do with it',
				p: [
					'Do not look for the reason behind a single noun: there usually is none you could use. Learn the article with the word, and use the endings that do work, like *-ung* for *die* and *-chen* for *das*.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_artikel', label: 'Articles in the nominative' },
			{ quiz: 'quest_a1_1_plural', label: 'Plural of nouns' },
			{ quiz: 'quest_a2_1_wetter', label: 'Weather and seasons (die Sonne, der Regen)' },
			{ quiz: 'quest_b2_1_nachsilben_genus', label: 'Endings and gender (advanced)' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'look up any noun’s gender, with an example sentence.' },
			{ href: '/play/wortbloecke', label: 'Wortblöcke', note: 'drill genders until they feel natural.' }
		],
		related: ['der-die-das-how-to-know', 'why-is-it-das-maedchen', 'what-are-the-four-german-cases']
	},
	{
		slug: 'what-are-the-four-german-cases',
		question: 'What are the four German cases, and why are there so many words for "the"?',
		short:
			'German has four cases: nominative (the subject), accusative (the direct object), dative (the "to whom") and genitive (possession). The article changes with case and gender, so "the" has six forms: *der, die, das, den, dem, des*.',
		group: 'nouns',
		body: [
			{
				p: [
					'The six forms do a job English gives to word order: they show who does what to whom, so German can move the parts of a sentence around and still be clear.'
				]
			},
			{
				h: 'The four cases',
				table: {
					head: ['Case', 'Its job', 'Question', 'Example'],
					rows: [
						['Nominative', 'the subject, who does it', '*wer?*', '*Der Mann schläft.*'],
						['Accusative', 'the direct object', '*wen? was?*', '*Ich sehe den Mann.*'],
						['Dative', 'the receiver, "to whom"', '*wem?*', '*Ich helfe dem Mann.*'],
						['Genitive', 'whose, possession', '*wessen?*', '*das Auto des Mannes*']
					]
				}
			},
			{
				h: 'The articles in a table',
				table: {
					head: ['', 'masculine', 'feminine', 'neuter', 'plural'],
					rows: [
						['Nominative', '*der*', '*die*', '*das*', '*die*'],
						['Accusative', '*den*', '*die*', '*das*', '*die*'],
						['Dative', '*dem*', '*der*', '*dem*', '*den*'],
						['Genitive', '*des*', '*der*', '*des*', '*der*']
					]
				},
				p: [
					'Look at how little changes: feminine, neuter and plural stay the same in the nominative and accusative. Only the masculine moves, from *der* to *den*. That one change is the first case you learn, and it is most of what the accusative is.'
				]
			},
			{
				h: 'Why it lets German change the order',
				examples: [
					{ de: 'Der Hund beißt den Mann.', en: 'The dog bites the man.' },
					{ de: 'Den Mann beißt der Hund.', en: 'The dog bites the man. (stress on “the man”)' }
				],
				p: [
					'Both sentences mean the dog does the biting, because *der* marks the subject and *den* the object. English has the same thing in a few words: *he* and *him*, *who* and *whom*. German kept it on every article.'
				]
			},
			{
				h: 'Prepositions choose a case too',
				p: [
					'Some prepositions always take one case: *für, durch, ohne* take the accusative, *mit, bei, nach, von, zu* the dative. Learn each preposition with its case and much of the rest takes care of itself.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_akkusativ', label: 'Accusative articles' },
			{ quiz: 'quest_a2_1_dativ_artikel', label: 'Dative articles' },
			{ quiz: 'quest_a2_1_dativ_praep', label: 'Dative prepositions' },
			{ quiz: 'quest_b1_1_genitiv', label: 'The genitive' },
			{ quiz: 'quest_a1_2_praepositionen', label: 'Accusative prepositions' },
			{ quiz: 'quest_a2_1_dativ_akkusativ', label: 'Verbs with dative and accusative' }
		],
		more: [
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'every article and pronoun, with its case.' },
			{ href: '{course}/level/A2.1', label: 'Level A2.1', note: 'the dative, taught step by step.' },
			{ href: '/books', label: 'The books', note: 'the case tables on paper, with exercises.' }
		],
		related: ['der-die-das-how-to-know', 'why-is-the-verb-at-the-end-in-german']
	},
	{
		slug: 'why-are-german-words-so-long',
		question: 'Why are German words so long?',
		short:
			'German writes compound nouns as one word, where English leaves spaces: car insurance company is *Autoversicherungsgesellschaft*. The parts are ordinary words, and the last one gives the meaning and the article. Read a long word from the end.',
		group: 'sounds',
		body: [
			{
				p: [
					'A long German noun is usually several short words written together. English builds the same things, it just leaves gaps: “bus stop”, “birthday present”, “car insurance company”. German closes the gaps.'
				]
			},
			{
				h: 'How a compound works',
				p: [
					'The last part is the head: it says what the thing is and gives the article. Everything in front narrows it down. A *Kühlschrank* is a *Schrank* (cupboard) that is *kühl* (cool), so it is a fridge, and it is *der* because *Schrank* is.'
				],
				examples: [
					{ de: 'die Haustür = das Haus + die Tür', en: 'the front door' },
					{ de: 'der Geburtstag = die Geburt + der Tag', en: 'birthday (“birth day”)' },
					{ de: 'das Arbeitszimmer = die Arbeit + s + das Zimmer', en: 'the study, the home office' }
				]
			},
			{
				h: 'The little glue letters',
				p: [
					'Some compounds have a joint between the parts: *-s-* in *Arbeitszimmer*, *-n-* in *Sonnenschein*, *-e-* in *Hundehütte*. They help the word flow and carry no meaning of their own. You learn them with the word.'
				]
			},
			{
				h: 'The famous monsters',
				p: [
					'*Donaudampfschifffahrtsgesellschaftskapitän* (captain of a Danube steamship company) is a joke word Germans love. A real one was a law in Mecklenburg-Western Pomerania: *Rinderkennzeichnungs- und Rindfleischetikettierungsüberwachungsaufgabenübertragungsgesetz*, about labelling beef. It was repealed in 2013, and its name went with it.',
					'Everyday German is much tamer. Most compounds have two or three parts, and you can take any of them apart from the end.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_wortbildung', label: 'Word building and compounds' },
			{ quiz: 'quest_c2_1_komposita', label: 'Building and reading compounds (advanced)' },
			{ quiz: 'quest_a2_2_wortbildung', label: 'Word building: -er, -ung, un-, -los, -bar' },
			{ quiz: 'quest_b1_2_wortbildung', label: 'Word building: -heit, -keit, -ung, -schaft' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'compounds like Kühlschrank and Haustür, taken apart.' },
			{ href: '{course}/level/C2.1', label: 'Level C2.1', note: 'compounds at full strength.' }
		],
		related: ['der-die-das-how-to-know', 'why-are-german-nouns-capitalized']
	},
	{
		slug: 'what-is-the-german-ss-eszett',
		question: 'What is the German ß and when do you use it?',
		short:
			'ß (Eszett, or "sharp s") is a sharp s sound, like ss. Since the 1996 spelling reform you write ß after a long vowel or a diphthong (*Straße, heißen*) and ss after a short vowel (*Fluss, dass*). Switzerland writes ss everywhere. Without the key, write ss.',
		group: 'sounds',
		body: [
			{
				p: [
					'It looks like a B, but it is *ß*, called *Eszett* (“s-z”) or *scharfes S*. It says the same sound as *ss*: the hissing s in “kiss”, never the buzzing one in “rose”.'
				]
			},
			{
				h: 'ß or ss?',
				p: ['The vowel in front decides.'],
				table: {
					head: ['Before it', 'Write', 'Examples'],
					rows: [
						['a long vowel', '*ß*', '*die Straße, der Fuß, groß, süß*'],
						['a diphthong (ei, au, eu)', '*ß*', '*heißen, weiß, draußen*'],
						['a short vowel', '*ss*', '*der Fluss, muss, dass, essen*']
					]
				}
			},
			{
				h: 'Why it changes inside one word',
				p: [
					'Because the vowel changes. *Ich esse* has a short e, so *ss*. *Ich aß* (I ate) has a long a, so *ß*. *Der Fluss* is short, *der Fuß* is long. Before 1996 the rule was different, which is why you will see *daß* in older books and on old signs: today it is *dass*.'
				]
			},
			{
				h: 'The rest of the story',
				list: [
					'It began as two letters written together in old handwriting and print: a long s joined to a z or another s.',
					'Switzerland and Liechtenstein do not use it at all and write *ss*: *Strasse*.',
					'In capitals it used to become *SS* (*STRASSE*). A capital *ẞ* has been allowed officially since 2017.',
					'No German keyboard? *ss* is always accepted: *Strasse* will be understood.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_c1_1_hoeren_rechtschreibung', label: 'Listening: the argument about ß' },
			{ quiz: 'quest_a1_1_hoeren_buchstabieren', label: 'Listening: spelling out words' },
			{ quiz: 'quest_c2_2_lesen_reform', label: 'Reading: the fight over the sharp S' },
			{ quiz: 'quest_a1_1_diktat_steckbrief', label: 'Dictation: a profile' }
		],
		more: [
			{ href: '/words/nouns', label: 'Noun library', note: 'Straße, Fuß, Fluss: hear the sound, see the spelling.' },
			{ href: '{course}/level/A1.1', label: 'Level A1.1', note: 'spelling and dictation from the start.' }
		],
		related: ['how-to-pronounce-german-umlauts', 'why-are-german-nouns-capitalized']
	},
	{
		slug: 'how-to-pronounce-german-umlauts',
		question: 'How do you pronounce the German umlauts ä, ö and ü?',
		short:
			'Ä sounds like the e in "bed" (long: like the "ai" in "fair" without the r). For ö, say the e in "bed" and round your lips. For ü, say "ee" and round your lips as for "oo". Without the keys, write ae, oe and ue.',
		group: 'sounds',
		body: [
			{
				p: [
					'The trick for *ö* and *ü* is that your tongue and your lips work separately: the tongue makes one vowel while the lips make another.'
				]
			},
			{
				h: 'Mouth positions',
				table: {
					head: ['Letter', 'How to make it', 'Examples'],
					rows: [
						['*ä*', 'like the e in “bed”; long, like “fair” without the r', '*Männer, spät, Käse*'],
						['*ö*', 'say the e in “bed” (or “ay” for the long one), then round your lips', '*schön, hören, Köln*'],
						['*ü*', 'say “ee”, keep your tongue there, round your lips as for “oo”', '*über, müde, fünf*']
					]
				}
			},
			{
				h: 'The dots change the meaning',
				examples: [
					{ de: 'schon / schön', en: 'already / beautiful' },
					{ de: 'der Bruder / die Brüder', en: 'the brother / the brothers' },
					{ de: 'zahlen / zählen', en: 'to pay / to count' },
					{ de: 'warm / wärmer', en: 'warm / warmer' }
				],
				p: [
					'The umlaut often marks a change in the word: a plural (*Mann, Männer*), a comparison (*alt, älter*), or a verb form (*ich fahre, du fährst*). If you hear it, something has happened to the word.'
				]
			},
			{
				h: 'Where the dots came from',
				p: [
					'Medieval scribes wrote a small *e* above a vowel to show it had shifted. Over time the little *e* shrank to two dots. That is why *ae, oe, ue* are the accepted way to type them: *Mueller* is the same name as *Müller*.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_hoeren_buchstabieren', label: 'Listening: spelling out words' },
			{ quiz: 'quest_a1_1_vokalwechsel', label: 'Verbs that change their vowel' },
			{ quiz: 'quest_a1_1_plural', label: 'Plural of nouns' },
			{ quiz: 'quest_a2_1_komparativ', label: 'Comparatives (alt, älter)' },
			{ quiz: 'quest_a1_1_sprechen_vorstellung', label: 'Speaking: introducing yourself' }
		],
		more: [
			{ href: '/words/verbs/fahren', label: 'fahren', note: 'du fährst, er fährt: hear the umlaut appear.' },
			{ href: '/words/nouns', label: 'Noun library', note: 'plurals with umlauts, every one recorded.' }
		],
		related: ['what-is-the-german-ss-eszett', 'why-do-germans-say-numbers-backwards']
	},
	{
		slug: 'why-is-the-verb-at-the-end-in-german',
		question: 'Why does German put the verb at the end of the sentence?',
		short:
			'In a main clause the conjugated verb comes second and any second verb part goes to the end: *Ich habe gestern einen Film gesehen.* After words like *weil, dass* and *wenn*, the conjugated verb moves to the end too: *…, weil ich müde bin.*',
		group: 'verbs',
		body: [
			{
				p: [
					'German verbs have two fixed places in a sentence. Once you know them, every sentence has the same frame.'
				]
			},
			{
				h: 'Rule 1: the verb is second',
				p: [
					'In an ordinary statement, the conjugated verb is the second thing in the sentence. What comes first can change; the verb stays put, and the subject moves behind it if needed.'
				],
				examples: [
					{ de: 'Ich gehe heute ins Kino.', en: 'I’m going to the cinema today.' },
					{ de: 'Heute gehe ich ins Kino.', en: 'Today I’m going to the cinema.' }
				]
			},
			{
				h: 'Rule 2: the rest goes to the end',
				p: [
					'If the verb has a second part, such as an infinitive, a past participle or a separable prefix, that part goes to the very end. Everything else sits between the two, like filling in a sandwich.'
				],
				examples: [
					{ de: 'Ich habe gestern einen Film gesehen.', en: 'I watched a film yesterday.' },
					{ de: 'Ich muss morgen früh arbeiten.', en: 'I have to work early tomorrow.' }
				]
			},
			{
				h: 'Rule 3: after weil, dass, wenn, the verb goes last',
				p: [
					'Clauses that start with a joining word like *weil* (because), *dass* (that), *wenn* (if, when) or *ob* (whether) send the conjugated verb to the end.'
				],
				examples: [
					{ de: 'Ich bleibe zu Hause, weil ich müde bin.', en: 'I’m staying at home because I’m tired.' },
					{ de: 'Ich glaube, dass er morgen kommt.', en: 'I think he’s coming tomorrow.' }
				]
			},
			{
				h: 'Is there a reason?',
				p: [
					'The verb-at-the-end order is old: it is how Germanic clauses were built long ago, and German kept it in its subordinate clauses where English gave it up. The upside is that a German listener always knows where the verb will be.',
					'Mark Twain joked in 1880 that a German writer dives into a sentence and is not seen again “till he emerges on the other side of his Atlantic with his verb in his mouth”. Interpreters really do wait for it: translating German live, they often have to hold a whole sentence in their heads until the verb arrives.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_satzbau', label: 'Word order: position 2' },
			{ quiz: 'quest_a2_2_weil', label: 'Clauses with weil' },
			{ quiz: 'quest_a2_2_dass', label: 'Clauses with dass' },
			{ quiz: 'quest_c2_2_hoeren_dolmetscher', label: 'Listening: waiting for the verb' },
			{ quiz: 'quest_a2_2_tekamolo', label: 'Word order: when, how, where' },
			{ quiz: 'quest_b1_1_konjunktionen', label: 'Clauses with wenn, als, obwohl' }
		],
		more: [
			{ href: '/play/schreib-mir', label: 'Schreib mir!', note: 'a chat game: build every answer from word tiles, in the right order.' },
			{ href: '/words/dictionary', label: 'Small-word dictionary', note: 'weil, dass, wenn, ob: which ones send the verb to the end.' }
		],
		related: ['why-do-german-verbs-split', 'what-are-the-four-german-cases']
	},
	{
		slug: 'why-do-german-verbs-split',
		question: 'Why do German verbs split in two (separable verbs)?',
		short:
			'Many German verbs have a prefix that leaves the verb in a main clause and goes to the end: *anrufen* becomes *Ich rufe dich morgen an.* The prefix stays attached in the infinitive, after *weil* or *dass*, and in the past participle: *angerufen*.',
		group: 'verbs',
		body: [
			{
				p: [
					'*Anrufen* is a separable verb: in a main clause the prefix *an* goes to the end of the sentence, the same place German uses for every second verb part.'
				]
			},
			{
				h: 'When it splits and when it does not',
				table: {
					head: ['Where', 'Form', 'Example'],
					rows: [
						['main clause', 'split, prefix at the end', '*Ich rufe dich morgen an.*'],
						['with a modal verb', 'together, at the end', '*Ich will dich morgen anrufen.*'],
						['after weil, dass, wenn', 'together, at the end', '*…, weil ich dich morgen anrufe.*'],
						['past participle', '-ge- in the middle', '*Ich habe dich angerufen.*'],
						['with zu', '-zu- in the middle', '*Vergiss nicht, mich anzurufen!*']
					]
				}
			},
			{
				h: 'How to spot one',
				p: [
					'Separable prefixes are stressed, and most are words in their own right: *an, auf, aus, ein, mit, ab, vor, weg, zu, zurück*. Inseparable prefixes are never stressed and never split: *be-, ver-, er-, ent-, zer-, emp-, miss-*. So it is *Ich verstehe dich*, never *Ich stehe dich ver*.'
				]
			},
			{
				h: 'The trap: same letters, two verbs',
				p: [
					'A few prefixes can go either way, and the meaning changes with the stress. Stress *um* in *umfahren* and you knock something over with your car; stress *fahren* and you drive around it.'
				],
				examples: [
					{ de: 'Ich fahre das Schild um.', en: 'I knock the sign over (with my car).' },
					{ de: 'Ich umfahre das Schild.', en: 'I drive around the sign.' }
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_trennbare', label: 'Separable verbs' },
			{ quiz: 'quest_a1_2_satzbau', label: 'Word order: position 2' },
			{ quiz: 'quest_c1_2_praefixe', label: 'Prefixes: separable or not? (advanced)' },
			{ quiz: 'quest_a1_2_hoeren_baecker', label: 'Listening: getting up at three (aufstehen)' },
			{ quiz: 'quest_a1_2_bigtext_meintag', label: 'Long text: my day' }
		],
		more: [
			{ href: '/words/verbs/anrufen', label: 'anrufen', note: 'every form: ich rufe an, ich habe angerufen.' },
			{ href: '/words/verbs/aufstehen', label: 'aufstehen', note: 'another everyday separable verb, with audio.' }
		],
		related: ['why-is-the-verb-at-the-end-in-german', 'du-or-sie-in-german']
	},
	{
		slug: 'du-or-sie-in-german',
		question: 'When do you use du and when Sie in German?',
		short:
			'Use *Sie* (always with a capital S) for adults you do not know, at work unless told otherwise, and with officials and shop staff. Use *du* with friends, family, children, and among students. The older or more senior person offers *du*. If unsure, start with *Sie*.',
		group: 'everyday',
		body: [
			{
				p: [
					'Mistakes here are forgiven quickly, and starting with *Sie* is never wrong. Here is who gets which.'
				]
			},
			{
				h: 'Who gets which',
				table: {
					head: ['Use', 'With'],
					rows: [
						['*du*', 'friends, family, children, pets, classmates, people your age in relaxed places (a party, a sports club, most of the internet)'],
						['*ihr*', 'two or more people you would each call *du*'],
						['*Sie*', 'adults you don’t know, colleagues and bosses (unless they offer du), doctors, officials, police, shop and restaurant staff; one person or several']
					]
				}
			},
			{
				h: 'The grammar of Sie',
				p: [
					'*Sie* uses the same verb form as *sie* (they), and it is always written with a capital: *Sie sind, Sie haben, Können Sie mir helfen?* Its other forms are capitalized too: *Ihnen* (to you), *Ihr* (your).'
				],
				examples: [
					{ de: 'Woher kommst du?', en: 'Where are you from? (friendly)' },
					{ de: 'Woher kommen Sie?', en: 'Where are you from? (polite)' }
				]
			},
			{
				h: 'Switching to du',
				p: [
					'The older person, or the more senior one at work, offers it: *Wollen wir uns duzen?* (Shall we say du?). Once you have switched, going back to *Sie* feels cold, so it is a small event. Many workplaces, especially young companies, use *du* from the first day.',
					'Do not try it with the police. Calling an officer *du* can count as an insult, and people have been fined for it.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_2_hoeflich', label: 'Asking and ordering politely' },
			{ quiz: 'quest_a1_1_praesens', label: 'Regular verbs in the present' },
			{ quiz: 'quest_a1_1_hoeren_vorstellung', label: 'Listening: introducing yourself' },
			{ quiz: 'quest_a1_2_possessiv_plural', label: 'unser, euer, Ihr' },
			{ quiz: 'quest_b1_1_email_redemittel', label: 'Emails: formal and informal' }
		],
		more: [
			{ href: '/play/schreib-mir', label: 'Schreib mir!', note: 'a chat game: talk to characters in German, building every answer from word tiles.' },
			{ href: '/words/verbs/sein', label: 'sein', note: 'du bist, Sie sind: the forms side by side.' }
		],
		related: ['why-do-german-verbs-split', 'why-are-german-nouns-capitalized']
	},
	{
		slug: 'why-do-germans-say-numbers-backwards',
		question: 'Why do Germans say numbers backwards (einundzwanzig)?',
		short:
			'From 21 to 99, German says the ones before the tens: 21 is *einundzwanzig*, "one-and-twenty". English once counted the same way, as in "four-and-twenty blackbirds", and Dutch still does. Hundreds and thousands go in the normal order.',
		group: 'everyday',
		body: [
			{
				p: [
					'German numbers from 21 to 99 say the small part first: *siebenundvierzig* is seven-and-forty, 47. When you write numbers down as you hear them, this is easy to get wrong.'
				]
			},
			{
				h: 'How it works',
				table: {
					head: ['Number', 'German', 'Word for word'],
					rows: [
						['21', '*einundzwanzig*', 'one-and-twenty'],
						['47', '*siebenundvierzig*', 'seven-and-forty'],
						['365', '*dreihundertfünfundsechzig*', 'three hundred five-and-sixty'],
						['2026', '*zweitausendsechsundzwanzig*', 'two thousand six-and-twenty']
					]
				},
				p: [
					'Only the last two digits flip. Hundreds and thousands come in the order you expect, and the whole number is written as one word.'
				]
			},
			{
				h: 'English used to do it too',
				p: [
					'The nursery rhyme still sings of “four-and-twenty blackbirds baked in a pie”, and older English had “five-and-twenty” for 25. English moved to tens first; German, like Dutch (*eenentwintig*), kept the old way.'
				]
			},
			{
				h: 'Tips for hearing numbers',
				list: [
					'Write the second digit first, then the first: hear *sieben*, write _7, hear *vierzig*, fill in 47.',
					'On the phone, people often say *zwo* instead of *zwei*, so it is not confused with *drei*.',
					'Phone numbers are usually read in pairs: 47 11 83 is *siebenundvierzig, elf, dreiundachtzig*.'
				]
			}
		],
		practice: [
			{ quiz: 'quest_a1_1_zahlen3', label: 'Numbers 20–100' },
			{ quiz: 'quest_a1_1_hoeren_zahlen', label: 'Listening: numbers and prices' },
			{ quiz: 'quest_a1_1_zahlen_gross', label: 'Numbers from 100: prices, years, amounts' },
			{ quiz: 'quest_a1_1_zahlen2', label: 'Numbers 11–20' },
			{ quiz: 'quest_a1_1_lesen_hamburg', label: 'Reading: Hamburg in numbers' }
		],
		more: [
			{ href: '{course}/level/A1.1', label: 'Level A1.1', note: 'all the number lessons, with listening.' },
			{ href: '{course}/worksheet', label: 'Printable sheets', note: 'number exercises to do on paper.' }
		],
		related: ['how-to-pronounce-german-umlauts', 'why-is-the-verb-at-the-end-in-german']
	}
];

/** All questions: the first twelve here, the rest in germanFaqMore. */
export const GERMAN_FAQ: FaqEntry[] = [...FIRST_FAQ, ...MORE_FAQ];

/** "{course}/level/A1.1" → "/course/de_cert_a1/level/A1.1". */
export function faqHref(href: string, courseHref: string): string {
	return href.replace('{course}', courseHref);
}

/** The sub-level a quiz id belongs to: "quest_a1_2_uhrzeit" → "A1.2". */
export function quizLevel(quizId: string): string {
	const m = quizId.match(/^quest_([abc])([12])_([12])_/);
	return m ? `${m[1].toUpperCase()}${m[2]}.${m[3]}` : '';
}

/**
 * Folds text for search: lower case, umlauts and ß spelled out the way they
 * are typed without a German keyboard (ä → ae, ß → ss), then "ae/oe/ue"
 * reduced to the bare vowel, so "Madchen", "Maedchen" and "Mädchen" all match.
 */
export function foldForSearch(text: string): string {
	return text
		.toLowerCase()
		.replace(/ß/g, 'ss')
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '')
		.replace(/([aou])e/g, '$1')
		.replace(/[*"“”„’'()?!.,:;]/g, ' ');
}

const SEARCH_INDEX = new Map<string, { question: string; all: string }>();

function indexOf(f: FaqEntry) {
	let hit = SEARCH_INDEX.get(f.slug);
	if (!hit) {
		const body = f.body.flatMap((b) => [
			b.h ?? '',
			...(b.p ?? []),
			...(b.list ?? []),
			...(b.table?.rows.flat() ?? []),
			...(b.examples?.flatMap((e) => [e.de, e.en]) ?? [])
		]);
		hit = { question: foldForSearch(f.question), all: foldForSearch([f.question, f.short, ...body].join(' ')) };
		SEARCH_INDEX.set(f.slug, hit);
	}
	return hit;
}

/**
 * The questions matching every word of `query`, those whose question
 * matches first. An empty query matches nothing (the page shows the groups).
 */
export function searchFaq(query: string): FaqEntry[] {
	const words = foldForSearch(query).split(/\s+/).filter(Boolean);
	if (!words.length) return [];
	return GERMAN_FAQ.map((f) => ({ f, i: indexOf(f) }))
		.filter(({ i }) => words.every((w) => i.all.includes(w)))
		.map(({ f, i }) => ({ f, score: words.filter((w) => i.question.includes(w)).length }))
		.sort((a, b) => b.score - a.score)
		.map(({ f }) => f);
}

export function findFaq(slug: string): FaqEntry | undefined {
	return GERMAN_FAQ.find((f) => f.slug === slug);
}

/** Splits "*word*" markup into plain and German runs, for rendering without {@html}. */
export function faqRuns(text: string): { de: boolean; text: string }[] {
	return text
		.split(/(\*[^*]+\*)/)
		.filter(Boolean)
		.map((part) => (part.startsWith('*') && part.endsWith('*') ? { de: true, text: part.slice(1, -1) } : { de: false, text: part }));
}

/** The short answer with its markup removed (for meta tags and structured data). */
export function plain(text: string): string {
	return text.replace(/\*/g, '');
}
