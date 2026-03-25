# Professional Flight & Train Booking Flows - Travello AI

## Overview
This document provides a complete guide to the professional booking flows implemented for both airplane and train interfaces in Travello AI. These flows follow modern UI/UX best practices with clean, responsive layouts and reusable components.

---

## 📋 Table of Contents
1. [Flight Booking Flow](#flight-booking-flow)
2. [Train Booking Flow](#train-booking-flow)
3. [Shared Components](#shared-components)
4. [Routes & Navigation](#routes--navigation)
5. [Usage Guide](#usage-guide)

---

## ✈️ Flight Booking Flow

### 1. Flight Search Home (`flight_search_home.dart`)
**Route:** `/flight-search-home`

#### Features:
- **Trip Type Selector**: One-way, Round-trip, Multi-city
- **Airport Search**: 
  - From and To city search fields
  - Airport suggestions with search functionality
  - Displays airport code, name, and city
  - Swap button to exchange departure/arrival
- **Date Pickers**: 
  - Departure date (required)
  - Return date (for round-trip)
  - Calendar integration with date restrictions
- **Passenger Selector**:
  - Adults (12+ years) - minimum 1, maximum 9
  - Children (2-11 years) - 0 to 9
  - Infants (Under 2 years) - 0 to 9 (must not exceed adults)
  - Modal bottom sheet interface
- **Cabin Class Dropdown**: Economy, Premium Economy, Business, First Class
- **Sticky Bottom Button**: "Search Flights" button always visible

#### UI Highlights:
- Beautiful gradient app bar
- Card-based input sections with shadows
- Icon-driven interface
- Professional color scheme
- Bottom sheet modals for selections

---

### 2. Flight Results Screen (`flight_results_screen.dart`)
**Route:** `/flight-results`

#### Features:

##### Filters Section:
- **Direct Flights Toggle**: Show only non-stop flights
- **Maximum Stops Filter**: Direct, 1 Stop, 2+ Stops, Any
- **Price Range Slider**: Dynamic range based on available flights
- **Departure Time Range**: 24-hour sliding scale
- **Refundable Toggle**: Show only refundable flights
- **Filters Modal**: Full-screen bottom sheet with all filter options

##### Flight Result Cards:
Each card displays:
- **AI Badge**: "Cheapest", "Fastest", or "Recommended" with gradient styling
- **Airline Logo**: Visual placeholder
- **Airline Name & Code**
- **Departure & Arrival Times**
- **Duration & Route Visualization**: 
  - Dot-and-line timeline showing stops
  - Stop cities displayed
- **Price**: Prominent display with currency
- **Refundable Status**: Clear indicator
- **Select Button**: Prominent CTA

##### Sort Options:
- Recommended (default)
- Cheapest (price ascending)
- Fastest (duration ascending)

#### UI Highlights:
- Clean card-based design
- Color-coded badges (green for cheapest, blue for fastest, orange for recommended)
- Interactive filters with immediate visual feedback
- Empty state handling
- Smooth transitions

---

### 3. Flight Detail Screen (`flight_detail_professional.dart`)
**Route:** `/flight-detail-professional`

#### Features:

##### Flight Summary Card:
- AI Badge (if applicable)
- Large airline logo and details
- Complete timeline: Departure → Duration → Arrival
- Airport codes and city names
- Visual flight path representation

##### Layover Details:
- Shows all stop cities (if multi-stop)
- Estimated layover duration per stop
- Warning-style UI for visibility

##### Baggage Information:
- Check-in allowance (weight and pieces)
- Cabin baggage allowance
- Icon-driven presentation

##### Cancellation Policy:
- Refundable status
- Time-based refund percentages
- Clear terms display

##### Fare Breakdown:
- Base fare breakdown by passenger type
- Adults, Children, Infants (if applicable)
- Taxes and fees
- **Total price** prominently displayed

#### Bottom Navigation:
- Total price summary
- "Continue" button to passenger form

---

### 4. Passenger Form (`passenger_form_professional.dart`)
**Route:** `/booking-passengers`

#### Features:

##### Passenger Forms:
For each passenger (Adult/Child/Infant):
- **First Name** (required)
- **Last Name** (required)
- **CNIC/Passport Number** (required)
- **Email** (Adults only, required)
- **Phone Number** (Adults only, required)
- **Save Traveler Checkbox**: Option to save details for future bookings

##### Add-ons Section:

**Extra Baggage:**
- Counter interface (+ / -)
- Price per kg: PKR 1,000
- Up to 30 kg additional

**Seat Selection:**
- Visual seat map with grid layout
- Price: PKR 2,000 per seat
- Available seats displayed (1A, 1B, 1C, etc.)
- Selected seat highlighted

**Travel Insurance:**
- Toggle switch
- Price: PKR 1,500
- Coverage details: Up to PKR 500,000

#### Price Breakdown:
- Base flight price
- Each add-on itemized
- Running total
- "Proceed to Payment" button

#### UI Highlights:
- Card-based passenger forms
- Professional form validation
- Icon-driven add-ons
- Interactive seat selection grid
- Real-time price calculation

---

## 🚂 Train Booking Flow

### 1. Train Search Home (`train_search_home.dart`)
**Route:** `/train-search-home`

#### Features:
- **Station Search**: 
  - From and To railway station fields
  - Search with station name, city, or code
  - Swap button
  - Modal bottom sheet with search
- **Date Picker**: Single date for journey
- **Passenger Selector**: Simple counter (1-9 passengers)
- **Class Dropdown**: 
  - AC Business
  - AC Standard
  - AC Sleeper
  - Economy

#### UI Highlights:
- Green color scheme (distinctive from flights)
- Train-specific icons
- Similar UX to flight booking for consistency
- Clean, modern interface

---

### 2. Train Results Screen (`train_results_screen.dart`)
**Route:** `/train-results`

#### Features:

##### Train Result Cards:
Each card displays:
- **Train Icon**: Visual indicator
- **Train Name**: e.g., "Green Line Express"
- **Train Number**: e.g., "GL-001"
- **Departure & Arrival Times**
- **Duration**: Total journey time
- **Available Seats**: With color coding (orange if < 20)
- **Available Classes**: Count of class options
- **Starting Price**: Lowest class price
- **Select Button**: Opens class selection

##### Class Selection Modal:
When user taps "Select":
- Shows all available classes for that train
- Each class shows:
  - Class name and icon (AC has snowflake icon)
  - Description (e.g., "Premium seating, meals included")
  - Price per person
- Tapping a class proceeds to passenger form

#### Dummy Data:
- 5 sample trains with realistic names
- Variable class availability
- Dynamic pricing
- Seat availability simulation

---

### 3. Train Passenger Form (`train_passenger_form.dart`)
**Route:** `/train-passengers`

#### Features:

##### Train Summary Card:
- Train name and number
- Selected class
- Departure and arrival times
- Journey duration

##### Passenger Forms:
For each passenger:
- **First Name** (required)
- **Last Name** (required)
- **CNIC Number** (required, Pakistani format)
- **Phone Number** (required)

#### Bottom Navigation:
- Total price calculation
- Passenger count display
- "Proceed to Payment" button

#### UI Highlights:
- Green theme throughout
- Simpler form than flights (no add-ons)
- Train journey summary always visible
- Professional validation

---

## 💳 Shared Payment Screen

### Payment Screen (`payment_screen_professional.dart`)
**Route:** `/payment-professional`

#### Features:

##### Fare Breakdown:
- **Flight Bookings**: Shows base fare, add-ons, taxes
- **Train Bookings**: Shows passenger count × price
- Total amount prominently displayed

##### Payment Methods:
- **Card Payment**:
  - Card number
  - Card holder name
  - Expiry date (MM/YY)
  - CVV
- **JazzCash**:
  - Mobile number
  - PIN
- **Easypaisa**:
  - Mobile number
  - PIN
- **Bank Transfer**:
  - Bank details displayed
  - Account information
  - IBAN
  - Instructions

##### Payment Processing:
- Loading state during processing
- Success dialog with:
  - Confirmation animation (green checkmark)
  - Booking reference number
  - Success message
  - "Done" button to return home

#### UI Highlights:
- Dynamic color scheme (blue for flights, green for trains)
- Method-specific forms
- Professional payment interface
- Clear confirmation flow
- Error handling

---

## 🎨 Shared Components

### Design System:
All screens use:
- **Theme Palette**: Consistent color scheme from `theme_palette.dart`
- **Theme Spacing**: Standardized spacing units
- **Theme Text**: Typography system
- **Cupertino Icons**: iOS-style icons throughout

### Reusable Patterns:
- **Bottom Sheet Modals**: For selections and filters
- **Card Containers**: With consistent shadows and radius
- **Form Fields**: Standardized input styling
- **Buttons**: Primary, secondary, and text buttons
- **Chips**: For filters and selections

---

## 🛣️ Routes & Navigation

### Route Configuration:
All routes are configured in `routes_professional.dart` and imported into `app_routes.dart`.

### Navigation Flow - Flights:
```
Flight Search Home → Flight Results → Flight Detail → Passenger Form → Payment → Confirmation
```

### Navigation Flow - Trains:
```
Train Search Home → Train Results → [Class Selection] → Passenger Form → Payment → Confirmation
```

### Route Names:
```dart
// Flights
'/flight-search-home'
'/flight-results'
'/flight-detail-professional'
'/booking-passengers'

// Trains
'/train-search-home'
'/train-results'
'/train-passengers'

// Shared
'/payment-professional'
```

---

## 📱 Usage Guide

### To Access Flight Booking:
```dart
Get.toNamed('/flight-search-home');
```

### To Access Train Booking:
```dart
Get.toNamed('/train-search-home');
```

### Passing Data Between Screens:
```dart
Get.toNamed('/flight-results', arguments: {
  'fromAirport': airport1,
  'toAirport': airport2,
  'departureDate': date,
  'passengers': count,
  // ... other params
});
```

### Accessing Passed Data:
```dart
final args = Get.arguments ?? {};
final airport = args['fromAirport'] as Airport?;
```

---

## 🎯 Key Features Summary

### Flight Booking:
✅ Multi-trip type support (One-way, Round-trip, Multi-city)
✅ Advanced filtering (stops, price, time, refundable)
✅ AI-powered recommendations
✅ Seat selection with visual map
✅ Extra baggage options
✅ Travel insurance
✅ Complete fare breakdown
✅ Multiple payment methods

### Train Booking:
✅ Station search with suggestions
✅ Multiple class options per train
✅ Real-time seat availability
✅ Class-specific pricing
✅ Simplified passenger form
✅ Complete journey details
✅ Integrated payment flow

### Shared Features:
✅ Responsive layouts
✅ Form validation
✅ Loading states
✅ Empty states
✅ Error handling
✅ Professional UI/UX
✅ Consistent design language
✅ Smooth animations and transitions
✅ Accessibility considerations

---

## 📦 Files Created

### Flight Booking:
1. `lib/screens/flight/flight_search_home.dart`
2. `lib/screens/flight/flight_results_screen.dart`
3. `lib/screens/flight/flight_detail_professional.dart`
4. `lib/screens/booking/passenger_form_professional.dart`

### Train Booking:
5. `lib/screens/railway/train_search_home.dart`
6. `lib/screens/railway/train_results_screen.dart`
7. `lib/screens/railway_booking/train_passenger_form.dart`

### Shared:
8. `lib/screens/payment/payment_screen_professional.dart`
9. `lib/app/routes_professional.dart`

### Updated:
10. `lib/app/app_routes.dart` (added routes_professional import)

---

## 🚀 Next Steps

### To Implement Backend:
1. Replace dummy data with API calls
2. Connect to Firebase/Backend for:
   - Real flight/train data
   - User authentication
   - Booking storage
   - Payment gateway integration
3. Add passenger data persistence
4. Implement e-ticket generation

### Enhancements:
1. Add multi-city flight support
2. Implement seat map with real data
3. Add loyalty program integration
4. Email confirmation system
5. Push notifications for booking updates
6. QR code for e-tickets

---

## 📞 Support

For questions or issues with the booking flows, refer to:
- Component documentation in respective files
- Theme documentation in `lib/ui/themes/`
- Model documentation in `lib/models/`

---

**Built with Flutter • Get Navigation • Professional UI/UX Standards**

*Last Updated: February 2026*
