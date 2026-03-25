import 'package:change_case/change_case.dart';
import 'package:flight_app/models/promo.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flight_app/widgets/promo/package_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/promo/promo_desc.dart';

class PromoDetail extends StatefulWidget {
  const PromoDetail({
    super.key,
  });

  @override
  State<PromoDetail> createState() => _PromoDetailState();
}

class _PromoDetailState extends State<PromoDetail> {
  final ScrollController _scrollref = ScrollController();

  bool _isFixed = false;

  @override
  void dispose() {
    _scrollref.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Promotion promoItem = promoList[0]; 

    _scrollref.addListener(() {
      setState(() {
        if(_scrollref.offset > 100) {
          _isFixed = true;
        } else {
          _isFixed = false;
        }
      });
    });
  
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        forceMaterialTransparency: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
        centerTitle: false,
        titleSpacing: 0,
        /// TITLE
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: _isFixed ? 1 : 0)),
          child: Text(
            promoItem.name.toCapitalCase(),
            overflow: TextOverflow.ellipsis,
            style: ThemeText.subtitle2,
          ),
        ),
        actions: [
          // POINT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: ThemeRadius.big
            ),
            child: Text('${promoItem.price} POINT', style: ThemeText.paragraph)
          ),
          SizedBox(width: spacingUnit(1)),
          /// LIKED
          Padding(
            padding: EdgeInsets.only(right: spacingUnit(1)),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [ThemeShade.shadeMedium(context)],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_outlined,
                size: 16,
                color: Colors.pink
              )
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ThemeSize.sm),
          child: ListView(
            controller: _scrollref,
            children: [
              /// EVENT BANNER HERO AND DESCRIPTON
              PromoDesc(
                title: promoItem.name.toCapitalCase(),
                desc: promoItem.desc,
                thumb: promoItem.thumb,
                terms1: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                terms2: 'Integer sem massa, interdum commodo leo ac, posuere molestie leo',
                terms3: 'Sed iaculis quis lacus sed malesuada. Nam suscipit lacus',
                date: promoItem.date,
                point: promoItem.price,
                liked: true
              ),
          
              /// PACKAGE LIST OF THIS PROMO
              const LineSpace(),
              const PackageList(),
              const VSpaceBig()
            ]
          ),
        ),
      )
    );
  }
}
