import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M5 · B1.1 — *Meinungen & Wünsche* (Opinions & wishes).
///
/// Can-do: state and defend opinions; express wishes and polite
/// hypotheticals; describe people/things with full adjective phrases; talk
/// about work and living situations.
/// Grammar: Konjunktiv II present (würde/hätte/wäre/könnte), adjective
/// endings (all three declension patterns), reflexive verbs, verbs with
/// prepositions, expanded Nebensätze (obwohl, damit, um…zu).
///
/// B1 session shape: ~4 minutes, 8 exchanges, pass 60.
const _b1Session = SpeakingSession(durationMinutes: 4, minExchanges: 8);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM5Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m5_adj_endings',
    title: 'Words: character adjectives with endings',
    level: 'B1',
    mode: SpeakingMode.vocabDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Character adjectives drilled INSIDE noun phrases: you give me a '
        'noun-plus-case frame with a gap, I supply a fitting adjective with '
        'the correct ending. Rotate all three declension patterns.',
    material:
        'Adjectives to drill (word = meaning):\n'
        'freundlich = friendly · zuverlässig = reliable · ehrgeizig = '
        'ambitious · geduldig = patient · streng = strict · faul = lazy · '
        'fleißig = hard-working · hilfsbereit = helpful · schüchtern = shy · '
        'selbstbewusst = self-confident · gelassen = calm, relaxed · '
        'launisch = moody · neugierig = curious · ordentlich = tidy · '
        'chaotisch = chaotic\n'
        'Frames to serve (fill the gap, endings vary by article and case):\n'
        'ein ___ Kollege · mit meiner ___ Chefin · der ___ Nachbar · '
        'ohne den ___ Mitbewohner · ___ Freunde (no article) · '
        'für ein ___ Team · von einem ___ Menschen · die ___ Kollegin',
    practisePoints: [
      'Weak endings after der/die/das (der nette Nachbar)',
      'Mixed endings after ein/kein/mein (ein netter Kollege)',
      'Strong endings with no article (netten Freunden)',
    ],
    scoringCriteria: [
      'a fitting adjective for the frame',
      'the correct ending for article and case',
      'speed on repeated patterns',
    ],
    priorityErrors: ['bare adjectives without endings', '-e vs -en mixed up'],
    intro:
        'B1 starts with the endings everyone fears. Your AI serves noun '
        'frames; you drop in character adjectives with the right ending — '
        'over and over until the patterns stick.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Someone must show the case',
        text:
            'If the article shows the case (der, dem), the adjective relaxes '
            'to -e/-en. If the article is weak or missing (ein, kein words '
            'in some slots, no article), the adjective carries the strong '
            'ending itself.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_wg_conflict',
    title: 'The dishes rota has collapsed',
    level: 'B1',
    mode: SpeakingMode.conversation,
    session: _b1Session,
    passScore: 60,
    topic:
        'We share a flat and our dishes rota has completely collapsed — '
        'your dishes have been in the sink for four days. You play my '
        'slightly defensive flatmate. I express my annoyance politely with '
        'Konjunktiv II (Könntest du…? Ich hätte gern…, Es wäre schön, '
        'wenn…) and we negotiate a new rota that both of us accept.',
    practisePoints: [
      'Polite requests in Konjunktiv II: könntest, würdest, wärst',
      'Naming feelings without attacking: Ich ärgere mich, wenn…',
      'Negotiating a concrete fix (wer, wann, was)',
    ],
    targetVocabulary: [
      'der Abwasch',
      'die Spüle',
      'sich ärgern über',
      'der Vorschlag',
      'sich einigen auf',
      'der Putzplan',
    ],
    scoringCriteria: [
      'well-formed Konjunktiv II requests',
      'reflexive verbs used correctly',
      'a real negotiated agreement by the end',
    ],
    priorityErrors: [
      'indicative where Konjunktiv II is needed (kannst du vs könntest du)',
      'missing reflexive pronoun (ich ärgere über)',
    ],
    intro:
        'A flat-share classic: dirty dishes, four days old. Complain like a '
        'diplomat — Konjunktiv II keeps it polite while you push for a real '
        'agreement.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'Soften it, then land it',
        text:
            '"Könntest du bitte heute abwaschen? Es wäre wirklich schön, '
            'wenn wir uns auf einen Plan einigen könnten." Two Konjunktiv '
            'forms, zero aggression, full pressure.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_wish_machine',
    title: 'Translate: the wish machine',
    level: 'B1',
    mode: SpeakingMode.translationDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Twelve English wish-and-hypothetical sentences into German '
        'Konjunktiv II — würde, hätte, wäre, könnte. Serve one at a time, '
        're-serve my misses at the end.',
    material:
        'Sentences to serve one at a time (accept any correct German):\n'
        '1. I would like to have more free time.\n'
        '2. If only I were rich!\n'
        '3. Could you help me, please?\n'
        '4. I would travel to Japan.\n'
        '5. We would have a bigger flat if we had more money.\n'
        '6. That would be wonderful!\n'
        '7. I wish I could speak better German.\n'
        '8. Would you come with me?\n'
        '9. If I had time, I would learn the guitar.\n'
        '10. She would never say that.\n'
        '11. It would be better if you asked him.\n'
        '12. I would rather stay at home.',
    practisePoints: [
      'würde + infinitive as the default Konjunktiv II',
      'hätte/wäre/könnte instead of würde-forms',
      'wenn-clauses with the verb at the end',
    ],
    scoringCriteria: [
      'the right Konjunktiv II form',
      'verb-final order in wenn-clauses',
      'natural word order in the main clause',
    ],
    priorityErrors: [
      'würde haben / würde sein instead of hätte / wäre',
      'verb not final in the wenn-clause',
    ],
    intro:
        'A drill for the subjunctive machine: twelve English wishes go in, '
        'twelve German Konjunktiv II sentences come out. Your AI checks each '
        'one on the spot.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Four verbs refuse würde',
        text:
            'haben, sein and the modals keep their own forms: hätte, wäre, '
            'könnte, müsste. Everything else is happy with würde + '
            'infinitive.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_advocatus',
    title: 'Game: Advocatus Diaboli',
    level: 'B1',
    mode: SpeakingMode.wordGame,
    session: _b1Session,
    passScore: 60,
    topic:
        'A disagreement game. You state mild opinions; whatever you say, I '
        'must take the other side — with the right connectors and one fully '
        'inflected adjective phrase per turn.',
    material:
        'Game rules:\n'
        '- You state 5 mild opinions, one per round, for example: Katzen '
        'sind besser als Hunde. / Sommer ist die beste Jahreszeit. / '
        'Frühstück ist die wichtigste Mahlzeit. Keep them light.\n'
        '- Each round I must disagree in 2–3 sentences and my answer MUST '
        'contain: (a) one clause with obwohl, damit or um…zu, and (b) one '
        'noun phrase with an inflected adjective (ein treuer Hund, die '
        'kalte Jahreszeit).\n'
        '- Scoring: 10 points for a valid disagreement, +5 if the '
        'connector clause is correct, +5 if the adjective ending is right. '
        'Missing either requirement = 0 for the round.\n'
        '- 5 rounds, then convert my points (max 100) to the final score.',
    practisePoints: [
      'obwohl and damit with verb-final order',
      'um…zu + infinitive for purpose',
      'Adjective endings under time pressure',
    ],
    scoringCriteria: [
      'a genuine counter-argument each round',
      'correct connector clauses',
      'correct adjective endings',
    ],
    priorityErrors: [
      'verb not final after obwohl/damit',
      'adjective phrase missing or unmarked',
    ],
    intro:
        'Play the devil\'s advocate: whatever your AI claims, you argue the '
        'opposite. Every turn needs a subordinate clause and a properly '
        'dressed adjective — that\'s where the points are.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Build the turn backwards',
        text:
            'Pick your adjective phrase first (ein treuer Hund), then wrap '
            'the connector around it: "Obwohl Katzen unabhängig sind, ist '
            'ein treuer Hund der bessere Freund." Both requirements, one '
            'breath.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_job_ads',
    title: 'Reading: two job ads, one candidate',
    level: 'B1',
    mode: SpeakingMode.readingQa,
    session: _b1Session,
    passScore: 60,
    topic:
        'Two job ads and a candidate profile to read and judge. Ask the '
        'questions in German; question 5 needs a real recommendation with '
        'weil and Konjunktiv II, not just facts from the text.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Anzeige 1 — Café Morgenrot sucht eine freundliche Servicekraft. '
        'Sie arbeiten am Wochenende und an drei Abenden pro Woche. Wir '
        'bieten ein junges Team und flexible Pausen, aber der Lohn ist '
        'nicht hoch. Erfahrung ist nicht nötig.\n'
        'Anzeige 2 — Das Büro Weber und Partner sucht eine zuverlässige '
        'Assistenz. Sie organisieren Termine, schreiben E-Mails und '
        'arbeiten von Montag bis Freitag von neun bis siebzehn Uhr. Gute '
        'Computerkenntnisse sind wichtig, und wir zahlen gut.\n'
        'Profil — Sara ist 26 und sehr ordentlich. Sie hat zwei Jahre in '
        'einem Reisebüro gearbeitet und liebt feste Arbeitszeiten, weil '
        'sie abends einen Sprachkurs besucht. Am Wochenende möchte sie '
        'frei haben. Mit Computern arbeitet sie jeden Tag.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Wann muss man im Café Morgenrot arbeiten?\n'
        '2. Was bietet das Büro Weber und Partner?\n'
        '3. Warum sind feste Arbeitszeiten für Sara wichtig?\n'
        '4. Welche Erfahrung bringt Sara mit?\n'
        '5. Welcher Job würde besser zu Sara passen — und warum? '
        '(My answer must use weil and at least one Konjunktiv II form.)',
    practisePoints: [
      'Reading job ads for conditions, not just keywords',
      'Justifying a judgment with weil (verb final)',
      'Recommending with Konjunktiv II (würde passen, wäre besser)',
    ],
    scoringCriteria: [
      'correct information from all three texts',
      'a reasoned recommendation in question 5',
      'weil-clauses with verb-final order',
    ],
    priorityErrors: [
      'question 5 answered without weil or Konjunktiv',
      'details of the two ads mixed up',
    ],
    intro:
        'Read like a recruiter: two jobs, one candidate. The first four '
        'questions check the facts; the fifth asks for your professional '
        'opinion — in proper B1 German.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The shape of question 5',
        text:
            '"Der Bürojob würde besser passen, weil Sara feste '
            'Arbeitszeiten liebt und am Wochenende frei haben möchte." '
            'Judgment, würde, weil — all three boxes ticked.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_landlord_mail',
    title: 'Write: dear landlord…',
    level: 'B1',
    mode: SpeakingMode.writing,
    session: _b1Session,
    passScore: 60,
    topic:
        'A polite complaint email to a landlord about a broken heater. '
        'Grade the text against the rubric in the material, sentence by '
        'sentence, and quote my best Konjunktiv II line back to me.',
    material:
        'Writing task:\n'
        '- Write an email (8–10 sentences) to your landlord: the heating '
        'in your cold flat has been broken for a week.\n'
        '- Describe the problem, say how it affects you, and make two '
        'polite requests in Konjunktiv II (Könnten Sie…? Es wäre schön, '
        'wenn…).\n'
        '- Use at least 5 noun phrases with inflected adjectives (die '
        'kaputte Heizung, in der kalten Wohnung, ein schneller Termin…).\n'
        'Rubric (grade against this):\n'
        '- Both requests in correct Konjunktiv II (biggest weight).\n'
        '- At least 5 correct adjective endings.\n'
        '- Polite register throughout (Sie-form, greeting and closing).\n'
        '- One subordinate clause with weil, obwohl or damit.',
    practisePoints: [
      'Konjunktiv II requests in formal writing',
      'Adjective endings checked at writing speed',
      'Formal email frame: Sehr geehrte…, Mit freundlichen Grüßen',
    ],
    scoringCriteria: [
      'correct Konjunktiv II requests',
      'adjective endings',
      'register and email structure',
    ],
    priorityErrors: [
      'du-forms slipping into a formal letter',
      'adjectives left without endings',
    ],
    intro:
        'Time to complain in writing — politely. A cold flat, a silent '
        'landlord, and a rubric that rewards Konjunktiv II and dressed-up '
        'adjectives.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Firm content, soft grammar',
        text:
            'The trick of German complaint mail: state facts hard (Die '
            'Heizung ist seit einer Woche kaputt), then request soft '
            '(Könnten Sie bitte…). The Konjunktiv is the velvet glove.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_verb_preps',
    title: 'Words: verbs with prepositions',
    level: 'B1',
    mode: SpeakingMode.vocabDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Verbs that come welded to a preposition. First drill the pairings '
        'both ways, then force me into free sentences about my own life — '
        'one per verb, correct case included.',
    material:
        'Verb + preposition pairs to drill (pair = meaning):\n'
        'sich freuen auf + Akk = to look forward to · '
        'sich freuen über + Akk = to be pleased about · '
        'warten auf + Akk = to wait for · '
        'sich ärgern über + Akk = to be annoyed about · '
        'sich interessieren für + Akk = to be interested in · '
        'denken an + Akk = to think of · '
        'träumen von + Dat = to dream of · '
        'sich kümmern um + Akk = to take care of · '
        'Angst haben vor + Dat = to be afraid of · '
        'sich bedanken für + Akk = to thank for · '
        'sprechen über + Akk = to talk about · '
        'teilnehmen an + Dat = to take part in\n'
        'Phase 2: for each pair, I build one true sentence about myself; '
        'reject any sentence with the wrong preposition or case.',
    practisePoints: [
      'The fixed preposition for each verb',
      'Akkusativ vs Dativ after the preposition',
      'auf vs über with sich freuen (future vs present)',
    ],
    scoringCriteria: [
      'the correct preposition every time',
      'the correct case after it',
      'natural free sentences in phase 2',
    ],
    priorityErrors: [
      'sich freuen auf/über swapped',
      'Dativ after auf or über in these pairs',
    ],
    intro:
        'These verbs never travel alone — each drags its own preposition '
        'and case. Drill the pairs cold, then prove it with sentences about '
        'your real life.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'auf = not here yet',
        text:
            'Ich freue mich AUF das Wochenende (it\'s coming), ich freue '
            'mich ÜBER das Geschenk (it\'s here). auf points forward, über '
            'looks at what you already have.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_dream_job',
    title: 'Tell it: Mein Traumjob',
    level: 'B1',
    mode: SpeakingMode.storytelling,
    session: _b1Session,
    passScore: 60,
    topic:
        'I narrate one full day in my dream job — entirely hypothetical, '
        'entirely in Konjunktiv II. You keep me honest: any indicative '
        'main verb gets flagged and the sentence redone.',
    material:
        'Story skeleton (walk me through it beat by beat):\n'
        '- Beat 1: the morning — how I would get to work, when I would '
        'start (Ich würde…, ich müsste nicht…).\n'
        '- Beat 2: the work itself — what I would do, what I would be '
        '(Ich wäre…, ich hätte…).\n'
        '- Beat 3: the people — what my colleagues would be like, one '
        'inflected adjective phrase (nette Kollegen, einen geduldigen '
        'Chef).\n'
        '- Beat 4: the evening — why this job would make me happy '
        '(one damit or um…zu clause).\n'
        '- Required forms: würde + infinitive at least 5 times, hätte and '
        'wäre at least once each, one damit or um…zu clause.',
    practisePoints: [
      'Sustaining Konjunktiv II across a whole narrative',
      'hätte/wäre woven in among würde-forms',
      'A purpose clause with damit or um…zu',
    ],
    scoringCriteria: [
      'consistent Konjunktiv II throughout',
      'all four beats covered',
      'the required forms actually appearing',
    ],
    priorityErrors: [
      'sliding back into the indicative mid-story',
      'werde/würde confusion',
    ],
    intro:
        'Dream out loud: one whole imaginary workday, and not a single '
        'indicative verb allowed. The longer you hold the Konjunktiv, the '
        'higher the score.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'warning',
        title: 'The third-sentence slide',
        text:
            'Most learners start with "Ich würde…" and slide into "Ich '
            'arbeite…" by sentence three. Hear yourself say a plain present '
            'verb? Stop, smile, redo it with würde.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_job_interview',
    title: 'Roleplay: the friendly job interview',
    level: 'B1',
    mode: SpeakingMode.roleplay,
    session: _b1Session,
    passScore: 60,
    topic:
        'You are a warm, encouraging interviewer at a company I would love '
        'to join; I am the candidate. Ask about my strengths, my '
        'weaknesses, and what I would wish for in the job. Probe at least '
        'twice with a simple "Warum?" and make me go deeper.',
    practisePoints: [
      'Strengths and weaknesses with character adjectives',
      'Wishes in Konjunktiv II (Ich würde mir wünschen…)',
      'Surviving the "Warum?" follow-up with weil-clauses',
    ],
    targetVocabulary: [
      'die Stärke',
      'die Schwäche',
      'die Erfahrung',
      'sich bewerben um',
      'das Gehalt',
      'die Arbeitszeit',
    ],
    scoringCriteria: [
      'full, connected answers (not single words)',
      'correct Konjunktiv II for wishes',
      'adjectives with endings when describing yourself',
    ],
    priorityErrors: [
      'weil-clause without verb-final order',
      'wishes in plain indicative',
    ],
    intro:
        'A job interview with the nicest interviewer alive — which means '
        'no hiding. Twice it will simply ask "Warum?", and that little word '
        'is where the real German happens.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'A weakness that wins',
        text:
            '"Ich bin manchmal zu ungeduldig, obwohl ich daran arbeite." — '
            'an honest adjective plus an obwohl-clause turns a weakness '
            'into a grammar showcase.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m5_gate_roundtable',
    title: 'Module exam: the opinions round-table',
    level: 'B1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 5, minExchanges: 9),
    passScore: 60,
    topic:
        'The closing exam of the module: a round-table on three everyday '
        'theses, one after the other — for example "Homeoffice ist besser '
        'als Büro", "Haustiere gehören nicht in kleine Wohnungen", "Man '
        'sollte mit Freunden nie zusammenwohnen". For each thesis I state '
        'my opinion, defend it against your pushback, and add one wish or '
        'hypothetical in Konjunktiv II.',
    practisePoints: [
      'Opinion phrases: meiner Meinung nach, ich finde, dass…',
      'Konjunktiv II wishes and hypotheticals',
      'Adjective endings in free speech',
      'obwohl/damit/weil with verb-final order',
    ],
    scoringCriteria: [
      'a clear, defended opinion per thesis',
      'correct Konjunktiv II forms',
      'adjective endings and verb-final subordinate clauses',
    ],
    priorityErrors: [
      'wrong adjective endings',
      'malformed Konjunktiv II (würde sein, hätte werden)',
      'verb not final in subordinate clauses',
    ],
    intro:
        'The module gate: three theses, three rounds of opinion, pushback '
        'and wishes. Pass it and B1.2 unlocks — retake it as often as you '
        'like, your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'One frame per round',
        text:
            'Open every round the same way: "Meiner Meinung nach…, weil…. '
            'Trotzdem wäre es schön, wenn…". Opinion, reason, wish — the '
            'whole module in three moves.',
      ),
    ],
  ),
];
