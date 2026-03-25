import 'package:flutter/material.dart';

/// Travello AI - Luxury Dark + Gold Theme Palette
/// Exact colors as specified by user requirements
class ThemePalette {
  // ═══════════════════════════════════════════════════════════════
  // GOLD ACCENT (Primary)
  // ═══════════════════════════════════════════════════════════════

  /// Soft gold - primary brand accent
  static Color primaryMain = const Color(0xFFD4AF37);

  /// Muted gold variant
  static Color primaryLight = const Color(0xFFC6A75E);

  /// Deep gold
  static Color primaryDark = const Color(0xFFB8935C);

  // ═══════════════════════════════════════════════════════════════
  // WARM BEIGE (Secondary)
  // ═══════════════════════════════════════════════════════════════

  /// Warm beige for confirm buttons
  static Color secondaryMain = const Color(0xFFE6C68E);

  /// Light beige
  static Color secondaryLight = const Color(0xFFF5E6D3);

  /// Medium beige
  static Color secondaryDark = const Color(0xFFC6A75E);

  // ═══════════════════════════════════════════════════════════════
  // TERTIARY (Additional gold tones)
  // ═══════════════════════════════════════════════════════════════

  /// Gold accent
  static Color tertiaryMain = const Color(0xFFD4AF37);

  /// Light gold
  static Color tertiaryLight = const Color(0xFFE6C68E);

  /// Muted gold
  static Color tertiaryDark = const Color(0xFFC6A75E);

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUNDS (Dark/Black surfaces)
  // ═══════════════════════════════════════════════════════════════

  /// Cards and containers - dark grey
  static Color paperLight = const Color(0xFF1A1A1A);

  /// Main background - deep black
  static Color paperDark = const Color(0xFF0D0D0D);

  /// Input fields - dark grey
  static Color defaultLight = const Color(0xFF1C1C1E);

  /// Scaffold background - soft black
  static Color defaultDark = const Color(0xFF111111);

  // ═══════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Primary white text
  static Color textPrimary = const Color(0xFFFFFFFF);

  /// Secondary grey text
  static Color textSecondary = const Color(0xFFB3B3B3);

  /// Muted grey text
  static Color textMuted = const Color(0xFF808080);

  /// Disabled text
  static Color textDisabled = const Color(0xFF4D4D4D);

  // ═══════════════════════════════════════════════════════════════
  // PREMIUM GRADIENTS
  // ═══════════════════════════════════════════════════════════════

  static LinearGradient gradientMixedLight = const LinearGradient(
    colors: [Color(0xFFE6C68E), Color(0xFFD4AF37), Color(0xFFC6A75E)],
  );

  static LinearGradient gradientMixedMain = const LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFC6A75E)],
  );

  static LinearGradient gradientMixedDark = const LinearGradient(
    colors: [Color(0xFFC6A75E), Color(0xFFB8935C)],
  );

  static LinearGradient gradientPrimaryLight = const LinearGradient(
    colors: [Color(0xFFE6C68E), Color(0xFFD4AF37)],
  );

  static LinearGradient gradientPrimaryDark = const LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFC6A75E)],
  );

  static LinearGradient gradientSecondaryLight = const LinearGradient(
    colors: [Color(0xFFF5E6D3), Color(0xFFE6C68E)],
  );

  static LinearGradient gradientSecondaryDark = const LinearGradient(
    colors: [Color(0xFFE6C68E), Color(0xFFB8935C)],
  );
}

ColorScheme colorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight =
      hsl.withLightness((hsl.lightness + amount / 1.5).clamp(0.0, 1.0));

  return hslLight.toColor();
}
