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
  int _hoveredIndex = -1;

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
    // Container has padding: spacingUnit(1) = 8px on all sides
    // So inner available width = screenWidth - 16px (left+right padding of parent)
    // ServiceTabs is inside a Positioned with left/right: spacingUnit(2) = 16px each
    // So actual widget width = screenWidth - 32px, inner = screenWidth - 32 - 16 = screenWidth - 48
    // Use LayoutBuilder to get exact available width for accurate indicator positioning
    return LayoutBuilder(
      builder: (context, constraints) {
        final innerWidth = constraints.maxWidth -
            spacingUnit(1) * 2; // subtract container padding
        final tabWidth = innerWidth / 3;
        return _buildTabContent(context, tabWidth);
      },
    );
  }

  Widget _buildTabContent(BuildContext context, double tabWidth) {
    final isSmall = MediaQuery.of(context).size.width < 380;
    final tabHeight = isSmall ? 48.0 : 56.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.05),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated indicator background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _selectedIndex * tabWidth,
            child: Container(
              width: tabWidth,
              height: tabHeight,
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
            children: _services.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;
              final isSelected = service['id'] == widget.selectedService;
              final isHovered = _hoveredIndex == index;
              return Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = -1),
                  child: GestureDetector(
                    onTap: () {
                      _animationController.forward(from: 0);
                      widget.onServiceChanged(service['id']);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: tabHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: (!isSelected && isHovered)
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.transparent,
                        boxShadow: isHovered && !isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isHovered && !isSelected ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              service['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : isHovered
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.white.withValues(alpha: 0.6),
                              size: 22,
                            ),
                          ),
                          SizedBox(height: spacingUnit(0.5)),
                          Text(
                            service['label'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isHovered
                                      ? Colors.white.withValues(alpha: 0.95)
                                      : Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : isHovered
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
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
