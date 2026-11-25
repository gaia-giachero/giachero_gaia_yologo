import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';

class StatusDialog extends StatelessWidget {
  final String message;

  const StatusDialog({required this.message, super.key});

  static Future<void> show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(duration, () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });

        return StatusDialog(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.of(context).surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.searchRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingHorizontalPage),
        child: StatusMessage(message: message),
      ),
    );
  }
}
