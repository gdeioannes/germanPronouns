import 'dart:math';

String _canonicalCaseLabel(String caseLabel) {
  switch (caseLabel) {
    case 'Poss. Masc. Nom.':
      return 'Poss. Masc.';
    case 'Poss. Fem. Nom.':
      return 'Poss. Fem.';
    case 'Poss. Neut. Nom.':
      return 'Poss. Neut.';
    case 'Poss. Pl. Nom.':
      return 'Poss. Pl.';
    default:
      return caseLabel;
  }
}

/// Public alias of the case-label canonicalization used by this bank, so the
/// quiz-content layer can look up [referenceSentenceTemplates] by category.
String canonicalReferenceCaseLabel(String caseLabel) =>
    _canonicalCaseLabel(caseLabel);

/// Pronoun example sentences, keyed by canonical case label → answer form →
/// candidate sentences (each containing a `____` blank).
///
/// Design goals:
///  - Every sentence makes the grammatical role *obvious* without hints.
///  - No parenthetical disambiguation like "(die Schwester)" — the sentence
///    context alone signals who the referent is and what the case role is.
///  - Accusative  → vivid direct-object verbs: sehen, anrufen, einladen…
///  - Dative      → verbs that demand a recipient: helfen, gehören, schreiben…
///  - Genitive    → wegen / trotz / statt constructions
///  - Reflexive   → clearly reflexive verbs and structures
///  - Possessive  → noun always matches the expected gender/number/case
///
/// Public so the quiz-content layer can enumerate these as data (see
/// pronoun_content.dart); also used by [pickReferenceSentence].
const Map<String, Map<String, List<String>>> referenceSentenceTemplates =
    <String, Map<String, List<String>>>{
    // ── Personal pronouns — Accusative ──────────────────────────────────────
    'Accusative': {
      // mich — 1 sg acc
      'mich': [
        'Kannst du ____ bitte vom Bahnhof abholen?',
        'Er hat ____ auf der Straße gar nicht erkannt.',
        'Sie hat ____ gestern zum Abendessen eingeladen.',
      ],
      // dich — 2 sg acc
      'dich': [
        'Ich vermisse ____ wirklich sehr.',
        'Er liebt ____ von ganzem Herzen.',
        'Wir haben ____ den ganzen Nachmittag gesucht!',
      ],
      // ihn — 3 sg masc acc
      'ihn': [
        'Kennst du ____? Er wohnt direkt nebenan.',
        'Ich habe ____ gestern im Park gesehen.',
        'Sie hat ____ zum Geburtstag eingeladen.',
      ],
      // sie — 3 sg fem acc (or 3 pl acc)
      'sie': [
        'Rufst du ____ heute Abend noch an?',
        'Er trifft ____ jeden Mittwoch im Café.',
        'Ich habe ____ seit dem Sommer nicht mehr gesehen.',
      ],
      // es — 3 sg neut acc
      'es': [
        'Das Buch? Ich habe ____ noch nicht gelesen.',
        'Das Baby weint — leg ____ bitte wieder hin.',
        'Ich kenne das Lied — ich liebe ____.',
      ],
      // uns — 1 pl acc
      'uns': [
        'Kannst du ____ morgen vom Bahnhof abholen?',
        'Hat er ____ wirklich nicht gesehen?',
        'Sie haben ____ zum Sommerfest eingeladen.',
      ],
      // euch — 2 pl acc
      'euch': [
        'Ich habe ____ doch gewarnt!',
        'Wir haben ____ überall gesucht.',
        'Er besucht ____ nächsten Samstag.',
      ],
      // Sie — formal acc
      'Sie': [
        'Ich werde ____ morgen früh anrufen.',
        'Darf ich ____ kurz um Rat fragen?',
        'Wir erwarten ____ pünktlich um zehn Uhr.',
      ],
    },

    // ── Personal pronouns — Dative ───────────────────────────────────────────
    'Dative': {
      // mir — 1 sg dat
      'mir': [
        'Kannst du ____ bitte helfen?',
        'Er hat ____ das Buch zurückgegeben.',
        'Das gehört doch ____!',
      ],
      // dir — 2 sg dat
      'dir': [
        'Ich schreibe ____ heute noch eine Nachricht.',
        'Das Buch gehört ____, nicht mir.',
        'Ich danke ____ wirklich von Herzen.',
      ],
      // ihm — 3 sg masc dat
      'ihm': [
        'Ich habe ____ immer vertraut.',
        'Das Geld gehört ____.',
        'Sie bringt ____ jeden Abend Essen.',
      ],
      // ihr — 3 sg fem dat
      'ihr': [
        'Ich habe ____ geholfen, den Koffer zu tragen.',
        'Das rote Fahrrad gehört ____.',
        'Wir schicken ____ eine Einladungskarte.',
      ],
      // uns — 1 pl dat
      'uns': [
        'Kannst du ____ erklären, wo der Ausgang ist?',
        'Er hat ____ leider nichts davon gesagt.',
        'Das Haus am See gehört ____.',
      ],
      // euch — 2 pl dat
      'euch': [
        'Ich werde ____ die ganze Wahrheit sagen.',
        'Hat er ____ wirklich geholfen?',
        'Das wird ____ bestimmt schmecken.',
      ],
      // ihnen — 3 pl dat
      'ihnen': [
        'Ich habe ____ alles genau erklärt.',
        'Das Geld gehört ____ beiden.',
        'Sie dankt ____ herzlich für die Hilfe.',
      ],
      // Ihnen — formal dat
      'Ihnen': [
        'Kann ich ____ irgendwie behilflich sein?',
        'Ich schicke ____ die Unterlagen noch heute zu.',
        'Ich danke ____ für Ihre Geduld.',
      ],
    },

    // ── Personal pronouns — Genitive ─────────────────────────────────────────
    'Genitive': {
      // meiner — 1 sg gen
      'meiner': [
        'Wegen ____ hat sich der ganze Plan geändert.',
        'Trotz ____ blieb die Stimmung gut.',
        'Man hat statt ____ einen anderen geschickt.',
      ],
      // deiner — 2 sg gen
      'deiner': [
        'Wegen ____ haben wir den Zug verpasst.',
        'Trotz ____ halten wir an dem Plan fest.',
        'Statt ____ kam jemand anderes.',
      ],
      // seiner — 3 sg masc gen
      'seiner': [
        'Wegen ____ wurde das Projekt auf Eis gelegt.',
        'Trotz ____ fährt das Team fort.',
        'Statt ____ übernahm ein Kollege die Aufgabe.',
      ],
      // ihrer — 3 sg fem / 3 pl gen
      'ihrer': [
        'Wegen ____ blieb er den ganzen Tag zu Hause.',
        'Trotz ____ kamen alle pünktlich an.',
        'Statt ____ sprach eine Vertreterin.',
      ],
      // unser — 1 pl gen
      'unser': [
        'Wegen ____ wurde das Spiel verschoben.',
        'Trotz ____ haben alle unterschrieben.',
        'Man hat statt ____ eine externe Firma beauftragt.',
      ],
      // euer — 2 pl gen
      'euer': [
        'Wegen ____ mussten alle länger warten.',
        'Trotz ____ hat das Projekt geklappt.',
      ],
      // Ihrer — formal gen
      'Ihrer': [
        'Wegen ____ haben wir die Entscheidung überprüft.',
        'Trotz ____ bleibt die Frage offen.',
      ],
    },

    // ── Reflexive pronouns ───────────────────────────────────────────────────
    'Reflexive': {
      // mich — reflexive for ich
      'mich': [
        'Ich freue ____ schon sehr auf das Wochenende.',
        'Ich habe ____ beim Sport verletzt.',
        'Ich muss ____ jetzt wirklich beeilen.',
      ],
      // dich — reflexive for du
      'dich': [
        'Hast du ____ gut amüsiert?',
        'Erinnerst du ____ noch an unseren Urlaub?',
        'Du solltest ____ jetzt ausruhen.',
      ],
      // sich — 3rd person & formal reflexive
      'sich': [
        'Er hat ____ beim Sport verletzt.',
        'Sie freut ____ schon sehr auf das Konzert.',
        'Das Kind wäscht ____ jetzt alleine.',
      ],
      // uns — 1 pl reflexive
      'uns': [
        'Wir haben ____ zufällig im Park getroffen.',
        'Wir müssen ____ jetzt beeilen.',
        'Wir erinnern ____ noch gut daran.',
      ],
      // euch — 2 pl reflexive
      'euch': [
        'Habt ihr ____ gut amüsiert?',
        'Beeilt ____!',
        'Das solltet ihr ____ gut merken.',
      ],
    },

    // ── Possessive pronouns ──────────────────────────────────────────────────
    // Noun in each sentence matches gender / number / case to reinforce the form.
    'Poss. Masc.': {
      'mein': ['Das ist ____ Vater.', '____ Bruder kommt heute Abend.'],
      'dein': ['Ist das ____ Schlüssel?', '____ Freund wartet schon unten.'],
      'sein': ['____ Hund ist riesengroß.', 'Das ist ____ Rucksack.'],
      'ihr': ['____ Mann arbeitet in Berlin.', 'Das ist ____ Vater.'],
      'unser': ['____ Lehrer ist sehr streng.', 'Das ist ____ Nachbar.'],
      'euer': ['Wo ist ____ Vater?', '____ Bruder hat gerade angerufen.'],
      'Ihr': [
        'Ist ____ Wagen der blaue?',
        '____ Kollege hat eine Nachricht hinterlassen.',
      ],
    },

    'Poss. Masc. Acc.': {
      'meinen': [
        'Ich suche ____ Schlüssel — hast du ihn gesehen?',
        'Hast du ____ Bruder heute irgendwo getroffen?',
      ],
      'deinen': [
        'Ich schätze ____ Humor wirklich sehr.',
        'Ruf doch ____ Vater an!',
      ],
      'seinen': [
        'Sie liebt ____ Hund über alles.',
        'Er vergisst ____ Regenschirm ständig.',
      ],
      'ihren': [
        'Sie besucht ____ Mann jeden Tag im Krankenhaus.',
        'Sie vermisst ____ Bruder sehr.',
      ],
      'unseren': [
        'Wir unterstützen ____ Verein seit Jahren.',
        'Wir besuchen ____ Lehrer noch heute.',
      ],
      'euren': [
        'Ihr solltet ____ Vater öfter anrufen.',
        'Ich kenne ____ Freund gut.',
      ],
      'Ihren': [
        'Ich werde ____ Kollegen sofort benachrichtigen.',
        'Haben Sie ____ Pass zur Hand?',
      ],
    },

    'Poss. Masc. Dat.': {
      'meinem': [
        'Ich vertraue ____ Arzt vollkommen.',
        'Er hilft ____ Vater gern im Garten.',
      ],
      'deinem': [
        'Ich habe ____ Freund beim Umzug geholfen.',
        'Mit ____ Bruder war es wirklich lustig.',
      ],
      'seinem': [
        'Sie gibt ____ Mann die Schlüssel.',
        'Er dankt ____ Lehrer für alles.',
      ],
      'ihrem': [
        'Sie schreibt ____ Bruder regelmäßig eine Karte.',
        'Mit ____ Mann reist sie sehr gern.',
      ],
      'unserem': [
        'Wir vertrauen ____ Arzt blind.',
        'Sie hilft ____ Nachbarn, wo sie kann.',
      ],
      'eurem': [
        'Zeigt das doch ____ Vater!',
        'Mit ____ Lehrer habt ihr wirklich Glück.',
      ],
      'Ihrem': [
        'Ich schicke das direkt ____ Kollegen.',
        'Bitte sprechen Sie zunächst mit ____ Arzt.',
      ],
    },

    'Poss. Masc. Gen.': {
      'meines': [
        'Wegen ____ Bruders musste ich lange warten.',
        'Trotz ____ Freundes habe ich es allein geschafft.',
      ],
      'deines': [
        'Wegen ____ Freundes sind wir zu spät gekommen.',
        'Trotz ____ Bruders blieben wir bei unserer Entscheidung.',
      ],
      'seines': [
        'Wegen ____ Hundes darf er nicht ins Hotel.',
        'Trotz ____ Lehrers lernte er einfach nicht.',
      ],
      'ihres': [
        'Wegen ____ Mannes zog sie in die Stadt.',
        'Trotz ____ Bruders schaffte sie es kaum allein.',
      ],
      'unseres': [
        'Wegen ____ Lehrers fiel der Unterricht aus.',
        'Trotz ____ Chefs machten wir früh Feierabend.',
      ],
      'eures': [
        'Wegen ____ Freundes haben wir ewig gewartet.',
        'Trotz ____ Vaters fuhren wir trotzdem los.',
      ],
      'Ihres': [
        'Wegen ____ Kollegen hat sich das Projekt verzögert.',
        'Trotz ____ Arztes rauchte er weiter.',
      ],
    },

    'Poss. Fem.': {
      'meine': ['____ Schwester wohnt in München.', 'Das ist ____ Tasche.'],
      'deine': ['Ist das ____ Mutter?', '____ Freundin hat gerade angerufen.'],
      'seine': ['____ Tochter ist Ärztin geworden.', 'Das ist ____ Frau.'],
      'ihre': ['____ Mutter kocht fantastisch.', 'Das ist ____ Tochter.'],
      'unsere': ['____ Lehrerin ist sehr geduldig.', 'Das ist ____ Nachbarin.'],
      'eure': [
        'Wo ist ____ Mutter?',
        '____ Schwester hat den Wettbewerb gewonnen.',
      ],
      'Ihre': [
        'Ist ____ Kollegin bereits informiert?',
        '____ Frau hat eine Nachricht hinterlassen.',
      ],
    },

    'Poss. Fem. Acc.': {
      'meine': [
        'Ich suche ____ Jacke — hast du sie gesehen?',
        'Hast du ____ Schwester heute getroffen?',
      ],
      'deine': ['Ich schätze ____ Mutter sehr.', 'Ruf ____ Schwester doch an!'],
      'seine': [
        'Er vermisst ____ Tochter sehr.',
        'Er besucht ____ Frau jeden Tag.',
      ],
      'ihre': [
        'Sie besucht ____ Mutter jedes Wochenende.',
        'Sie liebt ____ Schwester über alles.',
      ],
      'unsere': [
        'Wir unterstützen ____ Mannschaft bei jedem Spiel.',
        'Wir besuchen ____ Lehrerin nächste Woche.',
      ],
      'eure': [
        'Besucht doch mal ____ Schwester!',
        'Ich kenne ____ Mutter schon lange.',
      ],
      'Ihre': [
        'Ich werde ____ Kollegin sofort informieren.',
        'Haben Sie ____ Karte dabei?',
      ],
    },

    'Poss. Fem. Dat.': {
      'meiner': [
        'Ich helfe ____ Mutter jeden Samstag im Haushalt.',
        'Mit ____ Schwester verreise ich sehr gern.',
      ],
      'deiner': [
        'Er dankt ____ Mutter für ihre Geduld.',
        'Mit ____ Freundin war der Abend wunderschön.',
      ],
      'seiner': [
        'Er schreibt ____ Tochter jeden Monat einen Brief.',
        'Er vertraut ____ Frau in allem.',
      ],
      'ihrer': [
        'Sie hilft ____ Mutter täglich beim Einkaufen.',
        'Mit ____ Schwester teilt sie das Zimmer.',
      ],
      'unserer': [
        'Wir vertrauen ____ Ärztin vollkommen.',
        'Er hilft ____ Nachbarin, wo er kann.',
      ],
      'eurer': [
        'Zeigt das ____ Mutter!',
        'Mit ____ Lehrerin habt ihr wirklich Glück.',
      ],
      'Ihrer': [
        'Ich schicke das direkt ____ Kollegin.',
        'Bitte sprechen Sie zunächst mit ____ Ärztin.',
      ],
    },

    'Poss. Fem. Gen.': {
      'meiner': [
        'Wegen ____ Schwester musste ich früher gehen.',
        'Trotz ____ Mutter handelte sie selbstständig.',
      ],
      'deiner': [
        'Wegen ____ Freundin haben wir uns verspätet.',
        'Trotz ____ Schwester entschied sie allein.',
      ],
      'seiner': [
        'Wegen ____ Frau blieb er an dem Abend zu Hause.',
        'Trotz ____ Tochter änderte er seine Meinung nicht.',
      ],
      'ihrer': [
        'Wegen ____ Mutter zog sie näher an die Stadt.',
        'Trotz ____ Schwester entschied sie sich anders.',
      ],
      'unserer': [
        'Wegen ____ Lehrerin fiel die Stunde aus.',
        'Trotz ____ Trainerin kämpften wir weiter.',
      ],
      'eurer': [
        'Wegen ____ Mutter sind wir alle aufgeregt.',
        'Trotz ____ Freundin zögerte er lange.',
      ],
      'Ihrer': [
        'Wegen ____ Kollegin wurde der Termin verschoben.',
        'Trotz ____ Ärztin aß er weiter Süßigkeiten.',
      ],
    },

    'Poss. Neut.': {
      'mein': ['Das ist ____ Kind.', '____ Baby schläft gerade fest.'],
      'dein': ['Ist das ____ Fahrrad?', '____ Kind ist wirklich süß.'],
      'sein': ['____ Auto steht vor der Tür.', 'Das ist ____ Kind.'],
      'ihr': ['____ Kind spielt draußen im Garten.', 'Das ist ____ Baby.'],
      'unser': ['____ Haus steht auf dem Hügel.', 'Das ist ____ neues Auto.'],
      'euer': [
        'Ist das ____ Haustier?',
        '____ Kind hat den ersten Platz gewonnen.',
      ],
      'Ihr': [
        'Ist ____ Büro im zweiten Stock?',
        '____ Auto steht leider im Weg.',
      ],
    },

    'Poss. Neut. Acc.': {
      'mein': [
        'Ich suche ____ Handy — hast du es gesehen?',
        'Hast du ____ Kind heute gesehen?',
      ],
      'dein': [
        'Ich mag ____ Lächeln sehr.',
        'Nimm ____ Fahrrad mit, falls es regnet!',
      ],
      'sein': [
        'Er liebt ____ Kind über alles.',
        'Er vermisst ____ Haustier sehr.',
      ],
      'ihr': [
        'Sie besucht ____ Kind täglich im Krankenhaus.',
        'Sie streichelt gern ____ Tier.',
      ],
      'unser': [
        'Wir verkaufen ____ Haus im Frühjahr.',
        'Wir holen ____ Kind gleich ab.',
      ],
      'euer': [
        'Holt schnell ____ Gepäck aus dem Zug!',
        'Vergesst ____ Kind nicht!',
      ],
      'Ihr': [
        'Habe ich ____ Gepäck richtig verstaut?',
        'Ich kann ____ Büro leider nicht finden.',
      ],
    },

    'Poss. Neut. Dat.': {
      'meinem': [
        'Ich vertraue ____ Kind diese Aufgabe an.',
        'Er hilft ____ Kind täglich bei den Hausaufgaben.',
      ],
      'deinem': [
        'Mit ____ Auto kommt ihr viel schneller hin.',
        'Er dankt ____ Kind für die liebe Geste.',
      ],
      'seinem': [
        'Sie liest ____ Kind jeden Abend vor.',
        'Er schreibt ____ Kind jeden Monat.',
      ],
      'ihrem': [
        'Sie liest ____ Kind vor dem Einschlafen eine Geschichte vor.',
        'Mit ____ Baby reiste sie sehr vorsichtig.',
      ],
      'unserem': [
        'Wir vertrauen ____ Kind diese Verantwortung an.',
        'Sie spielen täglich mit ____ Tier.',
      ],
      'eurem': [
        'Schenkt ____ Kind doch ein Buch!',
        'Helft ____ Kind beim Lernen!',
      ],
      'Ihrem': ['Ich schicke das direkt ____ Kind.', 'Wie geht es ____ Baby?'],
    },

    'Poss. Neut. Gen.': {
      'meines': [
        'Wegen ____ Kindes blieb ich den ganzen Tag zu Hause.',
        'Trotz ____ Tieres zog sie in eine größere Wohnung.',
      ],
      'deines': [
        'Wegen ____ Babys schlief niemand durch.',
        'Trotz ____ Kindes schlief es irgendwann ein.',
      ],
      'seines': [
        'Wegen ____ Kindes musste er früher nach Hause.',
        'Trotz ____ Autos blieb er lieber zu Fuß.',
      ],
      'ihres': [
        'Wegen ____ Tieres suchte sie eine Wohnung mit Garten.',
        'Trotz ____ Kindes nahm sie die Stelle an.',
      ],
      'unseres': [
        'Wegen ____ Hauses mussten wir viel sparen.',
        'Trotz ____ Autos fuhren wir lieber mit dem Zug.',
      ],
      'eures': [
        'Wegen ____ Kindes haben wir lange gewartet.',
        'Trotz ____ Haustiers war alles geregelt.',
      ],
      'Ihres': [
        'Wegen ____ Autos wurde die Einfahrt blockiert.',
        'Trotz ____ Kindes lief die Besprechung weiter.',
      ],
    },

    'Poss. Pl. Gen.': {
      'meiner': [
        'Wegen ____ Kinder blieb die Tür den ganzen Abend offen.',
        'Trotz ____ Freunde blieb sie allein zu Hause.',
      ],
      'deiner': [
        'Wegen ____ Bücher mussten wir ein neues Regal kaufen.',
        'Trotz ____ Geschwister entschied er ganz allein.',
      ],
      'seiner': [
        'Wegen ____ Eltern wurde das Fest um eine Woche verschoben.',
        'Trotz ____ Kinder fand er Zeit für sich.',
      ],
      'ihrer': [
        'Wegen ____ Töchter fuhren wir früher los.',
        'Trotz ____ Eltern blieben sie freundlich.',
      ],
      'unserer': [
        'Wegen ____ Nachbarn mussten wir den Plan ändern.',
        'Trotz ____ Kinder schafften wir es rechtzeitig.',
      ],
      'eurer': [
        'Wegen ____ Freunde mussten alle länger warten.',
        'Trotz ____ Eltern sind wir trotzdem gefahren.',
      ],
      'Ihrer': [
        'Wegen ____ Kollegen blieb das Büro an dem Tag leer.',
        'Trotz ____ Kinder verlief die Besprechung reibungslos.',
      ],
    },

    'Poss. Pl.': {
      'meine': [
        '____ Kinder spielen den ganzen Tag draußen.',
        '____ Freunde kommen heute Abend vorbei.',
      ],
      'deine': [
        'Sind das ____ Bücher?',
        '____ Geschwister sind wirklich sehr lustig.',
      ],
      'seine': [
        '____ Eltern wohnen schon lange in Hamburg.',
        '____ Kinder sind schon alle groß.',
      ],
      'ihre': [
        '____ Töchter studieren beide Medizin.',
        '____ Eltern kommen nächste Woche zu Besuch.',
      ],
      'unsere': [
        '____ Nachbarn sind wirklich sehr nett.',
        '____ Kinder gehen alle in dieselbe Schule.',
      ],
      'eure': [
        'Sind ____ Eltern auch dabei?',
        '____ Freunde sind natürlich herzlich willkommen.',
      ],
      'Ihre': [
        'Sind ____ Kollegen bereits informiert?',
        '____ Kinder sind herzlich eingeladen.',
      ],
    },
};

/// Returns a sentence that demonstrates the pronoun in a meaningful context,
/// chosen at random from [referenceSentenceTemplates] for the (case, answer)
/// pair. The blank `____` replaces the pronoun so the user fills it in.
String pickReferenceSentence({
  required String caseLabel,
  required String nominative,
  required String answer,
  required Random random,
}) {
  final canonicalCase = _canonicalCaseLabel(caseLabel);
  final caseTemplates = referenceSentenceTemplates[canonicalCase];
  final options =
      caseTemplates?[answer] ?? caseTemplates?[nominative] ?? ['______'];
  return options[random.nextInt(options.length)];
}

String buildReferenceExplanation({
  required String caseLabel,
  required String nominative,
  required String answer,
  required String sentence,
}) {
  final canonicalCase = _canonicalCaseLabel(caseLabel);
  final pronounMeaning = _pronounMeaning(
    caseLabel: canonicalCase,
    nominative: nominative,
    answer: answer,
  );

  final grammarNote = _grammarNote(caseLabel: canonicalCase);
  final englishMeaning = _englishSentenceMeaning(
    caseLabel: canonicalCase,
    answer: answer,
    sentence: sentence,
  );
  final triggerNote = _caseTriggerNote(
    caseLabel: canonicalCase,
    sentence: sentence,
  );

  final possessiveNote = canonicalCase.startsWith('Poss.')
      ? 'This is a possessive determiner (like my/your/his), not a standalone personal pronoun, '
            'so it must agree in gender, number, and case with the noun that follows.'
      : '';

  final targetNote = _targetAgreementNote(canonicalCase);

  return [
    'Example: $sentence',
    'English: $englishMeaning',
    'Answer: "$answer" — $pronounMeaning.',
    'Grammar: $grammarNote',
    if (triggerNote != '') 'Trigger: $triggerNote',
    if (targetNote != '') 'Agreement: $targetNote',
    if (possessiveNote != '') possessiveNote,
    'Base form (nominative): "$nominative".',
  ].join('\n\n');
}

String _englishSentenceMeaning({
  required String caseLabel,
  required String answer,
  required String sentence,
}) {
  final pronounEnglish = caseLabel.startsWith('Poss.')
      ? _possessiveOwnerMeaning(answer)
      : _pronounMeaning(caseLabel: caseLabel, nominative: '', answer: answer);

  if (caseLabel.startsWith('Poss.')) {
    return 'The missing word means "$pronounEnglish" and shows who owns the following noun in this sentence.';
  }

  switch (caseLabel) {
    case 'Accusative':
      return 'This sentence uses "$pronounEnglish" as the direct object: the person or thing receiving the action.';
    case 'Dative':
      return 'This sentence uses "$pronounEnglish" as the indirect object: the recipient or beneficiary.';
    case 'Genitive':
      return 'This sentence uses "$pronounEnglish" in a genitive structure, often translated with "of" or required by prepositions like "because of" / "despite".';
    case 'Reflexive':
      return 'This sentence uses a reflexive meaning: the subject acts back on itself.';
    default:
      return 'In English terms, the missing form means "$pronounEnglish" in this sentence.';
  }
}

String _caseTriggerNote({required String caseLabel, required String sentence}) {
  final lowerSentence = sentence.toLowerCase();
  final trigger = _findFirstTrigger(lowerSentence, const [
    'wegen',
    'trotz',
    'statt',
    'mit',
    'für',
    'ohne',
    'gegen',
    'durch',
    'helfen',
    'gehört',
    'gehören',
    'danken',
    'schreiben',
    'geben',
    'sehen',
    'kennen',
    'einladen',
    'vermissen',
    'anrufen',
    'freut',
    'erinnern',
    'wasche',
  ]);

  if (caseLabel == 'Genitive' || caseLabel.contains('Gen.')) {
    if (trigger == 'wegen' || trigger == 'trotz' || trigger == 'statt') {
      return 'The preposition "$trigger" is a genitive marker here, so German requires a genitive form after it.';
    }
    return 'Look for genitive signals such as wegen, trotz, or statt: these often force the genitive.';
  }

  if (caseLabel == 'Dative' || caseLabel.contains('Dat.')) {
    if (trigger == 'mit') {
      return 'The preposition "$trigger" takes the dative in German.';
    }
    if (trigger == 'helfen' ||
        trigger == 'gehört' ||
        trigger == 'gehören' ||
        trigger == 'danken' ||
        trigger == 'schreiben' ||
        trigger == 'geben') {
      return 'The verb "$trigger" points to a dative role here: the person receiving help, thanks, a message, or an object.';
    }
    return 'Typical dative markers are recipient verbs like helfen, geben, schreiben, danken, or dative prepositions like mit.';
  }

  if (caseLabel == 'Accusative' || caseLabel.contains('Acc.')) {
    if (trigger == 'für' ||
        trigger == 'ohne' ||
        trigger == 'gegen' ||
        trigger == 'durch') {
      return 'The preposition "$trigger" is an accusative marker in German.';
    }
    if (trigger == 'sehen' ||
        trigger == 'kennen' ||
        trigger == 'einladen' ||
        trigger == 'vermissen' ||
        trigger == 'anrufen') {
      return 'The verb "$trigger" takes a direct object here, which is why the accusative is used.';
    }
    return 'Look for a direct-object verb or an accusative preposition such as für, ohne, gegen, or durch.';
  }

  if (caseLabel == 'Reflexive') {
    if (trigger == 'freut' || trigger == 'erinnern' || trigger == 'wasche') {
      return 'The verb form "$trigger" is used reflexively here, so the subject refers back to itself.';
    }
    return 'The verb is reflexive here, which is why the pronoun points back to the subject.';
  }

  if (caseLabel.startsWith('Poss.')) {
    return 'The noun after the blank determines the possessive ending, so check its gender, number, and case.';
  }

  return '';
}

String? _findFirstTrigger(String sentence, List<String> triggers) {
  for (final trigger in triggers) {
    if (sentence.contains(trigger)) {
      return trigger;
    }
  }
  return null;
}

String _grammarNote({required String caseLabel}) {
  switch (caseLabel) {
    case 'Accusative':
      return 'The accusative marks the direct object: the person or thing directly affected by the verb.';
    case 'Dative':
      return 'The dative marks the indirect object: the recipient or beneficiary (to or for whom something happens).';
    case 'Genitive':
      return 'The genitive marks possession or close relation, and is required after prepositions like wegen, trotz, and statt.';
    case 'Reflexive':
      return 'A reflexive form shows the subject acting on itself (for example: I wash myself, she remembers herself).';
    default:
      if (caseLabel.contains('Gen.')) {
        return 'Possessive in the genitive: it shows ownership and follows a genitive trigger such as wegen or trotz.';
      }
      if (caseLabel.contains('Dat.')) {
        return 'Possessive in the dative: it shows ownership and marks the indirect object or follows a dative trigger such as mit or helfen.';
      }
      if (caseLabel.contains('Acc.')) {
        return 'Possessive in the accusative: it shows ownership and marks the direct object of the verb.';
      }
      if (caseLabel.startsWith('Poss.')) {
        return 'Possessive in the nominative: it shows ownership in the subject position.';
      }
      return 'This sentence uses a case-specific pronoun form determined by its grammatical context.';
  }
}

String _targetAgreementNote(String caseLabel) {
  switch (caseLabel) {
    case 'Poss. Masc.':
      return 'Agrees with a masculine noun in the nominative.';
    case 'Poss. Masc. Acc.':
      return 'Agrees with a masculine noun in the accusative.';
    case 'Poss. Masc. Dat.':
      return 'Agrees with a masculine noun in the dative.';
    case 'Poss. Masc. Gen.':
      return 'Agrees with a masculine noun in the genitive.';
    case 'Poss. Fem.':
      return 'Agrees with a feminine noun in the nominative.';
    case 'Poss. Fem. Acc.':
      return 'Agrees with a feminine noun in the accusative.';
    case 'Poss. Fem. Dat.':
      return 'Agrees with a feminine noun in the dative.';
    case 'Poss. Fem. Gen.':
      return 'Agrees with a feminine noun in the genitive.';
    case 'Poss. Neut.':
      return 'Agrees with a neuter noun in the nominative.';
    case 'Poss. Neut. Acc.':
      return 'Agrees with a neuter noun in the accusative.';
    case 'Poss. Neut. Dat.':
      return 'Agrees with a neuter noun in the dative.';
    case 'Poss. Neut. Gen.':
      return 'Agrees with a neuter noun in the genitive.';
    case 'Poss. Pl.':
      return 'Agrees with a plural noun in the nominative or accusative.';
    case 'Poss. Pl. Gen.':
      return 'Agrees with a plural noun in the genitive.';
    default:
      return '';
  }
}

String _pronounMeaning({
  required String caseLabel,
  required String nominative,
  required String answer,
}) {
  if (caseLabel.startsWith('Poss.')) {
    return _possessiveOwnerMeaning(answer);
  }

  final personal = <String, String>{
    'mich': 'me (accusative)',
    'dich': 'you (informal singular, accusative)',
    'ihn': 'him (accusative)',
    'sie': 'her, or them (the context decides)',
    'es': 'it (accusative)',
    'uns': 'us',
    'euch': 'you (informal plural)',
    'Sie': 'you (formal)',
    'mir': 'to me',
    'dir': 'to you (informal singular)',
    'ihm': 'to him, or to it (masculine/neuter)',
    'ihr': 'to her',
    'ihnen': 'to them',
    'Ihnen': 'to you (formal)',
    'meiner': 'of me',
    'deiner': 'of you (informal singular)',
    'seiner': 'of him, or of it (masculine/neuter)',
    'ihrer': 'of her, or of them',
    'unser': 'of us',
    'euer': 'of you (informal plural)',
    'Ihrer': 'of you (formal)',
    'sich': 'himself / herself / itself / themselves (reflexive)',
  };

  return personal[answer] ?? 'a case-marked form of "$nominative"';
}

String _possessiveOwnerMeaning(String answer) {
  final lower = answer.toLowerCase();
  if (lower.startsWith('mein')) return 'my';
  if (lower.startsWith('dein')) return 'your (informal singular)';
  if (lower.startsWith('sein')) {
    return 'his, or its (masculine or neuter owner)';
  }
  if (lower.startsWith('ihr')) return 'her, or their (the context decides)';
  if (lower.startsWith('unser')) return 'our';
  if (lower.startsWith('euer')) return 'your (informal plural)';
  if (answer.startsWith('Ihr')) return 'your (formal)';
  return 'a possessive form';
}
