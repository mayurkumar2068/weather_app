import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../widget/glass_container.dart';

class HeaderWeatherCard extends StatelessWidget {
  final Map<String, dynamic> current;

  const HeaderWeatherCard({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final temp = current['main']['temp'];
    final max = current['main']['temp_max'];
    final min = current['main']['temp_min'];
    final condition = current['weather'][0]['description'];

    return GlassContainer(
      child: Column(
        children: [
          Text("${temp.toStringAsFixed(1)}°",
              style:
                  const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
          Text(condition, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text("H: ${max.toStringAsFixed(0)}°  L: ${min.toStringAsFixed(0)}°"),
        ],
      ),
    );
  }
}
