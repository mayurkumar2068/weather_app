import 'package:get/get.dart';
import 'package:glasscast/presentations/search/city_search_screen.dart';
import 'package:glasscast/presentations/settings/settings_screen.dart';
import 'package:glasscast/routes/routes.dart';
import '../presentations/auth/login_screen.dart';
import '../presentations/auth/signup_screen.dart';
import '../presentations/main_navigation/main_navigation_screen.dart';
import '../presentations/weather_detail/weather_detail_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const MainNavigationScreen(),
    ),
    GetPage(name: Routes.settings, page: () => const SettingsScreen()),
    GetPage(
      name: Routes.searchCity,
      page: () => const CitySearchScreen(),
    ),
    GetPage(
        name: Routes.weatherDetail, page: () => const WeatherDetailScreen()),
  ];
}
