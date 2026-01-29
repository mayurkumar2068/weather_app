import 'package:dio/dio.dart';
import 'package:glasscast/core/constants/api_constants.dart';
import '../../core/config/env.dart';
import '../models/city_model.dart';

class CitySearchRepository {
  final Dio dio = Dio();

  Future<List<CityModel>> searchCity(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      ApiConstants.directGeo,
      queryParameters: {
        "q": query,
        "limit": 5,
        "appid": Env.weatherApiKey,
      },
    );

    final data = response.data as List;

    return data.map((e) {
      return CityModel(
        name: e['name'],
        lat: (e['lat'] as num).toDouble(),
        lon: (e['lon'] as num).toDouble(),
      );
    }).toList();
  }
}
