import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/city_model.dart';
import '../data/repositories/city_repository.dart';
import 'selected_city_provider.dart';

final cityProvider =
    StateNotifierProvider<CityViewModel, AsyncValue<List<CityModel>>>((ref) {
  return CityViewModel(ref);
});

class CityViewModel extends StateNotifier<AsyncValue<List<CityModel>>> {
  CityViewModel(this.ref) : super(const AsyncLoading());

  final Ref ref;
  final repo = CityRepository();

  /// Load cities (with caching)
  Future<void> loadCities({bool forceReload = false}) async {
    try {
      if (state is AsyncData && !forceReload) return;

      state = const AsyncLoading();
      final cities = await repo.getFavorites();
      state = AsyncData(cities);
      final selected = ref.read(selectedCityProvider);
      if (selected == null && cities.isNotEmpty) {
        ref.read(selectedCityProvider.notifier).state = cities.first;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Add city (prevent duplicates, optimistic update)
  Future<void> addCity(CityModel city) async {
    try {
      final current = state.value ?? [];
      final exists = current.any(
        (c) => c.name.toLowerCase() == city.name.toLowerCase(),
      );
      if (exists) return;
      final updated = [...current, city];
      state = AsyncData(updated);
      await repo.addCity(city);
      await loadCities(forceReload: true);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteCity(String id) async {
    try {
      final current = state.value ?? [];

      final updated = current.where((c) => c.id != id).toList();
      state = AsyncData(updated);
      await repo.deleteCity(id);
      await loadCities(forceReload: true);
      final selected = ref.read(selectedCityProvider);
      if (selected != null && selected.id == id) {
        ref.read(selectedCityProvider.notifier).state =
            updated.isNotEmpty ? updated.first : null;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
