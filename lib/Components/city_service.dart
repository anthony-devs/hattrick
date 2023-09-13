import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  static const apiKey = '2f9b5943b1c2c794ec5b0bc02df9e996';
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<List<String>> getCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/onecall/countries?appid=$apiKey'));

    if (response.statusCode == 200) {
      final countriesData = json.decode(response.body) as List;
      return countriesData.map((country) => country['country']).cast<String>().toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  static Future<List<String>> getCitiesByCountry(String country) async {
    final response = await http.get(Uri.parse('$baseUrl/onecall?country=$country&appid=$apiKey'));

    if (response.statusCode == 200) {
      final citiesData = json.decode(response.body) as List;
      return citiesData.map((city) => city['name']).cast<String>().toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
