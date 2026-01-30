import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../database/storage.dart';
import '../../routes/routes.dart';
import '../../viewmodels/selected_city_provider.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/city_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../widget/glass_container.dart';

// ================= USER NAME PROVIDER =================
final userNameProvider = FutureProvider<String>((ref) async {
  final name = await SecureStorage.getString();
  return name ?? "User";
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final city = ref.read(selectedCityProvider);
      final lat = city?.lat ?? 28.6139;
      final lon = city?.lon ?? 77.2090;
      await _loadData(lat, lon);
    });
  }

  Future<void> refresh() async {
    final city = ref.read(selectedCityProvider);
    final lat = city?.lat ?? 28.6139;
    final lon = city?.lon ?? 77.2090;
    await _loadData(lat, lon);
  }

  Future<void> _loadData(double lat, double lon) async {
    ref.read(weatherProvider.notifier).load(lat, lon);
    ref.read(cityProvider.notifier).loadCities();
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

  String formatTime() {
    final now = DateTime.now();
    final weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][now.weekday - 1];
    final hour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$weekday, $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final cityState = ref.watch(cityProvider);
    final selectedCity = ref.watch(selectedCityProvider);

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
          child: RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header with city name and menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCity?.name ?? "San Francisco",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            formatTime(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // This will be handled by bottom navigation
                            },
                            icon: const Icon(
                              Icons.bookmark_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // This will be handled by bottom navigation
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Main weather display
                  weatherState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    error: (error, _) => Center(
                      child: Text(
                        "Error loading weather",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                    data: (weatherData) {
                      final current = weatherData['list'][0];
                      final temp =
                          convertTemp(current['main']['temp'].toDouble());
                      final condition = current['weather'][0]['main'];
                      final description = current['weather'][0]['description'];
                      final high =
                          convertTemp(current['main']['temp_max'].toDouble());
                      final low =
                          convertTemp(current['main']['temp_min'].toDouble());

                      return Column(
                        children: [
                          // Weather icon
                          Text(
                            getWeatherIcon(condition),
                            style: const TextStyle(fontSize: 120),
                          ),
                          const SizedBox(height: 20),

                          // Temperature
                          Text(
                            "${temp.round()}°",
                            style: const TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Condition
                          Text(
                            description
                                .split(' ')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' '),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // High/Low and AI message
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "H: ${high.round()}°",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "L: ${low.round()}°",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Text(
                            "AI: Perfect for a light jacket today",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // 5-Day Forecast
                          GlassContainer(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "5-Day Forecast",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Get.toNamed(Routes.weatherDetail),
                                      child: Text(
                                        "DETAILS",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(0.7),
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Forecast days
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(5, (index) {
                                    final dayData =
                                        weatherData['list'][index * 8];
                                    final dayTemp = convertTemp(
                                        dayData['main']['temp'].toDouble());
                                    final dayCondition =
                                        dayData['weather'][0]['main'];
                                    final days = [
                                      'WED',
                                      'THU',
                                      'FRI',
                                      'SAT',
                                      'SUN'
                                    ];

                                    return Column(
                                      children: [
                                        Text(
                                          days[index],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          getWeatherIcon(dayCondition),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${dayTemp.round()}°",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "${(dayTemp - 5).round()}°",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Weather details
                          Row(
                            children: [
                              Expanded(
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.water_drop_outlined,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "HUMIDITY",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${current['main']['humidity']}%",
                                        style: const TextStyle(
                                          fontSize: 24,
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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.air,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "WIND",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${current['wind']['speed'].round()} mph",
                                        style: const TextStyle(
                                          fontSize: 24,
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
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
