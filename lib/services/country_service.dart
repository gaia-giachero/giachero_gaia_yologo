import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:giachero_gaia_yologo/models/country_info.dart';
import 'package:http/http.dart' as http;

class CountryService {
  static Future<CountryInfo?> getCountryInfoForCity(String city) async {
    try {
      final cleanCity = city.split(',').first.trim();
      if (cleanCity.isEmpty) return null;

      final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': cleanCity,
        'count': '1',
        'language': 'it',
      });

      final geoRes = await http.get(geoUri);
      if (geoRes.statusCode != 200) return null;

      final geoData = jsonDecode(geoRes.body) as Map<String, dynamic>;
      final geoResults = geoData['results'] as List<dynamic>?;
      if (geoResults == null || geoResults.isEmpty) return null;

      final first = geoResults.first as Map<String, dynamic>;
      final countryCode = first['country_code'] as String?;
      if (countryCode == null || countryCode.isEmpty) return null;

      final countryUri = Uri.https(
        'restcountries.com',
        '/v3.1/alpha/${Uri.encodeComponent(countryCode)}',
        {'fields': 'name,flags,currencies,languages'},
      );

      final countryRes = await http.get(countryUri);
      if (countryRes.statusCode != 200) return null;

      final decoded = jsonDecode(countryRes.body);
      final Map<String, dynamic> countryMap = decoded is List
          ? decoded.first as Map<String, dynamic>
          : decoded as Map<String, dynamic>;

      return CountryInfo.fromJson(countryMap);
    } catch (e, stack) {
      debugPrint('Errore CountryService per "$city": $e\n$stack');
      return null;
    }
  }
}
