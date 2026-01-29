import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Settings state class
class AppSettings {
  final bool notificationsEnabled;
  final bool aiSummaryEnabled;
  final String userName;
  final String userEmail;
  final bool isPro;

  AppSettings({
    this.notificationsEnabled = true,
    this.aiSummaryEnabled = true,
    this.userName = "User",
    this.userEmail = "user@glasscast.app",
    this.isPro = false,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? aiSummaryEnabled,
    String? userName,
    String? userEmail,
    bool? isPro,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      aiSummaryEnabled: aiSummaryEnabled ?? this.aiSummaryEnabled,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isPro: isPro ?? this.isPro,
    );
  }
}

// Settings provider
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  static const _storage = FlutterSecureStorage();

  Future<void> _loadSettings() async {
    try {
      final notifications = await _storage.read(key: 'notifications_enabled');
      final aiSummary = await _storage.read(key: 'ai_summary_enabled');
      final userName = await _storage.read(key: 'user_name');
      final userEmail = await _storage.read(key: 'user_email');
      final isPro = await _storage.read(key: 'is_pro');

      state = AppSettings(
        notificationsEnabled: notifications == 'true',
        aiSummaryEnabled: aiSummary == 'true',
        userName: userName ?? "User",
        userEmail: userEmail ?? "user@glasscast.app",
        isPro: isPro == 'true',
      );
    } catch (e) {
      // Handle error, keep default state
    }
  }

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    await _storage.write(key: 'notifications_enabled', value: newValue.toString());
    state = state.copyWith(notificationsEnabled: newValue);
  }

  Future<void> toggleAiSummary() async {
    final newValue = !state.aiSummaryEnabled;
    await _storage.write(key: 'ai_summary_enabled', value: newValue.toString());
    state = state.copyWith(aiSummaryEnabled: newValue);
  }

  Future<void> updateUserName(String name) async {
    await _storage.write(key: 'user_name', value: name);
    state = state.copyWith(userName: name);
  }

  Future<void> updateUserEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
    state = state.copyWith(userEmail: email);
  }

  Future<void> togglePro() async {
    final newValue = !state.isPro;
    await _storage.write(key: 'is_pro', value: newValue.toString());
    state = state.copyWith(isPro: newValue);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});