import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_screen.dart';
import '../search/city_search_screen.dart';
import '../settings/settings_screen.dart';

// Provider to manage the current tab index
final currentTabProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);

    // List of screens for each tab (3 tabs only)
    final screens = [
      const HomeScreen(),
      const CitySearchScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildGlassBottomNavBar(context, ref, currentIndex),
    );
  }

  Widget _buildGlassBottomNavBar(BuildContext context, WidgetRef ref, int currentIndex) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      label: "Home",
                      index: 0,
                      currentIndex: currentIndex,
                      onTap: () => ref.read(currentTabProvider.notifier).state = 0,
                    ),
                    _buildNavItem(
                      icon: Icons.search_rounded,
                      label: "Search",
                      index: 1,
                      currentIndex: currentIndex,
                      onTap: () => ref.read(currentTabProvider.notifier).state = 1,
                    ),
                    _buildNavItem(
                      icon: Icons.settings_rounded,
                      label: "Settings",
                      index: 2,
                      currentIndex: currentIndex,
                      onTap: () => ref.read(currentTabProvider.notifier).state = 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isActive = index == currentIndex;
    
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withOpacity(0.25) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isActive ? Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(isActive ? 1.0 : 0.6),
                size: isActive ? 22 : 20,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(isActive ? 1.0 : 0.6),
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}