import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/models/hotel.dart';
import 'package:flight_app/models/room_type.dart';
import 'package:intl/intl.dart';

class HotelGuestFormScreen extends StatefulWidget {
  const HotelGuestFormScreen({super.key});

  @override
  State<HotelGuestFormScreen> createState() => _HotelGuestFormScreenState();
}

class _HotelGuestFormScreenState extends State<HotelGuestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late Hotel hotel;
  RoomType? roomType;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  late int rooms;
  late int guests;
  late double totalPrice;
  bool addProtectionPlan = false;

  // Guest controllers
  final List<Map<String, TextEditingController>> _guestControllers = [];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    hotel = args['hotel'];
    roomType = args['roomType'];
    checkInDate = args['checkInDate'];
    checkOutDate = args['checkOutDate'];
    rooms = args['rooms'];
    guests = args['guests'];
    totalPrice = args['totalPrice'];

    // Initialize guest forms (one primary guest required)
    for (int i = 0; i < guests; i++) {
      _guestControllers.add({
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'email': TextEditingController(),
        'phone': TextEditingController(),
      });
    }
  }

  @override
  void dispose() {
    for (var controllers in _guestControllers) {
      controllers['firstName']?.dispose();
      controllers['lastName']?.dispose();
      controllers['email']?.dispose();
      controllers['phone']?.dispose();
    }
    super.dispose();
  }

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  double get protectionPlanCost {
    return totalPrice * 0.05; // 5% of total booking
  }

  double get finalTotal {
    return totalPrice + (addProtectionPlan ? protectionPlanCost : 0);
  }

  void _proceedToPayment() {
    if (_formKey.currentState!.validate()) {
      // Collect guest data
      final guestsData = _guestControllers.map((controllers) {
        return {
          'firstName': controllers['firstName']!.text,
          'lastName': controllers['lastName']!.text,
          'email': controllers['email']!.text,
          'phone': controllers['phone']!.text,
        };
      }).toList();

      Get.toNamed(
        '/payment-professional',
        arguments: {
          'hotel': hotel,
          'roomType': roomType,
          'checkInDate': checkInDate,
          'checkOutDate': checkOutDate,
          'rooms': rooms,
          'guests': guests, // Keep as int for payment screen
          'guestsData': guestsData, // Actual guest details
          'nights': numberOfNights,
          'totalPrice': finalTotal,
          'basePrice': totalPrice,
          'protectionPlan': addProtectionPlan,
          'protectionPlanCost': addProtectionPlan ? protectionPlanCost : 0,
          'bookingType': 'hotel',
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields',
                style: TextStyle(fontSize: 14))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme(context).primary,
        foregroundColor: Colors.white,
        title: const Text('Guest Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progression Indicator
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            color: Colors.white,
            child: Row(
              children: [
                _buildProgressStep(1, 'Search', true),
                _buildProgressLine(true),
                _buildProgressStep(2, 'Details', true),
                _buildProgressLine(true),
                _buildProgressStep(3, 'Payment', false),
                _buildProgressLine(false),
                _buildProgressStep(4, 'Confirm', false),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(spacingUnit(2)),
                children: [
                  // Hotel Summary
                  Container(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    decoration: BoxDecoration(
                      color:
                          colorScheme(context).primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            colorScheme(context).primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(spacingUnit(1)),
                              decoration: BoxDecoration(
                                color: colorScheme(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.hotel,
                                color: colorScheme(context).primary,
                              ),
                            ),
                            SizedBox(width: spacingUnit(1.5)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel.name,
                                    style: ThemeText.subtitle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    hotel.category,
                                    style: ThemeText.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacingUnit(1.5)),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Check-in',
                                      style: ThemeText.caption),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(checkInDate),
                                    style: ThemeText.subtitle,
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
                                  const Text('Check-out',
                                      style: ThemeText.caption),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(checkOutDate),
                                    style: ThemeText.subtitle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacingUnit(1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$numberOfNights ${numberOfNights == 1 ? 'Night' : 'Nights'} • $rooms ${rooms == 1 ? 'Room' : 'Rooms'}',
                              style: ThemeText.caption,
                            ),
                            Text(
                              'PKR ${totalPrice.toStringAsFixed(0)}',
                              style: ThemeText.subtitle.copyWith(
                                color: colorScheme(context).primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacingUnit(3)),

                  // Guest Information Header
                  const Text(
                    'Guest Information',
                    style: ThemeText.title2,
                  ),
                  SizedBox(height: spacingUnit(0.5)),
                  Text(
                    'Please provide details for the primary guest (additional guests can check-in later)',
                    style: ThemeText.caption
                        .copyWith(color: const Color(0xFFB3B3B3)),
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Guest Forms
                  ...List.generate(_guestControllers.length, (index) {
                    return _buildGuestForm(index);
                  }),

                  // Room Type Summary (if available)
                  if (roomType != null) ...[
                    SizedBox(height: spacingUnit(2)),
                    Container(
                      padding: EdgeInsets.all(spacingUnit(2)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bed,
                                  color: colorScheme(context).primary),
                              SizedBox(width: spacingUnit(1)),
                              const Text('Room Selection',
                                  style: ThemeText.subtitle),
                            ],
                          ),
                          SizedBox(height: spacingUnit(1.5)),
                          Text(
                            roomType!.name,
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            roomType!.description,
                            style: ThemeText.caption.copyWith(fontSize: 13),
                          ),
                          SizedBox(height: spacingUnit(1)),
                          Row(
                            children: [
                              Icon(Icons.people,
                                  size: 16, color: Colors.grey.shade600),
                              SizedBox(width: spacingUnit(0.5)),
                              Text('${roomType!.maxOccupancy} guests',
                                  style: ThemeText.caption),
                              SizedBox(width: spacingUnit(2)),
                              Icon(Icons.aspect_ratio,
                                  size: 16, color: Colors.grey.shade600),
                              SizedBox(width: spacingUnit(0.5)),
                              Text('${roomType!.sizeInSqFt} sq ft',
                                  style: ThemeText.caption),
                            ],
                          ),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            roomType!.bedType,
                            style: ThemeText.caption.copyWith(
                              color: colorScheme(context).primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Protection Plan
                  SizedBox(height: spacingUnit(2)),
                  Container(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: addProtectionPlan
                            ? colorScheme(context)
                                .primary
                                .withValues(alpha: 0.5)
                            : Colors.grey.shade300,
                        width: addProtectionPlan ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: colorScheme(context).primary,
                            ),
                            SizedBox(width: spacingUnit(1)),
                            const Expanded(
                              child: Text(
                                'Travel Protection Plan',
                                style: ThemeText.subtitle,
                              ),
                            ),
                            Text(
                              'PKR ${protectionPlanCost.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colorScheme(context).primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacingUnit(1.5)),
                        Text(
                          'Protect your booking with our comprehensive travel insurance:',
                          style: ThemeText.caption.copyWith(fontSize: 13),
                        ),
                        SizedBox(height: spacingUnit(1)),
                        _buildProtectionBenefit(
                            'Full refund if you cancel for any reason'),
                        _buildProtectionBenefit(
                            'Coverage for medical emergencies'),
                        _buildProtectionBenefit(
                            '24/7 travel assistance hotline'),
                        _buildProtectionBenefit(
                            'Trip delay & interruption coverage'),
                        SizedBox(height: spacingUnit(1.5)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              addProtectionPlan = !addProtectionPlan;
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: addProtectionPlan,
                                onChanged: (value) {
                                  setState(() {
                                    addProtectionPlan = value ?? false;
                                  });
                                },
                                activeColor: colorScheme(context).primary,
                              ),
                              Expanded(
                                child: Text(
                                  'Yes, add protection for PKR ${protectionPlanCost.toStringAsFixed(0)}',
                                  style: ThemeText.paragraph.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacingUnit(10)),
                ],
              ),
            ),
          ),
        ],
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
                    const Text('Total', style: ThemeText.caption),
                    Text(
                      'PKR ${finalTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).primary,
                      ),
                    ),
                    if (addProtectionPlan)
                      Text(
                        'Includes protection',
                        style: ThemeText.caption.copyWith(fontSize: 11),
                      )
                    else
                      Text(
                        '$guests ${guests == 1 ? 'Guest' : 'Guests'}',
                        style: ThemeText.caption.copyWith(fontSize: 11),
                      ),
                  ],
                ),
              ),
              SizedBox(width: spacingUnit(2)),
              Expanded(
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme(context).primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestForm(int index) {
    final controllers = _guestControllers[index];
    final isPrimary = index == 0;

    return Container(
      margin: EdgeInsets.only(bottom: spacingUnit(2)),
      padding: EdgeInsets.all(spacingUnit(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? colorScheme(context).primary.withValues(alpha: 0.5)
              : Colors.grey.shade300,
          width: isPrimary ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isPrimary ? 'Primary Guest' : 'Guest ${index + 1}',
                style: TextStyle(
                  color: isPrimary
                      ? colorScheme(context).primary
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isPrimary) ...[
                SizedBox(width: spacingUnit(1)),
                Icon(
                  Icons.star,
                  size: 16,
                  color: colorScheme(context).primary,
                ),
              ],
            ],
          ),
          SizedBox(height: spacingUnit(2)),

          // First Name
          TextFormField(
            controller: controllers['firstName'],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'First Name *',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),

          SizedBox(height: spacingUnit(1.5)),

          // Last Name
          TextFormField(
            controller: controllers['lastName'],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Last Name *',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
          ),

          SizedBox(height: spacingUnit(1.5)),

          // Email (required for primary guest only)
          TextFormField(
            controller: controllers['email'],
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: isPrimary ? 'Email *' : 'Email (optional)',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: isPrimary
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }
                : null,
          ),

          SizedBox(height: spacingUnit(1.5)),

          // Phone (required for primary guest only)
          TextFormField(
            controller: controllers['phone'],
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: isPrimary ? 'Phone Number *' : 'Phone (optional)',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: '03XX-XXXXXXX',
            ),
            validator: isPrimary
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isCompleted) {
    final isActive = step == 2;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted || isActive
                ? colorScheme(context).primary
                : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isActive ? colorScheme(context).primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    step.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        SizedBox(height: spacingUnit(0.5)),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isCompleted || isActive
                ? colorScheme(context).primary
                : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.only(bottom: spacingUnit(3)),
        color:
            isCompleted ? colorScheme(context).primary : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildProtectionBenefit(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green.shade600,
          ),
          SizedBox(width: spacingUnit(1)),
          Expanded(
            child: Text(
              text,
              style: ThemeText.caption.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
