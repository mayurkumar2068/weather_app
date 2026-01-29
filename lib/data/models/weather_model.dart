class WeatherModel {
  final double temp;
  final String description;
  final double minTemp;
  final double maxTemp;

  WeatherModel({
    required this.temp,
    required this.description,
    required this.minTemp,
    required this.maxTemp
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: (json['main']['temp'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'],
    );
  }

}