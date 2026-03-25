import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/widgets/profile/timeline_activities.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

class DetailPoint extends StatelessWidget {
  const DetailPoint({super.key});

  @override
  Widget build(BuildContext context) {

    final ButtonStyle iconBtn = IconButton.styleFrom(
      backgroundColor: colorScheme(context).surface,
      shadowColor: Colors.grey.withValues(alpha: 0.5),
      elevation: 3
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          style: iconBtn,
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        title: Text('Your Points', style: ThemeText.subtitle.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: spacingUnit(7)),
        decoration: BoxDecoration(
          color: colorScheme(context).primary,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.stars, color: Colors.white.withValues(alpha: 0.5), size: 40),
            SizedBox(width: spacingUnit(1)),
            Text('3000', style: ThemeText.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const VSpaceShort(),
          /// HISTORY
          Expanded(child: 
            Container(
              padding: EdgeInsets.all(spacingUnit(1)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              ),
              child: const TimelineActivities()
            )
          )
        ],),
      )
    );
  }
}