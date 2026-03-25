import 'dart:math';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/flight_package.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/cards/package_card.dart';
import 'package:flight_app/widgets/title/title_action.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/utils/auth_service.dart';
import 'package:flight_app/utils/location_preference_service.dart';

class PackageListSlider extends StatefulWidget {
  const PackageListSlider({super.key});

  @override
  State<PackageListSlider> createState() => _PackageListSliderState();
}

class _PackageListSliderState extends State<PackageListSlider> {
  final ScrollController _scrollController = ScrollController();
  String _userOriginCityCode = 'KHI';
  String _userOriginCityName = 'Karachi';
  bool _isLoading = true;
  bool _isGuestMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserOriginCity();
  }

  /// Fetch user's selected origin city
  Future<void> _loadUserOriginCity() async {
    final isGuest = await AuthService.isGuestMode();
    final cityData = await LocationPreferenceService.getOriginCity();
    if (mounted) {
      setState(() {
        _isGuestMode = isGuest;
        _userOriginCityCode = cityData['cityCode']!;
        _userOriginCityName = cityData['cityName']!;
        _isLoading = false;
      });
    }
  }

  /// Filter packages FROM user's city.
  /// ISB airport (IATA: ISB) serves both Islamabad and Rawalpindi.
  List<FlightPackage> get _relevantPackages {
    if (_isGuestMode) {
      // Guest: show a daily-shuffled mix from all cities
      final seed = DateTime.now().day * 31 + DateTime.now().month;
      final rng = Random(seed);
      final all = List<FlightPackage>.from(flightPackageList);
      all.shuffle(rng);
      return all.take(8).toList();
    }
    final lowerCity = _userOriginCityName.toLowerCase();
    final isISBZone = lowerCity == 'islamabad' || lowerCity == 'rawalpindi';
    return flightPackageList
        .where((pkg) {
          final fromName = pkg.from.name.toLowerCase();
          if (isISBZone) {
            return fromName == 'islamabad' ||
                fromName == 'rawalpindi' ||
                pkg.from.code == 'ISB' ||
                pkg.from.code == 'RWP';
          }
          return fromName.contains(lowerCity) ||
              pkg.from.code == _userOriginCityCode;
        })
        .take(8)
        .toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 320,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 320,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme(context).primary,
          ),
        ),
      );
    }

    final packageList = _relevantPackages;

    // Show message if no packages from user's city
    if (packageList.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(spacingUnit(2)),
        child: Container(
          padding: EdgeInsets.all(spacingUnit(3)),
          decoration: BoxDecoration(
            color: colorScheme(context).surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.flight_takeoff_outlined,
                size: 48,
                color: colorScheme(context).primary.withValues(alpha: 0.5),
              ),
              SizedBox(height: spacingUnit(1)),
              Text(
                'No featured packages from $_userOriginCityName yet',
                style: TextStyle(
                  color: colorScheme(context).onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacingUnit(0.5)),
              Text(
                'Search for flights to explore all available routes',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme(context).onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    const double cardWidth = 300;
    const double cardHeight = 220;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? spacingUnit(8) : spacingUnit(2)),
        child: TitleAction(
            title: 'Featured Packages',
            textAction: 'See All',
            onTap: () {
              Get.toNamed(AppLink.promoDetail);
            }),
      ),
      SizedBox(height: spacingUnit(2)),
      SizedBox(
        width: double.infinity,
        height: cardHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? spacingUnit(8) : spacingUnit(2)),
                  itemCount: packageList.length,
                  itemBuilder: ((context, index) {
                    FlightPackage item = packageList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppLink.flightDetailPackage,
                            arguments: item);
                      },
                      child: SizedBox(
                          width: cardWidth,
                          child: Padding(
                            padding: EdgeInsets.only(right: spacingUnit(2)),
                            child: PackageCard(
                                image: item.img,
                                label: item.label!,
                                from: item.from.name,
                                to: item.to.name,
                                date: item.date,
                                tags: item.tags != null ? item.tags! : [],
                                price: item.price,
                                plane: item.plane,
                                roundTrip: item.roundTrip),
                          )),
                    );
                  })),
            ),
            if (isDesktop) ...[
              Positioned(
                left: 16,
                top: 80,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme(context).surface.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _scrollLeft,
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: colorScheme(context).primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 80,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme(context).surface.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _scrollRight,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme(context).primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ]);
  }
}
