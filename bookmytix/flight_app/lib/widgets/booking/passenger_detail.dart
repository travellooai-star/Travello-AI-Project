import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/list_item.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/grabber_icon.dart';
import 'package:flutter/material.dart';

final List<ListItem> selectedPackageList = [
  ListItem(
    value: '20',
    label: 'Beverages',
    icon: Icons.coffee,
    text: 'Beverages depending on airline and class'
  ),
  ListItem(
    value: '10',
    label: 'Snack Services',
    icon: Icons.card_giftcard,
    text: 'Light snacks and refreshments'
  ),
  ListItem(
    value: '25',
    label: 'Extra Baggage',
    icon: Icons.home_repair_service,
    text: 'Additional luggage for an extra fee'
  ),
];

class PassengerDetail extends StatelessWidget {
  const PassengerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Wrap(children: [
        Column(children: [
          const GrabberIcon(),
          const VSpaceShort(),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.person, size: 22),
            SizedBox(width: 8,),
            Text('Passenger Detail', style: ThemeText.subtitle)
          ],),
          const VSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Name', style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSurfaceVariant)),
            Text('${passengerList[0].title} ${passengerList[0].name}', style: ThemeText.paragraphBold),
          ]),
          SizedBox(height: spacingUnit(1)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Pasport ID', style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSurfaceVariant)),
            Text(passengerList[0].idCard, style: ThemeText.paragraphBold),
          ]),
          const VSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              Text('BAGGAGE', style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
              Text('${passengerList[0].baggage} Kg', style: ThemeText.subtitle2,)
            ]),
            Column(children: [
              Text('SEAT', style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
              Text('${passengerList[0].seat}', style: ThemeText.subtitle2,)
            ]),
            Column(children: [
              Text('TYPE', style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
              Text(passengerList[0].type!.toUpperCase(), style: ThemeText.subtitle2,)
            ]),
          ]),
          const VSpace(),
          Container(
            padding: EdgeInsets.symmetric(vertical: spacingUnit(1), horizontal: spacingUnit(2)),
            decoration: BoxDecoration(
              color: colorScheme(context).surfaceDim,
              borderRadius: ThemeRadius.medium
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: selectedPackageList.length,
              itemBuilder: (context, index) {
                final item = selectedPackageList[index];
                return ListTile(
                  leading: Icon(item.icon, size: 16, color: colorScheme(context).onSecondaryContainer),
                  title: Text(item.label, style: ThemeText.paragraph),
                  trailing: Text('\$${item.value}', style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSurface)),
                  contentPadding: const EdgeInsets.all(0),
                  minTileHeight: 0,
                );
              },
            ),
          ),
          const VSpace(),
        ])
      ]),
    );
  }
}