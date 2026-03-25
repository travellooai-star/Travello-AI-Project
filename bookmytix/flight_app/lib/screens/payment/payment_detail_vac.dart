import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/widgets/payment/payment_guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/alert_info/alert_info.dart';
import 'package:flight_app/widgets/app_input/app_input_box.dart';
import 'package:flight_app/widgets/cards/paper_card.dart';
import 'package:flight_app/widgets/counter/counter_down.dart';

class PaymentDetailVac extends StatelessWidget {
  const PaymentDetailVac({super.key});

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
              const Column(children: [
                /// TIMER
                VSpace(),
                Text('Time left:'),
                CounterDown(
                    duration: Duration(
                      days: 0,
                      hours: 23,
                      minutes: 30,
                    ),
                    format: CountDownTimerFormat.daysHoursMinutes),
                VSpaceShort(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: AlertInfo(
                      type: AlertType.warning,
                      text:
                          'Please finish your payment before 22 May 2025:17:45'),
                )
              ]),
              const VSpaceShort(),

              /// DETAIL BANK ACCOUNT
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(spacingUnit(2)),
                  children: [
                    PaperCard(
                        flat: true,
                        content: Padding(
                          padding: EdgeInsets.all(spacingUnit(2)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Image.asset(
                                  'assets/images/logos/logo2.png',
                                  height: 50,
                                )),
                                const VSpace(),
                                const Text('Virtual Account Number'),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('098765432112345',
                                          style: ThemeText.title.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: spacingUnit(1)),
                                      IconButton(
                                          icon: const Icon(Icons.copy),
                                          onPressed: () {})
                                    ]),
                                const VSpaceShort(),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Total amount + tax 12%: ',
                                          style: ThemeText.paragraph.copyWith(
                                              color: colorScheme(context)
                                                  .onSurfaceVariant)),
                                      Text(
                                        '\$630',
                                        style: ThemeText.title2.copyWith(
                                            color: ThemePalette.primaryMain,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ]),
                        )),
                    const VSpace(),
                    AppInputBox(
                        content: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.help_outline,
                          color: ThemePalette.primaryMain),
                      title: Text('Need guide for this transfer method?',
                          style: TextStyle(color: ThemePalette.primaryMain)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showModalBottomSheet<dynamic>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return const Wrap(children: [PaymentGuide()]);
                            });
                      },
                    ))
                  ],
                ),
              ),

              /// ACTION BUTTON
              Padding(
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
                              child: const Text('CONFIRM TRANSFER')),
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
