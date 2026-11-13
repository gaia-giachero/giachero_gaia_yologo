import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';

class StatusMessage extends StatelessWidget {
  final String message;
  final String? textButton;
  final VoidCallback? onPressed;
  final Color? buttonColor;

  const StatusMessage({
    required this.message,
    this.textButton,
    this.onPressed,
    this.buttonColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final labelButton = textButton;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: AppTextStyles.body.copyWith(
            color: AppColors.of(context).textPrimary,
          ),
        ),
        SizedBox(height: 10),
        if (labelButton != null)
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              backgroundColor:
                  buttonColor ?? Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              labelButton,
              style: AppTextStyles.label.copyWith(
                color: AppColors.of(context).surface,
              ),
            ),
          ),
      ],
    );
  }
}
