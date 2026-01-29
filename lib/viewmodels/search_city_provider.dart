import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glasscast/data/repositories/city_search_repository.dart';
import '../data/models/city_model.dart';

final citySearchProvider =
StateNotifierProvider<CitySearchViewModel, AsyncValue<List<CityModel>>>((ref) {
  return CitySearchViewModel();
});

class CitySearchViewModel extends StateNotifier<AsyncValue<List<CityModel>>> {
  CitySearchViewModel() : super(const AsyncData([]));

  final repo = CitySearchRepository();

  Future<void> search(String query) async {
    try {
      if (query.isEmpty) {
        state = const AsyncData([]);
        return;
      }

      state = const AsyncLoading();
      final result = await repo.searchCity(query);
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
