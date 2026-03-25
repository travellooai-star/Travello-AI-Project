import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/shimmer_preloader.dart';
import 'package:flight_app/widgets/cards/paper_card.dart';
import 'package:flutter/material.dart';

class AirportCard extends StatelessWidget {
  const AirportCard({
    super.key,
    required this.name,
    required this.code,
    required this.location,
    this.thumb,
  });

  final String name;
  final String code;
  final String location;
  final String? thumb;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      flat: true,
      content: Padding(
        padding: EdgeInsets.all(spacingUnit(1)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TEXT INFO
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name ($code)',
                    style: ThemeText.subtitle2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacingUnit(0.5)),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: colorScheme(context).outlineVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: ThemeText.paragraph,
                      )
                    ],
                  ),
                ],
              ),
            ),
            // THUMB IMAGE
            if (thumb != null)
              SizedBox(
                width: 80,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ClipRRect(
                    borderRadius: ThemeRadius.small,
                    child: Image.network(
                      thumb!,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: ShimmerPreloader(),
                        );
                      },
                    ),
                  ),
                ),
              )
            else
              Container()
          ],
        ),
      ),
    );
  }
}
