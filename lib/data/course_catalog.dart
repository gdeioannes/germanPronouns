import '../models/course.dart';
import '../models/nav_layout.dart';

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

/// The id of the course shown by default.
const String kDefaultCourseId = 'de_cert_a1';

/// All built-in courses, used to seed the database and as a fallback.
final List<Course> defaultCourses = [
  Course(
    id: kDefaultCourseId,
    name: 'Certification German A1–C2',
    tagline: 'Your step-by-step path from A1 to the C2 certificate',
    speakFlag: '🇬🇧',
    learnFlag: '🇩🇪',
    uiLang: UiLang.en,
    goal: 'certification',
    level: 'A1–C2',
    nav: _certA1Nav,
  ),
];
