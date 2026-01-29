import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/routes.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../viewmodels/app_settings_provider.dart';
import '../../utils/app_utils.dart';
import '../widget/glass_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(settingsProvider);
    final appSettings = ref.watch(appSettingsProvider);

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
                        "Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
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

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preferences Section
                      Text(
                        "PREFERENCES",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Temperature Unit Toggle
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.thermostat,
                              color: Colors.white.withOpacity(0.7),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Temperature Unit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    unit == TempUnit.celsius ? "Celsius" : "Fahrenheit",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: unit == TempUnit.fahrenheit,
                              onChanged: (_) {
                                ref.read(settingsProvider.notifier).toggleUnit();
                              },
                              activeColor: const Color(0xFF3B82F6),
                              activeTrackColor: const Color(0xFF3B82F6).withOpacity(0.3),
                              inactiveThumbColor: Colors.white.withOpacity(0.7),
                              inactiveTrackColor: Colors.white.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Smart Notifications
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Smart Notifications",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Weather alerts and updates",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: appSettings.notificationsEnabled,
                              onChanged: (value) {
                                ref.read(appSettingsProvider.notifier).toggleNotifications();
                              },
                              activeColor: const Color(0xFF3B82F6),
                              activeTrackColor: const Color(0xFF3B82F6).withOpacity(0.3),
                              inactiveThumbColor: Colors.white.withOpacity(0.7),
                              inactiveTrackColor: Colors.white.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // AI Forecast Summary
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.psychology_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "AI Forecast Summary",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Personalized weather insights",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: appSettings.aiSummaryEnabled,
                              onChanged: (value) {
                                ref.read(appSettingsProvider.notifier).toggleAiSummary();
                              },
                              activeColor: const Color(0xFF3B82F6),
                              activeTrackColor: const Color(0xFF3B82F6).withOpacity(0.3),
                              inactiveThumbColor: Colors.white.withOpacity(0.7),
                              inactiveTrackColor: Colors.white.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Account Section
                      Text(
                        "ACCOUNT",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Profile
                      GestureDetector(
                        onTap: () {
                          AppUtils.showEditProfileDialog(
                            context,
                            appSettings.userName,
                            appSettings.userEmail,
                            (name, email) {
                              if (name.isNotEmpty) {
                                ref.read(appSettingsProvider.notifier).updateUserName(name);
                              }
                              if (email.isNotEmpty) {
                                ref.read(appSettingsProvider.notifier).updateUserEmail(email);
                              }
                            },
                          );
                        },
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Center(
                                  child: Text(
                                    appSettings.userName.isNotEmpty 
                                        ? appSettings.userName.substring(0, 1).toUpperCase()
                                        : "U",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appSettings.userName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      appSettings.userEmail,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "ACTIVE",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Glasscast Pro
                      GestureDetector(
                        onTap: () {
                          ref.read(appSettingsProvider.notifier).togglePro();
                        },
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "Glasscast Pro",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: appSettings.isPro ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  appSettings.isPro ? "ACTIVE" : "UPGRADE",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Support Section
                      Text(
                        "SUPPORT",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rate the App
                      GestureDetector(
                        onTap: () => AppUtils.rateApp(context),
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "Rate the App",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Share App
                      GestureDetector(
                        onTap: () => AppUtils.shareApp(context),
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.share_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "Share App",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Contact Support
                      GestureDetector(
                        onTap: () => AppUtils.showContactSupport(context),
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.support_agent_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "Contact Support",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Privacy Policy
                      GestureDetector(
                        onTap: () => AppUtils.openPrivacyPolicy(context),
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // About
                      GestureDetector(
                        onTap: () => AppUtils.showAboutDialog(context),
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Sign Out Button
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () async {
                            await Supabase.instance.client.auth.signOut();
                            Get.offAllNamed(Routes.login);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red.withOpacity(0.8),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
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
