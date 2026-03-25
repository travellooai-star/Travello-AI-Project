import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/models/hotel.dart';
import 'package:intl/intl.dart';

class HotelResultsScreen extends StatefulWidget {
  const HotelResultsScreen({super.key});

  @override
  State<HotelResultsScreen> createState() => _HotelResultsScreenState();
}

class _HotelResultsScreenState extends State<HotelResultsScreen> {
  late String city;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  late int rooms;
  late int guests;

  List<Hotel> hotels = [];
  List<Hotel> filteredHotels = [];

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Filters
  String? selectedCategory;
  double maxPrice = 30000;
  double minRating = 0.0;
  bool? filterPool;
  bool? filterBreakfast;
  bool? filterWifi;
  bool? filterParking;
  bool? filterGym;
  bool? filterSpa;
  String sortBy =
      'recommended'; // 'recommended', 'rating', 'price_low', 'price_high'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    city = args['city'] ?? 'Karachi';
    checkInDate = args['checkInDate'] ?? DateTime.now();
    checkOutDate =
        args['checkOutDate'] ?? DateTime.now().add(const Duration(days: 2));
    rooms = args['rooms'] ?? 1;
    guests = args['guests'] ?? 2;

    _loadHotels();
  }

  void _loadHotels() {
    hotels = PakistanHotels.getHotels(city);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      // Start with base hotel search
      filteredHotels = PakistanHotels.searchHotels(
        city: city,
        category: selectedCategory,
        maxPrice: maxPrice > 0 ? maxPrice : null,
        minRating: minRating > 0 ? minRating : null,
        hasPool: filterPool,
        hasBreakfast: filterBreakfast,
      );

      // Apply additional amenity filters
      if (filterWifi == true) {
        filteredHotels = filteredHotels.where((h) => h.hasFreeWifi).toList();
      }
      if (filterParking == true) {
        filteredHotels = filteredHotels.where((h) => h.hasParking).toList();
      }
      if (filterGym == true) {
        filteredHotels = filteredHotels
            .where((h) => h.amenities.any((a) =>
                a.toLowerCase().contains('gym') ||
                a.toLowerCase().contains('fitness')))
            .toList();
      }
      if (filterSpa == true) {
        filteredHotels = filteredHotels
            .where(
                (h) => h.amenities.any((a) => a.toLowerCase().contains('spa')))
            .toList();
      }

      // Apply search query
      if (searchQuery.isNotEmpty) {
        filteredHotels = filteredHotels.where((hotel) {
          return hotel.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              hotel.address.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }

      // Apply sorting
      if (sortBy == 'price_low') {
        filteredHotels
            .sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
      } else if (sortBy == 'price_high') {
        filteredHotels
            .sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
      } else if (sortBy == 'rating') {
        filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
      }
      // If 'recommended', keep current order (base on PakistanHotels order)
    });
  }

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.all(spacingUnit(2)),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: ThemeText.title2,
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              selectedCategory = null;
                              maxPrice = 30000;
                              minRating = 0.0;
                              filterPool = null;
                              filterBreakfast = null;
                              filterWifi = null;
                              filterParking = null;
                              filterGym = null;
                              filterSpa = null;
                            });
                            setState(() {});
                            _applyFilters();
                          },
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Category Filter
                    const Text('Hotel Category', style: ThemeText.subtitle),
                    SizedBox(height: spacingUnit(1)),
                    Wrap(
                      spacing: spacingUnit(1),
                      children:
                          ['3-Star', '4-Star', '5-Star', 'Budget'].map((cat) {
                        final isSelected = selectedCategory == cat;
                        return FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              selectedCategory = selected ? cat : null;
                            });
                          },
                          selectedColor: colorScheme(context)
                              .primary
                              .withValues(alpha: 0.3),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: spacingUnit(2)),

                    // Price Filter
                    const Text('Max Price per Night',
                        style: ThemeText.subtitle),
                    SizedBox(height: spacingUnit(1)),
                    Slider(
                      value: maxPrice,
                      min: 5000,
                      max: 30000,
                      divisions: 25,
                      label: 'PKR ${maxPrice.toStringAsFixed(0)}',
                      onChanged: (value) {
                        setModalState(() {
                          maxPrice = value;
                        });
                      },
                    ),
                    Text(
                      'Up to PKR ${maxPrice.toStringAsFixed(0)}',
                      style: ThemeText.caption.copyWith(fontSize: 13),
                    ),

                    SizedBox(height: spacingUnit(2)),

                    // Rating Filter
                    const Text('Minimum Rating', style: ThemeText.subtitle),
                    SizedBox(height: spacingUnit(1)),
                    Wrap(
                      spacing: spacingUnit(1),
                      children: [0.0, 3.0, 3.5, 4.0, 4.5].map((rating) {
                        final isSelected = minRating == rating;
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (rating > 0) ...[
                                const Icon(Icons.star, size: 16),
                                SizedBox(width: spacingUnit(0.5)),
                                Text('$rating+'),
                              ] else
                                const Text('Any'),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              minRating = selected ? rating : 0.0;
                            });
                          },
                          selectedColor: colorScheme(context)
                              .primary
                              .withValues(alpha: 0.3),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: spacingUnit(2)),

                    // Amenities Filter
                    const Text('Amenities', style: ThemeText.subtitle),
                    SizedBox(height: spacingUnit(1)),
                    CheckboxListTile(
                      title: const Text('Free WiFi',
                          style: TextStyle(fontSize: 14)),
                      value: filterWifi ?? false,
                      onChanged: (value) {
                        setModalState(() {
                          filterWifi = value;
                        });
                      },
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Swimming Pool',
                          style: TextStyle(fontSize: 14)),
                      value: filterPool ?? false,
                      onChanged: (value) {
                        setModalState(() {
                          filterPool = value;
                        });
                      },
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Free Breakfast',
                          style: TextStyle(fontSize: 14)),
                      value: filterBreakfast ?? false,
                      onChanged: (value) {
                        setModalState(() {
                          filterBreakfast = value;
                        });
                      },
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Free Parking',
                          style: TextStyle(fontSize: 14)),
                      value: filterParking ?? false,
                      onChanged: (value) {
                        setModalState(() {
                          filterParking = value;
                        });
                      },
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Gym / Fitness Center',
                          style: TextStyle(fontSize: 14)),
                      value: filterGym ?? false,
                      onChanged: (value) {
                        setModalState(() {
                          filterGym = value;
                        });
                      },
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Spa Services',
                          style: TextStyle(fontSize: 14)),
                      value: filterSpa ?? false,
                      onChanged: (value) {
                        setModalState(() {
                          filterSpa = value;
                        });
                      },
                      dense: true,
                    ),

                    SizedBox(height: spacingUnit(3)),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme(context).primary,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: spacingUnit(2)),
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(spacingUnit(2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Sort By', style: ThemeText.title2),
              const Divider(),
              RadioListTile<String>(
                title:
                    const Text('Recommended', style: TextStyle(fontSize: 14)),
                value: 'recommended',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Highest Rating',
                    style: TextStyle(fontSize: 14)),
                value: 'rating',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Price: Low to High',
                    style: TextStyle(fontSize: 14)),
                value: 'price_low',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Price: High to Low',
                    style: TextStyle(fontSize: 14)),
                value: 'price_high',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels in $city'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search by property name...',
                hintStyle: ThemeText.caption.copyWith(fontSize: 14),
                prefixIcon:
                    Icon(Icons.search, color: colorScheme(context).primary),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme(context).primary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(2),
                  vertical: spacingUnit(1.5),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),

          // Search Summary
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: colorScheme(context).primary.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
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
                          Text(
                            DateFormat('MMM d').format(checkInDate),
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Check-in', style: ThemeText.caption),
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
                          Text(
                            DateFormat('MMM d').format(checkOutDate),
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Check-out', style: ThemeText.caption),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(spacingUnit(1)),
                      decoration: BoxDecoration(
                        color: colorScheme(context).primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$numberOfNights ${numberOfNights == 1 ? 'Night' : 'Nights'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter and Sort Bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacingUnit(2),
              vertical: spacingUnit(1),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${filteredHotels.length} hotels found',
                  style:
                      ThemeText.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.filter_list, size: 20),
                  label: const Text('Filter'),
                ),
                TextButton.icon(
                  onPressed: _showSortOptions,
                  icon: const Icon(Icons.sort, size: 20),
                  label: const Text('Sort'),
                ),
              ],
            ),
          ),

          // Hotels List
          Expanded(
            child: filteredHotels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hotel_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: spacingUnit(2)),
                        Text(
                          'No hotels found',
                          style: ThemeText.subtitle.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: spacingUnit(1)),
                        const Text(
                          'Try adjusting your filters',
                          style: ThemeText.caption,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
                      return _buildHotelCard(hotel);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    final totalPrice = hotel.pricePerNight * numberOfNights;

    return Card(
      margin: EdgeInsets.only(bottom: spacingUnit(2)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            '/hotel-detail',
            arguments: {
              'hotel': hotel,
              'checkInDate': checkInDate,
              'checkOutDate': checkOutDate,
              'rooms': rooms,
              'guests': guests,
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image with Refundable Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    hotel.images.first,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.hotel, size: 64),
                      );
                    },
                  ),
                ),
                // Refundable Badge
                if (hotel.isRefundable)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingUnit(1.5),
                        vertical: spacingUnit(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A86B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle,
                              size: 14, color: Colors.white),
                          SizedBox(width: spacingUnit(0.5)),
                          const Text(
                            'Refundable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

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
                          style: ThemeText.subtitle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(1),
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colorScheme(context).primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(0.5)),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Color(0xFFB3B3B3)),
                      SizedBox(width: spacingUnit(0.5)),
                      Expanded(
                        child: Text(
                          '${hotel.distanceFromCenter.toStringAsFixed(1)} km from center',
                          style: ThemeText.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(1)),

                  // Rating and Reviews
                  Row(
                    children: [
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
                            const Icon(Icons.star,
                                size: 14, color: Colors.white),
                            SizedBox(width: spacingUnit(0.5)),
                            Text(
                              hotel.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacingUnit(1)),
                      Text(
                        '${hotel.totalReviews} reviews',
                        style: ThemeText.caption,
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(1.5)),

                  // Amenities
                  Wrap(
                    spacing: spacingUnit(1),
                    runSpacing: spacingUnit(0.5),
                    children: hotel.amenities.take(3).map((amenity) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(1),
                          vertical: spacingUnit(0.5),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          amenity,
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: spacingUnit(1.5)),

                  // Price and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PKR ${hotel.pricePerNight.toStringAsFixed(0)}',
                            style: ThemeText.subtitle.copyWith(
                              color: colorScheme(context).primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'per night • PKR ${totalPrice.toStringAsFixed(0)} total',
                            style: ThemeText.caption.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            '/hotel-detail',
                            arguments: {
                              'hotel': hotel,
                              'checkInDate': checkInDate,
                              'checkOutDate': checkOutDate,
                              'rooms': rooms,
                              'guests': guests,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme(context).primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: spacingUnit(2),
                            vertical: spacingUnit(1),
                          ),
                        ),
                        child: const Text('View'),
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
}
