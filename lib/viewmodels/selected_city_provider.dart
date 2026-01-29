import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glasscast/data/models/city_model.dart';

final selectedCityProvider = StateProvider<CityModel?>((ref)=>null);
