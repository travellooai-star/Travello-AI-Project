import 'package:flight_app/constants/img_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_img;
import 'package:get/route_manager.dart';
import 'package:flight_app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/rounded_deco_main.dart';

class BannerExplore extends StatelessWidget {
  const BannerExplore({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;

    return Container(
        height: 400,
        decoration: BoxDecoration(
            color:
                isDark ? ThemePalette.primaryDark : ThemePalette.primaryLight),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: isDark
                    ? svg_img.Svg(ImgApi.bgCloudDark)
                    : svg_img.Svg(ImgApi.bgCloud),
                fit: BoxFit.contain,
                alignment: Alignment.center,
                colorFilter: isDark
                    ? ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.5), BlendMode.srcIn)
                    : null),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// TEXT TITLE
              Padding(
                  padding: EdgeInsets.only(
                    left: spacingUnit(2),
                    right: spacingUnit(2),
                    bottom: spacingUnit(5),
                    top: spacingUnit(10),
                  ),
                  child: Column(children: [
                    const Text(
                      'Explore the most beautiful places around Pakistan',
                      style: ThemeText.title2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      branding.desc,
                      style: ThemeText.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ])),

              /// BANNER WITH ILLUSTRATION
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: RoundedDecoMain(
                        height: 100,
                        bgDecoration: BoxDecoration(
                            color: colorScheme(context).surfaceContainerLowest),
                      )),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(ImgApi.bgPakistanLandmarks,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                              colorScheme(context).primary, BlendMode.srcIn)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
