import 'package:flutter_test/flutter_test.dart';
import 'package:glasscast/data/models/city_model.dart';
import 'package:glasscast/data/models/weather_model.dart';

void main() {
  group('CityModel Tests', () {
    test('CityModel should create from JSON correctly', () {
      final json = {
        'id': '1',
        'city_name': 'New York',
        'lat': 40.7128,
        'lon': -74.0060,
      };

      final city = CityModel.fromJson(json);

      expect(city.id, '1');
      expect(city.name, 'New York');
      expect(city.lat, 40.7128);
      expect(city.lon, -74.0060);
    });

    test('CityModel should handle null id', () {
      final json = {
        'city_name': 'New York',
        'lat': 40.7128,
        'lon': -74.0060,
      };

      final city = CityModel.fromJson(json);

      expect(city.id, null);
      expect(city.name, 'New York');
    });

    test('CityModel should convert to JSON correctly', () {
      final city = CityModel(
        id: '1',
        name: 'New York',
        lat: 40.7128,
        lon: -74.0060,
      );

      final json = city.toJson('user123');

      expect(json['city_name'], 'New York');
      expect(json['lat'], 40.7128);
      expect(json['lon'], -74.0060);
      expect(json['user_id'], 'user123');
    });
  });

  group('WeatherModel Tests', () {
    test('WeatherModel should create from JSON correctly', () {
      final json = {
        'main': {
          'temp': 25.5,
          'temp_min': 20.0,
          'temp_max': 30.0,
        },
        'weather': [
          {'description': 'Sunny'}
        ],
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.temp, 25.5);
      expect(weather.description, 'Sunny');
      expect(weather.minTemp, 20.0);
      expect(weather.maxTemp, 30.0);
    });

    test('WeatherModel constructor works correctly', () {
      final weather = WeatherModel(
        temp: 25.5,
        description: 'Sunny',
        minTemp: 20.0,
        maxTemp: 30.0,
      );

      expect(weather.temp, 25.5);
      expect(weather.description, 'Sunny');
      expect(weather.minTemp, 20.0);
      expect(weather.maxTemp, 30.0);
    });
  });
}
