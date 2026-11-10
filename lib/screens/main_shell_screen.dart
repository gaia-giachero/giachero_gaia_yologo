import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/utils/app_string.dart';
import 'package:giachero_gaia_yologo/screens/add_trip_screen.dart';
import 'package:giachero_gaia_yologo/screens/explore_screen.dart';
import 'package:giachero_gaia_yologo/screens/favorites_screen.dart';
import 'package:giachero_gaia_yologo/screens/home_screen.dart';
import 'package:giachero_gaia_yologo/screens/profile_screen.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

import '../theme/app_colors.dart';

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
      bottomNavigationBar: 
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingHorizontal,
          vertical: AppSizes.paddingVertical,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: NavigationBar(
            selectedIndex: _index,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: AppStrings.navHome,
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                label: AppStrings.navExplore,
              ),
              NavigationDestination(
                icon: Icon(Icons.add_circle),
                label: AppStrings.navAdd,
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite),
                label: AppStrings.navFavorite,
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                label: AppStrings.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
