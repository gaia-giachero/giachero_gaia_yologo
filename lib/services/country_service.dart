import 'dart:convert';

import 'package:giachero_gaia_yologo/models/country_info.dart';
import 'package:http/http.dart' as http;

class CountryService {
  static Future<CountryInfo?> getCountryInfoForCity(String city) async {
    try {
      final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': city.trim(),
        'count': '1',
        'language': 'en',
      });

      final geoRes = await http.get(geoUri);
      if (geoRes.statusCode != 200) return null;

      final geoData = jsonDecode(geoRes.body) as Map<String, dynamic>;
      final geoResults = geoData['results'] as List<dynamic>?;
      if (geoResults == null || geoResults.isEmpty) return null;

      final countryName =
          (geoResults.first as Map<String, dynamic>)['country'] as String?;
      if (countryName == null || countryName.isEmpty) return null;

      final countryUri = Uri.https(
        'restcountries.com',
        '/v3.1/name/${Uri.encodeComponent(countryName)}',
        {'fullText': 'true', 'fields': 'name,flags,currencies,languages'},
      );

      final countryRes = await http.get(countryUri);
      if (countryRes.statusCode != 200) return null;

      final list = jsonDecode(countryRes.body) as List<dynamic>;
      if (list.isEmpty) return null;

      return CountryInfo.fromJson(list.first as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
