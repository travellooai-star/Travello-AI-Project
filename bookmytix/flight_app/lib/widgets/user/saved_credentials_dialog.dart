import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_button.dart';

class SavedCredentialsDialog extends StatelessWidget {
  final String emailOrPhone;
  final VoidCallback onUseCredentials;
  final VoidCallback onDifferentAccount;

  const SavedCredentialsDialog({
    super.key,
    required this.emailOrPhone,
    required this.onUseCredentials,
    required this.onDifferentAccount,
  });

  String _maskEmail(String email) {
    if (email.contains('@')) {
      final parts = email.split('@');
      final username = parts[0];
      final domain = parts[1];
      if (username.length <= 2) return email;
      return '${username.substring(0, 2)}${'*' * (username.length - 2)}@$domain';
    } else {
      // Phone number
      if (email.length <= 4) return email;
      return '${email.substring(0, 2)}${'*' * (email.length - 4)}${email.substring(email.length - 2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(spacingUnit(3)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.white,
              ),
            ),

            SizedBox(height: spacingUnit(2)),

            // Title
            Text(
              'Welcome Back!',
              style: ThemeText.title.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: spacingUnit(1)),

            // Saved account info
            Container(
              margin: EdgeInsets.symmetric(vertical: spacingUnit(2)),
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: spacingUnit(1)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Account',
                          style: ThemeText.caption.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _maskEmail(emailOrPhone),
                          style: ThemeText.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                ],
              ),
            ),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: onUseCredentials,
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                icon: const Icon(Icons.login),
                label: const Text(
                  'Continue',
                  style: ThemeText.subtitle,
                ),
              ),
            ),

            SizedBox(height: spacingUnit(1)),

            // Use different account
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: onDifferentAccount,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                icon: Icon(
                  Icons.swap_horiz,
                  color: colorScheme.onSurface,
                ),
                label: Text(
                  'Use Different Account',
                  style: ThemeText.subtitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
