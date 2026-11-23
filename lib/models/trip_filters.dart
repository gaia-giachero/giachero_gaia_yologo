import 'package:giachero_gaia_yologo/models/trip_type.dart';

class TripFilters {
  final TripType? type;
  final int? maxPrice;

  const TripFilters({this.type, this.maxPrice});

  bool get isActive => type != null || maxPrice != null;
}