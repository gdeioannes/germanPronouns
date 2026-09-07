import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M7 · B2.1 — *Argumentieren* (Argue).
///
/// Can-do: argue a position with structured pros/cons; report what others
/// said; moderate disagreement; understand editorial text.
/// Grammar: Konjunktiv I (reported speech incl. K II fallback), passive in
/// all tenses + with modals, Partizipialattribute intro, concessive &
/// consecutive connectors (dennoch, folglich, je…desto).
///
/// B2 session shape: ~5 minutes, 8 exchanges, pass 60. From B2.1 on the
/// closing report is requested in German via the topic text.
const _b2Session = SpeakingSession(durationMinutes: 5, minExchanges: 8);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM7Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m7_scaffolds',
    title: 'Words: argumentation scaffolds',
    level: 'B2',
    mode: SpeakingMode.vocabDrill,
    session: _b2Session,
    passScore: 60,
    topic:
        'Argumentation scaffolds drilled as whole chunks: you state a bare '
        'claim, then assign me one scaffold, and I must re-express the '
        'claim through it — grammar intact, meaning preserved. '
        'Write the final report in German.',
    material:
        'Scaffolds to drill (chunk = meaning):\n'
        'einerseits … andererseits = on the one hand … on the other · '
        'es lässt sich nicht leugnen, dass … = it cannot be denied that · '
        'man muss bedenken, dass … = one has to consider that · '
        'im Gegensatz dazu = in contrast to that · '
        'daraus folgt, dass … = it follows that · '
        'ein weiteres Argument dafür ist … = a further argument for it is · '
        'dagegen spricht, dass … = against it speaks the fact that · '
        'zusammenfassend lässt sich sagen, dass … = in summary one can say · '
        'es kommt darauf an, ob … = it depends on whether · '
        'ich gebe zu, dass …, dennoch … = I admit that …, nevertheless · '
        'je mehr …, desto … = the more …, the more · '
        'folglich = consequently\n'
        'Drill: serve a bare claim (Hausaufgaben sind sinnvoll. / E-Autos '
        'lösen alle Probleme.) plus one scaffold; I rebuild the claim '
        'through the scaffold. Reject broken word order instantly.',
    practisePoints: [
      'Scaffold chunks recalled verbatim',
      'dass-clauses and ob-clauses with verb-final order',
      'je…desto with the comparative on both sides',
    ],
    scoringCriteria: [
      'the assigned scaffold used correctly',
      'word order inside the scaffold',
      'the claim\'s meaning preserved',
    ],
    priorityErrors: [
      'verb not final after dass/ob',
      'je…desto without comparatives',
    ],
    intro:
        'B2 argument runs on prefabricated steel: a dozen scaffolds that '
        'hold any opinion upright. Drill them as chunks until each one '
        'assembles itself.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'je…desto is a double comparative',
        text:
            '"Je mehr Autos fahren, desto schlechter wird die Luft." — '
            'comparative on both sides, verb final after je, verb second '
            'after desto. Miss one piece and the scaffold collapses.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_editorial',
    title: 'Reading: the e-scooter editorial',
    level: 'B2',
    mode: SpeakingMode.readingQa,
    session: _b2Session,
    passScore: 60,
    topic:
        'A newspaper editorial on e-scooters, locked at B2 — do not '
        'simplify or reword it. The questions target the author\'s stance '
        'between the lines, and one asks me to transform a quote into '
        'reported speech with Konjunktiv I. '
        'Write the final report in German.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Stolperfallen auf Rädern\n'
        'Seit fünf Jahren gehören E-Scooter zum Stadtbild, und noch immer '
        'wird über sie gestritten. Die Anbieter betonen gern, ihre '
        'Fahrzeuge seien ein Baustein der Verkehrswende. Das lässt sich '
        'hören — doch wer morgens über kreuz und quer abgestellte Roller '
        'steigen muss, dem erscheint diese Verkehrswende eher als '
        'Hindernislauf. Die steigenden Unfallzahlen sprechen eine '
        'deutliche Sprache: Allein im letzten Jahr wurden in deutschen '
        'Großstädten über 9000 Verletzte registriert. Gewiss, das Auto '
        'bleibt das größere Problem, und ein Verbot wäre folglich der '
        'falsche Weg. Dennoch muss der Wildwuchs geordnet werden: feste '
        'Abstellzonen, weniger Lizenzen, klare Regeln. Je verbindlicher '
        'die Vorgaben, desto eher wird aus dem Ärgernis ein nützliches '
        'Verkehrsmittel. Die Städte sollten das nicht länger den '
        'Anbietern überlassen.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Welche zwei Seiten des Streits nennt der Text?\n'
        '2. Was hält die Autorin von einem Verbot — und woran erkennt '
        'man das?\n'
        '3. Welche konkreten Maßnahmen werden gefordert?\n'
        '4. Was bedeutet der je…desto-Satz im Text, in eigenen Worten?\n'
        '5. Forme dieses Zitat in indirekte Rede mit Konjunktiv I um: '
        '"Die Anbieter sagen: Unsere Fahrzeuge sind ein Baustein der '
        'Verkehrswende." (Check my Konjunktiv I carefully.)',
    practisePoints: [
      'Reading for stance, not just facts',
      'Decoding je…desto and dennoch/folglich logic',
      'Transforming quotes into Konjunktiv I',
    ],
    scoringCriteria: [
      'the author\'s position correctly identified',
      'evidence from the text for each answer',
      'a correct Konjunktiv I transformation',
    ],
    priorityErrors: [
      'indicative kept in the reported-speech task',
      'stance question answered with surface facts only',
    ],
    intro:
        'Your first editorial: the author never says "I think", yet takes '
        'a clear side. Read between the lines, then bend one quote into '
        'proper reported speech.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Stance hides in connectors',
        text:
            'gewiss…dennoch, folglich, doch — these little words carry the '
            'author\'s verdict. Track where each "but" lands and you have '
            'the opinion without a single "ich finde".',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_reported',
    title: 'Translate: she said that…',
    level: 'B2',
    mode: SpeakingMode.translationDrill,
    session: _b2Session,
    passScore: 60,
    topic:
        'Ten English reported-speech sentences into German indirekte Rede '
        'with Konjunktiv I — falling back to Konjunktiv II exactly where '
        'K I matches the indicative. Serve one at a time; explain every '
        'fallback I miss. Write the final report in German.',
    material:
        'Sentences to serve one at a time (Konjunktiv I required, '
        'K II only as the correct fallback):\n'
        '1. She said that she was tired.\n'
        '2. He said that he had no time.\n'
        '3. The minister said that the plan was working.\n'
        '4. She said that they were coming tomorrow. (fallback!)\n'
        '5. He claimed that he knew nothing about it.\n'
        '6. The newspaper wrote that prices were rising.\n'
        '7. She said that she had seen the film.\n'
        '8. They said that they had (i.e. hätten) no money. (fallback!)\n'
        '9. He said that he would call later.\n'
        '10. The spokesperson said that the problem must be solved.',
    practisePoints: [
      'Konjunktiv I forms: er sei, er habe, er wisse, er komme',
      'K II fallback when K I equals the indicative (sie kämen, sie '
          'hätten)',
      'Past reported speech: er habe gesehen, sie sei gewesen',
    ],
    scoringCriteria: [
      'correct Konjunktiv I forms',
      'fallback applied only where needed',
      'tense of the original preserved',
    ],
    priorityErrors: [
      'indicative in reported speech',
      'K II used where K I is distinct and required',
    ],
    intro:
        'The journalist\'s tense: what others said, held at arm\'s length. '
        'Ten sentences, and two of them secretly test whether you know '
        'when Konjunktiv I must give way to Konjunktiv II.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Fall back only on a collision',
        text:
            'Use K I first: er sei, er habe, er komme. Only when the K I '
            'form looks identical to the indicative (sie kommen, sie '
            'haben) do you switch to K II: sie kämen, sie hätten.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_debate',
    title: 'The city-centre debate',
    level: 'B2',
    mode: SpeakingMode.conversation,
    session: _b2Session,
    passScore: 60,
    topic:
        'A structured debate on "Autos raus aus den Innenstädten" — and I '
        'have drawn the ANTI position (against banning cars), whatever my '
        'real view. Two full rounds: I argue, you rebut, I counter your '
        'rebuttal. Somewhere in the debate I must land at least one '
        'correct je…desto sentence — remind me at the end if it never '
        'came. Write the final report in German.',
    practisePoints: [
      'Building a pro/contra argument in rounds',
      'Concessive moves: zwar…, dennoch…; ich gebe zu, dass…',
      'One mandatory je…desto sentence',
    ],
    targetVocabulary: [
      'der Verkehr',
      'die Innenstadt',
      'die Einschränkung',
      'der Lieferverkehr',
      'auf etwas angewiesen sein',
      'dennoch',
    ],
    scoringCriteria: [
      'coherent arguments held across two rounds',
      'real engagement with the rebuttals',
      'the je…desto sentence, correctly built',
    ],
    priorityErrors: [
      'assertions without justification',
      'je…desto malformed or missing',
    ],
    intro:
        'You don\'t get to pick your side — the anti position is yours, '
        'defend it. Two rounds of argument and rebuttal, with one je…desto '
        'sentence as the price of admission.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'Concede, then strike',
        text:
            '"Zwar ist die Luft ein Problem, dennoch sind viele Menschen '
            'auf das Auto angewiesen." Conceding one point first makes '
            'your counter-punch twice as credible — and it\'s pure B2.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_headline_poker',
    title: 'Game: Schlagzeilen-Poker',
    level: 'B2',
    mode: SpeakingMode.wordGame,
    session: _b2Session,
    passScore: 60,
    topic:
        'A fake-news poker game. You deal headlines, I interrogate you in '
        'reported speech, then bet fake or real — with a justification. '
        'Write the final report in German.',
    material:
        'Game rules:\n'
        '- You invent 6 plausible German news headlines; make 2–3 of them '
        'subtly fake (wrong detail, invented statistic, absurd cause). '
        'Show them numbered.\n'
        '- For each headline I ask you 1–2 probing questions, and I must '
        'refer to the claim in reported speech: "Die Zeitung schreibe, '
        'dass…", "Der Artikel behaupte, die Zahl sei gestiegen…". You '
        'answer in character as the dealer, giving hints.\n'
        '- Then I call FAKE or ECHT with one justification sentence '
        '(dennoch, folglich, daraus folgt…).\n'
        '- Scoring: 10 points per correct call, +5 if my interrogation '
        'used correct Konjunktiv I, -5 if I slip into the indicative '
        'when reporting the claim.\n'
        '- 6 headlines, then convert my points to the final score.',
    practisePoints: [
      'Reported speech under game pressure (schreibe, behaupte, sei)',
      'Probing questions about sources and numbers',
      'Justifying a verdict with consecutive connectors',
    ],
    scoringCriteria: [
      'correct Konjunktiv I when citing the headlines',
      'sensible fake/real calls with reasons',
      'connector use in the justifications',
    ],
    priorityErrors: [
      'indicative when reporting claims',
      'calls made without any justification',
    ],
    intro:
        'Six headlines on the table, some of them bluffing. Interrogate '
        'the dealer in reported speech — distance is the whole game — then '
        'call the bluff and say why.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Konjunktiv I = raised eyebrow',
        text:
            '"Die Zeitung schreibe, die Preise seien gefallen" — the -e '
            'and sei signal "so they claim, I\'m not vouching for it". '
            'That grammatical eyebrow is exactly what this game trains.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_leserbrief',
    title: 'Write: the Leserbrief',
    level: 'B2',
    mode: SpeakingMode.writing,
    session: _b2Session,
    passScore: 60,
    topic:
        'A letter to the editor responding to the e-scooter editorial '
        '"Stolperfallen auf Rädern" (feste Abstellzonen, weniger '
        'Lizenzen, kein Verbot). Grade my letter against the rubric, '
        'paragraph by paragraph. Write the final report in German.',
    material:
        'Writing task:\n'
        '- Write a Leserbrief of about 120 words reacting to the '
        'editorial\'s demands (fixed parking zones, fewer licences, no '
        'ban). Agree, disagree or differentiate — but take a position.\n'
        '- Structure: a clear thesis, two supporting arguments, and one '
        'concession to the other side (zwar…, dennoch…).\n'
        '- Refer to the editorial at least once in reported speech (Die '
        'Autorin schreibe/fordere, dass…).\n'
        '- Formal frame: Sehr geehrte Redaktion, … Mit freundlichen '
        'Grüßen.\n'
        'Rubric (grade against this):\n'
        '- Thesis + 2 arguments + 1 concession all present (biggest '
        'weight).\n'
        '- Correct Konjunktiv I in the reference to the editorial.\n'
        '- Connectors doing real work (dennoch, folglich, außerdem).\n'
        '- Around 120 words; formal register throughout.',
    practisePoints: [
      'Thesis–argument–concession architecture',
      'Reported reference to a source text',
      'Formal letter register at B2',
    ],
    scoringCriteria: [
      'complete argumentative structure',
      'correct reported speech',
      'register and connector quality',
    ],
    priorityErrors: [
      'opinion piled up without a concession',
      'indicative in the reference to the editorial',
    ],
    intro:
        'Answer the editorial in its own arena: 120 words to the editor. '
        'A thesis, two arguments, one gracious concession — and the '
        'author\'s claims quoted at Konjunktiv distance.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'The concession is the crown',
        text:
            'B2 examiners look for the concession first: "Zwar hat die '
            'Autorin recht, dass…, dennoch übersieht sie…". One honest '
            'zwar…dennoch lifts the whole letter a level.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_panel_retell',
    title: 'Listen & report: the panel statement',
    level: 'B2',
    mode: SpeakingMode.listenRetell,
    session: _b2Session,
    passScore: 60,
    topic:
        'You deliver a 2-minute panel statement aloud (voice mode), in '
        'character as an expert. Afterwards I report the whole statement '
        'to an absent "colleague" — entirely in reported speech, '
        'Konjunktiv I with correct fallbacks, never quoting directly. '
        'Write the final report in German.',
    material:
        'The piece to deliver aloud (write your own, but it must '
        'be):\n'
        '- A 2-minute panel statement (10–12 sentences) by a fictional '
        'expert on a climate-and-city topic: e.g. "Solardächer für alle '
        'Neubauten" or "Die autofreie Innenstadt bis 2035".\n'
        '- B2 language: at least one passive with a modal (muss gebaut '
        'werden), one statistic (der Anteil, die Mehrheit), one '
        'je…desto sentence, and a clear demand at the end.\n'
        'Then:\n'
        '- Play my colleague who missed the panel and asks: "Was hat er '
        'gesagt?" I report the statement in indirekte Rede — er habe '
        'gesagt, die Dächer müssten…, der Anteil sei…\n'
        '- Interrupt once with "Wirklich? Sagte er das genau so?" and '
        'check that I keep the Konjunktiv while confirming.\n'
        '- Grade coverage of the statement and the reported-speech '
        'grammar; direct quotes in the indicative cost points.',
    practisePoints: [
      'Holding a 2-minute spoken argument in memory',
      'Sustained Konjunktiv I across a long report',
      'Reporting modals and passives (die Dächer müssten gebaut werden)',
    ],
    scoringCriteria: [
      'the statement\'s key points all reported',
      'Konjunktiv I sustained with correct fallbacks',
      'no direct quotation in the indicative',
    ],
    priorityErrors: [
      'sliding into the indicative mid-report',
      'the statistic or demand dropped from the report',
    ],
    intro:
        'Two minutes of expert opinion, then your colleague asks what was '
        'said — and you must retell all of it at reported-speech distance. '
        'The Konjunktiv marathon of this module.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Anchor on the verbs of saying',
        text:
            'Re-launch the Konjunktiv every few sentences: er habe betont, '
            'er habe gefordert, er habe gewarnt. Each verb of saying '
            'resets your grammar so the indicative can\'t sneak back in.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_statistics',
    title: 'Words: charts in words',
    level: 'B2',
    mode: SpeakingMode.vocabDrill,
    session: _b2Session,
    passScore: 60,
    topic:
        'Statistics language, both directions: you give numbers and I '
        'verbalize the trend; then you describe a trend in words and I '
        'reconstruct the numbers. Push for variety — no verb twice in a '
        'row. Write the final report in German.',
    material:
        'Chunks to drill (chunk = meaning):\n'
        'der Anteil = the share, proportion · die Mehrheit = the majority · '
        'die Minderheit = the minority · knapp = just under · gut = a '
        'good, just over · rund = around · steigen auf/um = to rise to/by · '
        'sinken auf/um = to fall to/by · sich verdoppeln = to double · '
        'sich halbieren = to halve · stagnieren = to stagnate · '
        'jeder Dritte = one in three · im Vergleich zu = compared to · '
        'der Rückgang = the decline · die Zunahme = the increase\n'
        'Direction 1: you give raw numbers ("2015: 20 Prozent, 2025: 35 '
        'Prozent"), I verbalize: "Der Anteil stieg von 20 auf 35 '
        'Prozent" — watch my auf vs um!\n'
        'Direction 2: you say a trend sentence ("Die Zahl hat sich '
        'verdoppelt, auf rund 600"), I reconstruct the numbers ("also '
        'von etwa 300 auf 600").\n'
        'Twist: every third item, I must add one je…desto or folglich '
        'comment interpreting the number.',
    practisePoints: [
      'steigen/sinken auf (endpoint) vs um (difference)',
      'Approximation words: knapp, gut, rund',
      'Interpreting numbers with folglich and je…desto',
    ],
    scoringCriteria: [
      'auf vs um used correctly',
      'varied verbs and chunks across items',
      'plausible reconstructions in direction 2',
    ],
    priorityErrors: [
      'auf/um swapped after steigen and sinken',
      'the same trend verb recycled every item',
    ],
    intro:
        'Numbers you can talk about: rises, falls, shares and majorities, '
        'drilled in both directions. The trap the whole drill circles is '
        'tiny — auf or um.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'auf lands, um travels',
        text:
            'stieg AUF 35 Prozent = where it landed; stieg UM 15 '
            'Prozentpunkte = how far it travelled. Same climb, two '
            'prepositions — pick by what your number describes.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_talkshow',
    title: 'Roleplay: moderating the talk-show',
    level: 'B2',
    mode: SpeakingMode.roleplay,
    session: _b2Session,
    passScore: 60,
    topic:
        'A live talk-show: you are a provocative, interrupting guest with '
        'strong opinions on city traffic; I am the moderator. My job: '
        'summarize your points in reported speech, challenge the weak '
        'ones, and keep order politely but firmly — with dennoch and '
        'folglich doing the steering. Escalate twice; never break '
        'character. Write the final report in German.',
    practisePoints: [
      'Summarizing live speech: Sie sagen also, es gebe…',
      'Firm-but-polite moderation (Moment bitte, dennoch…)',
      'Challenging with folglich and counter-questions',
    ],
    targetVocabulary: [
      'unterbrechen',
      'zusammenfassen',
      'der Standpunkt',
      'übertreiben',
      'sachlich bleiben',
      'das Argument entkräften',
    ],
    scoringCriteria: [
      'accurate reported-speech summaries of the guest',
      'order kept without rudeness or surrender',
      'connectors steering the discussion',
    ],
    priorityErrors: [
      'summaries in the indicative (taking the guest\'s side)',
      'losing the moderator role under provocation',
    ],
    intro:
        'Tonight you hold the microphone — and your guest is a handful. '
        'Summarize, challenge, keep control: the moderator\'s Konjunktiv '
        'keeps you neutral while dennoch keeps you in charge.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The moderator\'s move',
        text:
            '"Sie sagen also, die Regeln seien überflüssig — dennoch '
            'zeigen die Zahlen etwas anderes. Wie erklären Sie das?" '
            'Summary, distance, challenge: one sentence, full control.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m7_gate_switch',
    title: 'Module exam: the side-switch debate',
    level: 'B2',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 6, minExchanges: 9),
    passScore: 60,
    topic:
        'The closing exam of the module: you draw a debatable thesis and '
        'assign me a side at random. I defend it for four full exchanges '
        'with structured arguments — then, on your command "Seitenwechsel!", '
        'I must argue the opposite side just as convincingly, reporting my '
        'own earlier arguments in Konjunktiv I before dismantling them. '
        'Write the final report in German.',
    practisePoints: [
      'Structured argument under an assigned position',
      'Reporting earlier arguments in Konjunktiv I',
      'Passive with modals (das müsse geregelt werden)',
      'Connector logic: dennoch, folglich, je…desto',
    ],
    scoringCriteria: [
      'argument quality on BOTH sides',
      'correct Konjunktiv I when reporting the first half',
      'passive-with-modal constructions',
      'connectors used with correct logic and word order',
    ],
    priorityErrors: [
      'Konjunktiv I forms wrong or avoided',
      'passive with modals malformed',
      'connectors with reversed logic (folglich for contrast)',
    ],
    intro:
        'The module gate, with a twist: defend your drawn side for four '
        'exchanges, then switch sides on command and beat your own '
        'arguments. Pass it and B2.2 unlocks; your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Turn the switch into a weapon',
        text:
            'Open the second half by reporting yourself: "Vorhin habe ich '
            'gesagt, die Kosten seien zu hoch — aber dieses Argument '
            'greift zu kurz, denn…". Self-quotation in Konjunktiv I is '
            'exactly what the examiners want to hear.',
      ),
    ],
  ),
];
