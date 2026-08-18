/// Build stamp for the running binary.
///
/// The values are injected at compile time by CI
/// (`--dart-define=BUILD_NUMBER=… --dart-define=BUILD_TIME=… --dart-define=BUILD_COMMIT=…`),
/// so nobody has to remember to bump anything by hand: every deploy of the web
/// app carries the run number, the UTC timestamp of the build and the commit it
/// was built from. Local `flutter run` builds have no defines and fall back to
/// "dev", which is exactly how they should read.
///
/// Deliberately Flutter-free so plain `dart run` scripts can share it.
library;

/// Marketing version, kept in sync with `pubspec.yaml`'s `version:` by CI
/// (which passes the value it read from the pubspec).
const String kAppVersion = String.fromEnvironment(
  'BUILD_VERSION',
  defaultValue: 'dev',
);

/// Monotonic build counter — the GitHub Actions run number for deployed builds.
const String kBuildNumber = String.fromEnvironment(
  'BUILD_NUMBER',
  defaultValue: '0',
);

/// ISO-8601 UTC timestamp of the build, e.g. `2026-08-18T09:14:03Z`.
const String kBuildTime = String.fromEnvironment('BUILD_TIME');

/// Short git SHA the build came from.
const String kBuildCommit = String.fromEnvironment('BUILD_COMMIT');

/// True when this binary was stamped by CI (as opposed to a local dev build).
bool get kIsStampedBuild => kBuildTime.isNotEmpty;

/// Human-readable version line, e.g. `1.0.1 (build 142)` or `dev build`.
String get buildVersionLabel =>
    kIsStampedBuild ? '$kAppVersion (build $kBuildNumber)' : 'dev build';

/// Human-readable "last updated" line: `18 Aug 2026, 09:14 UTC`.
///
/// Formatted by hand rather than via `intl` so this file stays dependency-free
/// and reads the same in every locale (the timestamp is a fact about the
/// deploy, not localised content).
String get buildTimeLabel {
  final stamp = DateTime.tryParse(kBuildTime);
  if (stamp == null) return 'not published yet';
  final utc = stamp.toUtc();
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final day = utc.day.toString().padLeft(2, '0');
  final hh = utc.hour.toString().padLeft(2, '0');
  final mm = utc.minute.toString().padLeft(2, '0');
  return '$day ${months[utc.month - 1]} ${utc.year}, $hh:$mm UTC';
}
