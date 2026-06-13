import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Corner radius used for cards, panels, and other large surfaces.
const double kRadiusLarge = 12.0;

/// Corner radius used for buttons, chips, inputs, and other small controls.
const double kRadiusSmall = 8.0;

/// Deep ink-navy used as the primary brand color: confident and editorial,
/// like the cover of a well-made hardcover, rather than a tech-dashboard
/// blue.
const Color _kPrimaryNavy = Color(0xFF1F3A5F);

/// Warm terracotta, used sparingly as a secondary accent (selected chips,
/// highlights) so it doesn't compete with the navy primary or the
/// red/blue/green gender-color system.
const Color _kAccentTerracotta = Color(0xFFC9683B);

/// Warm "paper" neutrals for backgrounds and surfaces, replacing the cool
/// greys a default Material neutral palette would produce.
const Color _kPaper = Color(0xFFFFFFFF);
const Color _kPaperLow = Color(0xFFFAFAFA);
const Color _kPaperMid = Color(0xFFF5F5F5);
const Color _kPaperHigh = Color(0xFFEAEAEA);
const Color _kPaperHighest = Color(0xFFE0E0E0);
const Color _kInkText = Color(0xFF2A2A28);
const Color _kInkMuted = Color(0xFF6E6458);
const Color _kOutline = Color(0xFFD0D0D0);
const Color _kOutlineVariant = Color(0xFFE5E5E5);

/// Muted forest green and ochre, used alongside the navy primary and
/// terracotta secondary as a small rotating palette for circular icon
/// badges (drawer entries, panel headers) — a restrained nod to bold,
/// multi-color geometric layouts without tinting the rest of the UI.
const Color _kAccentForest = Color(0xFF3F5D45);
const Color _kAccentOchre = Color(0xFFA9802A);

/// Rotating accent colors for [IconBadge]s in the drawer and panel headers
/// (e.g. Help Memory, History, Analytics, Settings).
const List<Color> kSectionAccentColors = [
  _kPrimaryNavy,
  _kAccentTerracotta,
  _kAccentForest,
  _kAccentOchre,
];

/// A small circular colored badge for an icon, used in the drawer and panel
/// headers so each section reads as a distinct "stamp" against the warm
/// paper background.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}

/// App-wide visual identity: ink-navy on a warm paper background, a
/// terracotta accent used sparingly, and a serif/sans pairing (Source
/// Serif 4 for headings, Inter for body/UI text) for a calm, editorial,
/// "bookish" feel.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _kPrimaryNavy,
    brightness: Brightness.light,
  ).copyWith(
    primary: _kPrimaryNavy,
    onPrimary: Colors.white,
    secondary: _kAccentTerracotta,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFF3DED0),
    onSecondaryContainer: const Color(0xFF7A3A1C),
    surface: _kPaper,
    onSurface: _kInkText,
    onSurfaceVariant: _kInkMuted,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: _kPaperLow,
    surfaceContainer: _kPaperMid,
    surfaceContainerHigh: _kPaperHigh,
    surfaceContainerHighest: _kPaperHighest,
    outline: _kOutline,
    outlineVariant: _kOutlineVariant,
  );

  final serifTheme = GoogleFonts.sourceSerif4TextTheme();
  final textTheme = GoogleFonts.interTextTheme().copyWith(
    displayLarge: serifTheme.displayLarge,
    displayMedium: serifTheme.displayMedium,
    displaySmall: serifTheme.displaySmall,
    headlineLarge: serifTheme.headlineLarge,
    headlineMedium: serifTheme.headlineMedium,
    headlineSmall: serifTheme.headlineSmall,
    titleLarge: serifTheme.titleLarge,
    titleMedium: serifTheme.titleMedium,
    titleSmall: serifTheme.titleSmall,
  );

  final smallShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kRadiusSmall),
  );
  final largeShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kRadiusLarge),
    side: BorderSide(color: Colors.grey.shade400),
  );
  // Fully-rounded "pill" shape for primary/secondary action buttons, for a
  // bolder, more confident call-to-action than the small-radius rectangles
  // used for chips and inputs.
  const pillShape = StadiumBorder();
  const pillPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surfaceContainerLow,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: 72,
      titleTextStyle: GoogleFonts.sourceSerif4(
        textStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: largeShape,
    ),
    dialogTheme: DialogThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusLarge),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: largeShape,
      collapsedShape: largeShape,
      backgroundColor: colorScheme.surfaceContainerLow,
      collapsedBackgroundColor: colorScheme.surfaceContainerLow,
    ),
    chipTheme: ChipThemeData(
      shape: smallShape,
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.secondaryContainer,
      labelStyle: textTheme.labelLarge,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(shape: pillShape, padding: pillPadding),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: pillShape,
        padding: pillPadding,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(shape: pillShape, padding: pillPadding),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(shape: smallShape),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusSmall),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
  );
}
