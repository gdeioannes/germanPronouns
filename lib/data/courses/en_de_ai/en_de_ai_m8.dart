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

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

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
        'own sentence for each preposition, work context preferred. '
        'Write the final report in German.',
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
        'B2.2 opens with the genitive in its natural habitat: formal '
        'frames. Drill fifteen of them, then build your own — this is the '
        'register of emails and contracts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'des + -s, der without',
        text:
            'Masculine and neuter genitive add -s to the noun: trotz des '
            'Wetters, während des Praktikums. Feminine and plural take der: '
            'aufgrund der Verspätung — no ending on the noun.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Spoken German cheats — you don\'t',
        text:
            'On the street you\'ll hear "wegen dem Wetter". In formal '
            'writing and in this drill, the genitive is the only right '
            'answer.',
      ),
    ],
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
        'defend my judgement. Write the final report in German.',
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
        'The AI tells you four questionable decisions; you say what should '
        'have happened instead. Judging the past politely is what the '
        'irreal past is for.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Modal at the very end',
        text:
            'With a modal, the participle becomes an infinitive and the '
            'modal goes last: "Er hätte vorher fragen sollen." Never "hätte '
            'gefragt sollen".',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The judge\'s opening line',
        text:
            '"An seiner Stelle hätte ich zuerst mit dem Chef gesprochen." — '
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
        'relative clauses. Serve one at a time and correct immediately. '
        'Write the final report in German.',
    material:
        'Sentences to serve one at a time (target: a participial '
        'attribute, e.g. "der von der Firma entwickelte Plan"):\n'
        '1. The plan that was developed by the company failed.\n'
        '2. The email that was sent yesterday contains an error.\n'
        '3. The colleague who was hired last month is already leaving.\n'
        '4. The contract that was signed by both sides is valid.\n'
        '5. The questions that were discussed in the meeting remain open.\n'
        '6. The rising prices worry the customers.\n'
        '7. The documents that are still to be checked are on my desk.\n'
        '8. The offer that was rejected by the boss was actually good.\n'
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
        'German loves folding a whole relative clause into an adjective '
        'slot. This drill teaches both moves: packing English clauses in, '
        'and unpacking the German monsters again.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Done = Partizip II, happening = Partizip I',
        text:
            'Was developed → der entwickelte Plan (Partizip II). Is rising '
            '→ die steigenden Preise (Partizip I). Decide the time first, '
            'the ending second.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The full stack',
        text:
            '"der von der Firma im letzten Jahr entwickelte Plan" — agent, '
            'time, participle, noun. Everything between article and noun '
            'belongs to the participle.',
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
        'at a time; question 5 demands a trotz/aufgrund paraphrase. '
        'Write the final report in German.',
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
        'Contract German is its own dialect: ist zu zahlen, bedarf der '
        'Zustimmung. Read a rental excerpt like a tenant who can\'t afford '
        'to misunderstand it.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'ist zu zahlen = must be paid',
        text:
            'sein + zu + infinitive in contracts means obligation: "Die '
            'Miete ist zu zahlen" — the tenant MUST pay. It is never a '
            'suggestion.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Swap the preposition, keep the meaning',
        text:
            'trotz + noun phrase and obwohl + full clause say the same '
            'thing: "trotz mehrfacher Aufforderung" = "obwohl er mehrfach '
            'aufgefordert wurde".',
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
        'particle adds. Write the final report in German.',
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
        'Modal particles are the seasoning of spoken German — the same '
        'sentence, a different feeling. Play twelve rounds of guessing and '
        'producing that feeling.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'doch pushes, halt shrugs',
        text:
            '"Komm doch!" leans toward you — do come! "Komm halt!" shrugs — '
            'come if you must. One word flips the whole invitation.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Particles are whispered',
        text:
            'A real modal particle is never stressed. If you can shout the '
            'word ("Das ist JA falsch!"), it has become a normal adverb and '
            'means something else.',
      ),
    ],
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
        'me through the two weakest sentences. '
        'Write the final report in German.',
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
        '- Accuracy: case endings, verb position in subclauses.',
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
        'The classic B2 writing task: a job application. Your AI invents '
        'the ad, you write the email — formal from subject line to '
        'signature.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'Nominal style, ready to use',
        text:
            '"Nach Abschluss meines Studiums" beats "Nachdem ich mein '
            'Studium abgeschlossen habe" in a letter — shorter, colder, '
            'more professional. Two of these lift the whole email.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'No comma-Sie traps',
        text:
            'After "Sehr geehrte Frau Weber," the next line starts LOWER '
            'case unless it opens with a noun or Sie: "…Weber, mit großem '
            'Interesse habe ich…".',
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
        'things had gone wrong. Interrupt only between the two versions. '
        'Write the final report in German.',
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
        'or verb-first conditional (Hätte ich nicht…, dann…).',
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
        'Tell the same story twice: once as it happened, once as the '
        'disaster it nearly was. The grammar of relief is the irreal '
        'past — enjoy it.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The pivot sentence',
        text:
            '"Und jetzt stellt euch vor, was passiert wäre…" — this line '
            'switches the whole story from Perfekt into hätte/wäre land. '
            'Say it, then stay there.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Hätte first = no wenn needed',
        text:
            '"Hätte ich das Handy nicht gehört, hätte ich den Flug '
            'verpasst." Verb-first replaces wenn and sounds more dramatic — '
            'perfect for a near-catastrophe.',
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
        'the scene. Make me earn every euro. '
        'Write the final report in German.',
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
        'Negotiate a raise against a boss who says nice things and offers '
        'nothing. Politeness and firmness at the same time — that\'s the '
        'B2.2 skill.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'Concede AND advance',
        text:
            '"Ich verstehe die schwierige Lage. Dennoch habe ich im letzten '
            'Jahr zwei Projekte geleitet." — one breath of understanding, '
            'then straight back to your case.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Courtesy is Konjunktiv',
        text:
            '"Ich will mehr Geld" gets you shown the door. "Ich hätte gern '
            'über mein Gehalt gesprochen" gets you a meeting. Same wish, '
            'different mood.',
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
        'have been done at each step — irreal past required. '
        'Write the final report in German.',
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
        'Three voicemails, one brewing disaster. Listen, reconstruct the '
        'chain, and say — in clean irreal past — where it should have been '
        'stopped.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Note who, what, when',
        text:
            'Three messages overload memory fast. Jot one line per '
            'voicemail — sender, request, deadline — and the retell builds '
            'itself.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'Hindsight, step by step',
        text:
            '"Am Montag hätte ich sofort den Lieferanten anrufen sollen." '
            'Day, hätte, action, modal at the end — repeat the template '
            'for each step.',
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
        'formal except one deliberately casual aside I must handle. '
        'Write the final report in German.',
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
        'The module gate: a professional-scenario interview across '
        'everything in M8. Pass it and C1 territory unlocks. Retake it as '
        'often as you like — your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The three B2.2 flags',
        text:
            'The examiner listens hardest for: hätte … machen sollen with '
            'the modal last, genitive after trotz/aufgrund, and zero du in '
            'formal passages. Guard those three.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Buy time formally',
        text:
            '"Das ist eine berechtigte Frage — lassen Sie mich kurz '
            'überlegen." Formal filler keeps the register while your brain '
            'builds the sentence.',
      ),
    ],
  ),
];
