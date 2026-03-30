import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/grabber_icon.dart';
import 'package:flight_app/utils/auth_service.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  String _userName = 'User';
  String _userEmail = 'name@mail.com';
  String _userPhone = '+621234567890';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    // Check if in guest mode
    final isGuest = await AuthService.isGuestMode();

    if (isGuest) {
      final guestUser = AuthService.getGuestUser();
      setState(() {
        _userName = guestUser['name'];
        _userEmail = 'guest@example.com';
        _userPhone = 'Not available';
      });
    } else {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        setState(() {
          _userName = user['name'] ?? 'User';
          _userEmail = user['email'] ?? 'name@mail.com';
          _userPhone = user['phone'] ?? '+621234567890';
        });
      } else {
        setState(() {
          _userName = 'Guest User';
          _userEmail = 'guest@example.com';
          _userPhone = 'Not available';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const GrabberIcon(),
      const VSpace(),
      Text('Account Info',
          style: ThemeText.title2.copyWith(fontWeight: FontWeight.bold)),
      const VSpaceShort(),

      /// ACCOUNT INFO
      Padding(
          padding: EdgeInsets.all(spacingUnit(2)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(children: [
              Text('Name',
                  style:
                      ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Flexible(
                  child: Text(_userName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end)),
            ]),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
              child: const LineList(),
            ),
            Row(children: [
              Text('Email',
                  style:
                      ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Flexible(
                  child: Text(_userEmail,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end)),
            ]),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
              child: const LineList(),
            ),
            Row(children: [
              Text('Phone Number/WhatsApp',
                  style:
                      ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Flexible(
                  child: Text(_userPhone,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end)),
            ]),
            const VSpaceBig(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppLink.editProfile);
                  },
                  style: ThemeButton.outlinedPrimary(context),
                  child:
                      const Text('Change Profile', style: ThemeText.subtitle)),
            ),
            const VSpaceShort(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppLink.editPassword);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade300),
                    foregroundColor: Colors.red.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: ThemeRadius.medium,
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.red.shade300),
                        const Text('Change Password',
                            style: ThemeText.subtitle),
                      ])),
            ),
            const VSpaceBig(),
          ])),
    ]);
  }
}
