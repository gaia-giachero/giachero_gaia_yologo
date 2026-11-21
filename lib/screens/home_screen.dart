import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> _trips = [];
  final Set<String> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final result = await TripService.fetchSystemTrips();
      _trips = result;
    } catch (e) {
      debugPrint('Errore: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite(String tripId) {
    setState(() {
      if (_favoriteIds.contains(tripId)) {
        _favoriteIds.remove(tripId);
      } else {
        _favoriteIds.add(tripId);
      }
    });
  }

  List<Trip> get _upcomingTrips {
    final now = DateTime.now();
    final target = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 2));

    return _trips.where((trip) {
      return trip.departureDate.year == target.year &&
          trip.departureDate.month == target.month &&
          trip.departureDate.day == target.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingHorizontalPage,
            AppSizes.paddingTopPage,
            AppSizes.paddingHorizontalPage,
            AppSizes.paddingBottomPage,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.titleHome,
                style: AppTextStyles.brandTitle.copyWith(
                  color: AppColors.of(context).textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.gapTitle),
              Text(
                AppStrings.intestationHome,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.of(context).textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.gapSectionHome),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.of(context).border,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSection),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingHorizontalSection,
                  vertical: AppSizes.paddingVerticalSection,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.popularDestination,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.of(context).textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.gapSectionHome,),
                    
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.gapSectionHome),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.lastTrip,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.gapCard),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _upcomingTrips.isEmpty
                      ? Text('Nessun viaggio in partenza nei prossimi 2 giorni')
                      : SizedBox(
                          height: AppSizes.heightLastTrip,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: _upcomingTrips.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: AppSizes.gapCard),
                            itemBuilder: (BuildContext context, int index) {
                              final trip = _upcomingTrips[index];
                              return SizedBox(
                                width: AppSizes.widthCard,
                                child: TripCard(
                                  trip: trip,
                                  isFavorite: _favoriteIds.contains(trip.id),
                                  onFavoriteTap: () => _toggleFavorite(trip.id),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TripDetailScreen(
                                        trip: trip,
                                        isFavorite: _favoriteIds.contains(
                                          trip.id,
                                        ),
                                        onToggleFavorite: () =>
                                            _toggleFavorite(trip.id),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
