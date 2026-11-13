import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';

class TripTypeChip extends StatelessWidget {
  final TripType type;
  final bool isSelected;
  final ValueChanged<bool>? onTap;

  const TripTypeChip({
    required this.type,
    required this.isSelected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(type.label),
      selected: isSelected,
      onSelected: onTap,
    );
  }
}
