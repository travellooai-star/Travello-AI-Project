import 'package:flutter/material.dart';
import 'package:flight_app/models/general_list.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

class WalletList extends StatefulWidget {
  const WalletList({super.key});

  @override
  State<WalletList> createState() => _WalletListState();
}

class _WalletListState extends State<WalletList> {
  final List _banks = <GeneralList>[
    GeneralList(value: 'wallet1', text: 'Wallet A', desc: '\$20', thumb: 'assets/images/logos/logo9.jpg'),
    GeneralList(value: 'wallet2', text: 'Wallet B', thumb: 'assets/images/logos/logo10.jpg'),
    GeneralList(value: 'wallet3', text: 'Wallet C', thumb: 'assets/images/logos/logo11.jpg'),
    GeneralList(value: 'wallet4', text: 'Wallet D', desc: '\$5', thumb: 'assets/images/logos/logo12.png'),
    GeneralList(value: 'wallet5', text: 'Wallet E', thumb: 'assets/images/logos/logo13.png'),
    GeneralList(value: 'wallet6', text: 'Wallet F', desc: '\$12', thumb: 'assets/images/logos/logo14.jpg'),
  ];

  String _selected = '';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _banks.length,
      itemBuilder: ((BuildContext context, int index){
        final GeneralList item = _banks[index];
        return ListTile(
          title: Text(item.text!, style: ThemeText.subtitle2),
          subtitle: Text(item.desc ?? 'Not Connected', style: ThemeText.paragraph),
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(item.thumb),
          ),
          trailing: _selected == item.value ?
            Icon(Icons.check_circle, color: ThemePalette.primaryMain)
            : Icon(Icons.circle_outlined, color: colorScheme(context).outline),
          onTap: () {
            setState(() {
              _selected = item.value;
            });
          }
        );
      }),
    );
  }
}