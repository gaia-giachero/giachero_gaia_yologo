import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Trip> favorites;
  final ValueChanged<Trip> onToggleFavorites;
  final VoidCallback onExploreTap;
  final bool hasError;
  final VoidCallback onRetry;

  const FavoritesScreen({
    required this.favorites,
    required this.onToggleFavorites,
    required this.onExploreTap,
    required this.hasError,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.paddingHorizontalPage,
            AppSizes.paddingTopPage,
            AppSizes.paddingHorizontalPage,
            AppSizes.paddingBottomPage,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.myFavorites,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.of(context).textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.generalGapFav),

              if (hasError)
                Expanded(
                  child: Center(
                    child: StatusMessage(
                      message: AppStrings.favoriteError,
                      textButton: AppStrings.errorButton,
                      onPressed: onRetry,
                    ),
                  ),
                )
              else if (favorites.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StatusMessage(message: AppStrings.favoriteNoFav),
                        AppButton(
                          labelButton: AppStrings.exploreAddTrip,
                          onTap: onExploreTap,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      for (final trip in favorites)
                        TripCard(
                          trip: trip,
                          isFavorite: true,
                          onFavoriteTap: () => onToggleFavorites(trip),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripDetailScreen(
                                trip: trip,
                                isFavorite: true,
                                onToggleFavorite: () => onToggleFavorites(trip),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
