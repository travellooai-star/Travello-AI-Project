import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/screens/orders/hotel_booking_confirmation.dart';

class PaymentScreenProfessional extends StatefulWidget {
  const PaymentScreenProfessional({super.key});

  @override
  State<PaymentScreenProfessional> createState() =>
      _PaymentScreenProfessionalState();
}

class _PaymentScreenProfessionalState extends State<PaymentScreenProfessional> {
  late Map<String, dynamic> bookingData;
  late String bookingType; // 'flight', 'train', 'hotel', or 'transport'
  late double totalPrice;

  final _formKey = GlobalKey<FormState>();

  String _selectedPaymentMethod = 'Card';
  final List<String> _paymentMethods = [
    'Card',
    'JazzCash',
    'Easypaisa',
    'Bank Transfer',
  ];

  // Card details
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // Mobile wallet
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  bool _isProcessing = false;
  bool _showOutboundDetails = false;
  bool _showReturnDetails = false;
  bool _showTrainDetails = false;

  @override
  void initState() {
    super.initState();
    bookingData = Get.arguments ?? {};
    bookingType = bookingData['bookingType'] ?? 'flight';
    totalPrice = bookingData['totalPrice'] ?? 0.0;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _mobileNumberController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _processPayment() {
    // Validate form before processing
    if (!_formKey.currentState!.validate()) {
      // If form is not valid, show error message
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isProcessing = false);

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(spacingUnit(2)),
                decoration: BoxDecoration(
                  color: colorScheme(context).primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.check_mark_circled,
                  color: colorScheme(context).primary,
                  size: 60,
                ),
              ),
              SizedBox(height: spacingUnit(2)),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacingUnit(1)),
              Text(
                'Your ${bookingType == 'flight' ? 'flight' : bookingType == 'train' ? 'train' : bookingType == 'hotel' ? 'hotel' : 'transport'} has been booked successfully',
                textAlign: TextAlign.center,
                style: ThemeText.caption,
              ),
              SizedBox(height: spacingUnit(1)),
              Container(
                padding: EdgeInsets.all(spacingUnit(2)),
                decoration: BoxDecoration(
                  color: colorScheme(context).surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Booking Reference',
                      style: ThemeText.caption,
                    ),
                    SizedBox(height: spacingUnit(0.5)),
                    Text(
                      'TRA${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacingUnit(3)),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  // For hotel bookings, navigate to confirmation screen
                  if (bookingType == 'hotel') {
                    Get.to(
                      () => const HotelBookingConfirmation(),
                      arguments: {
                        'bookingReference':
                            'HTL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        'hotel': bookingData['hotel'],
                        'roomType': bookingData['roomType'],
                        'checkInDate': bookingData['checkInDate'],
                        'checkOutDate': bookingData['checkOutDate'],
                        'nights': bookingData['nights'],
                        'rooms': bookingData['rooms'],
                        'guests': bookingData['guests'],
                        'guestsData': bookingData['guestsData'],
                        'protectionPlan': bookingData['protectionPlan'],
                        'protectionPlanCost':
                            bookingData['protectionPlan'] == true
                                ? (bookingData['basePrice'] ??
                                        bookingData['totalPrice'] ??
                                        0.0) *
                                    0.05
                                : 0.0,
                        'basePrice': bookingData['basePrice'] ??
                            bookingData['totalPrice'],
                        'totalPrice': totalPrice,
                      },
                    );
                  } else {
                    // For other bookings, go to home
                    Get.until((route) => route.isFirst);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme(context).primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = colorScheme(context).primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Payment'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Stepper
            Container(
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                color: colorScheme(context).surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: bookingType == 'hotel'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStepIndicatorWithNumber(
                            1, 'Search', true, false, primaryColor),
                        _buildStepLine(true, primaryColor),
                        _buildStepIndicatorWithNumber(
                            2, 'Details', true, false, primaryColor),
                        _buildStepLine(true, primaryColor),
                        _buildStepIndicatorWithNumber(
                            3, 'Payment', false, true, primaryColor),
                        _buildStepLine(false, primaryColor),
                        _buildStepIndicatorWithNumber(
                            4, 'Confirm', false, false, primaryColor),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStepIndicator('PASSENGERS', true, primaryColor),
                        _buildStepLine(true, primaryColor),
                        _buildStepIndicator(
                            bookingType == 'flight' ? 'FACILITIES' : 'CLASS',
                            true,
                            primaryColor),
                        _buildStepLine(true, primaryColor),
                        _buildStepIndicator('CHECKOUT', true, primaryColor),
                        _buildStepLine(true, primaryColor),
                        _buildStepIndicator('PAYMENT', true, primaryColor),
                        _buildStepLine(false, primaryColor),
                        _buildStepIndicator('DONE', false, primaryColor),
                      ],
                    ),
            ),

            // Booking Summary
            Container(
              margin: EdgeInsets.all(spacingUnit(2)),
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                color: colorScheme(context).surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: bookingType == 'flight'
                  ? _buildFlightSummary()
                  : bookingType == 'train'
                      ? _buildTrainSummary()
                      : bookingType == 'hotel'
                          ? _buildHotelSummary()
                          : _buildTransportSummary(),
            ),

            // Fare breakdown
            Container(
              margin: EdgeInsets.all(spacingUnit(2)),
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        bookingType == 'flight'
                            ? CupertinoIcons.airplane
                            : bookingType == 'train'
                                ? CupertinoIcons.train_style_one
                                : bookingType == 'hotel'
                                    ? CupertinoIcons.building_2_fill
                                    : CupertinoIcons.car_detailed,
                        color: primaryColor,
                      ),
                      SizedBox(width: spacingUnit(1)),
                      Text(
                        'Fare Breakdown',
                        style: ThemeText.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacingUnit(2)),
                  if (bookingType == 'flight') ...[
                    _buildFareRow(
                        'Base Fare', (totalPrice * 0.85).toStringAsFixed(0)),
                    if (bookingData['addons']?['extraBaggage'] > 0)
                      _buildFareRow(
                        'Extra Baggage (${bookingData['addons']['extraBaggage']} kg)',
                        '${bookingData['addons']['extraBaggage'] * 1000}',
                      ),
                    if (bookingData['addons']?['selectedSeat'] != null)
                      _buildFareRow('Seat Selection', '2000'),
                    if (bookingData['addons']?['travelInsurance'] == true)
                      _buildFareRow('Travel Insurance', '1500'),
                    _buildFareRow(
                        'Taxes & Fees', (totalPrice * 0.15).toStringAsFixed(0)),
                  ] else if (bookingType == 'train') ...[
                    () {
                      final passengers =
                          bookingData['passengers'] as List? ?? [];
                      final pricePerPerson = totalPrice /
                          (passengers.isEmpty ? 1 : passengers.length);
                      return _buildFareRow(
                        '${passengers.length} passenger${passengers.length > 1 ? 's' : ''} × PKR ${pricePerPerson.toStringAsFixed(0)}',
                        totalPrice.toStringAsFixed(0),
                      );
                    }(),
                  ] else if (bookingType == 'hotel') ...[
                    () {
                      final nights = bookingData['nights'] ?? 1;
                      final rooms = bookingData['rooms'] ?? 1;
                      final basePrice = bookingData['basePrice'];
                      final roomTypePrice =
                          bookingData['roomType']?.pricePerNight;
                      final pricePerNight = roomTypePrice ??
                          bookingData['hotel']?.pricePerNight ??
                          0.0;
                      final baseAmount =
                          basePrice ?? (pricePerNight * nights * rooms);
                      final serviceCharge = baseAmount * 0.05; // 5%
                      final tourismTax = baseAmount * 0.03; // 3%
                      final gst = baseAmount * 0.16; // 16%
                      final protectionPlan =
                          bookingData['protectionPlan'] == true;
                      final protectionCost =
                          bookingData['protectionPlanCost'] ?? 0.0;

                      return Column(
                        children: [
                          _buildFareRow(
                            'PKR ${pricePerNight.toStringAsFixed(0)} × $nights night${nights > 1 ? 's' : ''} × $rooms room${rooms > 1 ? 's' : ''}',
                            baseAmount.toStringAsFixed(0),
                          ),
                          SizedBox(height: spacingUnit(1)),
                          _buildFareRow(
                            'Service Charge (5%)',
                            serviceCharge.toStringAsFixed(0),
                          ),
                          _buildFareRow(
                            'Tourism Tax (3%)',
                            tourismTax.toStringAsFixed(0),
                          ),
                          _buildFareRow(
                            'GST (16%)',
                            gst.toStringAsFixed(0),
                          ),
                          if (protectionPlan && protectionCost > 0) ...[
                            SizedBox(height: spacingUnit(1)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacingUnit(1.5),
                                vertical: spacingUnit(1),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified_user,
                                    size: 16,
                                    color: Colors.green.shade700,
                                  ),
                                  SizedBox(width: spacingUnit(1)),
                                  const Expanded(
                                    child: Text(
                                      'Travel Protection Plan',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'PKR ${protectionCost.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    }(),
                  ] else if (bookingType == 'transport') ...[
                    () {
                      final transport = bookingData['transport'];
                      final basePrice = transport?.basePrice ?? 0.0;
                      final pricePerKm = transport?.pricePerKm ?? 0.0;
                      final distance = bookingData['estimatedDistance'] ?? 0.0;
                      return Column(
                        children: [
                          _buildFareRow(
                              'Base Fare', basePrice.toStringAsFixed(0)),
                          if (distance > 0)
                            _buildFareRow(
                              'Distance (${distance.toStringAsFixed(0)} km × PKR ${pricePerKm.toStringAsFixed(0)})',
                              (pricePerKm * distance).toStringAsFixed(0),
                            ),
                        ],
                      );
                    }(),
                  ],
                  Divider(height: spacingUnit(3), thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'PKR ${totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment method selection
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style: ThemeText.title2,
                  ),

                  SizedBox(height: spacingUnit(2)),

                  ...List.generate(_paymentMethods.length, (index) {
                    final method = _paymentMethods[index];
                    final isSelected = _selectedPaymentMethod == method;

                    IconData icon;
                    switch (method) {
                      case 'Card':
                        icon = CupertinoIcons.creditcard;
                        break;
                      case 'JazzCash':
                        icon = CupertinoIcons.device_phone_portrait;
                        break;
                      case 'Easypaisa':
                        icon = CupertinoIcons.device_phone_portrait;
                        break;
                      case 'Bank Transfer':
                        icon = CupertinoIcons.building_2_fill;
                        break;
                      default:
                        icon = CupertinoIcons.money_dollar;
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: spacingUnit(1.5)),
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedPaymentMethod = method);
                        },
                        child: Container(
                          padding: EdgeInsets.all(spacingUnit(2)),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor.withValues(alpha: 0.1)
                                : colorScheme(context).surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(spacingUnit(1)),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor
                                      : Colors.grey.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  icon,
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                ),
                              ),
                              SizedBox(width: spacingUnit(1.5)),
                              Text(
                                method,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                Icon(
                                  CupertinoIcons.check_mark_circled_solid,
                                  color: primaryColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: spacingUnit(3)),

                  // Payment details form
                  if (_selectedPaymentMethod == 'Card')
                    _buildCardForm()
                  else if (_selectedPaymentMethod == 'JazzCash' ||
                      _selectedPaymentMethod == 'Easypaisa')
                    _buildMobileWalletForm()
                  else
                    _buildBankTransferInfo(),
                ],
              ),
            ),

            SizedBox(height: spacingUnit(10)),
          ],
        ),
      ),

      // Confirm button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: colorScheme(context).surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Confirm Payment • PKR ${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingUnit(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: ThemeText.caption),
          Text('PKR $amount', style: ThemeText.subtitle),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: BorderRadius.circular(16),
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
            const Text('Card Details', style: ThemeText.subtitle),
            SizedBox(height: spacingUnit(2)),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number *',
                hintText: '0000 0000 0000 0000',
                prefixIcon: const Icon(CupertinoIcons.creditcard),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 19, // 16 digits + 3 spaces
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                String cleanValue = value.replaceAll(' ', '');
                if (cleanValue.length != 16) {
                  return 'Card number must be 16 digits';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
                  return 'Card number should only contain numbers';
                }
                return null;
              },
              onChanged: (value) {
                // Auto-format card number with spaces
                String cleanValue = value.replaceAll(' ', '');
                if (cleanValue.length <= 16) {
                  String formatted = '';
                  for (int i = 0; i < cleanValue.length; i++) {
                    if (i > 0 && i % 4 == 0) {
                      formatted += ' ';
                    }
                    formatted += cleanValue[i];
                  }
                  if (formatted != value) {
                    _cardNumberController.value = TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                }
              },
            ),
            SizedBox(height: spacingUnit(2)),
            TextFormField(
              controller: _cardHolderController,
              decoration: InputDecoration(
                labelText: 'Card Holder Name *',
                prefixIcon: const Icon(CupertinoIcons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card holder name';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Name should only contain letters';
                }
                return null;
              },
            ),
            SizedBox(height: spacingUnit(2)),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry *',
                      hintText: 'MM/YY',
                      prefixIcon: const Icon(CupertinoIcons.calendar),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5, // MM/YY
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                        return 'Format: MM/YY';
                      }
                      List<String> parts = value.split('/');
                      int month = int.parse(parts[0]);
                      int year = int.parse(parts[1]) + 2000;

                      if (month < 1 || month > 12) {
                        return 'Invalid month';
                      }

                      DateTime now = DateTime.now();
                      DateTime expiry = DateTime(year, month);

                      if (expiry.isBefore(DateTime(now.year, now.month))) {
                        return 'Card expired';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      // Auto-format expiry with slash
                      String cleanValue = value.replaceAll('/', '');
                      if (cleanValue.length >= 2 && !value.contains('/')) {
                        String formatted =
                            '${cleanValue.substring(0, 2)}/${cleanValue.substring(2)}';
                        if (formatted.length <= 5) {
                          _expiryController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                                offset: formatted.length),
                          );
                        }
                      }
                    },
                  ),
                ),
                SizedBox(width: spacingUnit(2)),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV *',
                      hintText: '000',
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CVV';
                      }
                      if (value.length < 3 || value.length > 4) {
                        return '3-4 digits';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Numbers only';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileWalletForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: BorderRadius.circular(16),
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
            Text('$_selectedPaymentMethod Details', style: ThemeText.subtitle),
            SizedBox(height: spacingUnit(2)),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number *',
                hintText: '03001234567',
                prefixIcon: const Icon(CupertinoIcons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixText: '+92 ',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 11,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                String cleanValue =
                    value.replaceAll('-', '').replaceAll(' ', '');
                if (!cleanValue.startsWith('03')) {
                  return 'Mobile number must start with 03';
                }
                if (cleanValue.length != 11) {
                  return 'Mobile number must be 11 digits';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
                  return 'Mobile number should only contain numbers';
                }
                return null;
              },
            ),
            SizedBox(height: spacingUnit(2)),
            TextFormField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'PIN *',
                hintText: '4-digit PIN',
                prefixIcon: const Icon(CupertinoIcons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter PIN';
                }
                if (value.length != 4) {
                  return 'PIN must be exactly 4 digits';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'PIN should only contain numbers';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankTransferInfo() {
    return Container(
      padding: EdgeInsets.all(spacingUnit(2)),
      decoration: BoxDecoration(
        color: colorScheme(context).surface,
        borderRadius: BorderRadius.circular(16),
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
          const Text('Bank Transfer Details', style: ThemeText.subtitle),
          SizedBox(height: spacingUnit(2)),
          _buildInfoRow('Bank Name', 'Meezan Bank'),
          _buildInfoRow('Account Title', 'Travello AI'),
          _buildInfoRow('Account Number', '0123456789012'),
          _buildInfoRow('IBAN', 'PK12MEZN0000120123456789'),
          SizedBox(height: spacingUnit(2)),
          Container(
            padding: EdgeInsets.all(spacingUnit(1.5)),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.info_circle,
                  color: Colors.orange,
                  size: 20,
                ),
                SizedBox(width: spacingUnit(1)),
                Expanded(
                  child: Text(
                    'Transfer the amount and share receipt via email',
                    style: ThemeText.caption.copyWith(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingUnit(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: ThemeText.caption),
          Text(value, style: ThemeText.subtitle),
        ],
      ),
    );
  }

  Widget _buildFlightSummary() {
    final flight = bookingData['flight'];
    if (flight == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacingUnit(1.5)),
              decoration: BoxDecoration(
                color: colorScheme(context).primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                CupertinoIcons.airplane,
                color: colorScheme(context).primary,
                size: 28,
              ),
            ),
            SizedBox(width: spacingUnit(1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flight.airlineName ?? 'Flight',
                    style: ThemeText.subtitle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${flight.airlineCode ?? ''} • ${flight.cabinClass ?? 'Economy'}',
                    style: ThemeText.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flight.departureTime ?? '',
                  style: ThemeText.title2,
                ),
                Text(
                  bookingData['searchParams']?['fromAirport']?.code ?? 'DEP',
                  style: ThemeText.caption,
                ),
              ],
            ),
            Column(
              children: [
                Icon(
                  CupertinoIcons.arrow_right,
                  color: colorScheme(context).primary,
                ),
                Text(
                  flight.duration ?? '',
                  style: ThemeText.caption,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  flight.arrivalTime ?? '',
                  style: ThemeText.title2,
                ),
                Text(
                  bookingData['searchParams']?['toAirport']?.code ?? 'ARR',
                  style: ThemeText.caption,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrainSummary() {
    final isRoundTrip = bookingData['isRoundTrip'] ?? false;

    if (isRoundTrip) {
      final outboundTrain = bookingData['outboundTrain'];
      final returnTrain = bookingData['returnTrain'];
      final outboundClass = bookingData['outboundClass'] ?? 'Economy';
      final returnClass = bookingData['returnClass'] ?? 'Economy';

      if (outboundTrain == null || returnTrain == null) return const SizedBox();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outbound Train Header
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(1), vertical: spacingUnit(0.5)),
            decoration: BoxDecoration(
              color: colorScheme(context).primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'OUTBOUND JOURNEY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorScheme(context).primary,
              ),
            ),
          ),
          SizedBox(height: spacingUnit(1.5)),
          _buildSingleTrainSummary(
            outboundTrain,
            outboundClass,
            bookingData['searchParams']?['fromStation']?.code ?? 'DEP',
            bookingData['searchParams']?['toStation']?.code ?? 'ARR',
            bookingData['searchParams']?['fromStation']?.name ??
                'Departure Station',
            bookingData['searchParams']?['toStation']?.name ??
                'Arrival Station',
            bookingData['searchParams']?['departureDate'],
            true, // isOutbound
          ),

          SizedBox(height: spacingUnit(2)),
          Divider(thickness: 1, color: Colors.grey.withValues(alpha: 0.3)),
          SizedBox(height: spacingUnit(2)),

          // Return Train Header
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(1), vertical: spacingUnit(0.5)),
            decoration: BoxDecoration(
              color: colorScheme(context).primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'RETURN JOURNEY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorScheme(context).primary,
              ),
            ),
          ),
          SizedBox(height: spacingUnit(1.5)),
          _buildSingleTrainSummary(
            returnTrain,
            returnClass,
            bookingData['searchParams']?['toStation']?.code ?? 'ARR',
            bookingData['searchParams']?['fromStation']?.code ?? 'DEP',
            bookingData['searchParams']?['toStation']?.name ??
                'Departure Station',
            bookingData['searchParams']?['fromStation']?.name ??
                'Arrival Station',
            bookingData['searchParams']?['returnDate'],
            false, // isReturn
          ),
        ],
      );
    } else {
      // One-way journey
      final train = bookingData['train'];
      final selectedClass = bookingData['selectedClass'] ?? 'Economy';
      if (train == null) return const SizedBox();

      return _buildSingleTrainSummary(
        train,
        selectedClass,
        bookingData['searchParams']?['fromStation']?.code ?? 'DEP',
        bookingData['searchParams']?['toStation']?.code ?? 'ARR',
        bookingData['searchParams']?['fromStation']?.name ??
            'Departure Station',
        bookingData['searchParams']?['toStation']?.name ?? 'Arrival Station',
        bookingData['searchParams']?['departureDate'],
        null, // single trip
      );
    }
  }

  Widget _buildSingleTrainSummary(
    dynamic train,
    String selectedClass,
    String fromCode,
    String toCode,
    String fromName,
    String toName,
    DateTime? travelDate,
    bool? isOutbound, // true = outbound, false = return, null = one-way
  ) {
    // Determine which details state to use
    bool showDetails = isOutbound == true
        ? _showOutboundDetails
        : isOutbound == false
            ? _showReturnDetails
            : _showTrainDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacingUnit(1.5)),
              decoration: BoxDecoration(
                color: colorScheme(context).primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                CupertinoIcons.train_style_one,
                color: colorScheme(context).primary,
                size: 28,
              ),
            ),
            SizedBox(width: spacingUnit(1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    train.trainName ?? 'Train',
                    style: ThemeText.subtitle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${train.trainNumber ?? ''} • $selectedClass',
                    style: ThemeText.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  train.departureTime ?? '',
                  style: ThemeText.title2,
                ),
                Text(
                  fromCode,
                  style: ThemeText.caption,
                ),
              ],
            ),
            Column(
              children: [
                Icon(
                  CupertinoIcons.arrow_right,
                  color: colorScheme(context).primary,
                ),
                Text(
                  train.duration ?? '',
                  style: ThemeText.caption,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  train.arrivalTime ?? '',
                  style: ThemeText.title2,
                ),
                Text(
                  toCode,
                  style: ThemeText.caption,
                ),
              ],
            ),
          ],
        ),

        // Show/Hide Details Button
        SizedBox(height: spacingUnit(1.5)),
        GestureDetector(
          onTap: () {
            setState(() {
              if (isOutbound == true) {
                _showOutboundDetails = !_showOutboundDetails;
              } else if (isOutbound == false) {
                _showReturnDetails = !_showReturnDetails;
              } else {
                _showTrainDetails = !_showTrainDetails;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showDetails ? 'Hide details' : 'Show details',
                style: TextStyle(
                  color: colorScheme(context).primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: spacingUnit(0.5)),
              Icon(
                showDetails
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down,
                color: colorScheme(context).primary,
                size: 16,
              ),
            ],
          ),
        ),

        // Expandable Details Section
        if (showDetails) ...[
          SizedBox(height: spacingUnit(2)),
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color:
                  colorScheme(context).primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme(context).primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                if (travelDate != null) ...[
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: spacingUnit(1)),
                      Text(
                        _formatDate(travelDate),
                        style: ThemeText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacingUnit(2)),
                ],

                // Departure Station
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme(context).primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 60,
                          color: colorScheme(context)
                              .primary
                              .withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    SizedBox(width: spacingUnit(1.5)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            train.departureTime ?? '',
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '($fromCode) $fromName',
                            style: ThemeText.caption,
                          ),
                          SizedBox(height: spacingUnit(0.5)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingUnit(1),
                              vertical: spacingUnit(0.5),
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme(context).primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.train_style_one,
                                  size: 14,
                                  color: colorScheme(context).primary,
                                ),
                                SizedBox(width: spacingUnit(0.5)),
                                Text(
                                  '${train.trainNumber ?? ''} • ${train.trainName ?? ''}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme(context).primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Duration indicator
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Container(
                      width: 2,
                      height: 30,
                      color:
                          colorScheme(context).primary.withValues(alpha: 0.3),
                    ),
                    SizedBox(width: spacingUnit(1.5)),
                    Icon(
                      CupertinoIcons.time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      train.duration ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Arrival Station
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 2,
                          height: 20,
                          color: colorScheme(context)
                              .primary
                              .withValues(alpha: 0.3),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme(context).primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: spacingUnit(1.5)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            train.arrivalTime ?? '',
                            style: ThemeText.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '($toCode) $toName',
                            style: ThemeText.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacingUnit(2)),
                Divider(height: 1, color: Colors.grey.withValues(alpha: 0.3)),
                SizedBox(height: spacingUnit(2)),

                // Class details
                Text(
                  selectedClass,
                  style: ThemeText.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacingUnit(1)),
                Row(
                  children: [
                    if (selectedClass.contains('AC')) ...[
                      Icon(
                        CupertinoIcons.snow,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: spacingUnit(0.5)),
                      const Text(
                        'Air Conditioned',
                        style: ThemeText.caption,
                      ),
                      SizedBox(width: spacingUnit(2)),
                    ],
                    Icon(
                      CupertinoIcons.person_2,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      selectedClass.contains('Sleeper')
                          ? 'Sleeping Berths'
                          : 'Comfortable Seating',
                      style: ThemeText.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHotelSummary() {
    final hotel = bookingData['hotel'];
    if (hotel == null) return const SizedBox();

    final checkInDate = bookingData['checkInDate'] as DateTime?;
    final checkOutDate = bookingData['checkOutDate'] as DateTime?;
    final nights = bookingData['nights'] ?? 1;
    final rooms = bookingData['rooms'] ?? 1;
    final guests = bookingData['guests'] ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacingUnit(1.5)),
              decoration: BoxDecoration(
                color: colorScheme(context).primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                CupertinoIcons.building_2_fill,
                color: colorScheme(context).primary,
                size: 28,
              ),
            ),
            SizedBox(width: spacingUnit(1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name ?? 'Hotel',
                    style: ThemeText.subtitle
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${hotel.category ?? ''} • ${hotel.city ?? ''}',
                    style: ThemeText.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check-in',
                    style: ThemeText.caption.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    checkInDate != null ? _formatDate(checkInDate) : '-',
                    style: ThemeText.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.nights_stay,
                  color: colorScheme(context).primary,
                  size: 20,
                ),
                Text(
                  '$nights night${nights > 1 ? 's' : ''}',
                  style: ThemeText.caption,
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Check-out',
                    style: ThemeText.caption.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    checkOutDate != null ? _formatDate(checkOutDate) : '-',
                    style: ThemeText.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
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
            Icon(
              CupertinoIcons.person_2,
              size: 18,
              color: Colors.grey[600],
            ),
            SizedBox(width: spacingUnit(0.75)),
            Text(
              '$guests Guest${guests > 1 ? 's' : ''}',
              style: ThemeText.paragraph,
            ),
            SizedBox(width: spacingUnit(2.5)),
            Icon(
              CupertinoIcons.bed_double,
              size: 18,
              color: Colors.grey[600],
            ),
            SizedBox(width: spacingUnit(0.75)),
            Text(
              '$rooms Room${rooms > 1 ? 's' : ''}',
              style: ThemeText.paragraph,
            ),
          ],
        ),

        // Room Type Details (if available)
        if (bookingData['roomType'] != null) ...[
          SizedBox(height: spacingUnit(2)),
          Divider(thickness: 1, color: Colors.grey.withValues(alpha: 0.3)),
          SizedBox(height: spacingUnit(1.5)),
          Row(
            children: [
              Icon(
                CupertinoIcons.bed_double_fill,
                color: colorScheme(context).primary,
                size: 20,
              ),
              SizedBox(width: spacingUnit(1.5)),
              const Text(
                'Room Type',
                style: ThemeText.subtitle2,
              ),
            ],
          ),
          SizedBox(height: spacingUnit(1.5)),
          Container(
            padding: EdgeInsets.all(spacingUnit(1.5)),
            decoration: BoxDecoration(
              color:
                  colorScheme(context).primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingData['roomType'].name ?? 'Room',
                  style: ThemeText.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  bookingData['roomType'].description ?? '',
                  style: ThemeText.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacingUnit(1)),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      '${bookingData['roomType'].maxOccupancy ?? ''} guests',
                      style: ThemeText.caption,
                    ),
                    SizedBox(width: spacingUnit(2)),
                    Icon(Icons.aspect_ratio,
                        size: 16, color: Colors.grey.shade600),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      '${bookingData['roomType'].sizeInSqFt ?? ''} sq ft',
                      style: ThemeText.caption,
                    ),
                  ],
                ),
                if (bookingData['roomType'].bedType != null) ...[
                  SizedBox(height: spacingUnit(0.5)),
                  Row(
                    children: [
                      Icon(CupertinoIcons.bed_double,
                          size: 16, color: Colors.grey.shade600),
                      SizedBox(width: spacingUnit(0.5)),
                      Text(
                        bookingData['roomType'].bedType ?? '',
                        style: ThemeText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                if (bookingData['roomType'].breakfastIncluded == true) ...[
                  SizedBox(height: spacingUnit(0.75)),
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: Colors.green.shade600),
                      SizedBox(width: spacingUnit(0.5)),
                      Text(
                        'Breakfast included',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],

        // Guest Details
        if (bookingData['guestsData'] != null &&
            (bookingData['guestsData'] as List).isNotEmpty) ...[
          SizedBox(height: spacingUnit(2)),
          Divider(thickness: 1, color: Colors.grey.withValues(alpha: 0.3)),
          SizedBox(height: spacingUnit(1.5)),
          Text(
            'Guest Details',
            style: ThemeText.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacingUnit(1.5)),
          ...(bookingData['guestsData'] as List)
              .asMap()
              .entries
              .map<Widget>((entry) {
            final index = entry.key;
            final guest = entry.value as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(bottom: spacingUnit(0.75)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(spacingUnit(0.75)),
                    decoration: BoxDecoration(
                      color: colorScheme(context)
                          .primaryContainer
                          .withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      size: 16,
                      color: colorScheme(context).primary,
                    ),
                  ),
                  SizedBox(width: spacingUnit(1.5)),
                  Expanded(
                    child: Text(
                      '${guest['firstName'] ?? ''} ${guest['lastName'] ?? ''}',
                      style: ThemeText.paragraph.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (index == 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingUnit(1),
                        vertical: spacingUnit(0.25),
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme(context)
                            .primary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Primary',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorScheme(context).primary,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],

        // Cancellation Policy
        SizedBox(height: spacingUnit(2)),
        Divider(thickness: 1, color: Colors.grey.withValues(alpha: 0.3)),
        SizedBox(height: spacingUnit(1.5)),
        Container(
          padding: EdgeInsets.all(spacingUnit(1.5)),
          decoration: BoxDecoration(
            color: hotel.isRefundable == true
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hotel.isRefundable == true
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.orange.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                hotel.isRefundable == true
                    ? CupertinoIcons.checkmark_shield_fill
                    : CupertinoIcons.info_circle_fill,
                color:
                    hotel.isRefundable == true ? Colors.green : Colors.orange,
                size: 20,
              ),
              SizedBox(width: spacingUnit(1.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.isRefundable == true
                          ? 'Refundable'
                          : 'Non-Refundable',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: hotel.isRefundable == true
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: spacingUnit(0.5)),
                    Text(
                      hotel.isRefundable == true
                          ? 'Free cancellation up to 24 hours before check-in'
                          : 'This rate is non-refundable',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Hotel Amenities Summary
        if (hotel.amenities != null && hotel.amenities!.isNotEmpty) ...[
          SizedBox(height: spacingUnit(1.5)),
          Wrap(
            spacing: spacingUnit(1),
            runSpacing: spacingUnit(0.5),
            children: hotel.amenities!.take(4).map<Widget>((amenity) {
              IconData icon;
              switch (amenity.toLowerCase()) {
                case 'free wifi':
                case 'wifi':
                  icon = CupertinoIcons.wifi;
                  break;
                case 'parking':
                case 'free parking':
                  icon = CupertinoIcons.car_fill;
                  break;
                case 'breakfast':
                case 'free breakfast':
                  icon = CupertinoIcons.square_favorites_alt_fill;
                  break;
                case 'pool':
                case 'swimming pool':
                  icon = Icons.pool;
                  break;
                case 'gym':
                case 'fitness center':
                  icon = Icons.fitness_center;
                  break;
                default:
                  icon = CupertinoIcons.checkmark_circle_fill;
              }
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(1.5),
                  vertical: spacingUnit(0.75),
                ),
                decoration: BoxDecoration(
                  color: colorScheme(context).surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: colorScheme(context).primary,
                    ),
                    SizedBox(width: spacingUnit(0.75)),
                    Text(
                      amenity,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTransportSummary() {
    final transport = bookingData['transport'];
    if (transport == null) return const SizedBox();

    final pickupLocation = bookingData['pickupLocation'] ?? '';
    final dropoffLocation = bookingData['dropoffLocation'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacingUnit(1.5)),
              decoration: BoxDecoration(
                color: colorScheme(context).primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                CupertinoIcons.car_detailed,
                color: colorScheme(context).primary,
                size: 28,
              ),
            ),
            SizedBox(width: spacingUnit(1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transport.name ?? 'Transport',
                    style: ThemeText.subtitle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${transport.vehicleModel ?? ''} • ${transport.type ?? ''}',
                    style: ThemeText.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(2)),
        if (pickupLocation.isNotEmpty || dropoffLocation.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorScheme(context).primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.grey[400],
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(width: spacingUnit(1.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickup',
                      style: ThemeText.caption,
                    ),
                    Text(
                      pickupLocation.isNotEmpty ? pickupLocation : '-',
                      style: ThemeText.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacingUnit(2)),
                    const Text(
                      'Drop-off',
                      style: ThemeText.caption,
                    ),
                    Text(
                      dropoffLocation.isNotEmpty ? dropoffLocation : '-',
                      style: ThemeText.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(2)),
        ],
        Row(
          children: [
            if (transport.isAC == true) ...[
              Icon(
                CupertinoIcons.snow,
                size: 16,
                color: Colors.grey[600],
              ),
              SizedBox(width: spacingUnit(0.5)),
              const Text(
                'Air Conditioned',
                style: ThemeText.caption,
              ),
              SizedBox(width: spacingUnit(2)),
            ],
            Icon(
              CupertinoIcons.person_2,
              size: 16,
              color: Colors.grey[600],
            ),
            SizedBox(width: spacingUnit(0.5)),
            Text(
              '${transport.seatingCapacity ?? 0} Seats',
              style: ThemeText.caption,
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}';
  }

  Widget _buildStepIndicator(String label, bool isActive, Color activeColor) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : Colors.grey.shade300,
          ),
          child: isActive
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              : null,
        ),
        SizedBox(height: spacingUnit(0.5)),
        Text(
          label,
          style: ThemeText.caption.copyWith(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? activeColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicatorWithNumber(int step, String label, bool isCompleted,
      bool isActive, Color activeColor) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? activeColor : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? activeColor : Colors.transparent,
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
            color: isCompleted || isActive ? activeColor : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive, Color activeColor) {
    return Container(
      width: 30,
      height: 2,
      margin: EdgeInsets.only(bottom: spacingUnit(2.5)),
      color: isActive ? activeColor : Colors.grey.shade300,
    );
  }
}
