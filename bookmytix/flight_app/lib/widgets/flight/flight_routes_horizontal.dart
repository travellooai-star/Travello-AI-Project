import 'package:flight_app/models/flight_route.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/flight_route_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightRoutesHorizontal extends StatelessWidget {
  const FlightRoutesHorizontal({
    super.key,
    required this.title,
    required this.routes,
  });

  final String title;
  final List<FlightRoute> routes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VSpaceShort(),
          Text(title, style: ThemeText.subtitle),
          SizedBox(height: spacingUnit(1)),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: routes.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                FlightRoute item = routes[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: FlightRouteCard(
                    airport: item.airport,
                    time: DateFormat.jm().format(item.time),
                    type: item.type,
                  ),
                );
              })
            ),
          ),
        ],
      ),
    );
  }
}