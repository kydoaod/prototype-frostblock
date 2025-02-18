import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frostblok/services/service_config.dart';

class AppConfig implements ServiceConfig {
  @override
  String get openWeatherApiKey => dotenv.env['OPENWEATHER_API_KEY'] as String;
  @override
  String get openWeatherBaseUrl => dotenv.env['OPENWEATHER_BASE_URL'] as String;
  @override
  String get weatherApiBaseUrl => dotenv.env['WEATHER_API_BASE_URL'] as String;
  @override
  String get weatherApiKey => dotenv.env['WEATHER_API_KEY'] as String;
  @override
  String get tuyaAppKey => dotenv.env['TUYA_SMART_APPKEY'] as String;
  @override
  String get tuyaAppSecret => dotenv.env['TUYA_SMART_SECRET'] as String;
}
