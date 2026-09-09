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

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

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
        'for a reply whose register matches the dialogue.',
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
        'The words no dictionary can hand you: jein, Feierabend, the many '
        'lives of doch. Your AI serves them in tiny dialogues and grades '
        'whether you feel what they do, not what they "mean".',
    tips: [
      _copyTip,
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
        'No material, no preparation, no mercy: three topics you did not '
        'pick, cut mid-sentence. The score rewards how gracefully you '
        'wobble — repair is the skill, not perfection.',
    tips: [
      _copyTip,
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
        'Defend the sock conspiracy like your career depends on it. The '
        'joke is the frame; the graded content is pure argumentation '
        'under cross-examination — dodging costs more than losing.',
    tips: [
      _copyTip,
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
        'The listening skill C2 actually demands: real people mumble, '
        'contract and drop syllables. You hear the polished and the '
        'street version of one scene and prove you can map between them.',
    tips: [
      _copyTip,
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
        'One bike lane, two truths. The satirist and the reporter agree '
        'on more than they seem to — your job is to find exactly where, '
        'and to write the one summary both could sign.',
    tips: [
      _copyTip,
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
        'Two furious flatmates, one of you. You must speak Jonas\'s '
        'language AND Frau Petrova\'s, find what each actually needs, '
        'and leave the room with a written deal both say yes to.',
    tips: [
      _copyTip,
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
        'A eulogy for a ficus, written completely straight. If it makes '
        'the reader smile, the smile must come from the situation — the '
        'moment your language winks, you have fallen off the rope.',
    tips: [
      _copyTip,
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
        'half.',
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
        'One story, five voices, no time to think. The AI calls "Märchen!" '
        'and your very next sentence must sound centuries old — while '
        'Frau Berger and her key march on unbroken.',
    tips: [
      _copyTip,
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
        'Not the gate — the dress rehearsal. Easy questions are the '
        'trap: "Was machst du am Wochenende?" now demands an essayist\'s '
        'answer. Prove the whole staircase lives in one voice.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Simple question, layered answer',
        text:
            'Answer the fact, then the meaning: "Am Wochenende koche '
            'ich — wobei Kochen für mich weniger Ernährung ist als die '
            'einzige Stunde, in der niemand etwas von mir will." Fact, '
            'then essay.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Ease shrinks range',
        text:
            'On comfortable topics your grammar quietly retreats to '
            'A2. Plant one Konjunktiv, one passive and one FVG per '
            'answer on purpose until the range comes uninvited.',
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
        'The last door of the course: one dinner party, three impossible '
        'guests, twelve exchanges. Everything you have built — registers, '
        'repair, mediation, particles — sits at this table. Host it.',
    tips: [
      _copyTip,
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
