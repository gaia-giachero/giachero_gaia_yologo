import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/user.dart';
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
  final Map<String, Trip> _favorites = {};

  void _toggleFavorite(Trip trip) {
    setState(() {
      if (_favorites.containsKey(trip.id)) {
        _favorites.remove(trip.id);
      } else {
        _favorites[trip.id] = trip;
      }
    });
  }

  Set<String> get _favoriteIds => _favorites.keys.toSet();
  List<Trip> get _favoriteTrips => _favorites.values.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            favoriteIds: _favoriteIds,
            onToggleFavorite: _toggleFavorite,
          ),
          ExploreScreen(
            userId: widget.user.id,
            favoriteIds: _favoriteIds,
            onToggleFavorite: _toggleFavorite,
          ),
          const AddTripScreen(),
          FavoritesScreen(
            favorites: _favoriteTrips,
            onToggleFavorites: _toggleFavorite,
            onExploreTap: () => setState(() => _index = 1),
          ),
          ProfileScreen(userProfile: widget.user),
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
