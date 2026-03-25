import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketSettingsPopup extends StatelessWidget {
  const TicketSettingsPopup({super.key, this.whiteIcon = false});

  final bool whiteIcon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz, size: 32, color: whiteIcon ? Colors.white : colorScheme(context).onSurfaceVariant),
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Widget>>[
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: Transform.flip(flipX: true, child: Icon(Icons.reply, color: colorScheme(context).primary)),
            title: const Text('Share'),
          ),
        ),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: Icon(Icons.download, color: colorScheme(context).primary),
            title: const Text('Download'),
          ),
        ),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: Icon(Icons.print, color: colorScheme(context).primary),
            title: const Text('Print'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: Icon(CupertinoIcons.question_circle, color: colorScheme(context).primary),
            title: const Text('Ask for supports'),
          ),
        ),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: Icon(CupertinoIcons.time, color: colorScheme(context).primary),
            title: const Text('Reschedule'),
          ),
        ),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: Icon(CupertinoIcons.arrow_uturn_left, color: colorScheme(context).primary,),
            title: const Text('Request for refund'),
          ),
        ),
      ],
    );
  }
}

class TicketSettingsList extends StatelessWidget {
  const TicketSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
        child: const TitleBasic(title: 'Other Options', size: 'small',),
      ),
      SizedBox(height: spacingUnit(2)),
      GestureDetector(
        onTap: () {},
        child: Row(children: [
          SizedBox(width: spacingUnit(2)),
          Icon(CupertinoIcons.question_circle, color: colorScheme(context).primary),
          const SizedBox(width: 4),
          Text('Ask for support', style: ThemeText.paragraph.copyWith(color: colorScheme(context).primary, fontWeight: FontWeight.w500),)
        ]),
      ),
      const VSpaceShort(),
      GestureDetector(
        onTap: () {},
        child: Row(children: [
          SizedBox(width: spacingUnit(2)),
          Icon(CupertinoIcons.time, color: colorScheme(context).primary),
          const SizedBox(width: 4),
          Text('Reschedule', style: ThemeText.paragraph.copyWith(color: colorScheme(context).primary, fontWeight: FontWeight.w500),)
        ]),
      ),
      const VSpaceShort(),
      GestureDetector(
        onTap: () {},
        child: Row(children: [
          SizedBox(width: spacingUnit(2)),
          Icon(CupertinoIcons.arrow_uturn_left, color: colorScheme(context).primary),
          const SizedBox(width: 4),
          Text('Request for refund', style: ThemeText.paragraph.copyWith(color: colorScheme(context).primary, fontWeight: FontWeight.w500),)
        ]),
      ),
    ]);
  }
}

class TicketSettingsBottomSheet extends StatelessWidget {
  const TicketSettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          leading: Transform.flip(flipX: true, child: Icon(Icons.reply, color: ThemePalette.primaryMain)),
          title: const Text('Share'),
        ),
        ListTile(
          leading: Icon(Icons.download, color: ThemePalette.primaryMain),
          title: const Text('Download'),
        ),
        ListTile(
          leading: Icon(Icons.print, color: ThemePalette.primaryMain),
          title: const Text('Print'),
        ),
        const Divider(),
        ListTile(
          leading: Icon(CupertinoIcons.question_circle, color: ThemePalette.primaryMain),
          title: const Text('Ask for supports'),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.time, color: ThemePalette.primaryMain),
          title: const Text('Reschedule'),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.arrow_uturn_left, color: ThemePalette.primaryMain),
          title: const Text('Request for refund'),
        ),
        const VSpace()
      ],
    );
  }
}