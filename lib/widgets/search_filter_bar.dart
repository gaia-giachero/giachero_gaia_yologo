import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSearchTap;
  final bool hasActiveFilters;

  const SearchFilterBar({
    this.controller,
    this.onFilterTap,
    this.onSearchTap,
    this.hasActiveFilters = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          style: AppTextStyles.body.copyWith(
            color: AppColors.of(context).textPrimary,
          ),
          controller: controller,
          decoration: InputDecoration(hintText: AppStrings.hintText),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: controller != null
                  ? ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller!,
                      builder: (context, value, _) {
                        final canSearch =
                            value.text.trim().isNotEmpty || hasActiveFilters;
                        return FilledButton(
                          onPressed: canSearch ? onSearchTap : null,
                          child: Text(AppStrings.searchButton),
                        );
                      },
                    )
                  : FilledButton(
                      onPressed: hasActiveFilters ? onSearchTap : null,
                      child: Text(AppStrings.searchButton),
                    ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: onFilterTap,
              icon: Icon(
                Icons.tune,
                color: hasActiveFilters
                    ? AppColors.of(context).primary
                    : AppColors.of(context).disabled,
                size: AppSizes.filterIcons,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
