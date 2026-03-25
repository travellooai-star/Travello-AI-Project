import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/widgets/user/auth_wrap.dart';
import 'package:flight_app/widgets/user/reset_form.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
        actionsPadding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
        actions: [
          FilledButton(
            onPressed: () {
              Get.toNamed(AppLink.contact);
            },
            style: ThemeButton.btnSmall.merge(ThemeButton.white),
            child: Row(
              children: [
                Icon(Icons.headset_mic, color: ThemePalette.primaryMain),
                const SizedBox(width: 4),
                Text('Help and Support', style: TextStyle(color: ThemePalette.primaryMain)),
              ],
            )
          )
        ],
      ),
      body: const AuthWrap(content: ResetForm())
    );
  }
}