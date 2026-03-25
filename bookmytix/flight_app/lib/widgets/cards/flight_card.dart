import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/plane.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class FlightCard extends StatelessWidget {
  const FlightCard({
    super.key, required this.from, required this.to,
    required this.plane, required this.price, this.label, this.hasRefund = true, 
    required this.depart, required this.arrival, required this.transit, this.discount = 0,
    this.withEdit = false, this.onEdit
  });

  final City from;
  final City to;
  final Plane plane;
  final double price;
  final String? label;
  final bool hasRefund;
  final DateTime depart;
  final DateTime arrival;
  final int transit; 
  final double discount;
  final bool withEdit;
  final Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    final Duration tripDuration = arrival.difference(depart);
    final bool isDark = Get.isDarkMode;
    final Color cardColor = isDark ? colorScheme(context).surfaceContainerLowest : colorScheme(context).primaryContainer;

    return Container(
      decoration: BoxDecoration(
        borderRadius: ThemeRadius.medium,
        border: Border.all(color: cardColor, width: 1),
        color: cardColor
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: spacingUnit(1)),
            decoration: BoxDecoration(
              color: colorScheme(context).surface,
              borderRadius: ThemeRadius.medium,
            ),
            child: Column(children: [
              /// AIRPLANE INFO
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                child: Row(children: [
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
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: ThemeRadius.xsmall,
                      color: colorScheme(context).outline
                    ),
                    child: Text(plane.classType, style: ThemeText.caption),
                  )
                ]),
              ),
              SizedBox(height: spacingUnit(1)),
          
              /// FLIGHT INFO
              Stack(
                alignment: Alignment.center,
                children: [
                  /// FLIGHT DECORATION
                  SizedBox(
                    width: 150,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          border: Border.all(color: cardColor, width: 1),
                          shape: BoxShape.circle
                        ),
                      ),
                      const Expanded(child: DashedBorder(),),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          border: Border.all(color: cardColor, width: 1),
                          shape: BoxShape.circle
                        ),
                      ),
                    ])
                  ),
                  
                  /// FLIGHT DETAILS
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SizedBox(
                        width: 60,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(from.name, overflow: TextOverflow.ellipsis, style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(from.code, style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold),),
                          ),
                          Text(DateFormat.jm().format(depart), style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
                        ]),
                      ),
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(plane.code, overflow: TextOverflow.ellipsis, style: ThemeText.caption.copyWith(fontWeight: FontWeight.bold),),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            child: Icon(CupertinoIcons.airplane, size: 24, color: colorScheme(context).outlineVariant),
                          ),
                          Text('${transit > 0 ? '${transit.toString()}x Transit' : 'Direct'} ${tripDuration.inHours}h ${tripDuration.inMinutes.remainder(60)}m', style: ThemeText.caption.copyWith(fontWeight: FontWeight.bold),)
                        ]),
                      ),
                      SizedBox(
                        width: 60,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(to.name, style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(to.code, style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold),),
                          ),
                          Text(DateFormat.jm().format(arrival), style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
                        ]),
                      )
                    ]),
                  ),
                ],
              ),
          
              /// PRICE AND LABEL
              Divider(color: cardColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: ThemeRadius.xsmall,
                      color: colorScheme(context).secondaryContainer
                    ),
                    child: label != null ? Text(
                      label!,
                      style: ThemeText.caption.copyWith(fontWeight: FontWeight.w500, color: colorScheme(context).onSurface)
                    ) : Container(),
                  ),
                  const SizedBox(width: 2),
                  hasRefund ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: ThemeRadius.xsmall,
                      color: colorScheme(context).tertiaryContainer
                    ),
                    child: Icon(CupertinoIcons.arrow_uturn_left, color: colorScheme(context).tertiary, size: 12),
                  ) : Container(),
                  const Spacer(),
                  discount > 0 ? Text('\$${price.toStringAsFixed(0)}', textAlign: TextAlign.end, style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSurfaceVariant, decoration: TextDecoration.lineThrough, height: 1)) : Container(),
                  SizedBox(width: spacingUnit(1),),
                  Text('\$${price - price * discount / 100}', textAlign: TextAlign.end, style: ThemeText.subtitle.copyWith(color: colorScheme(context).primary, fontWeight: FontWeight.bold, height: 1)),
                ]),
              ),
            ]),
          ),
          withEdit ? InkWell(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.edit, color: colorScheme(context).onPrimaryContainer, size: 14),
                SizedBox(width: spacingUnit(1)),
                Text('EDIT', style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold, color: colorScheme(context).onPrimaryContainer))
              ]),
            ),
          ) : Container()
        ],
      ),
    );
  }
}