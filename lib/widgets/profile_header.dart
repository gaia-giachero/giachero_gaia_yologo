import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  const ProfileHeader({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.avatarSize,
          height: AppSizes.avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.of(context).border,
              width: AppSizes.avatarBorder,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_img.webp',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.gapAvatarName),
        Text(
          username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.h3.copyWith(color: AppColors.of(context).textPrimary),
        ),
      ],
    );
  }
}