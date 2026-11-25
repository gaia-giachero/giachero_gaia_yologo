import 'dart:convert';
import 'package:giachero_gaia_yologo/config/api_config.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static const String _accessKey = ApiConfig.unsplashAccessKey;

  static Future<String?> fetchCityImage(String city) async {
    try {
      final uri = Uri.https('api.unsplash.com', '/search/photos', {
        'query': city.trim(),
        'per_page': '1',
        'orientation': 'landscape',
      });

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Client-ID $_accessKey',
          'Accept-Version': 'v1',
        },
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) return null;

      final first = results.first as Map<String, dynamic>;
      final urls = first['urls'] as Map<String, dynamic>?;

      return urls?['regular'] as String?;
    } catch (_) {
      return null;
    }
  }
}