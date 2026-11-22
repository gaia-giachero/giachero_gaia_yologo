import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip_filters.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';

class FilterSheet extends StatefulWidget {
  final TripFilters initialFilters;
  const FilterSheet({required this.initialFilters, super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  late Set<TripType> _types;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialFilters;
    _types = {...initial.types}; // copia: la bozza non tocca l'originale
    _minController = TextEditingController(
      text: initial.minPrice?.toString() ?? '',
    );
    _maxController = TextEditingController(
      text: initial.maxPrice?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _toggleType(TripType type, bool selected) {
    setState(() {
      if (selected) {
        _types.add(type);
      } else {
        _types.remove(type);
      }
    });
  }

  String? _validatePrice(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; // vuoto = nessun limite
    final price = int.tryParse(text);
    if (price == null || price < 0) return AppStrings.invalidPrice;
    return null;
  }

  String? _validateMax(String? value) {
    final basic = _validatePrice(value);
    if (basic != null) return basic;

    final max = int.tryParse(value?.trim() ?? '');
    final min = int.tryParse(_minController.text.trim());
    if (max != null && min != null && max < min) {
      return AppStrings.maxLessThanMin;
    }
    return null;
  }

  void _apply() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    Navigator.pop(
      context,
      TripFilters(
        types: _types,
        minPrice: int.tryParse(_minController.text.trim()),
        maxPrice: int.tryParse(_maxController.text.trim()),
      ),
    );
  }

  void _reset() {
    Navigator.pop(context, const TripFilters());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}