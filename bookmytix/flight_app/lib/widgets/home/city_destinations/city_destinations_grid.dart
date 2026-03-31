import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/shimmer_preloader.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CityDestinationsGrid extends StatelessWidget {
  const CityDestinationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid columns
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > 1400) {
      crossAxisCount = 7;
      childAspectRatio = 0.85;
    } else if (screenWidth > 1200) {
      crossAxisCount = 6;
      childAspectRatio = 0.85;
    } else if (screenWidth > 900) {
      crossAxisCount = 5;
      childAspectRatio = 0.85;
    } else if (screenWidth > 600) {
      crossAxisCount = 4;
      childAspectRatio = 0.8;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 0.75;
    }

    // Popular Pakistani destinations: Top 10 flight destinations
    final List<City> recomendedCityList = [
      cityList.firstWhere((city) => city.name == 'Skardu'),
      cityList.firstWhere((city) => city.name == 'Lahore'),
      cityList.firstWhere((city) => city.name == 'Karachi'),
      cityList.firstWhere((city) => city.name == 'Islamabad'),
      cityList.firstWhere((city) => city.name == 'Quetta'),
      cityList.firstWhere((city) => city.name == 'Gilgit'),
      cityList.firstWhere((city) => city.name == 'Peshawar'),
      cityList.firstWhere((city) => city.name == 'Multan'),
      cityList.firstWhere((city) => city.name == 'Faisalabad'),
      cityList.firstWhere((city) => city.name == 'Sialkot'),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1200 ? spacingUnit(8) : spacingUnit(2)),
      decoration: BoxDecoration(
          color: colorScheme(context).surfaceContainerLowest,
          borderRadius: ThemeRadius.medium),
      child: Column(
        children: [
          const TitleBasic(title: 'Popular Destinations'),
          SizedBox(
            height: spacingUnit(2),
          ),
          GridView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: screenWidth > 1200 ? 16 : 8,
                mainAxisSpacing: screenWidth > 1200 ? 16 : 8,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: recomendedCityList.length,
              itemBuilder: (context, index) {
                final City item = recomendedCityList[index];
                return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppLink.flightSearchHome, arguments: {
                        'toCode': item.code,
                        'toCity': item.name,
                      });
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: ThemeRadius.medium,
                              boxShadow: [ThemeShade.shadeMedium(context)],
                            ),
                            child: ClipRRect(
                              borderRadius: ThemeRadius.medium,
                              child: Image.network(
                                item.photos[0],
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ShimmerPreloader());
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: spacingUnit(1)),
                          Text(item.name,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeText.paragraph)
                        ]));
              }),
        ],
      ),
    );
  }
}
