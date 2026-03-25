import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/utils/location_preference_service.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_button.dart';

/// Professional city selection bottom sheet shown after authentication
/// Industry-standard approach used by MakeMyTrip, Uber, Booking.com
/// Personalizes destination content based on user's location
class CitySelectionSheet extends StatefulWidget {
  final VoidCallback onComplete;

  const CitySelectionSheet({super.key, required this.onComplete});

  @override
  State<CitySelectionSheet> createState() => _CitySelectionSheetState();
}

class _CitySelectionSheetState extends State<CitySelectionSheet>
    with SingleTickerProviderStateMixin {
  String? _selectedCity;
  String? _selectedCode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Comprehensive Pakistani cities list - Professional standard (Bookme.pk, Sastaticket.pk)
  // Covers all provinces, major cities, and popular tourist destinations
  final List<Map<String, String>> _allCities = [
    // Punjab - Major Cities
    {'name': 'Lahore', 'code': 'LHE', 'icon': '🕌', 'province': 'Punjab'},
    {'name': 'Faisalabad', 'code': 'LYP', 'icon': '🏭', 'province': 'Punjab'},
    {'name': 'Rawalpindi', 'code': 'RWP', 'icon': '🏙️', 'province': 'Punjab'},
    {'name': 'Multan', 'code': 'MUX', 'icon': '🌾', 'province': 'Punjab'},
    {'name': 'Gujranwala', 'code': 'GUJ', 'icon': '🏺', 'province': 'Punjab'},
    {'name': 'Sialkot', 'code': 'SKT', 'icon': '⚽', 'province': 'Punjab'},
    {'name': 'Bahawalpur', 'code': 'BHV', 'icon': '🕌', 'province': 'Punjab'},
    {'name': 'Sargodha', 'code': 'SGD', 'icon': '🌾', 'province': 'Punjab'},
    {'name': 'Sahiwal', 'code': 'SWL', 'icon': '🌾', 'province': 'Punjab'},
    {'name': 'Jhang', 'code': 'JHG', 'icon': '🏛️', 'province': 'Punjab'},

    // Islamabad & Sindh
    {'name': 'Islamabad', 'code': 'ISB', 'icon': '🏛️', 'province': 'ICT'},
    {'name': 'Karachi', 'code': 'KHI', 'icon': '🌊', 'province': 'Sindh'},
    {'name': 'Hyderabad', 'code': 'HDD', 'icon': '🏙️', 'province': 'Sindh'},
    {'name': 'Sukkur', 'code': 'SKZ', 'icon': '🌉', 'province': 'Sindh'},
    {'name': 'Larkana', 'code': 'LRK', 'icon': '🏛️', 'province': 'Sindh'},
    {'name': 'Nawabshah', 'code': 'NWB', 'icon': '🌾', 'province': 'Sindh'},

    // Khyber Pakhtunkhwa (KPK)
    {'name': 'Peshawar', 'code': 'PEW', 'icon': '🏔️', 'province': 'KPK'},
    {'name': 'Abbottabad', 'code': 'ATD', 'icon': '⛰️', 'province': 'KPK'},
    {'name': 'Mardan', 'code': 'MRD', 'icon': '🏛️', 'province': 'KPK'},
    {'name': 'Swat', 'code': 'SWT', 'icon': '🏔️', 'province': 'KPK'},
    {'name': 'Mansehra', 'code': 'MSH', 'icon': '⛰️', 'province': 'KPK'},

    // Balochistan
    {'name': 'Quetta', 'code': 'UET', 'icon': '⛰️', 'province': 'Balochistan'},
    {'name': 'Gwadar', 'code': 'GWD', 'icon': '🌊', 'province': 'Balochistan'},
    {'name': 'Turbat', 'code': 'TUK', 'icon': '🏜️', 'province': 'Balochistan'},

    // Gilgit-Baltistan (Tourist Destinations)
    {'name': 'Gilgit', 'code': 'GIL', 'icon': '🏔️', 'province': 'GB'},
    {'name': 'Skardu', 'code': 'KDU', 'icon': '⛰️', 'province': 'GB'},
    {'name': 'Hunza', 'code': 'HNZ', 'icon': '🏔️', 'province': 'GB'},

    // AJK (Azad Jammu & Kashmir)
    {'name': 'Muzaffarabad', 'code': 'MFD', 'icon': '🏔️', 'province': 'AJK'},
    {'name': 'Mirpur', 'code': 'MJL', 'icon': '🏛️', 'province': 'AJK'},
  ];

  List<Map<String, String>> get _filteredCities {
    if (_searchQuery.isEmpty) {
      return _allCities;
    }
    return _allCities.where((city) {
      return city['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          city['code']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          city['province']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.all(spacingUnit(3)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar for visual indication
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: spacingUnit(2)),
                decoration: BoxDecoration(
                  color: colorScheme(context).outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header with icon
              Container(
                padding: EdgeInsets.all(spacingUnit(2)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme(context).primaryContainer,
                      colorScheme(context).secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 48,
                      color: colorScheme(context).primary,
                    ),
                    SizedBox(height: spacingUnit(1)),
                    Text(
                      '📍 Which city are you in?',
                      style: ThemeText.title2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).onSurface,
                      ),
                    ),
                    SizedBox(height: spacingUnit(0.5)),
                    Text(
                      'We\'ll show you relevant destinations and accurate travel times from your location',
                      style: ThemeText.caption.copyWith(
                        color: colorScheme(context)
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacingUnit(3)),

              // Search bar (Pakistani app standard - Bookme.pk style)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme(context).surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme(context).outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search city or code...',
                    hintStyle: ThemeText.caption.copyWith(
                      color:
                          colorScheme(context).onSurface.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme(context).primary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: colorScheme(context)
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacingUnit(2),
                      vertical: spacingUnit(1.5),
                    ),
                  ),
                ),
              ),

              SizedBox(height: spacingUnit(2)),

              // Results count
              if (_searchQuery.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: spacingUnit(1)),
                  child: Text(
                    '${_filteredCities.length} cities found',
                    style: ThemeText.caption.copyWith(
                      color: colorScheme(context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // City selection grid (scrollable)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = _selectedCity == city['name'];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCity = city['name'];
                            _selectedCode = city['code'];
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      colorScheme(context).primary,
                                      colorScheme(context)
                                          .primary
                                          .withOpacity(0.8),
                                    ],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : colorScheme(context).surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme(context).primary
                                  : colorScheme(context)
                                      .outline
                                      .withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorScheme(context)
                                          .primary
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                city['icon']!,
                                style: TextStyle(
                                  fontSize: 24,
                                  shadows: isSelected
                                      ? [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                              SizedBox(height: spacingUnit(0.5)),
                              Text(
                                city['name']!,
                                style: ThemeText.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isSelected
                                      ? Colors.white
                                      : colorScheme(context).onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                city['code']!,
                                style: ThemeText.caption.copyWith(
                                  fontSize: 10,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : colorScheme(context)
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: spacingUnit(3)),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _selectedCity == null
                      ? null
                      : () async {
                          // Save preference to SharedPreferences
                          await LocationPreferenceService.setOriginCity(
                            _selectedCity!,
                            _selectedCode!,
                          );

                          // Show professional confirmation message
                          Get.snackbar(
                            '✅ Location Set',
                            'Showing destinations from $_selectedCity',
                            backgroundColor: Colors.green.shade600,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 2),
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white),
                            borderRadius: 10,
                            margin: const EdgeInsets.all(10),
                          );

                          // Close sheet and continue to home
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                          widget.onComplete();
                        },
                  style: ThemeButton.btnBig.merge(ThemeButton.primary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline),
                      SizedBox(width: spacingUnit(1)),
                      const Text('CONTINUE', style: ThemeText.subtitle),
                    ],
                  ),
                ),
              ),

              SizedBox(height: spacingUnit(1)),

              // Skip button with default fallback
              TextButton(
                onPressed: () async {
                  // Set default to Karachi (largest city, most connections)
                  await LocationPreferenceService.setOriginCity(
                      'Karachi', 'KHI');

                  Get.snackbar(
                    'ℹ️ Default Location',
                    'Using Karachi as your location',
                    backgroundColor: Colors.blue.shade600,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 2),
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    borderRadius: 10,
                    margin: const EdgeInsets.all(10),
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  widget.onComplete();
                },
                child: Text(
                  'Skip (Use Karachi as default)',
                  style: ThemeText.caption.copyWith(
                    color:
                        colorScheme(context).onSurface.withValues(alpha: 0.6),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              SizedBox(height: spacingUnit(1)),

              // Info text
              Container(
                padding: EdgeInsets.all(spacingUnit(1.5)),
                decoration: BoxDecoration(
                  color: colorScheme(context).surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color:
                          colorScheme(context).onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: spacingUnit(1)),
                    Expanded(
                      child: Text(
                        'You can change this anytime from Settings',
                        style: ThemeText.caption.copyWith(
                          fontSize: 11,
                          color: colorScheme(context)
                              .onSurface
                              .withValues(alpha: 0.6),
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
