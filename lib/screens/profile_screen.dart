import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/user.dart';
import 'package:giachero_gaia_yologo/screens/settings_screen.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/profile_header.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';
import 'package:giachero_gaia_yologo/screens/add_trip_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User userProfile;
  final int refreshRequestId;
  final VoidCallback? onAddTripTap;

  const ProfileScreen({
    required this.userProfile,
    required this.refreshRequestId,
    this.onAddTripTap,
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _currentUser;
  late Future<List<Trip>> _tripsFuture;

  void _loadTrips() {
    setState(() {
      _tripsFuture = TripService.fetchTripsByOwner(_currentUser.id);
    });
  }

  Future<void> _openEditTrip(Trip trip) async {
    final result = await Navigator.of(context).push<EditTripResult>(
      MaterialPageRoute(
        builder: (_) => AddTripScreen(userId: _currentUser.id, trip: trip),
      ),
    );

    if (result != null && mounted) {
      _loadTrips();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userProfile;
    _tripsFuture = TripService.fetchTripsByOwner(_currentUser.id);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshRequestId != widget.refreshRequestId) {
      _loadTrips();
    }
  }

  Widget _buildTrips() {
    return FutureBuilder<List<Trip>>(
      future: _tripsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final trips = snapshot.data;
        if (snapshot.hasError || trips == null) {
          return StatusMessage(
            message: AppStrings.profileTripError,
            textButton: AppStrings.errorButton,
            onPressed: _loadTrips,
          );
        }

        if (trips.isEmpty) {
          return StatusMessage(
            message: AppStrings.profileNoTrip,
            textButton: AppStrings.addFirstTrip,
            buttonVariant: AppButtonVariant.primary,
            onPressed: widget.onAddTripTap,
          );
        }

        return Column(
          children: [
            for (final trip in trips) ...[
              TripCard(
                trip: trip,
                onEditTap: () => _openEditTrip(trip),
                onTap: () async {
                  final result = await Navigator.of(context)
                      .push<EditTripResult>(
                        MaterialPageRoute(
                          builder: (context) => TripDetailScreen(
                            trip: trip,
                            isOwner: true,
                            userId: _currentUser.id,
                          ),
                        ),
                      );

                  if (result != null && mounted) {
                    _loadTrips();
                  }
                },
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
    final usernameUser = _currentUser.username;
    final bioUser = _currentUser.bio;

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
              ProfileHeader(username: usernameUser),
              const SizedBox(height: AppSizes.gapText),
              if (bioUser != null)
                Text(
                  bioUser,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
              const SizedBox(height: AppSizes.gapText),
              AppButton(
                labelButton: AppStrings.settingsProfile,
                onTap: () async {
                  final updatedUser = await Navigator.push<User>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(user: _currentUser),
                    ),
                  );

                  if (updatedUser != null) {
                    setState(() {
                      _currentUser = updatedUser;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSizes.gapProfile),
              Text(
                AppStrings.profileMyTrip,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.of(context).textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.gapText),
              _buildTrips(),
            ],
          ),
        ),
      ),
    );
  }
}
