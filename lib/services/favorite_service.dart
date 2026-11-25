import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteService {
  static Future<List<Trip>> fetchFavoriteTrips(String userId) async {
    final client = Supabase.instance.client;

    final List rows = await client
        .from('favorites')
        .select('trips(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return rows
        .map((row) => row['trips'])
        .whereType<Map<String, dynamic>>()
        .map(Trip.fromMap)
        .toList();
  }

  static Future<void> addFavorite({
    required String userId,
    required String tripId,
  }) async {
    final client = Supabase.instance.client;

    await client.from('favorites').upsert({
      'user_id': userId,
      'trip_id': tripId,
    }, onConflict: 'user_id,trip_id');
  }

  static Future<void> removeFavorite({
    required String userId,
    required String tripId,
  }) async {
    final client = Supabase.instance.client;

    await client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('trip_id', tripId);
  }
}
