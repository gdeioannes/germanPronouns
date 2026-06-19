/// The app's brand color palette as raw 0xAARRGGBB ints — the **single source
/// of truth** for color, shared by the on-screen theme (`app_theme.dart`, via
/// `Color(...)`) and the PDF theme (`pdf_theme.dart`, via
/// `PdfColor.fromInt(...)`). Change a value here and both the app and its PDFs
/// update together.
library;

/// Deep ink-navy — the primary brand color.
const int kBrandNavy = 0xFF1F3A5F;

/// Warm terracotta — secondary accent.
const int kBrandTerracotta = 0xFFC9683B;

/// Muted forest green and ochre — rotating badge accents.
const int kBrandForest = 0xFF3F5D45;
const int kBrandOchre = 0xFFA9802A;

/// Warm "paper" neutrals for backgrounds and surfaces.
const int kBrandPaper = 0xFFFFFFFF;
const int kBrandPaperLow = 0xFFFAFAFA;
const int kBrandPaperMid = 0xFFF5F5F5;
const int kBrandPaperHigh = 0xFFEAEAEA;
const int kBrandPaperHighest = 0xFFE0E0E0;

/// Ink text and muted text.
const int kBrandInkText = 0xFF2A2A28;
const int kBrandInkMuted = 0xFF6E6458;

/// Outline / divider tones.
const int kBrandOutline = 0xFFD0D0D0;
const int kBrandOutlineVariant = 0xFFE5E5E5;
