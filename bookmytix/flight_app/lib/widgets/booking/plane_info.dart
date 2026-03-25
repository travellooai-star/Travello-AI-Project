import 'package:flight_app/models/plane.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';

class PlaneInfo extends StatelessWidget {
  const PlaneInfo({super.key, required this.plane});

  final Plane plane;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(
          borderRadius: ThemeRadius.xsmall,
          child: Image.network(
            plane.logo,
            width: 20,
          ),
        ),
        const SizedBox(width: 4,),
        Text(plane.name, style: ThemeText.paragraph),
        const Spacer(),
        Text(plane.code, style: ThemeText.paragraph),
        const SizedBox(width: 4,),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: ThemeRadius.xsmall,
            color: colorScheme(context).primaryContainer
          ),
          child: Text(plane.classType, style: ThemeText.caption),
        )
      ]),
    );
  }
}