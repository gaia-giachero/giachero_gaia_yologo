import 'trip_type.dart';

class Trip {
  final String id;
  final String title;
  final String city;
  final String description;
  final int price;
  final DateTime departureDate;
  final DateTime returnDate;
  final TripType type;
  final String? ownerId;
  final DateTime createdAt;
  final String? imageUrl;

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
    this.imageUrl,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    final rawType = (map['trip_type'] as String? ?? '').toLowerCase().trim();

    return Trip(
      id: map['id'].toString(),
      title: map['title'] as String? ?? 'Senza titolo',
      city: map['city'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      departureDate: DateTime.parse(map['start_date'] as String),
      returnDate: DateTime.parse(map['end_date'] as String),
      type: TripType.values.firstWhere(
        (e) => e.name.toLowerCase() == rawType,
        orElse: () => TripType.values.first,
      ),
      ownerId: map['owner_id'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String).toLocal()
          : DateTime.now(),
      imageUrl: map['image_url'] as String?,
    );
  }
}
