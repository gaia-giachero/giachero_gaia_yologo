import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_theme.dart';
import 'package:giachero_gaia_yologo/screens/add_trip_screen.dart';
import 'package:giachero_gaia_yologo/screens/explore_screen.dart';
import 'package:giachero_gaia_yologo/screens/favorites_screen.dart';
import 'package:giachero_gaia_yologo/screens/home_screen.dart';
import 'package:giachero_gaia_yologo/screens/profile_screen.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          ExploreScreen(),
          AddTripScreen(),
          FavoritesScreen(),
          ProfileScreen(),
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
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).disabledColor,
      ),
    );
  }
}
