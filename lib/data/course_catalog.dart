import '../models/course.dart';
import '../models/nav_layout.dart';
import '../models/quiz_content.dart';
import 'courses/de_cs/de_cs_content.dart';
import 'courses/de_es/de_es_content.dart';
import 'courses/en_de/en_de_content.dart';
import 'courses/en_zh/en_zh_content.dart';
import 'courses/es_de/es_de_content.dart';
import 'courses/zh_en/zh_en_content.dart';

/// Navigation links shared by the English courses (word reference, settings,
/// how-it-works, course switcher).
const List<NavItem> _enMoreLinks = [
  NavItem(ref: kWordLibraryRef),
  NavItem(ref: kSettingsRef),
  NavItem(ref: kHowItWorksRef),
  NavItem(ref: kCoursesRef),
];

/// The "Certification German A1–C2" drawer: the full Goethe-ladder Quest chain
/// split into its twelve CEFR sub-levels (A1.1 … C2.2), plus links. The chain
/// stays globally continuous — each sub-level only unlocks once every quiz in
/// the preceding ones is complete.
final NavLayout _certA1Nav = NavLayout(
  groups: const [
    NavGroup(
      id: 'quest_a1_1',
      title: 'A1.1 · ERSTE SCHRITTE',
      type: NavGroupType.questChain,
      level: 'A1.1',
    ),
    NavGroup(
      id: 'quest_a1_2',
      title: 'A1.2 · IM ALLTAG',
      type: NavGroupType.questChain,
      level: 'A1.2',
    ),
    NavGroup(
      id: 'quest_a2_1',
      title: 'A2.1 · ERLEBNISSE',
      type: NavGroupType.questChain,
      level: 'A2.1',
    ),
    NavGroup(
      id: 'quest_a2_2',
      title: 'A2.2 · BESCHREIBEN & PLANEN',
      type: NavGroupType.questChain,
      level: 'A2.2',
    ),
    NavGroup(
      id: 'quest_b1_1',
      title: 'B1.1 · MEINUNGEN & WÜNSCHE',
      type: NavGroupType.questChain,
      level: 'B1.1',
    ),
    NavGroup(
      id: 'quest_b1_2',
      title: 'B1.2 · ERZÄHLEN & BEGRÜNDEN',
      type: NavGroupType.questChain,
      level: 'B1.2',
    ),
    NavGroup(
      id: 'quest_b2_1',
      title: 'B2.1 · ARGUMENTIEREN',
      type: NavGroupType.questChain,
      level: 'B2.1',
    ),
    NavGroup(
      id: 'quest_b2_2',
      title: 'B2.2 · DIFFERENZIEREN',
      type: NavGroupType.questChain,
      level: 'B2.2',
    ),
    NavGroup(
      id: 'quest_c1_1',
      title: 'C1.1 · ABSTRAHIEREN',
      type: NavGroupType.questChain,
      level: 'C1.1',
    ),
    NavGroup(
      id: 'quest_c1_2',
      title: 'C1.2 · NUANCIEREN',
      type: NavGroupType.questChain,
      level: 'C1.2',
    ),
    NavGroup(
      id: 'quest_c2_1',
      title: 'C2.1 · STILSICHERHEIT',
      type: NavGroupType.questChain,
      level: 'C2.1',
    ),
    NavGroup(
      id: 'quest_c2_2',
      title: 'C2.2 · MEISTERSCHAFT',
      type: NavGroupType.questChain,
      level: 'C2.2',
    ),
    NavGroup(
      id: 'more',
      title: 'MORE',
      type: NavGroupType.links,
      items: _enMoreLinks,
    ),
  ],
);

/// One drawer group for a grammar quest, its tiles built from the quest's
/// quiz list so the menu never drifts from the content.
NavGroup _enQuest(String id, String title, List<QuizContent> quizzes) =>
    NavGroup(
      id: id,
      title: title,
      type: NavGroupType.quizzes,
      items: [for (final c in quizzes) NavItem(ref: c.id)],
    );

/// The "German Grammar in Detail" drawer: the step-by-step quests (Quest 1 →
/// Quest 17, A1 → B2), then the four original reference quizzes, the noun
/// categories, and links. Quests are ungated for now so every quiz is open to
/// practise in any order; give a group `gated: true` to turn it into a
/// pass-to-unlock chain.
final NavLayout _grammarNav = NavLayout(
  groups: [
    _enQuest('m1', 'QUEST 1 · PRESENT TENSE & WORD ORDER', enDeM1),
    _enQuest('m2', 'QUEST 2 · GENDER & THE NOMINATIVE', enDeM2),
    _enQuest('m3', 'QUEST 3 · THE ACCUSATIVE', enDeM3),
    _enQuest('m4', 'QUEST 4 · THE DATIVE', enDeM4),
    _enQuest('m5', 'QUEST 5 · PUTTING THE CASES TOGETHER', enDeM5),
    _enQuest('m6', 'QUEST 6 · TWO-WAY PREPOSITIONS', enDeM6),
    _enQuest('m7', 'QUEST 7 · ADJECTIVE ENDINGS', enDeM7),
    _enQuest('m8', 'QUEST 8 · THE PERFEKT', enDeM8),
    _enQuest('m9', 'QUEST 9 · MODAL & SEPARABLE VERBS', enDeM9),
    _enQuest('m10', 'QUEST 10 · COMPARISONS', enDeM10),
    _enQuest('m11', 'QUEST 11 · CONNECTING SENTENCES', enDeM11),
    _enQuest('m12', 'QUEST 12 · FULL ADJECTIVE DECLENSION', enDeM12),
    _enQuest('m13', 'QUEST 13 · GENITIVE & PRÄTERITUM', enDeM13),
    _enQuest('m14', 'QUEST 14 · RELATIVE CLAUSES', enDeM14),
    _enQuest('m15', 'QUEST 15 · KONJUNKTIV II & REFLEXIVE', enDeM15),
    _enQuest('m16', 'QUEST 16 · THE PASSIVE', enDeM16),
    _enQuest('m17', 'QUEST 17 · INDIRECT SPEECH', enDeM17),
    const NavGroup(
      id: 'quizzes',
      title: 'REFERENCE QUIZZES',
      type: NavGroupType.quizzes,
      items: [
        NavItem(ref: 'article'),
        NavItem(ref: 'pronoun'),
        NavItem(ref: 'pronoun_article'),
        NavItem(ref: 'preposition'),
      ],
    ),
    const NavGroup(
      id: 'nouns',
      title: 'NOUN CATEGORIES',
      type: NavGroupType.nounChain,
    ),
    const NavGroup(
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

/// The "Tschechisch entdecken" drawer (Deutsch → Tschechisch): three gated
/// module groups (Erste Klänge, Ich & die anderen, Aspekt) in chain order, plus
/// links. A deep but short introductory taster, so the whole sequence is one
/// continuous pass-to-unlock chain.
final NavLayout _deCsNav = NavLayout(
  groups: [
    NavGroup(
      id: 'm1',
      title: 'MODUL 1 · ERSTE KLÄNGE',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deCsM1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'm2',
      title: 'MODUL 2 · ICH & DIE ANDEREN',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deCsM2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'm3',
      title: 'MODUL 3 · DER ASPEKT',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in deCsM3) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'more',
      title: 'MEHR',
      type: NavGroupType.links,
      items: [
        NavItem(ref: kSettingsRef),
        NavItem(ref: kHowItWorksRef),
        NavItem(ref: kCoursesRef),
      ],
    ),
  ],
);

/// The "英语认证 A1–C2" drawer (Mandarin → English): the CEFR sub-level groups in
/// chain order, plus links. Each level group is [NavGroup.gated], so the whole
/// sequence is one continuous pass-to-unlock chain. Modules A1.2 … C2.2 are
/// added here as they are authored (see `docs/zh_en_certification_plan.md`).
final NavLayout _zhEnCertNav = NavLayout(
  groups: [
    NavGroup(
      id: 'a1_1',
      title: 'A1.1 · 初次接触',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnA1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a1_2',
      title: 'A1.2 · 日常生活',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnA1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a2_1',
      title: 'A2.1 · 过去与经历',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnA2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a2_2',
      title: 'A2.2 · 计划与数量',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnA2_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b1_1',
      title: 'B1.1 · 经历与联系',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnB1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b1_2',
      title: 'B1.2 · 叙述与条件',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnB1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b2_1',
      title: 'B2.1 · 观点与假设',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnB2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b2_2',
      title: 'B2.2 · 转述与细节',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnB2_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c1_1',
      title: 'C1.1 · 抽象与精确',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnC1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c1_2',
      title: 'C1.2 · 语体与修辞',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnC1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c2_1',
      title: 'C2.1 · 风格驾驭',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnC2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c2_2',
      title: 'C2.2 · 精通',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in zhEnC2_2) NavItem(ref: c.id)],
    ),
    const NavGroup(
      id: 'more',
      title: '更多',
      type: NavGroupType.links,
      items: [
        NavItem(ref: kSettingsRef),
        NavItem(ref: kHowItWorksRef),
        NavItem(ref: kCoursesRef),
      ],
    ),
  ],
);

/// The "Certification Chinese · HSK" drawer (English → Mandarin): the twelve
/// CEFR sub-level groups (A1.1 … C2.2) in chain order, each mapped to its HSK
/// band, plus links. Each level group is [NavGroup.gated], so the whole
/// sequence is one continuous pass-to-unlock chain. See
/// `docs/en_zh_certification_plan.md`.
final NavLayout _enZhCertNav = NavLayout(
  groups: [
    NavGroup(
      id: 'a1_1',
      title: 'A1.1 · FIRST SOUNDS & TONES',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhA1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a1_2',
      title: 'A1.2 · PEOPLE & THINGS',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhA1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a2_1',
      title: 'A2.1 · TIME & DAILY LIFE',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhA2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'a2_2',
      title: 'A2.2 · DONE & EXPERIENCED',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhA2_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b1_1',
      title: 'B1.1 · RESULTS & DIRECTIONS',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhB1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b1_2',
      title: 'B1.2 · DESCRIBING & DEFINING',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhB1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b2_1',
      title: 'B2.1 · HANDLING & BEING HANDLED',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhB2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'b2_2',
      title: 'B2.2 · ATTITUDE & FLOW',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhB2_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c1_1',
      title: 'C1.1 · PRECISION & NUANCE',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhC1_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c1_2',
      title: 'C1.2 · THE WRITTEN REGISTER',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhC1_2) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c2_1',
      title: 'C2.1 · IDIOM & COLOR',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhC2_1) NavItem(ref: c.id)],
    ),
    NavGroup(
      id: 'c2_2',
      title: 'C2.2 · MASTERY',
      type: NavGroupType.quizzes,
      gated: true,
      items: [for (final c in enZhC2_2) NavItem(ref: c.id)],
    ),
    const NavGroup(
      id: 'more',
      title: 'MORE',
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
    name: 'Certification German A1–C2',
    tagline: 'Your step-by-step path from A1 to the C2 certificate',
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
  Course(
    id: 'de_cs',
    name: 'Tschechisch entdecken',
    tagline: 'Ein tiefer Einstieg ins Tschechische – für Sprachliebhaber',
    speakFlag: '🇩🇪',
    learnFlag: '🇨🇿',
    uiLang: UiLang.de,
    learnLocale: 'cs-CZ',
    nav: _deCsNav,
  ),
  Course(
    id: 'zh_en',
    name: '英语认证 A1–C2',
    tagline: '从零基础到精通，一步步考取英语证书',
    speakFlag: '🇨🇳',
    learnFlag: '🇬🇧',
    uiLang: UiLang.zh,
    learnLocale: 'en-GB',
    nav: _zhEnCertNav,
  ),
  Course(
    id: 'en_zh',
    name: 'Certification Chinese · HSK',
    tagline: 'From nǐ hǎo to HSK mastery — tones, characters and all',
    speakFlag: '🇬🇧',
    learnFlag: '🇨🇳',
    uiLang: UiLang.en,
    learnLocale: 'zh-CN',
    nav: _enZhCertNav,
  ),
];
