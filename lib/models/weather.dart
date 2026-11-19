import 'package:flutter/material.dart';

class Weather {
  final double temperature;
  final String description;
  final IconData icon;

  const Weather({
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Weather.fromOpenMeteo(Map<String, dynamic> current) {
    final temp = (current['temperature_2m'] as num).toDouble();
    final code = current['weather_code'] as int;

    final (description, icon) = switch (code) {
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

    return Weather(temperature: temp, description: description, icon: icon);
  }
}
