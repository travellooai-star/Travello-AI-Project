import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/grabber_icon.dart';
import 'package:flutter/material.dart';

final List<String> helpGuideList = [
  'Log in to the mobile banking application, internet banking, or ATM.',
  'Select the "Transfer to Virtual Account" menu.',
  'Enter the virtual account number.',
  'Please verify the amount. The amount must be same as in application.',
  'Complete the transfer process until successful. Save proof of transfer if necessary.',
  'Go back to the application, then select the "Confirm Payment" button.'
];

class PaymentGuide extends StatelessWidget {
  const PaymentGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const GrabberIcon(),
      const VSpaceShort(),
      const Text('Payment Guide', textAlign: TextAlign.center, style: ThemeText.subtitle),
      const VSpaceShort(),
      ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(spacingUnit(2)),
        itemCount: helpGuideList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: spacingUnit(3)),
                margin: const EdgeInsets.only(left: 9),
                decoration: BoxDecoration(
                  border: index < helpGuideList.length - 1 ? Border(left: BorderSide(color: colorScheme(context).primaryContainer, width: 1)) : null
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: spacingUnit(2)),
                  child: Text(helpGuideList[index], textAlign: TextAlign.start, style: ThemeText.paragraph),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: colorScheme(context).primaryContainer,
                  child: Text('${index + 1}', style: ThemeText.caption.copyWith(color: colorScheme(context).onPrimaryContainer))
                ),
              ),
            ],
          );
        }
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ThemeButton.btnBig.merge(ThemeButton.outlinedPrimary(context)),
          child: const Text('UNDERSTAND')
        ),
      ),
      const VSpaceBig()
    ]);
  }
}