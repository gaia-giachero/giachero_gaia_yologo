import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  const TripDetailScreen({
    required this.trip,
    required this.isFavorite,
    required this.onToggleFavorite,
    super.key,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            ),
            Text(AppStrings.backButton),
          ],
        ),
      ),
    );
  }
}
