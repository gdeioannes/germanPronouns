/// Current version of the shipped/published quiz content.
///
/// It is stamped into the seed JSON as a top-level `"version"` field, so the
/// *data* carries its own version: republishing content can be as simple as
/// editing `assets/seed/quiz_content.json` (and bumping its `"version"`), no
/// code change required.
///
/// **Bump this whenever the seeded content changes** — new quizzes, edited
/// sentences, reordered chains, etc. On launch, an install whose stored version
/// differs from the published one is automatically re-seeded from the published
/// content, so learners get updates without a manual reset.
///
/// Use any dotted string (e.g. `"1.2.0"` / `"2.3.4"`); only equality is checked,
/// not ordering. Re-seeding replaces local back-office edits with the published
/// content; learner progress (in SharedPreferences) is not affected.
///
/// This constant is deliberately free of Flutter imports so the seed generator
/// (`tool/generate_seed.dart`, a plain `dart run` script) can share it.
const String kDataVersion = '1.4.0';
