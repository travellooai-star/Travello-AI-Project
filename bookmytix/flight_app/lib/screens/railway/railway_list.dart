import 'package:flight_app/models/train.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RailwayListScreen extends StatefulWidget {
  const RailwayListScreen({super.key});

  @override
  State<RailwayListScreen> createState() => _RailwayListScreenState();
}

class _RailwayListScreenState extends State<RailwayListScreen> {
  late List<Train> _trains;
  late String _fromStation;
  late String _toStation;
  late DateTime _date;
  late String _trainClass;
  late int _passengers;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _fromStation = args['fromStation'] as String;
    _toStation = args['toStation'] as String;
    _date = args['date'] as DateTime;
    _trainClass = args['trainClass'] as String;
    _passengers = args['passengers'] as int;

    // Get filtered trains
    _trains = PakistanTrains.getDummyTrains(
      fromStation: _fromStation,
      toStation: _toStation,
      trainClass: _trainClass == 'All' ? null : _trainClass,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Trains'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Summary
            Container(
              padding: EdgeInsets.all(spacingUnit(2)),
              color: colorScheme(context).primaryContainer,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.train,
                              size: 16,
                              color: colorScheme(context).onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$_fromStation → $_toStation',
                                style: ThemeText.subtitle.copyWith(
                                  color:
                                      colorScheme(context).onPrimaryContainer,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_date.day}/${_date.month}/${_date.year} • $_passengers ${_passengers == 1 ? 'Passenger' : 'Passengers'}',
                          style: ThemeText.caption.copyWith(
                            color: colorScheme(context).onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: _trains.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: colorScheme(context).outline,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No trains found',
                            style: ThemeText.title2,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try adjusting your search criteria',
                            style: ThemeText.caption,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(spacingUnit(2)),
                      itemCount: _trains.length,
                      itemBuilder: (context, index) {
                        return _TrainCard(
                          train: _trains[index],
                          passengers: _passengers,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainCard extends StatelessWidget {
  final Train train;
  final int passengers;

  const _TrainCard({
    required this.train,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = train.price * passengers;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(spacingUnit(2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Train Name & Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        train.name,
                        style: ThemeText.title.copyWith(fontSize: 16),
                      ),
                      Text(
                        'Train #${train.trainNumber}',
                        style: ThemeText.caption,
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
                    color: colorScheme(context).tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    train.trainClass,
                    style: ThemeText.caption.copyWith(
                      color: colorScheme(context).onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time & Duration
            Row(
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        train.departureTime,
                        style: ThemeText.title.copyWith(fontSize: 16),
                      ),
                      Text(
                        train.fromStation,
                        style: ThemeText.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Duration
                Column(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: colorScheme(context).primary,
                    ),
                    Text(
                      train.duration,
                      style: ThemeText.caption,
                    ),
                  ],
                ),

                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        train.arrivalTime,
                        style: ThemeText.title.copyWith(fontSize: 16),
                      ),
                      Text(
                        train.toStation,
                        style: ThemeText.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seats & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: 16,
                      color: train.availableSeats < 20
                          ? Colors.orange
                          : const Color(0xFFD4AF37),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${train.availableSeats} seats left',
                      style: ThemeText.caption.copyWith(
                        color: train.availableSeats < 20
                            ? Colors.orange
                            : const Color(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
                Text(
                  'PKR ${totalPrice.toStringAsFixed(0)}',
                  style: ThemeText.title.copyWith(
                    fontSize: 16,
                    color: colorScheme(context).primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Book Button
            FilledButton(
              style: ThemeButton.btnBig,
              onPressed: () {
                Get.toNamed(
                  '/railway-booking-passengers',
                  arguments: {
                    'train': train,
                  },
                );
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}

