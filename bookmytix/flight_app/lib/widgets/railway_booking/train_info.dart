import 'package:flight_app/models/train.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';

class TrainInfo extends StatelessWidget {
  const TrainInfo({super.key, required this.train});

  final Train train;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.train,
          color: colorScheme(context).primary,
          size: 24,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(train.name,
            style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(train.trainNumber, style: ThemeText.paragraph),
        const SizedBox(
          width: 8,
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: ThemeRadius.xsmall,
              color: colorScheme(context).primaryContainer),
          child: Text(train.trainClass, style: ThemeText.caption),
        )
      ]),
    );
  }
}
