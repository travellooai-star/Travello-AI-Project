import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/settings/contact_list.dart';
import 'package:flight_app/widgets/settings/message_form.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Help and Support', style: ThemeText.subtitle),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemePalette.primaryMain,
          labelColor: ThemePalette.primaryMain,
          tabAlignment: TabAlignment.center,
          unselectedLabelColor: Colors.grey.shade500,
          isScrollable: true,
          dividerHeight: 0,
          labelPadding: EdgeInsets.symmetric(horizontal: spacingUnit(3)),
          tabs: [
            Tab(child: Text('Message'.toUpperCase(), textAlign: TextAlign.center, style: ThemeText.subtitle)),
            Tab(child: Text('Contact'.toUpperCase(), textAlign: TextAlign.center, style: ThemeText.subtitle)),
          ]
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [
        MessageForm(),
        ContactList()
      ])
    );
  }
}