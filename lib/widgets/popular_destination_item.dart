import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/trip_image.dart';

class PopularDestinationItem extends StatelessWidget {
  final String city;
  final String? imageUrl;
  final VoidCallback? onTap;

  const PopularDestinationItem({
    required this.city,
    this.imageUrl,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              width: AppSizes.destinationCircleSize,
              height: AppSizes.destinationCircleSize,
              child: TripImage(imageUrl: imageUrl, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 5),
          Text(
            city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.of(context).textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
