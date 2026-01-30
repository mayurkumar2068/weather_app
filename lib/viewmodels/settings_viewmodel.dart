import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TempUnit { celsius, fahrenheit }

final settingsProvider =
    StateNotifierProvider<SettingsViewModel, TempUnit>((ref) {
  return SettingsViewModel();
});

class SettingsViewModel extends StateNotifier<TempUnit> {
  SettingsViewModel() : super(TempUnit.celsius);

  void toggleUnit() {
    state = state == TempUnit.celsius ? TempUnit.fahrenheit : TempUnit.celsius;
  }

  String get unitSymbol => state == TempUnit.celsius ? "°C" : "°F";

  double convertTemp(double tempCelsius) {
    if (state == TempUnit.celsius) return tempCelsius;
    return (tempCelsius * 9 / 5) + 32;
  }
}
