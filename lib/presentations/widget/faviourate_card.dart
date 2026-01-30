import 'package:flutter/material.dart';
import '../../data/models/city_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../widget/glass_container.dart';

class FavoriteCityCard extends StatelessWidget {
  final CityModel city;
  final double Function(double) convertTemp;
  final String unitSymbol;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FavoriteCityCard({
    super.key,
    required this.city,
    required this.convertTemp,
    required this.unitSymbol,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: WeatherRepository().getCurrentWeather(city.lat, city.lon),
      builder: (context, snapshot) {
        /// Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GlassContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(city.name, style: const TextStyle(fontSize: 16)),
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            ),
          );
        }

        /// Error State
        if (snapshot.hasError || !snapshot.hasData) {
          return GlassContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(city.name, style: const TextStyle(fontSize: 16)),
                  const Text("N/A"),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final temp = convertTemp((data['main']['temp'] as num).toDouble());
        final maxTemp =
            convertTemp((data['main']['temp_max'] as num).toDouble());
        final minTemp =
            convertTemp((data['main']['temp_min'] as num).toDouble());
        final condition = data['weather'][0]['description'];

        return GlassContainer(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${temp.toStringAsFixed(1)}$unitSymbol",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "H:${maxTemp.toStringAsFixed(0)}°  L:${minTemp.toStringAsFixed(0)}°",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      // 🗑️ Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
