import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class QuickSearchBar extends StatelessWidget {
  const QuickSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 800 : double.infinity,
        ),
        padding:
            EdgeInsets.symmetric(horizontal: isDesktop ? 0 : spacingUnit(2)),
        child: GestureDetector(
          onTap: () {
            Get.toNamed(AppLink.explore);
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: ThemeRadius.medium,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: spacingUnit(2)),
                Icon(
                  Icons.search,
                  color: colorScheme(context).primary,
                  size: 24,
                ),
                SizedBox(width: spacingUnit(1.5)),
                Expanded(
                  child: Text(
                    'Search flights, destinations...',
                    style: ThemeText.paragraph.copyWith(
                      color:
                          colorScheme(context).onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: spacingUnit(1)),
                  padding: EdgeInsets.symmetric(
                    horizontal: spacingUnit(1),
                    vertical: spacingUnit(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme(context).primaryContainer,
                    borderRadius: ThemeRadius.small,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.explore,
                        size: 16,
                        color: colorScheme(context).onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Explore',
                        style: ThemeText.caption.copyWith(
                          color: colorScheme(context).onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
