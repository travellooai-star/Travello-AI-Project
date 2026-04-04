import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/screens/flight/flight_results_screen.dart';
import 'package:flight_app/app/app_link.dart';

class FlightDetailProfessional extends StatelessWidget {
  const FlightDetailProfessional({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final flight = args['flight'] as FlightResult?;
    final searchParams = args['searchParams'] as Map<String, dynamic>? ?? {};
    final isRoundTrip = args['isRoundTrip'] as bool? ?? false;
    final outboundFlight = args['outboundFlight'] as FlightResult?;
    final returnFlight = args['returnFlight'] as FlightResult?;

    if (flight == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(title: const Text('Flight Details')),
        body: const Center(child: Text('Flight not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Flight Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Flight summary card
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
              child: Column(
                children: [
                  // Badge
                  if (flight.badge.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(1.5),
                          vertical: spacingUnit(0.5),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: flight.badge == 'Cheapest'
                                ? [Colors.green, Colors.greenAccent]
                                : flight.badge == 'Fastest'
                                    ? [Colors.blue, Colors.blueAccent]
                                    : [Colors.orange, Colors.orangeAccent],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              flight.badge == 'Cheapest'
                                  ? CupertinoIcons.money_dollar_circle
                                  : flight.badge == 'Fastest'
                                      ? CupertinoIcons.bolt_fill
                                      : CupertinoIcons.star_fill,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: spacingUnit(0.5)),
                            Text(
                              flight.badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (flight.badge.isNotEmpty) SizedBox(height: spacingUnit(2)),

                  // Airline info
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: colorScheme(context).primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            flight.airlineLogo,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      SizedBox(width: spacingUnit(2)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.airlineName,
                              style: ThemeText.title2,
                            ),
                            Text(
                              '${flight.airlineCode} • ${flight.cabinClass}',
                              style: ThemeText.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacingUnit(3)),

                  // Flight timeline
                  Row(
                    children: [
                      // Departure
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.departureTime,
                              style: ThemeText.title2,
                            ),
                            Text(
                              searchParams['fromAirport']?.code ?? 'DEP',
                              style: ThemeText.subtitle,
                            ),
                            Text(
                              searchParams['fromAirport']?.city ?? 'Departure',
                              style: ThemeText.caption,
                            ),
                          ],
                        ),
                      ),

                      // Duration
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.airplane,
                              color: colorScheme(context).primary,
                            ),
                            SizedBox(height: spacingUnit(0.5)),
                            Text(
                              flight.duration,
                              style: ThemeText.caption,
                            ),
                            SizedBox(height: spacingUnit(0.5)),
                            Container(
                              height: 2,
                              color: colorScheme(context).primary,
                              margin: EdgeInsets.symmetric(
                                  horizontal: spacingUnit(2)),
                            ),
                            SizedBox(height: spacingUnit(0.5)),
                            Text(
                              flight.stops == 0
                                  ? 'Non-stop'
                                  : '${flight.stops} ${flight.stops == 1 ? 'stop' : 'stops'}',
                              style: ThemeText.caption,
                            ),
                          ],
                        ),
                      ),

                      // Arrival
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              flight.arrivalTime,
                              style: ThemeText.title2,
                            ),
                            Text(
                              searchParams['toAirport']?.code ?? 'ARR',
                              style: ThemeText.subtitle,
                            ),
                            Text(
                              searchParams['toAirport']?.city ?? 'Arrival',
                              style: ThemeText.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Layover details (if stops > 0)
            if (flight.stops > 0)
              Container(
                margin: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                padding: EdgeInsets.all(spacingUnit(2)),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.info_circle,
                          color: Colors.orange,
                          size: 20,
                        ),
                        SizedBox(width: spacingUnit(1)),
                        const Text(
                          'Layover Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacingUnit(1)),
                    ...flight.stopCities.asMap().entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(top: spacingUnit(0.5)),
                        child: Text(
                          '• Stop ${entry.key + 1}: ${entry.value} (2h 30m layover)',
                          style: ThemeText.caption,
                        ),
                      );
                    }),
                  ],
                ),
              ),

            if (flight.stops > 0) SizedBox(height: spacingUnit(2)),

            // Baggage information
            _buildInfoSection(
              context,
              'Baggage Information',
              CupertinoIcons.bag,
              [
                _buildInfoRow('Check-in', '30 kg (2 pieces)'),
                _buildInfoRow('Cabin', '7 kg (1 piece)'),
              ],
            ),

            SizedBox(height: spacingUnit(2)),

            // Cancellation policy
            _buildInfoSection(
              context,
              'Cancellation Policy',
              CupertinoIcons.xmark_shield,
              [
                if (flight.isRefundable) ...[
                  _buildInfoRow('Refundable', 'Yes'),
                  _buildInfoRow('Cancellation before 24h', '100% refund'),
                  _buildInfoRow('Cancellation before 12h', '50% refund'),
                  _buildInfoRow('Within 12h', 'No refund'),
                ] else ...[
                  _buildInfoRow('Refundable', 'No'),
                  _buildInfoRow('Cancellation', 'Not allowed'),
                ],
              ],
            ),

            SizedBox(height: spacingUnit(2)),

            // Fare breakdown
            _buildInfoSection(
              context,
              'Fare Breakdown',
              CupertinoIcons.money_dollar_circle,
              [
                _buildInfoRow(
                  'Base Fare (${searchParams['adults'] ?? 1} Adult${(searchParams['adults'] ?? 1) > 1 ? 's' : ''})',
                  'PKR ${(flight.price * 0.85).toStringAsFixed(0)}',
                ),
                if ((searchParams['children'] ?? 0) > 0)
                  _buildInfoRow(
                    'Children (${searchParams['children']})',
                    'PKR ${((flight.price * 0.75) * (searchParams['children'] ?? 0)).toStringAsFixed(0)}',
                  ),
                if ((searchParams['infants'] ?? 0) > 0)
                  _buildInfoRow(
                    'Infants (${searchParams['infants']})',
                    'PKR ${((flight.price * 0.25) * (searchParams['infants'] ?? 0)).toStringAsFixed(0)}',
                  ),
                _buildInfoRow(
                  'Taxes & Fees',
                  'PKR ${(flight.price * 0.15).toStringAsFixed(0)}',
                ),
                Divider(height: spacingUnit(2)),
                _buildInfoRow(
                  'Total',
                  'PKR ${flight.price.toStringAsFixed(0)}',
                  isTotal: true,
                ),
              ],
            ),

            SizedBox(height: spacingUnit(10)),
          ],
        ),
      ),

      // Continue button
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Price', style: ThemeText.caption),
                        Text(
                          'PKR ${flight.price.toStringAsFixed(0)}',
                          style: ThemeText.title2.copyWith(
                            color: colorScheme(context).primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        AppLink.bookingStep1,
                        arguments: {
                          'flight': flight,
                          'searchParams': searchParams,
                          'isRoundTrip': isRoundTrip,
                          'outboundFlight': outboundFlight,
                          'returnFlight': returnFlight,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme(context).primary,
                      foregroundColor: colorScheme(context).onPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingUnit(4),
                        vertical: spacingUnit(2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
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
          Row(
            children: [
              Icon(
                icon,
                color: colorScheme(context).primary,
                size: 20,
              ),
              SizedBox(width: spacingUnit(1)),
              Text(
                title,
                style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(1.5)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingUnit(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : ThemeText.caption,
          ),
          Text(
            value,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : ThemeText.subtitle,
          ),
        ],
      ),
    );
  }
}
