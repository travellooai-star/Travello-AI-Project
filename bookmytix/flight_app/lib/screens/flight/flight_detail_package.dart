import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/airport.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/flight_package.dart';
import 'package:flight_app/models/flight_route.dart';
import 'package:flight_app/widgets/cards/flight_route_card.dart';
import 'package:flight_app/constants/img_api.dart';
import 'package:flight_app/models/plane.dart';
import 'package:flight_app/screens/flight/flight_results_screen.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flight_app/widgets/decorations/oval_shape.dart';
import 'package:flight_app/widgets/flight/flight_routes.dart';
import 'package:flight_app/widgets/flight/flight_routes_horizontal.dart';
import 'package:flight_app/widgets/flight/flight_summary.dart';
import 'package:flight_app/widgets/flight/flight_summary_wide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightDetailPackage extends StatefulWidget {
  const FlightDetailPackage({super.key});

  @override
  State<FlightDetailPackage> createState() => _FlightDetailPackageState();
}

class _FlightDetailPackageState extends State<FlightDetailPackage> {
  late FlightPackage? _pkg;
  late double _basePrice;
  late double _discount;
  late double _finalPrice;

  @override
  void initState() {
    super.initState();
    _pkg = Get.arguments as FlightPackage?;
    _basePrice = _pkg?.price ?? 1000;
    _discount = _pkg?.discount ?? 5;
    _finalPrice = _basePrice - _basePrice * _discount / 100;
  }

  /// Find airport by matching city name to airport location; fall back to a stub.
  Airport _airportForCity(City city) {
    try {
      return airportList.firstWhere(
        (a) => a.location.toLowerCase() == city.name.toLowerCase(),
      );
    } catch (_) {
      return Airport(
        id: '0',
        code: city.code.length >= 3
            ? city.code.substring(0, 3).toUpperCase()
            : city.code.toUpperCase(),
        name: '${city.name} Airport',
        location: city.name,
      );
    }
  }

  /// Build a simple 2-point route for display (depart → arrival).
  List<FlightRoute> _buildRoutes(City from, City to, DateTime base) {
    return [
      FlightRoute(
        id: '1',
        airport: _airportForCity(from),
        time: DateTime(base.year, base.month, base.day, 9, 0),
        type: RouteType.depart,
      ),
      FlightRoute(
        id: '2',
        airport: _airportForCity(to),
        time: DateTime(base.year, base.month, base.day, 11, 30),
        type: RouteType.arrival,
      ),
    ];
  }

  void _onBookNow() {
    final pkg = _pkg;
    final City fromCity = pkg?.from ?? cityList[0];
    final City toCity = pkg?.to ?? cityList[6];
    final Airport fromAirport = _airportForCity(fromCity);
    final Airport toAirport = _airportForCity(toCity);
    final bool isRoundTrip = pkg?.roundTrip ?? false;
    // For round-trip the package price covers both legs; split evenly so the
    // booking screen sums back to _finalPrice correctly.
    final double legPrice = isRoundTrip ? _finalPrice / 2 : _finalPrice;

    final FlightResult outbound = FlightResult(
      id: pkg?.id ?? '0',
      airlineName: pkg?.plane.name ?? 'Airline',
      airlineCode: pkg?.plane.code ?? 'N/A',
      airlineLogo: pkg?.plane.logo ?? '',
      departureTime: '09:00',
      arrivalTime: '11:30',
      duration: '2h 30m',
      stops: 0,
      stopCities: [],
      price: legPrice,
      isRefundable: pkg?.hasRefund ?? false,
      cabinClass: pkg?.plane.classType ?? 'Economy',
    );

    final FlightResult? returnFlight = isRoundTrip
        ? FlightResult(
            id: '${pkg?.id ?? '0'}_ret',
            airlineName: pkg?.plane.name ?? 'Airline',
            airlineCode: pkg?.plane.code ?? 'N/A',
            airlineLogo: pkg?.plane.logo ?? '',
            departureTime: '12:00',
            arrivalTime: '14:30',
            duration: '2h 30m',
            stops: 0,
            stopCities: [],
            price: legPrice,
            isRefundable: pkg?.hasRefund ?? false,
            cabinClass: pkg?.plane.classType ?? 'Economy',
          )
        : null;

    final DateTime departDate = DateTime.now().add(const Duration(days: 7));
    final DateTime returnDate = departDate.add(const Duration(days: 7));

    Get.toNamed(
      AppLink.bookingStep1,
      arguments: {
        'isRoundTrip': isRoundTrip,
        'flight': outbound,
        'outboundFlight': isRoundTrip ? outbound : null,
        'returnFlight': returnFlight,
        'searchParams': {
          'fromAirport': fromAirport,
          'toAirport': toAirport,
          'departureDate': departDate,
          'returnDate': isRoundTrip ? returnDate : null,
          'adults': 1,
          'children': 0,
          'infants': 0,
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pkg = _pkg;
    final City fromCity = pkg?.from ?? cityList[0];
    final City toCity = pkg?.to ?? cityList[6];
    final Plane plane = pkg?.plane ?? planeList[0];
    final String label =
        pkg?.label ?? 'Discount ${_discount.toStringAsFixed(0)}%';

    final bool wideScreen = ThemeBreakpoints.smUp(context);
    final DateTime now = DateTime.now();
    final List<FlightRoute> departRoutes =
        _buildRoutes(fromCity, toCity, now.add(const Duration(days: 7)));
    final List<FlightRoute> returnRoutes = (pkg?.roundTrip ?? false)
        ? _buildRoutes(toCity, fromCity, now.add(const Duration(days: 14)))
        : departRoute; // fallback static; only shown for round-trip

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: colorScheme(context).surface,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.transparent,
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
        actions: [
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
                onPressed: () {
                  Get.toNamed(AppLink.faq);
                },
                style: ThemeButton.iconBtn(context),
                icon: Icon(Icons.help_outline_rounded,
                    color: colorScheme(context).onSurface, size: 18)),
          ),
          SizedBox(
            width: spacingUnit(2),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.topCenter, children: [
          /// DECORATION BG
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(pkg?.img ?? ImgApi.photo[53]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// DECORATION ROUNDED
          Positioned(
            top: 120,
            left: -10,
            child: CustomPaint(
              painter: OvalShape(
                  color: colorScheme(context).surfaceContainerLowest,
                  width: MediaQuery.of(context).size.width + 20),
            ),
          ),

          /// CONTENTS
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 50),
            wideScreen
                ? FlightSummaryWide(
                    from: fromCity,
                    to: toCity,
                    price: _basePrice,
                    discount: _discount,
                    label: label,
                    plane: plane,
                  )
                : FlightSummary(
                    from: fromCity,
                    to: toCity,
                    price: _basePrice,
                    discount: _discount,
                    label: label,
                    plane: plane,
                  ),
            wideScreen
                ? FlightRoutesHorizontal(
                    title: 'Departure', routes: departRoutes)
                : FlightRoutes(title: 'Departure', routes: departRoutes),
            if (pkg?.roundTrip ?? false) ...[
              wideScreen
                  ? FlightRoutesHorizontal(
                      title: 'Return', routes: returnRoutes)
                  : FlightRoutes(title: 'Return', routes: returnRoutes),
            ],
            const VSpaceBig(),
          ])
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        shadowColor: Colors.black,
        height: 80,
        color: colorScheme(context).surface,
        padding: EdgeInsets.symmetric(
            horizontal: spacingUnit(2), vertical: spacingUnit(1)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              wideScreen
                  ? SizedBox(width: MediaQuery.of(context).size.width * 0.5)
                  : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PKR ${_basePrice.toStringAsFixed(0)}',
                      textAlign: TextAlign.end,
                      style: ThemeText.headline.copyWith(
                          color: colorScheme(context).onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                          height: 1)),
                  Text('PKR ${_finalPrice.toStringAsFixed(0)}',
                      textAlign: TextAlign.end,
                      style: ThemeText.title.copyWith(
                          color: colorScheme(context).primary,
                          height: 1,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: spacingUnit(3)),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                      onPressed: _onBookNow,
                      style: ThemeButton.btnBig.merge(ThemeButton.primary),
                      child:
                          const Text('BOOK NOW', style: ThemeText.subtitle2)),
                ),
              )
            ]),
      ),
    );
  }
}
