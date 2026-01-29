import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../core/constants/api_constants.dart';
import '../widget/glass_container.dart';

class HourlyForecastCard extends StatelessWidget {
  final Map<String, dynamic> hourly;

  const HourlyForecastCard({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final list = hourly['list'];

    return GlassContainer(
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) {
            final hour = list[index];
            final temp = hour['main']['temp'];
            final icon = hour['weather'][0]['icon'];
            final time = hour['dt_txt'].split(" ")[1].substring(0, 5);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(time),
                  Image.network(
                    ApiConstants.weatherIcon(icon),
                    width: 32,
                  ),
                  Text("${temp.toStringAsFixed(0)}°"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
