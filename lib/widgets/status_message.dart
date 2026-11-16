import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';

class StatusMessage extends StatelessWidget {
  final String message;
  final String? textButton;
  final VoidCallback? onPressed;
  final AppButtonVariant buttonVariant;

  const StatusMessage({
    required this.message,
    this.textButton,
    this.onPressed,
    this.buttonVariant = AppButtonVariant.red,
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
          AppButton(
            labelButton: labelButton,
            onTap: onPressed,
            variant: buttonVariant,
          ),
      ],
    );
  }
}
