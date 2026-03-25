import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/flight_package.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/package_card.dart';
import 'package:flight_app/widgets/flight/package_options.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PackageList extends StatelessWidget {
  const PackageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
          child: Text(
            'Explore the best packages!',
            textAlign: TextAlign.start,
            style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)
          ),
        ),
        const VSpace(),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(top: spacingUnit(2), left: spacingUnit(2), right: spacingUnit(2)),
          itemCount: packageList.length,
          itemBuilder: (BuildContext context, int index) {
            FlightPackage item = flightPackageList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: spacingUnit(3)),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppLink.flightDetailPackage);
                  },
                  child: PackageCard(
                    image: item.img,
                    label: item.label!,
                    from: item.from.name,
                    to: item.to.name,
                    date: item.date,
                    tags: item.tags != null ? item.tags! : [],
                    price: item.price,
                    plane: item.plane,
                  ),
                )
              ),
            );
          },
        )
      ],
    );
  }
}