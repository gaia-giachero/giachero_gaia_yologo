import 'trip_type.dart';

class Trip {
  final String id;
  final String title;
  final String city;
  final String description;
  final String price;
  final DateTime departureDate;
  final DateTime returnDate;
  final TripType type;
  final String? ownerId;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.title,
    required this.city,
    required this.description,
    required this.price,
    required this.departureDate,
    required this.returnDate,
    required this.type,
    this.ownerId,
    required this.createdAt,
  });
}