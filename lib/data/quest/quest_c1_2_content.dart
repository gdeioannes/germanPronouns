import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **C1.2 — "Nuancieren"** Quest quizzes (Goethe C1). Big rocks: the
/// **subjective use of modal verbs** (inference & hearsay), **word formation**
/// (prefixes/suffixes), idioms and text cohesion.

/// 1. Kultur & Medien (gehobener Wortschatz).
final QuizContent questC12KulturContent = sentenceQuestQuiz(
  id: 'quest_c1_2_kultur',
  title: 'C1.2 · Kultur & Medien',
  promptLabel: 'Wort',
  subjectsLabel: 'Kultur',
  subjectColumnLabel: 'English',
  categoryLabel: 'Kultur',
  contextualLayout: true,
  intro: 'Elevated vocabulary for culture and media commentary.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Cultivated nouns',
      text:
          'die Wahrnehmung (perception), der Einfluss (influence), die '
          'Auseinandersetzung (engagement/debate), die Vielfalt (diversity).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Precise verbs',
      text:
          'prägen (to shape), hinterfragen (to question), vermitteln (to '
          'convey), wahrnehmen (to perceive).',
    ),
  ],
  items: [
    qsi(
      'Medien ____ unsere Sicht der Welt. (shape)',
      'prägen',
      'Media shape our view of the world.',
      'shape',
    ),
    qsi(
      'Man sollte Informationen kritisch ____. (question)',
      'hinterfragen',
      'One should critically question information.',
      'question',
    ),
    qsi(
      'Die kulturelle ____ einer Stadt ist wertvoll. (diversity)',
      'Vielfalt',
      'The cultural diversity of a city is valuable.',
      'diversity',
    ),
    qsi(
      'Kunst kann komplexe Gefühle ____. (convey)',
      'vermitteln',
      'Art can convey complex feelings.',
      'convey',
    ),
    qsi(
      'Die ____ mit dem Thema war intensiv. (engagement/debate)',
      'Auseinandersetzung',
      'The engagement with the topic was intense.',
      'engagement',
    ),
    qsi(
      'Der Roman wurde in zwanzig Sprachen ____. (translated)',
      'übersetzt',
      'The novel was translated into twenty languages.',
      'translated',
      accepted: ['uebersetzt'],
    ),
    qsi(
      'Die Ausstellung zeigt zeitgenössische ____. (art)',
      'Kunst',
      'The exhibition shows contemporary art.',
      'art',
    ),
    qsi(
      'Das Theaterstück bekam hervorragende ____. (reviews)',
      'Kritiken',
      'The play received excellent reviews.',
      'reviews',
    ),
    qsi(
      'Digitale Medien verändern die ____. (public sphere)',
      'Öffentlichkeit',
      'Digital media are changing the public sphere.',
      'public sphere',
      accepted: ['Oeffentlichkeit'],
    ),
    qsi(
      'Der Autor spielt mit kulturellen ____. (allusions)',
      'Anspielungen',
      'The author plays with cultural allusions.',
      'allusions',
    ),
    qsi(
      'Das Publikum reagierte mit großer ____. (enthusiasm)',
      'Begeisterung',
      'The audience reacted with great enthusiasm.',
      'enthusiasm',
    ),
    qsi(
      'Die Sendung will Wissen unterhaltsam ____. (present/convey)',
      'präsentieren',
      'The show wants to present knowledge entertainingly.',
      'present',
      accepted: ['praesentieren'],
    ),
    qsi(
      'Der Verlag ____ nur wenige Romane pro Jahr. (publishes)',
      'veröffentlicht',
      'The publisher publishes only a few novels a year.',
      'publish',
      accepted: ['veroeffentlicht'],
    ),
    qsi(
      'Das Festival fördert den kulturellen ____. (exchange)',
      'Austausch',
      'The festival promotes cultural exchange.',
      'exchange',
    ),
    qsi(
      'Ihre Werke gelten als bedeutendes kulturelles ____. (heritage)',
      'Erbe',
      'Her works count as important cultural heritage.',
      'heritage',
    ),
  ],
);

/// 2. Subjektive Modalverben: Vermutung (muss/dürfte/könnte).
final QuizContent questC12ModalVermutungContent = sentenceQuestQuiz(
  id: 'quest_c1_2_modal_vermutung',
  title: 'C1.2 · Subjektive Modalverben: Vermutung',
  promptLabel: 'Modalverb',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Sicherheit',
  categoryLabel: 'Vermutung',
  intro:
      'Modal verbs can express the speaker’s **degree of certainty** about a '
      'fact, not ability or obligation: muss (almost certain) > dürfte > könnte/'
      'kann (possible) > mag.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Certainty scale',
      text:
          '"Er __muss__ krank sein" = he must be ill (I’m sure). "Er __dürfte__ '
          'krank sein" = he’s probably ill. "Er __könnte__ krank sein" = he '
          'might be.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'About a fact, not a duty',
      text: 'Here muss/dürfte say how sure I am — not what someone has to do.',
    ),
  ],
  items: [
    qsi(
      'Das Licht brennt. Er ____ zu Hause sein. (almost certain)',
      'muss',
      'The light is on. He must be home.',
      'muss (sure)',
    ),
    qsi(
      'Bei dem Wetter ____ der Zug Verspätung haben. (probably)',
      'dürfte',
      'In this weather the train is probably delayed.',
      'dürfte (probable)',
    ),
    qsi(
      'Sie antwortet nicht. Sie ____ schon schlafen. (might)',
      'könnte',
      'She’s not answering. She might already be asleep.',
      'könnte (possible)',
    ),
    qsi(
      'Das ist sein Auto. Er ____ schon da sein. (almost certain)',
      'muss',
      'That’s his car. He must already be here.',
      'muss (sure)',
    ),
    qsi(
      'Es ist dunkel. Es ____ schon spät sein. (probably)',
      'dürfte',
      'It’s dark. It’s probably late already.',
      'dürfte (probable)',
    ),
    qsi(
      'Der Brief ____ inzwischen angekommen sein. (probably)',
      'dürfte',
      'The letter has probably arrived by now.',
      'dürfte (Brief)',
    ),
    qsi(
      'Niemand öffnet. Sie ____ nicht zu Hause sein. (cannot)',
      'kann',
      'Nobody answers. She cannot be at home.',
      'kann nicht (impossible)',
    ),
    qsi(
      'Das Paket ____ schon morgen ankommen. (might)',
      'könnte',
      'The parcel might arrive as early as tomorrow.',
      'könnte (Paket)',
    ),
    qsi(
      'Er kennt jede Straße. Er ____ hier aufgewachsen sein. '
          '(almost certain)',
      'muss',
      'He knows every street. He must have grown up here.',
      'muss (aufgewachsen)',
    ),
    qsi(
      'Sie ____ etwa vierzig sein. (probably)',
      'dürfte',
      'She is probably about forty.',
      'dürfte (Alter)',
    ),
    qsi(
      'Das ____ stimmen, aber sicher bin ich nicht. (may)',
      'mag',
      'That may be true, but I am not sure.',
      'mag (vielleicht)',
    ),
    qsi(
      'Der Chef ist nicht da. Er ____ im Urlaub sein. (might)',
      'könnte',
      'The boss is not here. He might be on holiday.',
      'könnte (Urlaub)',
    ),
    qsi(
      'So ein Fehler ____ jedem passieren. (can)',
      'kann',
      'Such a mistake can happen to anyone.',
      'kann (jedem)',
    ),
    qsi(
      'Nach der langen Reise ____ sie müde sein. (almost certain)',
      'muss',
      'After the long journey she must be tired.',
      'muss (müde)',
    ),
    qsi(
      'Das Projekt ____ bis Freitag fertig sein. (probably)',
      'dürfte',
      'The project should be finished by Friday.',
      'dürfte (Projekt)',
    ),
  ],
);

/// 3. Subjektive Modalverben: Hörensagen (sollen/wollen).
final QuizContent questC12ModalHoerensagenContent = sentenceQuestQuiz(
  id: 'quest_c1_2_modal_hoerensagen',
  title: 'C1.2 · Subjektive Modalverben: Hörensagen',
  promptLabel: 'Modalverb',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Quelle',
  categoryLabel: 'Hörensagen',
  intro:
      'Two modals report claims: **sollen** = "is said to" (others claim); '
      '**wollen** = "claims to" (the subject claims it of themselves).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'sollen vs wollen',
      text:
          '"Er __soll__ reich sein" = people say he’s rich. "Er __will__ alles '
          'gesehen haben" = he claims to have seen everything.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Distance from the claim',
      text:
          'Both mark that you are reporting, not confirming. Useful for '
          'gossip, rumours and unverified news.',
    ),
  ],
  items: [
    qsi(
      'Er ____ sehr reich sein. (people say)',
      'soll',
      'He is said to be very rich.',
      'soll (hearsay)',
    ),
    qsi(
      'Sie ____ den Unfall gesehen haben. (she claims)',
      'will',
      'She claims to have seen the accident.',
      'will (self-claim)',
    ),
    qsi(
      'Das Restaurant ____ ausgezeichnet sein. (people say)',
      'soll',
      'The restaurant is said to be excellent.',
      'soll (hearsay)',
    ),
    qsi(
      'Er ____ nichts davon gewusst haben. (he claims)',
      'will',
      'He claims to have known nothing about it.',
      'will (self-claim)',
    ),
    qsi(
      'Der Film ____ sehr spannend sein. (people say)',
      'soll',
      'The film is said to be very exciting.',
      'soll (hearsay)',
    ),
    qsi(
      'Die Insel ____ wunderschön sein. (people say)',
      'soll',
      'The island is said to be beautiful.',
      'soll (Insel)',
    ),
    qsi(
      'Er ____ den Marathon in drei Stunden gelaufen sein. (he claims)',
      'will',
      'He claims to have run the marathon in three hours.',
      'will (Marathon)',
    ),
    qsi(
      'Die Firma ____ vor der Pleite stehen. (people say)',
      'soll',
      'The company is said to be near bankruptcy.',
      'soll (Firma)',
    ),
    qsi(
      'Sie ____ die Wahrheit gesagt haben. (she claims)',
      'will',
      'She claims to have told the truth.',
      'will (Wahrheit)',
    ),
    qsi(
      'Das Hotel ____ fünf Sterne haben. (people say)',
      'soll',
      'The hotel is said to have five stars.',
      'soll (Hotel)',
    ),
    qsi(
      'Der Zeuge ____ alles genau beobachtet haben. (he claims)',
      'will',
      'The witness claims to have observed everything closely.',
      'will (Zeuge)',
    ),
    qsi(
      'Das Medikament ____ sehr wirksam sein. (people say)',
      'soll',
      'The medicine is said to be very effective.',
      'soll (Medikament)',
    ),
    qsi(
      'Niemand ____ etwas bemerkt haben. (they claim)',
      'will',
      'Nobody claims to have noticed anything.',
      'will (niemand)',
    ),
    qsi(
      'Der neue Chef ____ sehr streng sein. (people say)',
      'soll',
      'The new boss is said to be very strict.',
      'soll (Chef)',
    ),
    qsi(
      'Sie ____ das Bild selbst gemalt haben. (she claims)',
      'will',
      'She claims to have painted the picture herself.',
      'will (Bild)',
    ),
  ],
);

/// 4. Sprechen: Andeuten & abschwächen.
final QuizContent questC12SprechenAbschwaechenContent = speakQuestQuiz(
  id: 'quest_c1_2_sprechen_abschwaechen',
  title: 'C1.2 · Sprechen: Andeuten & abschwächen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'Hedge and soften your statements — a mark of nuanced C1 speech. Listen '
      'and repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hedging phrases',
      text:
          '"Es könnte sein, dass …", "soweit ich weiß", "tendenziell", "in '
          'gewisser Weise".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Polite disagreement',
      text: '"Ich würde eher sagen, dass …" softens a correction.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
      phrase: 'Es könnte durchaus sein, dass ich mich irre.',
      meaning: 'It could well be that I’m wrong.',
    ),
    SpeakPhrase(
      phrase: 'Soweit ich weiß, ist das nicht ganz richtig.',
      meaning: 'As far as I know, that’s not quite right.',
    ),
    SpeakPhrase(
      phrase: 'Ich würde eher sagen, dass es komplizierter ist.',
      meaning: 'I’d rather say that it’s more complicated.',
    ),
    SpeakPhrase(
      phrase: 'In gewisser Weise haben Sie recht.',
      meaning: 'In a certain way you’re right.',
    ),
    SpeakPhrase(
      phrase: 'Das hängt letztlich vom Kontext ab.',
      meaning: 'Ultimately that depends on the context.',
    ),
    SpeakPhrase(
      phrase: 'Ich möchte mich da nicht festlegen.',
      meaning: 'I’d rather not commit on that.',
    ),
  ],
);

/// 5. Wortbildung: Vorsilben (ver-/zer-/ent-/be-).
final QuizContent questC12WortbildungVorContent = sentenceQuestQuiz(
  id: 'quest_c1_2_wortbildung_vor',
  title: 'C1.2 · Wortbildung: Vorsilben',
  promptLabel: 'Vorsilbe',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Vorsilbe',
  intro:
      'Prefixes change a verb’s meaning systematically: **ver-** (away/wrong/'
      'completion), **zer-** (to pieces), **ent-** (removal/escape), **be-** '
      '(makes a verb transitive).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Prefix meanings',
      text:
          'ver-laufen (go wrong), zer-brechen (shatter), ent-fliehen (escape), '
          'be-antworten (answer something).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Inseparable',
      text:
          'ver-/zer-/ent-/be- are inseparable: they stay attached and the '
          'participle has no ge- (verkauft, not gevergekauft).',
    ),
  ],
  items: [
    qsi(
      'Ich muss diese Frage noch be____. (answer)',
      'antworten',
      'I still have to answer this question.',
      'beantworten',
    ),
    qsi(
      'Die Vase ist zer____. (shattered)',
      'brochen',
      'The vase is shattered.',
      'zerbrochen',
    ),
    qsi(
      'Der Gefangene konnte ent____. (escape)',
      'fliehen',
      'The prisoner managed to escape.',
      'entfliehen',
    ),
    qsi(
      'Wir haben uns total ver____. (got lost)',
      'laufen',
      'We got completely lost.',
      'verlaufen',
    ),
    qsi(
      'Bitte be____ Sie das Formular vollständig. (process → be+arbeiten)',
      'arbeiten',
      'Please process the form completely.',
      'bearbeiten',
    ),
    qsi(
      'Der Spiegel ist in tausend Stücke zer____. (sprungen)',
      'sprungen',
      'The mirror shattered into a thousand pieces.',
      'zersprungen',
    ),
    qsi(
      'Ich habe den Termin völlig ver____. (gessen)',
      'gessen',
      'I completely forgot the appointment.',
      'vergessen',
    ),
    qsi(
      'Die Forscher konnten den Code ent____. (schlüsseln)',
      'schlüsseln',
      'The researchers managed to decode the code.',
      'entschlüsseln',
      accepted: ['schluesseln'],
    ),
    qsi(
      'Er hat die Frage leider miss____. (verstanden)',
      'verstanden',
      'Unfortunately he misunderstood the question.',
      'missverstanden',
    ),
    qsi(
      'Sie hat ihr Ziel endlich er____. (reicht)',
      'reicht',
      'She finally reached her goal.',
      'erreicht',
    ),
    qsi(
      'Bitte be____ Sie den Rasen nicht. (treten)',
      'treten',
      'Please do not step on the lawn.',
      'betreten',
    ),
    qsi(
      'Der Fleck lässt sich leicht ent____. (fernen)',
      'fernen',
      'The stain is easy to remove.',
      'entfernen',
    ),
    qsi(
      'Das Eis ist in der Sonne zer____. (laufen)',
      'laufen',
      'The ice cream melted apart in the sun.',
      'zerlaufen',
    ),
    qsi(
      'Wir haben den Abend sehr ge____. (nossen)',
      'nossen',
      'We enjoyed the evening very much.',
      'genossen',
    ),
    qsi(
      'Der Zug ist dem Unwetter knapp ent____. (kommen)',
      'kommen',
      'The train narrowly escaped the storm.',
      'entkommen',
    ),
  ],
);

/// 6. Wortbildung: Nachsilben (-heit/-ung/-bar …).
final QuizContent questC12WortbildungNachContent = sentenceQuestQuiz(
  id: 'quest_c1_2_wortbildung_nach',
  title: 'C1.2 · Wortbildung: Nachsilben',
  promptLabel: 'Nachsilbe',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bildung',
  categoryLabel: 'Nachsilbe',
  intro:
      'Suffixes derive new words and signal gender: **-heit/-keit** and '
      '**-ung** make feminine abstract nouns; **-los** (without), **-voll** '
      '(full of) make adjectives.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Suffix → gender (E2 callback)',
      text:
          '-heit/-keit/-ung/-schaft/-tion → die. das Glück → die Freiheit, '
          'die Möglichkeit, die Hoffnung.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Adjective suffixes',
      text:
          'arbeits-los (unemployed), hoffnungs-voll (hopeful), kind-isch '
          '(childish) vs kind-lich (childlike).',
    ),
  ],
  items: [
    qsi('frei → die ____ (freedom)', 'Freiheit', 'freedom', '-heit'),
    qsi(
      'möglich → die ____ (possibility)',
      'Möglichkeit',
      'possibility',
      '-keit',
    ),
    qsi('hoffen → die ____ (hope)', 'Hoffnung', 'hope', '-ung'),
    qsi(
      'Arbeit → arbeits____ (without work)',
      'los',
      'unemployed (without work)',
      '-los',
    ),
    qsi('Hoffnung → hoffnungs____ (full of hope)', 'voll', 'hopeful', '-voll'),
    qsi('krank → die ____ (illness)', 'Krankheit', 'illness', '-heit (krank)'),
    qsi(
      'einsam → die ____ (loneliness)',
      'Einsamkeit',
      'loneliness',
      '-keit (einsam)',
    ),
    qsi(
      'lösen → die ____ (solution)',
      'Lösung',
      'solution',
      '-ung (lösen)',
      accepted: ['Loesung'],
    ),
    qsi(
      'Freund → die ____ (friendship)',
      'Freundschaft',
      'friendship',
      '-schaft',
    ),
    qsi('Kind → kind____ (childlike)', 'lich', 'childlike', '-lich (kindlich)'),
    qsi(
      'Wolke → wolken____ (cloudless)',
      'los',
      'cloudless',
      '-los (wolkenlos)',
    ),
    qsi('Wert → wert____ (valuable)', 'voll', 'valuable', '-voll (wertvoll)'),
    qsi('Angst → ängst____ (anxious)', 'lich', 'anxious', '-lich (ängstlich)'),
    qsi('Salz → salz____ (salty)', 'ig', 'salty', '-ig (salzig)'),
    qsi(
      'Traum → traum____ (dreamlike, wonderful)',
      'haft',
      'dreamlike',
      '-haft (traumhaft)',
    ),
  ],
);

/// 7. Hören: Eine Reportage.
final QuizContent questC12HoerenReportageContent = listeningQuestQuiz(
  id: 'quest_c1_2_hoeren_reportage',
  title: 'C1.2 · Hören: Reportage',
  category: 'Media',
  passageTitle: 'Reportage: Ehrenamt',
  passage:
      'Jeden Samstag trifft sich eine Gruppe Freiwilliger, um in ihrem Viertel '
      'zu helfen. Die meisten von ihnen, so heißt es, seien selbst einmal auf '
      'Unterstützung angewiesen gewesen. Eine Teilnehmerin erzählt, sie habe '
      'durch das Ehrenamt neue Freunde gefunden. Experten betonen, '
      'freiwilliges Engagement stärke nicht nur die Gemeinschaft, sondern auch '
      'das eigene Wohlbefinden. Dennoch fehlt es vielerorts an Helfern.',
  passageTranslation:
      'Every Saturday a group of volunteers meets to help in their '
      'neighbourhood. Most of them, it is said, were once dependent on support '
      'themselves. One participant says she made new friends through the '
      'voluntary work. Experts stress that voluntary engagement strengthens not '
      'only the community but also one’s own well-being. Nevertheless, in many '
      'places there is a lack of helpers.',
  questions: const [
    ReadingQuestion(
      question: 'Wofür treffen sich die Freiwilligen?',
      questionTranslation: 'What do the volunteers meet for?',
      options: [
        'um im Viertel zu helfen',
        'um Sport zu treiben',
        'um Geld zu sammeln',
      ],
      optionsTranslation: [
        'to help in the neighbourhood',
        'to do sport',
        'to collect money',
      ],
      correctIndex: 0,
      explanation: '"… um in ihrem Viertel zu helfen."',
    ),
    ReadingQuestion(
      question: 'Was hat eine Teilnehmerin durch das Ehrenamt gewonnen?',
      questionTranslation:
          'What did one participant gain through the volunteering?',
      options: ['neue Freunde', 'mehr Geld', 'einen Job'],
      optionsTranslation: ['new friends', 'more money', 'a job'],
      correctIndex: 0,
      explanation: '"… sie habe durch das Ehrenamt neue Freunde gefunden."',
    ),
    ReadingQuestion(
      question: 'Welches Problem nennt die Reportage am Ende?',
      questionTranslation: 'What problem does the report mention at the end?',
      options: [
        'Es fehlt an Helfern.',
        'Es gibt zu viele Helfer.',
        'Das Ehrenamt ist verboten.',
      ],
      optionsTranslation: [
        'There is a lack of helpers.',
        'There are too many helpers.',
        'Volunteering is banned.',
      ],
      correctIndex: 0,
      explanation: '"Dennoch fehlt es vielerorts an Helfern."',
    ),
    ReadingQuestion(
      question: 'Was wird über die meisten Freiwilligen gesagt?',
      questionTranslation: 'What is said about most of the volunteers?',
      options: [
        'Sie seien selbst einmal auf Hilfe angewiesen gewesen.',
        'Sie seien alle sehr reich.',
        'Sie kämen aus dem Ausland.',
      ],
      optionsTranslation: [
        'They were once dependent on help themselves.',
        'They are all very rich.',
        'They come from abroad.',
      ],
      correctIndex: 0,
      explanation:
          '"Die meisten … seien selbst einmal auf Unterstützung '
          'angewiesen gewesen."',
    ),
    ReadingQuestion(
      question: 'Was stärkt das Ehrenamt laut Experten außer der Gemeinschaft?',
      questionTranslation:
          'Besides the community, what does volunteering strengthen, per experts?',
      options: ['das eigene Wohlbefinden', 'die Wirtschaft', 'die Politik'],
      optionsTranslation: ['one’s own well-being', 'the economy', 'politics'],
      correctIndex: 0,
      explanation:
          '"… stärke nicht nur die Gemeinschaft, sondern auch das eigene '
          'Wohlbefinden."',
    ),
  ],
  intro:
      'A reportage — you only hear it. Lots of reported speech (seien, habe, '
      'stärke). Track the benefit and the problem. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'so heißt es',
      text:
          '"so heißt es" / "Experten betonen" introduce reported claims — note '
          'who says what.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Dennoch flags the twist',
      text:
          'After all the positives, "Dennoch …" introduces the catch — the '
          'problem.',
    ),
  ],
);

/// 8. Redewendungen & feste Wendungen.
final QuizContent questC12RedewendungenContent = sentenceQuestQuiz(
  id: 'quest_c1_2_redewendungen',
  title: 'C1.2 · Redewendungen',
  promptLabel: 'Wort',
  subjectsLabel: 'Redewendungen',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Redewendung',
  intro:
      'Idioms make speech vivid but can’t be translated word for word. Learn '
      'the fixed wording. (E20: false-friend idioms abound.)',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Useful idioms',
      text:
          '"die Daumen drücken" (keep fingers crossed), "ins Wasser fallen" '
          '(fall through), "Tomaten auf den Augen haben" (not notice the '
          'obvious).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Fixed wording',
      text:
          'You can’t swap the words: it’s "die Daumen drücken", not "die '
          'Finger drücken".',
    ),
  ],
  items: [
    qsi(
      'Ich drücke dir die ____. (keep fingers crossed)',
      'Daumen',
      'I’ll keep my fingers crossed for you.',
      'die Daumen drücken',
    ),
    qsi(
      'Das Konzert ist ins ____ gefallen. (fell through)',
      'Wasser',
      'The concert fell through.',
      'ins Wasser fallen',
    ),
    qsi(
      'Du hast wohl ____ auf den Augen! (don’t see the obvious)',
      'Tomaten',
      'You clearly don’t see the obvious!',
      'Tomaten auf den Augen',
    ),
    qsi(
      'Das ist doch Schnee von ____. (old news)',
      'gestern',
      'That’s old news.',
      'Schnee von gestern',
    ),
    qsi(
      'Er nimmt kein ____ vor den Mund. (speaks bluntly)',
      'Blatt',
      'He doesn’t mince his words.',
      'kein Blatt vor den Mund nehmen',
    ),
    qsi(
      'Da hast du den Nagel auf den ____ getroffen. (hit the nail)',
      'Kopf',
      'You hit the nail on the head.',
      'den Nagel auf den Kopf treffen',
    ),
    qsi(
      'Bei Mathe verstehe ich nur ____. (all Greek to me)',
      'Bahnhof',
      'Maths is all Greek to me.',
      'nur Bahnhof verstehen',
    ),
    qsi(
      'Das neue Auto geht ganz schön ins ____. (very expensive)',
      'Geld',
      'The new car really eats into the money.',
      'ins Geld gehen',
    ),
    qsi(
      'Er hat mal wieder Schwein ____. (was lucky)',
      'gehabt',
      'He got lucky once again.',
      'Schwein gehabt',
    ),
    qsi(
      'Jetzt schlägt’s aber ____! (that’s the limit)',
      'dreizehn',
      'Now that really is the limit!',
      'jetzt schlägt’s dreizehn',
    ),
    qsi(
      'Er ist mit dem falschen Fuß ____. (bad mood since morning)',
      'aufgestanden',
      'He got up on the wrong side of the bed.',
      'mit dem falschen Fuß aufstehen',
    ),
    qsi(
      'Fußball ist einfach nicht mein ____. (not my thing)',
      'Bier',
      'Football is just not my thing.',
      'nicht mein Bier',
    ),
    qsi(
      'Kauf nicht die Katze im ____! (buy blind)',
      'Sack',
      'Don’t buy a pig in a poke!',
      'die Katze im Sack kaufen',
    ),
    qsi(
      'Wir sitzen doch alle im selben ____. (same situation)',
      'Boot',
      'We are all in the same boat.',
      'im selben Boot sitzen',
    ),
    qsi(
      'Er wirft das Geld zum ____ hinaus. (wastes money)',
      'Fenster',
      'He throws money out of the window.',
      'Geld zum Fenster hinauswerfen',
    ),
  ],
);

/// 9. Lesen: Eine Kolumne / ein Kommentar.
final QuizContent questC12LesenKolumneContent = readingQuestQuiz(
  id: 'quest_c1_2_lesen_kolumne',
  title: 'C1.2 · Lesen: Eine Kolumne',
  category: 'Media',
  passageTitle: 'Kolumne: Immer erreichbar',
  passage:
      'Wann haben Sie zuletzt eine Stunde lang nichts getan, ohne zum Handy zu '
      'greifen? Eben. Wir leben in einer Zeit, in der ständige Erreichbarkeit '
      'als selbstverständlich gilt. Wer nicht sofort antwortet, gilt schnell als '
      'unhöflich. Doch ich frage mich, ob wir dabei nicht etwas Wichtiges '
      'verlieren. Vielleicht sollten wir die Kunst des Wartens neu erlernen. '
      'Denn nicht jede Nachricht muss in derselben Minute beantwortet werden, in '
      'der sie eintrifft.',
  passageTranslation:
      'When did you last do nothing for an hour without reaching for your '
      'phone? Exactly. We live in a time in which constant availability is taken '
      'for granted. Anyone who doesn’t answer immediately is quickly seen as '
      'rude. But I wonder whether we aren’t losing something important in the '
      'process. Perhaps we should relearn the art of waiting. Because not every '
      'message has to be answered in the same minute it arrives.',
  questions: const [
    ReadingQuestion(
      question: 'Was kritisiert die Kolumne?',
      questionTranslation: 'What does the column criticise?',
      options: [
        'die ständige Erreichbarkeit',
        'zu langsames Internet',
        'zu teure Handys',
      ],
      optionsTranslation: [
        'constant availability',
        'too slow internet',
        'phones that are too expensive',
      ],
      correctIndex: 0,
      explanation: '"… ständige Erreichbarkeit als selbstverständlich gilt."',
    ),
    ReadingQuestion(
      question: 'Wie wird jemand gesehen, der nicht sofort antwortet?',
      questionTranslation:
          'How is someone seen who doesn’t answer immediately?',
      options: ['als unhöflich', 'als entspannt', 'als klug'],
      optionsTranslation: ['as rude', 'as relaxed', 'as clever'],
      correctIndex: 0,
      explanation: '"Wer nicht sofort antwortet, gilt … als unhöflich."',
    ),
    ReadingQuestion(
      question: 'Was schlägt der Autor vor?',
      questionTranslation: 'What does the author suggest?',
      options: [
        'die Kunst des Wartens neu zu erlernen',
        'das Handy abzuschaffen',
        'schneller zu antworten',
      ],
      optionsTranslation: [
        'to relearn the art of waiting',
        'to abolish the phone',
        'to answer faster',
      ],
      correctIndex: 0,
      explanation: '"… die Kunst des Wartens neu erlernen."',
    ),
  ],
  intro:
      'A newspaper column — personal, ironic in places ("Eben."), with a '
      'rhetorical question opening. A nuanced C1 read.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Rhetorical question',
      text:
          'The opening question isn’t really a question — it sets up the '
          'argument. The thesis follows.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Doch, ich frage mich …',
      text:
          'The author’s own view starts after "Doch" — the suggestion comes at '
          'the end.',
    ),
  ],
);

/// 10. Textkohäsion: Verweismittel & Konnektoren.
final QuizContent questC12KohaesionContent = sentenceQuestQuiz(
  id: 'quest_c1_2_kohaesion',
  title: 'C1.2 · Textkohäsion',
  promptLabel: 'Verweismittel',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Funktion',
  categoryLabel: 'Kohäsion',
  intro:
      'Cohesive devices tie a text together: pronominal adverbs (dadurch, '
      'dabei, dafür) and reference words (dies, jener, ein solcher) point back '
      'to what was said.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'da-compounds refer back',
      text:
          '"Er ist umgezogen. __Dadurch__ hat er einen kürzeren Weg." dadurch '
          '= by means of that.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Reference words',
      text:
          'dies/dieser (this just-mentioned), ein solcher (such a one), '
          'derartig (of that kind).',
    ),
  ],
  items: [
    qsi(
      'Er trainiert viel. ____ bleibt er fit. (by that means)',
      'Dadurch',
      'He trains a lot. By that he stays fit.',
      'dadurch',
    ),
    qsi(
      'Sie sparte lange. ____ konnte sie reisen. (because of that)',
      'Dadurch',
      'She saved for a long time. Because of that she could '
          'travel.',
      'dadurch',
    ),
    qsi(
      'Das Problem ist komplex. ____ braucht Zeit. (this)',
      'Dies',
      'The problem is complex. This needs time.',
      'dies',
    ),
    qsi(
      'Er hat sich entschuldigt. ____ war ich überrascht. (about that)',
      'Darüber',
      'He apologised. I was surprised about that.',
      'darüber',
    ),
    qsi(
      'Ein ____ Verhalten ist selten. (such a)',
      'solches',
      'Such behaviour is rare.',
      'ein solches',
    ),
    qsi(
      'Zuerst kam er zu spät. ____ vergaß er die Unterlagen. (in addition)',
      'Außerdem',
      'First he was late. In addition he forgot the documents.',
      'außerdem (Kohäsion)',
      accepted: ['Ausserdem'],
    ),
    qsi(
      'Die Preise steigen. ____ sinken die Löhne. (at the same time)',
      'Gleichzeitig',
      'Prices are rising. At the same time wages are '
          'falling.',
      'gleichzeitig',
    ),
    qsi(
      'Er versprach zu helfen. ____ hielt er sein Wort. (indeed)',
      'Tatsächlich',
      'He promised to help. And indeed he kept his word.',
      'tatsächlich',
      accepted: ['Tatsaechlich'],
    ),
    qsi(
      'Viele lehnen den Plan ab. ____ gibt es auch Zustimmung. (yet)',
      'Dennoch',
      'Many reject the plan. Yet there is also approval.',
      'dennoch (Zustimmung)',
    ),
    qsi(
      'Das Experiment scheiterte. ____ lernten wir viel. '
          '(nonetheless, formal)',
      'Gleichwohl',
      'The experiment failed. Nonetheless we learned a lot.',
      'gleichwohl',
    ),
    qsi(
      'Er hat nicht bezahlt. ____ wurde der Vertrag gekündigt. '
          '(consequently)',
      'Folglich',
      'He did not pay. Consequently the contract was terminated.',
      'folglich (Kohäsion)',
    ),
    qsi(
      'Erst prüfen wir die Daten. ____ ziehen wir Schlüsse. (afterwards)',
      'Anschließend',
      'First we check the data. Afterwards we draw '
          'conclusions.',
      'anschließend',
      accepted: ['Anschliessend'],
    ),
    qsi(
      'Zum einen fehlt Geld, zum ____ fehlt Zeit. (zum einen … zum anderen)',
      'anderen',
      'For one thing money is lacking, for another time.',
      'zum einen … zum anderen',
    ),
    qsi(
      'Die Zahlen sind schlecht. Der Grund ____ ist die Krise. (for that)',
      'dafür',
      'The figures are bad. The reason for that is the crisis.',
      'dafür',
      accepted: ['dafuer'],
    ),
    qsi(
      'Er sprach lange. ____ kam er zum Punkt. (finally)',
      'Schließlich',
      'He spoke for a long time. Finally he got to the point.',
      'schließlich',
      accepted: ['Schliesslich'],
    ),
  ],
);

/// 11. Diktat: Redewendungen & Nuancen.
final QuizContent questC12DiktatContent = dictationQuestQuiz(
  id: 'quest_c1_2_diktat_idiom',
  title: 'C1.2 · Diktat: Nuancen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'A dictation with idioms and subjective modals. You HEAR a sentence and '
      'TYPE it. Listen for the fixed idiom wording and modal verbs of certainty.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Idioms are fixed',
      text:
          'Write the exact words of the idiom (die Daumen drücken), even if '
          'they sound odd literally.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Modal of inference',
      text:
          '"Er muss krank sein" here means "he must be ill" (certainty), not '
          'obligation. Just write what you hear.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
      phrase: 'Ich drücke dir für die Prüfung die Daumen.',
      meaning: 'I’ll keep my fingers crossed for the exam.',
    ),
    SpeakPhrase(
      phrase: 'Bei dem Licht muss er zu Hause sein.',
      meaning: 'With that light he must be at home.',
    ),
    SpeakPhrase(
      phrase: 'Das Restaurant soll ausgezeichnet sein.',
      meaning: 'The restaurant is said to be excellent.',
    ),
    SpeakPhrase(
      phrase: 'Soweit ich weiß, ist das nicht ganz richtig.',
      meaning: 'As far as I know, that’s not quite right.',
    ),
    SpeakPhrase(
      phrase: 'Er nimmt kein Blatt vor den Mund.',
      meaning: 'He doesn’t mince his words.',
    ),
    SpeakPhrase(
      phrase: 'Es könnte durchaus sein, dass ich mich irre.',
      meaning: 'It could well be that I’m mistaken.',
    ),
    SpeakPhrase(
      phrase: 'Da hast du den Nagel auf den Kopf getroffen.',
      meaning: 'You hit the nail on the head there.',
    ),
    SpeakPhrase(
      phrase: 'Wir sitzen doch alle im selben Boot.',
      meaning: 'We are all in the same boat after all.',
    ),
    SpeakPhrase(
      phrase: 'Der neue Kollege soll sehr erfahren sein.',
      meaning: 'The new colleague is said to be very experienced.',
    ),
    SpeakPhrase(
      phrase: 'Sie will von nichts gewusst haben.',
      meaning: 'She claims to have known nothing.',
    ),
    SpeakPhrase(
      phrase: 'Das dürfte kein Problem sein.',
      meaning: 'That should not be a problem.',
    ),
    SpeakPhrase(
      phrase: 'Ich verstehe bei diesem Thema nur Bahnhof.',
      meaning: 'This topic is all Greek to me.',
    ),
    SpeakPhrase(
      phrase: 'Er hat mal wieder Schwein gehabt.',
      meaning: 'He got lucky once again.',
    ),
    SpeakPhrase(
      phrase: 'Das Angebot mag verlockend sein, aber es ist riskant.',
      meaning: 'The offer may be tempting, but it is risky.',
    ),
    SpeakPhrase(
      phrase: 'Kauf nicht die Katze im Sack!',
      meaning: 'Don’t buy a pig in a poke!',
    ),
  ],
);

/// 12. Sprechen: Ironie & Betonung.
final QuizContent questC12SprechenIronieContent = speakQuestQuiz(
  id: 'quest_c1_2_sprechen_ironie',
  title: 'C1.2 · Sprechen: Ironie & Betonung',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'Tone and stress change meaning. Listen and repeat, copying the '
      'intonation — irony lives in the melody.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Stress carries irony',
      text:
          '"Na __toll__." said flatly means the opposite. Copy the falling, '
          'dry tone.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Particles add attitude',
      text:
          '"Das ist ja __wunderbar__ …" with a sigh signals irony, not '
          'delight.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
      phrase: 'Na toll, jetzt regnet es auch noch.',
      meaning: 'Great, now it’s raining too. (ironic)',
    ),
    SpeakPhrase(
      phrase: 'Das hast du ja wieder mal toll gemacht.',
      meaning: 'You really did a great job again. (ironic)',
    ),
    SpeakPhrase(
      phrase: 'Wie schön, dass du endlich kommst.',
      meaning: 'How nice that you finally come. (can be ironic)',
    ),
    SpeakPhrase(
      phrase: 'Das war ja klar.',
      meaning: 'That was obvious / typical.',
    ),
    SpeakPhrase(
      phrase: 'Ehrlich gesagt finde ich das nicht so gut.',
      meaning: 'Honestly, I don’t find that so good.',
    ),
    SpeakPhrase(phrase: 'Im Ernst jetzt?', meaning: 'Are you serious?'),
  ],
);

/// 13. Hören: Ein Hörspiel-Ausschnitt.
final QuizContent questC12HoerenHoerspielContent = listeningQuestQuiz(
  id: 'quest_c1_2_hoeren_hoerspiel',
  title: 'C1.2 · Hören: Hörspiel',
  category: 'Arts',
  passageTitle: 'Hörspiel: Der späte Gast',
  passage:
      'Es war kurz nach Mitternacht, als es an der Tür klopfte. Anna zögerte. '
      'Wer konnte das um diese Zeit sein? Vorsichtig öffnete sie. Vor ihr stand '
      'ein alter Mann, durchnässt vom Regen. "Verzeihen Sie die späte Störung", '
      'sagte er leise, "aber mein Auto ist liegengeblieben, und Ihres ist das '
      'einzige Haus mit Licht." Anna atmete auf und bat ihn herein.',
  passageTranslation:
      'It was shortly after midnight when there was a knock at the door. Anna '
      'hesitated. Who could it be at this hour? Cautiously she opened. Before '
      'her stood an old man, soaked from the rain. "Forgive the late '
      'disturbance," he said quietly, "but my car has broken down, and yours is '
      'the only house with a light on." Anna breathed a sigh of relief and asked '
      'him in.',
  questions: const [
    ReadingQuestion(
      question: 'Zu welcher Zeit klopfte es an der Tür?',
      questionTranslation: 'At what time did someone knock at the door?',
      options: ['am frühen Morgen', 'kurz nach Mitternacht', 'am Nachmittag'],
      optionsTranslation: [
        'early morning',
        'shortly after midnight',
        'in the afternoon',
      ],
      correctIndex: 1,
      explanation: '"Es war kurz nach Mitternacht, als es … klopfte."',
    ),
    ReadingQuestion(
      question: 'Warum kam der alte Mann?',
      questionTranslation: 'Why did the old man come?',
      options: [
        'Sein Auto war liegengeblieben.',
        'Er hatte sich verlaufen.',
        'Er wollte etwas verkaufen.',
      ],
      optionsTranslation: [
        'His car had broken down.',
        'He had got lost.',
        'He wanted to sell something.',
      ],
      correctIndex: 0,
      explanation: '"… mein Auto ist liegengeblieben …"',
    ),
    ReadingQuestion(
      question: 'Wie reagierte Anna am Ende?',
      questionTranslation: 'How did Anna react in the end?',
      options: [
        'Sie schickte ihn weg.',
        'Sie bat ihn herein.',
        'Sie rief die Polizei.',
      ],
      optionsTranslation: [
        'She sent him away.',
        'She asked him in.',
        'She called the police.',
      ],
      correctIndex: 1,
      explanation: '"Anna … bat ihn herein."',
    ),
  ],
  intro:
      'A radio-play scene — you only hear it. Atmosphere and tone matter. '
      'Follow the time, the reason and the resolution. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Narrative past',
      text:
          'Hörspiele use the Präteritum (war, klopfte, öffnete). Follow the '
          'chain of events.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen inside the quotes',
      text: 'The man’s direct speech gives the reason — the answer to "why?".',
    ),
  ],
);

/// 14. Lesen: Ein literarischer Text (Auszug).
final QuizContent questC12LesenLiteraturContent = readingQuestQuiz(
  id: 'quest_c1_2_lesen_literatur',
  title: 'C1.2 · Lesen: Literarischer Text',
  category: 'Arts',
  passageTitle: 'Auszug: Der Brief',
  passage:
      'Sie hielt den Brief lange in der Hand, ohne ihn zu öffnen. Auf dem '
      'Umschlag stand nur ihr Vorname, in einer Schrift, die sie nicht '
      'wiedererkannte und doch zu kennen glaubte. Draußen wurde es langsam '
      'dunkel. Irgendwann, als die Straßenlaternen angingen, riss sie den '
      'Umschlag auf. Was sie las, veränderte alles – und nichts. Manche Worte, '
      'dachte sie, kommen zwanzig Jahre zu spät und gerade rechtzeitig zugleich.',
  passageTranslation:
      'She held the letter in her hand for a long time without opening it. On '
      'the envelope was only her first name, in a handwriting she did not '
      'recognise and yet believed she knew. Outside it was slowly getting dark. '
      'At some point, as the street lamps came on, she tore open the envelope. '
      'What she read changed everything – and nothing. Some words, she thought, '
      'come twenty years too late and just in time at once.',
  questions: const [
    ReadingQuestion(
      question: 'Was machte die Frau zunächst mit dem Brief?',
      questionTranslation: 'What did the woman do with the letter at first?',
      options: [
        'Sie öffnete ihn sofort.',
        'Sie hielt ihn lange, ohne ihn zu öffnen.',
        'Sie warf ihn weg.',
      ],
      optionsTranslation: [
        'She opened it immediately.',
        'She held it for a long time without opening it.',
        'She threw it away.',
      ],
      correctIndex: 1,
      explanation:
          '"Sie hielt den Brief lange in der Hand, ohne ihn zu öffnen."',
    ),
    ReadingQuestion(
      question: 'Was stand auf dem Umschlag?',
      questionTranslation: 'What was on the envelope?',
      options: ['ihr ganzer Name', 'nur ihr Vorname', 'eine Adresse'],
      optionsTranslation: [
        'her full name',
        'only her first name',
        'an address',
      ],
      correctIndex: 1,
      explanation: '"Auf dem Umschlag stand nur ihr Vorname …"',
    ),
    ReadingQuestion(
      question: 'Wie beschreibt der Text die Wirkung der Worte?',
      questionTranslation:
          'How does the text describe the effect of the words?',
      options: [
        'Sie veränderten alles und nichts zugleich.',
        'Sie ließen sie kalt.',
        'Sie machten sie wütend.',
      ],
      optionsTranslation: [
        'They changed everything and nothing at once.',
        'They left her cold.',
        'They made her angry.',
      ],
      correctIndex: 0,
      explanation: '"Was sie las, veränderte alles – und nichts."',
    ),
  ],
  intro:
      'A literary extract — mood, ambiguity and an aphoristic ending. Read '
      'for atmosphere and implication, not just facts. A demanding C1 text.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Paradox',
      text:
          '"veränderte alles – und nichts" is a deliberate paradox. Literature '
          'often means more than it says.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Implication over fact',
      text:
          'The text never says what’s in the letter. The questions test what '
          'IS stated — don’t over-infer.',
    ),
  ],
);

/// Big text (inline cloze) — Der geheimnisvolle Nachbar: subjective modal verbs,
/// where the modal encodes how sure the speaker is. Reading clues off a
/// mysterious neighbour, the learner slots in muss (certain), dürfte (likely),
/// könnte (possible), soll (hearsay) and will (claim) — the C1 art of hedging.
final QuizContent questC12BigTextNachbarContent = bigTextQuestQuiz(
  id: 'quest_c1_2_bigtext_nachbar',
  title: 'C1.2 · Großer Text: Der geheimnisvolle Nachbar',
  passageTitle: 'Der geheimnisvolle Nachbar',
  template:
      'Im Haus gegenüber geht etwas Seltsames vor. Das Licht brennt die ganze '
      'Nacht — der Bewohner {{0}} krank sein. Sein Auto fehlt; er {{1}} verreist '
      'sein. Die volle Mailbox zeigt: Er {{2}} schon seit Tagen weg sein. '
      'Angeblich {{3}} er ein berühmter Autor sein. Er selbst {{4}} viele Preise '
      'gewonnen haben. Sicher weiß das niemand, doch die Nachbarn {{5}} recht '
      'haben. Bald {{6}} sich alles klären.',
  blanks: [
    inputBlank('muss', hint: 'muss = starke Vermutung (must be)'),
    inputBlank(
      'könnte',
      accepted: const ['koennte'],
      hint: 'könnte = möglich (might)',
    ),
    inputBlank(
      'dürfte',
      accepted: const ['duerfte'],
      hint: 'dürfte = wahrscheinlich (probably)',
    ),
    inputBlank('soll', hint: 'soll = Hörensagen (is said to)'),
    inputBlank('will', hint: 'will = Behauptung (claims to)'),
    inputBlank(
      'könnten',
      accepted: const ['koennten'],
      hint: 'könnten = möglich (could)',
    ),
    inputBlank(
      'dürfte',
      accepted: const ['duerfte'],
      hint: 'dürfte = Vorhersage (probably will)',
    ),
  ],
  passageTranslation:
      'Something strange is going on in the house across the street. The light '
      'burns all night — the resident must be ill. His car is missing; he might '
      'be away. The full voicemail shows: he has probably been away for days. He '
      'is supposedly a famous author. He himself claims to have won many prizes. '
      'No one knows for sure, but the neighbours could be right. Everything will '
      'probably become clear soon.',
  intro:
      'Modal verbs don’t only say ability or duty — subjectively they say how '
      'sure you are. muss = I’m certain, dürfte = likely, könnte = possible, '
      'soll = others say, will = he claims. Pick the modal that fits the clue.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'A scale of certainty',
      text:
          'muss (100%) → dürfte (≈80%) → könnte/mag (≈50%). soll and will are '
          'not about probability but about the source: soll = they say, will = '
          'he claims.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'soll vs will',
      text:
          '"Er soll reich sein" = others say he’s rich. "Er will reich sein" = '
          'he himself claims it. Same words as English "shall/will", opposite job.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Inference about the past',
      text:
          'For a past guess, add the perfect infinitive: "Er muss krank '
          'gewesen sein", "Er will Preise gewonnen haben".',
    ),
  ],
);

/// Every C1.2 quiz, in chain order — all five exercise types, interleaved.

/// Speaking: the learner runs this conversation in their own AI
/// assistant and enters the score it gives (see `SpeakingQuizPage`).
final QuizContent questSpeakingNuancierenContent = speakingQuestQuiz(
  id: 'quest_c1_2_sprechen_dialog',
  title: 'C1.2 · Gespräch: Nuancieren',
  level: 'C1.2',
  topic:
      'Talking about culture and the media, with judgements hedged: how sure I am, where I heard it, and what I only suspect.',
  practisePoints: [
    'Subjective modals for inference: Er dürfte recht haben.',
    'Subjective modals for hearsay: Sie will das gesehen haben.',
    'Word formation: prefixes and suffixes that shift meaning',
    'Idioms used naturally, not decoratively',
  ],
  targetVocabulary: [
    'dürfte',
    'mag sein',
    'angeblich',
    'vermutlich',
    'nach allem, was man hört',
  ],
  scoringCriteria: [
    'the subjective modal and what it implies',
    'hedging that matches how sure I am',
    'idioms used in the right place',
    'cohesion across turns',
  ],
  priorityErrors: [
    'objective modal where a subjective one was meant',
    'wrong degree of certainty',
    'idiom used wrongly',
  ],
  session: SpeakingSession(durationMinutes: 6, minExchanges: 9),
  intro:
      'The app does not run this conversation. Copy the exercise, paste it into your own AI assistant, turn on its voice mode, and say "Los geht\'s" to start. It grades you at the end - bring that score back here.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Let it be a conversation',
      text:
          'Answer in full sentences and let the tutor react. It will not correct you while you talk - every correction comes at the end, with your score.',
    ),
  ],
);

/// Mid-level speaking checkpoint: a shorter, question-driven run over the
/// first half of this sub-level. The closing Gespräch covers the level as
/// a whole.
final QuizContent questSpeakingCheckC12Content = speakingQuestQuiz(
  id: 'quest_c1_2_sprechen_kurzcheck',
  title: 'C1.2 · Kurzcheck: Subjektive Modalverben',
  level: 'C1.2',
  topic:
      'How sure am I? Short claims, each hedged to the degree I actually believe it.',
  practisePoints: [
    'Inference: dürfte, müsste, könnte',
    'Hearsay: soll, will',
    'Matching the modal to how certain I am',
  ],
  targetVocabulary: ['dürfte', 'soll', 'will', 'angeblich', 'vermutlich'],
  scoringCriteria: [
    'the subjective modal',
    'the degree of certainty it signals',
    'hedging that matches the claim',
  ],
  priorityErrors: [
    'objective modal where a subjective one was meant',
    'wrong degree of certainty',
  ],
  mode: SpeakingMode.interview,
  session: SpeakingSession(durationMinutes: 3, minExchanges: 6),
  report: SpeakingReport(maxWords: 150, maxCorrections: 3),
  intro:
      'A short checkpoint on the first half of this level. Copy it into your own AI assistant, turn on voice mode, and answer - about three minutes.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'A short checkpoint, not an exam',
      text:
          'Three minutes is enough. Answer in full sentences and let the tutor move on - it saves every correction for the report at the end.',
    ),
  ],
);

final List<QuizContent> questC1_2Content = [
  questC12KulturContent, //              Kultur & Medien        (knowledge)
  questC12ModalVermutungContent, //      Modal: Vermutung       (knowledge·verb)
  questC12SprechenAbschwaechenContent, // Sprechen: abschwächen (speaking)
  questC12ModalHoerensagenContent, //    Modal: Hörensagen      (knowledge·verb)
  questC12BigTextNachbarContent, //      Großer Text: Nachbar   (reading·cloze)
  questC12WortbildungVorContent, //      Wortbildung: Vorsilben (knowledge)
  questC12HoerenReportageContent, //     Hören: Reportage       (listening)
  questC12WortbildungNachContent, //     Wortbildung: Nachsilben(knowledge)
  questSpeakingCheckC12Content, // Kurzcheck mit einer KI (speaking·AI)
  questC12RedewendungenContent, //       Redewendungen          (knowledge)
  questC12LesenKolumneContent, //        Lesen: Kolumne         (reading)
  questC12KohaesionContent, //           Textkohäsion           (knowledge)
  questC12DiktatContent, //              Diktat: Nuancen        (dictation)
  questC12SprechenIronieContent, //      Sprechen: Ironie       (speaking)
  questC12HoerenHoerspielContent, //     Hören: Hörspiel        (listening)
  questC12LesenLiteraturContent, //      Lesen: Literatur       (reading)
  questSpeakingNuancierenContent, // Gespräch mit einer KI  (speaking·AI)
];
