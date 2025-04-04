import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/constants.dart';

class WeatherService {
  String apiKey = Endpoint.apiKey;
  String baseUrl = Endpoint.baseUrl;

  WeatherService();

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$city'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception("City not found. Please enter a valid city.");
      } else if (response.statusCode == 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
            "Something went wrong. Error code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load weather data: $e");
    }
  }
}
