import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainSummary extends StatelessWidget {
  const TrainSummary({
    super.key,
    required this.trainName,
    required this.trainNumber,
    required this.trainClass,
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    this.label,
    this.discount = 0,
    required this.price,
    this.roundTrip = false,
    this.bordered = false,
    this.depart,
    this.arrival,
    this.logo = '',
  });

  final String trainName;
  final String trainNumber;
  final String trainClass;
  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final String? label;
  final double discount;
  final double price;
  final bool roundTrip;
  final bool bordered;
  final DateTime? depart;
  final DateTime? arrival;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(spacingUnit(2)),
      padding: EdgeInsets.symmetric(vertical: spacingUnit(1)),
      decoration: BoxDecoration(
        color: colorScheme(context).surface,
        borderRadius: ThemeRadius.medium,
        boxShadow: !bordered ? [ThemeShade.shadeSoft(context)] : null,
        border: bordered
            ? Border.all(width: 1, color: colorScheme(context).primaryContainer)
            : null,
      ),
      child: Column(
        children: [
          /// TRAIN INFO ROW  – mirrors FlightSummary's airplane info row
          Padding(
            padding: EdgeInsets.only(
              left: spacingUnit(2),
              right: spacingUnit(2),
              bottom: spacingUnit(2),
              top: spacingUnit(1),
            ),
            child: Row(children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme(context).primaryContainer,
                  borderRadius: ThemeRadius.xsmall,
                ),
                child: Icon(
                  Icons.train,
                  size: 13,
                  color: colorScheme(context).primary,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  trainName,
                  style: ThemeText.paragraph,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: ThemeRadius.xsmall,
                  color: colorScheme(context).outline,
                ),
                child: Text(trainClass, style: ThemeText.caption),
              ),
            ]),
          ),

          /// DASHED LINE WITH CIRCLE DOTS – mirrors FlightSummary decoration
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colorScheme(context).primary, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Expanded(child: DashedBorder()),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colorScheme(context).primary, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              /// Center: logo image on dashed line
              logo.isNotEmpty
                  ? ClipRRect(
                      borderRadius: ThemeRadius.xsmall,
                      child: Image.network(
                        logo,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.train,
                          size: 24,
                          color: colorScheme(context).outlineVariant,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.train,
                      size: 24,
                      color: colorScheme(context).outlineVariant,
                    ),
            ],
          ),

          /// STATION CODES + CITY NAMES – mirrors FlightSummary destination row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        fromCity,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeText.caption.copyWith(
                            color: colorScheme(context).onSurfaceVariant),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          fromCode,
                          style: ThemeText.title2
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      depart != null
                          ? Text(DateFormat.MMMEd().format(depart!),
                              style: ThemeText.caption.copyWith(
                                  color: colorScheme(context).onSurfaceVariant))
                          : Container(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 2),
                        child: logo.isNotEmpty
                            ? ClipRRect(
                                borderRadius: ThemeRadius.xsmall,
                                child: Image.network(
                                  logo,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.train,
                                    size: 24,
                                    color: colorScheme(context).outlineVariant,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.train,
                                size: 24,
                                color: colorScheme(context).outlineVariant,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        toCity,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeText.caption.copyWith(
                            color: colorScheme(context).onSurfaceVariant),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          toCode,
                          style: ThemeText.title2
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      arrival != null
                          ? Text(DateFormat.MMMEd().format(arrival!),
                              style: ThemeText.caption.copyWith(
                                  color: colorScheme(context).onSurfaceVariant))
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// DIVIDER + PRICE ROW – mirrors FlightSummary price section
          Divider(color: colorScheme(context).primaryContainer),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: ThemeRadius.xsmall,
                  color: colorScheme(context).secondaryContainer,
                ),
                child: label != null
                    ? Text(label!,
                        style: ThemeText.paragraph.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme(context).onSurface))
                    : Container(),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: ThemeRadius.xsmall,
                  color: colorScheme(context).tertiaryContainer,
                ),
                child: Icon(Icons.train,
                    color: colorScheme(context).tertiary, size: 16),
              ),
              const Spacer(),
              discount > 0
                  ? Text(
                      'PKR ${price.toStringAsFixed(0)}',
                      textAlign: TextAlign.end,
                      style: ThemeText.headline.copyWith(
                          color: colorScheme(context).onSurfaceVariant,
                          height: 1,
                          decoration: TextDecoration.lineThrough),
                    )
                  : Container(),
              SizedBox(width: spacingUnit(1)),
              Text(
                'PKR ${(price - price * discount / 100).toStringAsFixed(0)}',
                textAlign: TextAlign.end,
                style: ThemeText.title.copyWith(
                    color: colorScheme(context).primary,
                    height: 1,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
