import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/course_progress.dart';
import '../data/quest_data.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../widgets/country_flag.dart';
import '../widgets/course_tile.dart';

/// Display metadata for a language, keyed by its ISO code.
///
/// [endonym] is the language's own name — shown in the "I speak" chips so every
/// learner recognizes theirs regardless of the current UI language. [names] is
/// the language's name localized into each UI language — shown in the "I want to
/// learn" chips, which only appear after a spoken language (and therefore a UI
/// language) has been picked.
class _LangInfo {
  const _LangInfo(this.flag, this.endonym, this.names);

  final String flag;
  final String endonym;
  final Map<UiLang, String> names;
}

const Map<String, _LangInfo> _langInfo = {
  'en': _LangInfo('🇬🇧', 'English', {
    UiLang.en: 'English',
    UiLang.es: 'Inglés',
    UiLang.de: 'Englisch',
  }),
  'es': _LangInfo('🇪🇸', 'Español', {
    UiLang.en: 'Spanish',
    UiLang.es: 'Español',
    UiLang.de: 'Spanisch',
  }),
  'de': _LangInfo('🇩🇪', 'Deutsch', {
    UiLang.en: 'German',
    UiLang.es: 'Alemán',
    UiLang.de: 'Deutsch',
  }),
  'cs': _LangInfo('🇨🇿', 'Čeština', {
    UiLang.en: 'Czech',
    UiLang.es: 'Checo',
    UiLang.de: 'Tschechisch',
  }),
};

// Localized chrome for the finder. Until a spoken language is chosen we don't
// know the learner's language, so the title falls back to a trilingual form.
const Map<UiLang, String> _titleText = {
  UiLang.en: 'Find your course',
  UiLang.es: 'Encuentra tu curso',
  UiLang.de: 'Finde deinen Kurs',
};
const Map<UiLang, String> _speakText = {
  UiLang.en: 'I speak',
  UiLang.es: 'Hablo',
  UiLang.de: 'Ich spreche',
};
const Map<UiLang, String> _learnText = {
  UiLang.en: 'I want to learn',
  UiLang.es: 'Quiero aprender',
  UiLang.de: 'Ich möchte lernen',
};
const Map<UiLang, String> _coursesText = {
  UiLang.en: 'Courses for you',
  UiLang.es: 'Cursos para ti',
  UiLang.de: 'Kurse für dich',
};
const Map<UiLang, String> _yourCoursesText = {
  UiLang.en: 'Your courses',
  UiLang.es: 'Tus cursos',
  UiLang.de: 'Deine Kurse',
};
const Map<UiLang, String> _myCoursesText = {
  UiLang.en: 'All my courses',
  UiLang.es: 'Todos mis cursos',
  UiLang.de: 'Alle meine Kurse',
};
const Map<UiLang, String> _allText = {
  UiLang.en: 'All',
  UiLang.es: 'Todos',
  UiLang.de: 'Alle',
};
const Map<UiLang, String> _noMatchText = {
  UiLang.en: 'No courses for this pair yet.',
  UiLang.es: 'Aún no hay cursos para esta combinación.',
  UiLang.de: 'Noch keine Kurse für diese Kombination.',
};
const Map<UiLang, String> _goalText = {
  UiLang.en: 'My goal',
  UiLang.es: 'Mi objetivo',
  UiLang.de: 'Mein Ziel',
};

// Short prefixes for the one-line filter dropdowns ("Learn: All ▾").
const Map<UiLang, String> _speakShortText = {
  UiLang.en: 'Language',
  UiLang.es: 'Idioma',
  UiLang.de: 'Sprache',
};
const Map<UiLang, String> _learnShortText = {
  UiLang.en: 'Learn',
  UiLang.es: 'Aprender',
  UiLang.de: 'Lernen',
};
const Map<UiLang, String> _goalShortText = {
  UiLang.en: 'Goal',
  UiLang.es: 'Meta',
  UiLang.de: 'Ziel',
};

/// Canonical course-goal keys (see [Course.goal]) in display order, each with
/// an icon and localized chip label. A goal key outside this list still works —
/// it falls back to a flag icon and its raw key as the label.
const List<String> _goalOrder = [
  'certification',
  'grammar',
  'vocabulary',
  'discover',
];
const Map<String, IconData> _goalIcons = {
  'certification': Icons.workspace_premium_rounded,
  'grammar': Icons.menu_book_rounded,
  'vocabulary': Icons.style_rounded,
  'discover': Icons.explore_rounded,
};
const Map<String, Map<UiLang, String>> _goalLabels = {
  'certification': {
    UiLang.en: 'Certificate',
    UiLang.es: 'Certificado',
    UiLang.de: 'Zertifikat',
  },
  'grammar': {
    UiLang.en: 'Grammar',
    UiLang.es: 'Gramática',
    UiLang.de: 'Grammatik',
  },
  'vocabulary': {
    UiLang.en: 'Vocabulary',
    UiLang.es: 'Vocabulario',
    UiLang.de: 'Wortschatz',
  },
  'discover': {
    UiLang.en: 'Discover',
    UiLang.es: 'Descubrir',
    UiLang.de: 'Entdecken',
  },
};

/// The spoken language of a course (drives the UI language too).
String _speakCodeOf(Course c) => c.uiLang.name;

/// The language a course teaches, from its BCP-47 learn locale (e.g. `es-ES` →
/// `es`, `cs-CZ` → `cs`).
String _learnCodeOf(Course c) => c.learnLocale.split('-').first;

UiLang _uiLangForCode(String code) =>
    UiLang.values.firstWhere((l) => l.name == code, orElse: () => UiLang.en);

/// Joins a label's three translations for the pre-selection state, e.g.
/// "I speak · Hablo · Ich spreche".
String _tri(Map<UiLang, String> m) =>
    '${m[UiLang.en]}  ·  ${m[UiLang.es]}  ·  ${m[UiLang.de]}';

/// Lets the learner find a language-pair course by answering two questions —
/// "which language do you speak?" and "which do you want to learn?" — instead of
/// scanning a flat list. The matching courses appear (and narrow) live as the
/// answers are chosen, so the picker scales as more courses are added.
///
/// Shown on first launch and reachable later via the "Switch course" menu entry;
/// returning learners land with their spoken language already selected.
class CourseSelectorPage extends StatefulWidget {
  const CourseSelectorPage({super.key});

  @override
  State<CourseSelectorPage> createState() => _CourseSelectorPageState();
}

class _CourseSelectorPageState extends State<CourseSelectorPage> {
  /// The single language the learner speaks (it drives the UI language, so it
  /// can't be a multi-select). Kept as a one-element set so the filter and
  /// signature code reads the same as the learn/goal selections; empty only
  /// until the very first pick.
  final Set<String> _speakSel = {};

  /// ISO codes of the target languages to show — a multi-select filter; empty
  /// means "all targets" for the selected spoken language.
  final Set<String> _learnSel = {};

  /// Goal keys (see [Course.goal]) to show — a multi-select filter; empty
  /// means "all goals". Pruned whenever the language answers narrow the
  /// available goals.
  final Set<String> _goalSel = {};

  /// Stable signature of the current filter answers, used to re-key the
  /// result cards so a filter change replays their entrance.
  String get _filterSig {
    final s = _speakSel.toList()..sort();
    final l = _learnSel.toList()..sort();
    final g = _goalSel.toList()..sort();
    return '${s.join('+')}-${l.join('+')}-${g.join('+')}';
  }

  /// Per-course progress summaries for the started courses, loaded async —
  /// cards render immediately and grow their stats line once this arrives.
  Map<String, CourseProgress> _progress = const {};

  @override
  void initState() {
    super.initState();
    // Returning learners (reached via "Switch course") start on the language
    // they already speak, so their courses are shown without re-picking.
    final activeId = CourseSession.instance.activeCourseId;
    if (activeId != null) {
      for (final c in CourseSession.instance.courses) {
        if (c.id == activeId) {
          _speakSel.add(_speakCodeOf(c));
          break;
        }
      }
    }
    _loadProgress();
    // Stay current when the session changes underneath — e.g. a course was
    // archived or deleted on the My Courses page pushed on top of this one.
    CourseSession.instance.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    CourseSession.instance.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadProgress() async {
    final ids = CourseSession.instance.startedCourseIds;
    if (ids.isEmpty) return;
    final startedCourses = [
      for (final c in CourseSession.instance.courses)
        if (ids.contains(c.id)) c,
    ];
    final progress = await loadCourseProgress(startedCourses);
    if (mounted) setState(() => _progress = progress);
  }

  Future<void> _pick(Course course) async {
    await CourseSession.instance.setActiveCourse(course.id);
    // Apply this course's Quest chain order (no-op for courses without one).
    applyQuestOrderFromLayout(course.nav);
    if (!mounted) return;
    context.go('/home');
  }

  void _selectSpeak(String code) => setState(() {
    _speakSel
      ..clear()
      ..add(code);
    _pruneSelections();
  });

  /// Toggles [code] in a multi-select whose *empty* set means "everything"
  /// (displayed with every option ticked). Unticking from the all-state keeps
  /// the rest ticked; re-ticking the full set collapses back to "all"; the
  /// last ticked option can't be removed.
  void _toggleAllStyle(Set<String> sel, String code, List<String> allCodes) {
    if (sel.isEmpty) {
      sel
        ..addAll(allCodes)
        ..remove(code);
    } else if (sel.contains(code)) {
      if (sel.length == 1) return;
      sel.remove(code);
    } else {
      sel.add(code);
    }
    if (sel.length == allCodes.length) sel.clear();
  }

  void _toggleLearn(String code, List<String> allCodes) => setState(() {
    _toggleAllStyle(_learnSel, code, allCodes);
    _pruneGoals();
  });

  void _toggleGoal(String code, List<String> allCodes) =>
      setState(() => _toggleAllStyle(_goalSel, code, allCodes));

  /// Drops learn/goal selections that no longer exist for the current spoken
  /// languages (an empty set already means "all", so it needs no pruning).
  void _pruneSelections() {
    final courses = CourseSession.instance.courses;
    final targets = <String>{
      for (final c in courses)
        if (_speakSel.contains(_speakCodeOf(c))) _learnCodeOf(c),
    };
    _learnSel.retainAll(targets);
    _pruneGoals();
  }

  /// Drops goal selections not on offer for the current language answers, so
  /// the results can't silently go empty.
  void _pruneGoals() {
    final courses = CourseSession.instance.courses;
    final goals = <String>{
      for (final c in courses)
        if (_speakSel.contains(_speakCodeOf(c)) &&
            (_learnSel.isEmpty || _learnSel.contains(_learnCodeOf(c))) &&
            c.goal != null)
          c.goal!,
    };
    _goalSel.retainAll(goals);
  }

  /// The checkbox icon for a multi-select menu item.
  Widget _checkbox(bool checked) => Icon(
    checked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
    size: 20,
  );

  /// The "I speak" dropdown: a labeled single-select — this answer drives the
  /// UI language, so exactly one language is chosen. Picking closes the menu.
  Widget _speakDropdown(UiLang uiLang, List<String> speakCodes) {
    final code = _speakSel.first;
    final info = _langInfo[code];
    return _FilterDropdown(
      tooltip: _speakText[uiLang]!,
      prefix: _speakShortText[uiLang]!,
      highlighted: true,
      leading: [if (info != null) CountryFlag(emoji: info.flag, size: 20)],
      value: info?.endonym ?? code,
      menuChildren: [
        for (final c in speakCodes)
          MenuItemButton(
            leadingIcon: CountryFlag(emoji: _langInfo[c]?.flag ?? '', size: 20),
            trailingIcon: _speakSel.contains(c)
                ? const Icon(Icons.check_rounded, size: 18)
                : null,
            onPressed: () => _selectSpeak(c),
            child: Text(_langInfo[c]?.endonym ?? c),
          ),
      ],
    );
  }

  /// The "I want to learn" dropdown: a multi-select over the available
  /// targets that *starts with everything ticked* (the empty set means "all"
  /// and displays as every checkbox on). Checkbox items keep the menu open
  /// for further picks.
  Widget _learnDropdown(UiLang uiLang, List<String> learnCodes) {
    final engaged = _learnSel.isNotEmpty;
    // What the pill shows: the ticked targets — or, in the all-state, "All"
    // (when there's a real choice) / the only target on offer by name.
    final shown = engaged
        ? [
            for (final c in learnCodes)
              if (_learnSel.contains(c)) c,
          ]
        : learnCodes.length == 1
        ? learnCodes
        : const <String>[];
    return _FilterDropdown(
      tooltip: _learnText[uiLang]!,
      prefix: _learnShortText[uiLang]!,
      highlighted: engaged,
      leading: [
        for (final code in shown)
          CountryFlag(emoji: _langInfo[code]?.flag ?? '', size: 20),
      ],
      value: shown.isEmpty
          ? _allText[uiLang]!
          : shown.length == 1
          ? (_langInfo[shown.first]?.names[uiLang] ?? shown.first)
          : '',
      menuChildren: [
        for (final code in learnCodes)
          MenuItemButton(
            closeOnActivate: false,
            leadingIcon: CountryFlag(
              emoji: _langInfo[code]?.flag ?? '',
              size: 20,
            ),
            trailingIcon: _checkbox(!engaged || _learnSel.contains(code)),
            onPressed: () => _toggleLearn(code, learnCodes),
            child: Text(_langInfo[code]?.names[uiLang] ?? code),
          ),
      ],
    );
  }

  /// The "My goal" dropdown: like the learn one — a multi-select over the
  /// goals on offer, starting with everything ticked.
  Widget _goalDropdown(UiLang uiLang, List<String> goalCodes) {
    final engaged = _goalSel.isNotEmpty;
    final selected = [
      for (final c in goalCodes)
        if (_goalSel.contains(c)) c,
    ];
    final colorScheme = Theme.of(context).colorScheme;
    final fg = engaged
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurface;
    return _FilterDropdown(
      tooltip: _goalText[uiLang]!,
      prefix: _goalShortText[uiLang]!,
      highlighted: engaged,
      leading: [
        for (final code in selected)
          Icon(_goalIcons[code] ?? Icons.flag_rounded, size: 18, color: fg),
      ],
      value: !engaged
          ? _allText[uiLang]!
          : selected.length == 1
          ? (_goalLabels[selected.first]?[uiLang] ?? selected.first)
          : '',
      menuChildren: [
        for (final code in goalCodes)
          MenuItemButton(
            closeOnActivate: false,
            leadingIcon: Icon(_goalIcons[code] ?? Icons.flag_rounded, size: 20),
            trailingIcon: _checkbox(!engaged || _goalSel.contains(code)),
            onPressed: () => _toggleGoal(code, goalCodes),
            child: Text(_goalLabels[code]?[uiLang] ?? code),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final courses = CourseSession.instance.courses;
    // The first ticked spoken language drives the UI language of the chrome.
    final uiLang = _speakSel.isEmpty ? null : _uiLangForCode(_speakSel.first);

    // Distinct spoken languages across the catalog, in catalog order.
    final speakCodes = <String>[];
    for (final c in courses) {
      final s = _speakCodeOf(c);
      if (!speakCodes.contains(s)) speakCodes.add(s);
    }

    // Target languages available for the chosen spoken languages.
    final learnCodes = <String>[];
    for (final c in courses) {
      if (!_speakSel.contains(_speakCodeOf(c))) continue;
      final l = _learnCodeOf(c);
      if (!learnCodes.contains(l)) learnCodes.add(l);
    }

    // Goals available among the courses matching the language answers, in
    // canonical order (unknown future keys go last). The goal question is only
    // asked when there's an actual choice to make.
    final goalCodes = <String>[];
    if (_speakSel.isNotEmpty) {
      final available = <String>{
        for (final c in courses)
          if (_speakSel.contains(_speakCodeOf(c)) &&
              (_learnSel.isEmpty || _learnSel.contains(_learnCodeOf(c))) &&
              c.goal != null)
            c.goal!,
      };
      for (final g in _goalOrder) {
        if (available.remove(g)) goalCodes.add(g);
      }
      goalCodes.addAll(available);
    }

    final matches = _speakSel.isEmpty
        ? const <Course>[]
        : courses
              .where(
                (c) =>
                    _speakSel.contains(_speakCodeOf(c)) &&
                    (_learnSel.isEmpty ||
                        _learnSel.contains(_learnCodeOf(c))) &&
                    (_goalSel.isEmpty ||
                        (c.goal != null && _goalSel.contains(c.goal))),
              )
              .toList();

    // The learner's most recent non-archived course — a single "jump back in"
    // shortcut above the finder, independent of the language filters. The full
    // courses-taken list (switch / archive / delete) lives on the My Courses
    // page, linked right below it. Empty on first run.
    final session = CourseSession.instance;
    final activeId = session.activeCourseId;
    Course? recent;
    for (final id in session.startedCourseIds) {
      if (session.isArchived(id)) continue;
      for (final c in courses) {
        if (c.id == id) {
          recent = c;
          break;
        }
      }
      if (recent != null) break;
    }
    final startedCount = session.startedCourseIds.length;

    // Reached from "Switch course" (a course is already active): offer a way
    // back out without switching. First-run learners have nowhere to go back
    // to, so no button is shown.
    final canDismiss = CourseSession.instance.hasChosenCourse;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  children: [
                    // ── Title ────────────────────────────────────────────────
                    _Enter(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/QuizLogo-02.svg',
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            uiLang == null
                                ? _titleText[UiLang.en]!
                                : _titleText[uiLang]!,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (uiLang == null) ...[
                            const SizedBox(height: 6),
                            Text(
                              '${_titleText[UiLang.es]} · ${_titleText[UiLang.de]}',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Your courses (already started) ───────────────────────
                    // One "jump back in" card for the most recent course; the
                    // full courses-taken list (switch / archive / delete)
                    // lives on the My Courses page, linked right below.
                    if (recent != null) ...[
                      _Enter(
                        delayMs: 40,
                        child: _SectionLabel(
                          uiLang == null
                              ? _tri(_yourCoursesText)
                              : _yourCoursesText[uiLang]!,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Enter(
                        delayMs: 80,
                        child: CourseTile(
                          course: recent,
                          active: recent.id == activeId,
                          progress: _progress[recent.id],
                          onTap: () => _pick(recent!),
                        ),
                      ),
                      if (startedCount > 1)
                        _Enter(
                          delayMs: 120,
                          child: TextButton.icon(
                            onPressed: () => context.push('/my-courses'),
                            icon: const Icon(
                              Icons.collections_bookmark_rounded,
                              size: 18,
                            ),
                            label: Text(
                              '${uiLang == null ? _myCoursesText[UiLang.en]! : _myCoursesText[uiLang]!}'
                              ' ($startedCount)',
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],

                    // ── Filters ──────────────────────────────────────────────
                    // First run: the "I speak" question as labeled flag chips,
                    // self-evident in all three languages. Once answered, the
                    // three questions collapse into one line of dropdowns —
                    // speak (single-select), learn + goal (multi-select).
                    if (uiLang == null)
                      _Enter(
                        delayMs: 80,
                        child: _FilterRow(
                          label: _tri(_speakText),
                          chips: [
                            for (final code in speakCodes)
                              _LangChip(
                                flag: _langInfo[code]?.flag,
                                label: _langInfo[code]?.endonym ?? code,
                                selected: _speakSel.contains(code),
                                onTap: () => _selectSpeak(code),
                              ),
                          ],
                        ),
                      )
                    else
                      _Enter(
                        // A stable key: re-keying per selection would replace
                        // the MenuAnchors and slam an open menu shut mid
                        // multi-select.
                        key: const ValueKey('filters'),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _speakDropdown(uiLang, speakCodes),
                            if (learnCodes.isNotEmpty)
                              _learnDropdown(uiLang, learnCodes),
                            if (goalCodes.length > 1)
                              _goalDropdown(uiLang, goalCodes),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ── Matching courses ─────────────────────────────────────
                    if (uiLang != null) ...[
                      _Enter(
                        key: const ValueKey('courses-label'),
                        delayMs: 60,
                        child: _SectionLabel(_coursesText[uiLang]!),
                      ),
                      const SizedBox(height: 12),
                      if (matches.isEmpty)
                        _Enter(
                          key: ValueKey('no-match-$_filterSig'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              _noMatchText[uiLang]!,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        // Re-keyed per filter state so refining the answers softly
                        // fades the results in again, with a slight stagger.
                        for (final (i, course) in matches.indexed) ...[
                          _Enter(
                            key: ValueKey('card-${course.id}-$_filterSig'),
                            delayMs: 90 + 50 * i,
                            child: CourseTile(
                              course: course,
                              active: course.id == activeId,
                              progress: _progress[course.id],
                              onTap: () => _pick(course),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                    ],
                  ],
                ),
              ),
            ),
            if (canDismiss)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  icon: const Icon(Icons.close_rounded),
                  tooltip: CourseSession.instance.strings.close,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Fades its child in with a slight upward drift as it enters the tree — the
/// page's single, deliberately minimal entrance effect. [delayMs] staggers
/// siblings, and giving an instance a new [Key] replays the effect (used when
/// the filters change the results). Renders statically when the platform asks
/// for reduced motion.
class _Enter extends StatefulWidget {
  const _Enter({super.key, this.delayMs = 0, required this.child});

  final int delayMs;
  final Widget child;

  @override
  State<_Enter> createState() => _EnterState();
}

class _EnterState extends State<_Enter> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final CurvedAnimation _eased = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delayMs <= 0) {
      _controller.forward();
    } else {
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _eased.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _eased,
      builder: (context, child) => Opacity(
        opacity: _eased.value,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - _eased.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// A compact dropdown pill for one finder question: an optional muted prefix
/// ("Learn:"), the current value (flag/icon widgets + text), and a caret that
/// opens the option menu. Filled with the terracotta accent while the filter
/// is engaged, matching the selection chips — this is what lets all three
/// questions share a single line.
class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    this.prefix,
    this.tooltip,
    this.leading = const [],
    required this.value,
    required this.menuChildren,
    this.highlighted = false,
  });

  final String? prefix;
  final String? tooltip;
  final List<Widget> leading;
  final String value;
  final List<Widget> menuChildren;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bg = highlighted ? cs.secondaryContainer : cs.surface;
    final fg = highlighted ? cs.onSecondaryContainer : cs.onSurface;
    final border = highlighted ? cs.secondary : cs.outlineVariant;

    return MenuAnchor(
      menuChildren: menuChildren,
      builder: (context, controller, child) {
        Widget pill = Material(
          color: bg,
          shape: StadiumBorder(
            side: BorderSide(color: border, width: highlighted ? 1.5 : 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 4, 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefix != null) ...[
                    Text(
                      prefix!,
                      style: textTheme.labelLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  for (final w in leading) ...[w, const SizedBox(width: 5)],
                  if (value.isNotEmpty)
                    Text(
                      value,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  Icon(Icons.arrow_drop_down_rounded, color: fg),
                ],
              ),
            ),
          ),
        );
        if (tooltip != null) pill = Tooltip(message: tooltip!, child: pill);
        return pill;
      },
    );
  }
}

/// One compact finder question: its label inline with the answer chips, all in
/// a single centered wrap — the label reads as a prefix, and on narrow screens
/// the chips flow underneath it. Keeps the three questions to roughly one line
/// each instead of a heading + chip row per question.
class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.chips});

  final String label;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: _SectionLabel(label),
        ),
        ...chips,
      ],
    );
  }
}

/// A small uppercase-weight section heading ("I speak", "Courses for you", …).
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: textTheme.labelLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
      ),
    );
  }
}

/// A selectable pill for a language: its circular flag beside its label,
/// filled with the terracotta accent when selected. Used for the first-run
/// "I speak" question (afterwards the filters render as [_FilterDropdown]s).
class _LangChip extends StatelessWidget {
  const _LangChip({
    this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String? flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bg = selected ? cs.secondaryContainer : cs.surface;
    final fg = selected ? cs.onSecondaryContainer : cs.onSurface;
    final border = selected ? cs.secondary : cs.outlineVariant;

    return Material(
      color: bg,
      shape: StadiumBorder(
        side: BorderSide(color: border, width: selected ? 1.5 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 12, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (flag != null)
                CountryFlag(emoji: flag!, size: 20, ringColor: bg),
              const SizedBox(width: 7),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
