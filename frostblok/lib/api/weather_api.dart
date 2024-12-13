import 'package:frostblok/utils/api_fetch.dart';
import 'package:frostblok/services/app_service_config.dart';
import 'dart:convert';

class WeatherApi {
  static Future<Map<String, dynamic>> getWeatherForecast(String query, int days) async {
    final String apiKey = AppConfig().weatherApiKey;
    final String baseUrl = AppConfig().weatherApiBaseUrl;
    final String url = '$baseUrl/forecast.json'; // Adjusted for WeatherAPI forecast endpoint
    final queryParams = {
      'q': query, // WeatherAPI uses combined lat/lon query
      'days': days.toString(), // Example: 3-day forecast
      'key': apiKey
    };

    try {
      final response = await ApiFetch.get(url, {}, queryParams, '');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body); // Parse as Map
        return {
          'location': data['location']['name'],
          'country': data['location']['country'],
          'forecast': data['forecast']['forecastday'], // 3-day forecast data
        };
      } else {
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      rethrow;
    }
  }
}
