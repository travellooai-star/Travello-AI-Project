import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/plane.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class FlightSummaryWide extends StatelessWidget {
  const FlightSummaryWide(
      {super.key,
      required this.from,
      required this.to,
      this.label,
      this.discount = 0,
      required this.price,
      this.roundTrip = false,
      this.bordered = false,
      this.depart,
      this.arrival,
      this.plane});

  final City from;
  final City to;
  final String? label;
  final double discount;
  final double price;
  final bool roundTrip;
  final bool bordered;
  final DateTime? depart;
  final DateTime? arrival;
  final Plane? plane;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(spacingUnit(2)),
      padding: EdgeInsets.symmetric(vertical: spacingUnit(1)),
      height: 120,
      decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: ThemeRadius.medium,
          boxShadow: !bordered ? [ThemeShade.shadeSoft(context)] : null,
          border: bordered
              ? Border.all(
                  width: 1, color: colorScheme(context).primaryContainer)
              : null),
      child: Row(
        children: [
          /// AIRPLANE INFO
          plane != null
              ? Padding(
                  padding: EdgeInsets.only(
                    left: spacingUnit(2),
                    right: spacingUnit(2),
                    bottom: spacingUnit(2),
                    top: spacingUnit(1),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          Image.network(
                            plane!.logo,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            plane!.name,
                            style: ThemeText.paragraph,
                          ),
                        ]),
                        const VSpaceShort(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: ThemeRadius.xsmall,
                              color: colorScheme(context).outline),
                          child:
                              Text(plane!.classType, style: ThemeText.caption),
                        )
                      ]),
                )
              : Container(),
          SizedBox(width: spacingUnit(2)),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 64,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(from.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: ThemeText.caption.copyWith(
                                      color: colorScheme(context)
                                          .onSurfaceVariant)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Text(
                                  from.code,
                                  style: ThemeText.title2
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              depart != null
                                  ? Text(DateFormat.MMMEd().format(depart!),
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant))
                                  : Container(),
                              depart != null
                                  ? Text(DateFormat.jm().format(depart!),
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant))
                                  : Container(),
                            ]),
                      ),
                      SizedBox(width: spacingUnit(1)),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorScheme(context).primary, width: 1),
                            shape: BoxShape.circle),
                      ),
                      const Expanded(
                        child: DashedBorder(),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorScheme(context).primary, width: 1),
                            shape: BoxShape.circle),
                      ),
                      SizedBox(width: spacingUnit(1)),
                      SizedBox(
                        width: 64,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(to.name,
                                  style: ThemeText.caption.copyWith(
                                      color: colorScheme(context)
                                          .onSurfaceVariant)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Text(
                                  to.code,
                                  style: ThemeText.title2
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              arrival != null
                                  ? Text(DateFormat.MMMEd().format(arrival!),
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant))
                                  : Container(),
                              arrival != null
                                  ? Text(DateFormat.jm().format(arrival!),
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant))
                                  : Container(),
                            ]),
                      ),
                    ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Icon(
                      roundTrip
                          ? CupertinoIcons.arrow_right_arrow_left
                          : CupertinoIcons.airplane,
                      size: 24,
                      color: colorScheme(context).outlineVariant),
                ),
              ],
            ),
          ),

          /// PRICE AND LABEL
          SizedBox(width: spacingUnit(2)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          borderRadius: ThemeRadius.xsmall,
                          color: colorScheme(context).secondaryContainer),
                      child: label != null
                          ? Text(label!,
                              style: ThemeText.paragraph.copyWith(
                                  color: colorScheme(context).onSurface))
                          : Container(),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: ThemeRadius.xsmall,
                          color: colorScheme(context).tertiaryContainer),
                      child: Icon(CupertinoIcons.arrow_uturn_left,
                          color: colorScheme(context).tertiary, size: 16),
                    ),
                  ]),
                  const VSpaceShort(),
                  discount > 0
                      ? Text('PKR ${price.toStringAsFixed(0)}',
                          textAlign: TextAlign.end,
                          style: ThemeText.headline.copyWith(
                              color: colorScheme(context).onSurfaceVariant,
                              height: 1,
                              decoration: TextDecoration.lineThrough))
                      : Container(),
                  SizedBox(
                    width: spacingUnit(1),
                  ),
                  Text(
                      'PKR ${(price - price * discount / 100).toStringAsFixed(0)}',
                      textAlign: TextAlign.end,
                      style: ThemeText.title.copyWith(
                          color: colorScheme(context).primary,
                          height: 1,
                          fontWeight: FontWeight.bold)),
                ]),
          ),
        ],
      ),
    );
  }
}
