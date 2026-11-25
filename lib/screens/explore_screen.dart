import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/trip_filters.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/filter_panel.dart';
import 'package:giachero_gaia_yologo/widgets/search_filter_bar.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';

class ExploreScreen extends StatefulWidget {
  final String userId;
  final Set<String> favoriteIds;
  final void Function(Trip) onToggleFavorite;
  final String? selectedDestination;
  final int searchRequestId;

  const ExploreScreen({
    required this.userId,
    required this.favoriteIds,
    required this.onToggleFavorite,
    this.selectedDestination,
    this.searchRequestId = 0,
    super.key,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const double _priceMin = 0;
  static const double _priceMax = 1000;

  final TextEditingController _controller = TextEditingController();
  late Future<List<Trip>> _searchFuture;

  bool _showFilters = false;
  TripType? _selectedType;
  double _maxPrice = _priceMax;

  TripFilters get _filters => TripFilters(
    type: _selectedType,
    maxPrice: _maxPrice < _priceMax ? _maxPrice.round() : null,
  );

  void _toggleFilters() {
    setState(() => _showFilters = !_showFilters);
  }

  void _selectType(TripType type) {
    setState(() {
      _selectedType = _selectedType == type ? null : type;
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
      _showFilters = false;
      _searchFuture = _search();
    });
  }

  void _applyDestinationSearch(String destination) {
    _controller.text = destination;
    _selectedType = null;
    _maxPrice = _priceMax;
    _showFilters = false;
    _searchFuture = _search();
  }

  @override
  void initState() {
    super.initState();
    final destination = widget.selectedDestination;
    if (destination != null && destination.isNotEmpty) {
      _applyDestinationSearch(destination);
    } else {
      _searchFuture = _search();
    }
  }

  @override
  void didUpdateWidget(covariant ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final destination = widget.selectedDestination;
    if (widget.searchRequestId != oldWidget.searchRequestId &&
        destination != null &&
        destination.isNotEmpty) {
      setState(() {
        _applyDestinationSearch(destination);
      });
    }
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
                isFavorite: widget.favoriteIds.contains(trip.id),
                onFavoriteTap: () => widget.onToggleFavorite(trip),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailScreen(
                      trip: trip,
                      isOwner: false,
                      isFavorite: widget.favoriteIds.contains(trip.id),
                      onToggleFavorite: () => widget.onToggleFavorite(trip),
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context)
                .copyWith(overscroll: false),
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
                  onFilterTap: _toggleFilters,
                  hasActiveFilters: _filters.isActive,
                ),
                if (_showFilters) ...[
                  const SizedBox(height: AppSizes.paddingText),
                  FilterPanel(
                    minPrice: _priceMin,
                    maxPrice: _priceMax,
                    value: _maxPrice,
                    onValueChanged: (value) =>
                        setState(() => _maxPrice = value),
                    selectedType: _selectedType,
                    onTypeSelected: _selectType,
                  ),
                ],
                const SizedBox(height: AppSizes.paddingText),
                _buildTrips(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
