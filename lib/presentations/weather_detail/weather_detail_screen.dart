import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/city_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../viewmodels/selected_city_provider.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../widget/glass_container.dart';

class WeatherDetailScreen extends ConsumerStatefulWidget {
  const WeatherDetailScreen({super.key});

  @override
  ConsumerState<WeatherDetailScreen> createState() =>
      _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends ConsumerState<WeatherDetailScreen> {
  final repo = WeatherRepository();
  CityModel? city;

  @override
  void initState() {
    super.initState();
    // Use the selected city from provider
    city = ref.read(selectedCityProvider);

    // If still null, create a default city (San Francisco)
    city ??= CityModel(
      name: "San Francisco",
      lat: 37.7749,
      lon: -122.4194,
    );
  }

  double convertTemp(double tempC) {
    final unit = ref.watch(settingsProvider);
    return unit == TempUnit.fahrenheit ? (tempC * 9 / 5) + 32 : tempC;
  }

  String unitSymbol() {
    final unit = ref.watch(settingsProvider);
    return unit == TempUnit.fahrenheit ? "°F" : "°C";
  }

  String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return '☀️';
      case 'clouds':
      case 'cloudy':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'snow':
        return '❄️';
      case 'thunderstorm':
        return '⛈️';
      default:
        return '☀️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E40AF),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const SizedBox(width: 48), // Balance
                    Expanded(
                      child: Text(
                        city?.name ?? "Weather Details",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance
                  ],
                ),
              ),

              // Weather Content
              Expanded(
                child: FutureBuilder(
                  future: city != null
                      ? repo.getWeather(city!.lat, city!.lon)
                      : null,
                  builder: (context, snapshot) {
                    if (city == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 64,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No city selected",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Error loading weather data",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "No weather data available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      );
                    }

                    final weatherData = snapshot.data!;
                    final current = weatherData['list'][0];
                    final temp =
                        convertTemp(current['main']['temp'].toDouble());
                    final condition = current['weather'][0]['main'];
                    final description = current['weather'][0]['description'];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Current Weather Card
                          GlassContainer(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Text(
                                  getWeatherIcon(condition),
                                  style: const TextStyle(fontSize: 80),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "${temp.round()}${unitSymbol()}",
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description
                                      .split(' ')
                                      .map((word) =>
                                          word[0].toUpperCase() +
                                          word.substring(1))
                                      .join(' '),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Weather Details Grid
                          Row(
                            children: [
                              Expanded(
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.thermostat,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "FEELS LIKE",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${convertTemp(current['main']['feels_like'].toDouble()).round()}${unitSymbol()}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.water_drop_outlined,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "HUMIDITY",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${current['main']['humidity']}%",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.air,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "WIND SPEED",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${current['wind']['speed'].round()} mph",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.compress,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "PRESSURE",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${current['main']['pressure']} hPa",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 24-Hour Forecast
                          GlassContainer(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "24-Hour Forecast",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      final hourData =
                                          weatherData['list'][index];
                                      final hourTemp = convertTemp(
                                          hourData['main']['temp'].toDouble());
                                      final hourCondition =
                                          hourData['weather'][0]['main'];
                                      final hour =
                                          DateTime.fromMillisecondsSinceEpoch(
                                        hourData['dt'] * 1000,
                                      ).hour;

                                      return Container(
                                        width: 60,
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                              hour == 0
                                                  ? "12 AM"
                                                  : hour <= 12
                                                      ? "$hour AM"
                                                      : "${hour - 12} PM",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              getWeatherIcon(hourCondition),
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${hourTemp.round()}°",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
