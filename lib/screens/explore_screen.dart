import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/trip_filters.dart';
import 'package:giachero_gaia_yologo/widgets/filter_sheet.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/widgets/search_filter_bar.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';

class ExploreScreen extends StatefulWidget {
  final String userId;
  const ExploreScreen({required this.userId, super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _controller = TextEditingController();
  TripFilters _filters = const TripFilters();
  late Future<List<Trip>> _searchFuture;

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<TripFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterSheet(initialFilters: _filters),
    );

    if (!mounted || result == null) return;

    setState(() {
      _filters = result;
      _searchFuture = _search();
    });
  }

  Future<List<Trip>> _search() {
    return TripService.searchTrips(
      text: _controller.text.trim(),
      filters: _filters,
      excludeOwnerId: widget.userId,
    );
  }

  void _onSearch() {
    FocusScope.of(context).unfocus();
    setState(() {
      _searchFuture = _search();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchFuture = _search();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTrips() {
    return FutureBuilder<List<Trip>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final trips = snapshot.data;
        if (snapshot.hasError || trips == null) {
          return StatusMessage(
            message: AppStrings.searchError,
            textButton: AppStrings.errorButton,
            onPressed: _onSearch,
          );
        }

        if (trips.isEmpty) {
          return StatusMessage(message: AppStrings.searchNoResults);
        }

        return Column(
          children: [
            for (final trip in trips) ...[
              TripCard(
                trip: trip,
                onFavoriteTap: () {},
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailScreen(
                      trip: trip,
                      isOwner: false,
                      onToggleFavorite: () {},
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapText),
            ],
          ],
        );
      },
    );
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
          child: ListView(
            children: [
              Text(
                AppStrings.titleExplore,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.of(context).textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingText),
              SearchFilterBar(
                controller: _controller,
                onSearchTap: _onSearch,
                onFilterTap: _openFilters,
                hasActiveFilters: _filters.isActive,
              ),
              const SizedBox(height: AppSizes.paddingText),
              _buildTrips(),
            ],
          ),
        ),
      ),
    );
  }
}
