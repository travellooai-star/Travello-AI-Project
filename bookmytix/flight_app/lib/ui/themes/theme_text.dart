import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';

const String appFont = 'Ubuntu';

class ThemeText {
  // ═══════════════════════════════════════════════════════════════
  // BASIC TEXT STYLES
  // ═══════════════════════════════════════════════════════════════

  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle headline = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle paragraph = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle paragraphBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark text for light theme
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: appFont,
    color: Color(0xFFB3B3B3), // Light grey for captions
  );

  // ═══════════════════════════════════════════════════════════════
  // BOOKING SCREEN HEADINGS (Flight & Train Consistency)
  // ═══════════════════════════════════════════════════════════════

  /// Section headings - "Departure", "Return" (Gold)
  /// Use: Flight facilities, Train facilities, Checkout screens
  static const TextStyle sectionHeading = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    fontFamily: appFont,
    color: Color(0xFFD4AF37), // Gold - matches theme
    letterSpacing: 0.3,
  );

  /// Card route headings - "KHI-LHE", "Karachi-Lahore" (Dark grey on white cards)
  /// Use: Inside flight/train detail cards
  static const TextStyle cardHeading = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    fontFamily: appFont,
    color: Color(0xFF1A1A1A), // Dark grey for visibility on white
  );

  /// Duration/Info badge text (Light grey for secondary info)
  /// Use: "Non-Stop - Duration: 1h 25m", "Direct - Duration: 2h 30m"
  static const TextStyle durationBadge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontFamily: appFont,
    color: Color(0xFFB3B3B3), // Light grey
  );

  /// Journey label badges - "OUTBOUND FLIGHT", "RETURN"
  /// Use: Journey type indicators
  static const TextStyle journeyLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: appFont,
    color: Color(0xFF1976D2), // Blue for emphasis
  );

  /// Select seat labels - consistent across modules
  static const TextStyle selectSeatHeading = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    fontFamily: appFont,
    color: Color(0xFFD4AF37), // Gold
    letterSpacing: 0.3,
  );
}

class ThemeTextColor {
  static final bool _isDark = Get.isDarkMode;

  static TextStyle primary = TextStyle(color: ThemePalette.primaryMain);
  static TextStyle secondary = TextStyle(color: ThemePalette.secondaryMain);
  static TextStyle tertiary = TextStyle(color: ThemePalette.tertiaryMain);

  static TextStyle tonalPrimary(BuildContext context) {
    return TextStyle(
      color: _isDark ? ThemePalette.primaryLight : ThemePalette.primaryDark,
    );
  }

  static TextStyle tonalSecondary(BuildContext context) {
    return TextStyle(
      color: _isDark ? ThemePalette.secondaryLight : ThemePalette.secondaryDark,
    );
  }

  static TextStyle tonalTertiary(BuildContext context) {
    return TextStyle(
      color: _isDark ? ThemePalette.tertiaryLight : ThemePalette.tertiaryDark,
    );
  }
}
