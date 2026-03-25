import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/trip.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/flight_portrait_card.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CitySearchResults extends StatefulWidget {
  const CitySearchResults({super.key});

  @override
  State<CitySearchResults> createState() => _CitySearchResultsState();
}

class _CitySearchResultsState extends State<CitySearchResults>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String cityName = '';
  City? selectedCity;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Get city from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    cityName = args?['cityName'] ?? '';

    // Find city in cityList
    try {
      selectedCity = cityList.firstWhere(
          (city) => city.name.toLowerCase() == cityName.toLowerCase());
    } catch (e) {
      selectedCity = null;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Trip> _getDepartureFlights() {
    if (selectedCity == null) return [];
    return tripList
        .where((trip) => trip.from.name.toLowerCase() == cityName.toLowerCase())
        .take(10)
        .toList();
  }

  List<Trip> _getArrivalFlights() {
    if (selectedCity == null) return [];
    return tripList
        .where((trip) => trip.to.name.toLowerCase() == cityName.toLowerCase())
        .take(10)
        .toList();
  }

  List<Trip> _getPopularRoutes() {
    if (selectedCity == null) return [];
    return tripList
        .where((trip) =>
            trip.from.name.toLowerCase() == cityName.toLowerCase() ||
            trip.to.name.toLowerCase() == cityName.toLowerCase())
        .take(8)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCity == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
        ),
        body: const Center(
          child: Text('City not found'),
        ),
      );
    }

    final departureFlights = _getDepartureFlights();
    final arrivalFlights = _getArrivalFlights();
    final popularRoutes = _getPopularRoutes();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with City Info
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                cityName,
                style: ThemeText.title2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    selectedCity!.photos[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colorScheme(context).primary,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(spacingUnit(2)),
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                color: colorScheme(context).surfaceContainerLow,
                borderRadius: ThemeRadius.medium,
                boxShadow: [ThemeShade.shadeSoft(context)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.flight_takeoff,
                    '${departureFlights.length}',
                    'Departures',
                  ),
                  _buildStatItem(
                    context,
                    Icons.flight_land,
                    '${arrivalFlights.length}',
                    'Arrivals',
                  ),
                  _buildStatItem(
                    context,
                    Icons.route,
                    '${popularRoutes.length}',
                    'Routes',
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: colorScheme(context).primary,
                unselectedLabelColor: colorScheme(context).onSurfaceVariant,
                indicatorColor: colorScheme(context).primary,
                tabs: const [
                  Tab(text: 'Departures'),
                  Tab(text: 'Arrivals'),
                  Tab(text: 'Popular Routes'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFlightList(departureFlights, 'No departures found'),
                _buildFlightList(arrivalFlights, 'No arrivals found'),
                _buildFlightList(popularRoutes, 'No routes found'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: colorScheme(context).primary, size: 28),
        SizedBox(height: spacingUnit(0.5)),
        Text(
          value,
          style: ThemeText.title.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme(context).primary,
          ),
        ),
        Text(
          label,
          style: ThemeText.caption.copyWith(
            color: colorScheme(context).onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightList(List<Trip> flights, String emptyMessage) {
    if (flights.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flight_outlined,
              size: 64,
              color: colorScheme(context).outlineVariant,
            ),
            SizedBox(height: spacingUnit(2)),
            Text(
              emptyMessage,
              style: ThemeText.subtitle.copyWith(
                color: colorScheme(context).onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(spacingUnit(2)),
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final trip = flights[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacingUnit(2)),
          child: FlightPortraitCard(
            from: trip.from.code,
            to: trip.to.code,
            date: '${trip.depart.day}/${trip.depart.month}/${trip.depart.year}',
            price: trip.price,
            plane: trip.plane,
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: colorScheme(context).surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
