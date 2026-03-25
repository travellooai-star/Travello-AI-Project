# Quick Start Guide - Professional Booking Flows

## 🚀 Getting Started

### Step 1: Run the App
```bash
cd "C:\Users\checking\Downloads\TRAVELLO AI\bookmytix_v101\bookmytix\flight_app"
flutter run
```

## 📱 How to Access the New Booking Flows

### Option 1: Direct Navigation (for testing)
You can navigate directly to the new screens from anywhere in your app:

#### Flight Booking:
```dart
import 'package:get/get.dart';

// Navigate to flight search
Get.toNamed('/flight-search-home');
```

#### Train Booking:
```dart
import 'package:get/get.dart';

// Navigate to train search
Get.toNamed('/train-search-home');
```

### Option 2: Add to Home Screen
Add navigation buttons to your home screen. Example:

```dart
// In your home screen widget
ElevatedButton(
  onPressed: () => Get.toNamed('/flight-search-home'),
  child: Text('Book Flight'),
)

ElevatedButton(
  onPressed: () => Get.toNamed('/train-search-home'),
  child: Text('Book Train'),
)
```

## 🔍 Testing Features

### Flight Booking Flow:

1. **Search Screen** (`/flight-search-home`):
   - Try all trip types (One-way, Round-trip, Multi-city)
   - Search and select airports
   - Use the swap button
   - Select dates
   - Add different passenger combinations
   - Change cabin classes

2. **Results Screen** (`/flight-results`):
   - Test all filters (direct flights, stops, price, time, refundable)
   - Try different sort options
   - Click on flight cards to see details

3. **Detail Screen** (`/flight-detail-professional`):
   - Review flight information
   - Check layover details (for multi-stop flights)
   - Review baggage policy
   - Check fare breakdown

4. **Passenger Form** (`/booking-passengers`):
   - Fill passenger details
   - Add extra baggage
   - Select seats
   - Toggle travel insurance
   - Watch price update in real-time

5. **Payment Screen** (`/payment-professional`):
   - Try different payment methods
   - Fill payment details
   - Process payment
   - See confirmation

### Train Booking Flow:

1. **Search Screen** (`/train-search-home`):
   - Search and select railway stations
   - Use the swap button
   - Select travel date
   - Choose passenger count
   - Select train class

2. **Results Screen** (`/train-results`):
   - View available trains
   - Check seat availability
   - Open class selection modal
   - Select different classes

3. **Passenger Form** (`/train-passengers`):
   - Fill passenger details for all travelers
   - Review journey summary
   - Check total price

4. **Payment Screen** (`/payment-professional`):
   - Same as flight booking
   - Notice green theme for trains

## 🎨 Customization

### Change Colors:
Edit the colors in the theme files:
- `lib/ui/themes/theme_palette.dart`

### Change Dummy Data:
Each screen has dummy data defined:
- **Flights**: `flight_results_screen.dart` → `_loadDummyFlights()`
- **Trains**: `train_results_screen.dart` → `_loadDummyTrains()`

### Modify Prices:
Adjust prices in:
- **Extra Baggage**: PKR 1,000/kg in `passenger_form_professional.dart`
- **Seat Selection**: PKR 2,000 in `passenger_form_professional.dart`
- **Insurance**: PKR 1,500 in `passenger_form_professional.dart`
- **Train Classes**: In `train_results_screen.dart` → `_loadDummyTrains()`

## 🐛 Troubleshooting

### "Screen not found" error:
Make sure `routes_professional.dart` is imported in `app_routes.dart`:
```dart
import 'package:flight_app/app/routes_professional.dart';
```

And added to the routes list:
```dart
...routesProfessional,
```

### Import errors:
Run:
```bash
flutter pub get
flutter clean
flutter run
```

### UI not updating:
Try hot restart instead of hot reload:
- Press `R` in the terminal (full restart)

## 📊 Test Scenarios

### Flight Booking:
1. **Solo Traveler**: 1 Adult, Economy, One-way
2. **Family Trip**: 2 Adults, 2 Children, Business, Round-trip
3. **With Infant**: 2 Adults, 1 Infant, Economy, One-way
4. **Premium Experience**: 1 Adult, First Class, Extra baggage, Seat Selection, Insurance

### Train Booking:
1. **Solo Journey**: 1 Passenger, Economy
2. **Group Travel**: 6 Passengers, AC Business
3. **Budget Travel**: 3 Passengers, Economy
4. **Overnight Journey**: 2 Passengers, AC Sleeper

## 🔗 Quick Links

### Documentation:
- [Complete Documentation](PROFESSIONAL_BOOKING_FLOWS.md)
- Main App: `lib/main.dart`
- Routes: `lib/app/routes_professional.dart`

### Screen Files:
- Flight Search: `lib/screens/flight/flight_search_home.dart`
- Train Search: `lib/screens/railway/train_search_home.dart`
- Payment: `lib/screens/payment/payment_screen_professional.dart`

## 💡 Pro Tips

1. **Use Hot Reload**: Press `r` in terminal for fast iterations
2. **Check Console**: Look for validation errors and navigation logs
3. **Test on Different Screens**: Try different device sizes
4. **Explore Animations**: Notice smooth transitions between screens
5. **Test Edge Cases**: Try invalid inputs, empty selections, etc.

## 🎯 What's Working

✅ Complete flight booking flow (6 steps)
✅ Complete train booking flow (5 steps)
✅ Advanced filtering for flights
✅ Class selection for trains
✅ Add-ons (baggage, seats, insurance)
✅ Form validation
✅ Multiple payment methods
✅ Success confirmation
✅ Responsive layouts
✅ Professional UI/UX

## 🔄 Navigation Flow Diagram

```
FLIGHTS:
┌─────────────────────┐
│  Flight Search Home │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Flight Results    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Flight Detail     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Passenger Form     │
│  + Add-ons          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Payment Screen    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Confirmation      │
└─────────────────────┘

TRAINS:
┌─────────────────────┐
│  Train Search Home  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Train Results     │
│ + Class Selection   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Passenger Form     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Payment Screen    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Confirmation      │
└─────────────────────┘
```

---

**Happy Testing! 🎉**

For detailed documentation, see [PROFESSIONAL_BOOKING_FLOWS.md](PROFESSIONAL_BOOKING_FLOWS.md)
