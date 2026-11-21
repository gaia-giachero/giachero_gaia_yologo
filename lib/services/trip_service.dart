import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
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
    required Set<TripType> types,
  }) async {
    final client = Supabase.instance.client;

    var query = client
        .from('trips')
        .select()
        .gte('start_date', DateFormatter.formatForDatabase(DateTime.now()));

    final cleanText = text.replaceAll(RegExp(r'[,()%*]'), ' ').trim();
    if (cleanText.isNotEmpty) {
      query = query.or('city.ilike.*$cleanText*,title.ilike.*$cleanText*');
    }

    if (types.isNotEmpty) {
      query = query.inFilter(
        'trip_type',
        types.map((type) => type.name).toList(),
      );
    }

    final rows = await query.order('created_at', ascending: false);

    return rows.map(Trip.fromMap).toList();
  }
}
