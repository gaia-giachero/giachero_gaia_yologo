import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

class AddTripScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onGoToMyTrips;

  const AddTripScreen({
    required this.userId,
    required this.onGoToMyTrips,
    super.key,
  });

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _departureDate;
  DateTime? _returnDate;
  TripType? _selectedType;

  bool _isSubmitting = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingHorizontalPage,
                AppSizes.paddingTopPage,
                AppSizes.paddingHorizontalPage,
                AppSizes.paddingBottomPage,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.titleAdd,
                    style: AppTextStyles.display.copyWith(
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.gapForm),
                  Text(
                    AppStrings.subtitleAdd,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
