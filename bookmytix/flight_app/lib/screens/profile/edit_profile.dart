import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileKey = GlobalKey<FormState>();
  bool _isNotValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme(context).surfaceContainerLowest,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new)
        ),
        title: const Text('Edit Profile', style: ThemeText.subtitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(spacingUnit(2)),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ThemeSize.sm
              ),
              child: Form(
                key: _editProfileKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userDummy.avatar),
                      ),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: ThemePalette.primaryMain,
                        child: const Icon(Icons.edit, size: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  const VSpace(),
                  AppTextField(
                    label: 'Name',
                    initialValue: userDummy.name,
                    onChanged: (_) {},
                    validator: FormBuilderValidators.required(),
                    errorText: _isNotValid ? 'Please fill your name' : null,
                  ),
                  const VSpace(),
                  AppTextField(
                    label: 'Phone Number',
                    initialValue: '+621234567890',
                    onChanged: (_) {},
                    validator: FormBuilderValidators.phoneNumber(),
                    errorText: _isNotValid ? 'Please fill the correct phone number' : null,
                  ),
                  const VSpace(),
                  AppTextField(
                    label: 'Email',
                    initialValue: 'john.doe@mymail.com',
                    onChanged: (_) {},
                    validator: FormBuilderValidators.email(),
                    errorText: _isNotValid ? 'Please fill the correct email' : null,
                  ),
                  const VSpace(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        if (_editProfileKey.currentState!.validate()) {
                          Get.toNamed('/profile');
                        } else {
                          setState(() {
                            _isNotValid = true;
                          });
                        }
                      },
                      style: ThemeButton.btnBig.merge(ThemeButton.primary),
                      child: Text('UPDATE'.toUpperCase(), style: ThemeText.subtitle,)
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      )
    );
  }
}