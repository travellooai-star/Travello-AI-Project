import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/train.dart';
import 'package:flight_app/models/train_package.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/cards/train_package_card.dart';
import 'package:flight_app/widgets/title/title_action.dart';
import 'package:flight_app/utils/auth_service.dart';
import 'package:flight_app/utils/location_preference_service.dart';

/// Featured train packages slider - DYNAMIC based on user's city
class TrainPackageSlider extends StatefulWidget {
  const TrainPackageSlider({super.key});

  @override
  State<TrainPackageSlider> createState() => _TrainPackageSliderState();
}

class _TrainPackageSliderState extends State<TrainPackageSlider> {
  final ScrollController _scrollController = ScrollController();
  String _userOriginCityCode = 'KHI'; // Default fallback
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
  /// Rawalpindi station serves Islamabad (no PR station in ISB).
  List<TrainPackage> get _relevantPackages {
    if (_isGuestMode) {
      // Guest: show a daily-shuffled mix from all cities
      final seed = DateTime.now().day * 31 + DateTime.now().month;
      final rng = Random(seed);
      final all = List<TrainPackage>.from(featuredTrainPackages);
      all.shuffle(rng);
      return all.take(8).toList();
    }
    final lowerCity = _userOriginCityName.toLowerCase();
    final isRWPZone = lowerCity == 'islamabad' || lowerCity == 'rawalpindi';
    return featuredTrainPackages
        .where((pkg) {
          final fromLower = pkg.fromStation.toLowerCase();
          if (isRWPZone) {
            return fromLower.contains('rawalpindi') ||
                fromLower.contains('islamabad');
          }
          return fromLower.contains(lowerCity);
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
                Icons.train_outlined,
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
                'Check flight options or search for other routes',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? spacingUnit(8) : spacingUnit(2),
          ),
          child: TitleAction(
            title: 'Featured Packages',
            textAction: 'See All',
            onTap: () {
              Get.toNamed('/train-search-home');
            },
          ),
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
                    horizontal: isDesktop ? spacingUnit(8) : spacingUnit(2),
                  ),
                  itemCount: packageList.length,
                  itemBuilder: (context, index) {
                    final item = packageList[index];

                    return GestureDetector(
                      onTap: () {
                        final double discountPct = _getDiscountPercent(item);
                        final double discountedPrice =
                            item.price * (1 - discountPct / 100);
                        final Train train = Train(
                          id: item.id,
                          name: item.name,
                          trainNumber: item.trainNumber,
                          fromStation: item.fromStation,
                          toStation: item.toStation,
                          departureTime: item.departureTime,
                          arrivalTime: '—',
                          duration: item.duration,
                          trainClass: item.trainClass,
                          price: discountedPrice,
                          availableSeats: 50,
                          operatedBy: 'Pakistan Railways',
                        );
                        Get.toNamed(
                          AppLink.railwayBookingStep1,
                          arguments: {
                            'train': train,
                            'adults': 1,
                            'children': 0,
                            'infants': 0,
                          },
                        );
                      },
                      child: SizedBox(
                        width: cardWidth,
                        child: Padding(
                          padding: EdgeInsets.only(right: spacingUnit(2)),
                          child: TrainPackageCard(
                            image: item.imageUrl,
                            label: _getDiscountLabel(item),
                            trainName: item.name,
                            trainNumber: item.trainNumber,
                            from: _getShortStationName(item.fromStation),
                            to: _getShortStationName(item.toStation),
                            date: item.departureTime,
                            tags: [
                              ...item.amenities
                                  .where(
                                      (a) => !a.toLowerCase().contains('meal'))
                                  .take(1),
                              _getDiscountTag(item),
                            ],
                            price: item.price,
                            trainClass: item.trainClass,
                            roundTrip: item.roundTrip,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isDesktop) ...[
                Positioned(
                  left: 16,
                  top: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          colorScheme(context).surface.withValues(alpha: 0.95),
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
                      color:
                          colorScheme(context).surface.withValues(alpha: 0.95),
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
      ],
    );
  }

  double _getDiscountPercent(TrainPackage package) {
    switch (package.packageType) {
      case 'business':
        return 30;
      case 'sleeper':
        return 20;
      case 'express':
        return 15;
      default:
        return 10;
    }
  }

  String _getDiscountLabel(TrainPackage package) {
    switch (package.packageType) {
      case 'business':
        return '30%\nOFF';
      case 'sleeper':
        return '20%\nOFF';
      case 'express':
        return '15%\nOFF';
      default:
        return '10%\nOFF';
    }
  }

  String _getDiscountTag(TrainPackage package) {
    switch (package.packageType) {
      case 'business':
        return '30% OFF';
      case 'sleeper':
        return '20% OFF';
      case 'express':
        return '15% OFF';
      default:
        return '10% OFF';
    }
  }

  String _getShortStationName(String fullName) {
    // Shorten station names like "Karachi Cantt" -> "Karachi"
    return fullName.split(' ').first;
  }
}
