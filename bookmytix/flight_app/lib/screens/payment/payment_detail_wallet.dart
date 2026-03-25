import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/paper_card.dart';

class PaymentDetailWallet extends StatelessWidget {
  const PaymentDetailWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                Get.toNamed('/faq');
              },
            )
          ],
          centerTitle: true,
          title: const Text('Payment', style: ThemeText.subtitle),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(spacingUnit(2)),
                child: PaperCard(
                    flat: true,
                    content: Padding(
                      padding: EdgeInsets.all(spacingUnit(2)),
                      child: Column(children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/logos/logo11.jpg'),
                        ),
                        SizedBox(
                          height: spacingUnit(2),
                        ),
                        Text('Wallet ABC',
                            style: ThemeText.title2
                                .copyWith(fontWeight: FontWeight.bold)),
                        const Text(
                          'Continue Payment with Wallet ABC',
                          style: ThemeText.paragraph,
                        )
                      ]),
                    )),
              ),
              Expanded(
                  child: ListView(children: [
                const ListTile(
                  leading: Icon(Icons.shopping_bag_outlined),
                  title: Text('Billing Ammount:'),
                  trailing: Text(
                    '\$630.00',
                    style: ThemeText.paragraph,
                  ),
                ),
                const LineList(),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Tax 12%:'),
                  trailing: Text(
                    '\$75.6',
                    style: ThemeText.paragraph,
                  ),
                ),
                const LineList(),
                ListTile(
                  title: Text(
                    'Total:',
                    style:
                        ThemeText.title2.copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '\$705.6',
                    style: ThemeText.title2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemePalette.primaryMain),
                  ),
                ),
              ])),
              Container(
                color: colorScheme(context).surface,
                padding: EdgeInsets.only(
                    top: spacingUnit(1),
                    bottom: spacingUnit(5),
                    left: spacingUnit(2),
                    right: spacingUnit(2)),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        'By continuing, you agree with the',
                        style: ThemeText.caption,
                      ),
                      InkWell(
                          onTap: () {
                            Get.toNamed(AppLink.terms);
                          },
                          child: Text(' Terms and Conditions',
                              style: ThemeText.caption
                                  .copyWith(color: ThemePalette.primaryMain))),
                    ]),
                    SizedBox(height: spacingUnit(1)),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ThemeButton.btnBig
                                  .merge(ThemeButton.outlinedPrimary(context)),
                              child: const Text('BACK')),
                        ),
                        SizedBox(width: spacingUnit(1)),
                        Expanded(
                          child: FilledButton(
                              onPressed: () {
                                Get.toNamed('/payment/status',
                                    arguments: Get.arguments
                                            as Map<String, dynamic>? ??
                                        {});
                              },
                              style: ThemeButton.btnBig
                                  .merge(ThemeButton.tonalPrimary(context)),
                              child: const Text('OPEN WALLET APP')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
