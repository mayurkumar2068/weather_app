class CityModel {
  final String? id;
  final String name;
  final double lat;
  final double lon;

  CityModel({
    this.id,
    required this.name,
    required this.lat,
    required this.lon,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString(),
      name: json['city_name'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson(String userId) {
    return {
      'city_name': name,
      'lat': lat,
      'lon': lon,
      'user_id': userId,
    };
  }
}
