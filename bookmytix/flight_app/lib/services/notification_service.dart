import 'package:flight_app/models/notification.dart';

/// Singleton service — call from any booking confirmation screen to
/// push a real notification into the notifications panel.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  // ── helpers ───────────────────────────────────────────────────────────────

  String _airlineTag(String airline) {
    final a = airline.toLowerCase();
    if (a.contains('pia') || a.contains('pakistan international')) return 'PIA';
    if (a.contains('airblue')) return 'AirBlue';
    if (a.contains('airsial')) return 'AirSial';
    if (a.contains('serene')) return 'Serene';
    return airline.split(' ').first;
  }

  void _prepend(NotificationModel n) => notifListToday.insert(0, n);

  // ── FLIGHT ────────────────────────────────────────────────────────────────

  void flightBooked({
    required String airline,
    required String flightNumber,
    required String fromCode,
    required String toCode,
    required String date,
    required String departure,
    required String pnr,
    String seatClass = 'Economy',
  }) {
    _prepend(NotificationModel(
      type: 'success',
      category: 'flight',
      tag: _airlineTag(airline),
      title: '$airline $flightNumber — Booking Confirmed',
      subtitle:
          '$fromCode → $toCode · $date, $departure · $seatClass · PNR: $pnr',
      date: 'Just now',
      isRead: false,
    ));
  }

  void flightCheckInOpen({
    required String airline,
    required String flightNumber,
    required String fromCode,
    required String toCode,
    required String departure,
    required String pnr,
  }) {
    _prepend(NotificationModel(
      type: 'info',
      category: 'flight',
      tag: _airlineTag(airline),
      title: '$airline $flightNumber — Online check-in open',
      subtitle:
          '$fromCode → $toCode · Dep. $departure · Check-in closes 1 hr before departure',
      date: 'Just now',
      isRead: false,
    ));
  }

  // ── TRAIN ─────────────────────────────────────────────────────────────────

  void trainBooked({
    required String trainName,
    required String fromStation,
    required String toStation,
    required String date,
    required String departure,
    required String seatClass,
    required String coach,
    required String seat,
    required String pnr,
  }) {
    _prepend(NotificationModel(
      type: 'success',
      category: 'train',
      tag: 'Train',
      title: 'Pakistan Railways — Ticket Confirmed',
      subtitle:
          '$trainName · $fromStation → $toStation · $date, $departure · $seatClass · Coach $coach, Seat $seat · PNR: $pnr',
      date: 'Just now',
      isRead: false,
    ));
  }

  // ── HOTEL ─────────────────────────────────────────────────────────────────

  void hotelBooked({
    required String hotelName,
    required String city,
    required String roomType,
    required String checkIn,
    required String checkOut,
    required String bookingRef,
  }) {
    _prepend(NotificationModel(
      type: 'success',
      category: 'hotel',
      tag: 'Hotel',
      title: '$hotelName — Booking Confirmed',
      subtitle:
          '$city · $roomType · Check-in: $checkIn · Check-out: $checkOut · Ref: $bookingRef',
      date: 'Just now',
      isRead: false,
    ));
  }

  void hotelCheckInReminder({
    required String hotelName,
    required String checkInTime,
    required String bookingRef,
  }) {
    _prepend(NotificationModel(
      type: 'info',
      category: 'hotel',
      tag: 'Hotel',
      title: '$hotelName — Check-in Reminder',
      subtitle:
          'Check-in today at $checkInTime. Please carry valid CNIC or Passport. Ref: $bookingRef',
      date: 'Just now',
      isRead: false,
    ));
  }
}
