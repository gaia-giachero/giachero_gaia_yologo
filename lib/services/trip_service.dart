import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/trip_filters.dart';
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

    if (filters.types.isNotEmpty) {
      query = query.inFilter(
        'trip_type',
        filters.types.map((type) => type.name).toList(),
      );
    }

    final minPrice = filters.minPrice;
    if (minPrice != null) {
      query = query.gte('price', minPrice);
    }

    final maxPrice = filters.maxPrice;
    if (maxPrice != null) {
      query = query.lte('price', maxPrice);
    }

    final rows = await query.order('created_at', ascending: false);

    return rows.map(Trip.fromMap).toList();
  }
}
