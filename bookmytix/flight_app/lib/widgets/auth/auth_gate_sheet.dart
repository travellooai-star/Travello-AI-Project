import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';

/// Industry-standard "Soft Auth Gate" — shown when a guest attempts
/// an action that requires authentication (booking, checkout, etc.)
///
/// Pattern used by: Expedia, Booking.com, MakeMyTrip, Wego
/// ─────────────────────────────────────────────────────────────────
/// - Non-blocking: user can dismiss and keep browsing
/// - Clear value proposition before forcing login
/// - Matches app's luxury gold dark theme
class AuthGateSheet extends StatelessWidget {
  /// Short contextual reason shown to user, e.g. "to book this flight"
  final String action;

  const AuthGateSheet({super.key, this.action = 'to complete your booking'});

  /// Show the auth gate as a modal bottom sheet.
  static void show(BuildContext context,
      {String action = 'to complete your booking'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => AuthGateSheet(action: action),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        spacingUnit(3),
        spacingUnit(1),
        spacingUnit(3),
        spacingUnit(3) + bottomPad,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: spacingUnit(2.5)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Icon badge ───────────────────────────────────────────
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ThemePalette.primaryMain,
                  ThemePalette.primaryDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemePalette.primaryMain.withValues(alpha: 0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.black87,
              size: 28,
            ),
          ),

          SizedBox(height: spacingUnit(2)),

          // ── Headline ─────────────────────────────────────────────
          const Text(
            'Sign In Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),

          SizedBox(height: spacingUnit(1)),

          // ── Sub-copy ──────────────────────────────────────────────
          Text(
            'Please sign in $action.\nIt only takes a moment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),

          SizedBox(height: spacingUnit(3)),

          // ── Primary: Login button ─────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(AppLink.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemePalette.primaryMain,
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          SizedBox(height: spacingUnit(1.5)),

          // ── Secondary: Create account ─────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(AppLink.register);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemePalette.primaryMain,
                side: BorderSide(
                  color: ThemePalette.primaryMain.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),

          SizedBox(height: spacingUnit(2)),

          // ── Tertiary: Dismiss ──────────────────────────────────────
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              'Continue Browsing',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.4),
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
