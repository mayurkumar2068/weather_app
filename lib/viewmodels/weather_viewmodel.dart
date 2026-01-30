import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/weather_repository.dart';

final weatherProvider =
    StateNotifierProvider<WeatherViewModel, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return WeatherViewModel();
});

class WeatherViewModel extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  WeatherViewModel() : super(const AsyncLoading());

  final repo = WeatherRepository();

  Future<void> load(double lat, double lon) async {
    try {
      state = const AsyncLoading();
      final data = await repo.getWeather(lat, lon);
      state = AsyncData(data);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
