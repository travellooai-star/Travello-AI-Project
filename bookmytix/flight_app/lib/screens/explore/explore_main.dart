import 'package:flight_app/widgets/home/package_list_slider.dart';
import 'package:flight_app/widgets/home/promo_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/explore/banner.dart';
import 'package:flight_app/widgets/explore/header.dart';
import 'package:flight_app/widgets/explore/search.dart';
import 'package:flight_app/widgets/explore/explore_category_filter.dart';
import 'package:flight_app/widgets/explore/explore_destinations_section.dart';

class ExploreMain extends StatefulWidget {
  const ExploreMain({super.key});

  @override
  State<ExploreMain> createState() => _ExploreMainState();
}

class _ExploreMainState extends State<ExploreMain> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
            child: Stack(
          alignment: Alignment.topCenter,
          children: [
            /// BANNER ILLUSTRATION
            BannerExplore(),

            /// HEADER
            Positioned(child: SizedBox(child: HeaderExplore())),
          ],
        )),

        /// STICKY SEARCH + CATEGORY BAR
        SliverStickyHeader.builder(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// SEARCH BAR
                  const SearchExplore(),

                  /// CATEGORY FILTER CHIPS
                  Container(
                    color: colorScheme(context).surfaceContainerLowest,
                    padding: EdgeInsets.only(bottom: spacingUnit(1)),
                    child: ExploreCategoryFilter(
                      selected: _selectedCategory,
                      onSelect: (cat) =>
                          setState(() => _selectedCategory = cat),
                    ),
                  ),
                ],
              );
            },

            /// CONTENT BELOW STICKY HEADER
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: spacingUnit(1)),

              /// ── DESTINATION GRID (filterable, Pakistan only) ──
              ExploreDestinationsSection(
                selectedCategory: _selectedCategory,
              ),

              /// ── FEATURED PACKAGES ──
              const PackageListSlider(),
              SizedBox(height: spacingUnit(3)),

              /// ── PROMOTIONS ──
              const PromoSlider(),
              SizedBox(height: spacingUnit(3)),
            ]))),
      ],
    ));
  }
}
