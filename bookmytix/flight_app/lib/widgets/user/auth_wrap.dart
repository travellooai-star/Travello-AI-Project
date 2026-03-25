import 'package:flight_app/constants/img_api.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';

class AuthWrap extends StatelessWidget {
  const AuthWrap({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                  ThemePalette.primaryMain.withValues(alpha: 0.8),
                ]
              : [
                  ThemePalette.primaryMain,
                  ThemePalette.primaryMain.withValues(alpha: 0.8),
                  const Color(0xFF6366f1),
                ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImgApi.welcomeBg),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(2),
                  vertical: spacingUnit(3),
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: ThemePalette.primaryMain.withValues(alpha: 0.1),
                        blurRadius: 60,
                        offset: const Offset(0, 20),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(spacingUnit(3)),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
