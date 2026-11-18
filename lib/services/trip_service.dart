import 'package:giachero_gaia_yologo/models/trip.dart';
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
}
