import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter_svg/svg.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    this.primaryTxtBtn,
    this.secondaryTxtBtn,
    this.primaryAction,
    this.secondaryAction,
  });

  final String image;
  final String title;
  final String desc;
  final String? primaryTxtBtn;
  final String? secondaryTxtBtn;
  final Function()? primaryAction;
  final Function()? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: ThemeSize.sm),
        padding: EdgeInsets.symmetric(
          horizontal: spacingUnit(3),
          vertical: spacingUnit(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ILLUSTRATION
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemePalette.primaryMain.withValues(alpha: 0.15),
                    ThemePalette.primaryLight.withValues(alpha: 0.30),
                  ],
                ),
                border: Border.all(
                  color: ThemePalette.primaryMain.withValues(alpha: 0.20),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemePalette.primaryMain.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child:
                    SvgPicture.asset(image, height: 110, fit: BoxFit.contain),
              ),
            ),

            SizedBox(height: spacingUnit(3)),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: ThemeText.title.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: colorScheme(context).onSurface,
                height: 1.2,
              ),
            ),

            SizedBox(height: spacingUnit(1)),

            /// DESCRIPTION
            Container(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: ThemeText.headline.copyWith(
                  color: colorScheme(context).onSurface.withValues(alpha: 0.55),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: spacingUnit(3.5)),

            /// PRIMARY BUTTON
            if (primaryTxtBtn != null)
              SizedBox(
                height: 52,
                width: double.infinity,
                child: FilledButton(
                  onPressed: primaryAction,
                  style: ThemeButton.tonalPrimary(context).copyWith(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(0),
                  ),
                  child: Text(
                    primaryTxtBtn!,
                    style: ThemeText.subtitle2.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

            if (primaryTxtBtn != null && secondaryTxtBtn != null)
              SizedBox(height: spacingUnit(1.5)),

            /// SECONDARY BUTTON
            if (secondaryTxtBtn != null)
              SizedBox(
                height: 52,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: secondaryAction,
                  style: ThemeButton.outlinedSecondary(context).copyWith(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                      BorderSide(
                        color: ThemePalette.primaryMain.withValues(alpha: 0.45),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    secondaryTxtBtn!,
                    style: ThemeText.subtitle2.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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
