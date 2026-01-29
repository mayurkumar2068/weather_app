class ApiConstants {
  ///OpenWeather Base URLs
  static const String baseUrl = "https://api.openweathermap.org/data/2.5";
  static const String geoBaseUrl = "https://api.openweathermap.org/geo/1.0";

  /// Weather APIs
  static const String currentWeather = "$baseUrl/weather";
  static const String forecast = "$baseUrl/forecast";
  static const String directGeo = "$geoBaseUrl/direct";
  static const String iconBaseUrl = "https://openweathermap.org/img/wn";

  static String weatherIcon(String icon) => "$iconBaseUrl/$icon@2x.png";
  static String weatherIconSmall(String icon) => "$iconBaseUrl/$icon.png";
}
