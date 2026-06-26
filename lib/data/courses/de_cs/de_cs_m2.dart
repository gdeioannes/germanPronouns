import '../../../models/quiz_content.dart';
import 'de_cs_builder.dart';

/// Modul 2 — Ich, du und die anderen. Deutsch → Tschechisch.
/// People, identity, the no-article revelation, and the first taste of case.

final QuizContent deCsM2Zajmena = deCsFill(
  id: 'de_cs_m2_zajmena',
  title: 'Osobní zájmena (Personalpronomen)',
  intro:
      'Die tschechischen Personalpronomen – und warum du sie meistens gar nicht '
      'sagst.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Pro-Drop: meist weglassen',
      text: 'Im Satz entfällt das Pronomen fast immer (»Jsem Klára«, nicht »Já '
          'jsem Klára«). »já« nur zur Betonung: »JÁ to vím« = ICH weiß es. [DE]/[FR] '
          'brauchen das Pronomen immer.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '»vy« = Sie UND ihr',
      text: 'Genau wie das [FR] *vous*: Höflichkeitsform (Sie) UND Plural (ihr). '
          'Der Kontext entscheidet.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '3. Person Plural hat drei Formen',
      text: 'oni (belebte Männer/gemischt), ony (Frauen + unbelebte Dinge), ona '
          '(Neutra). Nur in der Schrift unterschieden – gesprochen oft alles »oni«.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'on / ona / ono',
      text: 'Die Endung verrät das Genus: -a = feminin (ona = sie), -o = neutrum '
          '(ono = es), Konsonant = maskulin (on = er) – wie bei den Nomen.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich', answer: 'já'),
    CourseItem(prompt: 'du', answer: 'ty'),
    CourseItem(prompt: 'er', answer: 'on'),
    CourseItem(prompt: 'sie (Einzahl)', answer: 'ona'),
    CourseItem(prompt: 'es', answer: 'ono'),
    CourseItem(prompt: 'wir', answer: 'my'),
    CourseItem(prompt: 'ihr', answer: 'vy'),
    CourseItem(prompt: 'Sie (höflich)', answer: 'vy'),
    CourseItem(prompt: 'sie (Plural, Männer)', answer: 'oni'),
    CourseItem(prompt: 'sie (Plural, Frauen/Dinge)', answer: 'ony'),
    CourseItem(prompt: 'wer?', answer: 'kdo'),
    CourseItem(prompt: 'was?', answer: 'co'),
  ],
);

final QuizContent deCsM2Predstaveni = deCsSpeak(
  id: 'de_cs_m2_predstaveni',
  title: 'Sprechen: Jmenuji se…',
  intro: 'Stell dich auf Tschechisch vor – hören und nachsprechen. Jede Zeile mit '
      'französischem Anker.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'jmenovat se = sich nennen',
      text: 'Reflexiv mit »se«, [FR] wie *je m’appelle*. Formell »jmenuji se«, '
          'umgangssprachlich »jmenuju se«.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Alter: »je mi … let«',
      text: 'Wörtlich »mir sind … Jahre«. [FR] *j’ai 20 ans* (haben), [DE] ich bin 20 '
          '(sein), Tschechisch: »mir ist«. »let« = Genitiv Plural von »rok« (Jahr).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'z + woher, v + wo',
      text: '»z Německa« (aus Deutschland, + Genitiv), »v Praze« (in Prag, + '
          'Lokativ). Zwei Präpositionen, zwei Fälle – ein erster Blick aufs System.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich heiße Klára ([FR] Je m’appelle Klára — reflexives »se«; jmenovat SE)', answer: 'Jmenuji se Klára.'),
    CourseItem(prompt: 'Ich bin aus Deutschland ([FR] Je suis d’Allemagne — »z« + Genitiv: Německo → Německa)', answer: 'Jsem z Německa.'),
    CourseItem(prompt: 'Ich bin Studentin ([FR] Je suis étudiante — kein Artikel, nicht »eine«)', answer: 'Jsem studentka.'),
    CourseItem(prompt: 'Ich bin zwanzig ([FR] J’ai vingt ans — wörtl. »mir sind 20 Jahre«)', answer: 'Je mi dvacet let.'),
    CourseItem(prompt: 'Ich wohne in Prag ([FR] J’habite à Prague — »v« + Lokativ: Praha → Praze)', answer: 'Bydlím v Praze.'),
    CourseItem(prompt: 'Ich spreche Deutsch und Französisch ([FR] Je parle… — Adverb, klein)', answer: 'Mluvím německy a francouzsky.'),
    CourseItem(prompt: 'Ich lerne Tschechisch ([FR] J’apprends le tchèque — »učit se« reflexiv + Adverb)', answer: 'Učím se česky.'),
    CourseItem(prompt: 'Freut mich ([FR] Enchanté(e))', answer: 'Těší mě.'),
  ],
);

final QuizContent deCsM2Byt = deCsFill(
  id: 'de_cs_m2_byt',
  title: 'Sloveso «být» + zápor',
  intro:
      'Das Verb »být« (sein) im Präsens und seine Verneinung – das Rückgrat jedes '
      'Satzes.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Verneinung mit »ne-«',
      text: 'Einfach »ne-« vorne ankleben: jsem → nejsem, jsme → nejsme. [FR] braucht '
          'zwei Teile (*ne…pas*), Tschechisch nur eine Vorsilbe.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '»není« ist die Ausnahme',
      text: '»er/sie/es ist nicht« = není (nicht »neje«!). Die einzige '
          'unregelmäßige Form im ganzen Paradigma – gut merken.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '»To je…« = Das ist…',
      text: '»To je Tomáš«, »To je káva«. »to« (das) ist geschlechtsneutral – egal '
          'ob Mann, Frau oder Ding. [FR] vgl. *c’est*.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Das ganze Paradigma',
      text: 'jsem · jsi · je / jsme · jste · jsou. Verneint: nejsem · nejsi · '
          'není / nejsme · nejste · nejsou.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich bin', answer: 'jsem'),
    CourseItem(prompt: 'du bist', answer: 'jsi', accepted: ['seš']),
    CourseItem(prompt: 'er/sie/es ist', answer: 'je'),
    CourseItem(prompt: 'wir sind', answer: 'jsme'),
    CourseItem(prompt: 'ihr seid / Sie sind', answer: 'jste'),
    CourseItem(prompt: 'sie sind', answer: 'jsou'),
    CourseItem(prompt: 'ich bin nicht', answer: 'nejsem'),
    CourseItem(prompt: 'er/sie ist nicht', answer: 'není'),
    CourseItem(prompt: 'wir sind nicht', answer: 'nejsme'),
    CourseItem(prompt: 'Ich bin Studentin.', answer: 'Jsem studentka.'),
    CourseItem(prompt: 'Bist du aus Prag?', answer: 'Jsi z Prahy?'),
    CourseItem(prompt: 'Das ist Tomáš.', answer: 'To je Tomáš.'),
  ],
);

final QuizContent deCsM2LideVztahy = deCsSpeak(
  id: 'de_cs_m2_lide_vztahy',
  title: 'Sprechen: Menschen & Wörter mit Geschichte (Triade)',
  intro:
      'Über Menschen sprechen – und nebenbei sehen, wie viele tschechische Wörter '
      'aus dem Französischen oder Lateinischen kommen.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Lehnwörter, die du kennst',
      text: '»kamarád« ← frz. *camarade*; »restaurace«, »prezident«, »student« – '
          'internationale Wörter, die dir vertraut sind.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '»-ová« bei Frauennamen',
      text: 'Weibliche Nachnamen bekommen »-ová« – aus jeder Ausländerin wird '
          '»Merkelová«, »Macronová«. Ein Possessiv-Suffix: »die zu … Gehörige«.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'mít rád = gern haben',
      text: 'Zuneigung mit »mít rád/ráda« (wörtl. »froh haben«): »Mám rád kávu«. '
          'Mann sagt rád, Frau ráda. [FR] vgl. *aimer bien*.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Das ist mein Freund Tomáš ([FR] camarade — »kamarád« ist dasselbe Lehnwort)', answer: 'To je můj kamarád Tomáš.'),
    CourseItem(prompt: 'Er ist Tscheche ([FR] Tchèque — Nation groß »Čech«, Sprache klein »česky«)', answer: 'Je to Čech.'),
    CourseItem(prompt: 'Er spricht Französisch ([FR] Il parle français — Sprache klein, kein Artikel)', answer: 'Mluví francouzsky.'),
    CourseItem(prompt: 'Das ist Frau Nováková ([FR] Madame Nováková — »-ová« weibl. Nachnamen-Endung, sogar »Macronová«!)', answer: 'To je paní Nováková.'),
    CourseItem(prompt: 'Er mag Kaffee ([FR] Il aime le café — »mít rád« = gern haben; káva → kávu im Akkusativ)', answer: 'Má rád kávu.'),
    CourseItem(prompt: 'Sie ist sehr nett ([FR] Elle est très gentille — »milá« feminin auf -á)', answer: 'Je velmi milá.'),
    CourseItem(prompt: 'Wer ist das? ([FR] Qui est-ce ? — Frage ohne Hilfsverb; Wortstellung frei dank Kasus)', answer: 'Kdo je to?'),
  ],
);

final QuizContent deCsM2CteniKlara = deCsRead(
  id: 'de_cs_m2_cteni_klara',
  title: 'Lesen: Klára v Praze',
  passageTitle: 'Klára v Praze',
  passage:
      'Tohle je Klára. Je z Německa, ale teď bydlí v Praze. Je studentka a má '
      'ráda jazyky. Její kamarád Tomáš je Čech. Tomáš mluví německy a Klára se '
      'učí česky. Praha je krásné město. „Praha je můj domov,“ říká Klára.',
  passageTranslation:
      'Das ist Klára. Sie ist aus Deutschland, aber jetzt wohnt sie in Prag. Sie '
      'ist Studentin und mag Sprachen. Ihr Freund Tomáš ist Tscheche. Tomáš '
      'spricht Deutsch und Klára lernt Tschechisch. Prag ist eine schöne Stadt. '
      '„Prag ist mein Zuhause“, sagt Klára.',
  intro: 'Lies über Klára und ihren Freund Tomáš – mit Possessiva und dem ersten '
      'reflexiven »se«.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Keine Artikel – Kontext entscheidet',
      text: '»je studentka« (eine Studentin), »Praha je město« (eine/die Stadt). '
          'Ob bestimmt oder unbestimmt, sagt der Zusammenhang, nicht der/ein.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Possessiv: můj / její',
      text: '»můj domov« (mein Zuhause, m), »její kamarád« (ihr Freund). '
          'Possessiva richten sich nach dem Genus des besessenen Dings, nicht des '
          'Besitzers.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Das »se« wandert',
      text: '»Klára se učí« – das »se« steht an zweiter Satzstelle, nicht am Verb '
          'kleben. [FR] vgl. die Klitik-Logik bei *se / le / lui*.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Odkud je Klára?',
      options: ['Z Německa', 'Z Čech', 'Z Francie'],
      correctIndex: 0,
      questionTranslation: 'Woher kommt Klára?',
    ),
    ReadingQuestion(
      question: 'Kdo je Tomáš?',
      options: ['Učitel', 'Klářin kamarád', 'Student z Berlína'],
      correctIndex: 1,
      questionTranslation: 'Wer ist Tomáš?',
    ),
    ReadingQuestion(
      question: 'Co dělá Klára v Praze?',
      options: ['Učí se česky', 'Učí němčinu', 'Pracuje'],
      correctIndex: 0,
      questionTranslation: 'Was macht Klára in Prag?',
    ),
    ReadingQuestion(
      question: 'Jak Klára mluví o Praze?',
      options: ['Je to její domov', 'Je to drahé město', 'Je to malé město'],
      correctIndex: 0,
      questionTranslation: 'Wie spricht Klára über Prag?',
    ),
  ],
);

final QuizContent deCsM2RodZivotnost = deCsFill(
  id: 'de_cs_m2_rod_zivotnost',
  title: 'Bez členů: rod a životnost',
  intro:
      'Tschechisch hat keine Artikel – aber sehr wohl drei Genera und eine '
      'Besonderheit, die es weder im Deutschen noch im Französischen gibt: die '
      'Belebtheit.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Drei Genera – an der Endung erkennbar',
      text: 'Meist Konsonant = maskulin (muž, dům), -a = feminin (žena, káva), '
          '-o/-e = neutrum (město, pivo). [FR] hat nur zwei Genera, Tschechisch drei.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Das Genus weicht vom Deutschen ab',
      text: 'der Kaffee → káva (f!), die Sprache → jazyk (m!), das Haus → dům (m!). '
          'Vertrau der tschechischen Endung, nicht dem deutschen Artikel.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Belebtheit (životnost)',
      text: 'Maskulina sind belebt (muž, pes, student) oder unbelebt (dům, stůl). '
          'Das verändert später die Akkusativ-Endung – ein viertes »Untergenus«, '
          'das [DE]/[FR] nicht kennen.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Die Endung ist dein neuer »Artikel«',
      text: 'Ohne der/die/das trägt die Wortendung die Information. Lern jedes '
          'Nomen mit Gefühl für seine Endung, nicht mit einem Artikel davor.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'der Mann (belebt)', answer: 'muž'),
    CourseItem(prompt: 'die Frau', answer: 'žena'),
    CourseItem(prompt: 'das Kind', answer: 'dítě'),
    CourseItem(prompt: 'der Hund (belebt)', answer: 'pes'),
    CourseItem(prompt: 'die Katze', answer: 'kočka'),
    CourseItem(prompt: 'die Stadt (im Tsch. neutrum!)', answer: 'město'),
    CourseItem(prompt: 'das Haus (im Tsch. maskulin!)', answer: 'dům'),
    CourseItem(prompt: 'der Tisch (unbelebt)', answer: 'stůl'),
    CourseItem(prompt: 'der Kaffee (im Tsch. feminin!)', answer: 'káva'),
    CourseItem(prompt: 'die Sprache (im Tsch. maskulin!)', answer: 'jazyk'),
    CourseItem(prompt: 'das Bier', answer: 'pivo'),
    CourseItem(prompt: 'der Tag', answer: 'den'),
  ],
);

final QuizContent deCsM2Osloveni = deCsSpeak(
  id: 'de_cs_m2_osloveni',
  title: 'Sprechen: Oslovení (5. pád / Vokativ)',
  intro:
      'Wen du direkt ansprichst, steht im Vokativ – einem eigenen Fall mit eigener '
      'Endung. Den hatte das Latein, das Französische hat ihn verloren.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Der 5. Fall: die Anrede',
      text: 'Wen du rufst oder ansprichst, bekommt eine Vokativ-Endung. [DE] hat '
          'keinen morphologischen Vokativ, [FR] hat ihn verloren – aber Latein hatte '
          'ihn (»Brute!«).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Typische Endungen',
      text: '-e: Petr → Petře, pan → pane. -i: Tomáš → Tomáši, kamarádi. -o: '
          'Klára → Kláro, žena → ženo.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Nicht der Nominativ!',
      text: '»Ahoj, Tomáš« klingt für Tschechen abrupt – richtig ist »Ahoj, '
          'Tomáši«. Bei direkter Anrede immer den Vokativ nehmen.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '»-ová« bleibt gleich',
      text: 'Weibliche Nachnamen auf »-ová« ändern sich im Vokativ nicht: »paní '
          'Nováková«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hallo, Tomáš! ([FR] Salut, Tomáš ! — Vokativ: Tomáš → Tomáši)', answer: 'Ahoj, Tomáši!'),
    CourseItem(prompt: 'Petr, komm her! ([FR] Pierre, viens ! — Petr → Petře)', answer: 'Petře, pojď sem!'),
    CourseItem(prompt: 'Guten Tag, Herr Novák! ([FR] Bonjour Monsieur — pan Novák → pane Nováku)', answer: 'Dobrý den, pane Nováku!'),
    CourseItem(prompt: "Klára, geht's dir gut? ([FR] Klára… — Klára → Kláro)", answer: 'Kláro, máš se dobře?'),
    CourseItem(prompt: 'Danke, Frau Nováková ([FR] Madame — weibl. »-ová« bleibt im Vokativ gleich)', answer: 'Děkuji, paní Nováková.'),
    CourseItem(prompt: 'Mama, wo bist du? ([FR] Maman — máma → mami)', answer: 'Mami, kde jsi?'),
    CourseItem(prompt: 'Los, Freunde! ([FR] les amis ! — kamarádi → Vokativ Plural)', answer: 'Pojďme, kamarádi!'),
  ],
);

final QuizContent deCsM2Cisla = deCsFill(
  id: 'de_cs_m2_cisla',
  title: 'Čísla 1–10 a počítání',
  intro:
      'Die Zahlen 1–10 – und der erste echte Schock fürs deutsche und französische '
      'Sprachgefühl: Zahlen bestimmen den Fall des gezählten Worts.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Zahlen regieren den Kasus',
      text: 'Ab 5 steht das Gezählte im Genitiv Plural: »pět korun« (5 Kronen), '
          '»pět piv«, »deset studentů«. [DE]/[FR] kennen das nicht – dort bleibt der '
          'Plural unverändert.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Paukal 2–4',
      text: '2, 3, 4 nehmen den Nominativ Plural: »dva studenti«, »tři koruny«, '
          '»čtyři piva«. Erst ab 5 kippt es in den Genitiv.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '1 und 2 haben Genus',
      text: 'jeden (m) / jedna (f) / jedno (n); dva (m) / dvě (f, n). Eins und '
          'Zwei richten sich nach dem Nomen.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'sedm / osm – silbenbildendes m',
      text: '»sedm« (7) und »osm« (8) haben ein silbenbildendes »m«: sprich fast '
          '»se-dum / o-sum«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'eins', answer: 'jedna', accepted: ['jeden', 'jedno']),
    CourseItem(prompt: 'zwei', answer: 'dva', accepted: ['dvě']),
    CourseItem(prompt: 'drei', answer: 'tři'),
    CourseItem(prompt: 'vier', answer: 'čtyři'),
    CourseItem(prompt: 'fünf', answer: 'pět'),
    CourseItem(prompt: 'sechs', answer: 'šest'),
    CourseItem(prompt: 'sieben', answer: 'sedm'),
    CourseItem(prompt: 'acht', answer: 'osm'),
    CourseItem(prompt: 'neun', answer: 'devět'),
    CourseItem(prompt: 'zehn', answer: 'deset'),
    CourseItem(prompt: 'fünf Kronen', answer: 'pět korun'),
    CourseItem(prompt: 'zwei Studenten', answer: 'dva studenti'),
  ],
);

/// Modul 2 in chain order (interleaved knowledge / audio / reading).
final List<QuizContent> deCsM2 = [
  deCsM2Zajmena,
  deCsM2Predstaveni,
  deCsM2Byt,
  deCsM2LideVztahy,
  deCsM2CteniKlara,
  deCsM2RodZivotnost,
  deCsM2Osloveni,
  deCsM2Cisla,
];
