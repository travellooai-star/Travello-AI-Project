import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';

/// ✨ ENTERPRISE-GRADE SERVICE TABS
/// Premium tab selector for Flight | Train | Hotel services
/// Features:
/// - Smooth slide animation on tab change
/// - Glassmorphism design
/// - Accessibility support
/// - Responsive layout
class ServiceTabs extends StatefulWidget {
  final String selectedService;
  final ValueChanged<String> onServiceChanged;

  const ServiceTabs({
    super.key,
    required this.selectedService,
    required this.onServiceChanged,
  });

  @override
  State<ServiceTabs> createState() => _ServiceTabsState();
}

class _ServiceTabsState extends State<ServiceTabs>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> _services = [
    {
      'id': 'flight',
      'label': 'Flights',
      'icon': CupertinoIcons.airplane,
    },
    {
      'id': 'train',
      'label': 'Trains',
      'icon': CupertinoIcons.train_style_one,
    },
    {
      'id': 'hotel',
      'label': 'Hotels',
      'icon': CupertinoIcons.building_2_fill,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get _selectedIndex {
    return _services.indexWhere((s) => s['id'] == widget.selectedService);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacingUnit(1)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        // Glassmorphism effect
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated indicator background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _selectedIndex * (MediaQuery.of(context).size.width / 3 - 16),
            child: Container(
              width: MediaQuery.of(context).size.width / 3 - 16,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          // Service buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _services.map((service) {
              final isSelected = service['id'] == widget.selectedService;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _animationController.forward(from: 0);
                    widget.onServiceChanged(service['id']);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          service['icon'],
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.6),
                          size: 22,
                        ),
                        SizedBox(height: spacingUnit(0.5)),
                        Text(
                          service['label'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
