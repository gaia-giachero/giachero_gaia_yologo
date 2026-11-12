import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/date_formatter.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/utils/price_formatter.dart';

import '../models/trip.dart';
import './trip_image.dart';

enum TripCardVariant { horizontal, vertical }

class TripCard extends StatelessWidget {
  final Trip trip;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onEditTap;
  final TripCardVariant variant;

  const TripCard({
    required this.trip,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.onEditTap,
    this.variant = TripCardVariant.vertical,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSizes.cardPadding),
              child: _buildImageSection(context),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.cardPadding),
              child: _buildInfoSection(context),
            ),
          ],
        ),
      ),
    );
  }

  // Image + icon
  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.imageRadius),
            child: TripImage(imageUrl: trip.imageUrl),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: () {},
            icon: onEditTap != null
                ? Icon(Icons.edit_square, color: AppColors.of(context).accent)
                : (onFavoriteTap != null
                      ? Icon(
                          Icons.favorite,
                          color: AppColors.of(context).accent,
                        )
                      : Icon(Icons.favorite_border)),
          ),
        ),
      ],
    );
  }

  // Text context
  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(trip.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormatter.formatRange(
                    trip.departureDate,
                    trip.returnDate,
                  ),
                ),
                Text(trip.city),
              ],
            ),
            Text(
              PriceFormatter.formatta(trip.price),
              style: TextStyle(color: AppColors.of(context).accent),
            ),
          ],
        ),
      ],
    );
  }
}
