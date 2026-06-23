import '../models/course.dart';
import '../models/nav_layout.dart';
import 'courses/de_es/de_es_content.dart';
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

/// The "German Grammar in Detail" drawer: the grammar quizzes first, then the
/// noun categories (plus links).
final NavLayout _grammarNav = NavLayout(
  groups: const [
    NavGroup(
      id: 'quizzes',
      title: 'GRAMMAR QUIZZES',
      type: NavGroupType.quizzes,
      items: [
        NavItem(ref: 'article'),
        NavItem(ref: 'pronoun'),
        NavItem(ref: 'pronoun_article'),
        NavItem(ref: 'preposition'),
      ],
    ),
    NavGroup(
      id: 'nouns',
      title: 'NOUN CATEGORIES',
      type: NavGroupType.nounChain,
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
      title: 'BLOQUE E · COMUNICACIÓN PROFUNDA (B2–C1)',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueE) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_f',
      title: 'BLOQUE F · CONFRONTACIÓN Y CONFLICTO (B2–C1)',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueF) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_g',
      title: 'BLOQUE G · RUPTURA Y RECONCILIACIÓN (B2–C1)',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueG) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'emo_h',
      title: 'BLOQUE H · LECTURA',
      type: NavGroupType.quizzes,
      items: [for (final c in esDeEmocionesBloqueH) NavItem(ref: c.id)],
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

/// The "Spanisch-Zertifikat" drawer (Deutsch → Spanisch): seven CEFR sub-level
/// groups (A1.1 … B2), each listing its quizzes in chain order, plus links.
///
/// The seven level groups are [NavGroup.gated], so the whole A1.1 → B2 sequence
/// is one continuous pass-to-unlock chain: each quiz opens only once the
/// previous one is finished.
final NavLayout _deEsCertNav = NavLayout(
  groups: [
    NavGroup(
      id: 'a1_1',
      title: 'A1.1 · PRIMEROS PASOS',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsA1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a1_2',
      title: 'A1.2 · MI VIDA DIARIA',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsA1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a2_1',
      title: 'A2.1 · EXPERIENCIAS',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsA2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a2_2',
      title: 'A2.2 · DESCRIBIR Y COMPARAR',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsA2_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b1_1',
      title: 'B1.1 · OPINIONES Y DESEOS',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsB1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b1_2',
      title: 'B1.2 · RELATOS Y CONJETURAS',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsB1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b2',
      title: 'B2 · ARGUMENTAR Y MATIZAR',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deEsB2) NavItem(ref: c.id)],
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
  Course(
    id: 'de_es',
    name: 'Spanisch-Zertifikat A1–B2',
    tagline: 'Dein Schritt-für-Schritt-Weg zum Spanisch-Zertifikat',
    speakFlag: '🇩🇪',
    learnFlag: '🇪🇸',
    uiLang: UiLang.de,
    learnLocale: 'es-ES',
    nav: _deEsCertNav,
  ),
];
