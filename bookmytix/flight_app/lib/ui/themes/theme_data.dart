import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

/// ════════════════════════════════════════════════════════════════════════════
/// TRAVELLO AI - LUXURY LIGHT THEME
/// Based on user-specified color palette
/// ════════════════════════════════════════════════════════════════════════════

ThemeData luxuryDarkTheme = ThemeData(
  fontFamily: appFont,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Light grey/white
  primaryColor: const Color(0xFFD4AF37), // Soft gold

  // Color Scheme
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFD4AF37), // Soft gold
    secondary: Color(0xFFC6A75E), // Muted gold
    surface: Color(0xFFFFFFFF), // White
    onPrimary: Color(0xFF000000), // Black text on gold
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFF1A1A1A), // Dark text
    onSurfaceVariant: Color(0xFF666666), // Secondary text
    brightness: Brightness.light,
  ),

  // Card Theme
  cardColor: const Color(0xFFFFFFFF),
  cardTheme: const CardThemeData(
    color: Color(0xFFFFFFFF),
    elevation: 2,
    surfaceTintColor: Colors.transparent,
  ),

  // Text Theme
  textTheme: const TextTheme(
    bodyLarge:
        TextStyle(color: Color(0xFF1A1A1A), fontFamily: appFont), // Dark text
    bodyMedium: TextStyle(
        color: Color(0xFF333333), fontFamily: appFont), // Dark grey text
    bodySmall:
        TextStyle(color: Color(0xFF666666), fontFamily: appFont), // Grey text
    titleLarge: TextStyle(
        color: Color(0xFF1A1A1A), fontFamily: appFont), // Dark for titles
    titleMedium: TextStyle(color: Color(0xFF1A1A1A), fontFamily: appFont),
    titleSmall: TextStyle(color: Color(0xFF666666), fontFamily: appFont),
  ),

  // App Bar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFD4AF37),
    foregroundColor: Color(0xFF000000),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Color(0xFF000000)),
    titleTextStyle: TextStyle(
      color: Color(0xFF000000),
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: appFont,
    ),
  ),

  // Bottom Navigation
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    selectedItemColor: Color(0xFFD4AF37), // Gold active
    unselectedItemColor: Color(0xFF808080), // Muted inactive
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(
        0xFFF5F5F5), // Light grey background for better text visibility
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF808080)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF808080)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
    ),
    labelStyle: const TextStyle(color: Color(0xFF808080), fontFamily: appFont),
    hintStyle: const TextStyle(color: Color(0xFF808080), fontFamily: appFont),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD4AF37), // Gold
      foregroundColor: const Color(0xFF000000), // Black text
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: appFont,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFD4AF37),
      side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFD4AF37),
    ),
  ),

  // Icon Theme
  iconTheme: const IconThemeData(
    color: Color(0xFF1A1A1A),
    size: 24,
  ),

  // Divider
  dividerTheme: const DividerThemeData(
    color: Color(0xFF808080),
    thickness: 1,
  ),
);

/// Legacy theme references
ThemeData get darkColorScheme => luxuryDarkTheme;
ThemeData lightColorScheme = luxuryDarkTheme;
