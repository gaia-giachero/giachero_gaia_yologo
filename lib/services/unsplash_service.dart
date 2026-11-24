import 'dart:convert';

import 'package:giachero_gaia_yologo/config/api_config.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:http/http.dart' as http;

class UnsplashService {
  static final Map<String, String> _cache = {};

  static Future<String?> fetchDestinationImage(
    String city, [
    TripType? type,
  ]) async {
    final normalizedCity = city.trim().toLowerCase();
    if (normalizedCity.isEmpty) return null;

    final cacheKey = '${normalizedCity}_${type?.name ?? 'any'}';
    final cachedUrl = _cache[cacheKey];
    if (cachedUrl != null) return cachedUrl;

    try {
      final query = type != null ? '$city ${type.searchKeywords}' : city;

      final uri = Uri.https('api.unsplash.com', '/search/photos', {
        'query': query,
        'per_page': '1',
        'orientation': 'landscape',
      });

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Client-ID ${ApiConfig.unsplashAccessKey}',
          'Accept-Version': 'v1',
        },
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return null;

      final firstPhoto = results.first as Map<String, dynamic>;
      final urls = firstPhoto['urls'] as Map<String, dynamic>?;
      final imageUrl = urls?['regular'] as String?;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        _cache[cacheKey] = imageUrl;
      }

      return urls?['regular'] as String?;
    } catch (_) {
      return null;
    }
  }
}
