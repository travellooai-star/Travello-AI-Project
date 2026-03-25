import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

/// Hotel Booking Confirmation & Invoice Screen
/// Shows complete booking details with QR code, invoice, and actions
class HotelBookingConfirmation extends StatefulWidget {
  const HotelBookingConfirmation({super.key});

  @override
  State<HotelBookingConfirmation> createState() =>
      _HotelBookingConfirmationState();
}

class _HotelBookingConfirmationState extends State<HotelBookingConfirmation> {
  Map<String, dynamic> bookingData = {};
  String bookingReference = '';

  @override
  void initState() {
    super.initState();
    _loadBookingData();
  }

  void _loadBookingData() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    setState(() {
      bookingData = args;
      bookingReference = args['bookingReference'] ??
          'HTL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  double get baseAmount {
    return bookingData['basePrice'] ?? bookingData['totalPrice'] ?? 0.0;
  }

  double get serviceCharge {
    return baseAmount * 0.05;
  }

  double get tourismTax {
    return baseAmount * 0.03;
  }

  double get gst {
    return baseAmount * 0.16;
  }

  double get protectionCost {
    return bookingData['protectionPlanCost'] ?? 0.0;
  }

  double get totalAmount {
    return bookingData['totalPrice'] ?? 0.0;
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text(
          'Are you sure you want to cancel this hotel booking? This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.back();
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _downloadInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invoice downloaded successfully'),
        backgroundColor: colorScheme(context).primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Booking details shared'),
        backgroundColor: colorScheme(context).primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = bookingData['hotel'];
    final roomType = bookingData['roomType'];
    final checkInDate = bookingData['checkInDate'] as DateTime?;
    final checkOutDate = bookingData['checkOutDate'] as DateTime?;
    final nights = bookingData['nights'] ?? 1;
    final rooms = bookingData['rooms'] ?? 1;
    final guests = bookingData['guests'] ?? 1;
    final guestsData = bookingData['guestsData'] as List? ?? [];
    final hasProtection = bookingData['protectionPlan'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: colorScheme(context).primary,
        foregroundColor: Colors.white,
        title: const Text('Booking Confirmed'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.until((route) => route.isFirst),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareBooking,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Success Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme(context).primary,
                    colorScheme(context).primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: spacingUnit(4),
                horizontal: spacingUnit(2),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                  SizedBox(height: spacingUnit(2)),
                  const Text(
                    'Booking Confirmed!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: spacingUnit(1)),
                  const Text(
                    'Your hotel reservation is confirmed',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: spacingUnit(3)),
                  Container(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'BOOKING REFERENCE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: spacingUnit(1)),
                        Text(
                          bookingReference,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Booking Details Cards
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Details Card
                  _buildCard(
                    title: 'Hotel Details',
                    icon: Icons.hotel,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: hotel?.images != null &&
                                    (hotel.images as List).isNotEmpty
                                ? Image.network(
                                    hotel.images[0],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child:
                                            const Icon(Icons.hotel, size: 40),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.hotel, size: 40),
                                  ),
                          ),
                          SizedBox(width: spacingUnit(2)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel?.name ?? 'Hotel',
                                  style: ThemeText.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: spacingUnit(0.5)),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: spacingUnit(1),
                                        vertical: spacingUnit(0.5),
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme(context)
                                            .primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        hotel?.category ?? '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme(context).primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: spacingUnit(1)),
                                    const Icon(Icons.star,
                                        size: 16, color: Colors.orange),
                                    SizedBox(width: spacingUnit(0.5)),
                                    Text(
                                      hotel?.rating?.toString() ?? '',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: spacingUnit(1)),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 14, color: Colors.grey.shade600),
                                    SizedBox(width: spacingUnit(0.5)),
                                    Expanded(
                                      child: Text(
                                        hotel?.address ?? '',
                                        style: ThemeText.caption
                                            .copyWith(fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (roomType != null) ...[
                        SizedBox(height: spacingUnit(2)),
                        Divider(color: Colors.grey.shade300),
                        SizedBox(height: spacingUnit(1.5)),
                        Row(
                          children: [
                            Icon(Icons.bed,
                                color: colorScheme(context).primary, size: 20),
                            SizedBox(width: spacingUnit(1)),
                            Text(
                              'Room Type',
                              style: ThemeText.subtitle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacingUnit(1)),
                        Container(
                          padding: EdgeInsets.all(spacingUnit(1.5)),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                roomType.name ?? 'Room',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: spacingUnit(0.5)),
                              Text(
                                roomType.description ?? '',
                                style: ThemeText.caption.copyWith(fontSize: 12),
                              ),
                              SizedBox(height: spacingUnit(1)),
                              Row(
                                children: [
                                  Icon(Icons.people,
                                      size: 14, color: Colors.grey.shade600),
                                  SizedBox(width: spacingUnit(0.5)),
                                  Text(
                                    '${roomType.maxOccupancy ?? ''} guests',
                                    style: ThemeText.caption
                                        .copyWith(fontSize: 12),
                                  ),
                                  SizedBox(width: spacingUnit(2)),
                                  Icon(Icons.aspect_ratio,
                                      size: 14, color: Colors.grey.shade600),
                                  SizedBox(width: spacingUnit(0.5)),
                                  Text(
                                    '${roomType.sizeInSqFt ?? ''} sq ft',
                                    style: ThemeText.caption
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                              if (roomType.bedType != null) ...[
                                SizedBox(height: spacingUnit(0.5)),
                                Text(
                                  '🛏️ ${roomType.bedType}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Check-in & Check-out Card
                  _buildCard(
                    title: 'Stay Details',
                    icon: Icons.calendar_today,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'CHECK-IN',
                              checkInDate != null
                                  ? _formatDate(checkInDate)
                                  : '-',
                              '2:00 PM',
                              Icons.login,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 60,
                            color: Colors.grey.shade300,
                            margin: EdgeInsets.symmetric(
                                horizontal: spacingUnit(1)),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'CHECK-OUT',
                              checkOutDate != null
                                  ? _formatDate(checkOutDate)
                                  : '-',
                              '12:00 PM',
                              Icons.logout,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingUnit(2)),
                      Container(
                        padding: EdgeInsets.all(spacingUnit(1.5)),
                        decoration: BoxDecoration(
                          color: colorScheme(context)
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStayDetail(
                                Icons.nights_stay, '$nights Nights'),
                            Container(
                              width: 1,
                              height: 30,
                              color: colorScheme(context)
                                  .primary
                                  .withValues(alpha: 0.3),
                            ),
                            _buildStayDetail(
                                Icons.meeting_room, '$rooms Rooms'),
                            Container(
                              width: 1,
                              height: 30,
                              color: colorScheme(context)
                                  .primary
                                  .withValues(alpha: 0.3),
                            ),
                            _buildStayDetail(Icons.people, '$guests Guests'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Guest Information Card
                  if (guestsData.isNotEmpty)
                    _buildCard(
                      title: 'Guest Information',
                      icon: Icons.person,
                      children: [
                        ...guestsData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final guest = entry.value as Map<String, dynamic>;
                          final isPrimary = index == 0;

                          return Container(
                            margin: EdgeInsets.only(
                                bottom: index < guestsData.length - 1
                                    ? spacingUnit(1.5)
                                    : 0),
                            padding: EdgeInsets.all(spacingUnit(1.5)),
                            decoration: BoxDecoration(
                              color: isPrimary
                                  ? colorScheme(context)
                                      .primary
                                      .withValues(alpha: 0.05)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: isPrimary
                                  ? Border.all(
                                      color: colorScheme(context)
                                          .primary
                                          .withValues(alpha: 0.3),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isPrimary
                                      ? colorScheme(context).primary
                                      : Colors.grey.shade400,
                                  radius: 24,
                                  child: Text(
                                    (guest['firstName'] as String?)
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        'G',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: spacingUnit(1.5)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${guest['firstName'] ?? ''} ${guest['lastName'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isPrimary) ...[
                                            SizedBox(width: spacingUnit(1)),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: spacingUnit(0.75),
                                                vertical: spacingUnit(0.25),
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme(context)
                                                    .primary,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'PRIMARY',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (guest['email'] != null &&
                                          guest['email']
                                              .toString()
                                              .isNotEmpty) ...[
                                        SizedBox(height: spacingUnit(0.5)),
                                        Text(
                                          guest['email'],
                                          style: ThemeText.caption
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                      if (guest['phone'] != null &&
                                          guest['phone']
                                              .toString()
                                              .isNotEmpty) ...[
                                        SizedBox(height: spacingUnit(0.25)),
                                        Text(
                                          guest['phone'],
                                          style: ThemeText.caption
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),

                  SizedBox(height: spacingUnit(2)),

                  // Price Breakdown Card
                  _buildCard(
                    title: 'Payment Summary',
                    icon: Icons.receipt_long,
                    children: [
                      _buildPriceRow('Room Charges', baseAmount),
                      _buildPriceRow('Service Charge (5%)', serviceCharge),
                      _buildPriceRow('Tourism Tax (3%)', tourismTax),
                      _buildPriceRow('GST (16%)', gst),
                      if (hasProtection && protectionCost > 0) ...[
                        SizedBox(height: spacingUnit(0.5)),
                        Container(
                          padding: EdgeInsets.all(spacingUnit(1)),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified_user,
                                  size: 16, color: Colors.green.shade700),
                              SizedBox(width: spacingUnit(1)),
                              const Expanded(
                                child: Text(
                                  'Travel Protection Plan',
                                  style: TextStyle(
                                    fontSize: 12,
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
                      SizedBox(height: spacingUnit(1.5)),
                      Divider(thickness: 1.5, color: Colors.grey.shade300),
                      SizedBox(height: spacingUnit(1.5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount Paid',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PKR ${totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme(context).primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingUnit(1)),
                      Container(
                        padding: EdgeInsets.all(spacingUnit(1)),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: Colors.green.shade700),
                            SizedBox(width: spacingUnit(1)),
                            const Expanded(
                              child: Text(
                                'Payment Successful',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // QR Code Card
                  _buildCard(
                    title: 'Check-in QR Code',
                    icon: Icons.qr_code,
                    children: [
                      const Text(
                        'Show this QR code at hotel reception for quick check-in',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacingUnit(2)),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(spacingUnit(2)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: bookingReference,
                            version: QrVersions.auto,
                            size: 180,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: spacingUnit(2)),
                      Text(
                        bookingReference,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Important Information
                  _buildCard(
                    title: 'Important Information',
                    icon: Icons.info_outline,
                    children: [
                      _buildInfoPoint(
                        '✓',
                        'A valid ID proof is required at check-in',
                        Colors.blue,
                      ),
                      _buildInfoPoint(
                        '✓',
                        'Early check-in subject to availability',
                        Colors.blue,
                      ),
                      _buildInfoPoint(
                        '✓',
                        hotel?.isRefundable == true
                            ? 'Free cancellation up to 24 hours before check-in'
                            : 'Non-refundable booking',
                        hotel?.isRefundable == true
                            ? Colors.green
                            : Colors.orange,
                      ),
                      _buildInfoPoint(
                        '✓',
                        'Contact hotel directly for any special requests',
                        Colors.blue,
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(3)),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _downloadInvoice,
                          icon: const Icon(Icons.download, size: 20),
                          label: const Text('Download Invoice'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme(context).primary,
                            side:
                                BorderSide(color: colorScheme(context).primary),
                            padding: EdgeInsets.symmetric(
                                vertical: spacingUnit(1.5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacingUnit(1.5)),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Get.until((route) => route.isFirst),
                          icon: const Icon(Icons.home, size: 20),
                          label: const Text('Back to Home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme(context).primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: spacingUnit(1.5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (hotel?.isRefundable == true) ...[
                    SizedBox(height: spacingUnit(1.5)),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _cancelBooking,
                        icon: const Icon(Icons.cancel, size: 20),
                        label: const Text('Cancel Booking'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding:
                              EdgeInsets.symmetric(vertical: spacingUnit(1.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: spacingUnit(3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: colorScheme(context).primary, size: 22),
                SizedBox(width: spacingUnit(1)),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(spacingUnit(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      String label, String value, String subValue, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colorScheme(context).primary),
            SizedBox(width: spacingUnit(0.5)),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(0.5)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subValue,
          style: ThemeText.caption.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStayDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorScheme(context).primary),
        SizedBox(width: spacingUnit(0.75)),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            'PKR ${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(String bullet, String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bullet,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: spacingUnit(1)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
