import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flight_app/components/home/service_tabs.dart';
import 'package:flight_app/components/home/hero_section.dart';
import 'package:flight_app/widgets/home/quick_search_bar.dart';
import 'package:flight_app/widgets/home/quick_access_features.dart';
import 'package:flight_app/widgets/home/dynamic_destination_cards.dart';
import 'package:flight_app/widgets/home/package_list_slider.dart';
import 'package:flight_app/widgets/home/train_package_slider.dart';
import 'package:flight_app/widgets/home/flight_list_double.dart';
import 'package:flight_app/widgets/home/news_list.dart';
import 'package:flight_app/widgets/home/travello_footer.dart';
import 'package:flight_app/widgets/bottom_nav/bottom_nav_menu.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/utils/auth_service.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/destination.dart';

/// 🔥 TRAVELLO AI - UNIFIED HOME SCREEN
///
/// Enterprise-grade unified booking hub following Wego architecture
///
/// ## Features:
/// - ✅ Single entry point for Flight, Train, Hotel booking
/// - ✅ Dynamic hero section with smooth transitions
/// - ✅ No UI duplication - navigates to existing screens
/// - ✅ Premium animations and glassmorphism design
/// - ✅ Scalable for future services
///
/// ## Architecture Benefits (FYP Defense):
/// 1. **Centralized State**: Single `selectedService` state drives all UI
/// 2. **No Duplication**: Reuses existing booking screens
/// 3. **Scalability**: Easy to add new services (Bus, Car Rental)
/// 4. **Clean Separation**: Presentation vs Business Logic
/// 5. **Wego-Inspired**: Aggregator pattern for travel services
///
/// @author Travello AI Team
/// @version 2.0 - Unified Hub Architecture
class UnifiedHomeScreen extends StatefulWidget {
  const UnifiedHomeScreen({super.key});

  @override
  State<UnifiedHomeScreen> createState() => _UnifiedHomeScreenState();
}

class _UnifiedHomeScreenState extends State<UnifiedHomeScreen> {
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🎯 CORE STATE - Single source of truth
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  String _selectedService = 'flight'; // flight | train | hotel

  // User state
  String _userName = 'User';
  String _userAvatar = '';
  bool _isGuest = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Load current user from AuthService
  Future<void> _loadUserProfile() async {
    final isGuest = await AuthService.isGuestMode();
    setState(() {
      _isGuest = isGuest;
    });

    if (isGuest) {
      final guestUser = AuthService.getGuestUser();
      setState(() {
        _userName = guestUser['name'];
        _userAvatar = '';
      });
    } else {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        setState(() {
          _userName = user['name'] ?? 'User';
          _userAvatar = user['avatar'] ?? '';
        });
      }
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🚀 NAVIGATION LOGIC - Routes to existing booking screens
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void _navigateToBooking() {
    switch (_selectedService) {
      case 'flight':
        Get.toNamed('/flight-search-home');
        break;
      case 'train':
        Get.toNamed('/train-search-home');
        break;
      case 'hotel':
        Get.toNamed(AppLink.hotelSearch);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).surface,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: const BottomNavMenu(),

      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 📱 APP BAR - Transparent with user profile
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade600.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: spacingUnit(2)),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppLink.profile),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: _userAvatar.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          _userAvatar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      )
                    : Icon(
                        CupertinoIcons.person_fill,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () => Get.toNamed(AppLink.profile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isGuest ? 'Guest Mode' : 'Welcome back',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.bell,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              onPressed: () => Get.toNamed(AppLink.notification),
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.chat_bubble_text,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              onPressed: () => Get.toNamed(AppLink.notification),
            ),
          ],
        ),
      ),

      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 📜 MAIN BODY - Scrollable content
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 🌟 HERO SECTION - Dynamic background & CTA
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Stack(
              children: [
                HeroSection(
                  serviceType: _selectedService,
                  onCtaTap: _navigateToBooking,
                ),

                // Service tabs overlay (positioned at bottom of hero)
                Positioned(
                  bottom: spacingUnit(3),
                  left: spacingUnit(2),
                  right: spacingUnit(2),
                  child: ServiceTabs(
                    selectedService: _selectedService,
                    onServiceChanged: (service) {
                      setState(() {
                        _selectedService = service;
                      });
                    },
                  ),
                ),
              ],
            ),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 🔍 QUICK SEARCH BAR
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            SizedBox(height: spacingUnit(2)),
            const QuickSearchBar(),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // ⚡ FEATURES SECTION
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            SizedBox(height: spacingUnit(3)),
            const QuickAccessFeatures(),

            SizedBox(height: spacingUnit(3)),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // � DYNAMIC SECTIONS - Changes based on selected service
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            _buildDynamicContent(),

            SizedBox(height: spacingUnit(3)),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 📰 NEWS & UPDATES SECTION (Common for all)
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            const NewsList(),

            SizedBox(height: spacingUnit(3)),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 🔗 FOOTER SECTION
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            const TravelloFooter(),

            SizedBox(height: spacingUnit(10)), // Bottom nav clearance
          ],
        ),
      ),
    );
  }

  /// Features section with AI Assistant, Weather, Healthcare
  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Travello AI Features',
                style: ThemeText.title2.copyWith(
                  color: colorScheme(context).onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(1.5),
                  vertical: spacingUnit(0.5),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.sparkles,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: spacingUnit(0.5)),
                    const Text(
                      'All-in-One',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(2)),
          _buildFeatureCard(
            icon: CupertinoIcons.chat_bubble_text_fill,
            title: 'AI Assistant',
            subtitle: 'Smart travel companion',
            gradient: const [Color(0xFF7C3AED), Color(0xFFA855F7)],
            onTap: () => Get.toNamed(AppLink.aiAssistant),
          ),
          SizedBox(height: spacingUnit(1.5)),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: CupertinoIcons.cloud_sun_fill,
                  title: 'Weather',
                  subtitle: 'Forecasts',
                  gradient: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                  onTap: () => Get.toNamed(AppLink.weather),
                  isCompact: true,
                ),
              ),
              SizedBox(width: spacingUnit(1.5)),
              Expanded(
                child: _buildFeatureCard(
                  icon: CupertinoIcons.heart_fill,
                  title: 'Healthcare',
                  subtitle: 'Emergency',
                  gradient: const [Color(0xFFEF4444), Color(0xFFF87171)],
                  onTap: () => Get.toNamed(AppLink.healthcare),
                  isCompact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isCompact = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(spacingUnit(isCompact ? 2 : 2.5)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacingUnit(1.5)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isCompact ? 20 : 24,
                ),
              ),
              SizedBox(width: spacingUnit(1.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isCompact ? 11 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// 🎯 DYNAMIC CONTENT - Changes based on selected service
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildDynamicContent() {
    switch (_selectedService) {
      case 'flight':
        return _buildFlightContent();
      case 'train':
        return _buildTrainContent();
      case 'hotel':
        return _buildHotelContent();
      default:
        return _buildFlightContent();
    }
  }

  /// ✈️ Flight-specific content
  Widget _buildFlightContent() {
    return Column(
      children: [
        // Top Flight Destinations
        DynamicDestinationCards(
          destinations: flightDestinations,
          travelMode: 'flight',
        ),
        SizedBox(height: spacingUnit(4)),

        // Featured Flight Packages
        const PackageListSlider(),
        SizedBox(height: spacingUnit(4)),

        // More Flight Routes
        const FlightListDouble(),
        SizedBox(height: spacingUnit(3)),
      ],
    );
  }

  /// 🚆 Train-specific content
  Widget _buildTrainContent() {
    return Column(
      children: [
        // Popular Train Routes
        DynamicDestinationCards(
          destinations: trainDestinations,
          travelMode: 'train',
        ),
        SizedBox(height: spacingUnit(4)),

        // Featured Train Journeys
        const TrainPackageSlider(),
        SizedBox(height: spacingUnit(4)),

        // Train Benefits Section
        _buildTrainBenefitsSection(),
        SizedBox(height: spacingUnit(3)),
      ],
    );
  }

  /// 🏨 Hotel-specific content
  Widget _buildHotelContent() {
    return Column(
      children: [
        // Top Tourist Destinations
        DynamicDestinationCards(
          destinations: hotelDestinations,
          travelMode: 'hotel',
        ),
        SizedBox(height: spacingUnit(4)),

        // Featured Hotel Packages (reuse flight packages styled differently)
        _buildHotelPackagesSection(),
        SizedBox(height: spacingUnit(3)),
      ],
    );
  }

  /// Train benefits info section
  Widget _buildTrainBenefitsSection() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 1200
            ? spacingUnit(8)
            : spacingUnit(2),
      ),
      padding: EdgeInsets.all(spacingUnit(3)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Pakistan Railways?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: spacingUnit(2)),
          _buildBenefitItem(
            CupertinoIcons.money_dollar_circle,
            'Affordable Fares',
            'Travel across Pakistan at budget-friendly prices',
          ),
          SizedBox(height: spacingUnit(1.5)),
          _buildBenefitItem(
            CupertinoIcons.bed_double,
            'Comfortable Sleepers',
            'AC sleeper & business class for long journeys',
          ),
          SizedBox(height: spacingUnit(1.5)),
          _buildBenefitItem(
            CupertinoIcons.timer,
            'Scenic Routes',
            'Enjoy beautiful landscapes on ML-1 main line',
          ),
          SizedBox(height: spacingUnit(1.5)),
          _buildBenefitItem(
            CupertinoIcons.checkmark_shield,
            'Safe & Reliable',
            'Operated by Pakistan Railways since 1861',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(spacingUnit(1.5)),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(width: spacingUnit(2)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Hotel packages section
  Widget _buildHotelPackagesSection() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 1200
            ? spacingUnit(8)
            : spacingUnit(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Hotel Packages',
                    style: ThemeText.title2.copyWith(
                      color: colorScheme(context).onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacingUnit(0.5)),
                  Text(
                    'Curated stays in Pakistan\'s most beautiful locations',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          colorScheme(context).onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed(AppLink.hotelSearch),
                icon: const Icon(CupertinoIcons.arrow_right_circle_fill,
                    size: 18),
                label: const Text('Browse Hotels'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(2)),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hotelDestinations.take(6).length,
              itemBuilder: (context, index) {
                final destination = hotelDestinations[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(AppLink.hotelSearch, arguments: {
                    'destination': destination.name,
                  }),
                  child: Container(
                    width: 240,
                    margin: EdgeInsets.only(right: spacingUnit(2)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              destination.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        destination.cardColor,
                                        destination.cardColor
                                            .withValues(alpha: 0.8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: EdgeInsets.all(spacingUnit(2)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    CupertinoIcons.building_2_fill,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  if (destination.popularityRank <= 3)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: spacingUnit(1),
                                        vertical: spacingUnit(0.5),
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Top ${destination.popularityRank}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    destination.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: spacingUnit(0.5)),
                                  Text(
                                    destination.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
