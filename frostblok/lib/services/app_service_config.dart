import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frostblok/services/service_config.dart';

class AppConfig implements ServiceConfig {
  @override
  String get openWeatherApiKey => dotenv.env['OPENWEATHER_API_KEY'] as String;
  String get openWeatherBaseUrl => dotenv.env['OPENWEATHER_BASE_URL'] as String;
}
