import 'package:glasscast/core/constants/api_constants.dart';

import '../../core/config/env.dart';
import '../../core/network/dio_client.dart';
import 'package:dio/dio.dart';

class WeatherRepository {
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    try {
      final apiKey = Env.weatherApiKey;

      print("DEBUG Weather API Key: $apiKey");

      final res = await DioClient.dio.get(
        ApiConstants.forecast,
        queryParameters: {
          "lat": lat,
          "lon": lon,
          "appid": apiKey,
          "units": "metric",
        },
      );

      return res.data;
    } on DioException catch (e) {
      print("Weather API Error: ${e.response?.data}");
      print("Status Code: ${e.response?.statusCode}");
      throw Exception(e.response?.data ?? "Weather API failed");
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    final res = await DioClient.dio.get(
      ApiConstants.currentWeather,
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": Env.weatherApiKey,
        "units": "metric",
      },
    );
    return res.data;
  }

  Future<Map<String, dynamic>> getForecast(double lat, double lon) async {
    final res = await DioClient.dio.get(
      ApiConstants.forecast,
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": Env.weatherApiKey,
        "units": "metric",
      },
    );
    return res.data;
  }

  /// Hourly forecast (next 24 hours)
  Future<Map<String, dynamic>> getHourlyWeather(double lat, double lon) async {
    return await getForecast(lat, lon);
  }

  /// Daily forecast (7 days approximation from forecast API)
  Future<Map<String, dynamic>> getDailyWeather(double lat, double lon) async {
    return await getForecast(lat, lon);
  }
}
