import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

enum AppButtonVariant { primary, red, green, secondary }

class AppButton extends StatelessWidget {
  final String labelButton;
  final IconData? icon;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool isFullWidth;
  final bool isLoading;

  const AppButton({
    required this.labelButton,
    this.icon,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.isFullWidth = true,
    this.isLoading = false,
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
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.of(context).textPrimary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.paddingVerticalButton,
                    ),
                    child: Text(labelButton),
                  ),
                ],
              ),
      ),
    );
  }
}
