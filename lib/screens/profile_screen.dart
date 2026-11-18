import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/user.dart';
import 'package:giachero_gaia_yologo/screens/settings_screen.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/profile_header.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';

class ProfileScreen extends StatefulWidget {
  final User userProfile;
  const ProfileScreen({required this.userProfile, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Trip>> _tripsFuture;

  void _loadTrips() {
    setState(() {
      _tripsFuture = TripService.fetchTripsByOwner(widget.userProfile.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _tripsFuture = TripService.fetchTripsByOwner(widget.userProfile.id);
  }

  @override
  void dispose() {
    super.dispose();
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
            onPressed: () {},
          );
        }

        return Column(
          children: [
            for (final trip in trips) ...[
              TripCard(trip: trip, onEditTap: () {}),
              const SizedBox(height: AppSizes.gapText),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usernameUser = widget.userProfile.username;
    final bioUser = widget.userProfile.bio;

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
              ProfileHeader(username: widget.userProfile.username),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      nomeUtente: usernameUser,
                      bioUtente: bioUser,
                    ),
                  ),
                ),
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
