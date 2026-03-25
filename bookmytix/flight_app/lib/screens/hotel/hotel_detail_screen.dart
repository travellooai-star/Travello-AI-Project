import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/models/hotel.dart';
import 'package:flight_app/models/room_type.dart';
import 'package:intl/intl.dart';

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({super.key});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen>
    with SingleTickerProviderStateMixin {
  late Hotel hotel;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  late int rooms;
  late int guests;

  int _currentImageIndex = 0;
  late TabController _tabController;
  RoomType? selectedRoom;

  // Sample room types (in a real app, these would come from the hotel data)
  List<RoomType> availableRooms = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    final args = Get.arguments ?? {};
    hotel = args['hotel'];
    checkInDate = args['checkInDate'];
    checkOutDate = args['checkOutDate'];
    rooms = args['rooms'];
    guests = args['guests'];

    _initializeRooms();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeRooms() {
    // Create sample rooms based on hotel category
    final basePrice = hotel.pricePerNight;

    availableRooms = [
      RoomType(
        id: '${hotel.id}-1',
        name: 'Superior Room',
        description: 'Comfortable room with modern amenities and city views',
        pricePerNight: basePrice,
        maxOccupancy: 2,
        bedCount: 1,
        bedType: 'King Bed',
        sizeInSqFt: 280,
        amenities: [
          'Free WiFi',
          'Air Conditioning',
          'Flat-screen TV',
          'Mini Bar',
          'Work Desk'
        ],
        images: hotel.images,
        hasCityView: true,
        hasBalcony: false,
        isRefundable: true,
        cancellationPolicy: 'Free cancellation up to 24 hours before check-in',
        breakfastIncluded: hotel.hasBreakfast,
        roomsAvailable: 5,
      ),
      RoomType(
        id: '${hotel.id}-2',
        name: 'Deluxe Room',
        description:
            'Spacious room with premium furnishings and stunning city views',
        pricePerNight: basePrice * 1.3,
        maxOccupancy: 3,
        bedCount: 1,
        bedType: 'King Bed + Sofa Bed',
        sizeInSqFt: 350,
        amenities: [
          'Free WiFi',
          'Air Conditioning',
          'Flat-screen TV',
          'Mini Bar',
          'Work Desk',
          'Coffee Maker',
          'Bathrobe & Slippers'
        ],
        images: hotel.images,
        hasCityView: true,
        hasBalcony: true,
        isRefundable: true,
        cancellationPolicy: 'Free cancellation up to 48 hours before check-in',
        breakfastIncluded: true,
        roomsAvailable: 3,
      ),
      RoomType(
        id: '${hotel.id}-3',
        name: 'Executive Suite',
        description:
            'Luxurious suite with separate living area and panoramic views',
        pricePerNight: basePrice * 1.8,
        maxOccupancy: 4,
        bedCount: 2,
        bedType: '1 King Bed + 1 Queen Bed',
        sizeInSqFt: 550,
        amenities: [
          'Free WiFi',
          'Air Conditioning',
          'Flat-screen TV',
          'Mini Bar',
          'Work Desk',
          'Coffee Maker',
          'Bathrobe & Slippers',
          'Living Area',
          'Premium Toiletries',
          'Express Check-in'
        ],
        images: hotel.images,
        hasCityView: true,
        hasBalcony: true,
        isRefundable: true,
        cancellationPolicy: 'Free cancellation up to 72 hours before check-in',
        breakfastIncluded: true,
        roomsAvailable: 2,
      ),
    ];
  }

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  double get totalPrice {
    final roomPrice = selectedRoom?.pricePerNight ?? hotel.pricePerNight;
    return roomPrice * numberOfNights * rooms;
  }

  void _proceedToBooking() {
    if (selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a room type',
              style: TextStyle(fontSize: 14)),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Get.toNamed(
      '/hotel-guest-form',
      arguments: {
        'hotel': hotel,
        'roomType': selectedRoom,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'rooms': rooms,
        'guests': guests,
        'totalPrice': totalPrice,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      itemCount: hotel.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          hotel.images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.hotel, size: 64),
                            );
                          },
                        );
                      },
                    ),
                    // Image Indicator
                    if (hotel.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            hotel.images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Hotel Header and Tabs
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Info
                  Padding(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name and Category
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                hotel.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacingUnit(1.5),
                                vertical: spacingUnit(0.5),
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                hotel.category,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme(context).primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: spacingUnit(1)),

                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18, color: Color(0xFFB3B3B3)),
                            SizedBox(width: spacingUnit(0.5)),
                            Expanded(
                              child: Text(
                                hotel.address,
                                style:
                                    ThemeText.subtitle.copyWith(fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: spacingUnit(0.5)),

                        Row(
                          children: [
                            SizedBox(width: spacingUnit(3)),
                            Text(
                              '${hotel.distanceFromCenter.toStringAsFixed(1)} km from city center',
                              style: ThemeText.caption.copyWith(fontSize: 13),
                            ),
                          ],
                        ),

                        SizedBox(height: spacingUnit(1.5)),

                        // Rating and Reviews
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: spacingUnit(1.5),
                                  vertical: spacingUnit(1)),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 18, color: Colors.white),
                                  SizedBox(width: spacingUnit(0.5)),
                                  Text(
                                    hotel.rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: spacingUnit(1.5)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getRatingText(hotel.rating),
                                  style: ThemeText.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${hotel.totalReviews} reviews',
                                  style:
                                      ThemeText.caption.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Tabs
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: colorScheme(context).primary,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      indicatorColor: colorScheme(context).primary,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Rooms'),
                        Tab(text: 'Amenities'),
                        Tab(text: 'Reviews'),
                        Tab(text: 'Policies'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildRoomsTab(),
            _buildAmenitiesTab(),
            _buildReviewsTab(),
            _buildPoliciesTab(),
          ],
        ),
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From PKR ${(selectedRoom?.pricePerNight ?? hotel.pricePerNight).toStringAsFixed(0)}/night',
                      style: ThemeText.caption.copyWith(fontSize: 13),
                    ),
                    SizedBox(height: spacingUnit(0.5)),
                    Text(
                      'PKR ${totalPrice.toStringAsFixed(0)} total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacingUnit(2)),
              Expanded(
                child: ElevatedButton(
                  onPressed: _proceedToBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme(context).primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    selectedRoom == null ? 'Select Room' : 'Book Now',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking Summary Card
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: colorScheme(context).primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme(context).primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check-in',
                              style: ThemeText.caption.copyWith(fontSize: 13)),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            DateFormat('EEE, MMM d').format(checkInDate),
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward,
                        color: colorScheme(context).primary),
                    SizedBox(width: spacingUnit(1)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check-out',
                              style: ThemeText.caption.copyWith(fontSize: 13)),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            DateFormat('EEE, MMM d').format(checkOutDate),
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacingUnit(2)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration',
                              style: ThemeText.caption.copyWith(fontSize: 13)),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            '$numberOfNights ${numberOfNights == 1 ? 'Night' : 'Nights'}',
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guests',
                              style: ThemeText.caption.copyWith(fontSize: 13)),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            '$guests ${guests == 1 ? 'Guest' : 'Guests'}, $rooms ${rooms == 1 ? 'Room' : 'Rooms'}',
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: spacingUnit(3)),

          // About Section
          const Text('About This Hotel', style: ThemeText.title2),
          SizedBox(height: spacingUnit(1)),
          Text(
            hotel.description,
            style: ThemeText.paragraph.copyWith(fontSize: 14),
          ),

          SizedBox(height: spacingUnit(10)),
        ],
      ),
    );
  }

  // Rooms Tab
  Widget _buildRoomsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Room',
            style: ThemeText.title2,
          ),
          SizedBox(height: spacingUnit(2)),
          ...availableRooms.map((room) => _buildRoomCard(room)),
          SizedBox(height: spacingUnit(10)),
        ],
      ),
    );
  }

  // Room Card Widget
  Widget _buildRoomCard(RoomType room) {
    final isSelected = selectedRoom?.id == room.id;
    final roomTotalPrice = room.pricePerNight * numberOfNights;

    return Container(
      margin: EdgeInsets.only(bottom: spacingUnit(2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSelected ? colorScheme(context).primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? colorScheme(context).primary.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              room.images.first,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.bed, size: 48),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(spacingUnit(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Name
                Text(
                  room.name,
                  style: ThemeText.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: spacingUnit(0.5)),

                // Room Description
                Text(
                  room.description,
                  style: ThemeText.caption.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: spacingUnit(1.5)),

                // Room Details
                Row(
                  children: [
                    Icon(Icons.people,
                        size: 18, color: colorScheme(context).primary),
                    SizedBox(width: spacingUnit(0.5)),
                    Text('${room.maxOccupancy} guests',
                        style: ThemeText.caption.copyWith(fontSize: 13)),
                    SizedBox(width: spacingUnit(2)),
                    Icon(Icons.bed,
                        size: 18, color: colorScheme(context).primary),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(room.bedType,
                        style: ThemeText.caption.copyWith(fontSize: 13)),
                  ],
                ),

                SizedBox(height: spacingUnit(0.5)),

                Row(
                  children: [
                    Icon(Icons.aspect_ratio,
                        size: 18, color: colorScheme(context).primary),
                    SizedBox(width: spacingUnit(0.5)),
                    Text('${room.sizeInSqFt} sq ft',
                        style: ThemeText.caption.copyWith(fontSize: 13)),
                    if (room.hasCityView) ...[
                      SizedBox(width: spacingUnit(2)),
                      Icon(Icons.visibility,
                          size: 18, color: colorScheme(context).primary),
                      SizedBox(width: spacingUnit(0.5)),
                      Text('City view',
                          style: ThemeText.caption.copyWith(fontSize: 13)),
                    ],
                  ],
                ),

                SizedBox(height: spacingUnit(1.5)),

                // Amenities
                Wrap(
                  spacing: spacingUnit(1),
                  runSpacing: spacingUnit(0.5),
                  children: room.amenities.take(4).map((amenity) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingUnit(1),
                        vertical: spacingUnit(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        amenity,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: spacingUnit(1.5)),

                // Cancellation Policy
                Row(
                  children: [
                    Icon(
                      room.isRefundable ? Icons.check_circle : Icons.info,
                      size: 16,
                      color: room.isRefundable ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: spacingUnit(0.5)),
                    Expanded(
                      child: Text(
                        room.cancellationPolicy,
                        style: TextStyle(
                          fontSize: 12,
                          color: room.isRefundable
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacingUnit(2)),

                // Price and Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PKR ${room.pricePerNight.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme(context).primary,
                          ),
                        ),
                        Text(
                          'per night • PKR ${roomTotalPrice.toStringAsFixed(0)} total',
                          style: ThemeText.caption.copyWith(fontSize: 12),
                        ),
                        if (room.breakfastIncluded)
                          Text(
                            '✓ Breakfast included',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedRoom = room;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${room.name} selected',
                                style: const TextStyle(fontSize: 14)),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? colorScheme(context).primary
                            : Colors.white,
                        foregroundColor: isSelected
                            ? Colors.white
                            : colorScheme(context).primary,
                        side: BorderSide(
                          color: colorScheme(context).primary,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(2),
                          vertical: spacingUnit(1),
                        ),
                      ),
                      child: Text(
                        isSelected ? 'Selected' : 'Select',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                if (room.roomsAvailable <= 3)
                  Padding(
                    padding: EdgeInsets.only(top: spacingUnit(1)),
                    child: Text(
                      'Only ${room.roomsAvailable} rooms left!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Amenities Tab
  Widget _buildAmenitiesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hotel Amenities', style: ThemeText.title2),
          SizedBox(height: spacingUnit(2)),
          Wrap(
            spacing: spacingUnit(2),
            runSpacing: spacingUnit(2),
            children: hotel.amenities.map((amenity) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.42,
                padding: EdgeInsets.all(spacingUnit(1.5)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 22,
                      color: colorScheme(context).primary,
                    ),
                    SizedBox(width: spacingUnit(1)),
                    Expanded(
                      child: Text(
                        amenity,
                        style: ThemeText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(10)),
        ],
      ),
    );
  }

  // Reviews Tab
  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Rating
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: colorScheme(context).primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      hotel.rating.toString(),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).primary,
                      ),
                    ),
                    const Text('out of 5', style: ThemeText.caption),
                  ],
                ),
                SizedBox(width: spacingUnit(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getRatingText(hotel.rating),
                        style: ThemeText.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: spacingUnit(0.5)),
                      Text(
                        'Based on ${hotel.totalReviews} reviews',
                        style: ThemeText.caption.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: spacingUnit(3)),

          // Rating Breakdown
          const Text('Rating Breakdown', style: ThemeText.title2),
          SizedBox(height: spacingUnit(1.5)),

          _buildRatingBar('Cleanliness', 4.6),
          _buildRatingBar('Service', 4.4),
          _buildRatingBar('Location', 4.5),
          _buildRatingBar('Facilities', 4.3),
          _buildRatingBar('Value for Money', 4.2),

          SizedBox(height: spacingUnit(3)),

          // Sample Reviews
          const Text('Recent Reviews', style: ThemeText.title2),
          SizedBox(height: spacingUnit(1.5)),

          _buildReviewCard(
            'Excellent Stay',
            'Amazing hotel with great facilities and friendly staff. The room was spacious and clean. Highly recommended!',
            'Ahmed K.',
            5.0,
            '2 days ago',
          ),

          _buildReviewCard(
            'Great Location',
            'Perfect location in the heart of the city. Easy access to all major attractions. The breakfast was delicious.',
            'Sara M.',
            4.5,
            '5 days ago',
          ),

          _buildReviewCard(
            'Good Value',
            'Nice hotel for the price. Rooms could be a bit bigger but overall a pleasant stay. Staff was very helpful.',
            'Bilal R.',
            4.0,
            '1 week ago',
          ),

          SizedBox(height: spacingUnit(10)),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String category, double rating) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(1.5)),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              category,
              style: ThemeText.caption.copyWith(fontSize: 13),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rating / 5,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme(context).primary,
                ),
              ),
            ),
          ),
          SizedBox(width: spacingUnit(1)),
          Text(
            rating.toString(),
            style: ThemeText.caption.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    String title,
    String review,
    String author,
    double rating,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacingUnit(2)),
      padding: EdgeInsets.all(spacingUnit(2)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme(context).primary,
                child: Text(
                  author[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: spacingUnit(1.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: ThemeText.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      time,
                      style: ThemeText.caption.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(1),
                  vertical: spacingUnit(0.5),
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.white),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(1.5)),
          Text(
            title,
            style: ThemeText.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: spacingUnit(0.5)),
          Text(
            review,
            style: ThemeText.paragraph.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Policies Tab
  Widget _buildPoliciesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hotel Policies', style: ThemeText.title2),
          SizedBox(height: spacingUnit(2)),
          _buildPolicyItem(
            Icons.check_circle,
            'Cancellation',
            hotel.isRefundable
                ? 'Free cancellation up to 24 hours before check-in. After that, cancellation charges may apply.'
                : 'Non-refundable booking. No refunds will be provided for cancellations.',
          ),
          _buildPolicyItem(
            Icons.access_time,
            'Check-in / Check-out',
            'Check-in from 2:00 PM\nCheck-out until 12:00 PM\nEarly check-in and late check-out available upon request (subject to availability)',
          ),
          _buildPolicyItem(
            Icons.restaurant,
            'Breakfast',
            hotel.hasBreakfast
                ? 'Complimentary breakfast included with your stay. Served daily from 7:00 AM to 10:30 AM.'
                : 'Breakfast not included in room rate. Available for purchase at our restaurant.',
          ),
          _buildPolicyItem(
            Icons.wifi,
            'WiFi',
            hotel.hasFreeWifi
                ? 'Free high-speed WiFi available throughout the property.'
                : 'WiFi available for purchase at reception desk.',
          ),
          _buildPolicyItem(
            Icons.local_parking,
            'Parking',
            hotel.hasParking
                ? 'Free on-site parking available for all guests. Valet parking service also available.'
                : 'Street parking available nearby (charges may apply).',
          ),
          _buildPolicyItem(
            Icons.pets,
            'Pets',
            'Pets are not allowed in the hotel premises.',
          ),
          _buildPolicyItem(
            Icons.smoking_rooms,
            'Smoking',
            'This is a non-smoking property. Smoking is only allowed in designated outdoor areas.',
          ),
          _buildPolicyItem(
            Icons.child_care,
            'Children',
            'Children of all ages are welcome. Children under 12 years stay free when using existing beds.',
          ),
          SizedBox(height: spacingUnit(10)),
        ],
      ),
    );
  }

  // Helper: Build Policy Item
  Widget _buildPolicyItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: colorScheme(context).primary),
          SizedBox(width: spacingUnit(1.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ThemeText.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  description,
                  style: ThemeText.caption.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Get Amenity Icon
  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi')) return Icons.wifi;
    if (lowerAmenity.contains('pool') || lowerAmenity.contains('swimming')) {
      return Icons.pool;
    }
    if (lowerAmenity.contains('gym') || lowerAmenity.contains('fitness')) {
      return Icons.fitness_center;
    }
    if (lowerAmenity.contains('restaurant') ||
        lowerAmenity.contains('dining')) {
      return Icons.restaurant;
    }
    if (lowerAmenity.contains('parking')) return Icons.local_parking;
    if (lowerAmenity.contains('spa') || lowerAmenity.contains('massage')) {
      return Icons.spa;
    }
    if (lowerAmenity.contains('bar') || lowerAmenity.contains('lounge')) {
      return Icons.local_bar;
    }
    if (lowerAmenity.contains('room service')) return Icons.room_service;
    if (lowerAmenity.contains('laundry') || lowerAmenity.contains('cleaning')) {
      return Icons.local_laundry_service;
    }
    if (lowerAmenity.contains('concierge') ||
        lowerAmenity.contains('reception')) {
      return Icons.support_agent;
    }
    if (lowerAmenity.contains('conference') ||
        lowerAmenity.contains('meeting')) {
      return Icons.meeting_room;
    }
    if (lowerAmenity.contains('airport')) return Icons.flight;
    return Icons.check_circle;
  }

  // Helper: Get Rating Text
  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    return 'Fair';
  }
}
