import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/constants/img_api.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/no_data.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found', style: ThemeText.subtitle),
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: NoData(
          image: ImgApi.emptyNotFound,
          title: 'Page Not Found',
          desc: 'Nulla condimentum pulvinar arcu a pellentesque.',
          primaryAction: () {
            Get.toNamed(AppLink.home);
          },
          primaryTxtBtn: 'BACK TO HOME',
        ),
      )
    );
  }
}