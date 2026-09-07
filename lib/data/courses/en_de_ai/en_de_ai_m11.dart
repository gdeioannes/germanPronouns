import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M11 · C2.1 — *Stilsicherheit* (Stylistic command).
///
/// Can-do: switch registers on demand; write professional prose; deploy
/// Funktionsverbgefüge and precise collocations; persuade.
/// Grammar: Funktionsverbgefüge; the register system (formal/neutral/
/// colloquial triplets); advanced word order for emphasis (Vorfeld
/// manipulation, Ausklammerung); precision collocations.
///
/// C2 session shape: ~6 minutes, 10 exchanges, pass 70; report in German.
const _c2Session = SpeakingSession(durationMinutes: 6, minExchanges: 10);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM11Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m11_fvg_drill',
    title: 'Words: Funktionsverbgefüge',
    level: 'C2',
    mode: SpeakingMode.vocabDrill,
    session: _c2Session,
    passScore: 70,
    topic:
        'Drill Funktionsverbgefüge against their simple-verb equivalents, '
        'both directions, with a one-line register comment on each: when the '
        'FVG lifts the sentence and when it just stiffens it. Write the '
        'final report in German.',
    material:
        'FVG = simple verb (drill both directions):\n'
        'in Erwägung ziehen = erwägen · zur Verfügung stellen = bereitstellen '
        '· in Anspruch nehmen = beanspruchen · zum Ausdruck bringen = '
        'ausdrücken · in Frage stellen = anzweifeln · zur Sprache bringen = '
        'ansprechen · in Kraft treten = gelten (ab) · Kritik üben an = '
        'kritisieren · eine Entscheidung treffen = entscheiden · in Kauf '
        'nehmen = hinnehmen · zum Abschluss bringen = abschließen · unter '
        'Beweis stellen = beweisen · in Betracht ziehen = berücksichtigen · '
        'Bezug nehmen auf = sich beziehen auf · zur Kenntnis nehmen = '
        'wahrnehmen\n'
        'Register triplets (colloquial · neutral · formal):\n'
        'kriegen · bekommen · erhalten\n'
        'kapieren · verstehen · nachvollziehen\n'
        'anfangen · beginnen · in Angriff nehmen\n'
        'For each miss: I build one sentence with the FVG, you judge whether '
        'the simple verb would have been the better choice there.',
    practisePoints: [
      'FVG → simple verb and back, instantly',
      'Choosing the right rung of a register triplet',
      'Sensing when an FVG elevates and when it merely inflates',
    ],
    scoringCriteria: [
      'correct pairings both directions',
      'sound register judgement',
      'idiomatic sentences with the FVG',
    ],
    priorityErrors: [
      'wrong preposition inside an FVG',
      'FVG used where the simple verb is natural',
    ],
    intro:
        'C2 begins with the machinery of formal German: function-verb '
        'phrases. You drill each pair both ways and, more importantly, '
        'argue about when each version belongs.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The preposition is part of the phrase',
        text:
            'FVG are frozen: IN Erwägung ziehen, ZUR Verfügung stellen, '
            'UNTER Beweis stellen. Swap the preposition and the phrase '
            'collapses — learn each one as a single unbreakable unit.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Elevation, not decoration',
        text:
            'An FVG in a WhatsApp message reads as parody. "Ich ziehe in '
            'Erwägung, Pizza zu bestellen" is a joke — the drill grades '
            'you on knowing that.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_register_slider',
    title: 'Game: the register slider',
    level: 'C2',
    mode: SpeakingMode.wordGame,
    session: _c2Session,
    passScore: 70,
    topic:
        'The register slider: one message, three audiences. You name a '
        'random audience, I re-voice the same content for it on the spot. '
        'Write the final report in German.',
    material:
        'Game rules:\n'
        '- Each round you give me one piece of content (e.g. "the meeting '
        'is moved to Friday and you are annoyed about it").\n'
        '- Then you name ONE random audience: eine Behörde (formal letter '
        'voice), eine Kollegin (neutral spoken), or WhatsApp an einen '
        'Freund (colloquial, particles welcome).\n'
        '- I deliver the message instantly in that register.\n'
        '- 10 points for pure register, 5 if it wobbles, 0 if one wrong-'
        'register word slips in (kriegen to the Behörde, erhalten to the '
        'friend).\n'
        '- 6 rounds, each with a fresh content + audience pair; convert my '
        'points to the final score.',
    practisePoints: [
      'Formal register: FVG, erhalten, distance, no particles',
      'Colloquial register: kriegen, halt, mal, contractions',
      'Switching instantly without losing the content',
    ],
    scoringCriteria: [
      'register purity per round',
      'content preserved across versions',
      'speed of the switch',
    ],
    priorityErrors: ['register bleed', 'content dropped in translation'],
    intro:
        'A game with one skill at its heart: saying the same thing three '
        'ways. The AI calls the audience, you find the voice — six rounds, '
        'no warm-up.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'One marker word per register',
        text:
            'Pick anchors: "erhalten" pulls you formal, "kriegen" plus '
            '"halt" pulls you colloquial. Land the anchor first and the '
            'rest of the sentence follows its lead.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The same annoyance, three ways',
        text:
            'Behörde: "Leider muss der Termin verschoben werden." Kollegin: '
            '"Das Meeting ist jetzt Freitag, echt ungünstig." Freund: '
            '"Meeting is\' jetzt Freitag, mega nervig."',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_collocations',
    title: 'Translate: collocation precision',
    level: 'C2',
    mode: SpeakingMode.translationDrill,
    session: _c2Session,
    passScore: 70,
    topic:
        'Ten English sentences where the obvious German verb is wrong — '
        'each needs its fixed collocation partner. Reveal the collocation '
        'only after my attempt. Write the final report in German.',
    material:
        'Sentences to serve one at a time (target collocation in '
        'brackets — reveal it after my attempt, never before):\n'
        '1. The opposition criticised the new law sharply. '
        '(Kritik üben an + Dat)\n'
        '2. The city took drastic measures. (Maßnahmen ergreifen)\n'
        '3. He made a serious mistake. (einen Fehler begehen)\n'
        '4. She reached an important decision. '
        '(eine Entscheidung treffen)\n'
        '5. The company suffered heavy losses. (Verluste erleiden)\n'
        '6. The minister gave a speech. (eine Rede halten)\n'
        '7. They set a new record. (einen Rekord aufstellen)\n'
        '8. The report raises serious doubts. (Zweifel wecken)\n'
        '9. We have to draw the consequences. (Konsequenzen ziehen)\n'
        '10. The witness gave a statement. (eine Aussage machen)\n'
        'For each miss, contrast the wrong literal verb with the fixed '
        'partner and re-serve the sentence later in the round.',
    practisePoints: [
      'Fixed verb-noun partnerships instead of literal translation',
      'The case or preposition each collocation governs',
      'Recognising a collocation trap before answering',
    ],
    scoringCriteria: [
      'the fixed collocation verb',
      'correct case and preposition',
      'natural full-sentence rendering',
    ],
    priorityErrors: [
      'literal verb (machen/geben) where a collocation rules',
      'wrong case after üben an / Kritik an',
    ],
    intro:
        'Ten sentences designed to punish the obvious verb. In German you '
        'do not "make" criticism — you practise it (Kritik üben). Your AI '
        'reveals each fixed partner only after you have committed.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The noun chooses the verb',
        text:
            'At C2 the noun is the boss: Kritik ÜBT man, Maßnahmen '
            'ERGREIFT man, eine Rede HÄLT man. When in doubt, recall the '
            'noun\'s one loyal verb, not a translation of the English.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'machen is almost never it',
        text:
            'If your draft sentence leans on "machen", stop. Of these ten '
            'sentences, exactly one tolerates it — the other nine are '
            'testing whether you reach past it.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_oped_reading',
    title: 'Reading: anatomy of an op-ed',
    level: 'C2',
    mode: SpeakingMode.readingQa,
    session: _c2Session,
    passScore: 70,
    topic:
        'A dense opinion piece to dissect: the questions target rhetorical '
        'structure — where the concession lives, what the Vorfeld fronts, '
        'how the author disarms objections. Write the final report in '
        'German.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Dass die Innenstädte veröden, gilt inzwischen als ausgemachte '
        'Sache. Wer dennoch an ihnen festhält, gerät rasch in den Verdacht '
        'der Nostalgie. Zugegeben: Der Onlinehandel hat den Einkauf '
        'bequemer gemacht, und niemand wird ernsthaft in Erwägung ziehen, '
        'das Rad zurückzudrehen. Doch wer daraus den Schluss zieht, die '
        'Stadtmitte habe ausgedient, macht es sich zu einfach. Gerade die '
        'Bequemlichkeit ist es nämlich, die uns teuer zu stehen kommt: '
        'Sie entzieht den Zentren die Laufkundschaft, den Kommunen die '
        'Gewerbesteuer und den Menschen einen Ort, an dem sich Begegnung '
        'nicht buchen lässt. Kritik zu üben an dieser Entwicklung heißt '
        'nicht, den Wandel aufhalten zu wollen. Es heißt, ihn zu '
        'gestalten, statt ihn zu erleiden. Die Kommunen müssten endlich '
        'Maßnahmen ergreifen, die über Blumenkübel und Leuchtreklame '
        'hinausgehen — von der Umwidmung leerstehender Kaufhäuser bis zur '
        'konsequenten Verbannung des Durchgangsverkehrs, so unbequem das '
        'auch sein mag. Dass dies Geld kostet, steht außer Frage. Dass '
        'das Nichtstun teurer wird, allerdings auch.\n'
        '\n'
        'Ask me (one at a time, in German):\n'
        '1. Wo genau liegt die Konzession des Autors — und mit welchem '
        'Signalwort wird sie eröffnet?\n'
        '2. Was leistet das "Doch" im vierten Satz rhetorisch?\n'
        '3. "Gerade die Bequemlichkeit ist es …": Was betont diese '
        'Vorfeld-Konstruktion, und wie klänge der Satz neutral?\n'
        '4. Welche Funktionsverbgefüge verwendet der Text, und was '
        'gewinnt er durch sie?\n'
        '5. Wie entwaffnet der Autor im Voraus den Einwand, er sei '
        'nostalgisch?\n'
        '6. Was leistet die Parallelführung der beiden letzten Sätze '
        '("Dass dies … Dass das …")?',
    practisePoints: [
      'Locating concession and counter-move in an argument',
      'Reading Vorfeld emphasis and cleft-like fronting',
      'Naming rhetorical devices in German',
    ],
    scoringCriteria: [
      'precise structural answers, not paraphrase',
      'correct rhetorical terminology',
      'evidence quoted from the text',
    ],
    priorityErrors: [
      'summarising content instead of analysing structure',
      'missing the concession-rebuttal pivot',
    ],
    intro:
        'You have read hard texts before; now you take one apart. Every '
        'question asks how the piece persuades, not what it says — the '
        'skills you dissect here are the ones you deploy next.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Zugegeben … doch …',
        text:
            'The classic concession frame: grant the opponent something '
            'real ("Zugegeben: …"), then pivot with "Doch". What follows '
            'the pivot is always the author\'s actual position.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Watch the first slot',
        text:
            'Whatever a German sentence fronts, it spotlights. "Gerade '
            'die Bequemlichkeit ist es, die …" is emphasis machinery — '
            'un-fronting it in your answer proves you saw the machine.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_persuade_mayor',
    title: 'Persuade the mayor',
    level: 'C2',
    mode: SpeakingMode.conversation,
    session: _c2Session,
    passScore: 70,
    topic:
        'You are a stubborn, budget-obsessed mayor; I lobby you to fund a '
        'project of my choosing. Object realistically and yield only to '
        'well-built arguments. I must use at least three Funktionsverbgefüge '
        'and one deliberate emphasis fronting — track them and name them in '
        'the feedback. Write the final report in German.',
    practisePoints: [
      'Concession-then-rebuttal argument structure',
      'Funktionsverbgefüge deployed naturally under pressure',
      'One planted Vorfeld fronting for emphasis',
    ],
    targetVocabulary: [
      'in Erwägung ziehen',
      'zur Verfügung stellen',
      'Maßnahmen ergreifen',
      'in Kauf nehmen',
      'zugegeben',
      'gleichwohl',
    ],
    scoringCriteria: [
      'persuasive structure with real concessions',
      'three correct FVG woven in, not bolted on',
      'the fronting lands and reads as intentional',
    ],
    priorityErrors: [
      'FVG with wrong preposition or article',
      'assertion without concession',
    ],
    intro:
        'Time to use the toolbox on a live target. The AI plays a mayor '
        'who has heard every pitch — you win funding with structure, not '
        'volume, and you must smuggle in three FVG along the way.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Concede first, then take the point',
        text:
            'Nothing disarms a stubborn official like agreement: "Dass '
            'das Geld kostet, steht außer Frage. Gleichwohl …" — you '
            'give a centimetre and take the argument.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'A fronting that persuades',
        text:
            '"Gerade JETZT müssen wir handeln" or "Verschieben können '
            'wir das Projekt immer noch" — put the pressure word first '
            'and the mayor hears it twice.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_position_paper',
    title: 'Write: paper and summary',
    level: 'C2',
    mode: SpeakingMode.writing,
    session: _c2Session,
    passScore: 70,
    topic:
        'A 150-word position paper plus its 40-word executive summary, '
        'graded above all on Funktionsverbgefüge density without stiffness. '
        'Write the final report in German.',
    material:
        'Writing task:\n'
        '- Pick one workplace or civic issue (I may propose one if you '
        'prefer). Write a position paper of about 150 words: clear stance, '
        'one concession, one counter-argument, one concrete demand.\n'
        '- Then compress it into a 40-word executive summary that a busy '
        'reader could act on — no new content, no lost demand.\n'
        'Rubric (grade against this):\n'
        '- 3–5 Funktionsverbgefüge, each earning its place (biggest '
        'weight): flag any that stiffen the prose as errors.\n'
        '- Collocations exact (Kritik üben an, Maßnahmen ergreifen …).\n'
        '- Concession structurally marked (zugegeben / zwar … doch).\n'
        '- The summary keeps stance AND demand within 40 words.\n'
        '- Register: consistently formal, no colloquial bleed.',
    practisePoints: [
      'FVG density that elevates rather than inflates',
      'Compression: 150 words to 40 without losing the demand',
      'A structurally marked concession',
    ],
    scoringCriteria: [
      'FVG used well and judged honestly',
      'exact collocations and formal register',
      'summary fidelity within the word limit',
    ],
    priorityErrors: [
      'FVG stacked until the prose goes stiff',
      'summary that drops the demand',
    ],
    intro:
        'The hardest part of formal writing is restraint. You write the '
        'long version, then the ruthless short one — and the AI grades '
        'whether each function-verb phrase earned its seat.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'warning',
        title: 'Density is a dial, not a goal',
        text:
            'Three FVG in 150 words read as command; eight read as a '
            'ministry memo parody. If two FVG land in one sentence, '
            'demote one to its simple verb.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Summarise demands, not sentences',
        text:
            'For the 40-word version, do not shorten your sentences — '
            'list your stance and your demand, then write two new '
            'sentences that carry only those.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_two_papers',
    title: 'Tell it: tabloid and broadsheet',
    level: 'C2',
    mode: SpeakingMode.storytelling,
    session: _c2Session,
    passScore: 70,
    topic:
        'One story, two publications: I narrate the same event first as a '
        'tabloid would, then as a broadsheet. Grade register purity per '
        'version, sentence by sentence. Write the final report in German.',
    material:
        'Story skeleton:\n'
        '- The event: a small-town swimming pool closes for the summer '
        'because of a burst pipe; the mayor knew about the damage since '
        'spring; families are furious; repairs start in August.\n'
        '- Beat 1, tabloid (BILD voice): short punchy sentences, outrage, '
        'exclamation, colloquial verbs (kriegen, dichtmachen), a furious '
        'quote from "Mutter Sabine (34)".\n'
        '- Beat 2, broadsheet (FAZ voice): measured periods, FVG and '
        'exact collocations (Kritik üben an, Maßnahmen ergreifen), an '
        'attributed official statement, no exclamation marks.\n'
        '- Same facts in both — invent nothing new for version two.\n'
        '- After both, name one sentence from each version that would be '
        'impossible in the other, and say why.',
    practisePoints: [
      'Tabloid register: punch, outrage, colloquial verbs',
      'Broadsheet register: FVG, attribution, measured syntax',
      'Keeping the facts identical across both tellings',
    ],
    scoringCriteria: [
      'register purity in each version',
      'fact fidelity between versions',
      'the closing register analysis',
    ],
    priorityErrors: [
      'broadsheet words leaking into the tabloid or vice versa',
      'facts drifting between versions',
    ],
    intro:
        'Same pool, same burst pipe, two newspapers that could not sound '
        'less alike. You write the front page twice, and the AI hunts for '
        'the one word that betrays the wrong paper.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The same fact, two voices',
        text:
            'Tabloid: "Bad dicht — und der Bürgermeister wusste es!" '
            'Broadsheet: "Der Bürgermeister räumte ein, seit dem Frühjahr '
            'von den Schäden Kenntnis gehabt zu haben."',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Sentence length is register',
        text:
            'Before word choice, check rhythm: tabloid sentences average '
            'six words, broadsheet ones twenty. Get the rhythm right and '
            'half the register work is done.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_statement_relay',
    title: 'Listen: the statement, relaxed',
    level: 'C2',
    mode: SpeakingMode.listenRetell,
    session: _c2Session,
    passScore: 70,
    topic:
        'You read me a formal written statement aloud; I render it for a '
        'colleague in relaxed but still professional spoken German — same '
        'content, one register down. Write the final report in German.',
    material:
        'The piece (read it to me aloud, twice if I ask):\n'
        '"Sehr geehrte Mitarbeiterinnen und Mitarbeiter, die '
        'Geschäftsleitung hat nach eingehender Prüfung die Entscheidung '
        'getroffen, das Projekt Atlas zum Jahresende zum Abschluss zu '
        'bringen. Die frei werdenden Kapazitäten werden ab Januar dem '
        'Bereich Kundenservice zur Verfügung gestellt. Wir sind uns '
        'bewusst, dass dieser Schritt mit Unannehmlichkeiten verbunden '
        'ist, und nehmen diese nicht leichtfertig in Kauf. Etwaige '
        'Rückfragen richten Sie bitte an die Personalabteilung."\n'
        'My task afterwards:\n'
        '- Retell it to a colleague at the coffee machine: relaxed, '
        'spoken, professional — no FVG, but no slang collapse either.\n'
        '- All four facts must survive: Atlas ends in December, people '
        'move to Kundenservice in January, management admits it is '
        'inconvenient, questions go to HR.\n'
        '- Then ask me two checking questions about details I glossed.',
    practisePoints: [
      'Decoding FVG-heavy formal prose by ear',
      'Down-shifting register without losing precision',
      'Keeping all facts through the shift',
    ],
    scoringCriteria: [
      'all four facts preserved',
      'natural relaxed-professional register',
      'no formal chunks parroted verbatim',
    ],
    priorityErrors: [
      'FVG copied into the spoken version',
      'a fact dropped or distorted',
    ],
    intro:
        'The daily C2 task nobody teaches: hearing management prose and '
        'saying what it means. You catch a formal statement by ear and '
        'hand it on in human German — nothing lost, nothing stiff.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Translate the FVG down',
        text:
            '"zum Abschluss bringen" becomes "beenden", "zur Verfügung '
            'stellen" becomes "die Leute gehen zu …". If a chunk from '
            'the statement survives verbatim, you have not retold it.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Relaxed has a floor',
        text:
            'Coffee-machine German is casual, not careless: "Atlas wird '
            'dichtgemacht, voll übel" undershoots. Aim for "Atlas läuft '
            'Ende des Jahres aus" — easy, but still office-worthy.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_press_conference',
    title: 'Scene: the press conference',
    level: 'C2',
    mode: SpeakingMode.roleplay,
    session: _c2Session,
    passScore: 70,
    topic:
        'A press conference. I am the spokesperson defending an unpopular '
        'decision my organisation has made; you play several journalists '
        'who interrupt, bait me with loaded questions, and misquote what I '
        'just said. Stay hostile but realistic. Write the final report in '
        'German.',
    practisePoints: [
      'Correcting a misquote calmly and precisely',
      'Bridging from a loaded question back to the message',
      'Formal register held under interruption',
    ],
    targetVocabulary: [
      'Das habe ich so nicht gesagt.',
      'Lassen Sie mich das richtigstellen.',
      'in aller Deutlichkeit',
      'Ich komme darauf zurück.',
      'gleichwohl',
    ],
    scoringCriteria: [
      'misquotes caught and corrected',
      'message discipline under baiting',
      'register never cracks into defensiveness',
    ],
    priorityErrors: [
      'accepting a misquote unchallenged',
      'register collapse when interrupted',
    ],
    intro:
        'The stress test before the exam: journalists who twist your '
        'words in real time. Your job is not to win the room — it is to '
        'stay precise, stay formal, and correct the record every time.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The correction formula',
        text:
            '"Das habe ich so nicht gesagt. Gesagt habe ich, dass …" — '
            'note the fronting: putting "Gesagt" first turns your '
            'correction into emphasis. M11 grammar, live under fire.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Bridge, don\'t bite',
        text:
            'A loaded question wants a defensive answer. Concede one '
            'word, then pivot: "Unbequem ist die Entscheidung, ja — '
            'entscheidend aber ist …" and you are back on message.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m11_gate_style_exam',
    title: 'Module exam: style command',
    level: 'C2',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 6, minExchanges: 12),
    passScore: 70,
    topic:
        'The style-command exam. Interview me on everyday and professional '
        'topics, but hold the content constant and switch the register on '
        'your command MID-ANSWER: call "formell!", "neutral!" or "salopp!" '
        'and I must re-voice the running answer instantly. Do this at least '
        'four times across the interview. Write the final report in German.',
    practisePoints: [
      'Instant register switches without losing the thread',
      'FVG and exact collocations on demand in formal mode',
      'Colloquial mode that is loose but controlled',
      'Emphasis fronting used at least once, deliberately',
    ],
    scoringCriteria: [
      'register purity after each switch',
      'collocation and FVG correctness',
      'content continuity across switches',
    ],
    priorityErrors: [
      'register bleed after a switch',
      'wrong collocation partner',
      'FVG with broken preposition or article',
    ],
    intro:
        'The M11 gate: an interview where the AI yanks the register lever '
        'mid-sentence. Same content, new voice, no pause. Pass it and the '
        'final module unlocks — your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Finish the thought, not the sentence',
        text:
            'On "formell!" you may abandon the sentence, never the '
            'thought: restart the clause in the new register and carry '
            'the content over. Content continuity is scored separately.',
      ),
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Three gears, three verbs',
        text:
            'Keep the triplet as your gearbox: kriegen — bekommen — '
            'erhalten. Whichever gear is called, shift the verb first '
            'and the rest of the register engages behind it.',
      ),
    ],
  ),
];
