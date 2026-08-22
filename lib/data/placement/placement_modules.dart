import '../../models/course.dart';
import '../../models/nav_layout.dart';
import '../quest_data.dart';

/// One step of a course's locked progression — an A1.1 / A1.2 / … band, or a
/// named module in a course that doesn't use CEFR labels.
///
/// A module is derived from the course's navigation rather than parsed out of
/// level strings: a gated quizzes group *is* a module, and so is one level's
/// slice of the Quest chain. That keeps this working for courses whose bands
/// aren't CEFR at all (Deutsch → Tschechisch ships "Erste Klänge", "Aspekt")
/// without a second source of truth to keep in sync.
class PlacementModule {
  const PlacementModule({
    required this.id,
    required this.title,
    required this.quizRefs,
  });

  /// The nav group's id (e.g. `'a1_1'`). Stable across renames of [title].
  final String id;

  /// The group's display title, e.g. `'A1.1 · PRIMEROS PASOS'`.
  final String title;

  /// Every quiz in this module, in chain order. For a gated quizzes group these
  /// are `QuizContent.id`s; for a Quest slice they are Quest entry keys. Both
  /// are what the completion sets are keyed by, so they gate identically.
  final List<String> quizRefs;

  /// The short band label — the part before the '·' separator, so a home-page
  /// chip can read "A1.1" instead of "A1.1 · PRIMEROS PASOS".
  String get shortTitle {
    final head = title.split('·').first.trim();
    return head.isEmpty ? title : head;
  }
}

/// The locked progression of [course], in order, or an empty list for a course
/// with nothing to place into.
///
/// Only *gated* groups count: an ungated group is already open, so placing a
/// learner past it would mean nothing. A course with fewer than two modules
/// can't be placed either — there is only one place to be.
List<PlacementModule> placementModules(Course course) {
  final modules = <PlacementModule>[];
  for (final group in course.nav.groups) {
    switch (group.type) {
      case NavGroupType.quizzes:
        if (!group.gated) continue;
        final refs = [
          for (final item in group.items)
            if (!item.hidden) item.ref,
        ];
        if (refs.isNotEmpty) {
          modules.add(
            PlacementModule(id: group.id, title: group.title, quizRefs: refs),
          );
        }
      case NavGroupType.questChain:
        // The Quest chain is gated by construction (a sub-level opens only once
        // every earlier one is finished), so each of a course's per-level quest
        // groups is a module.
        final level = group.level;
        final refs = [
          for (final e in questEntries)
            if (level == null || e.levelLabel == level) e.key,
        ];
        if (refs.isNotEmpty) {
          modules.add(
            PlacementModule(id: group.id, title: group.title, quizRefs: refs),
          );
        }
      case NavGroupType.nounChain:
      case NavGroupType.links:
        break;
    }
  }
  return modules.length < 2 ? const [] : modules;
}

/// Whether [course] has a locked progression a learner could be placed into.
bool supportsPlacement(Course course) => placementModules(course).isNotEmpty;

/// Every quiz that must be opened to start the course *at* [moduleIndex]:
/// all of the modules before it.
///
/// The placed module itself is deliberately excluded. Its first quiz opens
/// anyway (the gate only asks that everything before it is cleared), so the
/// learner lands exactly at the start of their level with the rest of it still
/// to earn.
Set<String> refsUnlockedUpTo(List<PlacementModule> modules, int moduleIndex) => {
  for (var i = 0; i < moduleIndex && i < modules.length; i++)
    ...modules[i].quizRefs,
};
