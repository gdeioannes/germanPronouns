import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M12 · C2.2 — *Meisterschaft* (Mastery).
///
/// Can-do: debate any topic spontaneously; mediate between positions;
/// understand dialect-coloured and highly colloquial speech; improvise.
/// Grammar: near-native control audit under pressure; colloquial/dialect
/// awareness (receptive); discourse management (turn-taking, repair);
/// prosody & emphasis in speech.
///
/// C2 session shape: ~6 minutes, 10 exchanges, pass 70; the builder switches the report to German at this level.
const _c2Session = SpeakingSession(durationMinutes: 6, minExchanges: 10);

const List<HelpMemoryTip> _particleTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The particle palette',
    text:
        '**doch** pre-empts contradiction or overturns a negative, **mal** '
        'softens a command, **halt**/**eben** mean resigned „that is just how '
        'it is", **ja** appeals to shared knowledge, **schon** concedes '
        'grudgingly. They sit unstressed after the verb and the pronouns.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Never translate a particle',
    text:
        'A dictionary gloss kills the effect: *doch* is not „but", *mal* is '
        'not „once". Describe what the word DOES to the sentence — pressure, '
        'softening, resignation — and match the register when you reply.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Particles are tone of voice in print',
    text:
        'Whatever an English speaker does with intonation and a raised '
        'eyebrow, German does with a one-syllable particle. Hear each one as '
        'a facial expression, not a word.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„Do come by — it is just around the corner."',
    text: 'Komm **doch mal** kurz vorbei — ist **ja** gleich um die Ecke.',
  ),
];

const List<HelpMemoryTip> _discourseTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The repair kit',
    text:
        '**wie soll ich sagen …** buys thinking time, **anders gesagt** '
        'restarts a failed sentence, **Wo war ich stehen geblieben?** '
        'recovers the thread, **wie dem auch sei** closes a topic and opens '
        'the next. Fillers keep the floor; silence loses it.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Name the swerve',
    text:
        'When the topic jumps, say so out loud: „Wie dem auch sei — zum '
        'neuen Thema." Announcing the turn IS discourse management, and it '
        'buys your brain the second it needs.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Ease shrinks range',
    text:
        'Under surprise or on comfortable topics your grammar quietly '
        'retreats to A2. Plant one **Konjunktiv II**, one **Passiv** and one '
        'Funktionsverbgefüge per answer on purpose until the range comes '
        'uninvited.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„Be that as it may — essentially this is about trust."',
    text:
        '**Wie dem auch sei** — **im Grunde genommen** geht es hier doch um '
        'Vertrauen.',
  ),
];

const List<HelpMemoryTip> _rhetoricTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Concession + counter',
    text:
        'The C2 debate move: **Zugegeben, …** admits the fact, **doch '
        'gerade das …** turns it into support. Reframe hostile questions '
        'with **Die Frage ist doch eher, ob …** — answered, not dodged.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Fronting is a spotlight',
    text:
        'Move the contested word to position 1 and the verb stays second: '
        '„GERADE deshalb stimmt es." Fronting plus a particle (doch, eben, '
        'ja) is the rhetorical one-two of spoken German.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„Granted, that sounds absurd — but exactly that supports it."',
    text:
        '**Zugegeben**, das klingt absurd — **doch gerade das** spricht '
        'dafür.',
  ),
];

const List<HelpMemoryTip> _colloquialTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The contraction map',
    text:
        'Each spoken form expands to exactly one standard form: **isses** = '
        'ist es, **haste** = hast du, **’nen** = einen, **heut** = heute, '
        '**wär** = wäre, **’n Abend** = guten Abend. Decode them like '
        'vocabulary — you rarely need to produce them.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'A contraction can change politeness',
    text:
        '**haste** is not just fast speech — it is „hast du". The speaker '
        'switched to du without asking. Hearing the social move inside the '
        'contraction is the real C2 listening skill.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Swallowed endings, kept skeleton',
    text:
        'Colloquial German drops unstressed vowels and fuses verb + pronoun '
        '(hast du → haste, ist es → isses) but never touches word order. '
        'Find the verb, rebuild the pronoun, and the sentence reappears.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„Is it still far? No idea if one still runs today."',
    text:
        '**Isses** noch weit? Hab keine Ahnung, ob **heut** überhaupt noch '
        'einer fährt.',
  ),
];

const List<HelpMemoryTip> _registerTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Every genre is a grammar package',
    text:
        'Märchen: **Es war einmal** + archaic inversion. Nachrichten: '
        '**Passiv** + attribution (**laut**, **wie verlautete**). '
        'Amtsdeutsch: Nominalstil, **hiermit**, **fristgerecht**. '
        'Werbespot: imperatives, superlatives, direct address. Krimi: terse '
        '**Präteritum**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'The first four words buy the register',
    text:
        'Open with the genre’s loudest signal — „Es war einmal …", „Wie '
        'soeben bekannt wurde …", „Hiermit wird …" — and the listener’s ear '
        'grants you the whole style on credit.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Register slips show in the small words',
    text:
        'One chatty **halt** ruins an Amtsdeutsch sentence; one **hiermit** '
        'ruins a Märchen. Elevated register lives in lexis AND particles — '
        'police both.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„Collection of the key is hereby confirmed as within deadline."',
    text:
        '**Hiermit wird** die fristgerechte Abholung des Schlüssels '
        'bestätigt.',
  ),
];

const List<HelpMemoryTip> _mediationTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Mediation runs on Konjunktiv II',
    text:
        '**Der Kompromiss läge darin, dass …** proposes without imposing; '
        '**Wenn ich Sie richtig verstehe …** mirrors before solving; '
        '**Können wir festhalten, dass …?** locks in agreement; **im '
        'Gegenzug** balances the deal.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: '„ihr müsst" loses the room',
    text:
        'Indicative commands (**müssen**, **sollen**) read as taking sides. '
        'Offer with **läge**, **könnte**, **wäre** — the subjunctive keeps '
        'both parties owners of the solution.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Mirror before you mediate',
    text:
        'Restate each grievance in its owner’s register before proposing '
        'anything — du-register for the informal party, Sie-register for '
        'the formal one. Only a heard party negotiates.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„The compromise would be that both sides give a little."',
    text:
        'Der Kompromiss **läge** darin, dass beide Seiten ein wenig '
        'nachgeben — **im Gegenzug** bleibt es abends ruhig.',
  ),
];

final List<QuizContent> enDeAiM12Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m12_untranslatables',
    title: 'Words: the untranslatables',
    level: 'C2',
    mode: SpeakingMode.vocabDrill,
    session: _c2Session,
    passScore: 70,
    topic:
        'Untranslatables and colloquialisms, served inside mini-dialogues: '
        'I translate the EFFECT of the marked word (not the word), then '
        'answer the dialogue line in matching register.',
    material:
        'Serve each mini-dialogue, mark the target word, ask me for '
        'its effect, then for my in-register reply:\n'
        '1. "Kommst du mit?" — "*Jein* … kommt drauf an, wer noch da ist." '
        '(jein = yes-and-no, hedged)\n'
        '2. "Endlich *Feierabend*!" (Feierabend = the sacred end of the '
        'working day, almost a small holiday)\n'
        '3. "Du kommst *doch* mit, oder?" (doch = hopeful pressure: '
        'contradiction pre-empted)\n'
        '4. "Magst du keinen Kaffee?" — "*Doch*!" (doch = yes-I-do, '
        'overturning a negative)\n'
        '5. "Guck *mal* her." (mal = softener, makes the imperative light)\n'
        '6. "*Haste* mal \'nen Stift?" (haste = hast du, rapid colloquial)\n'
        '7. "Das ist *halt* so." (halt = resigned that\'s-just-how-it-is)\n'
        '8. "Na, *isses* weit noch?" (isses = ist es, spoken contraction)\n'
        '9. "Der Film war ganz gut — aber *eben* kein Meisterwerk." '
        '(eben = precisely-that, confirming a limit)\n'
        '10. "*Na ja*, war schon okay." (na ja = lukewarm concession)\n'
        'For each: half the points for naming the effect precisely, half '
        'for a reply whose register matches the dialogue.\n'
        'Particle cheat sheet (word = effect):\n'
        'doch = contradiction pre-empted, or yes-I-do after a negative · '
        'mal = softener on a command · halt = resigned that’s-just-how-it-is '
        '· eben = precisely so, confirming a limit · jein = yes-and-no, '
        'hedged · Feierabend = the sacred end of the working day · '
        'na ja = lukewarm concession',
    practisePoints: [
      'Explaining the pragmatic effect, not a dictionary gloss',
      'doch in both jobs: pressure particle and yes-I-do',
      'Replying inside the dialogue\'s colloquial register',
    ],
    scoringCriteria: [
      'accurate effect descriptions',
      'register-matched replies',
      'both doch-uses distinguished',
    ],
    priorityErrors: [
      'translating the word instead of its effect',
      'formal replies to colloquial lines',
    ],
    intro:
        'German modal particles carry attitude, not meaning: doch pre-empts '
        'contradiction (or overturns a negative), mal softens a command, '
        'halt and eben signal resigned „that is just how it is". Learn the '
        'EFFECT and the register — no dictionary gloss survives translation.',
    tips: [
      ..._particleTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'doch has two day jobs',
        text:
            'Unstressed inside a sentence, doch nudges ("Komm doch '
            'mit!"). Stressed and alone, it overturns a negative: '
            '"Magst du keinen Kaffee?" — "Doch!" means yes, I do.',
      ),
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Feierabend is a place',
        text:
            'Think of Feierabend as somewhere you GO, not a time: "nach '
            'Feierabend", "schönen Feierabend!" — the workday ends and '
            'a small private festival begins. No English word attends.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_free_talk',
    title: 'No-net free talk',
    level: 'C2',
    mode: SpeakingMode.conversation,
    session: _c2Session,
    passScore: 70,
    topic:
        'Free conversation without a safety net: pick three random topics '
        'of escalating abstraction (an object, a social question, a '
        'philosophical one) and change topic MID-SENTENCE at least twice. '
        'Weight the grading towards flexibility and repair strategies, not '
        'polish.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Wo war ich stehen geblieben? = where was I? · anders gesagt = to '
        'put it another way · Das bringt mich zu … = that brings me to … · '
        'im Grunde genommen = essentially · wie dem auch sei = be that as '
        'it may · wie soll ich sagen … = how shall I put it … · '
        'Moment, ich fange anders an = hold on, let me start again',
    practisePoints: [
      'Following an abrupt topic cut without stalling',
      'Repair phrases: wo waren wir, wie soll ich sagen, Moment',
      'Holding depth even on a topic I did not choose',
    ],
    targetVocabulary: [
      'Wo war ich stehen geblieben?',
      'anders gesagt',
      'Das bringt mich zu …',
      'im Grunde genommen',
      'wie dem auch sei',
    ],
    scoringCriteria: [
      'flexibility across the three topics',
      'repair strategies used, not silence',
      'sustained C2 depth of argument',
    ],
    priorityErrors: [
      'freezing at a topic cut',
      'retreating to B-level simplicity when surprised',
    ],
    intro:
        'C2 fluency is repair, not perfection: „wie soll ich sagen", '
        '„anders gesagt" and „wo war ich stehen geblieben?" hold the floor '
        'while your brain catches up. Naming a topic change out loud — '
        '„wie dem auch sei" — is itself discourse management.',
    tips: [
      ..._discourseTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Name the cut',
        text:
            'When the topic jumps, say so: "Wie dem auch sei — zum neuen '
            'Thema …" Naming the swerve out loud IS discourse management, '
            'and it buys your brain the second it needs.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Repair beats silence',
        text:
            'A native speaker lost for words says "wie soll ich sagen …" '
            'and keeps the floor. Two seconds of silence costs more '
            'than any grammar slip in this exercise.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_absurde_these',
    title: 'Game: Absurde These',
    level: 'C2',
    mode: SpeakingMode.wordGame,
    session: _c2Session,
    passScore: 70,
    topic:
        'The Absurde These game: I draw an absurd thesis and defend it '
        'against your genuine cross-examination. Argue back hard — treat '
        'my thesis as if it mattered.',
    material:
        'Game rules:\n'
        '- Offer me three absurd theses to draw from, e.g.: "Socken '
        'verschwinden nicht — sie emigrieren", "Montage sollten verboten '
        'werden", "Pflanzen hören uns zu und sind enttäuscht".\n'
        '- I defend my drawn thesis for 5 exchanges against real '
        'cross-examination: demand evidence, expose contradictions, '
        'offer tempting outs.\n'
        '- Scoring per exchange: full points for a substantive defence '
        '(concession + counter, analogy, reframing).\n'
        '- Conceding a round costs points; DODGING a question costs '
        'more — an answered absurdity beats an evaded one.\n'
        '- Bonus points for one rhetorical fronting and one correctly '
        'placed particle (doch, eben, ja) per exchange.\n'
        '- After 5 exchanges, convert my points to the final score.',
    practisePoints: [
      'Building arguments for a position I do not hold',
      'Answering hostile questions instead of dodging',
      'Rhetorical tools (fronting, particles) under fire',
    ],
    scoringCriteria: [
      'substantive answers to every question',
      'argumentative structure per exchange',
      'rhetorical bonus moves',
    ],
    priorityErrors: [
      'dodging a direct question',
      'humour used as a substitute for argument',
    ],
    intro:
        'German debate runs on concession plus counter: „Zugegeben, … — '
        'doch gerade das …" admits the fact and keeps the thesis alive, and '
        '„Die Frage ist doch eher, ob …" reframes a hostile question '
        'without dodging it. Fronting plus a particle is the spoken '
        'rhetoric bonus.',
    tips: [
      ..._rhetoricTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Concede the fact, keep the thesis',
        text:
            '"Zugegeben, niemand hat je eine Socke emigrieren sehen — '
            'doch gerade DAS beweist, wie gut sie es planen." Concession '
            'plus reframe answers any question without surrender.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'A joke is not an answer',
        text:
            'The frame is absurd; your moves must not be. If the AI asks '
            '"Wohin emigrieren sie denn?", name a destination and argue '
            'for it. Laughing the question off is scored as a dodge.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_two_voices',
    title: 'Listen: one scene, two voices',
    level: 'C2',
    mode: SpeakingMode.listenRetell,
    session: _c2Session,
    passScore: 70,
    topic:
        'You speak the same short scene twice — once in neutral standard '
        'German, once colloquial and lightly dialect-tinged — and I map '
        'one version onto the other.',
    material:
        'The piece (perform BOTH versions aloud, colloquial one '
        'noticeably faster):\n'
        'Version 1, neutral: "Guten Abend. Ist es noch weit bis zum '
        'Bahnhof? Ich habe meinen Zug verpasst und weiß nicht, ob heute '
        'noch einer fährt. Haben Sie vielleicht einen Fahrplan? Das wäre '
        'wirklich nett von Ihnen."\n'
        'Version 2, colloquial: "\'n Abend! Isses noch weit bis zum '
        'Bahnhof? Hab meinen Zug verpasst und keine Ahnung, ob heut '
        'überhaupt noch einer fährt. Haste vielleicht \'nen Fahrplan? '
        'Wär echt nett."\n'
        'My tasks afterwards:\n'
        '- Retell the scene\'s content once, register-neutral.\n'
        '- Map five pairs across the versions (isses ↔ ist es, haste ↔ '
        'haben Sie, \'nen ↔ einen, heut ↔ heute, wär ↔ das wäre) and '
        'say what each contraction does.\n'
        '- Note the one pair that also shifts POLITENESS, not just sound '
        '(haste = du-form vs. Haben Sie = Sie-form).\n'
        '- Then quiz me: speak two NEW colloquial lines in the same '
        'style and have me render them in neutral standard German.',
    practisePoints: [
      'Decoding contractions at speed (isses, haste, \'nen)',
      'Mapping colloquial onto standard forms precisely',
      'Hearing when a contraction changes politeness, not just sound',
    ],
    scoringCriteria: [
      'complete and correct form mappings',
      'the du/Sie shift spotted',
      'new colloquial lines decoded live',
    ],
    priorityErrors: [
      'contractions mis-expanded',
      'missing the politeness shift in haste',
    ],
    intro:
        'Spoken German contracts systematically: ist es → isses, hast du → '
        'haste, einen → ’nen, heute → heut. Each shrinks to exactly one '
        'standard form — and haste even smuggles in du, so a contraction '
        'can shift politeness, not just sound.',
    tips: [
      ..._colloquialTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Contractions are receptive vocabulary',
        text:
            'You need to UNDERSTAND isses, haste and \'nen instantly — '
            'you rarely need to say them. Decode them like vocabulary: '
            'each one expands to exactly one standard form.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'haste smuggles in du',
        text:
            'haste is not just fast speech — it is "hast du". The '
            'colloquial stranger switched to du without asking. Hearing '
            'that social move inside a contraction is the C2 catch.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_two_texts',
    title: 'Reading: two texts, one event',
    level: 'C2',
    mode: SpeakingMode.readingQa,
    session: _c2Session,
    passScore: 70,
    topic:
        'Two texts about the same event — a satirical column and a sober '
        'report. The questions force me to mediate between their claims '
        'rather than summarise either.',
    material:
        'Text A, satirical column (show it exactly like this):\n'
        '"Es ist vollbracht: Unsere Stadt hat eine Fahrradstraße. Ganze '
        'dreihundert Meter, festlich eröffnet mit Blaskapelle, endend — '
        'man ahnt es — an einer vierspurigen Kreuzung ohne Ampel. Der '
        'Bürgermeister sprach von einem Meilenstein. Ein Meilenstein ist '
        'bekanntlich ein Stein, an dem man vorbeifährt. Die Radfahrer '
        'der Stadt danken es ihm, sofern sie die Kreuzung überleben."\n'
        '\n'
        'Text B, sober report:\n'
        '"Am Samstag wurde die erste Fahrradstraße der Stadt eröffnet. '
        'Der 300 Meter lange Abschnitt in der Gartenstraße ist Teil '
        'eines Konzepts, das bis 2030 insgesamt zwölf Kilometer umfassen '
        'soll. Die Anbindung an die Kreuzung Nordring wird laut '
        'Stadtverwaltung in einem zweiten Bauabschnitt geprüft; ein '
        'Zeitplan hierfür liegt noch nicht vor. Der ADFC begrüßte den '
        'Schritt, mahnte jedoch ein höheres Tempo an."\n'
        '\n'
        'Ask me (one at a time, in German):\n'
        '1. Welchen Sachverhalt bestätigen BEIDE Texte übereinstimmend?\n'
        '2. Die Kreuzung: Was macht die Satire daraus, was der Bericht — '
        'und widersprechen sich die beiden wirklich?\n'
        '3. Wie funktioniert die Meilenstein-Pointe sprachlich?\n'
        '4. Der Bericht schreibt "wird geprüft" und "liegt noch nicht '
        'vor" — was leistet diese Behördensprache, und wie übersetzt '
        'die Satire sie?\n'
        '5. Formulieren Sie EINE faire Zusammenfassung des Ereignisses, '
        'die beiden Texten gerecht wird — je ein Element aus beiden.\n'
        '6. Wo hört die Satire auf zu übertreiben und sagt schlicht die '
        'Wahrheit?',
    practisePoints: [
      'Extracting the shared factual core of opposed texts',
      'Naming how satire transforms a fact',
      'Writing one mediated summary fair to both',
    ],
    scoringCriteria: [
      'facts and spin cleanly separated',
      'satirical mechanics explained, not just felt',
      'the mediated summary balances both texts',
    ],
    priorityErrors: [
      'adopting one text\'s framing as fact',
      'summary that averages instead of mediates',
    ],
    intro:
        'Satire exaggerates around a true core, while administrative German '
        'hides inaction in the passive: „wird geprüft" and „liegt noch '
        'nicht vor" report that nothing has happened yet. Mediating between '
        'two texts means separating the checkable facts from each framing.',
    tips: [
      HelpMemoryTip(
        kind: 'tip',
        title: 'Satire exaggerates around a true bone',
        text:
            'Strip each satirical sentence to its checkable core: the '
            'Blaskapelle may be invented, the unguarded crossing is not. '
            'Mediation starts by sorting bone from flesh.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: '"wird geprüft" is a verdict',
        text:
            'Administrative passive ("wird geprüft", "liegt noch nicht '
            'vor") reports inaction in the costume of action. Reading '
            'that costume is C2 comprehension of the sober text too.',
      ),
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Mediate, don’t average',
        text:
            'A fair summary takes one verified element from EACH text — '
            'the opened 300 metres from the report, the still-unguarded '
            'crossing the satire points at — never the midpoint of their '
            'moods.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: '„The section is open; a link to the crossing is pending."',
        text:
            'Der Abschnitt **ist eröffnet** — die Anbindung an die Kreuzung '
            '**steht** allerdings **noch aus**.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_flatmate_mediation',
    title: 'Scene: the flatmate war',
    level: 'C2',
    mode: SpeakingMode.roleplay,
    session: _c2Session,
    passScore: 70,
    topic:
        'Mediation: you play BOTH flatmates in clearly different voices — '
        'Jonas (colloquial, hurt, interrupts) and Frau Petrova (formal, '
        'icy, precise) — at war over noise, cleaning and a broken lamp. I '
        'broker a compromise and, at the end, dictate it as a short '
        'written agreement both explicitly accept. Do not let either '
        'accept it until it addresses their core grievance.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Wenn ich Sie richtig verstehe … = if I understand you correctly … '
        '· beide Seiten = both sides · Der Kompromiss läge darin, dass … = '
        'the compromise would be that … · Können wir festhalten, dass …? = '
        'can we agree on record that …? · im Gegenzug = in return · Was '
        'bräuchten Sie, damit …? = what would you need so that …?',
    practisePoints: [
      'Mirroring each party in their own register',
      'Mediation language: beide Seiten, der Kompromiss läge darin',
      'Dictating a precise written agreement both accept',
    ],
    targetVocabulary: [
      'Wenn ich Sie richtig verstehe …',
      'beide Seiten',
      'Der Kompromiss läge darin, dass …',
      'Können wir festhalten, dass …?',
      'im Gegenzug',
    ],
    scoringCriteria: [
      'each party addressed in a fitting register',
      'grievances surfaced before solutions offered',
      'final agreement precise and accepted by both',
    ],
    priorityErrors: ['taking sides', 'one register used for both parties'],
    intro:
        'Mediation German runs on Konjunktiv II: „Der Kompromiss läge '
        'darin, dass …" proposes without imposing, and „Wenn ich Sie '
        'richtig verstehe …" mirrors a grievance before solving it. Address '
        'each party in their own register — du for Jonas, Sie for Frau '
        'Petrova.',
    tips: [
      ..._mediationTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Mirror before you mediate',
        text:
            'Restate each grievance in its owner\'s register: to Jonas '
            '"Dich nervt, dass du ständig der Böse bist", to Frau '
            'Petrova "Sie wünschen sich verbindliche Absprachen." Only '
            'a heard party negotiates.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The Konjunktiv of peace',
        text:
            '"Der Kompromiss läge darin, dass …" — the Konjunktiv II '
            'offers without imposing. A mediator who says "ihr müsst" '
            'has already lost the room.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_plant_eulogy',
    title: 'Write: eulogy for a houseplant',
    level: 'C2',
    mode: SpeakingMode.writing,
    session: _c2Session,
    passScore: 70,
    topic:
        'The hardest brief in the course: a eulogy for a deceased '
        'houseplant, in genuine, dignified eulogy register — graded on the '
        'tone tightrope, never on jokes.',
    material:
        'Writing task:\n'
        '- Write a eulogy (120–150 words) for Ficus "Herbert", who stood '
        'eight years by the office window and has died of neglect during '
        'the summer holidays.\n'
        '- The register is REAL eulogy German: elevated, warm, measured '
        '— Trauerrede, not sketch comedy. The absurdity lives entirely '
        'in the subject; the language never winks.\n'
        'Rubric (grade against this):\n'
        '- Tone tightrope (biggest weight): every sentence must be '
        'sayable at a real funeral. One joke word or ironic aside = '
        'points off; unearned pathos ("Held", "Tragödie") likewise.\n'
        '- Eulogy conventions present: address to the mourners, a '
        'remembered virtue, a shared memory, a farewell formula.\n'
        '- Elevated but living register: Konjunktiv and formal lexis '
        'without museum stiffness.\n'
        '- Structure: opening address → life → what he gave us → '
        'farewell.',
    practisePoints: [
      'Holding a dignified register over an absurd subject',
      'Eulogy conventions: address, virtue, memory, farewell',
      'Elevated lexis that stays warm, not stiff',
    ],
    scoringCriteria: [
      'tone control sentence by sentence',
      'all four eulogy conventions present',
      'register elevated yet natural',
    ],
    priorityErrors: [
      'winking at the reader',
      'pathos the subject cannot carry',
    ],
    intro:
        'The German Trauerrede has fixed conventions: an address to the '
        'mourners, a remembered virtue, a shared memory, a farewell formula '
        '— all in elevated, measured lexis with Konjunktiv. Holding that '
        'register over an absurd subject is pure tone control.',
    tips: [
      ..._registerTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Play it straight or not at all',
        text:
            'The comedy is structural: solemn form, absurd subject. Add '
            'a joke and you have neither comedy nor register control. '
            'Write as if Herbert\'s family were in the second row.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'Dignity, plant-sized',
        text:
            '"Er verlangte wenig: Licht, ein wenig Wasser, dann und '
            'wann ein gutes Wort. Nicht einmal das Wenige haben wir '
            'ihm zuverlässig gegeben." True, measured, and it holds.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_chain_story',
    title: 'Tell it: the genre-shift chain',
    level: 'C2',
    mode: SpeakingMode.storytelling,
    session: _c2Session,
    passScore: 70,
    topic:
        'An improvised chain story: we alternate sentences, and you inject '
        'genre shifts by announcing the new genre before your sentence. My '
        'next sentence must land the new register instantly while keeping '
        'the story coherent.',
    material:
        'Story skeleton and rules:\n'
        '- Seed: "Als Frau Berger am Montag ihren Briefkasten öffnete, '
        'lag darin ein einzelner, sehr alter Schlüssel." You start.\n'
        '- We alternate single sentences. Every 2–3 turns you call a '
        'genre shift BEFORE your sentence: Krimi → Märchen → '
        'Nachrichtensprecher → Werbespot → Behördenschreiben (use at '
        'least four of these, any order).\n'
        '- Required register markers I must hit: Krimi = terse präteritum '
        'and menace; Märchen = "Es war einmal"-tone, inversion, archaic '
        'flavour; Nachrichten = neutral report, passive, attribution; '
        'Werbespot = imperatives, superlatives, direct address; '
        'Behördenschreiben = nominal style, "hiermit", "fristgerecht".\n'
        '- Continuity rule: the key, Frau Berger and one detail from the '
        'previous sentence must survive every shift.\n'
        '- Score each of my sentences for register accuracy AND story '
        'continuity; a perfect register that breaks the story earns '
        'half.\n'
        'Genre openers I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Es war einmal … = once upon a time … · Wie soeben bekannt wurde … '
        '= as has just been reported … · Hiermit wird bestätigt, dass … = '
        'it is hereby confirmed that … · fristgerecht = within the '
        'deadline · Greifen Sie jetzt zu! = grab yours now! · Es war eine '
        'mondlose Nacht = it was a moonless night',
    practisePoints: [
      'Instant register hits on an announced genre',
      'Keeping story continuity through every shift',
      'Genre markers: Präteritum menace, Märchen inversion, '
          'Amtsdeutsch nominal style',
    ],
    scoringCriteria: [
      'register accuracy per genre sentence',
      'continuity of key, character and detail',
      'speed — no stalling before a shifted sentence',
    ],
    priorityErrors: [
      'genre markers missed or mixed',
      'story reset instead of continued',
    ],
    intro:
        'Every German genre is a grammar package: Märchen opens with „Es '
        'war einmal" and archaic inversion, news runs on passive plus '
        'attribution, Amtsdeutsch on Nominalstil and „hiermit", ads on '
        'imperatives and superlatives. The first four words of a sentence '
        'buy the whole register.',
    tips: [
      ..._registerTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Lead with the marker',
        text:
            'Open the shifted sentence with the genre\'s loudest signal: '
            '"Es war einmal …" for Märchen, "Wie soeben bekannt wurde …" '
            'for Nachrichten, "Hiermit wird …" for Amtsdeutsch. The '
            'first four words buy the whole register.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Continuity is half the score',
        text:
            'A dazzling Werbespot sentence that forgets the key earns '
            'half. Before speaking, grab one noun from the previous '
            'sentence and carry it across the genre border with you.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_capstone_interview',
    title: 'Capstone rehearsal interview',
    level: 'C2',
    mode: SpeakingMode.interview,
    session: _c2Session,
    passScore: 70,
    topic:
        'The capstone rehearsal: a ten-question full-range interview in '
        'which A1 topics demand C2 answers. Ask beginner questions — '
        'family, hobbies, my town, food, weekend — and require essayist '
        'depth: nuance, structure, imagery, register control ("Erzählen '
        'Sie von Ihrer Familie — als Essayist").',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'im Grunde genommen = essentially · Es ließe sich sagen, dass … = '
        'one could say that … · wobei = although, come to think of it · '
        'nicht zuletzt = not least · gewissermaßen = in a sense · streng '
        'genommen = strictly speaking · eine Rolle spielen = to play a '
        'part',
    practisePoints: [
      'Elevating trivial topics to essayistic depth',
      'Full grammar range recycled: Konjunktiv, passive, FVG',
      'Structure and imagery inside spoken answers',
    ],
    scoringCriteria: [
      'depth and structure per answer',
      'range of grammar deployed naturally',
      'register consistency at essay height',
    ],
    priorityErrors: [
      'A1-sized answers to A1-sized questions',
      'grammar range narrowing under ease',
    ],
    intro:
        'Simple topics deserve full grammar: answer the fact, then the '
        'meaning — planting Konjunktiv II, a passive and a '
        'Funktionsverbgefüge on purpose until the range comes uninvited. '
        'Essayistic depth means structure and imagery even about your '
        'weekend.',
    tips: [
      ..._discourseTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Simple question, layered answer',
        text:
            'Answer the fact, then the meaning: "Am Wochenende koche '
            'ich — wobei Kochen für mich weniger Ernährung ist als die '
            'einzige Stunde, in der niemand etwas von mir will." Fact, '
            'then essay.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m12_gate_salon',
    title: 'Finale: Der Salon',
    level: 'C2',
    mode: SpeakingMode.roleplay,
    session: SpeakingSession(durationMinutes: 6, minExchanges: 12),
    passScore: 70,
    topic:
        'The finale: "Der Salon". I host a dinner party; you play THREE '
        'guests in distinct voices: a pedant who corrects everything '
        '(formal, precise), a provocateur who drops outrageous theses '
        '(sharp, baiting), and a mumbler who speaks in fast colloquial '
        'contractions (isses, haste, \'nen). Rotate them, let them talk '
        'over each other, and make me host all three for the full twelve '
        'exchanges: soothe the pedant, parry the provocateur, decode the '
        'mumbler, and keep one conversation alive between them.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Was sagen Sie denn dazu? = and what do YOU say to that? · Da muss '
        'ich kurz einhaken = let me jump in there · Wie meinst du das '
        'genau? = what exactly do you mean? · Darauf kommen wir gleich '
        'zurück = we will come back to that in a moment · eins nach dem '
        'anderen = one thing at a time · Da ist was dran, und doch … = '
        'there is something to that, and yet …',
    practisePoints: [
      'Register agility across three simultaneous voices',
      'Discourse management: turn-taking, soothing, redirecting',
      'Decoding colloquial speech live and relaying it upward',
      'Grace under provocation — parry without escalation',
    ],
    scoringCriteria: [
      'each guest answered in a fitting register',
      'the table held together as one conversation',
      'mumbler decoded and provocations parried',
    ],
    priorityErrors: [
      'register agility failures between guests',
      'losing control of the table',
      'everything — this is the finale',
    ],
    intro:
        'Hosting a table takes register agility plus discourse management: '
        'full formal for the pedant, cool concession-and-counter for the '
        'provocateur, relaxed du and live decoding (isses, haste, ’nen) '
        'for the mumbler. Relaying — „Was sagen Sie denn dazu?" — keeps '
        'one conversation alive between them.',
    tips: [
      ..._mediationTips,
      ..._colloquialTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Be the table\'s conductor',
        text:
            'Relay between guests instead of answering each alone: '
            '"Herr Doktor, was sagen SIE denn zu dieser These?" — '
            'handing the provocateur to the pedant is peak discourse '
            'management, and it buys you a breath.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Three guests, three registers',
        text:
            'Pedant: full formal, concede precision gladly. '
            'Provocateur: cool, one concession then a counter. '
            'Mumbler: relaxed du-register — and if you missed it, '
            '"Wie meinst du das genau?" is a host\'s right.',
      ),
    ],
  ),
];
