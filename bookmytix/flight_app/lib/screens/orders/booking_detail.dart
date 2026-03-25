import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  🎫 PROFESSIONAL BOOKING DETAIL PAGE
//  Industry-Level Design - Consistent UI for Train & Flight Details
//  Inspired by: MakeMyTrip, Cleartrip, Emirates, Pakistan Railways
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class BookingDetail extends StatefulWidget {
  const BookingDetail({super.key});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  Map<String, dynamic> _booking = {};
  bool _isLoadingCancel = false;
  bool _downloadingPdf = false;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  void _loadBooking() {
    final booking = Get.arguments as Map<String, dynamic>?;
    if (booking != null) {
      setState(() {
        _booking = booking;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTrainBooking = (_booking['bookingType'] ?? 'flight') == 'train';

    return Scaffold(
      backgroundColor: colorScheme(context).surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isTrainBooking ? const Color(0xFF059669) : const Color(0xFF3B82F6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Booking Details',
          style: ThemeText.subtitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ━━━ Header with Type & PNR ━━━
            _buildHeader(isTrainBooking),

            // ━━━ E-Ticket Section with QR/Barcode ━━━
            _buildETicketSection(isTrainBooking),

            // ━━━ Journey Details ━━━
            _buildJourneySection(isTrainBooking),

            // ━━━ Passenger Details ━━━
            _buildPassengerSection(),

            // ━━━ Payment Summary ━━━
            _buildPaymentSection(),

            // ━━━ Important Information ━━━
            _buildInfoSection(isTrainBooking),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎨 UI COMPONENTS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildHeader(bool isTrainBooking) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isTrainBooking
              ? [const Color(0xFF059669), const Color(0xFF047857)]
              : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
        ),
      ),
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(1.5),
                  vertical: spacingUnit(0.7),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isTrainBooking ? Icons.train : Icons.flight,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      isTrainBooking ? 'TRAIN BOOKING' : 'FLIGHT BOOKING',
                      style: ThemeText.subtitle2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(_booking['status'] ?? 'confirmed'),
            ],
          ),
          SizedBox(height: spacingUnit(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PNR: ',
                style: ThemeText.paragraph.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                _booking['pnr'] ?? 'N/A',
                style: ThemeText.title.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(width: spacingUnit(1)),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                onPressed: () => _copyPNR(),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bgColor = const Color(0xFF10B981);
        label = 'CONFIRMED';
        icon = Icons.check_circle;
        break;
      case 'canceled':
        bgColor = const Color(0xFFEF4444);
        label = 'CANCELED';
        icon = Icons.cancel;
        break;
      case 'completed':
        bgColor = Colors.white.withOpacity(0.3);
        label = 'COMPLETED';
        icon = Icons.check_circle_outline;
        break;
      default:
        bgColor = const Color(0xFFF59E0B);
        label = 'PENDING';
        icon = Icons.access_time;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(1.2),
        vertical: spacingUnit(0.6),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          SizedBox(width: spacingUnit(0.5)),
          Text(
            label,
            style: ThemeText.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildETicketSection(bool isTrainBooking) {
    // ━━━ Professional Barcode Data Format (IATA-Style) ━━━
    final pnr = _booking['pnr'] ?? 'N/A';
    final passengerName = _booking['passengerName'] ?? 'PASSENGER';
    final details = isTrainBooking
        ? _booking['trainDetails'] as Map<String, dynamic>?
        : _booking['flightDetails'] as Map<String, dynamic>?;

    String barcodeData = pnr;
    String qrData = pnr;

    if (details != null) {
      if (isTrainBooking) {
        // Train format: PNR|TRAIN|FROM-TO|DATE|PAX|CLASS
        final trainNum = details['trainNumber'] ?? 'N/A';
        final fromCode = details['fromCode'] ?? 'N/A';
        final toCode = details['toCode'] ?? 'N/A';
        final date = details['date'] ?? 'N/A';
        final trainClass = details['class'] ?? 'Economy';

        barcodeData =
            '$pnr/$trainNum/$fromCode-$toCode/${date.replaceAll(' ', '')}/$passengerName/$trainClass';
        qrData =
            'TRAVELLO|TYPE:TRAIN|PNR:$pnr|TRAIN:$trainNum|ROUTE:$fromCode-$toCode|DATE:$date|PAX:$passengerName|CLASS:$trainClass';
      } else {
        // Flight format (IATA-inspired): PNR|FLT|FROM-TO|DATE|PAX|CLASS
        final flightNum = details['flightNumber'] ?? 'N/A';
        final date = details['date'] ?? 'N/A';
        final flightClass = details['class'] ?? 'Economy';

        // Extract airport codes
        final fromStr = details['from'] ?? 'N/A';
        final toStr = details['to'] ?? 'N/A';
        final fromMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(fromStr);
        final toMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(toStr);
        final fromCode =
            fromMatch?.group(1) ?? fromStr.substring(0, 3).toUpperCase();
        final toCode = toMatch?.group(1) ?? toStr.substring(0, 3).toUpperCase();

        // Professional airline barcode format
        barcodeData =
            '$pnr/$flightNum/$fromCode-$toCode/${date.replaceAll(' ', '')}/$passengerName/${flightClass[0]}';
        qrData =
            'TRAVELLO|TYPE:FLIGHT|PNR:$pnr|FLT:$flightNum|ROUTE:$fromCode-$toCode|DATE:$date|PAX:$passengerName|CLASS:$flightClass';
      }
    }

    return Container(
      margin: EdgeInsets.all(spacingUnit(2)),
      padding: EdgeInsets.all(spacingUnit(2.5)),
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
          Text(
            isTrainBooking ? 'RAILWAY E-TICKET' : 'BOARDING PASS',
            style: ThemeText.subtitle.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: spacingUnit(2)),

          // QR Code (with comprehensive data)
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),

          SizedBox(height: spacingUnit(2)),

          // Professional Barcode (IATA-style format)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacingUnit(2),
              vertical: spacingUnit(1.5),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: barcodeData,
              height: 60,
              drawText: true,
              style: ThemeText.caption.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 9,
              ),
            ),
          ),

          SizedBox(height: spacingUnit(1.5)),
          Text(
            'Show this to ${isTrainBooking ? 'railway staff' : 'airport staff'} for boarding',
            style: ThemeText.caption.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySection(bool isTrainBooking) {
    final details = isTrainBooking
        ? _booking['trainDetails'] as Map<String, dynamic>?
        : _booking['flightDetails'] as Map<String, dynamic>?;

    if (details == null) return const SizedBox();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      padding: EdgeInsets.all(spacingUnit(2.5)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isTrainBooking ? Icons.train : Icons.flight,
                color: isTrainBooking
                    ? const Color(0xFF059669)
                    : const Color(0xFF3B82F6),
              ),
              SizedBox(width: spacingUnit(1)),
              Text(
                'JOURNEY DETAILS',
                style: ThemeText.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: spacingUnit(1.5)),

          // Route display (City(CODE) - City(CODE))
          Text(
            isTrainBooking
                ? _buildTrainRouteText(details)
                : _buildFlightRouteText(details),
            style: ThemeText.subtitle.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: spacingUnit(2.5)),

          // Journey Timeline
          isTrainBooking
              ? _buildTrainJourney(details)
              : _buildFlightJourney(details),

          SizedBox(height: spacingUnit(2)),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: spacingUnit(2)),

          // Additional Details
          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  'Date',
                  isTrainBooking ? _getTrainDateDisplay(details) : (details['date'] ?? 'N/A'),
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: _buildInfoTile(
                  'Class',
                  details['class'] ?? 'Economy',
                  Icons.airline_seat_recline_extra,
                ),
              ),
              Expanded(
                child: _buildInfoTile(
                  'Duration',
                  details['duration'] ?? 'N/A',
                  Icons.schedule,
                ),
              ),
            ],
          ),

          if (isTrainBooking) ...[
            SizedBox(height: spacingUnit(1.5)),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Train',
                    details['trainName'] ?? 'N/A',
                    Icons.train,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Number',
                    details['trainNumber'] ?? 'N/A',
                    Icons.confirmation_number,
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: spacingUnit(1.5)),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Airline',
                    details['airline'] ?? 'N/A',
                    Icons.flight,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Flight',
                    details['flightNumber'] ?? 'N/A',
                    Icons.confirmation_number,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getTrainDateDisplay(Map<String, dynamic> details) {
    String dateStr = details['date'] ?? 'N/A';
    
    // Check if train arrives next day
    bool arrivesNextDay = details['arrivesNextDay'] ?? false;
    
    // Fallback: detect next-day arrival by comparing times
    if (!arrivesNextDay) {
      final depTime = details['departure'] as String?;
      final arrTime = details['arrival'] as String?;
      if (depTime != null && arrTime != null) {
        try {
          final depParts = depTime.split(':');
          final arrParts = arrTime.split(':');
          if (depParts.length == 2 && arrParts.length == 2) {
            final depHour = int.parse(depParts[0]);
            final arrHour = int.parse(arrParts[0]);
            // If arrival hour is less than departure, it's next day
            if (arrHour < depHour || (arrHour == depHour && details['duration']?.toString().contains('23h') == true)) {
              arrivesNextDay = true;
            }
          }
        } catch (e) {
          // Keep arrivesNextDay as false
        }
      }
    }
    
    // If next day arrival, show both dates
    if (arrivesNextDay) {
      // Format: "19 Mar - 20 Mar"
      String depDate = dateStr;
      if (depDate.contains(' ')) {
        final parts = depDate.split(' ');
        if (parts.length >= 2) {
          final day = int.tryParse(parts[0]);
          if (day != null) {
            final month = parts[1];
            final arrDay = day + 1;
            return '$day $month - $arrDay $month';
          }
        }
      }
    }
    
    return dateStr;
  }

  String _buildFlightRouteText(Map<String, dynamic> details) {
    // Get full airport strings (e.g., "Jinnah International Airport (KHI)")
    final fromStr = details['from'] ?? 'N/A';
    final toStr = details['to'] ?? 'N/A';

    // Extract airport codes using regex
    final fromMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(fromStr);
    final toMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(toStr);

    final fromCode = fromMatch?.group(1) ?? 'N/A';
    final toCode = toMatch?.group(1) ?? 'N/A';

    // Map airport codes to city names
    final fromCity = _getCityNameFromCode(fromCode);
    final toCity = _getCityNameFromCode(toCode);

    return '$fromCity($fromCode) - $toCity($toCode)';
  }

  String _buildTrainRouteText(Map<String, dynamic> details) {
    final fromStation = details['from'] ?? 'N/A';
    final fromCode = details['fromCode'] ?? '';
    final toStation = details['to'] ?? 'N/A';
    final toCode = details['toCode'] ?? '';
    final fromDisplay =
        fromCode.isNotEmpty ? '$fromStation($fromCode)' : fromStation;
    final toDisplay = toCode.isNotEmpty ? '$toStation($toCode)' : toStation;
    return '$fromDisplay - $toDisplay';
  }

  String _getCityNameFromCode(String airportCode) {
    // Airport code to city name mapping (Domestic Pakistan airports only)
    const Map<String, String> airportToCityMap = {
      'KHI': 'Karachi',
      'ISB': 'Islamabad',
      'LHE': 'Lahore',
      'PEW': 'Peshawar',
      'SKT': 'Sialkot',
      'MUX': 'Multan',
      'UET': 'Quetta',
      'RYK': 'Rahim Yar Khan',
      'BHV': 'Bahawalpur',
      'ATG': 'Attock',
      'LYP': 'Faisalabad',
      'GWD': 'Gwadar',
      'SBQ': 'Sibi',
      'PJG': 'Panjgur',
      'WAF': 'Wana',
      'KDD': 'Khuzdar',
      'CJL': 'Chitral',
      'GIL': 'Gilgit',
      'SKZ': 'Skardu',
      'SWN': 'Sahiwal',
    };

    return airportToCityMap[airportCode] ?? airportCode;
  }

  Widget _buildTrainJourney(Map<String, dynamic> details) {
    // Extract date from details
    String dateStr = details['date'] ?? '06 Mar';
    // Try to format date nicely (assuming format like "06 March 2026" or similar)
    if (dateStr.contains(' ')) {
      final parts = dateStr.split(' ');
      if (parts.length >= 2) {
        dateStr = '${parts[0]} ${parts[1].substring(0, 3)}';
      }
    }

    // Calculate if train arrives next day
    bool arrivesNextDay = details['arrivesNextDay'] ?? false;
    
    // Fallback: detect next-day arrival by comparing times
    if (!arrivesNextDay) {
      final depTime = details['departure'] as String?;
      final arrTime = details['arrival'] as String?;
      if (depTime != null && arrTime != null) {
        try {
          final depParts = depTime.split(':');
          final arrParts = arrTime.split(':');
          if (depParts.length == 2 && arrParts.length == 2) {
            final depHour = int.parse(depParts[0]);
            final arrHour = int.parse(arrParts[0]);
            // If arrival hour is less than departure, it's next day
            if (arrHour < depHour || (arrHour == depHour && details['duration']?.toString().contains('23h') == true)) {
              arrivesNextDay = true;
            }
          }
        } catch (e) {
          // Keep arrivesNextDay as false
        }
      }
    }

    // Calculate arrival date
    String arrivalDateStr = dateStr;
    if (arrivesNextDay) {
      // Parse the date and add 1 day
      try {
        final dateParts = dateStr.split(' ');
        if (dateParts.length >= 2) {
          final day = int.parse(dateParts[0]);
          final month = dateParts[1];
          final nextDay = day + 1;
          arrivalDateStr = '$nextDay $month';
        }
      } catch (e) {
        // If parsing fails, just use the same date
        arrivalDateStr = dateStr;
      }
    }

    return Column(
      children: [
        // Top row: Times with dates and duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Departure time and date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details['departure'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            // Right: Arrival time, date, and duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 14, color: Colors.grey.shade600),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      details['duration'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacingUnit(0.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details['arrival'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (arrivesNextDay)
                      Container(
                        margin: const EdgeInsets.only(left: 3, top: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '+1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  arrivalDateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: spacingUnit(2)),

        // Middle row: Route visualization with code chips
        Row(
          children: [
            // FROM CODE in rounded chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(1.5),
                vertical: spacingUnit(0.8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF059669).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                details['fromCode'] ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xFF059669),
                  letterSpacing: 1,
                ),
              ),
            ),

            // Journey Line with hollow and filled circles
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
                child: Row(
                  children: [
                    // Hollow circle at start
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF059669),
                          width: 2,
                        ),
                      ),
                    ),
                    // Dashed line before icon
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 6).floor(),
                              (index) => Container(
                                width: 3,
                                height: 2,
                                color: const Color(0xFF059669).withOpacity(0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Train icon
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: spacingUnit(0.5)),
                      child: const Icon(
                        Icons.train_rounded,
                        color: Color(0xFF059669),
                        size: 20,
                      ),
                    ),
                    // Dashed line after icon
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 6).floor(),
                              (index) => Container(
                                width: 3,
                                height: 2,
                                color: const Color(0xFF059669).withOpacity(0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Filled circle at end
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
              ),
            ),

            // TO CODE in rounded chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(1.5),
                vertical: spacingUnit(0.8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF059669).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                details['toCode'] ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xFF059669),
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(1.2)),

        // Bottom row: Station names
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                details['from'] ?? 'N/A',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: spacingUnit(2)),
            Expanded(
              child: Text(
                details['to'] ?? 'N/A',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlightJourney(Map<String, dynamic> details) {
    // Extract airport codes
    String fromCode = 'N/A';
    String toCode = 'N/A';

    final fromStr = details['from'] ?? 'N/A';
    final toStr = details['to'] ?? 'N/A';

    final fromMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(fromStr);
    final toMatch = RegExp(r'\(([A-Z]{3})\)').firstMatch(toStr);

    if (fromMatch != null) fromCode = fromMatch.group(1)!;
    if (toMatch != null) toCode = toMatch.group(1)!;

    // Clean city names
    final fromCity = fromStr.replaceAll(RegExp(r'\s*\([A-Z]{3}\)'), '');
    final toCity = toStr.replaceAll(RegExp(r'\s*\([A-Z]{3}\)'), '');

    // Extract date from details
    String dateStr = details['date'] ?? '06 Mar';
    // Try to format date nicely (assuming format like "06 March 2026" or similar)
    if (dateStr.contains(' ')) {
      final parts = dateStr.split(' ');
      if (parts.length >= 2) {
        dateStr = '${parts[0]} ${parts[1].substring(0, 3)}';
      }
    }

    return Column(
      children: [
        // Top row: Times with dates and duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Departure time and date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details['departure'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            // Right: Arrival time, date, and duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 14, color: Colors.grey.shade600),
                    SizedBox(width: spacingUnit(0.5)),
                    Text(
                      details['duration'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  details['arrival'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: spacingUnit(0.5)),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: spacingUnit(2)),

        // Middle row: Route visualization with code chips
        Row(
          children: [
            // FROM CODE in rounded chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(1.5),
                vertical: spacingUnit(0.8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                fromCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xFF3B82F6),
                  letterSpacing: 1,
                ),
              ),
            ),

            // Journey Line with hollow and filled circles
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
                child: Row(
                  children: [
                    // Hollow circle at start
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                    ),
                    // Dashed line before icon
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 6).floor(),
                              (index) => Container(
                                width: 3,
                                height: 2,
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Flight icon (rotated to face destination)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: spacingUnit(0.5)),
                      child: Transform.rotate(
                        angle: 1.5708, // 90 degrees in radians (pi/2)
                        child: const Icon(
                          Icons.flight,
                          color: Color(0xFF3B82F6),
                          size: 20,
                        ),
                      ),
                    ),
                    // Dashed line after icon
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 6).floor(),
                              (index) => Container(
                                width: 3,
                                height: 2,
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Filled circle at end
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
              ),
            ),

            // TO CODE in rounded chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(1.5),
                vertical: spacingUnit(0.8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                toCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xFF3B82F6),
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacingUnit(1.2)),

        // Bottom row: City names
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                fromCity,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: spacingUnit(2)),
            Expanded(
              child: Text(
                toCity,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        SizedBox(height: spacingUnit(0.5)),
        Text(
          label,
          style: ThemeText.caption.copyWith(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
        SizedBox(height: spacingUnit(0.3)),
        Text(
          value,
          style: ThemeText.paragraph.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPassengerSection() {
    final passengers = _booking['allPassengers'] as List<dynamic>?;
    if (passengers == null || passengers.isEmpty) return const SizedBox();

    return Container(
      margin: EdgeInsets.fromLTRB(
        spacingUnit(2),
        spacingUnit(2),
        spacingUnit(2),
        0,
      ),
      padding: EdgeInsets.all(spacingUnit(2.5)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: colorScheme(context).primary),
              SizedBox(width: spacingUnit(1)),
              Text(
                'PASSENGERS (${passengers.length})',
                style: ThemeText.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(2)),
          ...passengers.asMap().entries.map((entry) {
            final index = entry.key;
            final passenger = entry.value as Map<String, dynamic>;
            return Column(
              children: [
                if (index > 0) ...[
                  SizedBox(height: spacingUnit(1.5)),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: spacingUnit(1.5)),
                ],
                _buildPassengerRow(passenger, index + 1, index),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPassengerRow(Map<String, dynamic> passenger, int number, int passengerIndex) {
    final firstName = passenger['firstName']?.toString() ?? '';
    final lastName = passenger['lastName']?.toString() ?? '';
    final salutation = passenger['salutation']?.toString() ?? '';
    final fullName = firstName.isNotEmpty && lastName.isNotEmpty
        ? '$firstName $lastName'
        : (passenger['name']?.toString() ?? 'N/A');
    final nameWithSalutation = salutation.isNotEmpty 
        ? '$fullName ($salutation)'
        : fullName;

    // Get seat information
    final seatInfo = _getPassengerSeatInfo(passengerIndex);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme(context).primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: ThemeText.subtitle.copyWith(
                color: colorScheme(context).primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(width: spacingUnit(1.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameWithSalutation,
                style: ThemeText.subtitle2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacingUnit(0.3)),
              Text(
                _getPassengerDocumentInfo(passenger),
                style: ThemeText.caption.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              if (seatInfo.isNotEmpty) ...[
                SizedBox(height: spacingUnit(0.3)),
                Text(
                  seatInfo,
                  style: ThemeText.caption.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getPassengerSeatInfo(int passengerIndex) {
    final isRoundTrip = _booking['isRoundTrip'] == true;
    final bookingType = _booking['bookingType'] ?? 'flight';
    
    if (bookingType == 'train') {
      // For trains, seats are stored differently
      final seats = _booking['seats'] as List<dynamic>? ?? [];
      if (passengerIndex < seats.length) {
        final seat = seats[passengerIndex];
        if (seat is Map) {
          final seatNumber = seat['seatNumber'] ?? seat['seat'] ?? '';
          if (seatNumber.toString().isNotEmpty) {
            return 'Seat: $seatNumber';
          }
        } else if (seat.toString().isNotEmpty) {
          return 'Seat: $seat';
        }
      }
    } else {
      // For flights
      if (isRoundTrip) {
        final outboundSeats = _booking['outboundSeatSelections'] as List<dynamic>? ?? [];
        final returnSeats = _booking['returnSeatSelections'] as List<dynamic>? ?? [];
        
        String outboundSeat = '';
        String returnSeat = '';
        
        if (passengerIndex < outboundSeats.length) {
          final seatData = outboundSeats[passengerIndex] as Map<String, dynamic>;
          outboundSeat = seatData['seatName']?.toString() ?? '';
        }
        
        if (passengerIndex < returnSeats.length) {
          final seatData = returnSeats[passengerIndex] as Map<String, dynamic>;
          returnSeat = seatData['seatName']?.toString() ?? '';
        }
        
        if (outboundSeat.isNotEmpty && returnSeat.isNotEmpty) {
          return 'Seats: $outboundSeat (Out) | $returnSeat (Ret)';
        } else if (outboundSeat.isNotEmpty) {
          return 'Seat (Outbound): $outboundSeat';
        } else if (returnSeat.isNotEmpty) {
          return 'Seat (Return): $returnSeat';
        }
      } else {
        final seatSelections = _booking['seatSelections'] as List<dynamic>? ?? [];
        if (passengerIndex < seatSelections.length) {
          final seatData = seatSelections[passengerIndex] as Map<String, dynamic>;
          final seatName = seatData['seatName']?.toString() ?? '';
          if (seatName.isNotEmpty) {
            return 'Seat: $seatName';
          }
        }
      }
    }
    
    return '';
  }

  String _getPassengerDocumentInfo(Map<String, dynamic> passenger) {
    final documentType = passenger['documentType']?.toString() ?? '';
    
    // Check for CNIC
    final cnic = passenger['cnic']?.toString().trim();
    final nationalId = passenger['nationalId']?.toString().trim();
    if (documentType == 'CNIC' || (cnic != null && cnic.isNotEmpty)) {
      final cnicNumber = cnic ?? nationalId ?? '';
      return cnicNumber.isNotEmpty ? 'CNIC: $cnicNumber' : 'CNIC: N/A';
    }
    
    // Check for B-Form
    final bForm = passenger['bForm']?.toString().trim();
    if (documentType == 'B-Form' || (bForm != null && bForm.isNotEmpty)) {
      return 'B-Form: $bForm';
    }
    
    // Check for Passport
    final passport = passenger['passportNumber']?.toString().trim();
    if (documentType == 'Passport' || (passport != null && passport.isNotEmpty)) {
      return 'Passport: $passport';
    }
    
    // Fallback to generic ID
    final passportOrId = passenger['passportOrId']?.toString().trim();
    if (passportOrId != null && passportOrId.isNotEmpty) {
      return 'ID: $passportOrId';
    }

    return 'ID: N/A';
  }

  String _getPassengerId(Map<String, dynamic> passenger) {
    // Check all possible ID fields
    final cnic = passenger['cnic']?.toString().trim();
    if (cnic != null && cnic.isNotEmpty) return cnic;

    final nationalId = passenger['nationalId']?.toString().trim();
    if (nationalId != null && nationalId.isNotEmpty) return nationalId;

    final bForm = passenger['bForm']?.toString().trim();
    if (bForm != null && bForm.isNotEmpty) return bForm;

    final passport = passenger['passportNumber']?.toString().trim();
    if (passport != null && passport.isNotEmpty) return passport;

    final passportOrId = passenger['passportOrId']?.toString().trim();
    if (passportOrId != null && passportOrId.isNotEmpty) return passportOrId;

    final id = passenger['id']?.toString().trim();
    if (id != null && id.isNotEmpty) return id;

    final idCard = passenger['idCard']?.toString().trim();
    if (idCard != null && idCard.isNotEmpty) return idCard;

    final passengerId = passenger['passengerId']?.toString().trim();
    if (passengerId != null && passengerId.isNotEmpty) return passengerId;

    return 'N/A';
  }

  Widget _buildPaymentSection() {
    return Container(
      margin: EdgeInsets.all(spacingUnit(2)),
      padding: EdgeInsets.all(spacingUnit(2.5)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: colorScheme(context).primary),
              SizedBox(width: spacingUnit(1)),
              Text(
                'PAYMENT SUMMARY',
                style: ThemeText.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(2)),
          _buildPriceRow('Base Fare', _booking['amount']),
          _buildPriceRow('Taxes & Fees', _booking['tax']),
          if ((_booking['serviceFee'] ?? 0) > 0)
            _buildPriceRow('Service Fee', _booking['serviceFee']),
          SizedBox(height: spacingUnit(1.5)),
          Divider(color: Colors.grey.shade200, thickness: 1.5),
          SizedBox(height: spacingUnit(1.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: ThemeText.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'PKR ${(_booking['total'] ?? 0).toStringAsFixed(0)}',
                style: ThemeText.title2.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme(context).primary,
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(1.5)),
          Container(
            padding: EdgeInsets.all(spacingUnit(1.2)),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green.shade700, size: 18),
                SizedBox(width: spacingUnit(1)),
                Expanded(
                  child: Text(
                    'Payment successful via ${_booking['paymentMethod'] ?? 'Card'}',
                    style: ThemeText.caption.copyWith(
                      color: Colors.green.shade700,
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

  Widget _buildPriceRow(String label, dynamic amount) {
    final value =
        (amount is double ? amount : (amount as num?)?.toDouble()) ?? 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: ThemeText.paragraph.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            'PKR ${value.toStringAsFixed(0)}',
            style: ThemeText.paragraph.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isTrainBooking) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      padding: EdgeInsets.all(spacingUnit(2.5)),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade800),
              SizedBox(width: spacingUnit(1)),
              Text(
                'IMPORTANT INFORMATION',
                style: ThemeText.subtitle2.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(1.5)),
          if (isTrainBooking) ...[
            _buildInfoPoint('Arrive at station 30 minutes before departure'),
            _buildInfoPoint(
                'Carry valid CNIC/Passport matching booking details'),
            _buildInfoPoint('Show QR code or PNR at entry gates'),
            _buildInfoPoint(
                'Cancellation allowed up to 2 hours before departure'),
          ] else ...[
            _buildInfoPoint('Check-in opens 3 hours before departure'),
            _buildInfoPoint('Carry valid passport and visa documents'),
            _buildInfoPoint('Arrive at airport 2 hours before departure'),
            _buildInfoPoint('Web check-in available 24 hours before flight'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacingUnit(0.8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: spacingUnit(1)),
          Expanded(
            child: Text(
              text,
              style: ThemeText.paragraph.copyWith(
                color: Colors.amber.shade900,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isConfirmed =
        (_booking['status'] ?? 'confirmed').toLowerCase() == 'confirmed';
    final isTrainBooking = (_booking['bookingType'] ?? 'flight') == 'train';

    return BottomAppBar(
      elevation: 8,
      height: 140,
      color: Colors.white,
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        children: [
          // First Row: E-Ticket Button (Full width)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _downloadingPdf ? null : _downloadETicket,
              style: ThemeButton.btnBig.merge(
                FilledButton.styleFrom(
                  backgroundColor: isTrainBooking
                      ? const Color(0xFF059669)
                      : const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
              ),
              child: _downloadingPdf
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isTrainBooking
                          ? 'DOWNLOAD E-TICKET'
                          : 'DOWNLOAD E-TICKET & BOARDING PASS',
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          SizedBox(height: spacingUnit(1.5)),
          // Second Row: Tax Invoice Button (Full width)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _downloadingPdf ? null : _downloadInvoice,
              style: ThemeButton.btnBig.merge(
                OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              child: _downloadingPdf
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade700,
                      ),
                    )
                  : const Text('DOWNLOAD TAX INVOICE'),
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎯 ACTIONS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _copyPNR() async {
    await Clipboard.setData(ClipboardData(text: _booking['pnr'] ?? 'N/A'));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: spacingUnit(1)),
              const Text('PNR copied to clipboard!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _shareBooking() {
    // Implement share functionality
    final pnr = _booking['pnr'] ?? 'N/A';
    final type = _booking['bookingType'] == 'train' ? 'Train' : 'Flight';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing $type booking $pnr...'),
        backgroundColor: colorScheme(context).primary,
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎫 PDF DOWNLOAD METHODS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> _downloadETicket() async {
    final bookingType = _booking['bookingType'] as String? ?? 'flight';

    if (bookingType == 'train') {
      await _downloadRailwayTicket();
    } else {
      await _downloadFlightTicket();
    }
  }

  Future<void> _downloadFlightTicket() async {
    setState(() => _downloadingPdf = true);
    try {
      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      final doc = pw.Document(
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
      );

      final actualPax = _booking['allPassengers'] is List &&
              (_booking['allPassengers'] as List).isNotEmpty
          ? (_booking['allPassengers'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : [
              {
                'name': _booking['passengerName'] ?? 'Passenger',
                'passportOrId': ''
              }
            ];

      // Generate outbound tickets
      for (final pax in actualPax) {
        _addFlightTicketPage(doc,
            isReturn: false,
            passengerName: pax['name'] as String? ?? 'Passenger',
            passportOrId: pax['passportOrId'] as String? ?? '');
      }

      // Generate return tickets if round trip
      if (_booking['isRoundTrip'] == true) {
        for (final pax in actualPax) {
          _addFlightTicketPage(doc,
              isReturn: true,
              passengerName: pax['name'] as String? ?? 'Passenger',
              passportOrId: pax['passportOrId'] as String? ?? '');
        }
      }

      await Printing.layoutPdf(
          name: 'E-Ticket-${_booking['pnr']}.pdf',
          onLayout: (_) async => doc.save());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF generation failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloadingPdf = false);
    }
  }

  Future<void> _downloadRailwayTicket() async {
    setState(() => _downloadingPdf = true);
    try {
      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      final doc = pw.Document(
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
      );

      final td = _booking['trainDetails'] as Map<String, dynamic>?;
      final returnTd = _booking['returnTrainDetails'] as Map<String, dynamic>?;
      final isRoundTrip = _booking['isRoundTrip'] == true && returnTd != null;
      final passengers = _booking['allPassengers'] as List<dynamic>? ?? [];
      final rawSeats = _booking['seatNumbers'] as List<dynamic>? ?? [];
      final rawTickets = _booking['ticketNumbers'] as List<dynamic>? ?? [];
      final coach = _booking['coach'] as String? ?? 'B-1';
      final pnr = _booking['pnr'] as String? ?? 'N/A';
      final grandTotal = _booking['total'] as double? ?? 0.0;
      final baseFare = _booking['amount'] as double? ?? 0.0;
      final paxCount = passengers.isEmpty ? 1 : passengers.length;
      final farePerPax = paxCount > 0 ? baseFare / paxCount : baseFare;
      const rabta = 10.0;
      
      // Get seat selections for both journeys
      final outboundSeats = isRoundTrip 
          ? (_booking['outboundSeatSelections'] as List<dynamic>? ?? [])
          : (_booking['seatSelections'] as List<dynamic>? ?? []);
      final returnSeats = isRoundTrip 
          ? (_booking['returnSeatSelections'] as List<dynamic>? ?? [])
          : [];

      // Generate outbound tickets for all passengers
      for (int i = 0; i < passengers.length; i++) {
        final pax = passengers[i] as Map<String, dynamic>;
        final paxName = pax['name'] as String? ?? 'Passenger ${i + 1}';
        final rawCnic = pax['cnic'] as String? ?? '';
        final cnic = rawCnic.isNotEmpty
            ? rawCnic.replaceAll('-', '').replaceAll(' ', '')
            : (pax['passportOrId'] as String?)
                    ?.replaceAll('-', '')
                    .replaceAll(' ', '') ??
                '--';
        final phone = pax['phone'] as String? ?? '--';
        final age = pax['age'] as String? ?? '--';
        final gender = pax['gender'] as String? ?? 'Male';
        final rawType = pax['concessionType'] as String? ?? 'ADULT';
        final paxType = rawType == 'CHILD_3_10'
            ? 'CHILD'
            : rawType == 'INFANT'
                ? 'INFANT'
                : 'ADULT';
        
        // Get seat and coach from actual selections (outbound)
        String seat = '${i + 1}'; // fallback
        String seatCoach = coach; // fallback
        if (i < outboundSeats.length) {
          final seatData = outboundSeats[i] as Map<String, dynamic>;
          final seatName = (seatData['seatName'] ?? '').toString();
          if (seatName.isNotEmpty) {
            seat = seatName;
            seatCoach = (seatData['coach'] ?? coach).toString();
          }
        } else if (i < rawSeats.length) {
          seat = rawSeats[i].toString();
        }
        
        final ticketNo = i < rawTickets.length ? rawTickets[i].toString() : pnr;

        final double thisFare = rawType == 'CHILD_3_10'
            ? farePerPax * 0.5
            : rawType == 'INFANT'
                ? 0.0
                : farePerPax;
        final double thisTotal = thisFare + (rawType == 'ADULT' ? rabta : 0.0);

        _addRailwayTicketPage(
          doc,
          td: td,
          pnr: pnr,
          coach: seatCoach,
          seat: seat,
          ticketNo: ticketNo,
          paxName: paxName,
          phone: phone,
          cnic: cnic,
          age: age,
          gender: gender,
          paxType: paxType,
          fare: thisFare,
          rabta: rawType == 'ADULT' ? rabta : 0.0,
          total: thisTotal,
          grandTotal: grandTotal,
          paxIndex: i,
          paxCount: passengers.length,
          isReturn: false,
        );
      }

      if (passengers.isEmpty) {
        _addRailwayTicketPage(
          doc,
          td: td,
          pnr: pnr,
          coach: coach,
          seat: '1',
          ticketNo: pnr,
          paxName: _booking['passengerName'] as String? ?? 'Passenger',
          phone: _booking['phone'] as String? ?? '--',
          cnic: '--',
          age: '--',
          gender: 'Male',
          paxType: 'ADULT',
          fare: baseFare,
          rabta: rabta,
          total: baseFare + rabta,
          grandTotal: grandTotal,
          paxIndex: 0,
          paxCount: 1,
          isReturn: false,
        );
      }

      // Generate return tickets if round trip
      if (isRoundTrip) {
        for (int i = 0; i < passengers.length; i++) {
          final pax = passengers[i] as Map<String, dynamic>;
          final paxName = pax['name'] as String? ?? 'Passenger ${i + 1}';
          final rawCnic = pax['cnic'] as String? ?? '';
          final cnic = rawCnic.isNotEmpty
              ? rawCnic.replaceAll('-', '').replaceAll(' ', '')
              : (pax['passportOrId'] as String?)
                      ?.replaceAll('-', '')
                      .replaceAll(' ', '') ??
                  '--';
          final phone = pax['phone'] as String? ?? '--';
          final age = pax['age'] as String? ?? '--';
          final gender = pax['gender'] as String? ?? 'Male';
          final rawType = pax['concessionType'] as String? ?? 'ADULT';
          final paxType = rawType == 'CHILD_3_10'
              ? 'CHILD'
              : rawType == 'INFANT'
                  ? 'INFANT'
                  : 'ADULT';
          
          // Get seat and coach from actual selections (return)
          String seat = '${i + 1}'; // fallback
          String seatCoach = coach; // fallback
          if (i < returnSeats.length) {
            final seatData = returnSeats[i] as Map<String, dynamic>;
            final seatName = (seatData['seatName'] ?? '').toString();
            if (seatName.isNotEmpty) {
              seat = seatName;
              seatCoach = (seatData['coach'] ?? coach).toString();
            }
          } else if (i < rawSeats.length) {
            seat = rawSeats[i].toString();
          }
          
          final ticketNo = i < rawTickets.length ? rawTickets[i].toString() : pnr;

          final double thisFare = rawType == 'CHILD_3_10'
              ? farePerPax * 0.5
              : rawType == 'INFANT'
                  ? 0.0
                  : farePerPax;
          final double thisTotal = thisFare + (rawType == 'ADULT' ? rabta : 0.0);

          _addRailwayTicketPage(
            doc,
            td: returnTd,
            pnr: pnr,
            coach: seatCoach,
            seat: seat,
            ticketNo: ticketNo,
            paxName: paxName,
            phone: phone,
            cnic: cnic,
            age: age,
            gender: gender,
            paxType: paxType,
            fare: thisFare,
            rabta: rawType == 'ADULT' ? rabta : 0.0,
            total: thisTotal,
            grandTotal: grandTotal,
            paxIndex: i,
            paxCount: passengers.length,
            isReturn: true,
          );
        }

        if (passengers.isEmpty) {
          _addRailwayTicketPage(
            doc,
            td: returnTd,
            pnr: pnr,
            coach: coach,
            seat: '1',
            ticketNo: pnr,
            paxName: _booking['passengerName'] as String? ?? 'Passenger',
            phone: _booking['phone'] as String? ?? '--',
            cnic: '--',
            age: '--',
            gender: 'Male',
            paxType: 'ADULT',
            fare: baseFare,
            rabta: rabta,
            total: baseFare + rabta,
            grandTotal: grandTotal,
            paxIndex: 0,
            paxCount: 1,
            isReturn: true,
          );
        }
      }

      await Printing.layoutPdf(
          name: 'Railway-Ticket-${_booking['pnr']}.pdf',
          onLayout: (_) async => doc.save());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF generation failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloadingPdf = false);
    }
  }

  Future<void> _downloadInvoice() async {
    setState(() => _downloadingPdf = true);
    try {
      final invoiceNumber = _booking['pnr'] ?? 'N/A';
      final eTicketNumber = _booking['transactionId'] ?? 'N/A';
      final issuedDate =
          DateFormat('ddMMMyy').format(DateTime.now()).toUpperCase();
      final issuedTime = DateFormat('HHmm').format(DateTime.now());

      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      final pdf = pw.Document(
        title: 'Tax Invoice - $invoiceNumber',
        author: 'Travello AI',
        creator: 'Travello AI',
        subject: 'e-Ticket Receipt & Itinerary',
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // ═══ Header: Logo + Title + Barcode ═══
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Logo
                  pw.Container(
                    width: 60,
                    height: 60,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: const pw.BoxDecoration(
                      color: PdfColor(0.145, 0.388, 0.922),
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        '✈',
                        style: pw.TextStyle(
                          fontSize: 32,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  // Title
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Travello AI',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: const PdfColor(0.145, 0.388, 0.922),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'e-Ticket Receipt & Itinerary',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // PNR Barcode
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: pw.BoxDecoration(
                          border:
                              pw.Border.all(color: PdfColors.black, width: 2),
                        ),
                        child: pw.Text(
                          invoiceNumber,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'TK$eTicketNumber',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Introduction text
              pw.Text(
                'Your electronic ticket is stored in our computer reservations system. This e-Ticket receipt/itinerary is your record of your electronic ticket and where applicable, your contract of carriage. You may need to show this receipt to enter the airport and/or to prove this booking to customs and immigration officials.',
                style: const pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.grey800,
                  height: 1.5,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Your attention is drawn to the Conditions of Contract and Other Important Notices set out in the attached document. Please visit us on www.travelloai.com to check-in online and for more information.',
                style: const pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.grey800,
                  height: 1.5,
                ),
              ),

              pw.SizedBox(height: 20),

              // PASSENGER AND TICKET INFORMATION
              _buildPdfSectionHeader('PASSENGER AND TICKET INFORMATION'),
              pw.SizedBox(height: 8),
              _buildPdfInfoTable([
                ['PASSENGER(S)', _buildPassengerNamesString()],
                ['TOTAL PASSENGERS', '${_booking['passengerCount'] ?? 1}'],
                ['BOOKING REFERENCE', invoiceNumber],
                ['E-TICKET NUMBER', eTicketNumber],
                [
                  'ISSUED BY / DATE',
                  'DUBAI / EMIRATES EZM\n($issuedDate/${issuedTime}hr)'
                ],
              ]),

              pw.SizedBox(height: 20),

              // TRAVEL INFORMATION
              _buildPdfSectionHeader(_booking['isRoundTrip'] == true
                  ? 'TRAVEL INFORMATION (ROUND TRIP)'
                  : 'TRAVEL INFORMATION (ONE-WAY)'),
              pw.SizedBox(height: 8),
              _buildPdfTravelTable(),
              // Add return flight if round trip
              if (_booking['isRoundTrip'] == true &&
                  _booking['returnFlightDetails'] != null) ...[
                pw.SizedBox(height: 12),
                _buildPdfReturnFlightTable(),
              ],

              pw.SizedBox(height: 20),

              // FARE AND ADDITIONAL INFORMATION
              _buildPdfSectionHeader('FARE AND ADDITIONAL INFORMATION'),
              pw.SizedBox(height: 8),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: _buildPdfFareBreakdown()),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _buildPdfAdditionalInfo()),
                ],
              ),

              pw.SizedBox(height: 20),

              // FARE CALCULATIONS
              _buildPdfSectionHeader('FARE CALCULATIONS'),
              pw.SizedBox(height: 8),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: const PdfColor(0.96, 0.96, 0.96),
                  border: pw.Border.all(color: const PdfColor(0.8, 0.8, 0.8)),
                ),
                child: pw.Text(
                  _buildFareCalculationString(),
                  style: const pw.TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              // Footer Notice
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: const pw.BoxDecoration(
                  color: PdfColor(0.95, 0.95, 0.95),
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Important Notice',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Please check with departure airport for restrictions on the carriage of liquids, aerosols and gels in hand baggage.',
                      style: const pw.TextStyle(fontSize: 10, height: 1.4),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'For customer support, please contact: support@travelloai.com | +92 300 1234567',
                      style: const pw.TextStyle(fontSize: 10, height: 1.4),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      await Printing.layoutPdf(
        name: 'Tax-Invoice-$invoiceNumber.pdf',
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF generation failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloadingPdf = false);
    }
  }

  void _cancelBooking() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NO'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoadingCancel = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoadingCancel = false);

      if (mounted) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: spacingUnit(1)),
                const Text('Booking canceled successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎨 PDF HELPER METHODS - Flight E-Ticket
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  // PDF Colors
  static const _pdfNavy = PdfColor(0.059, 0.176, 0.361); // #0F2D5C
  static const _pdfBlue = PdfColor(0.145, 0.388, 0.922); // #2563EB
  static const _pdfEmerald = PdfColor(0.063, 0.725, 0.506); // #10B981
  static const _pdfRose = PdfColor(0.957, 0.247, 0.369); // #F43F5E
  static const _pdfIce = PdfColor(0.941, 0.965, 1.0); // #F0F6FF
  static const _pdfBorder = PdfColor(0.886, 0.922, 0.965); // #E2EBF6
  static const _pdfTextSec = PdfColor(0.392, 0.455, 0.545); // #64748B
  static const _pdfBlueIce = PdfColor(0.859, 0.918, 0.996); // #DBEAFE

  void _addFlightTicketPage(
    pw.Document doc, {
    required bool isReturn,
    required String passengerName,
    required String passportOrId,
  }) {
    final fd = _booking['flightDetails'] as Map<String, dynamic>?;
    final rfd = _booking['returnFlightDetails'] as Map<String, dynamic>?;
    final src = isReturn ? (rfd ?? fd) : fd;
    final airline = src?['airline'] as String? ?? 'Airline';
    final fltNum = src?['flightNumber'] as String? ?? 'N/A';
    final cabin = src?['class'] as String? ?? 'Economy';
    final depTime = src?['departure'] as String? ?? '--:--';
    final arrTime = src?['arrival'] as String? ?? '--:--';
    final dur = src?['duration'] as String? ?? '--';
    final date = src?['date'] as String? ?? '--';
    final fromFull = isReturn
        ? (src?['from'] as String? ?? (fd?['to'] as String? ?? 'Origin'))
        : (fd?['from'] as String? ?? 'Origin');
    final toFull = isReturn
        ? (src?['to'] as String? ?? (fd?['from'] as String? ?? 'Dest'))
        : (fd?['to'] as String? ?? 'Dest');

    String code(String s) {
      final m = RegExp(r'\(([^)]+)\)').firstMatch(s);
      return m?.group(1) ?? s.substring(0, s.length.clamp(0, 3)).toUpperCase();
    }

    String city(String s) => s.split('(').first.trim();

    final fromCode = code(fromFull);
    final toCode = code(toFull);
    final fromCity = city(fromFull);
    final toCity = city(toFull);
    final pnr = _booking['pnr'] as String? ?? 'TRV000000';
    final payMethod = _booking['paymentMethod'] as String? ?? 'N/A';
    final dirLabel = isReturn ? 'RETURN FLIGHT' : 'OUTBOUND FLIGHT';

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(children: [
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(
                color: isReturn ? _pdfEmerald : _pdfNavy,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
              ),
              child: pw.Text(dirLabel,
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1)),
            ),
            pw.SizedBox(width: 10),
            pw.Text('PNR: $pnr',
                style: const pw.TextStyle(fontSize: 10, color: _pdfTextSec)),
            pw.Spacer(),
            pw.Text('Travello AI  -  E-Ticket',
                style: pw.TextStyle(
                    fontSize: 10,
                    color: _pdfNavy,
                    fontWeight: pw.FontWeight.bold)),
          ]),
          pw.SizedBox(height: 10),
          pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(14)),
              border: pw.Border.all(color: _pdfBorder),
              color: PdfColors.white,
            ),
            child: pw.Column(children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: const pw.BoxDecoration(
                  color: _pdfNavy,
                  borderRadius: pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(14),
                      topRight: pw.Radius.circular(14)),
                ),
                child: pw.Row(children: [
                  pw.Container(
                    width: 42,
                    height: 42,
                    decoration: const pw.BoxDecoration(
                      color: PdfColor(1, 1, 1, 0.12),
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.Center(
                      child: pw.Text('FL',
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(airline,
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 5),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: const pw.BoxDecoration(
                              color: PdfColor(1, 1, 1, 0.15),
                              borderRadius:
                                  pw.BorderRadius.all(pw.Radius.circular(4)),
                            ),
                            child: pw.Text(fltNum,
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    letterSpacing: 0.8)),
                          ),
                        ]),
                  ),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: pw.BoxDecoration(
                            color: const PdfColor(0.063, 0.725, 0.506, 0.22),
                            borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(12)),
                            border: pw.Border.all(
                                color:
                                    const PdfColor(0.063, 0.725, 0.506, 0.55)),
                          ),
                          child: pw.Text('CONFIRMED',
                              style: pw.TextStyle(
                                  color: _pdfEmerald,
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                  letterSpacing: 0.8)),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: const pw.BoxDecoration(
                            color: PdfColor(1, 1, 1, 0.12),
                            borderRadius:
                                pw.BorderRadius.all(pw.Radius.circular(6)),
                          ),
                          child: pw.Text(cabin,
                              style: const pw.TextStyle(
                                  color: PdfColors.white, fontSize: 9)),
                        ),
                      ]),
                ]),
              ),
              // Route
              pw.Container(
                color: PdfColors.white,
                padding: const pw.EdgeInsets.fromLTRB(24, 20, 24, 14),
                child: pw.Column(children: [
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(fromCity,
                                    style: const pw.TextStyle(
                                        fontSize: 8, color: _pdfTextSec)),
                                pw.SizedBox(height: 3),
                                pw.Text(fromCode,
                                    style: pw.TextStyle(
                                        fontSize: 28,
                                        fontWeight: pw.FontWeight.bold,
                                        color: _pdfNavy,
                                        letterSpacing: 2)),
                                pw.SizedBox(height: 5),
                                pw.Text(depTime,
                                    style: pw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: pw.FontWeight.bold,
                                        color: _pdfNavy)),
                                pw.SizedBox(height: 2),
                                pw.Text(date,
                                    style: const pw.TextStyle(
                                        fontSize: 8, color: _pdfTextSec)),
                              ]),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text(dur,
                                    style: const pw.TextStyle(
                                        fontSize: 8, color: _pdfTextSec)),
                                pw.SizedBox(height: 5),
                                pw.Row(children: [
                                  pw.Container(
                                      width: 6,
                                      height: 6,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: _pdfBlue, width: 1.5),
                                          shape: pw.BoxShape.circle)),
                                  pw.Container(
                                      width: 18,
                                      height: 1.5,
                                      color: const PdfColor(
                                          0.145, 0.388, 0.922, 0.3)),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.all(4),
                                    decoration: const pw.BoxDecoration(
                                        color: _pdfBlueIce,
                                        shape: pw.BoxShape.circle),
                                    child: pw.Text('>',
                                        style: pw.TextStyle(
                                            color: _pdfBlue,
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.Container(
                                      width: 18,
                                      height: 1.5,
                                      color: const PdfColor(
                                          0.145, 0.388, 0.922, 0.3)),
                                  pw.Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const pw.BoxDecoration(
                                          color: _pdfBlue,
                                          shape: pw.BoxShape.circle)),
                                ]),
                                pw.SizedBox(height: 5),
                                pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: const pw.BoxDecoration(
                                    color: _pdfBlueIce,
                                    borderRadius: pw.BorderRadius.all(
                                        pw.Radius.circular(4)),
                                  ),
                                  child: pw.Text('NON-STOP',
                                      style: pw.TextStyle(
                                          color: _pdfBlue,
                                          fontSize: 7,
                                          fontWeight: pw.FontWeight.bold,
                                          letterSpacing: 0.5)),
                                ),
                              ]),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(toCity,
                                    textAlign: pw.TextAlign.right,
                                    style: const pw.TextStyle(
                                        fontSize: 8, color: _pdfTextSec)),
                                pw.SizedBox(height: 3),
                                pw.Text(toCode,
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 28,
                                        fontWeight: pw.FontWeight.bold,
                                        color: _pdfNavy,
                                        letterSpacing: 2)),
                                pw.SizedBox(height: 5),
                                pw.Text(arrTime,
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: pw.FontWeight.bold,
                                        color: _pdfNavy)),
                                pw.SizedBox(height: 2),
                                pw.Text(date,
                                    textAlign: pw.TextAlign.right,
                                    style: const pw.TextStyle(
                                        fontSize: 8, color: _pdfTextSec)),
                              ]),
                        ),
                      ]),
                  pw.SizedBox(height: 14),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4, vertical: 10),
                    decoration: pw.BoxDecoration(
                      color: _pdfIce,
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(8)),
                      border: pw.Border.all(color: _pdfBorder),
                    ),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          _pdfChip('SEAT', 'A1', _pdfTextSec),
                          _pdfVDiv(),
                          _pdfChip('GATE', 'H22', _pdfRose),
                          _pdfVDiv(),
                          _pdfChip('TERMINAL', '3', _pdfTextSec),
                          _pdfVDiv(),
                          _pdfChip('BOARDS AT', depTime, _pdfBlue),
                        ]),
                  ),
                ]),
              ),
              // Passenger Section
              pw.Container(
                color: PdfColors.white,
                padding: const pw.EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: pw.Column(children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: _pdfBlueIce,
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(10)),
                      border: pw.Border.all(color: _pdfBorder),
                    ),
                    child: pw.Row(children: [
                      pw.Container(
                        width: 36,
                        height: 36,
                        decoration: const pw.BoxDecoration(
                          color: PdfColor(0.145, 0.388, 0.922, 0.12),
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text('PAX',
                              style: pw.TextStyle(
                                  color: _pdfBlue,
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('PASSENGER',
                                  style: pw.TextStyle(
                                      fontSize: 7,
                                      color: _pdfTextSec,
                                      fontWeight: pw.FontWeight.bold,
                                      letterSpacing: 0.5)),
                              pw.SizedBox(height: 3),
                              pw.Text(passengerName,
                                  style: pw.TextStyle(
                                      fontSize: 13,
                                      fontWeight: pw.FontWeight.bold,
                                      color: _pdfNavy)),
                            ]),
                      ),
                      if (passportOrId.isNotEmpty)
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text('PASSPORT / ID',
                                  style: const pw.TextStyle(
                                      fontSize: 7, color: _pdfTextSec)),
                              pw.SizedBox(height: 3),
                              pw.Text(passportOrId,
                                  style: pw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold,
                                      color: _pdfNavy)),
                            ]),
                    ]),
                  ),
                ]),
              ),
            ]),
          ),
        ],
      ),
    ));
  }

  pw.Widget _pdfChip(String label, String val, PdfColor accent) =>
      pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
        pw.Text(label,
            style: const pw.TextStyle(
                fontSize: 7, color: PdfColor(0.392, 0.455, 0.545))),
        pw.SizedBox(height: 2),
        pw.Text(val,
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent)),
      ]);

  pw.Widget _pdfVDiv() => pw.Container(width: 1, height: 28, color: _pdfBorder);

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎨 PDF HELPER METHODS - Train E-Ticket
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _addRailwayTicketPage(
    pw.Document doc, {
    required Map<String, dynamic>? td,
    required String pnr,
    required String coach,
    required String seat,
    required String ticketNo,
    required String paxName,
    required String phone,
    required String cnic,
    required String age,
    required String gender,
    required String paxType,
    required double fare,
    required double rabta,
    required double total,
    required double grandTotal,
    required int paxIndex,
    required int paxCount,
    required bool isReturn,
  }) {
    const pgGreen = PdfColor(0.114, 0.388, 0.114);
    const pgGreenLight = PdfColor(0.882, 0.961, 0.878);
    const pgText = PdfColor(0.1, 0.1, 0.1);
    const pgGrey = PdfColor(0.45, 0.45, 0.45);
    const pgBorder = PdfColor(0.82, 0.82, 0.82);

    final trainName = td?['trainName'] as String? ?? 'Pakistan Express';
    final trainNumber = td?['trainNumber'] as String? ?? '45UP';
    final fromStation = td?['from'] as String? ?? 'N/A';
    final toStation = td?['to'] as String? ?? 'N/A';
    final fromCode = td?['fromCode'] as String? ?? '';
    final toCode = td?['toCode'] as String? ?? '';
    final depTime = td?['departure'] as String? ?? '--:--';
    final classType = td?['class'] as String? ?? 'Economy';
    final date = td?['date'] as String? ?? '--';

    final fromLabel =
        fromCode.isNotEmpty ? '${fromCode.toUpperCase()} JN.' : fromStation;
    final toLabel =
        toCode.isNotEmpty ? '${toCode.toUpperCase()} JN.' : toStation;
    final coachSeat = '$seat/$coach';
    final qrData =
        'PR|PNR:$pnr|TRN:$trainNumber|PAX:$paxName|SEAT:$coachSeat|DT:$date';

    pw.Widget row(String labelEn, String value, {bool bold = false}) {
      return pw.Container(
        decoration: const pw.BoxDecoration(
            border:
                pw.Border(bottom: pw.BorderSide(color: pgBorder, width: 0.5))),
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 4,
              child: pw.Text(labelEn,
                  style: pw.TextStyle(
                      fontSize: 10,
                      color: pgText,
                      fontWeight: pw.FontWeight.bold)),
            ),
            pw.Expanded(
              flex: 5,
              child: pw.Text(value,
                  style: pw.TextStyle(
                      fontSize: 11,
                      color: pgText,
                      fontWeight:
                          bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
            ),
          ],
        ),
      );
    }

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding:
                const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: const pw.BoxDecoration(
              color: pgGreen,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('PAKISTAN RAILWAYS',
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1)),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Online Ticket',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold)),
                    if (paxCount > 1)
                      pw.Text('${paxIndex + 1} of $paxCount',
                          style: const pw.TextStyle(
                              color: PdfColors.white, fontSize: 8)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text('Pakistan Railway Ticket',
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: pgText)),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: pw.BoxDecoration(
                color: isReturn ? const PdfColor(0.9, 0.5, 0.2) : pgGreen,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                isReturn ? 'RETURN JOURNEY' : 'OUTBOUND JOURNEY',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Column(children: [
              pw.Text('$trainNumber/$trainName',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: pgText)),
              pw.Text('$fromLabel to $toLabel',
                  style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: pgText)),
            ]),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: pgBorder),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: pw.Column(children: [
              row('Departure Date', '$date $depTime'),
              row('Class', classType),
              row('Coach/Seat', coachSeat, bold: true),
              row('Name', paxName, bold: true),
              row('CNIC', cnic),
              row('Age', age),
              row('Gender', gender),
              row('Phone', phone),
              row('Type', paxType),
              pw.SizedBox(height: 2),
              row('Fare', 'Rs.${fare.toStringAsFixed(2)}'),
              if (rabta > 0)
                row('RABTA (Database)', 'Rs.${rabta.toStringAsFixed(2)}'),
              row('Reservation (Online)', 'Rs.0.00'),
              pw.SizedBox(height: 2),
              pw.Container(
                color: pgGreenLight,
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: pw.Row(children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Text('Total:',
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: pgText)),
                  ),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Text('Rs.${total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: pgGreen)),
                  ),
                ]),
              ),
              row('Voucher', '--'),
            ]),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: const pw.BoxDecoration(
              color: pgGreenLight,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                    'A traveler must provide his/her original Name, CNIC No and Mobile No.',
                    style: const pw.TextStyle(fontSize: 9, color: pgText)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Traveling with fake information on Ticket is not allowed.',
                    style: const pw.TextStyle(fontSize: 9, color: pgText)),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: qrData,
                width: 90,
                height: 90,
                color: pgGreen,
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(ticketNo,
                        style: pw.TextStyle(
                            fontSize: 8,
                            color: pgGrey,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text('Online Ticket',
                        style: pw.TextStyle(
                            fontSize: 9,
                            color: pgGreen,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                    pw.Text('Pakistan Railways Official',
                        style: const pw.TextStyle(fontSize: 8, color: pgGrey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  🎨 PDF HELPER METHODS - Tax Invoice (Emirates Style)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  pw.Widget _buildPdfSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: const PdfColor(0.7, 0.7, 0.7),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  pw.Widget _buildPdfInfoTable(List<List<String>> rows) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: const PdfColor(0.8, 0.8, 0.8)),
      ),
      child: pw.Column(
        children: rows.map((row) {
          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom:
                    pw.BorderSide(color: PdfColor(0.9, 0.9, 0.9), width: 0.5),
              ),
            ),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 150,
                  child: pw.Text(
                    row[0],
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    row[1],
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  pw.Widget _buildPdfTravelTable() {
    final bookingType = _booking['bookingType'] as String? ?? 'flight';
    final isTrainBooking = bookingType == 'train';

    if (isTrainBooking) {
      return _buildPdfTrainTravelTable();
    }

    final flightDetails = _booking['flightDetails'] as Map<String, dynamic>?;
    final flightNumber = flightDetails?['flightNumber'] ?? 'N/A';
    final from = flightDetails?['from'] ?? 'N/A';
    final to = flightDetails?['to'] ?? 'N/A';
    final date = flightDetails?['date'] ?? 'N/A';
    final time = flightDetails?['departure'] ?? 'N/A';

    return pw.Table(
      border: pw.TableBorder.all(color: const PdfColor(0.8, 0.8, 0.8)),
      columnWidths: {
        0: const pw.FixedColumnWidth(60),
        1: const pw.FixedColumnWidth(80),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FixedColumnWidth(80),
        4: const pw.FixedColumnWidth(60),
        5: const pw.FixedColumnWidth(90),
      },
      children: [
        // Table Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColor(0.9, 0.9, 0.9)),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('FLIGHT',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('DEPART/\nARRIVE',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('AIRPORT/TERMINAL',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('CHECK-IN\nOPENS',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('CLASS',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('COUPON\nVALIDITY',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        // Departure Row
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(flightNumber,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text('CONFIRMED',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                '$date\n$time',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(from,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text('TERMINAL 0',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                '$date\n0730',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('ECONOMY', style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 2),
                  pw.Text('27 K',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                'NOT AFTER\n${DateFormat('dd MMM yy').format(DateTime.now().add(const Duration(days: 365))).toUpperCase()}',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        // Arrival Row
        pw.TableRow(
          children: [
            pw.Container(),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                '$date\n${_calculateArrivalTime(time)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(to,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text('TERMINAL 3',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Container(),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('BAGGAGE',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                  pw.SizedBox(height: 2),
                  pw.Text('ALLOWANCE\n30KGS',
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.Container(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfTrainTravelTable() {
    final trainDetails = _booking['trainDetails'] as Map<String, dynamic>?;
    final trainNumber = trainDetails?['trainNumber'] ?? 'N/A';
    final trainName = trainDetails?['trainName'] ?? 'N/A';
    final from = trainDetails?['from'] ?? 'N/A';
    final to = trainDetails?['to'] ?? 'N/A';
    final date = trainDetails?['date'] ?? 'N/A';
    final time = trainDetails?['departure'] ?? 'N/A';
    final classType = trainDetails?['class'] ?? 'Economy';

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: const PdfColor(0.8, 0.8, 0.8)),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            color: const PdfColor(0.9, 0.9, 0.9),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Train: $trainNumber / $trainName',
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text('Class: $classType',
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('From Station:',
                        style: const pw.TextStyle(
                            fontSize: 10, color: PdfColors.grey700)),
                    pw.Text(from,
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('To Station:',
                        style: const pw.TextStyle(
                            fontSize: 10, color: PdfColors.grey700)),
                    pw.Text(to,
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Departure:',
                        style: const pw.TextStyle(
                            fontSize: 10, color: PdfColors.grey700)),
                    pw.Text('$date $time',
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFareBreakdown() {
    final passengerCount = _booking['passengerCount'] ?? 1;
    final amount = _booking['amount'] ?? 0.0;
    final perPassengerFare =
        passengerCount > 0 ? amount / passengerCount : amount;
    final serviceFee = _booking['serviceFee'] ?? 0.0;
    final total = _booking['total'] ?? 0.0;
    final currency = _booking['currency'] ?? 'PKR';
    final paymentMethod = _booking['paymentMethod'] ?? 'N/A';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'FARE',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        if (passengerCount > 1) ...[
          _buildPdfFareRow(
              'Base Fare (per passenger)', perPassengerFare, currency),
          _buildPdfFareRow(
              'Base Fare (x$passengerCount passengers)', amount, currency),
        ] else
          _buildPdfFareRow('Base Fare', amount, currency),
        if (serviceFee > 0)
          _buildPdfFareRow('Service Fee', serviceFee, currency),
        pw.SizedBox(height: 10),
        pw.Text(
          'TAXES/FEES/CHARGES',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        _buildPdfTaxRow('MYR2.0QH', 'MYR47.0YR'),
        _buildPdfTaxRow('PD100.0EG', 'PD187.0AX'),
        _buildPdfTaxRow('F6200.0ZZ', ''),
        pw.SizedBox(height: 10),
        pw.Divider(color: const PdfColor(0.7, 0.7, 0.7), thickness: 1),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('TOTAL',
                style:
                    pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            pw.Text(
              '$currency ${total.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'FORM OF PAYMENT',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          paymentMethod.toUpperCase(),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '*1 CHQOUR YOU MAY NEED TO PRESENT THE CREDIT CARD USED FOR PAYMENT OF THIS TICKET*',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ],
    );
  }

  pw.Widget _buildPdfAdditionalInfo() {
    final passengerCount = _booking['passengerCount'] ?? 1;
    final isRoundTrip = _booking['isRoundTrip'] == true;
    final transactionId = _booking['transactionId'] ?? 'N/A';
    final date = DateFormat('dd MMM yyyy').format(DateTime.now());

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'ADDITIONAL INFORMATION',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          '* NONREF NON-ENDORSKYWARDS',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          'SAVER/NO ON ENDPENALTIES APPLY',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Trip Type: ${isRoundTrip ? "ROUND TRIP" : "ONE-WAY"}',
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Total Passengers: $passengerCount',
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Transaction ID: $transactionId',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          'Booking Date: $date',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          'Status: CONFIRMED',
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor(0.2, 0.6, 0.2)),
        ),
      ],
    );
  }

  pw.Widget _buildPdfFareRow(String label, double amount, String currency) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(
            '$currency ${amount.toStringAsFixed(2)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTaxRow(String code1, String code2) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        code2.isNotEmpty ? '$code1    $code2' : code1,
        style: const pw.TextStyle(fontSize: 9, letterSpacing: 0.5),
      ),
    );
  }

  pw.Widget _buildPdfReturnFlightTable() {
    final returnFlightDetails =
        _booking['returnFlightDetails'] as Map<String, dynamic>?;
    if (returnFlightDetails == null) {
      return pw.SizedBox.shrink();
    }

    final flightNumber = returnFlightDetails['flightNumber'] ?? 'N/A';
    final from = returnFlightDetails['from'] ?? 'N/A';
    final to = returnFlightDetails['to'] ?? 'N/A';
    final date = returnFlightDetails['date'] ?? 'N/A';
    final time = returnFlightDetails['departure'] ?? 'N/A';

    return pw.Table(
      border: pw.TableBorder.all(color: const PdfColor(0.8, 0.8, 0.8)),
      columnWidths: {
        0: const pw.FixedColumnWidth(60),
        1: const pw.FixedColumnWidth(80),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FixedColumnWidth(80),
        4: const pw.FixedColumnWidth(60),
        5: const pw.FixedColumnWidth(90),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColor(0.7, 0.85, 1.0)),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('RETURN',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('DEPART/\nARRIVE',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('AIRPORT/TERMINAL',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('CHECK-IN\nOPENS',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('CLASS',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('COUPON\nVALIDITY',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(flightNumber,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text('CONFIRMED',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('$date\n$time',
                  style: const pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(from,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text('TERMINAL 0',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('$date\n0730',
                  style: const pw.TextStyle(fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child:
                  pw.Text('ECONOMY', style: const pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                'NOT AFTER\n${DateFormat('dd MMM yy').format(DateTime.now().add(const Duration(days: 365))).toUpperCase()}',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Container(),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('$date\n${_calculateArrivalTime(time)}',
                  style: const pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(to,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text('TERMINAL 3',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Container(),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('BAGGAGE\nALLOWANCE\n30KGS',
                  style: const pw.TextStyle(fontSize: 8)),
            ),
            pw.Container(),
          ],
        ),
      ],
    );
  }

  String _buildPassengerNamesString() {
    final allPassengers = _booking['allPassengers'];
    if (allPassengers == null ||
        allPassengers is! List ||
        allPassengers.isEmpty) {
      return (_booking['passengerName']?.toUpperCase() ?? 'N/A');
    }

    if (allPassengers.length == 1) {
      final passenger = allPassengers[0] as Map;
      return (passenger['name']?.toString().toUpperCase() ?? 'N/A');
    }

    final names = <String>[];
    for (int i = 0; i < allPassengers.length; i++) {
      final passenger = allPassengers[i] as Map;
      final name =
          passenger['name']?.toString().toUpperCase() ?? 'PASSENGER ${i + 1}';
      names.add('${i + 1}. $name');
    }
    return names.join('\n');
  }

  String _buildFareCalculationString() {
    final bookingType = _booking['bookingType'] as String? ?? 'flight';
    final isRailway = bookingType == 'train';

    if (isRailway) {
      final trainDetails = _booking['trainDetails'];
      final fromStation = trainDetails?['from']?.toString() ?? 'N/A';
      final toStation = trainDetails?['to']?.toString() ?? 'N/A';
      final classType = _booking['class'] ?? 'Economy';
      final passengerCount = _booking['passengerCount'] ?? 1;
      final baseFare = _booking['amount'] ?? 0.0;
      final perPaxFare =
          passengerCount > 0 ? baseFare / passengerCount : baseFare;

      return 'PR $fromStation X $toStation / $classType\n'
          'BASE FARE: PKR ${perPaxFare.toStringAsFixed(2)} x $passengerCount PAX\n'
          'TOTAL BASE: PKR ${baseFare.toStringAsFixed(2)}';
    } else {
      final flightDetails = _booking['flightDetails'];
      final from = flightDetails?['from'] ?? 'N/A';
      final fromCode =
          RegExp(r'\(([A-Z]{3})\)').firstMatch(from)?.group(1) ?? 'XXX';

      return 'CAI EK X/DXB Q85.00EK KUL 192.53JUEE1/'
          'EGHEKF X/$fromCode NUC857.74963';
    }
  }

  String _calculateArrivalTime(String departureTime) {
    try {
      final parts = departureTime.split(':');
      if (parts.length != 2) return '$departureTime + 2h';

      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);

      hours += 2;
      if (hours >= 24) hours -= 24;

      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '$departureTime + 2h';
    }
  }
}
