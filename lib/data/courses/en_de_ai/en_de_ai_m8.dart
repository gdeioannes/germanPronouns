import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M8 · B2.2 — *Differenzieren* (Differentiate).
///
/// Can-do: discuss what could/should have been; qualify statements
/// precisely; handle formal work communication; read contract-adjacent
/// prose.
/// Grammar: Konjunktiv II Vergangenheit (incl. modals), full
/// Partizipialattribute, Genitiv + genitive prepositions, Nominalstil
/// intro, modal particles (doch, ja, eben, halt).
///
/// B2.2 session shape: 5 minutes, 8 exchanges, pass 60; reports come back
/// in German from B2.1 on.
const _b22Session = SpeakingSession(durationMinutes: 5, minExchanges: 8);

/// Genitive case + genitive prepositions.
const List<HelpMemoryTip> _genitivTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The genitive endings',
    text:
        'Masculine and neuter: **des** + noun with **-(e)s** — trotz **des '
        'Wetters**, während **des Praktikums**. Feminine and plural: **der** '
        'with no ending on the noun — aufgrund **der** Verspätung, trotz '
        '**der** Probleme. Adjectives in between take **-en**: trotz des '
        'schlecht**en** Wetters.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The formal preposition set',
    text:
        'All of these govern the genitive: **trotz** (despite), **während** '
        '(during), **wegen/aufgrund** (because of), **infolge** (as a result '
        'of), **innerhalb/außerhalb** (inside/outside of), **angesichts** '
        '(in view of), **anlässlich** (on the occasion of), **anstelle** '
        '(instead of), **mithilfe** (with the help of).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Spoken German cheats — you don\'t',
    text:
        'On the street you\'ll hear „wegen dem Wetter" with the dative. In '
        'formal writing, in exams and in this module the genitive is the '
        'only right answer: wegen **des** Wetter**s**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'des needs its -s',
    text:
        'Whenever you say **des**, an **-s** must land on the noun — des '
        'Preise**s**, des Streik**s**. Hear a des without an -s and an alarm '
        'should ring.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Despite the bad weather, the trade fair took place.',
    text: 'Trotz **des schlechten Wetters** fand die Messe statt.',
  ),
];

/// Konjunktiv II Vergangenheit (irreal past), incl. modals.
const List<HelpMemoryTip> _konjPastTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'hätte / wäre + Partizip II',
    text:
        'The irreal past is Konjunktiv II of haben/sein plus the participle: '
        'ich **hätte gefragt** (I would have asked), er **wäre gegangen** '
        '(he would have gone). The auxiliary follows the Perfekt rule: '
        'movement and change verbs take **wäre**, everything else **hätte**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Modals: the modal goes last',
    text:
        'With a modal the participle becomes an infinitive and the modal '
        'closes the sentence as an infinitive too: „Er hätte vorher **fragen '
        'sollen**." Never „hätte gefragt sollen", never „hätte gesollt". '
        'Same with können and müssen: hätte anrufen **können**, hätte zahlen '
        '**müssen**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Verb first = no wenn needed',
    text:
        'Start with the auxiliary and you can drop wenn entirely: „**Hätte** '
        'ich das gewusst, hätte ich anders entschieden." More dramatic, '
        'very German, and one comma cheaper.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Don\'t let würde sneak in',
    text:
        'For the PAST there is no würde-form: not „ich würde gefragt haben" '
        'in everyday German — say „ich **hätte** gefragt". würde + '
        'infinitive is for irreal present and future only.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'In his place I would first have spoken to the boss.',
    text: 'An seiner Stelle **hätte** ich zuerst mit dem Chef **gesprochen**.',
  ),
];

/// Participial attributes (Partizip I / II, zu + Partizip I).
const List<HelpMemoryTip> _partizipTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Done = Partizip II, happening = Partizip I',
    text:
        'Passive/completed meaning takes Partizip II: der **entwickelte** '
        'Plan (the plan that was developed). Active/ongoing meaning takes '
        'Partizip I (infinitive + **-d**): die **steigenden** Preise (the '
        'prices that are rising). Decide the time first, the ending second.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'zu + Partizip I = still to be done',
    text:
        'Necessity packs into **zu** + Partizip I: die noch **zu '
        'prüfenden** Dokumente = the documents that still have to be '
        'checked. It always carries a passive-obligation flavour.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The participle declines like an adjective',
    text:
        'Whatever ending the adjective would take, the participle takes: '
        '**der** entwickelt**e** Plan, **ein** entwickelt**er** Plan, mit '
        '**dem** entwickelt**en** Plan. Wrong ending = wrong attribute.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Everything between article and noun',
    text:
        'Agent, time, place — the whole relative clause squeezes between '
        'article and noun: der **von der Firma im letzten Jahr** '
        'entwickelte Plan. Read from the article, jump to the noun, then '
        'unpack the middle.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The software developed by the company is sold worldwide.',
    text:
        'Die **von der Firma entwickelte** Software wird weltweit verkauft.',
  ),
];

/// Formal register: sein + zu, Nominalstil, correspondence formulas.
const List<HelpMemoryTip> _formalTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'sein + zu + infinitive = obligation',
    text:
        'Contract prose compresses „muss/kann … werden" into sein + zu: '
        '„Die Miete **ist** bis zum dritten Werktag **zu zahlen**" — the '
        'rent MUST be paid. Related formal verbs: **bedarf** + Genitiv '
        '(requires), sich **verpflichten** zu (to commit to).',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Nominalstil: verbs become nouns',
    text:
        'Formal German trades clauses for noun phrases: „nachdem ich mein '
        'Studium abgeschlossen habe" → „**nach Abschluss** meines Studiums"; '
        '„falls Sie interessiert sind" → „**bei Interesse**". Shorter, '
        'colder, more professional.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Register slips cost most',
    text:
        'One **du**, one „na ja" or „mega" and the formal effect collapses. '
        'And after „Sehr geehrte Frau Weber," the next line starts LOWER '
        'case unless it opens with a noun or Sie: „…Weber, **m**it großem '
        'Interesse habe ich…".',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Due to the increased costs we ask for your understanding.',
    text:
        '**Aufgrund der gestiegenen Kosten** bitten wir um Ihr Verständnis.',
  ),
];

/// Modal particles: doch, ja, eben, halt, mal, schon.
const List<HelpMemoryTip> _partikelTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The flavour chart',
    text:
        '**doch** = friendly urging or contradiction · **ja** = shared '
        'knowledge („as we both know") · **eben/halt** = resigned „that\'s '
        'just how it is" · **mal** = casual softener · **schon** = '
        'reassuring or impatient, context decides. Same sentence, different '
        'feeling.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Where particles live',
    text:
        'Modal particles sit in the middle field, right after the finite '
        'verb and any pronouns: „Das ist **ja** interessant", „Komm **doch** '
        'morgen vorbei". Never in first position, never at the end.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'doch pushes, halt shrugs',
    text:
        '„Komm **doch**!" leans toward you — do come! „Komm **halt**!" '
        'shrugs — come if you must. One word flips the whole invitation.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Particles are whispered',
    text:
        'A real modal particle is never stressed. If you can shout the word '
        '(„Das ist JA falsch!"), it has become a normal adverb and means '
        'something else.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'You know I can\'t come today — that\'s just how it is.',
    text:
        'Du weißt **ja**, dass ich heute nicht kommen kann — das ist '
        '**eben** so.',
  ),
];

final List<QuizContent> enDeAiM8Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m8_words_genitiv',
    title: 'Words: genitive prepositions',
    level: 'B2',
    mode: SpeakingMode.vocabDrill,
    session: _b22Session,
    passScore: 60,
    topic:
        'Formal frames with genitive prepositions: drill the 15 frames in '
        'the material, then push me into free production — I must build my '
        'own sentence for each preposition, work context preferred.',
    material:
        'Frames to drill (frame = meaning):\n'
        'trotz des schlechten Wetters = despite the bad weather · '
        'trotz aller Bemühungen = despite all efforts · '
        'während der Besprechung = during the meeting · '
        'während des Praktikums = during the internship · '
        'aufgrund der Verspätung = because of the delay · '
        'aufgrund technischer Probleme = due to technical problems · '
        'infolge des Streiks = as a result of the strike · '
        'infolge eines Missverständnisses = as a result of a misunderstanding · '
        'wegen des hohen Preises = because of the high price · '
        'anlässlich des Jubiläums = on the occasion of the anniversary · '
        'anstelle einer Gehaltserhöhung = instead of a pay rise · '
        'innerhalb der Frist = within the deadline · '
        'außerhalb der Öffnungszeiten = outside opening hours · '
        'angesichts der Lage = in view of the situation · '
        'mithilfe eines Kollegen = with the help of a colleague',
    practisePoints: [
      'Genitive endings: des -(e)s for masculine/neuter, der for feminine',
      'Choosing the right preposition for cause, time and concession',
      'Free production in a formal work register',
    ],
    scoringCriteria: [
      'correct genitive forms',
      'the right preposition for the meaning',
      'natural formal-register sentences',
    ],
    priorityErrors: ['dative after trotz/wegen', 'missing -s on masc./neut.'],
    intro:
        'Formal German marks cause, time and concession with genitive '
        'prepositions — trotz, während, wegen, aufgrund — followed by des '
        '+ noun-s (masculine/neuter) or der (feminine/plural). This is the '
        'register of emails and contracts.',
    tips: _genitivTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_irreal_past',
    title: 'That\'s not how I\'d have done it',
    level: 'B2',
    mode: SpeakingMode.conversation,
    session: _b22Session,
    passScore: 60,
    topic:
        '"Das hätte ich anders gemacht": tell me 4 short decision stories, '
        'one at a time — a colleague who quit by text message, a friend who '
        'bought a car without a test drive, a boss who cancelled a project '
        'by email, a neighbour who sold his flat below value. After each, I '
        'evaluate the decision in the irreal past: what the person should, '
        'could or would have done. Push back once per story so I have to '
        'defend my judgement.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'an seiner Stelle hätte ich = in his place I would have · '
        'er hätte vorher fragen sollen = he should have asked first · '
        'das wäre besser gewesen = that would have been better · '
        'sie hätte sich beraten lassen können = she could have sought advice · '
        'das war ziemlich voreilig = that was rather rash · '
        'ich hätte anders entschieden = I would have decided differently · '
        'so etwas hätte man vermeiden können = that could have been avoided',
    practisePoints: [
      'hätte + Partizip II for irreal past (hätte gefragt)',
      'Irreal past with modals: hätte fragen sollen / können / müssen',
      'wäre + Partizip II where the verb takes sein (wäre gegangen)',
      'Softening judgement: An seiner Stelle hätte ich…',
    ],
    targetVocabulary: [
      'an seiner/ihrer Stelle',
      'hätte … sollen',
      'wäre besser gewesen',
      'die Entscheidung',
      'sich beraten lassen',
      'voreilig',
    ],
    scoringCriteria: [
      'correct hätte/wäre + participle forms',
      'the double-infinitive order with modals',
      'a real evaluation, not just a summary',
    ],
    priorityErrors: [
      'hätte gesollt instead of hätte … sollen',
      'haben/sein auxiliary mixed up',
    ],
    intro:
        'German judges the past with hätte/wäre + Partizip II: „Er hätte '
        'vorher fragen sollen" — he should have asked first, with the modal '
        'as an infinitive at the very end. That construction is what polite '
        'criticism of past decisions is made of.',
    tips: [
      ..._konjPastTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'The judge\'s template',
        text:
            '„An seiner Stelle hätte ich zuerst mit dem Chef gesprochen." — '
            'position, hätte, action, participle. One template carries all '
            'four stories.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_translate_partizip',
    title: 'Translate: packing participles',
    level: 'B2',
    mode: SpeakingMode.translationDrill,
    session: _b22Session,
    passScore: 60,
    topic:
        'Participle workshop in two directions: I turn 8 English '
        'relative-clause sentences into German Partizipialattribute, then '
        'you give me my German versions back and I unpack them into '
        'relative clauses. Serve one at a time and correct immediately.',
    material:
        'Sentences to serve one at a time — read me only the English half; '
        'the German after "=" is the reference answer (other correct German '
        'is acceptable, but the target is a participial attribute):\n'
        '1. The plan that was developed by the company failed. = Der von '
        'der Firma entwickelte Plan ist gescheitert.\n'
        '2. The email that was sent yesterday contains an error. = Die '
        'gestern geschickte E-Mail enthält einen Fehler.\n'
        '3. The colleague who was hired last month is already leaving. = '
        'Der letzten Monat eingestellte Kollege geht schon wieder.\n'
        '4. The contract that was signed by both sides is valid. = Der von '
        'beiden Seiten unterschriebene Vertrag ist gültig.\n'
        '5. The questions that were discussed in the meeting remain open. = '
        'Die in der Besprechung diskutierten Fragen bleiben offen.\n'
        '6. The rising prices worry the customers. = Die steigenden Preise '
        'beunruhigen die Kunden.\n'
        '7. The documents that are still to be checked are on my desk. = '
        'Die noch zu prüfenden Dokumente liegen auf meinem Schreibtisch.\n'
        '8. The offer that was rejected by the boss was actually good. = '
        'Das vom Chef abgelehnte Angebot war eigentlich gut.\n'
        'Round 2: read my German attributes back to me; I unpack each into '
        'a relative clause (der Plan, der von der Firma entwickelt wurde).',
    practisePoints: [
      'Partizip II attributes for passive meaning (der entwickelte Plan)',
      'Partizip I attributes for ongoing meaning (die steigenden Preise)',
      'zu + Partizip I for necessity (die noch zu prüfenden Dokumente)',
      'Adjective endings on the participle',
    ],
    scoringCriteria: [
      'the right participle type',
      'correct adjective endings',
      'accurate unpacking into relative clauses',
    ],
    priorityErrors: [
      'wrong adjective ending on the participle',
      'Partizip I where the meaning is passive',
    ],
    intro:
        'German folds whole relative clauses into the adjective slot: „der '
        'Plan, der entwickelt wurde" becomes „der entwickelte Plan", '
        'complete with adjective endings. This drill teaches both moves — '
        'packing clauses in and unpacking the German monsters again.',
    tips: [
      ..._partizipTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Unpacking, mechanically',
        text:
            'Attribute → relative clause: article + noun first, then der/die/'
            'das + the middle as a clause with the participle as full verb: '
            'der entwickelte Plan → der Plan, der entwickelt wurde.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_read_contract',
    title: 'Reading: the rental contract',
    level: 'B2',
    mode: SpeakingMode.readingQa,
    session: _b22Session,
    passScore: 60,
    topic:
        'A simplified rental-contract excerpt plus a short cover letter to '
        'read and answer questions about. Ask the questions in German, one '
        'at a time; question 5 demands a trotz/aufgrund paraphrase.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Auszug aus dem Mietvertrag, § 4 und § 7:\n'
        'Die monatliche Miete ist bis zum dritten Werktag eines Monats im '
        'Voraus zu zahlen. Der Mieter verpflichtet sich, die von ihm '
        'verursachten Schäden unverzüglich zu melden. Während der '
        'Heizperiode ist eine Mindesttemperatur von 18 Grad zu '
        'gewährleisten. Kleinreparaturen bis zu einem Betrag von 100 Euro '
        'trägt der Mieter. Trotz mehrfacher Aufforderung nicht gemeldete '
        'Mängel gehen zu Lasten des Mieters. Eine Untervermietung bedarf '
        'der schriftlichen Zustimmung des Vermieters.\n'
        '\n'
        'Begleitschreiben der Hausverwaltung:\n'
        'Sehr geehrter Herr Krause, aufgrund der gestiegenen Nebenkosten '
        'erhöht sich Ihre monatliche Vorauszahlung ab dem 1. März um 40 '
        'Euro. Infolge der im letzten Jahr durchgeführten Sanierung bleibt '
        'die Kaltmiete jedoch unverändert. Mit freundlichen Grüßen, Ihre '
        'Hausverwaltung.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Bis wann muss die Miete gezahlt werden?\n'
        '2. Welche Pflichten hat der Mieter bei Schäden und Mängeln?\n'
        '3. Was braucht der Mieter, wenn er untervermieten will?\n'
        '4. Warum steigt die Vorauszahlung — und warum die Kaltmiete '
        'nicht?\n'
        '5. Formuliere den letzten Satz des Schreibens neu: einmal mit '
        '"trotz", einmal mit "obwohl".',
    practisePoints: [
      'Decoding contract prose: ist zu zahlen, bedarf + Genitiv',
      'Participial attributes inside legal sentences',
      'Paraphrasing between trotz + Genitiv and obwohl clauses',
    ],
    scoringCriteria: [
      'correct information from both texts',
      'a working trotz/obwohl paraphrase',
      'formal vocabulary understood, not guessed',
    ],
    priorityErrors: [
      'misreading ist zu zahlen as optional',
      'genitive errors in the paraphrase',
    ],
    intro:
        'Contract German compresses obligation into sein + zu + infinitive '
        '(„ist zu zahlen" = must be paid) and demands the genitive („bedarf '
        'der Zustimmung"). Read a rental excerpt like a tenant who can\'t '
        'afford to misunderstand it.',
    tips: [
      ..._formalTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Swap the preposition, keep the meaning',
        text:
            '**trotz** + noun phrase and **obwohl** + full clause say the '
            'same thing: „trotz mehrfacher Aufforderung" = „obwohl er '
            'mehrfach aufgefordert wurde".',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_partikel_game',
    title: 'Game: Partikel-Gefühl',
    level: 'B2',
    mode: SpeakingMode.wordGame,
    session: _b22Session,
    passScore: 60,
    topic:
        'A mood-guessing game about modal particles (doch, ja, eben, halt, '
        'mal, schon). Keep it playful and always explain the flavour a '
        'particle adds.',
    material:
        'Game rules:\n'
        '- Round 1 (6 rounds, you serve): say the SAME base sentence with '
        'different particles, e.g. "Komm doch!" vs "Komm halt!" vs "Komm '
        'schon!". I name the speaker\'s mood or attitude (encouraging, '
        'resigned, impatient…). Right = 10 points; wrong = 0 and you '
        'explain the particle\'s flavour.\n'
        '- Round 2 (6 rounds, I serve): you give me a situation and a mood '
        '("your friend is late again — resigned"), I produce a sentence '
        'with a fitting particle. You guess my intended mood from my '
        'sentence. If you guess right, I earn 10 points — my particle did '
        'its job.\n'
        '- Flavour cheat-sheet: doch = friendly urging or contradiction · '
        'ja = shared knowledge ("as we both know") · eben/halt = resigned '
        '"that\'s just how it is" · mal = casual softener · schon = '
        'reassuring or impatient, context decides.\n'
        '- 12 rounds total, then convert my points to the final score.',
    practisePoints: [
      'Hearing the mood a particle adds to an identical sentence',
      'Producing doch, ja, eben, halt in fitting situations',
      'Particle position: after the verb and pronouns, unstressed',
    ],
    scoringCriteria: [
      'correct mood readings in round 1',
      'particles that transport the intended mood in round 2',
      'natural, unstressed particle placement',
    ],
    priorityErrors: [
      'stressing the particle like a content word',
      'eben/halt used for urging instead of resignation',
    ],
    intro:
        'Modal particles like doch, ja, eben and halt change the feeling of '
        'a sentence, not its facts: „Komm doch!" urges, „Komm halt!" '
        'shrugs. They sit after verb and pronouns and are never stressed.',
    tips: _partikelTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_write_application',
    title: 'Write: the application email',
    level: 'B2',
    mode: SpeakingMode.writing,
    session: _b22Session,
    passScore: 60,
    topic:
        'A formal application email for the fictional dream job from '
        'module 5. Grade it against the rubric in the material, then walk '
        'me through the two weakest sentences.',
    material:
        'Writing task:\n'
        '- Invent a job ad for my dream job (2 lines) and show it to me.\n'
        '- I write a formal application email of about 120 words: subject '
        'line, formal salutation, why I am applying, two qualifications '
        'with evidence, availability, formal closing.\n'
        'Required forms:\n'
        '- Full formal register (Sie throughout, no colloquialisms).\n'
        '- At least 2 nominal-style phrases (nach Abschluss meines '
        'Studiums, bei Interesse an meiner Bewerbung…).\n'
        '- At least 1 genitive preposition and 1 participial attribute '
        '(die in der Anzeige genannten Anforderungen).\n'
        'Rubric (grade against this):\n'
        '- Register: consistently formal, correct salutation and closing.\n'
        '- Structure: subject, opening, body, availability, closing.\n'
        '- The required forms are present and correct.\n'
        '- Accuracy: case endings, verb position in subclauses.\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Sehr geehrte Damen und Herren = Dear Sir or Madam · '
        'mit großem Interesse habe ich Ihre Anzeige gelesen = I read your '
        'ad with great interest · '
        'nach Abschluss meines Studiums = after completing my degree · '
        'die in der Anzeige genannten Anforderungen = the requirements '
        'named in the ad · '
        'ich stehe ab dem 1. März zur Verfügung = I am available from '
        '1 March · '
        'mit freundlichen Grüßen = kind regards',
    practisePoints: [
      'Formal correspondence formulas (Sehr geehrte…, Mit freundlichen '
          'Grüßen)',
      'Nominal-style phrases in application prose',
      'Genitive and participial attributes under register pressure',
    ],
    scoringCriteria: [
      'consistent formal register',
      'all required forms present and correct',
      'a convincing, complete structure',
    ],
    priorityErrors: [
      'du-forms or colloquial phrases in a formal letter',
      'nominal phrases with wrong case',
    ],
    intro:
        'Formal German letters compress clauses into noun phrases — „nach '
        'Abschluss meines Studiums" instead of a whole nachdem-clause — and '
        'keep Sie from salutation to closing. The classic B2 test of that '
        'register is the job application.',
    tips: [
      ..._formalTips,
      HelpMemoryTip(
        kind: 'example',
        title: 'After completing my degree I led two projects.',
        text:
            '**Nach Abschluss meines Studiums** habe ich zwei Projekte '
            'geleitet.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_story_nearmiss',
    title: 'Tell it: the near-catastrophe',
    level: 'B2',
    mode: SpeakingMode.storytelling,
    session: _b22Session,
    passScore: 60,
    topic:
        '"Beinahe-Katastrophe": I tell a near-miss story twice — first what '
        'actually happened, then the replay of what WOULD have happened if '
        'things had gone wrong. Interrupt only between the two versions.',
    material:
        'Story skeleton:\n'
        '- I invent (or remember) a near-miss: almost missed flight, '
        'almost sent the email to the wrong boss, almost signed the wrong '
        'contract.\n'
        '- Version 1 (real events, Perfekt/Präteritum): setup, the moment '
        'it almost went wrong, the rescue, the relieved ending.\n'
        '- Version 2 (the dark replay, irreal past): what would have '
        'happened — wäre … gewesen, hätte … verloren, hätte … zahlen '
        'müssen. At least 5 irreal-past forms, at least 2 with a modal.\n'
        '- Closing beat: one lesson drawn, with a genitive preposition '
        '(aufgrund dieser Erfahrung…).\n'
        '- Required: clear tense contrast between the versions; wenn-clause '
        'or verb-first conditional (Hätte ich nicht…, dann…).\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'beinahe wäre alles schiefgegangen = everything almost went wrong · '
        'Hätte ich nicht aufgepasst = had I not paid attention · '
        'ich hätte den Flug verpasst = I would have missed the flight · '
        'wir hätten viel Geld zahlen müssen = we would have had to pay a '
        'lot of money · '
        'zum Glück ist nichts passiert = luckily nothing happened · '
        'aufgrund dieser Erfahrung = because of this experience',
    practisePoints: [
      'Perfekt/Präteritum for the real version',
      'hätte/wäre + participle for the replay, incl. modals',
      'Verb-first irreal conditionals (Hätte ich nicht aufgepasst, …)',
    ],
    scoringCriteria: [
      'clean tense separation between the two versions',
      'five correct irreal-past forms, two with modals',
      'a story that actually builds tension',
    ],
    priorityErrors: [
      'irreal forms leaking into version 1',
      'wrong auxiliary in wäre/hätte',
    ],
    intro:
        'The real events take Perfekt; the disaster that never happened '
        'takes the irreal past — hätte/wäre + Partizip II, with verb-first '
        'conditionals like „Hätte ich nicht aufgepasst, …". Telling the '
        'same story twice makes the contrast audible.',
    tips: [
      ..._konjPastTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'The pivot sentence',
        text:
            '„Und jetzt stellt euch vor, was passiert wäre…" — this line '
            'switches the whole story from Perfekt into hätte/wäre land. '
            'Say it, then stay there.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_salary_talk',
    title: 'Roleplay: the salary negotiation',
    level: 'B2',
    mode: SpeakingMode.roleplay,
    session: _b22Session,
    passScore: 60,
    topic:
        'Salary negotiation: you are my budget-shy boss ("schwierige '
        'Marktlage", "vielleicht nächstes Jahr"), I ask for a raise. I use '
        'concessions and Konjunktiv II courtesy, but I am not allowed to '
        'fold more than twice — if I give in a third time, say so and end '
        'the scene. Make me earn every euro.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich hätte gern über mein Gehalt gesprochen = I would like to talk '
        'about my salary · '
        'wäre es möglich, darüber zu sprechen? = would it be possible to '
        'talk about it? · '
        'ich verstehe das, dennoch = I understand that, and yet · '
        'angesichts meiner Leistungen = in view of my achievements · '
        'ich habe zusätzliche Verantwortung übernommen = I have taken on '
        'additional responsibility · '
        'ein Entgegenkommen Ihrerseits = a concession on your side',
    practisePoints: [
      'Konjunktiv II courtesy: Ich hätte gern…, Wäre es möglich…',
      'Concessions that hold ground: Ich verstehe das, dennoch…',
      'Genitive frames under pressure: angesichts meiner Leistungen',
      'Naming achievements concretely, not vaguely',
    ],
    targetVocabulary: [
      'die Gehaltserhöhung',
      'die Verantwortung übernehmen',
      'angesichts',
      'dennoch',
      'ein Entgegenkommen',
      'die Leistung',
    ],
    scoringCriteria: [
      'polite but firm negotiation moves',
      'correct Konjunktiv II courtesy forms',
      'holding position: at most two concessions',
    ],
    priorityErrors: [
      'caving instead of conceding strategically',
      'würde + infinitive where hätte/wäre fits better',
    ],
    intro:
        'Konjunktiv II is the grammar of polite firmness: „Ich hätte '
        'gern…", „Wäre es möglich…". You can concede a point with „Ich '
        'verstehe das, dennoch…" and still hold your position — that\'s the '
        'B2.2 negotiation skill.',
    tips: [
      HelpMemoryTip(
        kind: 'rule',
        title: 'Courtesy is Konjunktiv',
        text:
            '„Ich will mehr Geld" gets you shown the door. „Ich **hätte '
            'gern** über mein Gehalt gesprochen" or „**Wäre** es möglich…" '
            'gets you a meeting. Same wish, different mood.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Concede AND advance',
        text:
            'The two-step: one breath of understanding, then straight back '
            'to your case with **dennoch/trotzdem**: „Ich verstehe die '
            'Lage. **Dennoch** habe ich zwei Projekte geleitet."',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Two concessions, then stop',
        text:
            'Polite German is not endless yielding. After the second „Ich '
            'verstehe…" the next sentence must be a demand or a concrete '
            'proposal — or you have lost the negotiation.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'In view of my achievements a raise would be appropriate.',
        text:
            '**Angesichts meiner Leistungen wäre** eine Gehaltserhöhung '
            'angemessen.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_voicemails',
    title: 'Listen: the voicemail chain',
    level: 'B2',
    mode: SpeakingMode.listenRetell,
    session: _b22Session,
    passScore: 60,
    topic:
        'A voicemail chain to untangle: you speak three short voicemails '
        'aloud, then I summarize the whole situation and say what should '
        'have been done at each step — irreal past required.',
    material:
        'The piece (perform each voicemail aloud, natural pace, '
        'clearly separated; repeat once on request):\n'
        '- Voicemail 1, Montag, Kollegin Yildiz: the delivery for the '
        'trade fair has not arrived; she asks me to call the supplier '
        'before noon.\n'
        '- Voicemail 2, Dienstag, the supplier: they tried to reach me, '
        'the goods are waiting at the depot because nobody confirmed the '
        'address; without confirmation today, delivery slips a week.\n'
        '- Voicemail 3, Mittwoch, the boss: the fair stand has no '
        'products, the situation is embarrassing, he expects an '
        'explanation and a plan by tomorrow morning.\n'
        '\n'
        'Then ask me to:\n'
        '1. Summarize the whole chain in order (Zuerst…, daraufhin…, '
        'schließlich…).\n'
        '2. Say what should have been done at each step (Ich hätte sofort '
        'anrufen sollen…, Man hätte die Adresse bestätigen müssen…).\n'
        '3. Propose the plan for the boss in two sentences, formal '
        'register.',
    practisePoints: [
      'Catching who wants what from spoken messages',
      'Ordering events with connectors (daraufhin, schließlich)',
      'hätte … sollen/müssen for step-by-step hindsight',
    ],
    scoringCriteria: [
      'all three voicemails correctly understood',
      'correct irreal-past forms in the evaluation',
      'a plausible, formal plan for the boss',
    ],
    priorityErrors: [
      'events retold out of order',
      'modal missing from the hindsight forms',
    ],
    intro:
        'Hindsight, step by step, uses hätte + infinitive + modal: „Ich '
        'hätte sofort anrufen sollen." Connectors like zuerst, daraufhin '
        'and schließlich keep the chain of events in order while you judge '
        'it.',
    tips: [
      ..._konjPastTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Note who, what, when',
        text:
            'Three messages overload memory fast. Jot one line per '
            'voicemail — sender, request, deadline — and the retell builds '
            'itself.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m8_gate_interview',
    title: 'Module exam: the B2.2 interview',
    level: 'B2',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 6, minExchanges: 9),
    passScore: 60,
    topic:
        'The closing interview for module 8: a professional scenario mix. '
        'Walk me through a job-interview question, a project post-mortem '
        '(what went wrong, what should have been done), a formal '
        'clarification call, and a short contract clause I must explain in '
        'my own words. Switch scenarios without warning; stay strictly '
        'formal except one deliberately casual aside I must handle.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'das hätte man vermeiden können = that could have been avoided · '
        'wir hätten früher reagieren müssen = we should have reacted '
        'earlier · '
        'aufgrund eines Missverständnisses = due to a misunderstanding · '
        'die in der Anzeige genannten Anforderungen = the requirements '
        'named in the ad · '
        'das ist eine berechtigte Frage = that is a fair question · '
        'lassen Sie mich kurz überlegen = let me think for a moment',
    practisePoints: [
      'Irreal past with modals under pressure',
      'Genitive prepositions and forms in formal speech',
      'Register control: formal by default, no slips',
      'Participial attributes understood and produced',
    ],
    scoringCriteria: [
      'accurate irreal-past evaluation of the post-mortem',
      'correct genitive forms',
      'consistent formal register with one clean casual pivot',
    ],
    priorityErrors: [
      'irreal past with modals mangled',
      'genitive forms avoided or wrong',
      'register slips in formal passages',
    ],
    intro:
        'The module gate bundles everything in M8: irreal past with modals '
        '(hätte … machen sollen), genitive after trotz/aufgrund, '
        'participial attributes and strict formal register — all inside one '
        'professional-scenario interview.',
    tips: [
      ..._formalTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The three B2.2 flags',
        text:
            'The examiner listens hardest for: **hätte … machen sollen** '
            'with the modal last, genitive after **trotz/aufgrund**, and '
            'zero du in formal passages. Guard those three.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'That is a fair question — let me think for a moment.',
        text:
            'Das ist eine berechtigte Frage — **lassen Sie mich** kurz '
            '**überlegen**.',
      ),
    ],
  ),
];
