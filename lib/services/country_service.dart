import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:giachero_gaia_yologo/models/country_info.dart';
import 'package:http/http.dart' as http;

class CountryService {
  static const Duration _timeout = Duration(seconds: 10);
  static final Map<String, CountryInfo?> _cache = {};
  static final Map<String, Future<CountryInfo?>> _inFlight = {};

  static Future<CountryInfo?> getCountryInfoForCity(String city) {
    final cleanCity = city.split(',').first.trim();
    if (cleanCity.isEmpty) return Future.value(null);

    final cacheKey = cleanCity.toLowerCase();

    if (_cache.containsKey(cacheKey)) {
      return Future.value(_cache[cacheKey]);
    }

    if (_inFlight.containsKey(cacheKey)) {
      return _inFlight[cacheKey]!;
    }

    final future = _fetchCountryInfo(cleanCity, cacheKey).whenComplete(() {
      _inFlight.remove(cacheKey);
    });

    _inFlight[cacheKey] = future;
    return future;
  }

  static Future<CountryInfo?> _fetchCountryInfo(
    String cleanCity,
    String cacheKey,
  ) async {
    try {
      final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': cleanCity,
        'count': '1',
        'language': 'it',
      });

      final geoRes = await http.get(geoUri).timeout(_timeout);
      if (geoRes.statusCode != 200) return null;

      final geoData = jsonDecode(geoRes.body) as Map<String, dynamic>;
      final geoResults = geoData['results'] as List<dynamic>?;
      if (geoResults == null || geoResults.isEmpty) {
        _cache[cacheKey] = null;
        return null;
      }

      final first = geoResults.first as Map<String, dynamic>;
      final countryCode = first['country_code'] as String?;
      final geoCountryName = first['country'] as String?;
      if (countryCode == null || countryCode.isEmpty) {
        _cache[cacheKey] = null;
        return null;
      }

      final countryUri = Uri.https(
        'www.apicountries.com',
        '/alpha/${countryCode.toUpperCase()}',
      );

      final countryRes = await http.get(countryUri).timeout(_timeout);
      if (countryRes.statusCode == 200) {
        final decoded = jsonDecode(countryRes.body);
        final Map<String, dynamic>? countryMap;
        if (decoded is List && decoded.isNotEmpty) {
          countryMap = Map<String, dynamic>.from(decoded.first as Map);
        } else if (decoded is Map) {
          countryMap = Map<String, dynamic>.from(decoded);
        } else {
          countryMap = null;
        }

        if (countryMap != null) {
          final info = CountryInfo.fromJson(
            countryMap,
            fallbackName: geoCountryName,
            countryCode: countryCode,
          );
          _cache[cacheKey] = info;
          return info;
        }
      }

      if (geoCountryName != null && geoCountryName.isNotEmpty) {
        final fallback = CountryInfo(
          name: geoCountryName,
          flagUrl: 'https://flagcdn.com/w80/${countryCode.toLowerCase()}.png',
          currency: 'Non disponibile',
          language: 'Non disponibile',
        );
        _cache[cacheKey] = fallback;
        return fallback;
      }

      return null;
    } catch (e) {
      debugPrint('Errore CountryService per "$cleanCity": $e');
      return null;
    }
  }
}
