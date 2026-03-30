import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';

/// ✨ ENTERPRISE-GRADE DYNAMIC HERO SECTION
/// Premium hero component with:
/// - Dynamic background images
/// - Smooth crossfade transitions
/// - Dark gradient overlay (60% opacity)
/// - Responsive typography
/// - High contrast accessibility
class HeroSection extends StatelessWidget {
  final String serviceType;
  final VoidCallback? onCtaTap;

  const HeroSection({
    super.key,
    required this.serviceType,
    this.onCtaTap,
  });

  /// Hero content configuration per service
  Map<String, dynamic> get _heroContent {
    switch (serviceType) {
      case 'train':
        return {
          'image': 'assets/images/railway_banner.jpg',
          'title': 'Travel by Train Comfortably',
          'subtitle': 'Reserve your train seat across Pakistan',
          'cta': 'Book Your Train',
          'gradient': [
            const Color(0xFF1A472A).withValues(alpha: 0.75),
            const Color(0xFF2D5F3D).withValues(alpha: 0.50),
          ],
        };
      case 'hotel':
        return {
          'image': 'assets/images/search_banner.jpg',
          'title': 'Find Your Perfect Stay',
          'subtitle': 'Discover hotels at best nightly rates',
          'cta': 'Book Your Stay',
          'gradient': [
            const Color(0xFF6B4423).withValues(alpha: 0.75),
            const Color(0xFF8B5A3C).withValues(alpha: 0.50),
          ],
        };
      case 'flight':
      default:
        return {
          'image': 'assets/images/home_banner.jpg',
          'title': 'Where do you want to fly?',
          'subtitle': 'Book domestic flights across Pakistan',
          'cta': 'Book Your Flight',
          'gradient': [
            const Color(0xFF1E3A8A).withValues(alpha: 0.75),
            const Color(0xFF3B82F6).withValues(alpha: 0.50),
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _heroContent;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey(serviceType),
        height: screenHeight * (isMobile ? 0.50 : 0.55),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(content['image']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.35),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: content['gradient'],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(isMobile ? 2 : 3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main headline
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      content['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 26 : 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: spacingUnit(2)),

                  // Subtitle
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      content['subtitle'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.5,
                        letterSpacing: 0.3,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: spacingUnit(isMobile ? 2 : 4)),

                  // Premium CTA Button
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.9 + (0.1 * value),
                          child: child,
                        ),
                      );
                    },
                    child: _buildPremiumCTA(content['cta'], isMobile),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCTA(String label, bool isMobile) {
    return _HoverScaleButton(
      onTap: onCtaTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacingUnit(isMobile ? 3 : 5),
          vertical: spacingUnit(isMobile ? 1.5 : 2),
        ),
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
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 15 : 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: spacingUnit(1.5)),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium hover/press scale animation wrapper
class _HoverScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _HoverScaleButton({
    required this.child,
    this.onTap,
  });

  @override
  State<_HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<_HoverScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
