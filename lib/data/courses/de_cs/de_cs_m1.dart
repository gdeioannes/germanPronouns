import '../../../models/quiz_content.dart';
import 'de_cs_builder.dart';

/// Modul 1 — Erste Klänge. Deutsch → Tschechisch.
/// The Czech sound system as the seduction, plus survival courtesy.

final QuizContent deCsM1Pozdravy = deCsFill(
  id: 'de_cs_m1_pozdravy',
  title: 'Pozdravy a zdvořilost',
  intro:
      'Die wichtigsten tschechischen Begrüßungen und Höflichkeitsformeln. Sprich '
      'sie laut mit — und merke dir: Tschechisch braucht keinen Artikel.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Kein Artikel, kein »es«',
      text: 'Tschechisch hat KEINE Artikel: »Dobrý den« = wörtlich »guter Tag«, '
          'kein der/die/das, kein »einen«. [FR] anders als »le/un jour«.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Dobrý + Tageszeit (erstes Kasus-Aha)',
      text: 'Die Endung folgt dem Genus des Substantivs: den (m) → Dobr**ý** den, '
          'ráno (n) → Dobr**é** ráno, noc (f, Akk.) → Dobr**ou** noc. Das Adjektiv '
          'richtet sich nach dem Nomen – wie im Deutschen, nur ohne Artikel.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Ahoj = hallo UND tschüss',
      text: '»Ahoj« und »Čau« (aus dem ital. *ciao*!) grüßen beim Kommen und '
          'Gehen. »Prosím« heißt »bitte«, »hier bitte« und »gern geschehen« – '
          '[FR] wie *je vous en prie*.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Förmlich oder vertraut?',
      text: 'Zu Fremden »Dobrý den«, unter Freunden »Ahoj«. Die du/Sie-Wahl '
          'kennst du doppelt: [DE] du/Sie, [FR] tu/vous. Tschechisch: tykání/vykání.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hallo (informell)', answer: 'Ahoj', accepted: ['Čau', 'Nazdar']),
    CourseItem(prompt: 'Guten Tag', answer: 'Dobrý den'),
    CourseItem(prompt: 'Guten Morgen', answer: 'Dobré ráno'),
    CourseItem(prompt: 'Guten Abend', answer: 'Dobrý večer'),
    CourseItem(prompt: 'Gute Nacht', answer: 'Dobrou noc'),
    CourseItem(prompt: 'Auf Wiedersehen', answer: 'Na shledanou'),
    CourseItem(prompt: 'Tschüss (informell)', answer: 'Měj se', accepted: ['Ahoj', 'Čau']),
    CourseItem(prompt: 'Bitte / Gern geschehen', answer: 'Prosím'),
    CourseItem(prompt: 'Danke', answer: 'Děkuji', accepted: ['Díky', 'Děkuju']),
    CourseItem(prompt: 'Vielen Dank', answer: 'Mockrát děkuji', accepted: ['Děkuji mnohokrát']),
    CourseItem(prompt: 'Entschuldigung', answer: 'Promiňte', accepted: ['Promiň']),
    CourseItem(prompt: 'Ja', answer: 'Ano', accepted: ['Jo']),
    CourseItem(prompt: 'Nein', answer: 'Ne'),
  ],
);

final QuizContent deCsM1Hlasky = deCsSpeak(
  id: 'de_cs_m1_hlasky',
  title: 'Hlásky a háčky (das Lautsystem)',
  intro:
      'Höre die typischen tschechischen Laute und sprich sie nach. Drei davon '
      'kannst du dank Französisch schon perfekt.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Ein Zeichen = ein Laut',
      text: 'Tschechisch schreibt fast lautgetreu. Der Haken (háček) macht aus '
          's→š, c→č, z→ž, r→ř, n→ň, t→ť, d→ď, e→ě.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '[FR] Dein Französisch-Anker',
      text: '»ž« = das frz. *j* in *jour* [ʒ]. »š« = frz. *ch* in *chat*. »ň« = '
          'frz. *gn* in *Espagne*. Drei Laute beherrschst du schon!',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '»h« ist stimmhaft, nicht stumm',
      text: 'Das tschechische »h« wird wirklich gehaucht (»Praha«, »ahoj«), nie '
          'stumm wie das frz. *h* in *hôtel*.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '»ě« ist kein normales e',
      text: '»ě« erweicht den Konsonanten davor: dě/tě/ně klingen ďe/ťe/ňe; »mě« '
          'klingt »mňe«. Es ist ein Erweichungszeichen, kein eigener Vokal.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Tee — »č« = dt. »tsch« (Tschechien); [FR] wie *tch* in *tchèque*', answer: 'čaj'),
    CourseItem(prompt: 'sechs — »š« = dt. »sch«; [FR] wie *ch* in *chat*', answer: 'šest'),
    CourseItem(prompt: 'Frau — »ž« = das frz. *j* in *jour* [ʒ]! Dein bester Anker', answer: 'žena'),
    CourseItem(prompt: 'Fluss — »ř«, der Dvořák-Laut: gerolltes »r« + »ž« gleichzeitig', answer: 'řeka'),
    CourseItem(prompt: 'die deutsche Sprache — weich: »ňem-či-na«; [FR] *ň* = gn in *Allemagne*', answer: 'němčina'),
    CourseItem(prompt: 'guten Tag — langes »ý« [iː]; Akzent auf der 1. Silbe: DOB-rý', answer: 'dobrý den'),
    CourseItem(prompt: 'hallo/tschüss — »h« gehaucht und stimmhaft, nicht stumm', answer: 'ahoj'),
    CourseItem(prompt: 'danke — »ě« macht »d« weich → ďe-ku-ji', answer: 'děkuji'),
  ],
);

final QuizContent deCsM1DelkaPrizvuk = deCsFill(
  id: 'de_cs_m1_delka_prizvuk',
  title: 'Délka a přízvuk (Länge & Betonung)',
  intro:
      'Schreib die Wörter mit den richtigen Längenzeichen. Vokallänge verändert '
      'die Bedeutung – und liegt nie dort, wo eine französische Zunge sie erwartet.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Länge trägt Bedeutung',
      text: 'á é í ó ú/ů ý sind LANGE Vokale (doppelt so lang). byt (Wohnung) ≠ '
          'být (sein); dráha (Bahn) ≠ drahá (teuer). [DE] wie Staat/Stadt – [FR] '
          'kennt diesen Längenunterschied nicht.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Betonung ≠ Länge',
      text: 'Der Akzent liegt IMMER auf der 1. Silbe (DOB-ře, ČE-sky, U-či-tel) – '
          'egal wo das Längenzeichen sitzt. [FR] Gegenteil: Französisch betont die '
          'letzte Silbe.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '»ú« oder »ů«?',
      text: 'Beide klingen gleich [uː]. »ú« steht am Wortanfang (úterý = Dienstag), '
          '»ů« in der Mitte und am Ende (dům = Haus, stůl = Tisch).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Háček-Buchstaben sind eigene Buchstaben',
      text: 'č, š, ž, ř, ě, ň zählen im Alphabet eigenständig – im Wörterbuch '
          'steht »č« direkt hinter »c«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'die Wohnung (kurzes y)', answer: 'byt'),
    CourseItem(prompt: 'sein / er ist (langes ý)', answer: 'být'),
    CourseItem(prompt: 'die Bahn, die Strecke', answer: 'dráha'),
    CourseItem(prompt: 'teuer (weiblich)', answer: 'drahá'),
    CourseItem(prompt: 'gut, richtig (Adverb)', answer: 'dobře'),
    CourseItem(prompt: 'tschechisch (Adverb)', answer: 'česky'),
    CourseItem(prompt: 'Prag', answer: 'Praha'),
    CourseItem(prompt: 'der Kaffee', answer: 'káva'),
    CourseItem(prompt: 'das Haus', answer: 'dům'),
    CourseItem(prompt: 'der Tisch', answer: 'stůl'),
    CourseItem(prompt: 'der Lehrer', answer: 'učitel'),
    CourseItem(prompt: 'Dienstag', answer: 'úterý'),
  ],
);

final QuizContent deCsM1RHacek = deCsSpeak(
  id: 'de_cs_m1_r_hacek',
  title: 'Der ř-Laut & Zungenbrecher',
  intro:
      'Der schwierigste Laut Europas – und ein Satz ganz ohne Vokal. Trau dich, '
      'niemand erwartet ihn beim ersten Mal perfekt.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Wie man »ř« macht',
      text: 'Gerollter »r«-Verschluss UND gleichzeitige »ž«-Reibung. Selbst '
          'tschechische Kinder lernen ihn zuletzt. Es ist EIN Laut, nicht »r« + '
          '»ž« nacheinander.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Dvořák trägt ihn im Namen',
      text: 'Der Komponist Dvořák, »dobře« (gut), »tři« (drei), »řeka« (Fluss) – '
          'das ř begegnet dir täglich.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Silbenbildendes r / l',
      text: 'In prst (Finger), vlk (Wolf), krk (Hals) ist »r«/»l« der Silbenkern – '
          'kein Vokal nötig. [DE]/[FR] undenkbar. Probier: Strč prst skrz krk.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Stimmhaft oder stimmlos',
      text: '»ř« klingt stimmhaft (řeka) – aber nach/vor stimmlosem Laut stimmlos '
          '(tři, při, keř). Hör auf den Nachbarlaut.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Fluss — Zungenspitze wie beim gerollten »r«, dann sofort »ž«', answer: 'řeka'),
    CourseItem(prompt: 'drei — »tř« in einem Rutsch; das ř ist der härteste Laut Europas', answer: 'tři'),
    CourseItem(prompt: 'gut, richtig — sehr häufig; DOB-ře', answer: 'dobře'),
    CourseItem(prompt: 'der Komponist — sein Name IST eine ř-Lektion', answer: 'Dvořák'),
    CourseItem(prompt: 'vier — »čty-ři«: erst »č«, dann »ř«', answer: 'čtyři'),
    CourseItem(prompt: '(das) Meer — [FR] wie *mer*, aber mit ř', answer: 'moře'),
    CourseItem(prompt: '»steck den Finger durch den Hals« — ein Satz GANZ OHNE Vokal', answer: 'Strč prst skrz krk'),
    CourseItem(prompt: 'der Finger — das »r« ist hier der Silbenkern', answer: 'prst'),
  ],
);

final QuizContent deCsM1JakSeMas = deCsFill(
  id: 'de_cs_m1_jak_se_mas',
  title: 'Jak se máš? (Smalltalk)',
  intro:
      'Der wichtigste Mini-Dialog: fragen, wie es geht, und antworten. Achte auf '
      'das »se« – das Verb ist reflexiv.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'tykání vs vykání',
      text: '»máš« (du) vs »máte« (Sie). [FR] wie tu/vous, [DE] wie du/Sie – du kennst '
          'die Unterscheidung doppelt. Achtung: »vy« ist Sie UND ihr.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '»se« gehört zum Verb',
      text: '»mít se« (sich befinden) ist reflexiv: »Jak se máš?« = wörtlich »Wie '
          'hast du DICH?«. [FR] vgl. *Comment vas-tu* – das »se« darfst du nie '
          'weglassen.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Pro-Drop: kein »já«',
      text: '»Mám se dobře« ohne »já«. Das Subjektpronomen entfällt – die Endung '
          '»-m« sagt schon »ich«. [DE]/[FR] verlangen beide ein Pronomen, Tschechisch '
          'nicht.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Sprachen als Adverb',
      text: '»mluvím česky / německy / francouzsky« (ich spreche tschechisch / '
          'deutsch / französisch) – klein, ohne Artikel. [FR] anders als *le français*.',
    ),
  ],
  items: const [
    CourseItem(prompt: "Wie geht's dir? (du)", answer: 'Jak se máš?'),
    CourseItem(prompt: 'Wie geht es Ihnen? (Sie)', answer: 'Jak se máte?'),
    CourseItem(prompt: "Mir geht's gut.", answer: 'Mám se dobře.'),
    CourseItem(prompt: 'Danke, gut. Und dir?', answer: 'Děkuji, dobře. A ty?'),
    CourseItem(prompt: 'Und Ihnen?', answer: 'A vy?'),
    CourseItem(prompt: 'Es geht. / So lala', answer: 'Ujde to', accepted: ['Jde to', 'Nic moc']),
    CourseItem(prompt: 'Freut mich.', answer: 'Těší mě'),
    CourseItem(prompt: 'Wie heißt du?', answer: 'Jak se jmenuješ?'),
    CourseItem(prompt: 'Ich heiße Klára.', answer: 'Jmenuji se Klára.', accepted: ['Jmenuju se Klára.']),
    CourseItem(prompt: 'Sprichst du Deutsch?', answer: 'Mluvíš německy?'),
    CourseItem(prompt: 'Ich spreche ein bisschen Tschechisch.', answer: 'Mluvím trochu česky.'),
  ],
);

final QuizContent deCsM1CteniAhoj = deCsRead(
  id: 'de_cs_m1_cteni_ahoj',
  title: 'Lesen: Ahoj, jsem Klára',
  passageTitle: 'Ahoj, jsem Klára',
  passage:
      'Ahoj! Jmenuji se Klára. Jsem z Berlína, z Německa. Jsem studentka. '
      'Studuji jazyky: francouzštinu a teď taky češtinu. Mluvím německy, '
      'francouzsky a trochu česky. Bydlím v Praze. Praha je krásná! A ty? '
      'Jak se jmenuješ?',
  passageTranslation:
      'Hallo! Ich heiße Klára. Ich bin aus Berlin, aus Deutschland. Ich bin '
      'Studentin. Ich studiere Sprachen: Französisch und jetzt auch Tschechisch. '
      'Ich spreche Deutsch, Französisch und ein bisschen Tschechisch. Ich wohne '
      'in Prag. Prag ist schön! Und du? Wie heißt du?',
  intro: 'Lies einen kurzen tschechischen Steckbrief – mit lauter Wörtern, die '
      'du schon kennst.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Lesestrategie',
      text: 'Suche bekannte Wörter (Berlín, studentka, jazyky, Praha). Du musst '
          'nicht jedes Wort verstehen, um den Sinn zu treffen.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Pro-Drop in Aktion',
      text: '»Jmenuji se… Jsem… Studuji… Bydlím…« – kein einziges »já«. Die '
          'Verbendung trägt die Person.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Sprachnamen auf -ština',
      text: '»francouzština« (das Französische), »čeština« (das Tschechische) – '
          'die Endung »-ština« macht den Sprachnamen (feminin). Als Adverb: '
          '»francouzsky«, »česky«.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'v + Ort = Lokativ (Vorgeschmack)',
      text: '»v Praze« (in Prag), nicht »v Praha«: nach »v« ändert sich die '
          'Endung. Das ist schon der 6. Fall – mehr dazu in Modul 2 und 3.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Odkud je Klára?',
      options: ['Z Berlína', 'Z Prahy', 'Z Vídně'],
      correctIndex: 0,
      questionTranslation: 'Woher kommt Klára?',
    ),
    ReadingQuestion(
      question: 'Co studuje?',
      options: ['Medicínu', 'Jazyky', 'Hudbu'],
      correctIndex: 1,
      questionTranslation: 'Was studiert sie?',
    ),
    ReadingQuestion(
      question: 'Kde bydlí?',
      options: ['V Berlíně', 'V Praze', 'V Paříži'],
      correctIndex: 1,
      questionTranslation: 'Wo wohnt sie?',
    ),
    ReadingQuestion(
      question: 'Kolik jazyků zná Klára?',
      options: ['Jeden', 'Dva', 'Tři'],
      correctIndex: 2,
      questionTranslation: 'Wie viele Sprachen kann Klára?',
    ),
  ],
);

final QuizContent deCsM1ZvukySlov = deCsSpeak(
  id: 'de_cs_m1_zvuky_slov',
  title: 'Sprechen: Klang & Bedeutung (Triade)',
  intro:
      'Sag die wichtigsten Wörter laut – und nimm bei jedem einen Klang- oder '
      'Sprachtipp mit. Was du auf Französisch schon fühlst, hilft dir hier.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Die Triade-Methode',
      text: 'Jede Zeile zeigt Tschechisch (hören & sprechen), Deutsch (Bedeutung) '
          'und Französisch (Anker). Sprich das Tschechische, denk ans Französische.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Erstsilben-Akzent bleibt',
      text: 'Auch im Satz: DOB-rý den, NA shle-da-nou. [FR] widersteh dem Drang, '
          'die letzte Silbe zu betonen.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Erweichung hören',
      text: '»Děkuji«, »Promiňte«, »Těší mě« – überall macht das ě/ň/ť den '
          'Konsonanten weich. Genau das gibt dem Tschechischen seinen Klang.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Guten Tag ([FR] Bonjour — wörtl. »guter Tag«; Akzent auf DOB-rý, nie auf der Endung; kein Artikel)',
      answer: 'Dobrý den.',
    ),
    CourseItem(
      prompt: 'Danke ([FR] Merci — »ě« erweicht das »d«: ďe-ku-ji, mouilliert wie gn)',
      answer: 'Děkuji.',
    ),
    CourseItem(
      prompt: 'Bitte / gern geschehen ([FR] S’il vous plaît / je vous en prie — ein Wort, zwei Funktionen; langes í)',
      answer: 'Prosím.',
    ),
    CourseItem(
      prompt: 'Ja. Nein. ([FR] Oui / Non — Achtung: kurzes »no« heißt umgangssprachlich »ja«!)',
      answer: 'Ano. Ne.',
    ),
    CourseItem(
      prompt: 'Auf Wiedersehen ([FR] Au revoir — beide wörtl. »auf das Wiedersehen«; shl ohne Vokal)',
      answer: 'Na shledanou.',
    ),
    CourseItem(
      prompt: 'Entschuldigung ([FR] Pardon / excusez-moi — »ň« = das frz. gn in Espagne; Sie-Form auf -te)',
      answer: 'Promiňte.',
    ),
    CourseItem(
      prompt: 'Freut mich ([FR] Enchanté(e) — »ě« erweicht »t« → ťe-ší; mě klingt mňe)',
      answer: 'Těší mě.',
    ),
  ],
);

/// Modul 1 in chain order (interleaved knowledge / audio / reading).
final List<QuizContent> deCsM1 = [
  deCsM1Pozdravy,
  deCsM1Hlasky,
  deCsM1DelkaPrizvuk,
  deCsM1RHacek,
  deCsM1JakSeMas,
  deCsM1CteniAhoj,
  deCsM1ZvukySlov,
];
