import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/screens/sample_ui/button_collection.dart';
import 'package:flight_app/screens/sample_ui/card_collection.dart';
import 'package:flight_app/screens/sample_ui/color_collection.dart';
import 'package:flight_app/screens/sample_ui/form_input_collection.dart';
import 'package:flight_app/screens/sample_ui/shadow_border_radius.dart';
import 'package:flight_app/screens/sample_ui/typography_collection.dart';
import 'package:flight_app/ui/layouts/general_layout.dart';
import 'package:get/route_manager.dart';

const int pageTransitionDuration = 200;

final List<GetPage> routesUiCollection = [
  GetPage(
    name: AppLink.buttonCollection,
    page: () => const GeneralLayout(content: ButtonCollection()),
  ),
  GetPage(
    name: AppLink.shadowRoundedCollection,
    page: () => const GeneralLayout(content: ShadowBorderRadius()),
  ),
  GetPage(
    name: AppLink.typographyCollection,
    page: () => const GeneralLayout(content: TypographyCollection()),
  ),
  GetPage(
    name: AppLink.colorCollection,
    page: () => const GeneralLayout(content: ColorCollection()),
  ),
  GetPage(
    name: AppLink.formSample,
    page: () => const GeneralLayout(content: FormInputCollection()),
  ),
  GetPage(
    name: AppLink.cardCollection,
    page: () => const GeneralLayout(content: CardCollection()),
  ),
];