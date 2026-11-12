import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/date_formatter.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/utils/price_formatter.dart';

import '../models/trip.dart';
import './trip_image.dart';

import '../edit_icons.dart';

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
    return SizedBox(
      width: variant == TripCardVariant.horizontal
          ? AppSizes.cardImageWidthHorizontal + AppSizes.cardPadding * 2
          : null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.of(context).border,
            width: 1.5, 
          ),
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
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
      ),
    );
  }

  // Image + icon
  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: variant == TripCardVariant.horizontal
              ? AppSizes.cardImageWidthHorizontal
              : double.infinity,
          height: variant == TripCardVariant.horizontal
              ? AppSizes.cardImageHeightHorizontal
              : AppSizes.cardImageHeightVertical,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.imageRadius),
            child: TripImage(imageUrl: trip.imageUrl),
          ),
        ),
        if (onEditTap != null || onFavoriteTap != null)
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.of(context).onSurfaceVariant
                    .withValues(alpha: 0.2),
              ),
              onPressed: onEditTap ?? onFavoriteTap,
              icon: onEditTap != null
                  ? Icon(EditIcons.editOutlined, color: AppColors.of(context).accent)
                  : Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.of(context).accent : null,
                    ),
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
            Expanded(
              child: Column(
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
