import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final AppButtonVariant confirmVariant;

  const ConfirmDialog({
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = AppStrings.cancelButton,
    required this.confirmVariant,
    super.key,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String message,
    required String confirmLabel,
    String cancelLabel = AppStrings.cancelButton,
    AppButtonVariant confirmVariant = AppButtonVariant.red,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmVariant: confirmVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.of(context).surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(AppSizes.searchRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingDialog),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.gapForm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    labelButton: cancelLabel,
                    variant: AppButtonVariant.secondary,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSizes.gapDialog),
                Expanded(
                  child: AppButton(
                    labelButton: confirmLabel,
                    variant: confirmVariant,
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
