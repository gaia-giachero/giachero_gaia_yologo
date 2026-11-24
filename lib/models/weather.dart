import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';

enum WeatherStatus {
  available,
  tooFarInFuture,
  pastTrip,
  unavailable,
}

class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final IconData icon;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
  });
}

class WeatherResult {
  final WeatherStatus status;
  final List<DailyForecast> forecasts;

  const WeatherResult({
    required this.status,
    this.forecasts = const [],
  });

  String? get statusMessage => switch (status) {
    WeatherStatus.available => null,
    WeatherStatus.tooFarInFuture => AppStrings.tooFarInFuture,
    WeatherStatus.pastTrip => AppStrings.pastTrip,
    WeatherStatus.unavailable => AppStrings.unavailable,
  };

  factory WeatherResult.fromOpenMeteoDaily(Map<String, dynamic> daily) {
    final dates = daily['time'] as List<dynamic>? ?? [];
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final codes = daily['weather_code'] as List<dynamic>? ?? [];

    final count = [
      dates.length,
      maxTemps.length,
      minTemps.length,
      codes.length,
    ].reduce((a, b) => a < b ? a : b);

    final list = <DailyForecast>[];
    for (var i = 0; i < count; i++) {
      final code = (codes[i] as num).toInt();
      final (description, icon) = _mapWeatherCode(code);

      list.add(
        DailyForecast(
          date: DateTime.parse(dates[i] as String),
          minTemp: (minTemps[i] as num).toDouble(),
          maxTemp: (maxTemps[i] as num).toDouble(),
          description: description,
          icon: icon,
        ),
      );
    }

    if (list.isEmpty) {
      return const WeatherResult(status: WeatherStatus.unavailable);
    }

    return WeatherResult(
      status: WeatherStatus.available,
      forecasts: list,
    );
  }

  static (String, IconData) _mapWeatherCode(int code) => switch (code) {
    0 => ('Sereno', Icons.wb_sunny),
    1 || 2 => ('Poco nuvoloso', Icons.wb_cloudy),
    3 => ('Nuvoloso', Icons.cloud),
    45 || 48 => ('Nebbia', Icons.foggy),
    >= 51 && <= 67 => ('Pioggia', Icons.umbrella),
    >= 71 && <= 77 => ('Neve', Icons.ac_unit),
    >= 80 && <= 82 => ('Rovesci', Icons.grain),
    >= 95 => ('Temporale', Icons.thunderstorm),
    _ => ('Variabile', Icons.wb_sunny_outlined),
  };
}