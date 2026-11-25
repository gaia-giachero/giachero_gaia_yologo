import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/services/unsplash_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/popular_destination_item.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';

class HomeScreen extends StatefulWidget {
  final Set<String> favoriteIds;
  final void Function(Trip) onToggleFavorite;
  final void Function(String) onDestinationTap;

  const HomeScreen({
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onDestinationTap,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> _trips = [];
  bool _isLoading = true;
  late Future<List<({String city, String? imageUrl})>>
  _popularDestinationsFuture;

  Future<List<({String city, String? imageUrl})>>
  _loadPopularDestinations() async {
    final results = await TripService.fetchPopularDestinations();

    if (results.isEmpty) return [];

    return Future.wait(
      results.map((city) async {
        final url = await UnsplashService.fetchDestinationImage(city);
        return (city: city, imageUrl: url);
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTrips();
    _popularDestinationsFuture = _loadPopularDestinations();
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

  List<Trip> get _upcomingTrips {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final limit = today.add(const Duration(days: 2));

    return _trips.where((trip) {
      final dep = DateTime(
        trip.departureDate.year,
        trip.departureDate.month,
        trip.departureDate.day,
      );
      return !dep.isBefore(today) && !dep.isAfter(limit);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
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
                      const SizedBox(height: AppSizes.gapSectionHome),
                      FutureBuilder<List<({String city, String? imageUrl})>>(
                        future: _popularDestinationsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: AppSizes.destinationListHeight,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError) {
                            return StatusMessage(
                              message: AppStrings.destinationError,
                              onPressed: () => setState(() {
                                _popularDestinationsFuture =
                                    _loadPopularDestinations();
                              }),
                            );
                          }

                          final destinations = snapshot.data ?? [];

                          if (destinations.isEmpty) {
                            return Text(AppStrings.noDestination);
                          }

                          return SizedBox(
                            height: AppSizes.destinationListHeight,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: destinations.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: AppSizes.gapDestination,
                                  ),
                              itemBuilder: (context, index) {
                                final item = destinations[index];
                                return PopularDestinationItem(
                                  city: item.city,
                                  imageUrl: item.imageUrl,
                                  onTap: () =>
                                      widget.onDestinationTap(item.city),
                                );
                              },
                            ),
                          );
                        },
                      ),
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
                        ? Text(
                            'Nessun viaggio in partenza nei prossimi 2 giorni',
                          )
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
                                    isFavorite: widget.favoriteIds.contains(
                                      trip.id,
                                    ),
                                    onFavoriteTap: () =>
                                        widget.onToggleFavorite(trip),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripDetailScreen(
                                          trip: trip,
                                          isFavorite: widget.favoriteIds
                                              .contains(trip.id),
                                          onToggleFavorite: () =>
                                              widget.onToggleFavorite(trip),
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
      ),
    );
  }
}
