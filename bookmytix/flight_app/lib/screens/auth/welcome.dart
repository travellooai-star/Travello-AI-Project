import 'package:flight_app/constants/img_api.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/auth_service.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final bool _openAuthOpt = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallPhone = screenWidth < 380 || screenHeight < 640;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(color: ThemePalette.primaryMain),
          child: Container(
            padding: EdgeInsets.all(spacingUnit(3)),
            decoration: BoxDecoration(
                color: colorScheme(context).surface.withValues(alpha: 0.1),
                image: DecorationImage(
                    image: AssetImage(ImgApi.welcomeBg), fit: BoxFit.cover)),
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// TEXT
                      Text('Welcome to ${branding.name}',
                          style: TextStyle(
                              fontSize: isSmallPhone ? 32 : 42,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const VSpaceShort(),
                      Text(branding.title,
                          style: ThemeText.title2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                      const VSpaceBig(),

                      /// BUTTONS
                      SizedBox(
                        width: double.infinity,
                        height: isSmallPhone ? 50 : 56,
                        child: FilledButton(
                            onPressed: () {
                              // Direct navigation to register page
                              Get.toNamed('/register');
                            },
                            style: ThemeButton.btnBig.merge(ThemeButton.black),
                            child:
                                const Text('SIGN UP', style: ThemeText.title2)),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: spacingUnit(3)),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(child: LineList()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text('Already have account?',
                                      style: TextStyle(
                                          fontSize: isSmallPhone ? 14 : 16,
                                          color: Colors.white)),
                                ),
                                const Expanded(child: LineList()),
                              ])),
                      SizedBox(
                        width: double.infinity,
                        height: isSmallPhone ? 50 : 56,
                        child: OutlinedButton(
                            onPressed: () {
                              // Direct navigation to login page
                              Get.toNamed('/login');
                            },
                            style: ThemeButton.btnBig
                                .merge(ThemeButton.outlinedWhite()),
                            child:
                                const Text('LOGIN', style: ThemeText.title2)),
                      ),
                      const VSpace(),
                      SizedBox(
                        width: double.infinity,
                        height: isSmallPhone ? 50 : 56,
                        child: TextButton(
                            onPressed: () async {
                              // Enable guest mode
                              await AuthService.enableGuestMode();
                              // Navigate to home as guest
                              Get.offAllNamed('/home');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 24),
                                const SizedBox(width: 8),
                                Text('Continue as Guest',
                                    style: ThemeText.title2.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w400)),
                              ],
                            )),
                      ),
                      const VSpaceBig(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: _openAuthOpt ? 200 : 0,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
