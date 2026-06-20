import '../models/course.dart';
import '../models/nav_layout.dart';
import 'courses/es_de/es_de_content.dart';

/// Navigation links shared by the English courses (word reference, settings,
/// how-it-works, course switcher).
const List<NavItem> _enMoreLinks = [
  NavItem(ref: kWordLibraryRef),
  NavItem(ref: kSettingsRef),
  NavItem(ref: kHowItWorksRef),
  NavItem(ref: kCoursesRef),
];

/// The "Certification German A.1" drawer: the A1 Quest chain split into its two
/// CEFR sub-levels (A1.1, A1.2), plus links. The chain stays globally
/// continuous — A1.2 only unlocks once A1.1 is complete.
final NavLayout _certA1Nav = NavLayout(
  groups: const [
    NavGroup(
      id: 'quest_a1_1',
      title: 'QUEST · A1.1',
      type: NavGroupType.questChain,
      level: 'A1.1',
    ),
    NavGroup(
      id: 'quest_a1_2',
      title: 'QUEST · A1.2',
      type: NavGroupType.questChain,
      level: 'A1.2',
    ),
    NavGroup(
      id: 'more',
      title: 'MORE',
      type: NavGroupType.links,
      items: _enMoreLinks,
    ),
  ],
);

/// The "German Grammar in Detail" drawer: noun categories + the grammar
/// quizzes (plus links).
final NavLayout _grammarNav = NavLayout(
  groups: const [
    NavGroup(
      id: 'nouns',
      title: 'NOUN CATEGORIES',
      type: NavGroupType.nounChain,
    ),
    NavGroup(
      id: 'quizzes',
      title: 'QUIZZES',
      type: NavGroupType.quizzes,
      items: [
        NavItem(ref: 'article'),
        NavItem(ref: 'pronoun'),
        NavItem(ref: 'pronoun_article'),
        NavItem(ref: 'preposition'),
      ],
    ),
    NavGroup(
      id: 'more',
      title: 'MORE',
      type: NavGroupType.links,
      items: _enMoreLinks,
    ),
  ],
);

/// The Español → Alemán drawer: three open Niveles plus a links group.
final NavLayout _esDeNav = NavLayout(
  groups: [
    NavGroup(
      id: 'n1',
      title: 'NIVEL 1 · LO BÁSICO',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeNivel1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'n2',
      title: 'NIVEL 2 · EN LA CIUDAD',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeNivel2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'n3',
      title: 'NIVEL 3 · SITUACIONES',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeNivel3) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'more',
      title: 'MÁS',
      type: NavGroupType.links,
      items: [
        NavItem(ref: kSettingsRef),
        NavItem(ref: kHowItWorksRef),
        NavItem(ref: kCoursesRef),
      ],
    ),
  ],
);

/// The "German Emotions" drawer: emotions vocabulary and healthy couple
/// communication, grouped into thematic bloques plus a links group.
final NavLayout _emotionsNav = NavLayout(
  groups: [
    NavGroup(
      id: 'emo_a',
      title: 'BLOQUE A · LAS EMOCIONES',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueA) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_b',
      title: 'BLOQUE B · EXPRESAR SENTIMIENTOS',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueB) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_c',
      title: 'BLOQUE C · COMUNICACIÓN EN PAREJA',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueC) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_d',
      title: 'BLOQUE D · CONFLICTO Y RECONCILIACIÓN',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueD) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_e',
      title: 'BLOQUE E · LECTURA',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueE) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'more',
      title: 'MÁS',
      type: NavGroupType.links,
      items: [
        NavItem(ref: kSettingsRef),
        NavItem(ref: kHowItWorksRef),
        NavItem(ref: kCoursesRef),
      ],
    ),
  ],
);

/// The id of the course shown by default (the original German app).
const String kDefaultCourseId = 'en_de';

/// All built-in courses, used to seed the database and as a fallback.
final List<Course> defaultCourses = [
  Course(
    id: 'de_cert_a1',
    name: 'Certification German A.1',
    tagline: 'Your step-by-step path to the A1 certificate',
    speakFlag: '🇬🇧',
    learnFlag: '🇩🇪',
    uiLang: UiLang.en,
    nav: _certA1Nav,
  ),
  Course(
    id: kDefaultCourseId,
    name: 'German Grammar in Detail',
    tagline: 'Articles, pronouns, prepositions & nouns in depth',
    speakFlag: '🇬🇧',
    learnFlag: '🇩🇪',
    uiLang: UiLang.en,
    nav: _grammarNav,
  ),
  Course(
    id: 'es_de',
    name: 'Español → Alemán',
    tagline: 'Un viaje rápido a Alemania',
    speakFlag: '🇪🇸',
    learnFlag: '🇩🇪',
    uiLang: UiLang.es,
    nav: _esDeNav,
  ),
  Course(
    id: 'es_de_emotions',
    name: 'German Emotions',
    tagline: 'Sentimientos y comunicación en pareja',
    speakFlag: '🇪🇸',
    learnFlag: '🇩🇪',
    uiLang: UiLang.es,
    nav: _emotionsNav,
  ),
];
