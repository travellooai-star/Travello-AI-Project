class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}

class AISuggestion {
  final String title;
  final String icon;

  AISuggestion({required this.title, required this.icon});
}

// Dummy AI responses for demo
class AIAssistantData {
  static List<AISuggestion> getSuggestions() {
    return [
      AISuggestion(
        title: 'Plan a trip from Karachi to Lahore',
        icon: '🚂',
      ),
      AISuggestion(
        title: 'Cheapest flights to Islamabad',
        icon: '✈️',
      ),
      AISuggestion(
        title: 'Best time to visit Murree',
        icon: '🏔️',
      ),
      AISuggestion(
        title: 'Hotels near Faisal Mosque',
        icon: '🏨',
      ),
    ];
  }

  static String getAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('karachi') && message.contains('lahore')) {
      return "I'd recommend taking the Tezgam Express or Green Line for comfort. The journey takes about 13-14 hours. AC Business class costs around PKR 3,500. Would you like me to show available trains?";
    } else if (message.contains('islamabad') || message.contains('flight')) {
      return "For flights to Islamabad, morning flights (6-8 AM) are usually cheaper. Major airlines operate this route daily. Prices range from PKR 8,000 to PKR 15,000 depending on the season.";
    } else if (message.contains('murree') || message.contains('weather')) {
      return "Murree is best visited from May to September for pleasant weather. During winter (Dec-Feb), you can enjoy snowfall but roads may be slippery. Check weather alerts before traveling!";
    } else if (message.contains('hotel') || message.contains('accommodation')) {
      return "I can help you find accommodations! Tell me your destination city and budget range, and I'll suggest the best options for you.";
    } else if (message.contains('train') && message.contains('ticket')) {
      return "You can book train tickets directly through the Railway section. Select your departure station, destination, date, and class to see available trains.";
    } else if (message.contains('help') || message.contains('guide')) {
      return "I'm here to help! I can assist with:\n• Flight & train booking guidance\n• Travel recommendations\n• Weather updates\n• Best routes and timings\n• Cost estimates\n\nWhat would you like to know?";
    } else {
      return "I'm your AI travel assistant for Pakistan! I can help you plan trips, find the best routes, check weather, and provide travel tips. What would you like to know about your journey?";
    }
  }
}
