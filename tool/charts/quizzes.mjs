// The app quizzes behind each chart's QR code: the page /charts/<slug> lists them.
// Per chart file: [quiz id, which part of the chart it practises, what you do].
// Hand-picked from the course (assets/content/courses/de_cert_a1.json), easiest first.
// gen-charts.mjs reads this, checks every id exists, and writes the lists into the
// site manifest (src/lib/content/charts.json).
export const CHART_QUIZZES = {
	'15-gender': [
		['quest_a1_1_artikel', 'der, die or das?', 'Sort everyday nouns by their article.'],
		['quest_a1_1_wortbildung', 'The last part decides', 'Make women’s job names with -in, and build compound nouns.'],
		['quest_b2_1_nachsilben_genus', 'The endings, all three columns', 'Give the article from the ending: -ung, -heit, -chen, -ismus …']
	],
	'24-gender-meaning': [
		['quest_a1_1_artikel', 'Always der, die or das', 'Sort everyday nouns by their article.'],
		['quest_a1_2_datum', 'Days and months: der', 'Days of the week and months in sentences.'],
		['quest_a1_1_laender', 'Countries: mostly no article', 'Countries, languages and nationalities, with die Schweiz and die Türkei.']
	],
	'16-plural': [
		['quest_a1_1_plural', 'The five plural endings', 'Sort nouns by how they make their plural.'],
		['quest_a2_1_dativ_artikel', 'Dativ plural adds -n', 'den Kindern, mit den Freunden: articles and endings in the Dativ.']
	],
	'18-articles': [
		['quest_a1_1_artikel', 'der, die, das: known', 'The definite article for everyday nouns.'],
		['quest_a1_2_akkusativ', 'After haben, brauchen', 'einen, eine, ein after verbs like haben and brauchen.'],
		['quest_a1_2_negation', 'kein: the no-article', 'Say no to a noun with kein.']
	],
	'25-present': [
		['quest_a1_1_praesens', 'The six endings', 'Regular verbs in the present tense.'],
		['quest_a1_1_sein_haben', 'sein and haben', 'The two verbs you need first.'],
		['quest_a1_1_vokalwechsel', 'Vowel changes', 'du fährst, er liest, sie nimmt.']
	],
	'03-verb-position': [
		['quest_a1_2_satzbau', 'Verb second', 'Put the verb in position 2, also after a time word.'],
		['quest_a1_2_trennbare', 'The prefix at the end', 'Split verbs: Ich rufe dich an.'],
		['quest_a2_2_weil', 'Verb last', 'Side clauses with weil send the verb to the end.']
	],
	'33-imperative': [
		['quest_a1_2_imperativ', 'du, ihr, Sie', 'Make the three imperatives.'],
		['quest_a1_2_hoeflich', 'bitte: being polite', 'Ask and order politely.'],
		['quest_a2_2_imperativ', 'Every day', 'More imperatives, with split verbs and sich.']
	],
	'22-question-words': [
		['quest_a1_1_wfragen', 'The six boxes', 'Pick the right question word.'],
		['quest_a2_2_indirekte_fragen', 'The next step', 'Not on the chart: the question inside a sentence. Können Sie mir sagen, wo …?']
	],
	'19-kein-nicht': [
		['quest_a1_2_negation', 'kein or nicht?', 'Say no with kein or nicht, and put nicht in its place.']
	],
	'20-possessives': [
		['quest_a1_2_possessiv', 'Owner picks the word', 'mein, dein, sein, ihr: who owns it?'],
		['quest_a1_2_possessiv_plural', 'unser, euer, Ihr', 'The owners in the plural.'],
		['quest_a2_1_welcher_dieser', 'The ending follows the thing', 'mein in the Dativ: mit meinem Bruder.']
	],
	'14-modal-verbs': [
		['quest_a1_2_modalverben', 'The six pictures', 'müssen, dürfen, können, wollen, sollen, möchten in sentences.'],
		['quest_a2_1_modal_praeteritum', 'The past', 'musste, konnte, durfte: sort the forms.'],
		['quest_a2_2_koennte_sollte', 'Polite: könnte, sollte', 'Suggestions and advice.']
	],
	'01-cases': [
		['quest_a1_2_akkusativ', 'Akkusativ', 'den, einen: the direct object.'],
		['quest_a2_1_dativ_artikel', 'Dativ', 'dem, der, den: articles in the Dativ.'],
		['quest_a2_1_dativ_akkusativ', 'Both in one sentence', 'Wem? Was? Verbs with a Dativ and an Akkusativ.'],
		['quest_b1_1_genitiv', 'Genitiv', 'des Mannes, der Frau: whose?']
	],
	'21-pronouns': [
		['quest_a1_1_pronomen', 'ich, du, er …', 'The subject pronouns.'],
		['quest_a1_2_pronomen_akk', 'mich, dich, ihn …', 'Pronouns in the Akkusativ.'],
		['quest_a1_2_dativ_pronomen_intro', 'mir, dir, Ihnen', 'Everyday Dativ: Wie geht es Ihnen?'],
		['quest_a2_1_pronomen_dativ', 'mir, dir, ihm …', 'All the Dativ pronouns.']
	],
	'10-time-prepositions': [
		['quest_a1_2_uhrzeit', 'um: the clock', 'Tell the time.'],
		['quest_a1_2_wann_praepositionen', 'um, am, im', 'Wann? Times, days, months.'],
		['quest_a2_1_temporal_2', 'seit, vor, nach, in, für', 'How long ago, since when, how long.']
	],
	'11-prefixes': [
		['quest_a1_2_trennbare', 'Prefixes that split off', 'anrufen, aufstehen, mitkommen in sentences.'],
		['quest_c1_2_praefixe', 'Both ways (hard)', 'A C1 quiz: prefixes that can do both, übersetzen, umfahren.']
	],
	'06-tenses': [
		['quest_a1_2_perfekt_intro', 'Perfekt', 'First steps: what you did.'],
		['quest_a2_2_praeteritum_intro', 'Präteritum', 'The written past: first steps.'],
		['quest_b1_1_futur', 'Futur', 'werden + infinitive.'],
		['quest_b1_2_plusquamperfekt', 'Plusquamperfekt', 'hatte / war + participle: the past before the past.']
	],
	'26-perfekt': [
		['quest_a1_2_perfekt_intro', 'The participle', 'First steps with the Perfekt.'],
		['quest_a2_1_perfekt_haben', 'haben', 'Perfekt with haben.'],
		['quest_a2_1_perfekt_sein', 'sein', 'Perfekt with sein: verbs of moving and changing.']
	],
	'02-wo-wohin': [
		['quest_a1_1_wo_praepositionen', 'Wo?', 'Say where things are.'],
		['quest_a2_2_wechsel_wo', 'Wo? + Dativ', 'The nine prepositions with the Dativ.'],
		['quest_a2_2_wechsel_wohin', 'Wohin? + Akkusativ', 'The nine prepositions with the Akkusativ.']
	],
	'27-fixed-prepositions': [
		['quest_a1_2_praepositionen', 'Always Akkusativ', 'durch, für, gegen, ohne, um.'],
		['quest_a2_1_dativ_praep', 'Always Dativ', 'aus, bei, mit, nach, seit, von, zu.']
	],
	'34-nach-in-zu': [
		['quest_a1_2_wohin', 'nach, zu, in', 'Where are you going?'],
		['quest_a2_1_woher_wo_wohin', 'Wohin, Wo, Woher', 'All three questions, one system.']
	],
	'28-dativ-verbs': [
		['quest_a1_2_dativ_pronomen_intro', 'gefallen, gehören, schmecken', 'Mir gefällt …: the Dativ verbs you meet first.'],
		['quest_a2_1_dativ_akkusativ', 'Two objects', 'Wem? Was? Giving verbs and the order of two objects.']
	],
	'35-reflexive': [
		['quest_a2_2_reflexiv', 'mich or mir?', 'Reflexive verbs in everyday sentences.']
	],
	'29-linking-words': [
		['quest_a2_2_wenn_deshalb', 'deshalb: verb after it', 'wenn and deshalb.'],
		['quest_a2_2_weil', 'weil: verb last', 'Side clauses with weil.'],
		['quest_a2_2_dass', 'dass: verb last', 'Side clauses with dass.'],
		['quest_b1_1_konjunktionen', 'More side clauses', 'wenn, als, obwohl.']
	],
	'30-irregular-verbs': [
		['quest_a2_1_perfekt_sein', 'The participles', 'gegangen, gekommen, geblieben: Perfekt with sein.'],
		['quest_b1_2_praet_unreg', 'The Präteritum', 'sang, ging, kam: irregular past forms.'],
		['quest_b1_2_praet_misch', 'Mixed verbs', 'brachte, dachte, kannte.']
	],
	'23-comparison': [
		['quest_a2_1_komparativ', 'besser: -er', 'Compare two things.'],
		['quest_a2_2_superlativ', 'am besten', 'The superlative.'],
		['quest_b1_1_adj_komparativ', 'Before a noun', 'das bessere Hotel, der schnellste Weg.']
	],
	'17-n-nouns': [
		['quest_b1_2_n_deklination', 'den Jungen, dem Jungen', 'Nouns that add -n.']
	],
	'05-adjective-endings': [
		['quest_a2_2_adjektiv_intro', 'First meeting', 'Sort the endings.'],
		['quest_b1_1_adj_bestimmt', 'After der, die, das', 'Adjective endings after the definite article.'],
		['quest_b1_1_adj_unbestimmt', 'After ein, kein, mein', 'Adjective endings after ein-words.'],
		['quest_b1_1_adj_nullartikel', 'No article', 'Adjective endings with no article.']
	],
	'07-verb-preposition': [
		['quest_a2_2_verben_praep_intro', 'The first verbs', 'warten auf, denken an: worauf? darauf!'],
		['quest_b1_1_verben_praep', 'More verbs', 'Verbs with prepositions in sentences.'],
		['quest_b2_1_verben_praep', 'The whole map', 'Verbs with prepositions, B2.']
	],
	'36-da-wo': [
		['quest_a2_2_verben_praep_intro', 'darauf, worauf', 'worauf? darauf! The first verbs.'],
		['quest_b1_1_verben_praep', 'Thing or person?', 'da-words, wo-questions and pronouns.']
	],
	'13-relative-clauses': [
		['quest_a2_2_relativ_intro', 'der, den', 'Relative clauses in Nominativ and Akkusativ.'],
		['quest_b1_1_relativ', 'Building them', 'More relative clauses.'],
		['quest_b1_2_relativ_dat', 'dem, dessen', 'Relative clauses in Dativ and Genitiv.'],
		['quest_b1_1_relativ_praep', 'With a preposition', 'der Mann, mit dem ich arbeite.']
	],
	'37-werden': [
		['quest_b1_1_futur', 'werden = will', 'The future with werden.'],
		['quest_a2_2_passiv_intro', 'werden = is done', 'The passive: Das wird gemacht.'],
		['quest_b2_2_futur1_vermutung', 'A guess (harder)', 'A B2 quiz: Er wird wohl krank sein.']
	],
	'31-konjunktiv': [
		['quest_b1_1_konj2_wuerde', 'würde + infinitive', 'Konjunktiv II with würde.'],
		['quest_b1_1_konj2_haette', 'Own forms', 'hätte, wäre, könnte.'],
		['quest_a2_2_koennte_sollte', 'Giving advice', 'könnte and sollte.'],
		['quest_b1_2_irreale_wuensche', 'Wishing', 'Hätte ich doch …!']
	],
	'32-zu-infinitive': [
		['quest_b1_1_infinitiv_zu', 'When zu is needed', 'Infinitive with zu.'],
		['quest_b1_2_infinitiv', 'um, ohne, statt … zu', 'Infinitive clauses.'],
		['quest_b1_2_damit_umzu', 'um … zu or damit?', 'Same subject or not.'],
		['quest_b2_1_dass_infinitiv', 'dass or zu?', 'Turn a dass clause into zu and back.']
	],
	'04-verb-piles': [
		['quest_b1_2_passiv_modal_intro', 'Passive with a modal', 'Das muss gemacht werden.'],
		['quest_b2_1_modalpassiv', 'Three verbs at the end', 'Modal passive in side clauses.'],
		['quest_b2_1_lassen', 'lassen', 'lassen and the double infinitive.']
	],
	'08-passiv': [
		['quest_a2_2_passiv_intro', 'Present', 'Das wird gemacht: first steps.'],
		['quest_b1_2_passiv', 'Present, more', 'The passive in the present.'],
		['quest_b1_2_passiv_praet', 'Präteritum', 'wurde + participle.'],
		['quest_b2_1_passiv_perfekt', 'Perfekt', 'ist … worden.']
	],
	'38-indirect-speech': [
		['quest_b2_1_konj1', 'The forms', 'Konjunktiv I: er sei, er habe.'],
		['quest_b2_1_konj1_vergangenheit', 'Past, questions, requests', 'Report the past, questions and requests.'],
		['quest_c1_2_konjunktiv1_indirekte_rede', 'In texts', 'Indirect speech at C1.']
	]
};
