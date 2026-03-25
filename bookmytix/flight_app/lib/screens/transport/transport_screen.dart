import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/models/transport.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  String _selectedType = 'Taxi';
  String _selectedCity = 'Karachi';
  int _passengers = 1;
  double _estimatedDistance = 5.0; // in km
  bool _requireAC = false;

  List<Transport> _availableTransports = [];

  @override
  void initState() {
    super.initState();
    _loadTransports();
  }

  void _loadTransports() {
    setState(() {
      _availableTransports = PakistanTransport.searchTransport(
        type: _selectedType,
        minSeats: _passengers,
        requireAC: _requireAC,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Transport'),
        centerTitle: true,
      ),
      body: Column(
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
                  Icons.directions_car,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: spacingUnit(1)),
                const Text(
                  'Book Your Ride',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: spacingUnit(0.5)),
                const Text(
                  'Safe and reliable transport across Pakistan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Search/Filter Panel
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transport Type Selection (Tabs)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: PakistanTransport.getTransportTypes().map((type) {
                      final isSelected = _selectedType == type;
                      return Padding(
                        padding: EdgeInsets.only(right: spacingUnit(1)),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = type;
                              });
                              _loadTransports();
                            }
                          },
                          selectedColor: colorScheme(context).primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: spacingUnit(2)),

                // City and Passengers
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        decoration: InputDecoration(
                          labelText: 'City',
                          prefixIcon: const Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: PakistanTransport.getCities().map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
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
                    SizedBox(width: spacingUnit(2)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Passengers', style: ThemeText.caption),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _passengers > 1
                                      ? () {
                                          setState(() => _passengers--);
                                          _loadTransports();
                                        }
                                      : null,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  '$_passengers',
                                  style: ThemeText.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() => _passengers++);
                                    _loadTransports();
                                  },
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

                SizedBox(height: spacingUnit(1.5)),

                // Distance Slider (for price estimation)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Distance: ${_estimatedDistance.toStringAsFixed(1)} km',
                      style: ThemeText.caption
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _estimatedDistance,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${_estimatedDistance.toStringAsFixed(1)} km',
                      onChanged: (value) {
                        setState(() {
                          _estimatedDistance = value;
                        });
                      },
                    ),
                  ],
                ),

                // AC Filter
                CheckboxListTile(
                  title: const Text('AC Required'),
                  value: _requireAC,
                  onChanged: (value) {
                    setState(() {
                      _requireAC = value ?? false;
                    });
                    _loadTransports();
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),

          // Available Transports List
          Expanded(
            child: _availableTransports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: spacingUnit(2)),
                        Text(
                          'No transport available',
                          style: ThemeText.subtitle.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    itemCount: _availableTransports.length,
                    itemBuilder: (context, index) {
                      final transport = _availableTransports[index];
                      return _buildTransportCard(transport);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportCard(Transport transport) {
    final double estimatedPrice =
        transport.type == 'Rental Car' && transport.pricePerKm == 0
            ? transport.basePrice
            : transport.calculatePrice(_estimatedDistance);

    return Card(
      margin: EdgeInsets.only(bottom: spacingUnit(2)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _showBookingDialog(transport, estimatedPrice);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(spacingUnit(2)),
          child: Row(
            children: [
              // Vehicle Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  transport.imageUrl,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.directions_car, size: 40),
                    );
                  },
                ),
              ),

              SizedBox(width: spacingUnit(2)),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Type
                    Text(
                      transport.name,
                      style: ThemeText.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      transport.vehicleModel,
                      style: ThemeText.caption,
                    ),

                    SizedBox(height: spacingUnit(1)),

                    // Features Row
                    Row(
                      children: [
                        if (transport.isAC)
                          _buildFeatureChip(Icons.ac_unit, 'AC'),
                        SizedBox(width: spacingUnit(0.5)),
                        _buildFeatureChip(
                          Icons.person,
                          '${transport.seatingCapacity}',
                        ),
                        if (transport.driverRating > 0) ...[
                          SizedBox(width: spacingUnit(0.5)),
                          _buildFeatureChip(
                            Icons.star,
                            transport.driverRating.toString(),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: spacingUnit(1)),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PKR ${estimatedPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme(context).primary,
                              ),
                            ),
                            if (transport.pricePerKm > 0)
                              Text(
                                'PKR ${transport.pricePerKm}/km',
                                style: ThemeText.caption.copyWith(fontSize: 10),
                              ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showBookingDialog(transport, estimatedPrice);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme(context).primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingUnit(2),
                              vertical: spacingUnit(1),
                            ),
                          ),
                          child: const Text('Book'),
                        ),
                      ],
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

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(0.8),
        vertical: spacingUnit(0.4),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          SizedBox(width: spacingUnit(0.3)),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(Transport transport, double estimatedPrice) {
    final pickupController = TextEditingController();
    final dropoffController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Book ${transport.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: pickupController,
                  decoration: const InputDecoration(
                    labelText: 'Pickup Location',
                    prefixIcon: Icon(Icons.my_location),
                  ),
                ),
                SizedBox(height: spacingUnit(2)),
                TextField(
                  controller: dropoffController,
                  decoration: const InputDecoration(
                    labelText: 'Drop-off Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: spacingUnit(2)),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: spacingUnit(2)),
                Container(
                  padding: EdgeInsets.all(spacingUnit(2)),
                  decoration: BoxDecoration(
                    color: colorScheme(context).primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Fare:'),
                          Text(
                            'PKR ${estimatedPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme(context).primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingUnit(0.5)),
                      Text(
                        'Actual fare may vary based on traffic and route',
                        style: ThemeText.caption.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Proceed to payment
                Navigator.pop(context);
                Get.toNamed(
                  '/payment-professional',
                  arguments: {
                    'transport': transport,
                    'pickup': pickupController.text,
                    'dropoff': dropoffController.text,
                    'phone': phoneController.text,
                    'totalPrice': estimatedPrice,
                    'bookingType': 'transport',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme(context).primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm Booking'),
            ),
          ],
        );
      },
    );
  }
}
