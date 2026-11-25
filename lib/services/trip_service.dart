import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/trip_filters.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/services/image_service.dart';
import 'package:giachero_gaia_yologo/utils/date_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripService {
  static Future<List<Trip>> fetchTripsByOwner(String ownerId) async {
    final client = Supabase.instance.client;

    final rows = await client
        .from('trips')
        .select()
        .eq('owner_id', ownerId)
        .order('created_at', ascending: false);

    return rows.map(Trip.fromMap).toList();
  }

  static Future<List<Trip>> fetchSystemTrips() async {
    final client = Supabase.instance.client;

    final rows = await client
        .from('trips')
        .select()
        .isFilter('owner_id', null)
        .order('created_at', ascending: false);

    return rows.map(Trip.fromMap).toList();
  }

  static Future<List<Trip>> searchTrips({
    required String text,
    required TripFilters filters,
    required String excludeOwnerId,
  }) async {
    final client = Supabase.instance.client;

    var query = client
        .from('trips')
        .select()
        .gte('start_date', DateFormatter.formatForDatabase(DateTime.now()));

    query = query.or('owner_id.is.null,owner_id.neq.$excludeOwnerId');

    final cleanText = text.replaceAll(RegExp(r'[,()%*]'), ' ').trim();
    if (cleanText.isNotEmpty) {
      query = query.or('city.ilike.*$cleanText*,title.ilike.*$cleanText*');
    }

    final type = filters.type;
    if (type != null) {
      query = query.eq('trip_type', type.name);
    }

    final maxPrice = filters.maxPrice;
    if (maxPrice != null) {
      query = query.lte('price', maxPrice);
    }

    final rows = await query.order('created_at', ascending: false);

    return rows.map(Trip.fromMap).toList();
  }

  static const int maxPopularDestination = 6;
  static Future<List<String>> fetchPopularDestinations() async {
    final response = await Supabase.instance.client
        .from('popular_destinations')
        .select('city')
        .limit(maxPopularDestination);

    return (response as List).map((row) => row['city'] as String).toList();
  }

  static Future<void> createTrip({
    required String ownerId,
    required String title,
    required String city,
    required DateTime startDate,
    required DateTime endDate,
    required int price,
    required TripType type,
    required String description,
  }) async {
    final client = Supabase.instance.client;
    final imageUrl = await ImageService.fetchCityImage(city);

    await client.from('trips').insert({
      'owner_id': ownerId,
      'title': title.trim(),
      'city': city.trim(),
      'start_date': DateFormatter.formatForDatabase(startDate),
      'end_date': DateFormatter.formatForDatabase(endDate),
      'price': price,
      'trip_type': type.name,
      'description': description.trim(),
      'image_url': imageUrl,
    });
  }
}
