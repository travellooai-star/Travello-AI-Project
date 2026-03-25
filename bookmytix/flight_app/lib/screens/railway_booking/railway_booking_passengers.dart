import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/train.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/passenger_form.dart';
import 'package:flight_app/widgets/railway_booking/train_info.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';
import 'package:flight_app/widgets/flight/info_header.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RailwayBookingPassengers extends StatelessWidget {
  const RailwayBookingPassengers({super.key});

  static const double price = 350;
  static const double discount = 10;

  @override
  Widget build(BuildContext context) {
    // Get all arguments including search parameters
    final Map<String, dynamic> args = Get.arguments ?? {};
    final Train? train = args['train'];

    // Get passenger counts from search parameters
    final int adults = args['adults'] as int? ?? 1;
    final int children = args['children'] as int? ?? 0;
    final int infants = args['infants'] as int? ?? 0;
    final int totalPassengers = adults + children + infants;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: InfoHeader(
          date: 'Fri, Oct 20',
          from: train?.fromStation ?? 'Karachi',
          to: train?.toStation ?? 'Lahore',
          passengers: totalPassengers,
        ),
      ),
      body: Column(children: [
        StepProgress(activeIndex: 0, items: bookingSteps),
        const Divider(),
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: TrainInfo(
                train: train ?? PakistanTrains.getDummyTrains().first)),
        Expanded(
            child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ThemeSize.sm),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              child: PassengerForm(totalPassengers: totalPassengers)),
        )),
        Padding(
          padding: EdgeInsets.only(
              left: spacingUnit(2),
              right: spacingUnit(2),
              top: spacingUnit(1),
              bottom: spacingUnit(4)),
          child: Container(
            height: 50,
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: FilledButton(
                onPressed: () {
                  Get.toNamed('/railway-booking-facilities', arguments: args);
                },
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                child: const Text('CONTINUE', style: ThemeText.subtitle2)),
          ),
        ),
      ]),
    );
  }
}
