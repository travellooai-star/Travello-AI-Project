import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pakistan destination data model
// ─────────────────────────────────────────────────────────────────────────────
class _PakDestination {
  final String name;
  final String province;
  final String tagline;
  final String imageUrl;
  final String category; // matches ExploreCategoryFilter labels
  final Color accentColor;
  final String flightCode; // IATA or nearest airport code
  final List<String> highlights;

  const _PakDestination({
    required this.name,
    required this.province,
    required this.tagline,
    required this.imageUrl,
    required this.category,
    required this.accentColor,
    required this.flightCode,
    required this.highlights,
  });
}

const List<_PakDestination> _pakDestinations = [
  // ── ADVENTURE ──────────────────────────────────────────────────────────────
  _PakDestination(
    name: 'Hunza Valley',
    province: 'Gilgit-Baltistan',
    tagline: 'Heaven on Earth',
    imageUrl:
        'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&q=80',
    category: 'Adventure',
    accentColor: Color(0xFF1565C0),
    flightCode: 'GIL',
    highlights: ['K2 Trek', 'Attabad Lake', 'Baltit Fort'],
  ),
  _PakDestination(
    name: 'Skardu',
    province: 'Gilgit-Baltistan',
    tagline: 'Gateway to K2',
    imageUrl:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
    category: 'Adventure',
    accentColor: Color(0xFF4527A0),
    flightCode: 'SKD',
    highlights: ['K2 Base Camp', 'Deosai Plains', 'Shangrila'],
  ),
  _PakDestination(
    name: 'Swat Valley',
    province: 'KPK',
    tagline: 'Switzerland of Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&q=80',
    category: 'Adventure',
    accentColor: Color(0xFF1B5E20),
    flightCode: 'PEW',
    highlights: ['Malam Jabba Ski', 'Mahodand Lake', 'Madyan'],
  ),
  _PakDestination(
    name: 'Naran & Kaghan',
    province: 'KPK',
    tagline: 'Land of Glacial Lakes',
    imageUrl:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
    category: 'Adventure',
    accentColor: Color(0xFF006064),
    flightCode: 'ISB',
    highlights: ['Saiful Muluk Lake', 'Babusar Top', 'Lulusar Lake'],
  ),

  // ── MOUNTAINS ──────────────────────────────────────────────────────────────
  _PakDestination(
    name: 'Fairy Meadows',
    province: 'Gilgit-Baltistan',
    tagline: 'Base of Nanga Parbat',
    imageUrl:
        'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=800&q=80',
    category: 'Mountains',
    accentColor: Color(0xFF37474F),
    flightCode: 'GIL',
    highlights: ['Nanga Parbat View', 'Raikot Glacier', 'Beyal Camp'],
  ),
  _PakDestination(
    name: 'Gilgit',
    province: 'Gilgit-Baltistan',
    tagline: 'Where Rivers Meet',
    imageUrl:
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=800&q=80',
    category: 'Mountains',
    accentColor: Color(0xFF4E342E),
    flightCode: 'GIL',
    highlights: ['Rakaposhi Base', 'Naltar Valley', 'Jutial Gorge'],
  ),
  _PakDestination(
    name: 'Chitral',
    province: 'KPK',
    tagline: 'Roof of KPK',
    imageUrl:
        'https://images.unsplash.com/photo-1527786356703-4b100091cd2c?w=800&q=80',
    category: 'Mountains',
    accentColor: Color(0xFF263238),
    flightCode: 'CJL',
    highlights: ['Tirich Mir', 'Kalash Festival', 'Shandur Polo'],
  ),

  // ── BEACHES ────────────────────────────────────────────────────────────────
  _PakDestination(
    name: 'Gwadar',
    province: 'Balochistan',
    tagline: 'Pearl of the Arabian Sea',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
    category: 'Beaches',
    accentColor: Color(0xFF006064),
    flightCode: 'GWD',
    highlights: ['Hammerhead Beach', 'Ormara Beach', 'China-Pak Port'],
  ),
  _PakDestination(
    name: 'Karachi Beaches',
    province: 'Sindh',
    tagline: 'Clifton & French Beach',
    imageUrl:
        'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800&q=80',
    category: 'Beaches',
    accentColor: Color(0xFF0277BD),
    flightCode: 'KHI',
    highlights: ['Clifton Beach', 'French Beach', 'Hawks Bay'],
  ),
  _PakDestination(
    name: 'Kund Malir',
    province: 'Balochistan',
    tagline: 'Pristine Coastal Gem',
    imageUrl:
        'https://images.unsplash.com/photo-1506953823976-52e1fdc0149a?w=800&q=80',
    category: 'Beaches',
    accentColor: Color(0xFF00796B),
    flightCode: 'KHI',
    highlights: ['Crystal Water', 'Desert Cliffs', 'Camping'],
  ),

  // ── HISTORICAL ─────────────────────────────────────────────────────────────
  _PakDestination(
    name: 'Lahore',
    province: 'Punjab',
    tagline: 'Cultural Heart of Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1584204687456-cbed5e3c1e82?w=800&q=80',
    category: 'Historical',
    accentColor: Color(0xFF880E4F),
    flightCode: 'LHE',
    highlights: ['Badshahi Mosque', 'Lahore Fort', 'Walled City'],
  ),
  _PakDestination(
    name: 'Peshawar',
    province: 'KPK',
    tagline: 'Ancient Gandhara Heritage',
    imageUrl:
        'https://images.unsplash.com/photo-1539136788836-5699e78bfc75?w=800&q=80',
    category: 'Historical',
    accentColor: Color(0xFF4A148C),
    flightCode: 'PEW',
    highlights: [
      'Qissa Khwani Bazaar',
      'Masjid Mahabat Khan',
      'Bala Hisar Fort'
    ],
  ),
  _PakDestination(
    name: 'Mohenjo-daro',
    province: 'Sindh',
    tagline: 'Indus Valley Civilization',
    imageUrl:
        'https://images.unsplash.com/photo-1548705085-101177834f47?w=800&q=80',
    category: 'Historical',
    accentColor: Color(0xFF5D4037),
    flightCode: 'MJD',
    highlights: ['Great Bath', 'Dancing Girl', '4000-Year History'],
  ),
  _PakDestination(
    name: 'Taxila',
    province: 'Punjab',
    tagline: 'Ancient Buddhist City',
    imageUrl:
        'https://images.unsplash.com/photo-1548013146-72479768bada?w=800&q=80',
    category: 'Historical',
    accentColor: Color(0xFF3E2723),
    flightCode: 'ISB',
    highlights: ['Dharmarajika Stupa', 'Taxila Museum', 'Jaulian'],
  ),

  // ── NATURE ─────────────────────────────────────────────────────────────────
  _PakDestination(
    name: 'Neelum Valley',
    province: 'AJK',
    tagline: 'Jewel of Azad Kashmir',
    imageUrl:
        'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&q=80',
    category: 'Nature',
    accentColor: Color(0xFF1B5E20),
    flightCode: 'ISB',
    highlights: ['Neelum River', 'Arang Kel', 'Ratti Gali Lake'],
  ),
  _PakDestination(
    name: 'Deosai Plains',
    province: 'Gilgit-Baltistan',
    tagline: 'World\'s 2nd Highest Plateau',
    imageUrl:
        'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800&q=80',
    category: 'Nature',
    accentColor: Color(0xFF33691E),
    flightCode: 'SKZ',
    highlights: ['Brown Bears', 'Wildflower Meadows', 'Sheosar Lake'],
  ),
  _PakDestination(
    name: 'Quetta',
    province: 'Balochistan',
    tagline: 'City of Fruit Gardens',
    imageUrl:
        'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=800&q=80',
    category: 'Nature',
    accentColor: Color(0xFF558B2F),
    flightCode: 'UET',
    highlights: ['Hanna Lake', 'Hazarganji Chiltan', 'Quaid Residency'],
  ),

  // ── CITIES ─────────────────────────────────────────────────────────────────
  _PakDestination(
    name: 'Islamabad',
    province: 'Federal Capital',
    tagline: 'Modern Green Capital',
    imageUrl:
        'https://images.unsplash.com/photo-1578895101408-1a36b834405b?w=800&q=80',
    category: 'Cities',
    accentColor: Color(0xFF1A237E),
    flightCode: 'ISB',
    highlights: ['Faisal Mosque', 'Daman-e-Koh', 'Margalla Hills'],
  ),
  _PakDestination(
    name: 'Multan',
    province: 'Punjab',
    tagline: 'City of Saints',
    imageUrl:
        'https://images.unsplash.com/photo-1605649487212-47bdab064df7?w=800&q=80',
    category: 'Cities',
    accentColor: Color(0xFFE65100),
    flightCode: 'MUX',
    highlights: ['Bahauddin Zakariya Shrine', 'Multan Fort', 'Blue Pottery'],
  ),
  _PakDestination(
    name: 'Faisalabad',
    province: 'Punjab',
    tagline: 'Industrial Hub & Textile City',
    imageUrl:
        'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&q=80',
    category: 'Cities',
    accentColor: Color(0xFF827717),
    flightCode: 'LYP',
    highlights: ['Clock Tower', 'Lyallpur Museum', 'Food Street'],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Explore Destinations Section Widget
// ─────────────────────────────────────────────────────────────────────────────
class ExploreDestinationsSection extends StatelessWidget {
  final String selectedCategory;

  const ExploreDestinationsSection({
    super.key,
    required this.selectedCategory,
  });

  List<_PakDestination> get _filtered {
    if (selectedCategory == 'All') return _pakDestinations;
    return _pakDestinations
        .where((d) => d.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _filtered;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final crossCount = isDesktop ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacingUnit(2),
            vertical: spacingUnit(1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCategory == 'All'
                        ? 'Explore Pakistan'
                        : '$selectedCategory in Pakistan',
                    style: ThemeText.title2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacingUnit(0.3)),
                  Text(
                    '${destinations.length} destinations',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          colorScheme(context).onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.map,
                color: ThemePalette.primaryMain,
                size: 20,
              ),
            ],
          ),
        ),

        // Grid of destination cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacingUnit(1.5)),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              childAspectRatio: 0.72,
              crossAxisSpacing: spacingUnit(1.5),
              mainAxisSpacing: spacingUnit(1.5),
            ),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              return _DestinationCard(destination: destinations[index]);
            },
          ),
        ),
        SizedBox(height: spacingUnit(2)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual destination card
// ─────────────────────────────────────────────────────────────────────────────
class _DestinationCard extends StatelessWidget {
  final _PakDestination destination;

  const _DestinationCard({required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppLink.flightSearchHome,
        arguments: {
          'toCode': destination.flightCode,
          'toCity': destination.name
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: destination.accentColor.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.network(
                  destination.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: destination.accentColor,
                  ),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: destination.accentColor.withValues(alpha: 0.4),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Category badge (top-left)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: destination.accentColor.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    destination.category,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // Bookmark icon (top-right)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.bookmark,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),

              // Bottom content
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Province tag
                    Text(
                      destination.province.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // City name
                    Text(
                      destination.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Tagline
                    Text(
                      destination.tagline,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Highlights row
                    Wrap(
                      spacing: 4,
                      runSpacing: 3,
                      children: destination.highlights
                          .take(2)
                          .map((h) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  h,
                                  style: const TextStyle(
                                    fontSize: 8.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    // Book Flight button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.toNamed(
                          AppLink.flightSearchHome,
                          arguments: {
                            'toCode': destination.flightCode,
                            'toCity': destination.name
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemePalette.primaryMain,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          minimumSize: const Size(0, 30),
                        ),
                        icon: const Icon(CupertinoIcons.airplane, size: 12),
                        label: const Text(
                          'Book Flight',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
