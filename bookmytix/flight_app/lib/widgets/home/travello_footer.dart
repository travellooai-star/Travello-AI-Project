import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';

class TravelloFooter extends StatelessWidget {
  const TravelloFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ThemeBreakpoints.smDown(context);
    final isTablet =
        ThemeBreakpoints.mdUp(context) && ThemeBreakpoints.lgDown(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
      ),
      child: Column(
        children: [
          // Main Footer Content
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? spacingUnit(2) : spacingUnit(4),
              vertical: spacingUnit(6),
            ),
            child: Column(
              children: [
                // Footer Columns
                _buildFooterColumns(isMobile, isTablet),

                SizedBox(height: spacingUnit(4)),

                // Social Media Section
                _buildSocialMediaSection(),
              ],
            ),
          ),

          // Copyright Bar
          _buildCopyrightBar(),
        ],
      ),
    );
  }

  Widget _buildFooterColumns(bool isMobile, bool isTablet) {
    if (isMobile) {
      // Mobile: Stack columns vertically
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutColumn(),
          SizedBox(height: spacingUnit(4)),
          _buildServicesColumn(),
          SizedBox(height: spacingUnit(4)),
          _buildSupportColumn(),
          SizedBox(height: spacingUnit(4)),
          _buildAppColumn(),
        ],
      );
    } else if (isTablet) {
      // Tablet: 2x2 grid
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAboutColumn()),
              SizedBox(width: spacingUnit(3)),
              Expanded(child: _buildServicesColumn()),
            ],
          ),
          SizedBox(height: spacingUnit(4)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildSupportColumn()),
              SizedBox(width: spacingUnit(3)),
              Expanded(child: _buildAppColumn()),
            ],
          ),
        ],
      );
    } else {
      // Desktop: 4 columns
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildAboutColumn()),
          SizedBox(width: spacingUnit(4)),
          Expanded(child: _buildServicesColumn()),
          SizedBox(width: spacingUnit(4)),
          Expanded(child: _buildSupportColumn()),
          SizedBox(width: spacingUnit(4)),
          Expanded(child: _buildAppColumn()),
        ],
      );
    }
  }

  // Column 1: About Travello AI
  Widget _buildAboutColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Travello AI',
          style: ThemeText.subtitle2.copyWith(
            color: ThemePalette.primaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: spacingUnit(2)),
        Text(
          'Your intelligent travel companion powered by AI. Book flights, trains, hotels, and access smart travel assistance all in one platform.',
          style: ThemeText.paragraph.copyWith(
            color: Colors.grey.shade700,
            height: 1.6,
          ),
        ),
        SizedBox(height: spacingUnit(2)),
        _buildFooterLink('About Us', () => Get.toNamed(AppLink.aboutUs)),
        _buildFooterLink('Careers', () => Get.toNamed(AppLink.careers)),
        _buildFooterLink('Blog', () => Get.toNamed(AppLink.blog)),
        _buildFooterLink('Contact Us', () => Get.toNamed(AppLink.contact)),
      ],
    );
  }

  // Column 2: Services
  Widget _buildServicesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: ThemeText.subtitle2.copyWith(
            color: ThemePalette.primaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: spacingUnit(2)),
        _buildFooterLink(
            'Flight Booking', () => Get.toNamed(AppLink.flightSearchHome)),
        _buildFooterLink(
            'Train Booking', () => Get.toNamed(AppLink.trainSearchHome)),
        _buildFooterLink(
            'Hotel Booking', () => Get.toNamed(AppLink.hotelSearch)),
        _buildFooterLink(
            'AI Assistant', () => Get.toNamed(AppLink.aiAssistant)),
        _buildFooterLink('Weather Updates', () => Get.toNamed(AppLink.weather)),
        _buildFooterLink(
            'Healthcare Services', () => Get.toNamed(AppLink.healthcare)),
      ],
    );
  }

  // Column 3: Support
  Widget _buildSupportColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support',
          style: ThemeText.subtitle2.copyWith(
            color: ThemePalette.primaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: spacingUnit(2)),
        _buildFooterLink('Help Center', () => Get.toNamed(AppLink.contact)),
        _buildFooterLink('Privacy Policy', () => Get.toNamed(AppLink.privacy)),
        _buildFooterLink('Terms of Service', () => Get.toNamed(AppLink.terms)),
        _buildFooterLink(
            'Cancellation Policy', () => Get.toNamed(AppLink.cancellation)),
        _buildFooterLink('FAQs', () => Get.toNamed(AppLink.faq)),
      ],
    );
  }

  // Column 4: Get the App
  Widget _buildAppColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get the App',
          style: ThemeText.subtitle2.copyWith(
            color: ThemePalette.primaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: spacingUnit(2)),
        Text(
          'Download our app for the best travel experience',
          style: ThemeText.paragraph.copyWith(
            color: Colors.grey.shade700,
            height: 1.6,
          ),
        ),
        SizedBox(height: spacingUnit(2)),

        // App Store Button
        _buildAppBadge(
          'App Store',
          Icons.apple,
          () {},
        ),

        SizedBox(height: spacingUnit(1.5)),

        // Google Play Button
        _buildAppBadge(
          'Google Play',
          Icons.play_arrow_rounded,
          () {},
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      hoverColor: ThemePalette.primaryLight.withOpacity(0.3),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacingUnit(0.75)),
        child: Text(
          text,
          style: ThemeText.paragraph.copyWith(
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBadge(String store, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacingUnit(2),
          vertical: spacingUnit(1.5),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: 24),
            SizedBox(width: spacingUnit(1)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Download on the',
                  style: ThemeText.caption.copyWith(
                    color: Colors.grey.shade700,
                    fontSize: 9,
                  ),
                ),
                Text(
                  store,
                  style: ThemeText.paragraph.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        // Divider
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),

        SizedBox(height: spacingUnit(3)),

        // Social Media Title
        Text(
          'Follow Us',
          style: ThemeText.subtitle2.copyWith(
            color: ThemePalette.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: spacingUnit(2)),

        // Social Media Icons Row
        Wrap(
          spacing: spacingUnit(2),
          children: [
            _buildSocialIcon(
              icon: Icons.facebook,
              label: 'Facebook',
              onTap: () {},
            ),
            _buildSocialIcon(
              icon: Icons.person, // Twitter/X placeholder
              label: 'Twitter',
              onTap: () {},
            ),
            _buildSocialIcon(
              icon: Icons.link, // LinkedIn placeholder
              label: 'LinkedIn',
              onTap: () {},
            ),
            _buildSocialIcon(
              icon: Icons.videocam, // YouTube placeholder
              label: 'YouTube',
              onTap: () {},
            ),
            _buildSocialIcon(
              icon: Icons.camera_alt, // Instagram placeholder
              label: 'Instagram',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: ThemePalette.primaryMain.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: ThemePalette.primaryMain.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: ThemePalette.primaryMain,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCopyrightBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: spacingUnit(2),
        horizontal: spacingUnit(2),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          '© 2026 Travello AI. All rights reserved.',
          style: ThemeText.paragraph.copyWith(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
