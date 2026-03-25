class Faq {
  Faq({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

final List<Faq> faqData = [
  Faq(
    expandedValue:
        'You can create an account by clicking the "Sign Up" button on the welcome screen. You can register using your email, Google, or Apple account. If you prefer to explore first, you can also continue as a guest.',
    headerValue: 'How do I create an account on Travello AI?',
  ),
  Faq(
    expandedValue:
        'To book a flight, tap "Create New Booking" on the home screen, select your departure and destination cities, choose your travel dates, and select the number of passengers. Then browse available flights and complete your booking.',
    headerValue: 'How do I book a flight?',
  ),
  Faq(
    expandedValue:
        'You can view all your bookings by tapping "My Orders" in the bottom navigation bar. This will show you all your past and upcoming trips with detailed booking information.',
    headerValue: 'Where can I see my bookings?',
  ),
  Faq(
    expandedValue:
        'Yes! Travello AI supports both flight and train bookings. You can switch between modes using the flight/train icon in the top navigation. Each mode offers tailored search and booking options.',
    headerValue: 'Can I book trains as well as flights?',
  ),
  Faq(
    expandedValue:
        'You can cancel your booking from the "My Orders" section. Select the booking you want to cancel and follow the cancellation process. Note that cancellation policies vary by airline and fare type.',
    headerValue: 'How do I cancel my booking?',
  ),
  Faq(
    expandedValue:
        'Travello AI accepts all major credit cards, debit cards, and digital payment methods. All payments are processed securely through our encrypted payment gateway.',
    headerValue: 'What payment methods are accepted?',
  ),
  Faq(
    expandedValue:
        'After completing your booking, you will receive a confirmation email with your e-ticket and booking details. You can also access your tickets anytime from the "My Orders" section.',
    headerValue: 'How do I get my ticket after booking?',
  ),
  Faq(
    expandedValue:
        'Yes, you can modify your booking details like passenger names, contact information, or travel dates (subject to airline policies) from the "My Orders" section. Additional charges may apply.',
    headerValue: 'Can I modify my booking after confirmation?',
  )
];
