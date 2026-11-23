import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/widgets/trip_type_chip.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';

class FilterPanel extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final double value;
  final ValueChanged<double> onValueChanged;
  final TripType? selectedType;
  final ValueChanged<TripType> onTypeSelected;

  const FilterPanel({
    required this.minPrice,
    required this.maxPrice,
    required this.value,
    required this.onValueChanged,
    required this.selectedType,
    required this.onTypeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.filterPanelPaddingVertical,
        horizontal: AppSizes.filterPanelPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusBox),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minPrice.round().toString(),
                style: AppTextStyles.body.copyWith(color: colors.textPrimary),
              ),
              Text(
                maxPrice.round().toString(),
                style: AppTextStyles.body.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
          Slider(
            min: minPrice,
            max: maxPrice,
            value: value,
            divisions: ((maxPrice - minPrice) / AppSizes.priceStep).round(),
            label: '${value.round()} €',
            onChanged: onValueChanged,
          ),
          const SizedBox(height: AppSizes.gapText),
          Container(
            padding: const EdgeInsets.all(AppSizes.filterChipPadding),
            decoration: BoxDecoration(
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(AppSizes.radiusBox),
            ),
            child: Wrap(
              spacing: AppSizes.gapChip,
              runSpacing: AppSizes.gapChip,
              children: [
                for (final type in TripType.values)
                  TripTypeChip(
                    type: type,
                    isSelected: selectedType == type,
                    onTap: (_) => onTypeSelected(type),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
