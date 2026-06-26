import '../../../models/quiz_content.dart';
import 'de_cs_builder.dart';

/// Modul 3 — Tun & Sein: erster Blick auf den Aspekt. Deutsch → Tschechisch.
/// The Czech verb on the French passé composé / imparfait bridge — plus the
/// instrumental, reflexives, and the closing hook.

final QuizContent deCsM3Sloveso = deCsFill(
  id: 'de_cs_m3_sloveso',
  title: 'Pravidelné sloveso «dělat»',
  intro:
      'Das erste regelmäßige Verb: »dělat« (machen/tun) im Präsens. Eine ganze '
      'Verbklasse auf einmal.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Die -at-Klasse',
      text: 'Endungen: -ám / -áš / -á / -áme / -áte / -ají. Stamm »dělá-« + Endung. '
          'Sehr regelmäßig – viele Verben gehen so (dělat, snídat, čekat).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Pro-Drop, schon wieder',
      text: '»Dělám« heißt komplett »ich mache«. Das Pronomen »já« nur zur '
          'Betonung. Die Endung trägt die Person.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Doppelte Verneinung ist Pflicht',
      text: '»ne-« vor das Verb: nedělám (ich mache nicht). Und: »Nic nedělám« = '
          'wörtl. »nichts mache-ich-nicht«. [FR] *ne…rien* hat auch zwei Teile, [DE] '
          'nur eines.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'dělat → udělat',
      text: 'Mit der Vorsilbe »u-« wird »dělat« vollendet (»udělat« = fertig '
          'machen). Genau das ist der Aspekt – gleich mehr dazu.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich mache', answer: 'dělám'),
    CourseItem(prompt: 'du machst', answer: 'děláš'),
    CourseItem(prompt: 'er/sie/es macht', answer: 'dělá'),
    CourseItem(prompt: 'wir machen', answer: 'děláme'),
    CourseItem(prompt: 'ihr macht', answer: 'děláte'),
    CourseItem(prompt: 'sie machen', answer: 'dělají'),
    CourseItem(prompt: 'ich mache nicht', answer: 'nedělám'),
    CourseItem(prompt: 'Was machst du?', answer: 'Co děláš?'),
    CourseItem(prompt: 'Ich mache nichts.', answer: 'Nic nedělám.'),
    CourseItem(prompt: 'Wir machen es zusammen.', answer: 'Děláme to spolu.'),
    CourseItem(prompt: 'Was macht Tomáš?', answer: 'Co dělá Tomáš?'),
    CourseItem(prompt: 'Macht ihr das oft?', answer: 'Děláte to často?'),
  ],
);

final QuizContent deCsM3KazdyDen = deCsSpeak(
  id: 'de_cs_m3_kazdy_den',
  title: 'Sprechen: Co děláš každý den?',
  intro:
      'Dein Tagesablauf auf Tschechisch. Alles, was du regelmäßig tust, steht in '
      'der unvollendeten Form – das ist schon der Aspekt.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Gewohnheit = imperfektiv',
      text: 'Was du regelmäßig tust, steht unvollendet (piju, čtu, učím se). [FR] das '
          'ist das *imparfait*-Gefühl, hier im Präsens vorbereitet.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Signalwörter',
      text: 'ráno (morgens), večer (abends), každý den (jeden Tag) kündigen eine '
          'Gewohnheit an.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Präposition zieht ihren Fall',
      text: 'v kavárně / v restauraci (Lokativ, »wo«), s Tomášem (Instrumental, '
          '»mit wem«). Jede Präposition bestimmt den Fall.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Morgens trinke ich Kaffee ([FR] Le matin je bois un café — Gewohnheit, imperfektiv)', answer: 'Ráno piju kávu.'),
    CourseItem(prompt: 'Jeden Tag lerne ich Tschechisch ([FR] Chaque jour j’apprends — »se« an zweiter Stelle)', answer: 'Každý den se učím česky.'),
    CourseItem(prompt: 'Ich arbeite in einem Café ([FR] Je travaille au café — »v« + Lokativ)', answer: 'Pracuji v kavárně.'),
    CourseItem(prompt: 'Abends lese ich ein Buch ([FR] Le soir je lis un livre — kniha → knihu Akkusativ)', answer: 'Večer čtu knihu.'),
    CourseItem(prompt: 'Ich spreche mit Tomáš ([FR] Je parle avec Tomáš — »s« + Instrumental: Tomáš → Tomášem)', answer: 'Mluvím s Tomášem.'),
    CourseItem(prompt: 'Ich esse im Restaurant ([FR] Je mange au restaurant — restaurace ← frz.!)', answer: 'Jím v restauraci.'),
    CourseItem(prompt: 'Ich wohne in Prag ([FR] J’habite à Prague)', answer: 'Bydlím v Praze.'),
  ],
);

final QuizContent deCsM3Aspekt = deCsFill(
  id: 'de_cs_m3_aspekt',
  title: 'Vid: dokonavý a nedokonavý (Aspekt)',
  intro:
      'Das Herzstück des Tschechischen – und dein größter Vorteil als '
      'Französischlehrerin. Fast jedes Verb hat ZWEI Formen: unvollendet (Verlauf, '
      'Gewohnheit) und vollendet (abgeschlossen, einmalig).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Zwei Verben für ein deutsches',
      text: 'Jedes Verb hat ein Paar: nedokonavý (unvollendet) für Verlauf/'
          'Gewohnheit, dokonavý (vollendet) für die abgeschlossene, einmalige Tat. '
          '[DE] hat KEIN grammatisches Aspektsystem.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '[FR] Dein Anker: imparfait vs passé composé',
      text: 'imperfektiv ≈ *je lisais* (imparfait: Verlauf, Gewohnheit). perfektiv '
          '≈ *j’ai lu* (passé composé: abgeschlossen). Genau diese Unterscheidung '
          'unterrichtest du jeden Tag.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Perfektives Präsens = Zukunft!',
      text: '»napíšu« sieht aus wie Präsens, heißt aber »ich werde schreiben«. Eine '
          'vollendete Handlung kann nicht »gerade jetzt« laufen. [DE]/[FR] brauchen ein '
          'Hilfsverb für die Zukunft – Tschechisch nicht.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Vorsilbe oder neuer Stamm',
      text: 'Oft macht eine Vorsilbe vollendet: psát → NApsat, číst → PŘEčíst, '
          'dělat → Udělat. Manchmal wechselt der Stamm: kupovat → koupit.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'machen / tun (Verlauf, unvollendet)', answer: 'dělat'),
    CourseItem(prompt: 'erledigen / fertig machen (vollendet)', answer: 'udělat'),
    CourseItem(prompt: 'schreiben (Verlauf, unvollendet)', answer: 'psát'),
    CourseItem(prompt: '(zu Ende) schreiben (vollendet)', answer: 'napsat'),
    CourseItem(prompt: 'lesen (Verlauf, unvollendet)', answer: 'číst'),
    CourseItem(prompt: '(ganz) lesen (vollendet)', answer: 'přečíst'),
    CourseItem(prompt: 'kaufen (gewohnt, unvollendet)', answer: 'kupovat'),
    CourseItem(prompt: '(einmal) kaufen (vollendet)', answer: 'koupit'),
    CourseItem(prompt: 'Ich schreibe (gerade) einen Brief.', answer: 'Píšu dopis.'),
    CourseItem(prompt: 'Ich schreibe den Brief (morgen) fertig.', answer: 'Napíšu dopis.'),
    CourseItem(prompt: 'Jeden Tag lese ich.', answer: 'Každý den čtu.'),
    CourseItem(prompt: 'Ich habe das Buch (ganz) gelesen.', answer: 'Přečetl jsem knihu.', accepted: ['Přečetla jsem knihu.']),
  ],
);

final QuizContent deCsM3AspektMluvit = deCsSpeak(
  id: 'de_cs_m3_aspekt_mluvit',
  title: 'Sprechen: Vid v akci (Aspekt im Satz)',
  intro:
      'Den Aspekt fühlst du über das Französische: imperfektiv ≈ imparfait, '
      'perfektiv ≈ passé composé. Sprich die Paare laut und höre den Unterschied.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Hör den Aspekt',
      text: 'Sprich die Paare hintereinander: čtu / přečetl, píšu / napíšu, kupuju '
          '/ koupím. Der Unterschied ist hörbar – wie imparfait vs passé composé.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Perfektiv zeigt in die Zukunft',
      text: '»napíšu«, »koupím«, »přečtu« meinen die Zukunft. Für »gerade jetzt« '
          'nimm die imperfektive Form (píšu, kupuju, čtu).',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Zeit-Signale lenken den Aspekt',
      text: 'vždycky (immer), každý den (jeden Tag), často (oft) → imperfektiv. '
          'včera (gestern), dnes (heute, einmal), zítra (morgen) → oft perfektiv.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Jeden Tag lese ich Zeitung ([FR] Je lisais le journal — imperfektiv »čtu« = Gewohnheit, imparfait-Gefühl)', answer: 'Každý den čtu noviny.'),
    CourseItem(prompt: 'Gestern habe ich das Buch ausgelesen ([FR] J’ai lu le livre — perfektiv »přečetl«, Präfix pře- = fertig)', answer: 'Včera jsem přečetl knihu.'),
    CourseItem(prompt: 'Ich schreibe (gerade) einen Brief ([FR] Je suis en train d’écrire — imperfektiv, Verlauf)', answer: 'Píšu dopis.'),
    CourseItem(prompt: 'Ich schreibe dir morgen ([FR] Je t’écrirai — perfektives Präsens = Zukunft! na- vollendet)', answer: 'Napíšu ti zítra.'),
    CourseItem(prompt: 'Ich kaufe immer Brot ([FR] J’achète toujours du pain — imperfektiv »kupuju«, Gewohnheit)', answer: 'Vždycky kupuju chleba.'),
    CourseItem(prompt: 'Heute kaufe ich Wein ([FR] J’achèterai du vin — perfektiv »koupím«, einmalig)', answer: 'Dnes koupím víno.'),
    CourseItem(prompt: 'Ich lerne — und ich werde es lernen! ([FR] j’apprends … je vais l’apprendre — Prozess vs Resultat)', answer: 'Učím se a naučím se!'),
  ],
);

final QuizContent deCsM3CteniDen = deCsRead(
  id: 'de_cs_m3_cteni_den',
  title: 'Lesen: Klářin den v Praze',
  passageTitle: 'Klářin den v Praze',
  passage:
      'Klára má ráda Prahu. Každé ráno pije kávu v malé kavárně a čte noviny. '
      'Pak jde do školy. Dnes ale udělala něco jiného: koupila lístek a jela '
      'tramvají na Pražský hrad. Tam potkala Tomáše. „Ahoj, Kláro!“ řekl Tomáš. '
      'Spolu si dali oběd a mluvili česky. Byl to krásný den.',
  passageTranslation:
      'Klára mag Prag. Jeden Morgen trinkt sie Kaffee in einem kleinen Café und '
      'liest Zeitung. Dann geht sie zur Uni. Heute aber machte sie etwas anderes: '
      'sie kaufte ein Ticket und fuhr mit der Straßenbahn zur Prager Burg. Dort '
      'traf sie Tomáš. „Hallo, Klára!“, sagte Tomáš. Zusammen aßen sie zu Mittag '
      'und sprachen Tschechisch. Es war ein schöner Tag.',
  intro: 'Klářin Tag – Gewohntes und ein besonderer Moment. Achte darauf, wie der '
      'Aspekt zwischen beidem wechselt.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Vergangenheit: -l-Partizip',
      text: 'Die Vergangenheit bildet man mit dem -l-Partizip (+ Form von být in '
          'der 1./2. Person): »koupila«, »jela«, »dali si«. »udělala« ist perfektiv '
          '(fertig), »pije/čte« imperfektiv (Gewohnheit).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '[FR] Dein Erzähl-Rhythmus',
      text: 'Gewohntes (pije, čte) wie *imparfait*, der besondere Tag (koupila, '
          'jela, potkala) wie *passé composé*. Genau dein französisches '
          'Erzählgefühl – nur im Tschechischen.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Partizip kongruiert mit dem Subjekt',
      text: 'Klára koupil**a** (sie, f), Tomáš řek**l** (er, m). Das -l-Partizip '
          'zeigt das Genus des Subjekts.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Co dělá Klára každé ráno?',
      options: ['Pije kávu a čte noviny', 'Jde na hrad', 'Pracuje v kavárně'],
      correctIndex: 0,
      questionTranslation: 'Was macht Klára jeden Morgen?',
    ),
    ReadingQuestion(
      question: 'Co udělala dnes?',
      options: ['Koupila lístek a jela na hrad', 'Zůstala doma', 'Učila se česky'],
      correctIndex: 0,
      questionTranslation: 'Was machte sie heute?',
    ),
    ReadingQuestion(
      question: 'Koho potkala na hradě?',
      options: ['Tomáše', 'Kláru', 'Pana Nováka'],
      correctIndex: 0,
      questionTranslation: 'Wen traf sie auf der Burg?',
    ),
    ReadingQuestion(
      question: 'Jaký byl ten den?',
      options: ['Krásný', 'Dlouhý', 'Smutný'],
      correctIndex: 0,
      questionTranslation: 'Wie war der Tag?',
    ),
  ],
);

final QuizContent deCsM3Instrumental = deCsFill(
  id: 'de_cs_m3_instrumental',
  title: 'Instrumentál: autem, s kamarádem',
  intro:
      'Das »Womit« und das »Mit wem« – der 7. Fall. Oft braucht er nicht einmal '
      'eine Präposition: die Endung allein sagt »mit«.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Das Mittel: blanker Instrumental',
      text: 'Werkzeug/Verkehrsmittel stehen im Instrumental – OHNE Präposition: '
          '»autem« (mit dem Auto), »vlakem« (mit dem Zug), »lžící« (mit dem Löffel). '
          '[DE] mit + Dativ, [FR] en/avec.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Die Begleitung: »s« + Instrumental',
      text: '»MIT jemandem« = »s« + Instrumental: s kamarádem, s Tomášem, s Klárou. '
          'Hier steht »s«; beim Mittel (autem) steht keine Präposition.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Die Endungen',
      text: 'maskulin/neutrum: -em (vlak → vlakem, učitel → učitelem). feminin: -ou '
          '(káva → kávou, Klára → Klárou) oder -í (tramvaj → tramvají).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '[FR] Zwei Wörter, hier eine Endung',
      text: '*en voiture*, *avec un ami* – Französisch nimmt Präpositionen, '
          'Tschechisch packt das »mit« oft direkt in die Endung.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'mit dem Auto', answer: 'autem'),
    CourseItem(prompt: 'mit dem Zug', answer: 'vlakem'),
    CourseItem(prompt: 'mit der Straßenbahn', answer: 'tramvají'),
    CourseItem(prompt: 'mit dem Bus', answer: 'autobusem'),
    CourseItem(prompt: 'mit einem Freund', answer: 's kamarádem'),
    CourseItem(prompt: 'mit einer Freundin', answer: 's kamarádkou'),
    CourseItem(prompt: 'mit Tomáš', answer: 's Tomášem'),
    CourseItem(prompt: 'mit Klára', answer: 's Klárou'),
    CourseItem(prompt: 'Ich fahre mit dem Auto.', answer: 'Jedu autem.'),
    CourseItem(prompt: 'Ich spreche mit dem Lehrer.', answer: 'Mluvím s učitelem.'),
    CourseItem(prompt: 'Ich esse mit einem Löffel.', answer: 'Jím lžící.'),
    CourseItem(prompt: 'Kaffee mit Milch', answer: 'káva s mlékem'),
  ],
);

final QuizContent deCsM3SeSi = deCsSpeak(
  id: 'de_cs_m3_se_si',
  title: 'Sprechen: Reflexiva se/si',
  intro:
      'Das kleine Wort »se« (und sein Dativ-Bruder »si«) steckt in vielen '
      'Alltagsverben – und sitzt immer an zweiter Satzstelle.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '»se« (Akkusativ) vs »si« (Dativ)',
      text: '»se« = sich (wen?), »si« = sich (wem?). »myji se« (ich wasche mich) '
          'vs »myji si ruce« (ich wasche mir die Hände). [DE] kennt genau diesen '
          'Akk/Dat-Split bei »sich«.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Klitika in zweiter Position',
      text: '»se/si« rutschen an die zweite Satzstelle, nicht ans Verb: »Učím se«, '
          'aber »Každý den SE učím«. [FR] vgl. die feste Reihenfolge in *je le lui '
          'donne*.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '»se« = man',
      text: '»Mluví se tady česky?« (Spricht man hier Tschechisch?), »Jak se to '
          'řekne?« (Wie sagt man das?) – unpersönliches »se«. [FR] vgl. *on*.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '»si« = für mich selbst',
      text: '»Dám si kávu« (ich nehme mir einen Kaffee), »Sednu si« (ich setze '
          'mich). Das »si« macht die Handlung persönlich-zugewandt.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich heiße Klára ([FR] Je m’appelle — »se« = Akkusativ-Reflexiv)', answer: 'Jmenuji se Klára.'),
    CourseItem(prompt: 'Ich lerne Tschechisch ([FR] J’apprends — »učit se«: das »se« gehört zum Verb)', answer: 'Učím se česky.'),
    CourseItem(prompt: 'Ich nehme einen Kaffee ([FR] Je prends un café — »si« = Dativ-Reflexiv, »ich gebe mir«)', answer: 'Dám si kávu.'),
    CourseItem(prompt: "Wie geht's dir? ([FR] Comment vas-tu ? — reflexives »mít se«)", answer: 'Jak se máš?'),
    CourseItem(prompt: 'Ich schaue einen Film ([FR] Je regarde un film — »dívat se« reflexiv)', answer: 'Dívám se na film.'),
    CourseItem(prompt: 'Spricht man hier Tschechisch? ([FR] parle-t-on — »se« = man, unpersönlich)', answer: 'Mluví se tady česky?'),
    CourseItem(prompt: 'Ich setze mich hierher ([FR] Je m’assieds — »si« Dativ-Reflexiv)', answer: 'Sednu si sem.'),
  ],
);

final QuizContent deCsM3CoDal = deCsRead(
  id: 'de_cs_m3_co_dal',
  title: 'Lesen: Co bude dál? (Ausblick)',
  passageTitle: 'Co bude dál?',
  passage:
      'Gratuluji! Teď umíš pozdravit, představit se, počítat a cítíš první rozdíl '
      'mezi dokonavým a nedokonavým videm. To je víc, než si myslíš. Čeština má '
      'sedm pádů a u každého slovesa dvojici vidů. Zní to těžko? Ty už máš základ: '
      'znáš čtyři pády z němčiny a cítíš vid z francouzštiny. „Učím se a naučím '
      'se,“ říká Klára. Tak pojď dál – těší mě, že jsi tady!',
  passageTranslation:
      'Gratuliere! Jetzt kannst du grüßen, dich vorstellen, zählen und spürst den '
      'ersten Unterschied zwischen vollendetem und unvollendetem Aspekt. Das ist '
      'mehr, als du denkst. Tschechisch hat sieben Fälle und zu jedem Verb ein '
      'Aspektpaar. Klingt schwer? Du hast schon das Fundament: Du kennst vier '
      'Fälle aus dem Deutschen und fühlst den Aspekt aus dem Französischen. „Ich '
      'lerne – und ich werde es lernen“, sagt Klára. Also komm weiter – schön, '
      'dass du hier bist!',
  intro: 'Ein kurzer Ausblick: Was du schon kannst, und was als Nächstes wartet. '
      'Dein Fundament ist größer, als du denkst.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Dein Fundament steht',
      text: 'Vier Fälle kennst du aus dem Deutschen (Nominativ, Akkusativ, Dativ, '
          'Genitiv), den Aspekt fühlst du aus dem Französischen (imparfait / passé '
          'composé). Tschechisch baut nur darauf auf.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Die 7 Fälle (Vorschau)',
      text: '1. Nominativ (kdo? co?) · 2. Genitiv (koho? čeho?) · 3. Dativ (komu? '
          'čemu?) · 4. Akkusativ (koho? co?) · 5. Vokativ (Anrede) · 6. Lokativ '
          '(nur mit Präposition) · 7. Instrumental (kým? čím?). Drei davon hast du '
          'hier schon getroffen!',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Ein Wort, sieben Gesichter',
      text: '»student« wird zu studenta, studentovi, studente, studentem… Im '
          'Aufbaukurs lernst du die ganze Tabelle – Schritt für Schritt.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Weiter geht’s',
      text: 'Den schwersten Teil – die Scheu – hast du schon hinter dir. »Učím se '
          'a naučím se.«',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Co už umíš?',
      options: ['Pozdravit a představit se', 'Vařit česká jídla', 'Řídit auto'],
      correctIndex: 0,
      questionTranslation: 'Was kannst du schon?',
    ),
    ReadingQuestion(
      question: 'Kolik pádů má čeština?',
      options: ['Čtyři', 'Sedm', 'Deset'],
      correctIndex: 1,
      questionTranslation: 'Wie viele Fälle hat Tschechisch?',
    ),
    ReadingQuestion(
      question: 'Odkud znáš pády a vid?',
      options: ['Z němčiny a francouzštiny', 'Z angličtiny', 'Ze španělštiny'],
      correctIndex: 0,
      questionTranslation: 'Woher kennst du Fälle und Aspekt?',
    ),
  ],
);

/// Modul 3 in chain order (interleaved knowledge / audio / reading).
final List<QuizContent> deCsM3 = [
  deCsM3Sloveso,
  deCsM3KazdyDen,
  deCsM3Aspekt,
  deCsM3AspektMluvit,
  deCsM3CteniDen,
  deCsM3Instrumental,
  deCsM3SeSi,
  deCsM3CoDal,
];
