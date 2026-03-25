import 'package:flight_app/models/ai_chat.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Itinerary data model
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _DayPlan {
  final int day;
  final String title;
  final String icon;
  final List<String> activities;
  const _DayPlan(
      {required this.day,
      required this.title,
      required this.icon,
      required this.activities});
}

class _TripItinerary {
  final String destination;
  final String province;
  final String imageUrl;
  final String style;
  final int duration;
  final String budget;
  final List<_DayPlan> days;
  final DateTime? savedDate;
  const _TripItinerary({
    required this.destination,
    required this.province,
    required this.imageUrl,
    required this.style,
    required this.duration,
    required this.budget,
    required this.days,
    this.savedDate,
  });
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Itinerary database by destination
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
Map<String, List<_DayPlan>> _itineraryDB = {
  'Hunza Valley': [
    const _DayPlan(day: 1, title: 'Arrival in Gilgit', icon: 'âœˆï¸', activities: [
      'Land at Gilgit Airport',
      'Drive to Karimabad (2.5 hrs)',
      'Check into hotel & rest',
      'Evening stroll at Karimabad Bazaar'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Attabad Lake & Hopper Glacier',
        icon: 'ðŸ”ï¸',
        activities: [
          'Morning: Attabad Lake boat ride',
          'Visit Hopper Glacier',
          'Lunch at lakeside cafÃ©',
          'Visit Karakoram Highway viewpoints'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Baltit Fort & Eagle\'s Nest',
        icon: 'ðŸ°',
        activities: [
          'Explore Baltit Fort (UNESCO)',
          'Visit Altit Fort',
          'Hike to Eagle\'s Nest viewpoint',
          'Sunset photography over Hunza River'
        ]),
    const _DayPlan(day: 4, title: 'Rakaposhi Viewpoint', icon: 'ðŸ—»', activities: [
      'Drive to Rakaposhi Base Camp',
      'Cherry blossom orchard walk',
      'Visit Nilt & Diran villages',
      'Traditional Hunza cuisine dinner'
    ]),
    const _DayPlan(day: 5, title: 'Departure', icon: 'ðŸ ', activities: [
      'Morning: Khunjerab Pass day trip (optional)',
      'Souvenir shopping for dry fruits & gems',
      'Drive back to Gilgit Airport',
      'Depart with lifetime memories'
    ]),
  ],
  'Skardu': [
    const _DayPlan(day: 1, title: 'Arrival in Skardu', icon: 'âœˆï¸', activities: [
      'Land at Skardu Airport',
      'Visit Skardu Bazaar',
      'Check-in & settle',
      'Shangrila Resort evening visit'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Shangrila & Kachura Lakes',
        icon: 'ðŸžï¸',
        activities: [
          'Upper & Lower Kachura Lakes',
          'Row boat at Shangrila Resort',
          'Visit Manthal Buddha Rock',
          'Sunset at Skardu Fort'
        ]),
    const _DayPlan(day: 3, title: 'Deosai National Park', icon: 'ðŸŒ¿', activities: [
      'Early morning drive to Deosai (2,800m altitude)',
      'Brown bear safari',
      'Wildflower meadow walk',
      'Sheosar Lake photography'
    ]),
    const _DayPlan(
        day: 4,
        title: 'K2 Base Camp Viewpoint',
        icon: 'â›°ï¸',
        activities: [
          'Drive toward Concordia area',
          'Baltoro Glacier viewpoint',
          'Jeep safari on Indus River banks',
          'Stargazing night (no light pollution)'
        ]),
    const _DayPlan(day: 5, title: 'Departure', icon: 'ðŸ ', activities: [
      'Morning: Satpara Lake visit',
      'Local gem & mineral shopping',
      'Drive to Skardu Airport',
      'Depart Skardu'
    ]),
  ],
  'Lahore': [
    const _DayPlan(day: 1, title: 'Mughal Heritage', icon: 'ðŸ•Œ', activities: [
      'Badshahi Mosque (largest mosque in Pakistan)',
      'Lahore Fort & Sheesh Mahal',
      'Hazuri Bagh gardens',
      'Dinner at Cooco\'s Den restaurant'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Walled City & Food Street',
        icon: 'ðŸ½ï¸',
        activities: [
          'Morning: Walled City walking tour',
          'Aurangzeb Mosque & Wazir Khan Mosque',
          'Fort Road Food Street lunch',
          'Anarkali Bazaar shopping'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Colonial Lahore & Museums',
        icon: 'ðŸ›ï¸',
        activities: [
          'Lahore Museum (largest museum in Pakistan)',
          'Aitchison College & Mall Road',
          'Packages Mall & Liberty Market',
          'Tikka Gali dinner at Burns Road'
        ]),
  ],
  'Islamabad': [
    const _DayPlan(
        day: 1,
        title: 'Faisal Mosque & Margalla Hills',
        icon: 'ðŸ•Œ',
        activities: [
          'Faisal Mosque (4th largest in world)',
          'Daman-e-Koh viewpoint',
          'Trail 3 Margalla Hills hike',
          'Centaurus Mall evening'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Rawalpindi & Heritage',
        icon: 'ðŸ›ï¸',
        activities: [
          'Pakistan Monument & Museum',
          'Lok Virsa Museum',
          'Raja Bazaar Rawalpindi',
          'Ayub National Park'
        ]),
    const _DayPlan(day: 3, title: 'Murree Day Trip', icon: 'ðŸŒ²', activities: [
      'Drive to Murree (1 hr)',
      'Mall Road Murree',
      'Pindi Point chairlift',
      'Pine forests walk & photography'
    ]),
  ],
};

List<_DayPlan> _getItinerary(String destination, int duration) {
  final allDays = _itineraryDB[destination] ??
      [
        const _DayPlan(
            day: 1,
            title: 'Arrival & Check-in',
            icon: 'âœˆï¸',
            activities: [
              'Arrive at destination',
              'Check into hotel',
              'Local area exploration',
              'Welcome dinner'
            ]),
        const _DayPlan(
            day: 2,
            title: 'Main Attractions',
            icon: 'ðŸ—ºï¸',
            activities: [
              'Visit top landmark',
              'Local museum or fort',
              'Traditional lunch',
              'Souvenir shopping'
            ]),
        const _DayPlan(day: 3, title: 'Nature & Outdoors', icon: 'ðŸŒ¿', activities: [
          'Morning nature walk',
          'Scenic viewpoint visit',
          'Picnic lunch',
          'Sunset photography'
        ]),
        const _DayPlan(day: 4, title: 'Culture & Food', icon: 'ðŸ½ï¸', activities: [
          'Local food street tour',
          'Cultural heritage site',
          'Traditional crafts shopping',
          'Farewell dinner'
        ]),
        const _DayPlan(day: 5, title: 'Departure', icon: 'ðŸ ', activities: [
          'Morning leisure',
          'Last-minute shopping',
          'Depart to airport',
          'Head home with memories'
        ]),
      ];
  return allDays.take(duration).toList();
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Main Screen
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // â”€â”€ Chat state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // â”€â”€ Plan Trip state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String? _tripDestination;
  String _tripStyle = 'Adventure';
  int _tripDuration = 5;
  String _tripBudget = 'Mid-range';
  bool _isGenerating = false;
  _TripItinerary? _generatedTrip;

  // â”€â”€ Saved Trips state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final List<_TripItinerary> _savedTrips = [
    _TripItinerary(
      destination: 'Hunza Valley',
      province: 'Gilgit-Baltistan',
      imageUrl:
          'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&q=80',
      style: 'Adventure',
      duration: 5,
      budget: 'Mid-range',
      savedDate: DateTime(2026, 3, 10),
      days: _itineraryDB['Hunza Valley']!,
    ),
    _TripItinerary(
      destination: 'Lahore',
      province: 'Punjab',
      imageUrl:
          'https://images.unsplash.com/photo-1584204687456-cbed5e3c1e82?w=800&q=80',
      style: 'Cultural',
      duration: 3,
      budget: 'Budget',
      savedDate: DateTime(2026, 2, 20),
      days: _itineraryDB['Lahore']!,
    ),
  ];

  static const List<String> _destinations = [
    'Hunza Valley',
    'Skardu',
    'Swat Valley',
    'Naran & Kaghan',
    'Fairy Meadows',
    'Gilgit',
    'Chitral',
    'Gwadar',
    'Karachi',
    'Lahore',
    'Islamabad',
    'Peshawar',
    'Multan',
    'Quetta',
    'Neelum Valley',
    'Taxila',
    'Mohenjo-daro',
  ];
  static const List<Map<String, dynamic>> _styles = [
    {'label': 'Adventure', 'icon': Icons.terrain, 'color': Color(0xFF1565C0)},
    {
      'label': 'Cultural',
      'icon': Icons.account_balance,
      'color': Color(0xFF880E4F)
    },
    {
      'label': 'Relaxing',
      'icon': Icons.beach_access,
      'color': Color(0xFF006064)
    },
    {
      'label': 'Family',
      'icon': Icons.family_restroom,
      'color': Color(0xFF4527A0)
    },
    {'label': 'Nature', 'icon': Icons.park, 'color': Color(0xFF2E7D32)},
  ];
  static const List<int> _durations = [3, 5, 7, 10];
  static const List<Map<String, dynamic>> _budgets = [
    {'label': 'Budget', 'range': 'PKR 5Kâ€“15K', 'icon': Icons.savings},
    {
      'label': 'Mid-range',
      'range': 'PKR 15Kâ€“40K',
      'icon': Icons.account_balance_wallet
    },
    {'label': 'Luxury', 'range': 'PKR 40K+', 'icon': Icons.diamond},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _messages.add(ChatMessage(
      id: '1',
      message:
          "Hello! ðŸ‘‹ I'm your AI Travel Assistant for Pakistan. How can I help you plan your journey today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // BUILD
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 20, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('AI Planner'),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemePalette.primaryMain,
          labelColor: ThemePalette.primaryMain,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.chat_bubble_outline, size: 18), text: 'Chat'),
            Tab(icon: Icon(Icons.map_outlined, size: 18), text: 'Plan Trip'),
            Tab(icon: Icon(CupertinoIcons.bookmark, size: 18), text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(),
          _buildPlanTripTab(),
          _buildSavedTripsTab(),
        ],
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // TAB 1 â€” CHAT
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(spacingUnit(2)),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
        if (_messages.length == 1) _buildSuggestions(),
        _buildInputField(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: colorScheme(context).primaryContainer,
              child: Icon(Icons.auto_awesome,
                  color: colorScheme(context).onPrimaryContainer, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(spacingUnit(1.5)),
              decoration: BoxDecoration(
                color: message.isUser
                    ? colorScheme(context).primaryContainer
                    : colorScheme(context).surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
              ),
              child: Text(message.message,
                  style: ThemeText.paragraph.copyWith(
                    color: message.isUser
                        ? colorScheme(context).onPrimaryContainer
                        : null,
                  )),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: colorScheme(context).tertiaryContainer,
              child: Icon(Icons.person,
                  color: colorScheme(context).onTertiaryContainer, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorScheme(context).primaryContainer,
            child: Icon(Icons.auto_awesome,
                color: colorScheme(context).onPrimaryContainer, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(spacingUnit(1.5)),
            decoration: BoxDecoration(
              color: colorScheme(context).surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(delay: 200),
                const SizedBox(width: 4),
                _buildDot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: colorScheme(context).primary, shape: BoxShape.circle),
        ),
      ),
      onEnd: () => setState(() {}),
    );
  }

  Widget _buildSuggestions() {
    final suggestions = AIAssistantData.getSuggestions();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: spacingUnit(2), vertical: spacingUnit(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Try asking:', style: ThemeText.caption),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions
                .map((s) => ActionChip(
                      avatar: Text(s.icon),
                      label: Text(s.title),
                      onPressed: () => _sendMessage(s.title),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(spacingUnit(2)),
      decoration: BoxDecoration(
        color: colorScheme(context).surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask me about your trip...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24)),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: spacingUnit(2), vertical: spacingUnit(1)),
                ),
                onSubmitted: _sendMessage,
                textInputAction: TextInputAction.send,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: colorScheme(context).primary,
              child: IconButton(
                icon: Icon(Icons.send, color: colorScheme(context).onPrimary),
                onPressed: () => _sendMessage(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: text,
          isUser: true,
          timestamp: DateTime.now()));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            message: AIAssistantData.getAIResponse(text),
            isUser: false,
            timestamp: DateTime.now()));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // TAB 2 â€” PLAN TRIP
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildPlanTripTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF283593)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome,
                    color: Color(0xFFD4AF37), size: 32),
                SizedBox(width: spacingUnit(1.5)),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Trip Planner',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text('Get a personalised day-by-day Pakistan itinerary',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacingUnit(3)),

          // Step 1 â€“ Destination
          _buildStepLabel('1', 'Choose Destination'),
          SizedBox(height: spacingUnit(1)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme(context).outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _tripDestination,
                hint: const Text('Select a destination in Pakistan'),
                items: _destinations
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) => setState(() {
                  _tripDestination = val;
                  _generatedTrip = null;
                }),
              ),
            ),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 2 â€“ Trip Style
          _buildStepLabel('2', 'Travel Style'),
          SizedBox(height: spacingUnit(1)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _styles.map((style) {
              final isSelected = _tripStyle == style['label'];
              return FilterChip(
                selected: isSelected,
                avatar: Icon(style['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Colors.black
                        : colorScheme(context).onSurface),
                label: Text(style['label'] as String),
                selectedColor: ThemePalette.primaryMain,
                checkmarkColor: Colors.black,
                onSelected: (_) => setState(() {
                  _tripStyle = style['label'] as String;
                  _generatedTrip = null;
                }),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 3 â€“ Duration
          _buildStepLabel('3', 'Trip Duration'),
          SizedBox(height: spacingUnit(1)),
          Row(
            children: _durations.map((d) {
              final isSelected = _tripDuration == d;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _tripDuration = d;
                      _generatedTrip = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ThemePalette.primaryMain
                            : colorScheme(context).surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected
                                ? ThemePalette.primaryMain
                                : colorScheme(context).outline),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$d',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isSelected ? Colors.black : null)),
                          Text('days',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected
                                      ? Colors.black87
                                      : colorScheme(context)
                                          .onSurface
                                          .withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 4 â€“ Budget
          _buildStepLabel('4', 'Budget Range'),
          SizedBox(height: spacingUnit(1)),
          Row(
            children: _budgets.map((b) {
              final isSelected = _tripBudget == b['label'];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _tripBudget = b['label'] as String;
                      _generatedTrip = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 72,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ThemePalette.primaryMain
                            : colorScheme(context).surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected
                                ? ThemePalette.primaryMain
                                : colorScheme(context).outline),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(b['icon'] as IconData,
                              size: 20,
                              color: isSelected
                                  ? Colors.black
                                  : colorScheme(context).primary),
                          const SizedBox(height: 4),
                          Text(b['label'] as String,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isSelected ? Colors.black : null)),
                          Text(b['range'] as String,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: isSelected
                                      ? Colors.black87
                                      : colorScheme(context)
                                          .onSurface
                                          .withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(3)),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _tripDestination == null ? null : _generateTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemePalette.primaryMain,
                foregroundColor: Colors.black,
                disabledBackgroundColor: colorScheme(context).outline,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              icon: _isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.auto_awesome),
              label: Text(
                  _isGenerating
                      ? 'Generating your plan...'
                      : 'Generate My Trip Plan',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: spacingUnit(3)),

          // Generated Itinerary
          if (_generatedTrip != null) _buildItineraryResult(_generatedTrip!),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String step, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: ThemePalette.primaryMain, shape: BoxShape.circle),
          child: Center(
              child: Text(step,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12))),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  void _generateTrip() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final days = _getItinerary(_tripDestination!, _tripDuration);
    setState(() {
      _isGenerating = false;
      _generatedTrip = _TripItinerary(
        destination: _tripDestination!,
        province: _getProvince(_tripDestination!),
        imageUrl: _getDestinationImage(_tripDestination!),
        style: _tripStyle,
        duration: _tripDuration,
        budget: _tripBudget,
        days: days,
      );
    });
  }

  Widget _buildItineraryResult(_TripItinerary trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trip header card
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(trip.imageUrl, fit: BoxFit.cover),
                ),
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                )),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: ThemePalette.primaryMain,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(trip.style,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text('${trip.duration} days',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(trip.budget,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11)),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Text(trip.destination,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      Text(trip.province,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacingUnit(2)),

        // Day-by-day cards
        ...trip.days.map((day) => _buildDayCard(day)),
        SizedBox(height: spacingUnit(2)),

        // Save button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _savedTrips.insert(
                    0,
                    _TripItinerary(
                      destination: trip.destination,
                      province: trip.province,
                      imageUrl: trip.imageUrl,
                      style: trip.style,
                      duration: trip.duration,
                      budget: trip.budget,
                      days: trip.days,
                      savedDate: DateTime.now(),
                    ));
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${trip.destination} trip saved!'),
                backgroundColor: const Color(0xFF2E7D32),
                behavior: SnackBarBehavior.floating,
              ));
              _tabController.animateTo(2);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemePalette.primaryMain,
              side: BorderSide(color: ThemePalette.primaryMain),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(CupertinoIcons.bookmark_fill),
            label: const Text('Save This Trip Plan',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: spacingUnit(3)),
      ],
    );
  }

  Widget _buildDayCard(_DayPlan day) {
    return Container(
      margin: EdgeInsets.only(bottom: spacingUnit(1.5)),
      decoration: BoxDecoration(
        color: colorScheme(context).surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: colorScheme(context).outline.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: ThemePalette.primaryMain.withValues(alpha: 0.15),
              shape: BoxShape.circle),
          child: Center(
              child: Text(day.icon, style: const TextStyle(fontSize: 18))),
        ),
        title: Text('Day ${day.day}: ${day.title}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        initiallyExpanded: day.day == 1,
        childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, spacingUnit(1.5)),
        children: day.activities
            .map((activity) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 6, right: 10),
                          decoration: BoxDecoration(
                              color: ThemePalette.primaryMain,
                              shape: BoxShape.circle)),
                      Expanded(
                          child: Text(activity,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // TAB 3 â€” SAVED TRIPS
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildSavedTripsTab() {
    if (_savedTrips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.bookmark,
                size: 64, color: colorScheme(context).outline),
            SizedBox(height: spacingUnit(2)),
            const Text('No saved trips yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: spacingUnit(1)),
            Text('Generate a trip plan and save it here',
                style: TextStyle(
                    color:
                        colorScheme(context).onSurface.withValues(alpha: 0.5))),
            SizedBox(height: spacingUnit(3)),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ThemePalette.primaryMain,
                  foregroundColor: Colors.black),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Plan a Trip'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(spacingUnit(2)),
      itemCount: _savedTrips.length,
      itemBuilder: (context, index) {
        final trip = _savedTrips[index];
        return _buildSavedTripCard(trip, index);
      },
    );
  }

  Widget _buildSavedTripCard(_TripItinerary trip, int index) {
    return Dismissible(
      key: Key('${trip.destination}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: spacingUnit(2)),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => setState(() => _savedTrips.removeAt(index)),
      child: Container(
        margin: EdgeInsets.only(bottom: spacingUnit(2)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Image header
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(trip.imageUrl, fit: BoxFit.cover)),
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    )),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip.destination,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(trip.province,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    if (trip.savedDate != null)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Saved ${trip.savedDate!.day}/${trip.savedDate!.month}/${trip.savedDate!.year}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Info row
              Container(
                color: colorScheme(context).surfaceContainerHighest,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    _infoChip(Icons.terrain, trip.style),
                    const SizedBox(width: 8),
                    _infoChip(Icons.calendar_today, '${trip.duration} days'),
                    const SizedBox(width: 8),
                    _infoChip(Icons.account_balance_wallet, trip.budget),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _showSavedTripDetail(trip),
                      style: TextButton.styleFrom(
                          foregroundColor: ThemePalette.primaryMain,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6)),
                      child: const Text('View Plan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 12,
            color: colorScheme(context).onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: colorScheme(context).onSurface.withValues(alpha: 0.7))),
      ],
    );
  }

  void _showSavedTripDetail(_TripItinerary trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: EdgeInsets.all(spacingUnit(2)),
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: spacingUnit(1.5)),
            Text('${trip.destination} â€” ${trip.duration} Day Plan',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: spacingUnit(2)),
            ...trip.days.map((day) => _buildDayCard(day)),
          ],
        ),
      ),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Helpers
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String _getProvince(String destination) {
    const map = {
      'Hunza Valley': 'Gilgit-Baltistan',
      'Skardu': 'Gilgit-Baltistan',
      'Swat Valley': 'KPK',
      'Naran & Kaghan': 'KPK',
      'Fairy Meadows': 'Gilgit-Baltistan',
      'Gilgit': 'Gilgit-Baltistan',
      'Chitral': 'KPK',
      'Gwadar': 'Balochistan',
      'Karachi': 'Sindh',
      'Lahore': 'Punjab',
      'Islamabad': 'Federal Capital',
      'Peshawar': 'KPK',
      'Multan': 'Punjab',
      'Quetta': 'Balochistan',
      'Neelum Valley': 'AJK',
      'Taxila': 'Punjab',
      'Mohenjo-daro': 'Sindh',
    };
    return map[destination] ?? 'Pakistan';
  }

  String _getDestinationImage(String destination) {
    const map = {
      'Hunza Valley':
          'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&q=80',
      'Skardu':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
      'Swat Valley':
          'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&q=80',
      'Naran & Kaghan':
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
      'Fairy Meadows':
          'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=800&q=80',
      'Gilgit':
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=800&q=80',
      'Lahore':
          'https://images.unsplash.com/photo-1584204687456-cbed5e3c1e82?w=800&q=80',
      'Islamabad':
          'https://images.unsplash.com/photo-1578895101408-1a36b834405b?w=800&q=80',
      'Peshawar':
          'https://images.unsplash.com/photo-1539136788836-5699e78bfc75?w=800&q=80',
      'Gwadar':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
      'Quetta':
          'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=800&q=80',
    };
    return map[destination] ??
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80';
  }
}
