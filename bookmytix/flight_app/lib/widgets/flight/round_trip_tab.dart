import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundTripTab extends StatelessWidget {
  const RoundTripTab(
      {super.key, required this.setTabMenu, required this.tabMenuIndex});

  final Function(int) setTabMenu;
  final int tabMenuIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(2),
        vertical: spacingUnit(1),
      ),
      child: Row(children: [
        Expanded(
            child: InkWell(
          onTap: () {
            setTabMenu(0);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacingUnit(1),
              vertical: spacingUnit(0.75),
            ),
            decoration: BoxDecoration(
              borderRadius: ThemeRadius.medium,
              color: tabMenuIndex == 0
                  ? colorScheme(context).primaryContainer
                  : colorScheme(context).surfaceDim,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(FontAwesomeIcons.planeDeparture,
                  size: 24,
                  color: tabMenuIndex == 0
                      ? colorScheme(context).onPrimaryContainer
                      : colorScheme(context).onSurface),
              SizedBox(width: spacingUnit(2)),
              Text('Departure',
                  style: ThemeText.subtitle.copyWith(
                      color: tabMenuIndex == 0
                          ? colorScheme(context).onPrimaryContainer
                          : colorScheme(context).onSurface))
            ]),
          ),
        )),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: InkWell(
          onTap: () {
            setTabMenu(1);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacingUnit(1),
              vertical: spacingUnit(0.75),
            ),
            decoration: BoxDecoration(
              borderRadius: ThemeRadius.medium,
              color: tabMenuIndex == 1
                  ? colorScheme(context).primaryContainer
                  : colorScheme(context).surfaceDim,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(FontAwesomeIcons.planeArrival,
                  size: 24,
                  color: tabMenuIndex == 1
                      ? colorScheme(context).onPrimaryContainer
                      : colorScheme(context).onSurface),
              SizedBox(width: spacingUnit(2)),
              Text('Return',
                  style: ThemeText.subtitle.copyWith(
                      color: tabMenuIndex == 1
                          ? colorScheme(context).onPrimaryContainer
                          : colorScheme(context).onSurface))
            ]),
          ),
        ))
      ]),
    );
  }
}
