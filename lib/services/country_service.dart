import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:giachero_gaia_yologo/config/countries_config.dart';
import 'package:giachero_gaia_yologo/models/country_info.dart';
import 'package:http/http.dart' as http;

class CountryService {
  static const Duration _timeout = Duration(seconds: 10);
  static final Map<String, CountryInfo?> _cache = {};

  static Future<CountryInfo?> getCountryInfoForCity(String city) async {
    final cleanCity = city.split(',').first.trim();
    if (cleanCity.isEmpty) return null;

    final cacheKey = cleanCity.toLowerCase();
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    }

    try {
      final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': cleanCity,
        'count': '1',
        'language': 'it',
      });

      final geoRes = await http.get(geoUri).timeout(_timeout);
      if (geoRes.statusCode != 200) {
        debugPrint('Geocoding: status ${geoRes.statusCode}');
        return null;
      }

      final geoData = jsonDecode(geoRes.body) as Map<String, dynamic>;
      final geoResults = geoData['results'] as List<dynamic>?;
      if (geoResults == null || geoResults.isEmpty) {
        debugPrint('Geocoding: nessun risultato per "$cleanCity"');
        _cache[cacheKey] = null;
        return null;
      }

      final first = geoResults.first as Map<String, dynamic>;
      final countryCode = first['country_code'] as String?;
      if (countryCode == null || countryCode.isEmpty) {
        debugPrint('Geocoding: country_code mancante per "$cleanCity"');
        _cache[cacheKey] = null;
        return null;
      }

      final countryUri = Uri.https(
        'api.restcountries.com',
        '/countries/v5/codes.alpha_2/${countryCode.toUpperCase()}',
        {
          'response_fields': 'names.common,names.translations,flag.url_png,currencies,languages',
        },
      );

      final countryRes = await http
          .get(
            countryUri,
            headers: {
              'Authorization':
                  'Bearer ${CountriesConfig.restCountriesAccessKey}',
            },
          )
          .timeout(_timeout);

      if (countryRes.statusCode != 200) {
        debugPrint(
          'REST Countries: status ${countryRes.statusCode} - ${countryRes.body}',
        );
        return null;
      }

      final decoded = jsonDecode(countryRes.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>?;
      final objects = data?['objects'] as List<dynamic>?;
      if (objects == null || objects.isEmpty) {
        debugPrint('REST Countries: nessun paese per "$countryCode"');
        _cache[cacheKey] = null;
        return null;
      }

      final countryMap = objects.first as Map<String, dynamic>;
      final info = CountryInfo.fromJson(countryMap);
      _cache[cacheKey] = info;
      return info;
    } catch (e, stack) {
      debugPrint('Errore CountryService per "$city": $e\n$stack');
      return null;
    }
  }
}
