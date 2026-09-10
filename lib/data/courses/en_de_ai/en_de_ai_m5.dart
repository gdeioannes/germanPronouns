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

/// Adjective declension: the three patterns.
const List<HelpMemoryTip> _adjTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Weak endings after der/die/das',
    text:
        'After the definite article the adjective relaxes to just -e or -en: '
        'der nett**e** Nachbar, den nett**en** Nachbarn, mit dem nett**en** '
        'Nachbarn, die nett**en** Kollegen. Only nominative singular (and '
        'feminine/neuter accusative) get -**e**; everything else is -**en**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Mixed endings after ein/kein/mein',
    text:
        'Where ein shows nothing, the adjective shows the gender itself: ein '
        'nett**er** Kollege, ein nett**es** Team, eine nett**e** Chefin. In '
        'all other slots it falls back to -en: mit einem nett**en** Menschen, '
        'ohne den nett**en** Mitbewohner.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Strong endings with no article',
    text:
        'No article at all? The adjective wears the der-word ending itself: '
        'nett**e** Freunde, mit nett**en** Freunden, frisch**es** Brot, '
        'gut**er** Kaffee. The case marker has to live somewhere.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Someone must show the case',
    text:
        'One rule behind all three tables: exactly one word in the phrase '
        'carries the strong case signal. If the article shows it (d**er**, '
        'd**em**, ein**em**), the adjective relaxes; if the article is silent '
        'or missing, the adjective steps up. And the whole plural after an '
        'article, plus every dative and genitive, is safe -**en**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'A reliable colleague helps me with the difficult task',
    text: 'Ein zuverlässig**er** Kollege hilft mir mit der schwierig**en** Aufgabe.',
  ),
];

/// Konjunktiv II present: würde, hätte, wäre, könnte.
const List<HelpMemoryTip> _konjTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'würde + infinitive is the default',
    text:
        'ich würd**e**, du würd**est**, er/sie/es würd**e**, wir würd**en**, '
        'ihr würd**et**, sie/Sie würd**en** — plus the infinitive at the very '
        'end: Ich **würde** nach Japan **reisen**. Heute **würde** ich zu '
        'Hause **bleiben**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Four verbs refuse würde',
    text:
        'haben, sein and the modals keep their own Konjunktiv forms: '
        '**hätte**, **wäre**, **könnte**, **müsste** (likewise dürfte, '
        'sollte). Ich **hätte** gern mehr Zeit. Das **wäre** schön. '
        '**Könntest** du mir helfen?',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Never „würde sein" or „würde haben"',
    text:
        'The classic B1 giveaway. It is always **wäre** (not würde sein) and '
        '**hätte** (not würde haben). In a wenn-clause the verb also goes to '
        'the very end: …, wenn ich mehr Geld **hätte**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Umlaut = unreal',
    text:
        'The two little dots are the unreality signal: h**ä**tte, w**ä**re, '
        'k**ö**nnte, m**ü**sste. Hear an umlaut on one of these verbs and '
        'you know the sentence is a wish, not a fact.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'If I had time, I would learn the guitar',
    text: 'Wenn ich Zeit **hätte**, **würde** ich Gitarre lernen.',
  ),
];

/// Reflexive verbs and verbs welded to a preposition.
const List<HelpMemoryTip> _prepTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Learn verb + preposition + case as one word',
    text:
        'sich freuen **auf** + Akk, warten **auf** + Akk, sich ärgern '
        '**über** + Akk, sich interessieren **für** + Akk, denken **an** + '
        'Akk, träumen **von** + Dat, Angst haben **vor** + Dat, teilnehmen '
        '**an** + Dat. The preposition is not logical — it is part of the '
        'verb, so memorise the trio together.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The reflexive pronoun set',
    text:
        'ich freue **mich**, du freust **dich**, er/sie freut **sich**, wir '
        'freuen **uns**, ihr freut **euch**, sie freuen **sich**. The '
        'pronoun is obligatory — „ich ärgere über…" without **mich** is '
        'simply broken.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'auf and über take Akkusativ here',
    text:
        'In these fixed pairings auf and über always govern the '
        '**Akkusativ**: ich warte auf **den** Bus, ich ärgere mich über '
        '**die** E-Mail. Only the verbs listed with Dat (träumen von, Angst '
        'haben vor, teilnehmen an) take the dative.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'auf = not here yet',
    text:
        'Ich freue mich **auf** das Wochenende (it is still coming), ich '
        'freue mich **über** das Geschenk (it is already here). **auf** '
        'points forward, **über** looks at what you already have.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'I am looking forward to the weekend',
    text: 'Ich freue **mich auf** das Wochenende.',
  ),
];

/// Subordinate clauses: obwohl, damit, um…zu.
const List<HelpMemoryTip> _nebenTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'obwohl and damit kick the verb to the end',
    text:
        'Like weil and dass, they open a Nebensatz with the finite verb '
        'last: **Obwohl** es **regnet**, gehe ich raus. Ich spreche langsam, '
        '**damit** du mich **verstehst**. After a fronted Nebensatz the main '
        'clause starts with its verb.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'um…zu or damit?',
    text:
        'Same subject in both halves → **um … zu** + infinitive: Ich lerne '
        'Deutsch, **um** in Berlin **zu arbeiten**. Different subjects → '
        '**damit** + full clause: Ich koche heute, **damit** du dich '
        '**ausruhen kannst**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Verb-final means truly final',
    text:
        'Everything else comes first, the conjugated verb closes the door: '
        'obwohl ich seit einer Woche jeden Tag im kalten Büro **sitze**. '
        'Slipping the verb into second position after obwohl is the error '
        'graders hear first.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Although I am tired, I am still going jogging today',
    text: '**Obwohl** ich müde **bin**, gehe ich heute noch joggen.',
  ),
];

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
        'Any adjective standing before a noun must carry an ending, and the '
        'ending depends on what the article already shows: der nette '
        'Nachbar, ein netter Kollege, nette Freunde. Three patterns — weak, '
        'mixed, strong — cover every case.',
    tips: _adjTips,
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to use '
        'them:\n'
        'könntest du bitte abwaschen? = could you please do the dishes? · '
        'ich ärgere mich über die volle Spüle = I am annoyed about the full '
        'sink · es wäre schön, wenn … = it would be nice if … · '
        'ich hätte einen Vorschlag = I would have a suggestion · '
        'wir sollten uns auf einen Putzplan einigen = we should agree on a '
        'cleaning rota · der Abwasch = the washing-up',
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
        'Konjunktiv II is German diplomacy: „Könntest du…?" and „Es wäre '
        'schön, wenn…" turn a demand into a polite request. State the facts '
        'hard, make the requests soft — that is how a flat-share conflict '
        'ends in a rota instead of a feud.',
    tips: [
      ..._konjTips,
      HelpMemoryTip(
        kind: 'example',
        title: 'Could you please do the dishes today? (soften it, then land it)',
        text:
            '**Könntest** du bitte heute abwaschen? Es **wäre** wirklich '
            'schön, wenn wir uns auf einen Putzplan einigen **könnten**.',
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
        'Sentences to serve one at a time (read me only the English half; '
        'the German after „=" is the reference answer — accept any other '
        'correct German too):\n'
        '1. I would like to have more free time. = Ich hätte gern mehr '
        'Freizeit.\n'
        '2. If only I were rich! = Wenn ich doch reich wäre!\n'
        '3. Could you help me, please? = Könntest du mir bitte helfen?\n'
        '4. I would travel to Japan. = Ich würde nach Japan reisen.\n'
        '5. We would have a bigger flat if we had more money. = Wir hätten '
        'eine größere Wohnung, wenn wir mehr Geld hätten.\n'
        '6. That would be wonderful! = Das wäre wunderbar!\n'
        '7. I wish I could speak better German. = Ich wünschte, ich könnte '
        'besser Deutsch sprechen.\n'
        '8. Would you come with me? = Würdest du mitkommen?\n'
        '9. If I had time, I would learn the guitar. = Wenn ich Zeit hätte, '
        'würde ich Gitarre lernen.\n'
        '10. She would never say that. = Das würde sie nie sagen.\n'
        '11. It would be better if you asked him. = Es wäre besser, wenn du '
        'ihn fragen würdest.\n'
        '12. I would rather stay at home. = Ich würde lieber zu Hause '
        'bleiben.',
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
        'Almost every German verb builds its hypothetical with würde + '
        'infinitive; only haben, sein and the modals keep their own forms — '
        'hätte, wäre, könnte, müsste. Twelve English wishes go in, twelve '
        'Konjunktiv II sentences come out.',
    tips: _konjTips,
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
        'obwohl concedes a point, damit and um…zu give a purpose — and all '
        'of them push the verb to the end of the clause. In this game every '
        'counter-argument must carry one such clause plus one properly '
        'inflected adjective phrase.',
    tips: [
      ..._nebenTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Build the turn backwards',
        text:
            'Pick your adjective phrase first (ein treu**er** Hund), then '
            'wrap the connector around it: „**Obwohl** Katzen unabhängig '
            '**sind**, ist ein treuer Hund der bessere Freund." Both '
            'requirements, one breath.',
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
        'A recommendation needs two tools: Konjunktiv II for the judgment '
        '(würde passen, wäre besser) and weil for the reason — with the '
        'verb at the very end of the weil-clause. Read the two ads and the '
        'profile like a recruiter, then commit to a verdict.',
    tips: [
      ..._konjTips,
      HelpMemoryTip(
        kind: 'example',
        title: 'The shape of question 5 (judgment + würde + weil)',
        text:
            'Der Bürojob **würde** besser zu Sara passen, **weil** sie feste '
            'Arbeitszeiten liebt und am Wochenende frei haben **möchte**.',
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
        '- One subordinate clause with weil, obwohl or damit.\n'
        'Building blocks I have studied (phrase = meaning):\n'
        'Sehr geehrter Herr … = Dear Mr … · die Heizung ist seit einer '
        'Woche kaputt = the heating has been broken for a week · Könnten '
        'Sie bitte einen Techniker schicken? = could you please send a '
        'technician? · es wäre schön, wenn … = it would be nice if … · '
        'Mit freundlichen Grüßen = kind regards',
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
        'A formal German complaint states the facts in the indicative (Die '
        'Heizung ist seit einer Woche kaputt) and makes its requests in '
        'Konjunktiv II with the Sie-form (Könnten Sie…?). Frame it with '
        '„Sehr geehrte…" and „Mit freundlichen Grüßen" and it lands.',
    tips: [
      ..._konjTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Firm content, soft grammar',
        text:
            'The trick of German complaint mail: state facts hard (Die '
            'Heizung **ist** seit einer Woche kaputt), then request soft '
            '(**Könnten** Sie bitte…). The Konjunktiv is the velvet glove.',
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
        'Many German verbs come welded to one fixed preposition and its '
        'case: warten auf + Akkusativ, träumen von + Dativ. The preposition '
        'is not guessable from English, so learn verb, preposition and case '
        'as a single vocabulary item.',
    tips: _prepTips,
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
        'wäre at least once each, one damit or um…zu clause.\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich würde von zu Hause arbeiten = I would work from home · '
        'ich müsste nicht früh aufstehen = I would not have to get up '
        'early · ich hätte nette Kollegen = I would have nice colleagues · '
        'ich wäre mein eigener Chef = I would be my own boss · '
        'damit ich mehr Zeit für meine Familie hätte = so that I would '
        'have more time for my family',
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
        'A hypothetical story lives or dies on consistency: every main verb '
        'stays in Konjunktiv II — würde + infinitive for most verbs, hätte '
        'and wäre for haben and sein. One plain present verb and the dream '
        'collapses back into reality.',
    tips: [
      ..._konjTips,
      HelpMemoryTip(
        kind: 'warning',
        title: 'The third-sentence slide',
        text:
            'Most learners start with „Ich **würde**…" and slide into „Ich '
            'arbeite…" by sentence three. Hear yourself say a plain present '
            'verb? Stop, smile, redo it with **würde**.',
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to use '
        'them:\n'
        'meine größte Stärke ist … = my greatest strength is … · '
        'ich bin manchmal zu ungeduldig = I am sometimes too impatient · '
        'ich würde mir wünschen, dass … = I would wish that … · '
        'ich habe mich um die Stelle beworben = I have applied for the '
        'position · ich interessiere mich für Teamarbeit = I am interested '
        'in teamwork · ich habe zwei Jahre Erfahrung = I have two years of '
        'experience',
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
        'Interview German runs on three gears: character adjectives with '
        'endings for who you are, Konjunktiv II for what you would wish '
        '(Ich würde mir wünschen…), and weil-clauses — verb at the end — '
        'for every „Warum?" that follows.',
    tips: [
      ..._konjTips,
      HelpMemoryTip(
        kind: 'example',
        title: 'A weakness that wins (honest adjective + obwohl-clause)',
        text: 'Ich bin manchmal zu **ungeduldig**, obwohl ich daran **arbeite**.',
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to use '
        'them:\n'
        'meiner Meinung nach = in my opinion · '
        'ich finde, dass … = I think that … · '
        'da bin ich anderer Meinung = I disagree there · '
        'es wäre besser, wenn … = it would be better if … · '
        'obwohl das stimmt = although that is true · '
        'einerseits … andererseits = on the one hand … on the other hand',
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
        'Everything from the module in one arena: open with an opinion '
        'frame (meiner Meinung nach, ich finde, dass…), defend it in a '
        'verb-final weil- or obwohl-clause, and finish each round with a '
        'wish in Konjunktiv II. Pass it and B1.2 unlocks.',
    tips: [
      ..._nebenTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'One frame per round',
        text:
            'Open every round the same way: „Meiner Meinung nach…, '
            '**weil**…. Trotzdem **wäre** es schön, **wenn**…". Opinion, '
            'reason, wish — the whole module in three moves.',
      ),
    ],
  ),
];
