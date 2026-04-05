import 'package:flight_app/models/ai_chat.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Send button with hover scale effect
// ─────────────────────────────────────────────────────────────────────────────
class _SendButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  const _SendButton(
      {required this.onPressed,
      required this.backgroundColor,
      required this.iconColor});
  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.12 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: CircleAvatar(
          backgroundColor: widget.backgroundColor,
          child: IconButton(
            icon: Icon(Icons.send, color: widget.iconColor),
            onPressed: widget.onPressed,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Itinerary data model
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Itinerary database by destination
// ─────────────────────────────────────────────────────────────────────────────
Map<String, List<_DayPlan>> _itineraryDB = {
  'Hunza Valley': [
    const _DayPlan(day: 1, title: 'Arrival in Gilgit', icon: '✈️', activities: [
      'Land at Gilgit Airport',
      'Drive to Karimabad (2.5 hrs)',
      'Check into hotel & rest',
      'Evening stroll at Karimabad Bazaar'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Attabad Lake & Hopper Glacier',
        icon: '🏔️',
        activities: [
          'Morning: Attabad Lake boat ride',
          'Visit Hopper Glacier',
          'Lunch at lakeside café',
          'Visit Karakoram Highway viewpoints'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Baltit Fort & Eagle\'s Nest',
        icon: '🏰',
        activities: [
          'Explore Baltit Fort (UNESCO)',
          'Visit Altit Fort',
          'Hike to Eagle\'s Nest viewpoint',
          'Sunset photography over Hunza River'
        ]),
    const _DayPlan(
        day: 4,
        title: 'Rakaposhi Viewpoint',
        icon: '🗻',
        activities: [
          'Drive to Rakaposhi Base Camp',
          'Cherry blossom orchard walk',
          'Visit Nilt & Diran villages',
          'Traditional Hunza cuisine dinner'
        ]),
    const _DayPlan(day: 5, title: 'Departure', icon: '🏠', activities: [
      'Morning: Khunjerab Pass day trip (optional)',
      'Souvenir shopping for dry fruits & gems',
      'Drive back to Gilgit Airport',
      'Depart with lifetime memories'
    ]),
  ],
  'Skardu': [
    const _DayPlan(day: 1, title: 'Arrival in Skardu', icon: '✈️', activities: [
      'Land at Skardu Airport',
      'Visit Skardu Bazaar',
      'Check-in & settle',
      'Shangrila Resort evening visit'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Shangrila & Kachura Lakes',
        icon: '🏞️',
        activities: [
          'Upper & Lower Kachura Lakes',
          'Row boat at Shangrila Resort',
          'Visit Manthal Buddha Rock',
          'Sunset at Skardu Fort'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Deosai National Park',
        icon: '🌿',
        activities: [
          'Early morning drive to Deosai (2,800m altitude)',
          'Brown bear safari',
          'Wildflower meadow walk',
          'Sheosar Lake photography'
        ]),
    const _DayPlan(
        day: 4,
        title: 'K2 Base Camp Viewpoint',
        icon: '⛰️',
        activities: [
          'Drive toward Concordia area',
          'Baltoro Glacier viewpoint',
          'Jeep safari on Indus River banks',
          'Stargazing night (no light pollution)'
        ]),
    const _DayPlan(day: 5, title: 'Departure', icon: '🏠', activities: [
      'Morning: Satpara Lake visit',
      'Local gem & mineral shopping',
      'Drive to Skardu Airport',
      'Depart Skardu'
    ]),
  ],
  'Lahore': [
    const _DayPlan(day: 1, title: 'Mughal Heritage', icon: '🕌', activities: [
      'Badshahi Mosque (largest mosque in Pakistan)',
      'Lahore Fort & Sheesh Mahal',
      'Hazuri Bagh gardens',
      'Dinner at Cooco\'s Den restaurant'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Walled City & Food Street',
        icon: '🍽️',
        activities: [
          'Morning: Walled City walking tour',
          'Aurangzeb Mosque & Wazir Khan Mosque',
          'Fort Road Food Street lunch',
          'Anarkali Bazaar shopping'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Colonial Lahore & Museums',
        icon: '🏛️',
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
        icon: '🕌',
        activities: [
          'Faisal Mosque (4th largest in world)',
          'Daman-e-Koh viewpoint',
          'Trail 3 Margalla Hills hike',
          'Centaurus Mall evening'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Rawalpindi & Heritage',
        icon: '🏛️',
        activities: [
          'Pakistan Monument & Museum',
          'Lok Virsa Museum',
          'Raja Bazaar Rawalpindi',
          'Ayub National Park'
        ]),
    const _DayPlan(day: 3, title: 'Murree Day Trip', icon: '🌲', activities: [
      'Drive to Murree hill station (1 hr)',
      'Mall Road stroll & local shopping',
      'Pindi Point chairlift ride',
      'Pine forests walk & sunset photography'
    ]),
  ],
  'Swat Valley': [
    const _DayPlan(
        day: 1,
        title: 'Arrival in Mingora',
        icon: '✈️',
        activities: [
          'Arrive at Saidu Sharif Airport or drive from Peshawar',
          'Swat Museum — Gandhara Buddhist art & artefacts',
          'Explore Mingora Green Chowk Bazaar',
          'Traditional Pashtun dinner at local restaurant'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Malam Jabba Ski Resort',
        icon: '⛷️',
        activities: [
          'Drive to Malam Jabba (45 km from Mingora)',
          'Chairlift ride for panoramic Hindukush views',
          'Ancient Buddhist ruins at Butkara Stupa',
          'Fizagat Park riverside evening picnic'
        ]),
    const _DayPlan(day: 3, title: 'Kalam Valley', icon: '🏔️', activities: [
      'Scenic drive to Kalam (85 km along Swat River)',
      'Ushu Forest — towering pine & fir trees',
      'Mahodand Lake boat ride (16 km from Kalam)',
      'Overnight at Kalam guesthouse'
    ]),
    const _DayPlan(
        day: 4,
        title: 'Bahrain & River Rafting',
        icon: '🌊',
        activities: [
          'White-water rafting on Swat River at Bahrain',
          'Trout fishing at Swat River banks',
          'Mingora Night Bazaar — Swati gemstones & crafts',
          'Saidu Baba historic shrine visit'
        ]),
    const _DayPlan(day: 5, title: 'Departure', icon: '🏠', activities: [
      'Morning: Saidu Sharif royal mosque visit',
      'Last shopping — Swati embroidery & emerald gems',
      'Drive back to Peshawar or fly home',
      'Depart Swat Valley'
    ]),
  ],
  'Naran & Kaghan': [
    const _DayPlan(day: 1, title: 'Drive to Naran', icon: '✈️', activities: [
      'Drive from Islamabad via Mansehra to Naran (5 hrs)',
      'Kunhar River gorge — dramatic roadside views',
      'Check into Naran & explore the town',
      'Traditional Kaghan Valley dinner'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Saif-ul-Malook Lake',
        icon: '💎',
        activities: [
          'Jeep ride to Saif-ul-Malook Lake (3,224 m)',
          'Pakistan\'s most photographed turquoise lake',
          'Photography with Malika Parbat snow peak',
          'Trek around the lake (2 hr loop)'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Lulusar & Babusar Pass',
        icon: '🗻',
        activities: [
          'Drive to Lulusar Lake — mirror-like reflections',
          'Cross Babusar Pass (4,173 m altitude)',
          'Panoramic views of Nanga Parbat',
          'Return to Naran for dinner'
        ]),
    const _DayPlan(day: 4, title: 'Departure', icon: '🏠', activities: [
      'Morning: Batakundi meadows stroll',
      'Ansoo (Teardrop) Lake viewpoint trail',
      'Drive back to Islamabad',
      'Depart Kaghan Valley'
    ]),
  ],
  'Fairy Meadows': [
    const _DayPlan(
        day: 1,
        title: 'Raikot Bridge Trek Start',
        icon: '✈️',
        activities: [
          'Drive from Gilgit to Raikot Bridge (80 km)',
          'Jeep ride to Tato Village (rough mountain track)',
          'Begin 3-hour scenic trek to Fairy Meadows',
          'First spectacular view of Nanga Parbat (8,126 m)'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Nanga Parbat Base Camp Trek',
        icon: '⛰️',
        activities: [
          'Stunning sunrise view of Nanga Parbat "Killer Mountain"',
          'Trek to Beyal Base Camp (4 hrs round-trip)',
          'Alpine wildflowers & glacial moraine walk',
          'Campfire storytelling with local Kashmiri guides'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Panorama & Departure',
        icon: '🏠',
        activities: [
          'Golden hour mountain photography at dawn',
          'Explore Fairy Meadows higher viewpoints',
          'Trek down to Raikot Bridge',
          'Drive back to Gilgit town'
        ]),
  ],
  'Gilgit': [
    const _DayPlan(
        day: 1,
        title: 'Gilgit City & Rock Carvings',
        icon: '✈️',
        activities: [
          'Arrive at Gilgit Airport',
          'Kargah Buddha Rock Carving (7th century CE)',
          'Gilgit Bazaar — dry fruits, gems & local spices',
          'Traditional Dumpukht lamb dinner'
        ]),
    const _DayPlan(day: 2, title: 'Naltar Valley', icon: '🏔️', activities: [
      'Drive to Naltar Valley (40 km, 1.5 hrs)',
      'Three colourful Naltar Lakes (blue, green & turquoise)',
      'Naltar Ski Resort viewpoints (year-round)',
      'Pine forest picnic & wildlife spotting'
    ]),
    const _DayPlan(day: 3, title: 'Rakaposhi & KKH', icon: '🗻', activities: [
      'Drive on Karakoram Highway (8th Wonder of the world)',
      'Rakaposhi Base Camp viewpoint (7,788 m peak)',
      'Nilt Fort & ancient Chinese fort ruins',
      'Return to Gilgit for Sajji dinner'
    ]),
  ],
  'Chitral': [
    const _DayPlan(
        day: 1,
        title: 'Arrival in Chitral',
        icon: '✈️',
        activities: [
          'Fly Islamabad → Chitral or drive via Lowari Tunnel',
          'Chitral Fort (Royal Palace of Mehtars)',
          'Shahi Mosque — royal mosque of Chitral royalty',
          'Browse Kalash crafts at local bazaar'
        ]),
    const _DayPlan(day: 2, title: 'Kalash Valleys', icon: '🎭', activities: [
      'Drive to Bumburet Valley — Kalash homeland (35 km)',
      'Meet the unique pre-Islamic Kalash people',
      'Kalash Museum & traditional wooden houses',
      'Witness traditional Kalash folk dances & festivals'
    ]),
    const _DayPlan(
        day: 3,
        title: 'Shandur Polo Ground',
        icon: '🏑',
        activities: [
          'Drive toward Shandur Top (3,734 m)',
          'World\'s highest polo ground',
          'Shandur Lake panorama',
          'Return to Chitral for traditional dinner'
        ]),
    const _DayPlan(day: 4, title: 'Departure', icon: '🏠', activities: [
      'Morning: Mastuj Fort ruins exploration',
      'Chitrali cap (Pakol) & wool shawl shopping',
      'Fly or drive back to Islamabad',
      'Depart Chitral'
    ]),
  ],
  'Gwadar': [
    const _DayPlan(
        day: 1,
        title: 'Arrival & CPEC Port',
        icon: '✈️',
        activities: [
          'Arrive at Gwadar International Airport',
          'Gwadar Deep Sea Port overview (CPEC mega-project)',
          'Padi Zirr Beach sunset & pebble shores',
          'Fresh catch seafood dinner at Gwadar Fish Harbour'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Hammerhead & Beaches',
        icon: '🌊',
        activities: [
          'Hammerhead Point — dramatic cliffs over Arabian Sea',
          'Princess of Hope rock arch formation',
          'Snorkelling at Pasni Beach',
          'Gwadar New Town promenade sunset walk'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Marine Drive & Departure',
        icon: '🏠',
        activities: [
          'Gwadar Marine Drive — iconic seaside boulevard',
          'Mirani Dam viewpoint',
          'Local Balochi seafood brunch (Sajji fish)',
          'Fly back to Karachi or Islamabad'
        ]),
  ],
  'Karachi': [
    const _DayPlan(day: 1, title: 'Historic Karachi', icon: '🏙️', activities: [
      'Quaid-e-Azam Mausoleum — Founder\'s resting place',
      'Frere Hall colonial heritage building & library',
      'Clifton Beach & Sea View promenade',
      'Burns Road food street — best nihari & haleem'
    ]),
    const _DayPlan(day: 2, title: 'Beaches & Bazaars', icon: '🌊', activities: [
      'French Beach & Hawkes Bay Sea Turtle Sanctuary',
      'Manora Island boat trip',
      'Port Grand waterfront dining complex',
      'Zainab Market & Tariq Road shopping'
    ]),
    const _DayPlan(
        day: 3,
        title: 'Museums & Culture',
        icon: '🏛️',
        activities: [
          'National Museum of Pakistan',
          'Pakistan Maritime Museum',
          'Empress Market colonial architecture',
          'Boat Basin food street — BBQ & karahi dinner'
        ]),
  ],
  'Peshawar': [
    const _DayPlan(day: 1, title: 'Old Peshawar City', icon: '🕌', activities: [
      'Bala Hisar Fort (Shahi Qila) over the city',
      'Qissa Khawani Bazaar — 2,000-year-old Storytellers\' Market',
      'Mahabat Khan Mosque (Mughal architecture)',
      'Traditional Chapli Kebab dinner at Namak Mandi'
    ]),
    const _DayPlan(
        day: 2,
        title: 'Gandhara Ruins & Khyber Pass',
        icon: '🏛️',
        activities: [
          'Peshawar Museum — finest Gandhara Buddhist art collection',
          'Takht-i-Bahi Buddhist monastery ruins (UNESCO)',
          'Khyber Pass gateway view (permit required)',
          'Bara Bazaar — traditional Pashtun goods & antiques'
        ]),
    const _DayPlan(
        day: 3,
        title: 'Valley & Departure',
        icon: '🏠',
        activities: [
          'Pushkalavati ancient Gandhara ruins at Charsadda',
          'University Town for modern cafes & culture',
          'Last shopping for Peshwari chappal (sandals)',
          'Depart Peshawar'
        ]),
  ],
  'Multan': [
    const _DayPlan(
        day: 1,
        title: 'City of Saints & Shrines',
        icon: '🕌',
        activities: [
          'Shrine of Bahauddin Zakariya (13th-century Sufi saint)',
          'Shrine of Shah Rukn-e-Alam (iconic blue-tiled dome)',
          'Multan Fort Old City walls',
          'Traditional Multani sohan halwa & famous mangoes'
        ]),
    const _DayPlan(day: 2, title: 'Crafts & Culture', icon: '🎨', activities: [
      'Multan Craft Village — famous blue tile pottery workshop',
      'Camel skin lamp & lacquer handicraft shopping',
      'Multan Museum archaeological exhibits',
      'Hussein Agahi historic street market dinner'
    ]),
    const _DayPlan(day: 3, title: 'Departure', icon: '🏠', activities: [
      'Morning: Tomb of Shah Shams Tabriz (13th century)',
      'Mango garden visit (peak season May–July)',
      'Fly or drive to Islamabad/Lahore',
      'Depart Multan — City of Saints'
    ]),
  ],
  'Quetta': [
    const _DayPlan(
        day: 1,
        title: 'Arrival & Quetta City',
        icon: '✈️',
        activities: [
          'Arrive at Quetta Airport',
          'Hanna Lake — serene blue reservoir',
          'Balochistan Museum & archaeological finds',
          'Liaquat Bazaar — best dried fruits & nuts in Pakistan'
        ]),
    const _DayPlan(day: 2, title: 'Ziarat Valley', icon: '🌲', activities: [
      'Drive to Ziarat (130 km) — world\'s 2nd largest juniper forest',
      'Quaid-e-Azam Residency (historic colonial villa)',
      'Apple & cherry orchards of Ziarat Valley',
      'Kach Pass scenic mountain drive'
    ]),
    const _DayPlan(
        day: 3,
        title: 'Urak Valley & Departure',
        icon: '🏠',
        activities: [
          'Urak Valley fruit orchards & spring camping',
          'Spin Karez crystal-clear freshwater pools',
          'Local Balochi Sajji & Kaak bread for brunch',
          'Fly back to Karachi or Islamabad'
        ]),
  ],
  'Neelum Valley': [
    const _DayPlan(
        day: 1,
        title: 'Arrival in Muzaffarabad',
        icon: '✈️',
        activities: [
          'Drive from Islamabad to Muzaffarabad (140 km)',
          'Muzaffarabad Red Fort ruins',
          'Neelum River–Jhelum River confluence viewpoint',
          'AJK traditional dinner'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Sharda & Upper Neelum',
        icon: '🏔️',
        activities: [
          'Drive along scenic Neelum Valley Road gorge',
          'Sharda University ruins (ancient Sanskrit institution)',
          'Keran village — trees overhanging turquoise river',
          'Kel village bridge & river crossing'
        ]),
    const _DayPlan(day: 3, title: 'Arang Kel Meadow', icon: '🌿', activities: [
      'Boat across Neelum River at Kel',
      'Trek to Arang Kel village (1.5 hrs ascent)',
      'Pristine meadow with untouched snow-capped peaks',
      'Overnight camping or return to Kel guesthouse'
    ]),
    const _DayPlan(day: 4, title: 'Departure', icon: '🏠', activities: [
      'Morning: Ratti Gali Lake day hike (seasonal)',
      'Shounter Pass scenic drive viewpoint',
      'Drive back to Muzaffarabad & Islamabad',
      'Depart Neelum Valley'
    ]),
  ],
  'Taxila': [
    const _DayPlan(
        day: 1,
        title: 'Ancient Gandhara Ruins',
        icon: '🏛️',
        activities: [
          'Taxila Museum — largest Gandhara collection in Pakistan',
          'Sirkap archaeological site (Hellenistic city, 2nd c. BC)',
          'Jaulian Buddhist monastery with 117 intricately carved stupas',
          'Easy 45-min drive from Islamabad — ideal day trip'
        ]),
    const _DayPlan(day: 2, title: 'Khanpur & Return', icon: '💧', activities: [
      'Khanpur Dam — water sports & boating',
      'Khanpur Caves exploration',
      'Margalla Pass historic Mughal gateway',
      'Return to Islamabad for dinner'
    ]),
  ],
  'Mohenjo-daro': [
    const _DayPlan(
        day: 1,
        title: 'UNESCO World Heritage Site',
        icon: '🏛️',
        activities: [
          'Fly to Mohenjo-daro Airport or drive from Sukkur',
          'Great Bath — world\'s first ever public bath (2500 BC)',
          'Granary, Assembly Hall & ancient streets exploration',
          'Mohenjo-daro Museum — 4,500-year-old Indus Valley artefacts'
        ]),
    const _DayPlan(
        day: 2,
        title: 'Indus Civilisation & Departure',
        icon: '🏠',
        activities: [
          'Lower Town ruins & private residential quarters',
          'Buddhist Stupa mound (2nd century AD)',
          'Sindhi Ajrak & handicraft shopping in Larkana city',
          'Drive or fly back from Sukkur'
        ]),
  ],
};

List<_DayPlan> _getItinerary(String destination, int duration) {
  final allDays = _itineraryDB[destination] ??
      [
        const _DayPlan(
            day: 1,
            title: 'Arrival & Check-in',
            icon: '✈️',
            activities: [
              'Arrive at destination',
              'Check into hotel',
              'Local area exploration',
              'Welcome dinner'
            ]),
        const _DayPlan(
            day: 2,
            title: 'Main Attractions',
            icon: '🗺️',
            activities: [
              'Visit top landmark',
              'Local museum or fort',
              'Traditional lunch',
              'Souvenir shopping'
            ]),
        const _DayPlan(
            day: 3,
            title: 'Nature & Outdoors',
            icon: '🌿',
            activities: [
              'Morning nature walk',
              'Scenic viewpoint visit',
              'Picnic lunch',
              'Sunset photography'
            ]),
        const _DayPlan(
            day: 4,
            title: 'Culture & Food',
            icon: '🍽️',
            activities: [
              'Local food street tour',
              'Cultural heritage site',
              'Traditional crafts shopping',
              'Farewell dinner'
            ]),
        const _DayPlan(day: 5, title: 'Departure', icon: '🏠', activities: [
          'Morning leisure',
          'Last-minute shopping',
          'Depart to airport',
          'Head home with memories'
        ]),
      ];
  return allDays.take(duration).toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────────────────────────
class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _dotController;
  late AnimationController _entryController;

  // ── Hover state ────────────────────────────────────────────────────────────
  int _hoveredSuggestion = -1;
  int _hoveredStyle = -1;
  int _hoveredDuration = -1;
  int _hoveredBudget = -1;

  // ── Chat state ─────────────────────────────────────────────────────────────
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // ── Plan Trip state ────────────────────────────────────────────────────────
  String? _tripDestination;
  String _tripStyle = 'Adventure';
  int _tripDuration = 5;
  String _tripBudget = 'Mid-range';
  bool _isGenerating = false;
  _TripItinerary? _generatedTrip;

  // ── Saved Trips state ──────────────────────────────────────────────────────
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
    {'label': 'Budget', 'range': 'PKR 5K–15K', 'icon': Icons.savings},
    {
      'label': 'Mid-range',
      'range': 'PKR 15K–40K',
      'icon': Icons.account_balance_wallet
    },
    {'label': 'Luxury', 'range': 'PKR 40K+', 'icon': Icons.diamond},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _messages.add(ChatMessage(
      id: '1',
      message:
          "Hello! 👋 I'm your AI Travel Assistant for Pakistan. How can I help you plan your journey today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dotController.dispose();
    _entryController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - value)),
              child: child,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text('AI Planner',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2))
                      ])),
            ],
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
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

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1 — CHAT
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildChatTab() {
    final showSuggestions = _messages.length == 1 && !_isTyping;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(spacingUnit(2)),
            itemCount: _messages.length + (_isTyping ? 1 : 0) + (showSuggestions ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _messages.length) {
                return _buildMessageBubble(_messages[index]);
              }
              if (_isTyping && index == _messages.length) {
                return _buildTypingIndicator();
              }
              if (showSuggestions) {
                return _buildSuggestions();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
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
                        : colorScheme(context).onSurface,
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
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _dotController,
      builder: (context, _) {
        final double phase = (_dotController.value - index / 3.0 + 1.0) % 1.0;
        final double opacity = phase < 0.5 ? phase * 2 : (1.0 - phase) * 2;
        return Opacity(
          opacity: 0.3 + opacity * 0.7,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                color: colorScheme(context).primary, shape: BoxShape.circle),
          ),
        );
      },
    );
  }

  Widget _buildSuggestions() {
    final suggestions = AIAssistantData.getSuggestions();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: spacingUnit(2),
            right: spacingUnit(2),
            bottom: spacingUnit(1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Try asking:',
                style: ThemeText.caption.copyWith(
                    color:
                        colorScheme(context).onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: suggestions.asMap().entries.map((entry) {
                final i = entry.key;
                final s = entry.value;
                final isHovered = _hoveredSuggestion == i;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _hoveredSuggestion = i),
                  onExit: (_) => setState(() => _hoveredSuggestion = -1),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + i * 80),
                    curve: Curves.easeOut,
                    builder: (context, v, child) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                        offset: Offset(0, 10 * (1 - v)),
                        child: child,
                      ),
                    ),
                    child: AnimatedScale(
                      scale: isHovered ? 1.06 : 1.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      child: ActionChip(
                        avatar: Text(s.icon),
                        label: Text(s.title),
                        backgroundColor: isHovered
                            ? ThemePalette.primaryMain.withValues(alpha: 0.12)
                            : null,
                        side: isHovered
                            ? BorderSide(
                                color: ThemePalette.primaryMain, width: 1.5)
                            : null,
                        elevation: isHovered ? 3 : 0,
                        shadowColor:
                            ThemePalette.primaryMain.withValues(alpha: 0.3),
                        onPressed: () => _sendMessage(s.title),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
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
            _SendButton(
              onPressed: () => _sendMessage(_messageController.text),
              backgroundColor: colorScheme(context).primary,
              iconColor: colorScheme(context).onPrimary,
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

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2 — PLAN TRIP
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildPlanTripTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — animated entry
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF283593)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, v, child) => Transform.scale(
                      scale: v,
                      child: child,
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Color(0xFFD4AF37), size: 32),
                  ),
                  SizedBox(width: spacingUnit(1.5)),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Trip Planner',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3)),
                        SizedBox(height: 3),
                        Text('Get a personalised day-by-day Pakistan itinerary',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Gold accent line
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Center(
                child: Container(
                  width: 40 * value,
                  height: 2,
                  margin: EdgeInsets.only(top: spacingUnit(1.5)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ThemePalette.primaryMain.withValues(alpha: 0.0),
                        ThemePalette.primaryMain.withValues(alpha: 0.7),
                        ThemePalette.primaryMain.withValues(alpha: 0.0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 1 – Destination
          _buildStepLabel('1', 'Choose Destination'),
          SizedBox(height: spacingUnit(1)),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showDestinationSheet(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                    horizontal: spacingUnit(2), vertical: spacingUnit(1.5)),
                decoration: BoxDecoration(
                  color: _tripDestination != null
                      ? ThemePalette.primaryMain.withValues(alpha: 0.06)
                      : colorScheme(context).surfaceContainerHighest,
                  border: Border.all(
                    color: _tripDestination != null
                        ? ThemePalette.primaryMain
                        : colorScheme(context).outline,
                    width: _tripDestination != null ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _tripDestination != null
                          ? ThemePalette.primaryMain
                          : colorScheme(context)
                              .onSurface
                              .withValues(alpha: 0.45),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _tripDestination == null
                          ? Text(
                              'Select a destination in Pakistan',
                              style: TextStyle(
                                color: colorScheme(context)
                                    .onSurface
                                    .withValues(alpha: 0.45),
                                fontSize: 15,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _tripDestination!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                                Text(
                                  _getProvince(_tripDestination!),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme(context)
                                          .onSurface
                                          .withValues(alpha: 0.55)),
                                ),
                              ],
                            ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _tripDestination != null
                          ? ThemePalette.primaryMain
                          : colorScheme(context)
                              .onSurface
                              .withValues(alpha: 0.45),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 2 – Trip Style
          _buildStepLabel('2', 'Travel Style'),
          SizedBox(height: spacingUnit(1)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _styles.asMap().entries.map((entry) {
              final i = entry.key;
              final style = entry.value;
              final isSelected = _tripStyle == style['label'];
              final isHovered = _hoveredStyle == i;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hoveredStyle = i),
                onExit: (_) => setState(() => _hoveredStyle = -1),
                child: AnimatedScale(
                  scale: isHovered && !isSelected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: FilterChip(
                    selected: isSelected,
                    avatar: AnimatedScale(
                      scale: isHovered || isSelected ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(style['icon'] as IconData,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : colorScheme(context).onSurface),
                    ),
                    label: Text(style['label'] as String,
                        style: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal)),
                    selectedColor: ThemePalette.primaryMain,
                    checkmarkColor: Colors.white,
                    backgroundColor: isHovered && !isSelected
                        ? ThemePalette.primaryMain.withValues(alpha: 0.08)
                        : null,
                    elevation: isHovered ? 3 : 0,
                    shadowColor:
                        ThemePalette.primaryMain.withValues(alpha: 0.25),
                    side: isHovered && !isSelected
                        ? BorderSide(
                            color:
                                ThemePalette.primaryMain.withValues(alpha: 0.5))
                        : null,
                    onSelected: (_) => setState(() {
                      _tripStyle = style['label'] as String;
                      _generatedTrip = null;
                    }),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 3 – Duration
          _buildStepLabel('3', 'Trip Duration'),
          SizedBox(height: spacingUnit(1)),
          Row(
            children: _durations.asMap().entries.map((entry) {
              final i = entry.key;
              final d = entry.value;
              final isSelected = _tripDuration == d;
              final isHovered = _hoveredDuration == i;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveredDuration = i),
                    onExit: (_) => setState(() => _hoveredDuration = -1),
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
                              : isHovered
                                  ? ThemePalette.primaryMain
                                      .withValues(alpha: 0.1)
                                  : colorScheme(context)
                                      .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected || isHovered
                                  ? ThemePalette.primaryMain
                                  : colorScheme(context).outline,
                              width: isHovered && !isSelected ? 1.5 : 1),
                          boxShadow: isHovered || isSelected
                              ? [
                                  BoxShadow(
                                    color: ThemePalette.primaryMain
                                        .withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 180),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isHovered && !isSelected ? 20 : 18,
                                  color: isSelected ? Colors.white : null),
                              child: Text('$d'),
                            ),
                            Text('days',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected
                                        ? Colors.white70
                                        : colorScheme(context)
                                            .onSurface
                                            .withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(2.5)),

          // Step 4 – Budget
          _buildStepLabel('4', 'Budget Range'),
          SizedBox(height: spacingUnit(1)),
          Row(
            children: _budgets.asMap().entries.map((entry) {
              final i = entry.key;
              final b = entry.value;
              final isSelected = _tripBudget == b['label'];
              final isHovered = _hoveredBudget == i;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveredBudget = i),
                    onExit: (_) => setState(() => _hoveredBudget = -1),
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
                              : isHovered
                                  ? ThemePalette.primaryMain
                                      .withValues(alpha: 0.08)
                                  : colorScheme(context)
                                      .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected || isHovered
                                  ? ThemePalette.primaryMain
                                  : colorScheme(context).outline,
                              width: isHovered && !isSelected ? 1.5 : 1),
                          boxShadow: isHovered || isSelected
                              ? [
                                  BoxShadow(
                                    color: ThemePalette.primaryMain
                                        .withValues(alpha: 0.22),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: isHovered || isSelected ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(b['icon'] as IconData,
                                  size: 20,
                                  color: isSelected
                                      ? Colors.white
                                      : isHovered
                                          ? ThemePalette.primaryMain
                                          : colorScheme(context).primary),
                            ),
                            const SizedBox(height: 4),
                            Text(b['label'] as String,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : null)),
                            Text(b['range'] as String,
                                style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected
                                        ? Colors.white70
                                        : colorScheme(context)
                                            .onSurface
                                            .withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spacingUnit(3)),

          // Generate Button
          MouseRegion(
            cursor: _tripDestination == null
                ? MouseCursor.defer
                : SystemMouseCursors.click,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - value)),
                  child: child,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _tripDestination == null ? null : _generateTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemePalette.primaryMain,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        colorScheme(context).onSurface.withValues(alpha: 0.12),
                    disabledForegroundColor:
                        colorScheme(context).onSurface.withValues(alpha: 0.38),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                    shadowColor:
                        ThemePalette.primaryMain.withValues(alpha: 0.45),
                  ),
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                      _isGenerating
                          ? 'Generating your plan...'
                          : 'Generate My Trip Plan',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
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
    final delay = (int.tryParse(step) ?? 1) * 100;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(-10 * (1 - value), 0),
          child: child,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
                color: ThemePalette.primaryMain,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ThemePalette.primaryMain.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]),
            child: Center(
                child: Text(step,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))),
          ),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.2)),
        ],
      ),
    );
  }

  void _showDestinationSheet(BuildContext context) {
    final TextEditingController searchCtrl = TextEditingController();
    List<String> filtered = List.from(_destinations);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      Icon(Icons.travel_explore,
                          color: ThemePalette.primaryMain, size: 22),
                      const SizedBox(width: 10),
                      const Text(
                        'Select Destination',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search destinations...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                searchCtrl.clear();
                                setSheetState(() {
                                  filtered = List.from(_destinations);
                                });
                              },
                            ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (q) {
                      setSheetState(() {
                        filtered = _destinations
                            .where((d) =>
                                d.toLowerCase().contains(q.toLowerCase()) ||
                                _getProvince(d)
                                    .toLowerCase()
                                    .contains(q.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                // List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_off,
                                  size: 48,
                                  color: Colors.grey.withValues(alpha: 0.5)),
                              const SizedBox(height: 8),
                              const Text('No destinations found',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 56),
                          itemBuilder: (_, i) {
                            final dest = filtered[i];
                            final province = _getProvince(dest);
                            final isSelected = dest == _tripDestination;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isSelected
                                    ? ThemePalette.primaryMain
                                    : ThemePalette.primaryMain
                                        .withValues(alpha: 0.12),
                                radius: 18,
                                child: Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: isSelected
                                      ? Colors.black
                                      : ThemePalette.primaryMain,
                                ),
                              ),
                              title: Text(
                                dest,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? ThemePalette.primaryMain
                                      : null,
                                ),
                              ),
                              subtitle: Text(province,
                                  style: const TextStyle(fontSize: 12)),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle,
                                      color: ThemePalette.primaryMain, size: 20)
                                  : null,
                              onTap: () {
                                setState(() {
                                  _tripDestination = dest;
                                  _generatedTrip = null;
                                });
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        });
      },
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
                  child: Image.network(
                    trip.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : Container(
                            color: const Color(0xFF1A237E),
                            child: const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFFD4AF37)))),
                    errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1A237E),
                        child: const Center(
                            child: Icon(Icons.landscape,
                                color: Color(0xFFD4AF37), size: 48))),
                  ),
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
        SizedBox(height: spacingUnit(1.5)),

        // Quick-action booking row
        Container(
          padding: EdgeInsets.all(spacingUnit(2)),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF1A237E).withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ready to book?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A237E))),
              SizedBox(height: spacingUnit(1)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to flights tab (tab index 0 on home)
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemePalette.primaryMain,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.flight_takeoff, size: 16),
                      label: const Text('Book Flights',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.hotel, size: 16),
                      label: const Text('Find Hotels',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
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

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3 — SAVED TRIPS
  // ══════════════════════════════════════════════════════════════════════════
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

    return Column(
      children: [
        // Header row with count + Clear All
        Padding(
          padding: EdgeInsets.fromLTRB(
              spacingUnit(2), spacingUnit(1.5), spacingUnit(1.5), 0),
          child: Row(
            children: [
              Text(
                '${_savedTrips.length} saved ${_savedTrips.length == 1 ? 'trip' : 'trips'}',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        colorScheme(context).onSurface.withValues(alpha: 0.55)),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear all saved trips?'),
                      content: const Text(
                          'This will remove all your saved trip plans. This cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _savedTrips.clear());
                            Navigator.pop(ctx);
                          },
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_sweep_outlined, size: 16),
                label: const Text('Clear all', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.withValues(alpha: 0.8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        // Trip list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(spacingUnit(2)),
            itemCount: _savedTrips.length,
            itemBuilder: (context, index) {
              final trip = _savedTrips[index];
              return _buildSavedTripCard(trip, index);
            },
          ),
        ),
      ],
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
                        child: Image.network(
                      trip.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : Container(
                              color: const Color(0xFF1A237E),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFFD4AF37)))),
                      errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF1A237E),
                          child: const Center(
                              child: Icon(Icons.landscape,
                                  color: Color(0xFFD4AF37), size: 40))),
                    )),
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
            Text('${trip.destination} — ${trip.duration} Day Plan',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: spacingUnit(2)),
            ...trip.days.map((day) => _buildDayCard(day)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────
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
      'Chitral':
          'https://images.unsplash.com/photo-1542401886-65d6c61db217?w=800&q=80',
      'Lahore':
          'https://images.unsplash.com/photo-1584204687456-cbed5e3c1e82?w=800&q=80',
      'Islamabad':
          'https://images.unsplash.com/photo-1578895101408-1a36b834405b?w=800&q=80',
      'Peshawar':
          'https://images.unsplash.com/photo-1539136788836-5699e78bfc75?w=800&q=80',
      'Multan':
          'https://images.unsplash.com/photo-1580418827493-f2b22c0a76cb?w=800&q=80',
      'Karachi':
          'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?w=800&q=80',
      'Gwadar':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
      'Quetta':
          'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=800&q=80',
      'Neelum Valley':
          'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&q=80',
      'Taxila':
          'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=800&q=80',
      'Mohenjo-daro':
          'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800&q=80',
    };
    return map[destination] ??
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80';
  }
}
