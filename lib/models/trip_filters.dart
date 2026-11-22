import 'package:giachero_gaia_yologo/models/trip_type.dart';

class TripFilters {
  final Set<TripType> types;
  final int? minPrice;
  final int? maxPrice;

  const TripFilters({
    this.types = const {},
    this.minPrice,
    this.maxPrice,
  });

  bool get isActive =>
      types.isNotEmpty || minPrice != null || maxPrice != null;
}