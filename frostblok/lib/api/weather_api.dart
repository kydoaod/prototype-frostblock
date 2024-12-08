import 'package:frostblok/utils/api_fetch.dart';
import 'package:frostblok/services/app_service_config.dart';
import 'dart:convert';

class WeatherApi {
  // Get geocode (latitude and longitude) from city name
  static Future<Map<String, dynamic>> getGeocodeData(String city) async {
    final String apiKey = AppConfig().openWeatherApiKey;
    final String baseUrl = AppConfig().openWeatherBaseUrl;
    final String url = '$baseUrl/geo/1.0/direct'; // Base URL + endpoint
    final queryParams = {'q': city, 'appid': apiKey};

    try {
      final response = await ApiFetch.get(url, {}, queryParams, '');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // Parse as List
        if (data.isNotEmpty) {
          // Return first match's latitude and longitude
          return {
            'lat': data[0]['lat'],
            'lon': data[0]['lon'],
          };
        } else {
          throw Exception('No matching geocode found for the city');
        }
      } else {
        throw Exception('Failed to load geocode data');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get weather forecast using latitude and longitude
  static Future<Map<String, dynamic>> getWeatherForecast(double lat, double lon) async {
    final String apiKey = AppConfig().openWeatherApiKey;
    final String baseUrl = AppConfig().openWeatherBaseUrl;
    final String url = '$baseUrl/data/2.5/forecast'; // Base URL + endpoint
    final queryParams = {'lat': lat.toString(), 'lon': lon.toString(), 'cnt': '3', 'appid': apiKey};

    try {
      final response = await ApiFetch.get(url, {}, queryParams, '');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body); // Parse as Map
        final List<dynamic> forecastList = data['list']; // Access the 'list' key
        if (forecastList.isNotEmpty) {
          return {
            'city': data['city']['name'],
            'country': data['city']['country'],
            'forecast': forecastList,  // You can also filter or process this list if needed
          };
        } else {
          throw Exception('No weather forecast data available');
        }
      } else {
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      rethrow;
    }
  }
}
