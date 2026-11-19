import 'dart:convert';
import 'package:giachero_gaia_yologo/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Weather?> getWeatherForCity(String city) async {
    try {
      // 1. Geocoding: da nome città a coordinate
      final geoUri = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': city,
          'count': '1',
          'language': 'it',
        },
      );

      final geoResponse = await http.get(geoUri);
      if (geoResponse.statusCode != 200) return null;

      final geoData = jsonDecode(geoResponse.body) as Map<String, dynamic>;
      final results = geoData['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return null;

      final first = results.first as Map<String, dynamic>;
      final lat = first['latitude'].toString();
      final lon = first['longitude'].toString();

      // 2. Previsioni attuali con latitudine e longitudine
      final weatherUri = Uri.https(
        'api.open-meteo.com',
        '/v1/forecast',
        {
          'latitude': lat,
          'longitude': lon,
          'current': 'temperature_2m,weather_code',
        },
      );

      final weatherResponse = await http.get(weatherUri);
      if (weatherResponse.statusCode != 200) return null;

      final weatherData = jsonDecode(weatherResponse.body) as Map<String, dynamic>;
      final current = weatherData['current'] as Map<String, dynamic>?;
      if (current == null) return null;

      return Weather.fromOpenMeteo(current);
    } catch (_) {
      return null;
    }
  }
}