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
/// builder switches the closing report to German automatically.
const _b2Session = SpeakingSession(durationMinutes: 5, minExchanges: 8);

/// Konjunktiv I / reported speech — the module's core grammar.
const List<HelpMemoryTip> _konjunktivTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Konjunktiv I: stem + e',
    text:
        'Take the infinitive stem and add -**e**: er sag**e**, er hab**e**, '
        'er wiss**e**, er komm**e**, er müss**e**. The two anchors to '
        'memorize whole: **sein** → er **sei**, sie **seien**; and du/ihr '
        'forms (du sei**e**st, ihr sei**e**t) are rare in real reporting.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Fall back only on a collision',
    text:
        'When K I looks identical to the indicative — almost always in the '
        'plural: sie kommen, sie haben — switch to Konjunktiv II: sie '
        '**kämen**, sie **hätten**. If even K II matches the Präteritum '
        '(sie stiegen), use **würden** + infinitive: sie **würden steigen**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Past and future in reported speech',
    text:
        'All past tenses collapse into one: er **habe** gesehen / sie '
        '**sei** gewesen. Future and "would" both become **werde** + '
        'infinitive: er **werde** anrufen. Modals keep their stem: das '
        'Problem **müsse** gelöst werden.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'The indicative slip',
    text:
        'The classic error is sliding back mid-report: „Er sagte, er habe '
        'keine Zeit und *ist* müde." Every verb inside the report stays '
        'Konjunktiv: … und **sei** müde. Re-launch with a verb of saying '
        '(er habe betont, er habe gefordert) to reset yourself.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The minister said the plan was working',
    text: 'Der Minister sagte, der Plan **funktioniere** und die Zahlen '
        '**seien** besser als erwartet.',
  ),
];

/// Concessive & consecutive connectors + je…desto — argument logic.
const List<HelpMemoryTip> _connectorTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'dennoch vs folglich',
    text:
        '**dennoch** = nevertheless (contrast against expectation), '
        '**folglich** = consequently (logical result). Both are adverbs in '
        'position 1, so the verb comes right after: Dennoch **fahren** '
        'viele Auto. Folglich **braucht** die Stadt Regeln.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'je…desto is a double comparative',
    text:
        '**Je** + comparative + verb-final clause, **desto** + comparative '
        '+ verb in position 2: Je **mehr** Autos fahren, desto '
        '**schlechter** wird die Luft. Two comparatives, two word orders — '
        'miss one piece and the scaffold collapses.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Concede, then strike: zwar … dennoch',
    text:
        'Think of **zwar** as opening a door you slam with **dennoch**: '
        'admit the strongest counter-point first, then land your own. One '
        'honest zwar…dennoch per argument is the sound of B2.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Verb-final after dass and ob',
    text:
        'Most scaffolds end in dass or ob, and the verb must go to the '
        'end: Man muss bedenken, dass viele Menschen auf das Auto '
        'angewiesen **sind**. Es kommt darauf an, ob die Regeln '
        'funktionieren **werden**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'I admit that…, nevertheless…',
    text: 'Ich gebe zu, dass die Luft ein Problem ist, **dennoch** sind '
        'viele Menschen auf das Auto angewiesen.',
  ),
];

/// Statistics language: trend verbs and auf/um.
const List<HelpMemoryTip> _statsTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'auf lands, um travels',
    text:
        'steigen/sinken **auf** = the endpoint, steigen/sinken **um** = '
        'the distance: Der Anteil stieg **auf** 35 Prozent (where it '
        'landed) / stieg **um** 15 Prozentpunkte (how far it moved). Same '
        'climb, two prepositions.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Approximation in one syllable',
    text:
        '**knapp** 50 = just under 50, **gut** 50 = just over 50, **rund** '
        '50 = around 50. And ratios read as ordinals: **jeder Dritte** = '
        'one in three, **die Mehrheit** / **die Minderheit** for the two '
        'halves of any split.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Reflexive doubling and halving',
    text:
        'verdoppeln and halbieren need **sich**: Die Zahl hat **sich** '
        'verdoppelt. Drop the reflexive and you claim somebody actively '
        'doubled the number.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The share rose from 20 to 35 percent',
    text: 'Der Anteil stieg von 20 **auf** 35 Prozent — er hat sich also '
        'fast verdoppelt.',
  ),
];

/// Passive in all tenses and with modals — the exam's second pillar.
const List<HelpMemoryTip> _passiveTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Passive through the tenses',
    text:
        'werden + Partizip II, conjugated through time: Präsens es **wird** '
        'geregelt, Präteritum es **wurde** geregelt, Perfekt es **ist** '
        'geregelt **worden** (worden, not geworden!), Futur es **wird** '
        'geregelt **werden**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Passive with modals',
    text:
        'Modal + Partizip II + **werden** at the very end: Das **muss** '
        'geregelt **werden**. Die Zonen **sollten** eingerichtet '
        '**werden**. In reported speech the modal takes K I: das **müsse** '
        'geregelt werden.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'worden, not geworden',
    text:
        'In the Perfekt passive the participle of werden loses its ge-: '
        'Die Regeln sind verschärft **worden**. „geworden" belongs only to '
        'werden as a full verb (Er ist Lehrer geworden).',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The sprawl must be brought to order',
    text: 'Der Wildwuchs **muss** endlich geordnet **werden** — feste '
        'Zonen **sollten** schon längst eingerichtet worden sein.',
  ),
];

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
        'claim through it — grammar intact, meaning preserved.',
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
        'German arguments are built from fixed scaffolds — einerseits … '
        'andererseits, daraus folgt, dass …, je mehr …, desto … — and most '
        'of them end in a dass- or ob-clause that sends the verb to the end. '
        'Learn each scaffold as one unbreakable chunk with its word order '
        'built in.',
    tips: [
      ..._connectorTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Rebuild, do not decorate',
        text:
            'A scaffold is not a sticker on the front of your sentence: '
            '„dagegen spricht, dass…" forces the claim itself into a '
            'verb-final dass-clause. Say the whole chunk, then let the '
            'claim fall into its slot.',
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
        'reported speech with Konjunktiv I.',
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
        'Editorials argue without ever saying „ich finde": the stance lives '
        'in connectors like gewiss … dennoch and folglich, and claims are '
        'held at a distance with Konjunktiv I (ihre Fahrzeuge seien …). '
        'Read for where each „but" lands, then reproduce that distance '
        'yourself.',
    tips: [
      ..._konjunktivTips,
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
        'fallback I miss.',
    material:
        'Sentences to serve one at a time — read me only the English half; '
        'the German after the = is the reference answer (other correct '
        'German is acceptable). Konjunktiv I required, K II only as the '
        'correct fallback:\n'
        '1. She said that she was tired. = Sie sagte, sie sei müde.\n'
        '2. He said that he had no time. = Er sagte, er habe keine Zeit.\n'
        '3. The minister said that the plan was working. = Der Minister '
        'sagte, der Plan funktioniere.\n'
        '4. She said that they were coming tomorrow. (fallback!) = Sie '
        'sagte, sie kämen morgen.\n'
        '5. He claimed that he knew nothing about it. = Er behauptete, er '
        'wisse nichts davon.\n'
        '6. The newspaper wrote that prices were rising. (fallback!) = Die '
        'Zeitung schrieb, die Preise würden steigen.\n'
        '7. She said that she had seen the film. = Sie sagte, sie habe den '
        'Film gesehen.\n'
        '8. They said that they had no money. (fallback!) = Sie sagten, '
        'sie hätten kein Geld.\n'
        '9. He said that he would call later. = Er sagte, er werde später '
        'anrufen.\n'
        '10. The spokesperson said that the problem must be solved. = Der '
        'Sprecher sagte, das Problem müsse gelöst werden.',
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
        'Reported speech takes Konjunktiv I — stem + e (er sage, er habe, '
        'er wisse) plus the anchor sei — and falls back to Konjunktiv II '
        '(sie kämen, sie hätten) exactly where K I would look like the '
        'plain indicative. Three of these ten sentences test that fallback.',
    tips: [
      ..._konjunktivTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'dass is optional, Konjunktiv is not',
        text:
            'Both are correct: „Sie sagte, dass sie müde **sei**" and '
            '„Sie sagte, sie **sei** müde." Dropping dass moves the verb '
            'to position 2 but never lets you drop the Konjunktiv.',
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
        'came.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'auf etwas angewiesen sein = to depend on something · '
        'ich gebe zu, dass … = I admit that · '
        'zwar …, dennoch … = admittedly …, nevertheless · '
        'dagegen spricht, dass … = against it speaks the fact that · '
        'der Lieferverkehr = delivery traffic · '
        'die Einschränkung = the restriction · '
        'je mehr …, desto … = the more …, the more · '
        'daraus folgt, dass … = it follows that',
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
        'A B2 argument concedes before it counters: zwar / ich gebe zu, '
        'dass … opens the door, dennoch slams it, and folglich or je…desto '
        'draws the consequence. Defend the assigned anti position with '
        'that machinery, not with bare assertions.',
    tips: [
      ..._connectorTips,
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
        'reported speech, then bet fake or real — with a justification.',
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
        'Konjunktiv I is the grammar of not vouching: „Die Zeitung '
        'schreibe, die Zahl sei gestiegen" reports a claim without '
        'endorsing it. Interrogate every headline at that distance, then '
        'call the bluff with a folglich- or dennoch-sentence.',
    tips: [
      ..._konjunktivTips,
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
        'paragraph by paragraph.',
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
        'A Leserbrief is argument in miniature: thesis, two supported '
        'arguments, one concession (zwar …, dennoch …) — and every '
        'reference to the source text in Konjunktiv I: Die Autorin '
        'schreibe, der Wildwuchs müsse geordnet werden.',
    tips: [
      ..._connectorTips,
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
        'Konjunktiv I with correct fallbacks, never quoting directly.',
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
        'Sustained reported speech means every verb of a long retelling '
        'stays in Konjunktiv I — er habe gesagt, der Anteil sei gestiegen, '
        'die Dächer müssten gebaut werden — including modals and passives, '
        'with never a direct quote in the indicative.',
    tips: [
      ..._passiveTips,
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
        'row.',
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
        'German trend language pairs a small set of verbs (steigen, '
        'sinken, sich verdoppeln, stagnieren) with two prepositions: auf '
        'names the endpoint, um the difference. Add knapp / gut / rund for '
        'approximation and you can narrate any chart.',
    tips: [
      ..._statsTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Interpret, do not just read',
        text:
            'B2 wants the number plus its consequence: „Der Anteil hat '
            'sich verdoppelt — **folglich** braucht die Stadt mehr '
            'Abstellzonen." Every third item, bolt an interpretation onto '
            'the figure.',
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
        'character.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Sie sagen also, es gebe … = so you are saying there is … · '
        'Moment bitte, lassen Sie mich ausreden = one moment, let me '
        'finish · '
        'zusammenfassen = to summarize · '
        'der Standpunkt = the point of view · '
        'übertreiben = to exaggerate · '
        'sachlich bleiben = to stay objective · '
        'das Argument entkräften = to refute the argument · '
        'Wie erklären Sie das? = how do you explain that?',
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
        'A moderator stays neutral by summarizing in Konjunktiv I — „Sie '
        'sagen also, die Regeln seien überflüssig" — and steers with '
        'dennoch and folglich instead of taking sides. Summarize, '
        'challenge, keep order: grammar is your gavel.',
    tips: [
      ..._konjunktivTips,
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
        'own earlier arguments in Konjunktiv I before dismantling them.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'vorhin habe ich gesagt, … sei … = earlier I said that … was … · '
        'dieses Argument greift zu kurz = this argument falls short · '
        'das müsse geregelt werden = that would have to be regulated '
        '(reported) · '
        'zwar …, dennoch … = admittedly …, nevertheless · '
        'daraus folgt, dass … = it follows that · '
        'je mehr …, desto … = the more …, the more · '
        'zusammenfassend lässt sich sagen, dass … = in summary one can '
        'say that',
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
        'The module gate bundles everything: structured arguments with '
        'dennoch / folglich / je…desto, passive with modals (das müsse '
        'geregelt werden), and Konjunktiv I to report your own first-half '
        'arguments before you dismantle them. Pass it and B2.2 unlocks.',
    tips: [
      ..._passiveTips,
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
