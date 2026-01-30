import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/city_model.dart';

class CityRepository {
  final _client = Supabase.instance.client;

  Future<List<CityModel>> getFavorites() async {
    final res =
        await _client.from('favorite_cities').select().order('created_at');
    return (res as List).map((e) => CityModel.fromJson(e)).toList();
  }

  Future<void> addCity(CityModel city) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _client.from('favorite_cities').insert({
      'city_name': city.name,
      'lat': city.lat,
      'lon': city.lon,
      'user_id': user.id,
    });
  }

  Future<void> deleteCity(String id) async {
    await _client.from('favorite_cities').delete().eq('id', id);
  }
}
