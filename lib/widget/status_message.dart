import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';

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
        Text(message, style: TextStyle(color: AppColors.of(context).textPrimary),),
        SizedBox(height: 10),
        if (labelButton != null)
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor:
                  buttonColor ?? Theme.of(context).colorScheme.primary,
            ),
            child: Text(labelButton, style: TextStyle(color: AppColors.of(context).surface),),
          ),
      ],
    );
  }
}
