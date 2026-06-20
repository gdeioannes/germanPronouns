// Shared reference data for German noun gender (der/die/das), used both by the
// on-screen Help Memory / Analytics tables in the quiz engine
// (widgets/quiz_page.dart) and by the PDF export (theme/help_memory_pdf.dart),
// so the two never drift out of sync.

/// Article-gender rows in display order: masculine, feminine, neuter.
const List<String> kGenderRowOrder = ['m', 'f', 'n'];

/// The definite article for each gender key.
const Map<String, String> kGenderArticles = {
  'm': 'der',
  'f': 'die',
  'n': 'das',
};

/// The English name of each gender, shown as a row subtitle.
const Map<String, String> kGenderRowNames = {
  'm': 'masculine',
  'f': 'feminine',
  'n': 'neuter',
};

/// Common (non-absolute) rules of thumb for guessing a noun's gender from its
/// ending or meaning, shown below the reference table for the Artikel quiz.
/// Each entry is "pattern — example(s)".
const Map<String, List<String>> kGenderRules = {
  'm': [
    '-er for people/professions and many tools — der Lehrer, der Bäcker, der Computer',
    '-or — der Motor, der Doktor, der Professor',
    '-ig, -ling, -ich — der König, der Frühling, der Teppich',
    '-ant, -ist, -ismus — der Praktikant, der Tourist, der Optimismus',
    'Seasons, months, days of the week — der Winter, der Mai, der Montag',
    'Weather phenomena — der Regen, der Schnee, der Wind, der Sturm',
    'Cardinal directions — der Norden, der Süden, der Osten, der Westen',
    'Most nouns formed from a verb stem + -en — der Wagen, der Garten',
  ],
  'f': [
    '-e — die Lampe, die Blume, die Tasche (many, but not all: der Junge, das Auge)',
    '-ung — die Zeitung, die Wohnung, die Übung',
    '-heit, -keit, -igkeit — die Freiheit, die Möglichkeit, die Süßigkeit',
    '-schaft — die Freundschaft, die Mannschaft, die Landschaft',
    '-ion, -tion — die Nation, die Information, die Diskussion',
    '-tät — die Universität, die Realität, die Qualität',
    '-ik — die Musik, die Politik, die Mathematik',
    '-ur — die Natur, die Kultur, die Temperatur',
    '-enz, -anz — die Differenz, die Distanz, die Toleranz',
    'Most numbers used as nouns — die Million, die Eins, die Hundert',
    'Many tree and flower names — die Eiche, die Tulpe, die Rose',
  ],
  'n': [
    '-chen, -lein (diminutives) — das Mädchen, das Fräulein, das Häuschen',
    '-um — das Museum, das Zentrum, das Datum',
    '-ment — das Dokument, das Experiment, das Element',
    'Infinitives used as nouns — das Essen, das Leben, das Lesen, das Schwimmen',
    'Most Ge- collective nouns — das Gebäude, das Geschenk, das Gepäck',
    'Young people and animals — das Kind, das Baby, das Fohlen',
    'Metals and chemical elements — das Gold, das Silber, das Eisen',
    'Letters, colors, and languages used as nouns — das A, das Blau, das Deutsch',
  ],
};
