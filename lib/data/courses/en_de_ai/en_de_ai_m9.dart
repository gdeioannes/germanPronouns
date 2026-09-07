import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M9 · C1.1 — *Abstrahieren* (Abstract).
///
/// Can-do: discuss abstract/societal topics; compress verbal prose into
/// nominal style and unpack it; use passive alternatives naturally.
/// Grammar: Nominalstil ↔ Verbalstil, Passiversatzformen (sein + zu,
/// sich lassen, -bar), subjectless passive, extended participial
/// constructions, advanced connectors (insofern, gleichwohl, zumal).
///
/// C1.1 session shape: 5 minutes, 9 exchanges, pass 70; reports in German.
const _c11Session = SpeakingSession(durationMinutes: 5, minExchanges: 9);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM9Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m9_words_pairs',
    title: 'Words: noun–verb partners',
    level: 'C1',
    mode: SpeakingMode.vocabDrill,
    session: _c11Session,
    passScore: 70,
    topic:
        'Abstraction pairs: drill the 20 noun–verb partners in the '
        'material in both directions, and after every third pair demand a '
        'full sentence embedding whichever form you name. '
        'Write the final report in German.',
    material:
        'Pairs to drill (noun ↔ verb = meaning):\n'
        'die Entwicklung ↔ entwickeln = development / to develop · '
        'die Untersuchung ↔ untersuchen = investigation / to investigate · '
        'die Entscheidung ↔ entscheiden = decision / to decide · '
        'die Zunahme ↔ zunehmen = increase / to increase · '
        'der Rückgang ↔ zurückgehen = decline / to decline · '
        'die Einführung ↔ einführen = introduction / to introduce · '
        'die Durchführung ↔ durchführen = implementation / to carry out · '
        'die Auswirkung ↔ sich auswirken = effect / to have an effect · '
        'die Annahme ↔ annehmen = assumption / to assume · '
        'die Darstellung ↔ darstellen = presentation / to present · '
        'die Erörterung ↔ erörtern = discussion / to discuss in depth · '
        'die Voraussetzung ↔ voraussetzen = prerequisite / to presuppose · '
        'die Zustimmung ↔ zustimmen = approval / to agree · '
        'die Ablehnung ↔ ablehnen = rejection / to reject · '
        'der Zusammenhang ↔ zusammenhängen = connection / to be connected · '
        'die Grundlage ↔ zugrunde liegen = basis / to underlie · '
        'die Verbesserung ↔ verbessern = improvement / to improve · '
        'die Beschränkung ↔ beschränken = restriction / to restrict · '
        'die Forderung ↔ fordern = demand / to demand · '
        'die Bewertung ↔ bewerten = evaluation / to evaluate',
    practisePoints: [
      'Both directions instantly: noun named → verb, verb → noun',
      'Gender and plural of each abstract noun',
      'Embedding either form in an academic-register sentence',
    ],
    scoringCriteria: [
      'the right partner form',
      'correct article and any preposition (auf … auswirken)',
      'natural academic-register embeddings',
    ],
    priorityErrors: [
      'invented nouns (die Entscheid, die Zunehmung)',
      'zugrunde liegen used with the wrong case',
    ],
    intro:
        'C1 begins with the machinery of abstraction: twenty noun–verb '
        'pairs that let you compress and unpack ideas at will. Drill them '
        'until switching direction costs nothing.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: '-ung is always die',
        text:
            'Every -ung noun is feminine and pluralizes with -en: die '
            'Entwicklung, die Entwicklungen. Half of this list is free '
            'gender points.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Watch the preposition partners',
        text:
            'Some verbs drag prepositions along: sich auswirken AUF + Akk., '
            'zusammenhängen MIT, einer Sache zugrunde liegen (Dativ!). The '
            'pair is only learned when its preposition comes too.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_translate_style',
    title: 'Translate: the style transformer',
    level: 'C1',
    mode: SpeakingMode.translationDrill,
    session: _c11Session,
    passScore: 70,
    topic:
        'Style transformation in two rounds: I turn 8 verbal German '
        'sentences into nominal style, then unpack 4 nominal monsters into '
        'clean verbal German. Serve one at a time, correct immediately, '
        'and rate elegance as well as accuracy. '
        'Write the final report in German.',
    material:
        'Round 1 — verbal → nominal (serve one at a time):\n'
        '1. Nachdem das Projekt abgeschlossen wurde, feierte das Team.\n'
        '2. Weil die Kosten gestiegen sind, wurde das Budget gekürzt.\n'
        '3. Bevor das Gesetz eingeführt wurde, gab es lange Debatten.\n'
        '4. Als die Ergebnisse veröffentlicht wurden, reagierte die '
        'Presse sofort.\n'
        '5. Damit die Qualität verbessert wird, braucht man klare Regeln.\n'
        '6. Obwohl viele zugestimmt haben, wurde der Plan abgelehnt.\n'
        '7. Wenn man die Daten untersucht, erkennt man ein Muster.\n'
        '8. Während die Stadt wuchs, verschwanden die Grünflächen.\n'
        '(Target style: Nach Abschluss des Projekts…, aufgrund des '
        'Kostenanstiegs…, trotz der Zustimmung vieler…)\n'
        '\n'
        'Round 2 — nominal → verbal (serve one at a time):\n'
        '9. Die Durchführung der Untersuchung erfolgte unter Ausschluss '
        'der Öffentlichkeit.\n'
        '10. Bei Nichtbeachtung der Vorschriften droht die Kündigung des '
        'Vertrags.\n'
        '11. Die Verbesserung der Lage ist nur durch eine Erhöhung der '
        'Investitionen möglich.\n'
        '12. Nach Bekanntgabe der Entscheidung kam es zu einem Rückgang '
        'der Bewerbungen.',
    practisePoints: [
      'Clause → prepositional noun phrase (nachdem → nach + Genitiv)',
      'The matching abstract noun for each verb',
      'Unpacking noun chains into subject–verb clauses',
    ],
    scoringCriteria: [
      'meaning fully preserved in both directions',
      'correct genitive chains in the nominal versions',
      'verbal versions that sound spoken, not translated',
    ],
    priorityErrors: [
      'case errors inside the noun chains',
      'nominal versions that keep the conjunction (nachdem der Abschluss…)',
    ],
    intro:
        'One meaning, two costumes: bureaucratic-nominal and human-verbal. '
        'This drill makes you fluent in changing the costume on command — '
        'the core C1 writing skill.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The conjunction map',
        text:
            'nachdem → nach, weil → aufgrund/wegen, obwohl → trotz, '
            'bevor → vor, während → während, damit → zur/zum + noun. Swap '
            'the connector, nominalize the verb, chain the rest in the '
            'genitive.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'Sentence 1, transformed',
        text:
            '"Nachdem das Projekt abgeschlossen wurde" → "Nach Abschluss '
            'des Projekts". Four words fewer, one register higher — that '
            'trade is the whole game.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_read_science',
    title: 'Reading: the sleep study',
    level: 'C1',
    mode: SpeakingMode.readingQa,
    session: _c11Session,
    passScore: 70,
    topic:
        'A popular-science passage on sleep research to read and answer '
        'questions about. Ask in German, one at a time; question 4 demands '
        'a paraphrase of a sein + zu construction. '
        'Write the final report in German.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Schlaf galt lange als passiver Zustand, in dem das Gehirn '
        'lediglich ruht. Neuere Untersuchungen zeichnen ein anderes Bild: '
        'Während des Tiefschlafs wird das am Tag Gelernte offenbar aktiv '
        'verarbeitet und in das Langzeitgedächtnis überführt. Die diesem '
        'Prozess zugrunde liegenden Mechanismen sind erst in Ansätzen '
        'erforscht. Fest steht gleichwohl, dass sich Schlafmangel '
        'unmittelbar auf die Gedächtnisleistung auswirkt. In einer viel '
        'beachteten Studie ließen sich bereits nach einer einzigen '
        'durchwachten Nacht deutliche Einbußen nachweisen. Die daraus '
        'abzuleitenden Konsequenzen sind nicht zu unterschätzen, zumal '
        'chronischer Schlafmangel in modernen Gesellschaften weit '
        'verbreitet ist. Eine pauschale Empfehlung ist dennoch kaum zu '
        'formulieren, da das individuelle Schlafbedürfnis erheblich '
        'variiert. Insofern plädieren Fachleute dafür, Schlaf nicht als '
        'verlorene Zeit, sondern als messbare Investition in die eigene '
        'Leistungsfähigkeit zu begreifen. Ob sich diese Einsicht '
        'gesellschaftlich durchsetzen lässt, bleibt abzuwarten.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Wie hat sich das wissenschaftliche Bild vom Schlaf verändert?\n'
        '2. Was passiert dem Text zufolge während des Tiefschlafs?\n'
        '3. Was zeigte die erwähnte Studie — und mit welcher '
        'Formulierung wird das Ergebnis ausgedrückt (ließen sich…)?\n'
        '4. Formuliere "Die daraus abzuleitenden Konsequenzen sind nicht '
        'zu unterschätzen" in einfachem verbalem Deutsch um.\n'
        '5. Warum ist laut Text keine pauschale Empfehlung möglich, und '
        'welche Haltung empfehlen die Fachleute stattdessen?',
    practisePoints: [
      'Extended participial constructions (die diesem Prozess zugrunde '
          'liegenden Mechanismen)',
      'Passiversatz reading: sich lassen, sein + zu, -bar',
      'Advanced connectors in context: gleichwohl, zumal, insofern',
    ],
    scoringCriteria: [
      'precise information from the text',
      'a correct plain-German paraphrase of sein + zu',
      'answers in academic-register German',
    ],
    priorityErrors: [
      'sein + zu misread as a simple statement instead of modality',
      'participial constructions skipped rather than decoded',
    ],
    intro:
        'A dense science passage in real C1 clothing: participial '
        'constructions, sich lassen, sein + zu. Read it like the educated '
        'lay reader it was written for.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Three passives in disguise',
        text:
            '"ist nicht zu unterschätzen" = kann/darf nicht unterschätzt '
            'werden. "ließen sich nachweisen" = konnten nachgewiesen '
            'werden. "messbar" = kann gemessen werden. Same passive, three '
            'costumes.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Find the noun, then rewind',
        text:
            'In "die diesem Prozess zugrunde liegenden Mechanismen", jump '
            'to the noun (Mechanismen), then read the middle as its '
            'relative clause: die dem Prozess zugrunde liegen.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_townhall',
    title: 'Town hall: the four-day week',
    level: 'C1',
    mode: SpeakingMode.conversation,
    session: _c11Session,
    passScore: 70,
    topic:
        'A town-hall discussion on introducing the four-day week. You '
        'moderate and play two citizens with opposing views; I argue my '
        'position, respond to both, and must produce at least 2 '
        'Passiversatz forms (sich lassen / sein + zu / -bar) and one '
        'sentence with zumal. Track those requirements and tell me at the '
        'end whether I met them. Write the final report in German.',
    practisePoints: [
      'Arguing an abstract societal question in extended turns',
      'Passiversatz in free speech (Das lässt sich finanzieren…)',
      'zumal for adding a strengthening reason',
      'Responding to two opposing speakers coherently',
    ],
    targetVocabulary: [
      'die Produktivität',
      'die Arbeitszeitverkürzung',
      'sich umsetzen lassen',
      'machbar',
      'zumal',
      'die Betreuung',
    ],
    scoringCriteria: [
      'well-structured arguments over several exchanges',
      'the required Passiversatz forms produced correctly',
      'a natural zumal sentence',
    ],
    priorityErrors: [
      'sich lassen built without the infinitive (lässt sich gemacht)',
      'zumal used as a main-clause starter',
    ],
    intro:
        'A civic debate with quotas: somewhere in your argument, two '
        'passive alternatives and one zumal must appear — naturally. Your '
        'AI keeps count while playing the whole town hall.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'Passiversatz, debate-ready',
        text:
            '"Das lässt sich in kleinen Betrieben schwer umsetzen" and '
            '"Die Kosten sind kaum zu vermeiden" — drop these frames into '
            'any policy debate and the quota fills itself.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'zumal sends the verb to the end',
        text:
            'zumal introduces a strengthening subclause: "…, zumal viele '
            'Beschäftigte ohnehin erschöpft sind." Verb last, and it never '
            'starts a standalone sentence.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_buerokratie_duell',
    title: 'Game: Bürokratie-Duell',
    level: 'C1',
    mode: SpeakingMode.wordGame,
    session: _c11Session,
    passScore: 70,
    topic:
        'A style-inflation duel. Keep it fast and funny, but grade the '
        'grammar of every transformation seriously. '
        'Write the final report in German.',
    material:
        'Game rules:\n'
        '- Round 1, inflation (5 rounds): you state a simple everyday fact '
        '("Man darf hier nicht parken.", "Wir haben das Problem gelöst."). '
        'I inflate it into maximal Amtsdeutsch — nominal style, passive or '
        'Passiversatz, genitive chains ("Das Abstellen von Fahrzeugen ist '
        'auf dem gesamten Gelände zu unterlassen."). 10 points per '
        'transformation that is both grammatical AND meaning-preserving; '
        '5 points if the meaning drifts; 0 if the grammar breaks.\n'
        '- Round 2, deflation (5 rounds): you serve a genuine bureaucratic '
        'monster sentence; I deflate it into one or two plain spoken '
        'sentences. Same scoring.\n'
        '- Bonus (up to 10 points): the single most elegant transformation '
        'of the game, your choice.\n'
        '- Maximum 110 points; convert my points to the final score.',
    practisePoints: [
      'Inflating: verb → abstract noun, agent deleted, genitive chained',
      'Deflating: finding the hidden subject and verb again',
      'Keeping the meaning exact while the style flips',
    ],
    scoringCriteria: [
      'grammatical correctness of every transformation',
      'meaning preserved in both directions',
      'stylistic range between the two extremes',
    ],
    priorityErrors: [
      'case errors in the inflated noun chains',
      'deflations that drop information',
    ],
    intro:
        'A duel of registers: pump plain sentences full of Amtsdeutsch, '
        'then puncture real bureaucratic monsters. Ten rounds, points for '
        'precision — and a bonus for elegance.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'The inflation pump',
        text:
            'Three strokes inflate any sentence: 1) verb becomes -ung/-en '
            'noun, 2) the doer disappears, 3) everything else hangs on in '
            'the genitive. "Wir prüfen den Antrag" → "Die Prüfung des '
            'Antrags erfolgt…".',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Deflate by asking: who does what?',
        text:
            'Every monster hides an agent and an action. Find them, make '
            'them subject and verb, and the sentence collapses into plain '
            'German by itself.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_write_abstract',
    title: 'Write: abstract & plain version',
    level: 'C1',
    mode: SpeakingMode.writing,
    session: _c11Session,
    passScore: 70,
    topic:
        'A two-register writing task on this module\'s sleep-research '
        'passage: first a 100-word abstract in nominal style, then a '
        '3-sentence plain-language version of the same content. Grade '
        'against the rubric, then show me one sentence of mine rewritten '
        'even better in each register. Write the final report in German.',
    material:
        'Writing task:\n'
        '- Source: the sleep-research passage from this module\'s reading '
        'exercise (ask me to paste it, or reconstruct it with me first).\n'
        '- Part 1: an abstract of ~100 words in academic nominal style — '
        'no ich, at least 3 abstract nouns from the noun–verb pairs '
        '(Untersuchung, Auswirkung, Annahme…), at least 1 Passiversatz '
        'form, at least 1 preposition + noun instead of a clause.\n'
        '- Part 2: the same content for a poster in the underground — '
        'exactly 3 sentences, plain verbal German, a 12-year-old must get '
        'it.\n'
        'Rubric (grade against this):\n'
        '- Abstract: consistently nominal, required forms present, all '
        'key findings covered, ~100 words.\n'
        '- Plain version: genuinely simple — no abstract nouns, no '
        'passive, active verbs only.\n'
        '- Both: accurate to the source, no invented findings.\n'
        '- The register GAP between the two versions is the main grade.',
    practisePoints: [
      'Sustained nominal style over a whole paragraph',
      'Radical simplification without losing the findings',
      'Choosing content: what survives the 100-word cut',
    ],
    scoringCriteria: [
      'register consistency inside each version',
      'the required nominal and Passiversatz forms',
      'faithfulness to the source in both versions',
    ],
    priorityErrors: [
      'verbal clauses leaking into the abstract',
      'abstract nouns leaking into the plain version',
    ],
    intro:
        'Write the same science twice: once for a journal, once for a '
        'poster in the U-Bahn. The distance between your two versions is '
        'exactly what this module trained.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Write the plain version first',
        text:
            'Draft the three simple sentences first — they force you to '
            'name the actual findings. Then inflate them into the '
            'abstract. Compression is easier with the content already '
            'chosen.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'An abstract has no ich',
        text:
            'Academic German hides the author: "Die Untersuchung zeigt…", '
            '"Es lässt sich nachweisen, dass…". If ich appears in Part 1, '
            'the register has already broken.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_lecture_retell',
    title: 'Listen: the invented study',
    level: 'C1',
    mode: SpeakingMode.listenRetell,
    session: _c11Session,
    passScore: 70,
    topic:
        'A mini-lecture to reconstruct: you lecture for about 2 minutes on '
        'an invented study, then I rebuild it along '
        'method–result–implication. Write the final report in German.',
    material:
        'The piece (deliver as a fluent ~2-minute spoken lecture, '
        'C1 register with nominal phrases and one sein + zu form; repeat '
        'once on request):\n'
        '- Invent a plausible study, e.g. "Auswirkung von Großraumbüros '
        'auf die Konzentrationsfähigkeit" — or choose your own social '
        'science topic.\n'
        '- Cover, in order: Ausgangsfrage and why it matters; Methode '
        '(who was studied, how many, how measured, over what period); '
        'zentrale Ergebnisse (two findings, one of them surprising, with '
        'rough numbers); Implikationen (what follows for practice, one '
        'open question).\n'
        '\n'
        'Then ask me to:\n'
        '1. Reconstruct the study along Methode – Ergebnis – Implikation, '
        'using at least 3 abstract nouns (Untersuchung, Zunahme, '
        'Auswirkung…).\n'
        '2. State the surprising finding and why it is surprising.\n'
        '3. Formulate one limitation of the study — with a Passiversatz '
        'form (Das ist kaum zu verallgemeinern / lässt sich nicht ohne '
        'Weiteres übertragen).\n'
        'Grade fidelity to the lecture, structure, and the required '
        'forms.',
    practisePoints: [
      'Tracking a long spoken structure: question, method, result, '
          'implication',
      'Retelling with abstract nouns instead of und-dann chains',
      'A critical limitation phrased with a Passiversatz form',
    ],
    scoringCriteria: [
      'the study reconstructed accurately and in order',
      'academic vocabulary in the retell',
      'the limitation with a correct Passiversatz form',
    ],
    priorityErrors: [
      'method and result mixed together',
      'numbers or findings invented beyond the lecture',
    ],
    intro:
        'Your AI turns professor for two minutes; you turn it back into '
        'structure. Method, result, implication — plus one polite doubt in '
        'proper C1 packaging.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Listen for the joints',
        text:
            'Lectures signal their skeleton: "Zunächst…", "Dabei zeigte '
            'sich…", "Daraus folgt…". Catch the joints and the two minutes '
            'hang themselves on three hooks.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The elegant doubt',
        text:
            '"Die Ergebnisse lassen sich kaum auf andere Branchen '
            'übertragen, zumal nur ein Unternehmen untersucht wurde." — '
            'limitation, Passiversatz and zumal in one C1 sentence.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_story_city2055',
    title: 'Tell it: the city in 30 years',
    level: 'C1',
    mode: SpeakingMode.storytelling,
    session: _c11Session,
    passScore: 70,
    topic:
        '"Die Stadt in 30 Jahren": a structured speculation about my city '
        'in three decades, told along the beats in the material — with '
        'subjectless passives as the required backbone. '
        'Write the final report in German.',
    material:
        'Story skeleton:\n'
        '- Beat 1, Ankunft: I arrive in my city in 30 years and describe '
        'the first impression — what is being done everywhere (Überall '
        'wird gebaut. Es wird kaum noch gefahren…).\n'
        '- Beat 2, Wandel: what has changed and how it came about — '
        'passive Perfekt and Passiversatz (Vieles ist umgebaut worden; '
        'die Innenstadt ist kaum wiederzuerkennen).\n'
        '- Beat 3, Alltag: how people live, work, move — es-wird futures '
        '(Es wird mehr von zu Hause gearbeitet werden).\n'
        '- Beat 4, Bilanz: what was gained, what was lost, my verdict '
        'with one gleichwohl or insofern.\n'
        '- Required forms: at least 4 subjectless passives (es wird… / '
        'hier wird… / überall wird…), at least 1 passive future (es wird '
        'gebaut werden), 1 sein + zu form, 1 advanced connector.\n'
        '- You interject once per beat as a curious local; I incorporate '
        'the interjection and go on.',
    practisePoints: [
      'Subjectless passive across tenses (es wird / wurde / ist … worden)',
      'Passive future (es wird gebaut werden)',
      'Keeping a 4-beat structure while being interrupted',
    ],
    scoringCriteria: [
      'the required passive forms, correct and varied',
      'a coherent arc from arrival to verdict',
      'interjections woven in, not ignored',
    ],
    priorityErrors: [
      'es kept where a fronted element should replace it (Hier wird es '
          'gebaut)',
      'future passive word order scrambled',
    ],
    intro:
        'Speculative city-telling with a grammatical spine: what is being '
        'done, what has been done, what will be done — the subjectless '
        'passive in every tense it owns.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'es is a placeholder, not a subject',
        text:
            '"Es wird gebaut" — but front anything and es vanishes: '
            '"Überall wird gebaut", never "Überall wird es gebaut". The '
            'es only holds the first seat until something else takes it.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'One future, fully passive',
        text:
            '"In den nächsten Jahren wird hier viel gebaut werden." — '
            'wird second, gebaut werden parked at the end. Say it slowly '
            'once, then own it.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_expert_panel',
    title: 'Roleplay: the expert panel',
    level: 'C1',
    mode: SpeakingMode.roleplay,
    session: _c11Session,
    passScore: 70,
    topic:
        'An expert panel: I am the invited expert on a topic I choose '
        '(ask me first), you are a skeptical lay host. Whenever I use '
        'jargon or nominal style, pounce: "Was heißt das konkret?" — and '
        'I must unpack it into plain German on the spot, then return to '
        'expert register. Do this at least four times. '
        'Write the final report in German.',
    practisePoints: [
      'Holding expert register: nominal style, hedged claims',
      'Instant downshifts to plain language on demand',
      'Returning to the thread after each unpacking',
      'Handling skeptical follow-ups without waffling',
    ],
    targetVocabulary: [
      'im Wesentlichen',
      'vereinfacht gesagt',
      'das bedeutet konkret',
      'die Studienlage',
      'sich belegen lassen',
      'differenziert betrachten',
    ],
    scoringCriteria: [
      'genuine register contrast between expert and plain turns',
      'accurate unpacking — same meaning, simpler words',
      'composure and thread-keeping under interruption',
    ],
    priorityErrors: [
      'plain versions that stay abstract',
      'losing the argument thread after downshifts',
    ],
    intro:
        'You are the expert; your AI is the host who refuses to nod along. '
        'Every piece of jargon gets challenged — translating yourself '
        'live is the C1 party trick this trains.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The downshift formula',
        text:
            '"Vereinfacht gesagt: …" then one sentence a neighbour would '
            'follow, then "Um auf den Punkt zurückzukommen: …" and you are '
            'back in expert mode. Three moves, every time.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Hedge like a pro',
        text:
            'Experts rarely say "immer". They say "in der Regel", "die '
            'Studienlage deutet darauf hin", "das lässt sich nicht '
            'pauschal beantworten". Hedging is credibility, not weakness.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m9_gate_interview',
    title: 'Module exam: the C1.1 interview',
    level: 'C1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 6, minExchanges: 10),
    passScore: 70,
    topic:
        'The closing examination for module 9: an abstract-topic interview '
        '(pick a societal question I have not prepared). Probe my '
        'argument, demand one live style transformation in each direction '
        '(a sentence of mine into nominal style, one of yours into plain '
        'German), and at one point order a full register shift: "Erklären '
        'Sie das jetzt einem Kind." Judge the shift itself. '
        'Write the final report in German.',
    practisePoints: [
      'Sustained abstract argumentation at C1 length',
      'Live Nominalstil ↔ Verbalstil transformations',
      'Passiversatz forms chosen correctly (sein + zu vs sich lassen '
          'vs -bar)',
      'Advanced connectors placed precisely',
    ],
    scoringCriteria: [
      'accuracy of both live style transformations',
      'the right Ersatzform for each meaning',
      'connector precision (insofern, gleichwohl, zumal)',
    ],
    priorityErrors: [
      'style transformations that change the meaning',
      'Ersatzform mismatches (sein + zu where -bar belongs)',
      'connectors used as decoration without their logic',
    ],
    intro:
        'The module gate: an abstract-topic examination with a forced '
        'register shift in the middle. Pass it and C1.2 unlocks. Retake '
        'it as often as you like — your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Know your three Ersatzformen',
        text:
            'sein + zu = must/can be done (die Frage ist zu klären), sich '
            'lassen = can be done (das lässt sich klären), -bar = doable '
            'as a property (eine klärbare Frage). The examiner tests '
            'whether you pick, not just produce.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'The child test is a register test',
        text:
            'When ordered to explain it to a child, drop every abstract '
            'noun, use one concrete image, and keep sentences under ten '
            'words. Staying simple under exam pressure IS the exam.',
      ),
    ],
  ),
];
