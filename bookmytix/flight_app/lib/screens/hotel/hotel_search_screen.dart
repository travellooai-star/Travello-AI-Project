import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/models/hotel.dart';
import 'package:intl/intl.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  String _selectedCity = 'Karachi';
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 3));
  int _rooms = 1;
  int _guests = 2;

  final List<String> _cities = PakistanHotels.getCities();

  void _selectCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme(context).primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        // Ensure check-out is after check-in
        if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
          _checkOutDate = _checkInDate.add(const Duration(days: 2));
        }
      });
    }
  }

  void _selectCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme(context).primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  int get _numberOfNights {
    return _checkOutDate.difference(_checkInDate).inDays;
  }

  void _searchHotels() {
    Get.toNamed(
      '/hotel-results',
      arguments: {
        'city': _selectedCity,
        'checkInDate': _checkInDate,
        'checkOutDate': _checkOutDate,
        'rooms': _rooms,
        'guests': _guests,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hotels'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacingUnit(3)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme(context).primary,
                    colorScheme(context).primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.hotel,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: spacingUnit(1)),
                  const Text(
                    'Find Your Perfect Stay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: spacingUnit(0.5)),
                  const Text(
                    'Search from top hotels across Pakistan',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City Selection
                  const Text(
                    'Destination',
                    style: ThemeText.subtitle,
                  ),
                  SizedBox(height: spacingUnit(1)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: _cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Row(
                            children: [
                              const Icon(Icons.location_city, size: 20),
                              SizedBox(width: spacingUnit(1)),
                              Text(city),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCity = value;
                          });
                        }
                      },
                    ),
                  ),

                  SizedBox(height: spacingUnit(3)),

                  // Check-in and Check-out Dates with Nights Indicator
                  Container(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // Check-in Date
                            Expanded(
                              child: InkWell(
                                onTap: _selectCheckInDate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('MMM d')
                                          .format(_checkInDate),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: spacingUnit(0.25)),
                                    Text(
                                      'Check-in',
                                      style: ThemeText.caption.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Arrow
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                              child: Icon(
                                Icons.arrow_forward,
                                color: colorScheme(context).primary,
                                size: 20,
                              ),
                            ),
                            
                            // Check-out Date
                            Expanded(
                              child: InkWell(
                                onTap: _selectCheckOutDate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('MMM d')
                                          .format(_checkOutDate),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: spacingUnit(0.25)),
                                    Text(
                                      'Check-out',
                                      style: ThemeText.caption.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(width: spacingUnit(8)), // Space for badge
                          ],
                        ),
                        
                        // Nights Badge - Positioned on top right
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingUnit(1.5),
                              vertical: spacingUnit(0.75),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37), // Gold color
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_numberOfNights ${_numberOfNights == 1 ? 'Night' : 'Nights'}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacingUnit(3)),

                  // Rooms and Guests
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rooms',
                              style: ThemeText.subtitle,
                            ),
                            SizedBox(height: spacingUnit(1)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: spacingUnit(2)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: _rooms > 1
                                        ? () => setState(() => _rooms--)
                                        : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '$_rooms',
                                    style: ThemeText.subtitle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _rooms < 5
                                        ? () => setState(() => _rooms++)
                                        : null,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacingUnit(2)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Guests',
                              style: ThemeText.subtitle,
                            ),
                            SizedBox(height: spacingUnit(1)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: spacingUnit(2)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: _guests > 1
                                        ? () => setState(() => _guests--)
                                        : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '$_guests',
                                    style: ThemeText.subtitle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _guests < 10
                                        ? () => setState(() => _guests++)
                                        : null,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(4)),

                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _searchHotels,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme(context).primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search),
                          SizedBox(width: spacingUnit(1)),
                          const Text(
                            'Search Hotels',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: spacingUnit(3)),

                  // Quick Info
                  Container(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme(context).primary,
                            ),
                            SizedBox(width: spacingUnit(1)),
                            const Expanded(
                              child: Text(
                                'Best Price Guarantee',
                                style: ThemeText.subtitle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacingUnit(1)),
                        const Text(
                          'Find the best hotel deals in Pakistan with instant confirmation and 24/7 customer support.',
                          style: ThemeText.caption,
                        ),
                      ],
                    ),
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
