import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  📱 PROFESSIONAL MY BOOKINGS PAGE
//  Industry-Level Design - Consistent UI for Train & Flight Bookings
//  Inspired by: MakeMyTrip, Cleartrip, Booking.com, Expedia
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _allBookings = [];
  List<Map<String, dynamic>> _filteredBookings = [];
  String _selectedFilter = 'All'; // All, Upcoming, Past, Canceled
  String _selectedType = 'All'; // All, Train, Flight
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);

    final bookings = await BookingService.getAllBookings();

    setState(() {
      _allBookings = bookings;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allBookings);

    // Filter by type
    if (_selectedType != 'All') {
      filtered = filtered
          .where((b) => b['bookingType'] == _selectedType.toLowerCase())
          .toList();
    }

    // Filter by status/time
    final now = DateTime.now();
    if (_selectedFilter == 'Upcoming') {
      filtered = filtered.where((b) {
        if (b['status'] == 'canceled') return false;

        final details = b['bookingType'] == 'train'
            ? b['trainDetails']
            : b['flightDetails'];

        if (details == null) return false;

        try {
          final dateStr = details['date'];
          final timeStr = details['departure'];
          if (dateStr == null || timeStr == null) return false;

          // Parse date (format: "dd MMM yyyy")
          final dateParts = dateStr.toString().split(' ');
          if (dateParts.length < 3) return false;

          final day = int.tryParse(dateParts[0]) ?? 1;
          final month = _monthToNumber(dateParts[1]);
          final year = int.tryParse(dateParts[2]) ?? DateTime.now().year;

          // Parse time (format: "HH:mm")
          final timeParts = timeStr.toString().split(':');
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute =
              timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

          final departureDateTime = DateTime(year, month, day, hour, minute);
          return departureDateTime.isAfter(now);
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Past') {
      filtered = filtered.where((b) {
        final details = b['bookingType'] == 'train'
            ? b['trainDetails']
            : b['flightDetails'];

        if (details == null) return true;

        try {
          final dateStr = details['date'];
          final timeStr = details['departure'];
          if (dateStr == null || timeStr == null) return true;

          final dateParts = dateStr.toString().split(' ');
          if (dateParts.length < 3) return true;

          final day = int.tryParse(dateParts[0]) ?? 1;
          final month = _monthToNumber(dateParts[1]);
          final year = int.tryParse(dateParts[2]) ?? DateTime.now().year;

          final timeParts = timeStr.toString().split(':');
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute =
              timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

          final departureDateTime = DateTime(year, month, day, hour, minute);
          return departureDateTime.isBefore(now);
        } catch (e) {
          return true;
        }
      }).toList();
    } else if (_selectedFilter == 'Canceled') {
      filtered = filtered.where((b) => b['status'] == 'canceled').toList();
    }

    setState(() {
      _filteredBookings = filtered;
    });
  }

  int _monthToNumber(String month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months.indexOf(month) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          // ━━━ Gradient App Bar with Stats ━━━
          _buildGradientAppBar(),

          // ━━━ Filter Tabs ━━━
          _buildFilterTabs(),

          // ━━━ Bookings List ━━━
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF0D9488),
                    ),
                    SizedBox(height: spacingUnit(2)),
                    Text('Loading your bookings...',
                        style: ThemeText.paragraph.copyWith(
                            color: colorScheme(context).onSurfaceVariant)),
                  ],
                ),
              ),
            )
          else if (_filteredBookings.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(spacingUnit(2)),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final booking = _filteredBookings[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: spacingUnit(2)),
                      child: _buildBookingCard(booking),
                    );
                  },
                  childCount: _filteredBookings.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎨 UI COMPONENTS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildGradientAppBar() {
    final upcomingCount = _allBookings.where((b) {
      final details =
          b['bookingType'] == 'train' ? b['trainDetails'] : b['flightDetails'];
      if (details == null) return false;
      // Simplified check - just check status
      return b['status'] != 'canceled';
    }).length;

    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0D9488),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D9488),
                Color(0xFF14B8A6),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Bookings',
                            style: ThemeText.title.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            '${_allBookings.length} Total • $upcomingCount Active',
                            style: ThemeText.paragraph.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(spacingUnit(1.5)),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.confirmation_number_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SliverToBoxAdapter(
      child: Container(
        color: colorScheme(context).surfaceContainerLowest,
        padding: EdgeInsets.all(spacingUnit(2)),
        child: Column(
          children: [
            // Type Filter (All, Train, Flight)
            Row(
              children: [
                _buildTypeChip('All', Icons.list_alt),
                SizedBox(width: spacingUnit(1)),
                _buildTypeChip('Train', Icons.train),
                SizedBox(width: spacingUnit(1)),
                _buildTypeChip('Flight', Icons.flight),
              ],
            ),
            SizedBox(height: spacingUnit(1.5)),
            // Status Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  SizedBox(width: spacingUnit(1)),
                  _buildFilterChip('Upcoming'),
                  SizedBox(width: spacingUnit(1)),
                  _buildFilterChip('Past'),
                  SizedBox(width: spacingUnit(1)),
                  _buildFilterChip('Canceled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    final isSelected = _selectedType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = label;
            _applyFilters();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: spacingUnit(1.5),
            vertical: spacingUnit(1),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0D9488)
                : colorScheme(context).surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0D9488)
                  : colorScheme(context).outline.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    isSelected ? Colors.white : colorScheme(context).onSurface,
              ),
              SizedBox(width: spacingUnit(0.5)),
              Text(
                label,
                style: ThemeText.subtitle2.copyWith(
                  color: isSelected
                      ? Colors.white
                      : colorScheme(context).onSurface,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
          _applyFilters();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: spacingUnit(2),
          vertical: spacingUnit(1),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D9488).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0D9488)
                : colorScheme(context).outline.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: ThemeText.paragraph.copyWith(
            color: isSelected
                ? const Color(0xFF0D9488)
                : colorScheme(context).onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final bookingType = booking['bookingType'] ?? 'flight';
    final isTrainBooking = bookingType == 'train';

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppLink.ticketDetail, arguments: booking);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ━━━ Header with Type Badge & Status ━━━
            Container(
              padding: EdgeInsets.all(spacingUnit(1.5)),
              decoration: BoxDecoration(
                color: isTrainBooking
                    ? const Color(0xFFF3F4F6)
                    : const Color(0xFFEFF6FF),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(1),
                          vertical: spacingUnit(0.5),
                        ),
                        decoration: BoxDecoration(
                          color: isTrainBooking
                              ? const Color(0xFF059669)
                              : const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isTrainBooking ? Icons.train : Icons.flight,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: spacingUnit(0.5)),
                            Text(
                              isTrainBooking ? 'TRAIN' : 'FLIGHT',
                              style: ThemeText.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacingUnit(1)),
                      Text(
                        'PNR: ${booking['pnr'] ?? 'N/A'}',
                        style: ThemeText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(booking['status'] ?? 'confirmed'),
                ],
              ),
            ),

            // ━━━ Journey Details ━━━
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Column(
                children: [
                  isTrainBooking
                      ? _buildTrainJourneyDetails(booking)
                      : _buildFlightJourneyDetails(booking),

                  SizedBox(height: spacingUnit(1.5)),
                  Divider(color: Colors.grey.shade200, height: 1),
                  SizedBox(height: spacingUnit(1.5)),

                  // ━━━ Footer Info ━━━
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: spacingUnit(0.5)),
                          Text(
                            '${booking['passengerCount'] ?? 1} ${(booking['passengerCount'] ?? 1) > 1 ? 'Passengers' : 'Passenger'}',
                            style: ThemeText.caption.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'PKR ${(booking['total'] ?? 0).toStringAsFixed(0)}',
                        style: ThemeText.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D9488),
                        ),
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
  }

  Widget _buildTrainJourneyDetails(Map<String, dynamic> booking) {
    final train = booking['trainDetails'] as Map<String, dynamic>?;
    if (train == null) return const SizedBox();

    return Row(
      children: [
        // From Station
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                train['departure'] ?? 'N/A',
                style: ThemeText.title2.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: spacingUnit(0.3)),
              Text(
                train['fromCode'] ?? 'N/A',
                style: ThemeText.headline.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacingUnit(0.2)),
              Text(
                train['from'] ?? 'N/A',
                style: ThemeText.caption.copyWith(
                  color: Colors.grey.shade500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Journey Indicator
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(0.8),
                  vertical: spacingUnit(0.3),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  train['duration'] ?? 'N/A',
                  style: ThemeText.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(height: spacingUnit(0.5)),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: const Color(0xFF059669),
                    ),
                  ),
                  const Icon(
                    Icons.train,
                    size: 16,
                    color: Color(0xFF059669),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: const Color(0xFF059669),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingUnit(0.5)),
              Text(
                train['class'] ?? 'Economy',
                style: ThemeText.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
        ),

        // To Station
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                train['arrival'] ?? 'N/A',
                style: ThemeText.title2.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: spacingUnit(0.3)),
              Text(
                train['toCode'] ?? 'N/A',
                style: ThemeText.headline.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacingUnit(0.2)),
              Text(
                train['to'] ?? 'N/A',
                style: ThemeText.caption.copyWith(
                  color: Colors.grey.shade500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightJourneyDetails(Map<String, dynamic> booking) {
    final flight = booking['flightDetails'] as Map<String, dynamic>?;
    if (flight == null) return const SizedBox();

    // Extract airport codes from the full string
    String fromCode = 'N/A';
    String toCode = 'N/A';

    final fromStr = flight['from'] ?? 'N/A';
    final toStr = flight['to'] ?? 'N/A';

    // Extract code from format "Name (CODE)"
    final fromMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(fromStr);
    final toMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(toStr);

    if (fromMatch != null) fromCode = fromMatch.group(1)!;
    if (toMatch != null) toCode = toMatch.group(1)!;

    return Row(
      children: [
        // From Airport
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flight['departure'] ?? 'N/A',
                style: ThemeText.title2.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: spacingUnit(0.3)),
              Text(
                fromCode,
                style: ThemeText.headline.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacingUnit(0.2)),
              Text(
                fromStr.replaceAll(RegExp(r'\s*\([A-Z]{3}\)'), ''),
                style: ThemeText.caption.copyWith(
                  color: Colors.grey.shade500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Journey Indicator
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(0.8),
                  vertical: spacingUnit(0.3),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  flight['duration'] ?? 'N/A',
                  style: ThemeText.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
              SizedBox(height: spacingUnit(0.5)),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  const Icon(
                    Icons.flight,
                    size: 16,
                    color: Color(0xFF3B82F6),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingUnit(0.5)),
              Text(
                flight['class'] ?? 'Economy',
                style: ThemeText.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
        ),

        // To Airport
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                flight['arrival'] ?? 'N/A',
                style: ThemeText.title2.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: spacingUnit(0.3)),
              Text(
                toCode,
                style: ThemeText.headline.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacingUnit(0.2)),
              Text(
                toStr.replaceAll(RegExp(r'\s*\([A-Z]{3}\)'), ''),
                style: ThemeText.caption.copyWith(
                  color: Colors.grey.shade500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bgColor = const Color(0xFF10B981).withOpacity(0.15);
        textColor = const Color(0xFF10B981);
        label = 'CONFIRMED';
        icon = Icons.check_circle;
        break;
      case 'canceled':
        bgColor = const Color(0xFFEF4444).withOpacity(0.15);
        textColor = const Color(0xFFEF4444);
        label = 'CANCELED';
        icon = Icons.cancel;
        break;
      case 'completed':
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        label = 'COMPLETED';
        icon = Icons.check_circle_outline;
        break;
      default:
        bgColor = const Color(0xFFF59E0B).withOpacity(0.15);
        textColor = const Color(0xFFF59E0B);
        label = 'PENDING';
        icon = Icons.access_time;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(1),
        vertical: spacingUnit(0.5),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: textColor),
          SizedBox(width: spacingUnit(0.3)),
          Text(
            label,
            style: ThemeText.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacingUnit(3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacingUnit(3)),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.airplane_ticket_outlined,
                size: 64,
                color: Color(0xFF0D9488),
              ),
            ),
            SizedBox(height: spacingUnit(2)),
            Text(
              _selectedFilter == 'All'
                  ? 'No bookings yet'
                  : 'No ${_selectedFilter.toLowerCase()} bookings',
              style: ThemeText.title2.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacingUnit(1)),
            Text(
              'Start exploring and book your next trip!',
              style: ThemeText.paragraph.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingUnit(3)),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () => Get.toNamed(AppLink.home),
                style:
                    ThemeButton.btnBig.merge(ThemeButton.tonalPrimary(context)),
                child: const Text('BOOK NOW'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
