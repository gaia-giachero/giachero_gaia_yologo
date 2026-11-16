import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

enum AppButtonVariant { primary, red, green, secondary }

class AppButton extends StatelessWidget {
  final String labelButton;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool isFullWidth;

  const AppButton({
    required this.labelButton,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.isFullWidth = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      AppButtonVariant.primary => (
        AppColors.of(context).primary,
        AppColors.of(context).surface,
      ),
      AppButtonVariant.red => (
        AppColors.of(context).error,
        AppColors.of(context).surface,
      ),
      AppButtonVariant.green => (
        AppColors.of(context).success,
        AppColors.of(context).surface,
      ),
      AppButtonVariant.secondary => (
        AppColors.of(context).surfaceVariant,
        AppColors.of(context).textPrimary,
      ),
    };
    return SizedBox(
      width: isFullWidth ? double.infinity : AppSizes.widthButton,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: AppColors.of(context).disabled,
        ),
        child: Text(labelButton),
      ),
    );
  }
}
