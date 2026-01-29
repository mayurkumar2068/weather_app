import 'package:flutter/material.dart';
import 'package:glasscast/core/constants/api_constants.dart';

import '../widget/glass_container.dart';

class DailyForecastCard extends StatelessWidget {
  final Map<String, dynamic> daily;

  const DailyForecastCard({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final list = daily['list'] as List;
    final daysCount = (list.length / 8).floor();
    final maxDays = daysCount > 7 ? 7 : daysCount;

    return GlassContainer(
      child: Column(
        children: List.generate(maxDays, (index) {
          final safeIndex = index * 8;

          if (safeIndex >= list.length) return const SizedBox();

          final day = list[safeIndex];

          final tempMax = (day['main']['temp_max'] as num).toDouble();
          final tempMin = (day['main']['temp_min'] as num).toDouble();
          final icon = day['weather'][0]['icon'];
          final date = day['dt_txt'].split(" ")[0];

          /// Realistic progress bar logic
          final progress = (tempMax - tempMin) / 20;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                /// Day
                Expanded(
                  flex: 2,
                  child: Text(
                    date.substring(5),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                /// Icon
                Image.network(
                  ApiConstants.weatherIcon(icon),
                  width: 28,
                ),

                const SizedBox(width: 8),

                /// Min Temp
                Text("${tempMin.toStringAsFixed(0)}°"),

                const SizedBox(width: 8),

                /// Progress Bar (iOS style)
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.05, 1.0),
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                      minHeight: 6,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// Max Temp
                Text("${tempMax.toStringAsFixed(0)}°"),
              ],
            ),
          );
        }),
      ),
    );
  }
}
