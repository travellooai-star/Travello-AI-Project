import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

class QuickAccessFeatures extends StatelessWidget {
  const QuickAccessFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? spacingUnit(8) : spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: ThemeText.title.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: spacingUnit(2)),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.wb_sunny_outlined,
                      title: 'Weather',
                      subtitle: 'Forecasts',
                      gradient: const [Color(0xFFD4AF37), Color(0xFFC5A028)],
                      onTap: () => Get.toNamed(AppLink.weather),
                    ),
                  ),
                  SizedBox(width: spacingUnit(2)),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.local_hospital_outlined,
                      title: 'Healthcare',
                      subtitle: 'Emergency',
                      gradient: const [Color(0xFFD4AF37), Color(0xFFC5A028)],
                      onTap: () => Get.toNamed(AppLink.healthcare),
                    ),
                  ),
                  SizedBox(width: spacingUnit(2)),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.psychology_outlined,
                      title: 'AI Assistant',
                      subtitle: 'Smart Help',
                      gradient: const [Color(0xFFD4AF37), Color(0xFFC5A028)],
                      onTap: () => Get.toNamed(AppLink.aiAssistant),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isHovered
                    ? [
                        widget.gradient[0].withValues(alpha: 0.9),
                        widget.gradient[1].withValues(alpha: 0.9),
                      ]
                    : widget.gradient,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.gradient[0]
                      .withValues(alpha: _isHovered ? 0.5 : 0.3),
                  blurRadius: _isHovered ? 12 : 8,
                  offset: Offset(0, _isHovered ? 6 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: spacingUnit(1)),
                Text(
                  widget.title,
                  style: ThemeText.subtitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: ThemeText.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
