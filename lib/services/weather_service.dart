import 'dart:convert';

import 'package:giachero_gaia_yologo/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const int _maxForecastDays = 16;
  static const Duration _timeout = Duration(seconds: 10);

  static Future<WeatherResult> getWeatherForTrip({
    required String city,
    required DateTime departureDate,
    required DateTime returnDate,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(
      departureDate.year,
      departureDate.month,
      departureDate.day,
    );
    final end = DateTime(returnDate.year, returnDate.month, returnDate.day);

    if (end.isBefore(today)) {
      return const WeatherResult(status: WeatherStatus.pastTrip);
    }

    final maxAllowedDate = today.add(const Duration(days: _maxForecastDays));
    if (start.isAfter(maxAllowedDate) || end.isAfter(maxAllowedDate)) {
      return const WeatherResult(status: WeatherStatus.tooFarInFuture);
    }

    final effectiveStart = start.isBefore(today) ? today : start;

    try {
      final cleanCity = city.split(',').first.trim();
      final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': cleanCity,
        'count': '1',
        'language': 'it',
      });

      final geoResponse = await http.get(geoUri).timeout(_timeout);
      if (geoResponse.statusCode != 200) {
        return const WeatherResult(status: WeatherStatus.unavailable);
      }

      final geoData = jsonDecode(geoResponse.body) as Map<String, dynamic>;
      final results = geoData['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        return const WeatherResult(status: WeatherStatus.unavailable);
      }

      final first = results.first as Map<String, dynamic>;
      final lat = first['latitude'].toString();
      final lon = first['longitude'].toString();

      final weatherUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': lat,
        'longitude': lon,
        'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
        'timezone': 'auto',
        'start_date': _formatApiDate(effectiveStart),
        'end_date': _formatApiDate(end),
      });

      final weatherResponse = await http.get(weatherUri).timeout(_timeout);
      if (weatherResponse.statusCode != 200) {
        return const WeatherResult(status: WeatherStatus.unavailable);
      }

      final weatherData =
          jsonDecode(weatherResponse.body) as Map<String, dynamic>;
      final daily = weatherData['daily'] as Map<String, dynamic>?;
      if (daily == null) {
        return const WeatherResult(status: WeatherStatus.unavailable);
      }

      return WeatherResult.fromOpenMeteoDaily(daily);
    } catch (_) {
      return const WeatherResult(status: WeatherStatus.unavailable);
    }
  }

  static String _formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
