import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/user.dart';
import 'package:giachero_gaia_yologo/services/favorite_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_theme.dart';
import 'package:giachero_gaia_yologo/screens/add_trip_screen.dart';
import 'package:giachero_gaia_yologo/screens/explore_screen.dart';
import 'package:giachero_gaia_yologo/screens/favorites_screen.dart';
import 'package:giachero_gaia_yologo/screens/home_screen.dart';
import 'package:giachero_gaia_yologo/screens/profile_screen.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

class MainShellScreen extends StatefulWidget {
  final User user;
  const MainShellScreen({required this.user, super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;
  String? _city;
  int _request = 0;
  int _tripsRefreshRequest = 0;
  final Map<String, Trip> _favorites = {};
  bool _hasFavoritesError = false;
  bool _isLoadingFavorites = true;

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoadingFavorites = true;
      _hasFavoritesError = false;
    });

    try {
      final trips = await FavoriteService.fetchFavoriteTrips(widget.user.id);
      if (!mounted) return;
      setState(() {
        _favorites.clear();
        for (final trip in trips) {
          _favorites[trip.id] = trip;
        }
        _isLoadingFavorites = false;
      });
    } catch (e, st) {
      debugPrint('Errore caricamento preferiti: $e\n$st');
      if (!mounted) return;
      setState(() {
        _hasFavoritesError = true;
        _isLoadingFavorites = false;
      });
    }
  }

  Future<void> _toggleFavorite(Trip trip) async {
    final wasFavorite = _favorites.containsKey(trip.id);

    setState(() {
      if (wasFavorite) {
        _favorites.remove(trip.id);
      } else {
        _favorites[trip.id] = trip;
      }
    });

    try {
      if (wasFavorite) {
        await FavoriteService.removeFavorite(
          userId: widget.user.id,
          tripId: trip.id,
        );
      } else {
        await FavoriteService.addFavorite(
          userId: widget.user.id,
          tripId: trip.id,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (wasFavorite) {
          _favorites[trip.id] = trip;
        } else {
          _favorites.remove(trip.id);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore durante l\'aggiornamento dei preferiti.'),
        ),
      );
    }
  }

  Set<String> get _favoriteIds => _favorites.keys.toSet();
  List<Trip> get _favoriteTrips => _favorites.values.toList();

  void _tapDestination(String citySelected) {
    setState(() {
      _city = citySelected;
      _request++;
      _index = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didUpdateWidget(covariant MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.id != widget.user.id) {
      _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            favoriteIds: _favoriteIds,
            onToggleFavorite: _toggleFavorite,
            onDestinationTap: _tapDestination,
          ),
          ExploreScreen(
            userId: widget.user.id,
            favoriteIds: _favoriteIds,
            onToggleFavorite: _toggleFavorite,
            selectedDestination: _city,
            searchRequestId: _request,
          ),
          AddTripScreen(
            userId: widget.user.id,
            onGoToMyTrips: () => setState(() {
              _tripsRefreshRequest++;
              _index = 4;
            }),
          ),
          FavoritesScreen(
            favorites: _favoriteTrips,
            onToggleFavorites: _toggleFavorite,
            onExploreTap: () => setState(() => _index = 1),
            hasError: _hasFavoritesError,
            isLoading: _isLoadingFavorites,
            onRetry: _loadFavorites,
          ),
          ProfileScreen(
            userProfile: widget.user,
            refreshRequestId: _tripsRefreshRequest,
            onAddTripTap: () {
              setState(() {
                _index = 2;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingVertical,
          horizontal: AppSizes.paddingHorizontal,
        ),
        child: Container(
          height: AppSizes.navHeight,
          decoration: AppTheme.navBarDecoration(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_outlined, index: 0),
              _buildNavItem(icon: Icons.explore_outlined, index: 1),
              _buildNavItem(icon: Icons.add_circle, index: 2),
              _buildNavItem(icon: Icons.favorite, index: 3),
              _buildNavItem(icon: Icons.account_circle_outlined, index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _index == index;
    return IconButton(
      onPressed: () => setState(() => _index = index),
      icon: Icon(
        icon,
        size: isSelected ? AppSizes.iconSizeSelected : AppSizes.iconSize,
        color: isSelected
            ? AppColors.of(context).primary
            : AppColors.of(context).disabled,
      ),
    );
  }
}
