import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/city_viewmodel.dart';
import '../../viewmodels/search_city_provider.dart';
import '../../viewmodels/selected_city_provider.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../widget/glass_container.dart';

class CitySearchScreen extends ConsumerStatefulWidget {
  const CitySearchScreen({super.key});

  @override
  ConsumerState<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends ConsumerState<CitySearchScreen> {
  final searchCtrl = TextEditingController();

  double convertTemp(double tempC) {
    final unit = ref.watch(settingsProvider);
    return unit == TempUnit.fahrenheit ? (tempC * 9 / 5) + 32 : tempC;
  }

  String unitSymbol() {
    final unit = ref.watch(settingsProvider);
    return unit == TempUnit.fahrenheit ? "°F" : "°C";
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(citySearchProvider);
    final cityState = ref.watch(cityProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF334155),
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
                    const Expanded(
                      child: Text(
                        "Glasscast",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassContainer(
                  width: double.infinity,

                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: searchCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search for a city or airport",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        ref.read(citySearchProvider.notifier).search(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Saved Cities Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SAVED CITIES",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Saved Cities List
                      cityState.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        error: (error, _) => Center(
                          child: Text(
                            "Error loading cities",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        data: (cities) {
                          if (cities.isEmpty) {
                            return Center(
                              child: Text(
                                "No saved cities yet",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: cities.map((city) {
                              // Mock weather data for saved cities
                              final mockTemp = 14 + (city.name.hashCode % 20);
                              final mockCondition = ["Light Rain", "Clear", "Cloudy", "Sunny"][city.name.hashCode % 4];
                              final mockTime = ["10:42 PM", "06:45 AM", "05:42 PM", "11:42 PM"][city.name.hashCode % 4];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GlassContainer(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // City info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF10B981),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  city.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "$mockTime • $mockCondition",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Temperature and delete
                                      Row(
                                        children: [
                                          Text(
                                            "$mockTemp°",
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              // Only delete if the city has a valid ID (meaning it's saved in database)
                                              if (city.id != null && city.id!.isNotEmpty) {
                                                ref.read(cityProvider.notifier).deleteCity(city.id!);
                                              }
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white.withOpacity(0.7),
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Search Results
                      if (searchCtrl.text.isNotEmpty) ...[
                        Text(
                          "SEARCH RESULTS",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        searchState.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                          error: (e, _) => Center(
                            child: Text(
                              "Error searching cities",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          data: (cities) {
                            if (cities.isEmpty) {
                              return Center(
                                child: Text(
                                  "No cities found",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: cities.map((city) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: GlassContainer(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        city.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Lat: ${city.lat.toStringAsFixed(2)}, Lon: ${city.lon.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3B82F6),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onTap: () async {
                                        // Save favorite
                                        await ref.read(cityProvider.notifier).addCity(city);

                                        // Set selected city
                                        ref.read(selectedCityProvider.notifier).state = city;

                                        // Show success message
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("${city.name} added to favorites"),
                                              backgroundColor: const Color(0xFF10B981),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}