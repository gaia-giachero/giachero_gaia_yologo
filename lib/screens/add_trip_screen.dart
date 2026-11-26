import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/date_formatter.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/utils/validators.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/status_dialog.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/text_field.dart';
import 'package:giachero_gaia_yologo/widgets/trip_type_chip.dart';
import 'package:giachero_gaia_yologo/widgets/confirm_dialog.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';

enum EditTripResult { updated, deleted }

class AddTripScreen extends StatefulWidget {
  final String userId;
  final VoidCallback? onGoToMyTrips;
  final Trip? trip;

  const AddTripScreen({
    required this.userId,
    this.onGoToMyTrips,
    this.trip,
    super.key,
  });

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _departureDate;
  DateTime? _returnDate;
  TripType? _selectedType;

  bool _isSubmitting = false;
  bool _isSuccess = false;
  bool _showSelectionErrors = false;

  bool get _hasAnyInput =>
      _titleController.text.trim().isNotEmpty ||
      _destinationController.text.trim().isNotEmpty ||
      _priceController.text.trim().isNotEmpty ||
      _descriptionController.text.trim().isNotEmpty ||
      _departureDate != null ||
      _returnDate != null ||
      _selectedType != null;

  bool get _isModify => widget.trip != null;

  bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a == b;
    return DateFormatter.formatForDatabase(a) ==
        DateFormatter.formatForDatabase(b);
  }

  bool get _hasChanges {
    final trip = widget.trip;
    if (trip == null) return _hasAnyInput;

    return _titleController.text.trim() != trip.title.trim() ||
        _destinationController.text.trim() != trip.city.trim() ||
        int.tryParse(_priceController.text.trim()) != trip.price ||
        _descriptionController.text.trim() != trip.description.trim() ||
        !_sameDay(_departureDate, trip.departureDate) ||
        !_sameDay(_returnDate, trip.returnDate) ||
        _selectedType != trip.type;
  }

  bool get _isFormCompleteAndValid =>
      Validators.notEmpty(_titleController.text) == null &&
      Validators.notEmpty(_destinationController.text) == null &&
      Validators.price(_priceController.text) == null &&
      Validators.notEmpty(_descriptionController.text) == null &&
      _departureDate != null &&
      _returnDate != null &&
      Validators.returnDate(_departureDate, _returnDate) == null &&
      _selectedType != null;

  bool get _canSubmit =>
      !_isSubmitting && _isFormCompleteAndValid && (!_isModify || _hasChanges);

  @override
  void initState() {
    super.initState();
    final trip = widget.trip;
    if (trip != null) {
      _titleController.text = trip.title;
      _destinationController.text = trip.city;
      _priceController.text = trip.price.toString();
      _descriptionController.text = trip.description;
      _departureDate = trip.departureDate;
      _returnDate = trip.returnDate;
      _selectedType = trip.type;
    }
  }

  void _resetForm() {
    FocusScope.of(context).unfocus();
    _titleController.clear();
    _destinationController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _formKey = GlobalKey<FormState>();
      _departureDate = null;
      _returnDate = null;
      _selectedType = null;
      _showSelectionErrors = false;
    });
  }

  Future<void> _onCancelTap() async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    final confirm = await ConfirmDialog.show(
      context,
      message: AppStrings.confirmNoChange,
      confirmLabel: AppStrings.confirmButton,
      confirmVariant: AppButtonVariant.primary,
    );

    if (confirm == true && mounted) Navigator.of(context).pop();
  }

  Future<void> _onDeleteTap() async {
    final confirm = await ConfirmDialog.show(
      context,
      message: AppStrings.confirmDelete,
      confirmLabel: AppStrings.deleteButton,
    );

    if (confirm != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await TripService.deleteTrip(widget.trip!.id);
      if (!mounted) return;
      await StatusDialog.show(context, message: AppStrings.successDelete);
      if (mounted) {
        Navigator.of(context).pop(EditTripResult.deleted);
      }
    } catch (e) {
      if (!mounted) return;
      final retry = await ConfirmDialog.show(
        context,
        message: AppStrings.errorDelete,
        confirmLabel: AppStrings.errorButton,
        confirmVariant: AppButtonVariant.primary,
      );
      if (retry == true) {
        await _onDeleteTap();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _showSelectionErrors = true;
    });

    final departureDate = _departureDate;
    final returnDate = _returnDate;
    final selectedType = _selectedType;

    final isFormValid = _formKey.currentState?.validate() ?? false;
    final isReturnValid =
        Validators.returnDate(departureDate, returnDate) == null;

    if (!isFormValid ||
        departureDate == null ||
        returnDate == null ||
        !isReturnValid ||
        selectedType == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (_isModify) {
        await TripService.updateTrip(
          original: widget.trip!,
          title: _titleController.text.trim(),
          city: _destinationController.text.trim(),
          startDate: departureDate,
          endDate: returnDate,
          price: int.parse(_priceController.text.trim()),
          type: selectedType,
          description: _descriptionController.text.trim(),
        );
        if (!mounted) return;
        await StatusDialog.show(context, message: AppStrings.successModify);
        if (mounted) {
          Navigator.of(context).pop(EditTripResult.updated);
        }
      } else {
        await TripService.createTrip(
          ownerId: widget.userId,
          title: _titleController.text.trim(),
          city: _destinationController.text.trim(),
          startDate: departureDate,
          endDate: returnDate,
          price: int.parse(_priceController.text.trim()),
          type: selectedType,
          description: _descriptionController.text.trim(),
        );
        _resetForm();
        setState(() {
          _isSuccess = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      if (!_isModify) {
        final shouldReset = await ConfirmDialog.show(
          context,
          message: AppStrings.addError,
          confirmLabel: AppStrings.deleteButton,
        );

        if (shouldReset == true) _resetForm();
      } else {
        final retry = await ConfirmDialog.show(
          context,
          message: AppStrings.errorModify,
          confirmLabel: AppStrings.errorButton,
          confirmVariant: AppButtonVariant.primary,
        );

        if (retry == true) await _submit();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isSuccess
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingHorizontalPage,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StatusMessage(message: AppStrings.addSuccess),
                      const SizedBox(height: AppSizes.gapForm),
                      AppButton(
                        labelButton: AppStrings.myTripButton,
                        variant: AppButtonVariant.green,
                        onTap: () {
                          setState(() {
                            _isSuccess = false;
                          });
                          widget.onGoToMyTrips?.call();
                        },
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.paddingHorizontalPage,
                      AppSizes.paddingTopPage,
                      AppSizes.paddingHorizontalPage,
                      AppSizes.paddingBottomPage,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_isModify)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppStrings.titleEdit,
                                  style: AppTextStyles.display.copyWith(
                                    color: AppColors.of(context).textPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _isSubmitting ? null : _onDeleteTap,
                                icon: const Icon(Icons.delete_outline),
                                color: AppColors.of(context).textPrimary,
                              ),
                            ],
                          )
                        else ...[
                          Text(
                            AppStrings.titleAdd,
                            style: AppTextStyles.display.copyWith(
                              color: AppColors.of(context).textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.gapForm),
                          Text(
                            AppStrings.subtitleAdd,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.of(context).textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.gapForm),
                        AppTextField(
                          labelText: AppStrings.titleTrip,
                          hintText: AppStrings.hintTitleTrip,
                          isRequired: true,
                          enabled: !_isSubmitting,
                          controller: _titleController,
                          validator: Validators.notEmpty,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSizes.gapForm),
                        AppTextField(
                          labelText: AppStrings.cityTrip,
                          hintText: AppStrings.hintCityTrip,
                          isRequired: true,
                          enabled: !_isSubmitting,
                          controller: _destinationController,
                          validator: Validators.notEmpty,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSizes.gapForm),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDatePickerField(
                                label: '${AppStrings.departureTrip} *',
                                hint: AppStrings.hintDepartureTrip,
                                selectedDate: _departureDate,
                                onTap: () async {
                                  final now = DateTime.now();
                                  final today = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                  );
                                  final current = _departureDate;
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        (current != null &&
                                            !current.isBefore(today))
                                        ? current
                                        : today,
                                    firstDate: today,
                                    lastDate: DateTime(now.year + 5),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _departureDate = picked;
                                      if (_returnDate != null &&
                                          _returnDate!.isBefore(picked)) {
                                        _returnDate = null;
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: AppSizes.gapDate),
                            Expanded(
                              child: _buildDatePickerField(
                                label: '${AppStrings.returnTrip} *',
                                hint: AppStrings.hintReturnTrip,
                                selectedDate: _returnDate,
                                onTap: () async {
                                  final now = DateTime.now();
                                  final minDate =
                                      _departureDate ??
                                      DateTime(now.year, now.month, now.day);
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _returnDate ?? minDate,
                                    firstDate: minDate,
                                    lastDate: DateTime(now.year + 5),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _returnDate = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_showSelectionErrors) ...[
                          if (Validators.notNull(_departureDate) != null ||
                              Validators.returnDate(
                                    _departureDate,
                                    _returnDate,
                                  ) !=
                                  null) ...[
                            const SizedBox(height: AppSizes.fieldLabelGap),
                            Text(
                              Validators.notNull(_departureDate) ??
                                  Validators.returnDate(
                                    _departureDate,
                                    _returnDate,
                                  )!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.of(context).error,
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: AppSizes.gapForm),
                        AppTextField(
                          labelText: AppStrings.priceTrip,
                          hintText: AppStrings.hintPriceTrip,
                          controller: _priceController,
                          isRequired: true,
                          enabled: !_isSubmitting,
                          validator: Validators.price,
                          suffixText: '€',
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSizes.gapForm),
                        Text(
                          AppStrings.typeTrip,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.of(context).textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.fieldLabelGap),
                        Container(
                          padding: const EdgeInsets.all(
                            AppSizes.filterChipPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).surface,
                            border: Border.all(
                              color: AppColors.of(context).border,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.searchRadius,
                            ),
                          ),
                          child: Wrap(
                            spacing: AppSizes.gapChip,
                            runSpacing: AppSizes.gapChip,
                            children: [
                              for (final type in TripType.values)
                                TripTypeChip(
                                  type: type,
                                  isSelected: _selectedType == type,
                                  onTap: (selected) {
                                    if (_isSubmitting) return;
                                    setState(() {
                                      _selectedType = (selected || _isModify)
                                          ? type
                                          : null;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                        if (_showSelectionErrors &&
                            Validators.notNull(_selectedType) != null) ...[
                          const SizedBox(height: AppSizes.fieldLabelGap),
                          Text(
                            Validators.notNull(_selectedType)!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.of(context).error,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.gapForm),
                        AppTextField(
                          labelText: AppStrings.descriptionTrip,
                          hintText: AppStrings.hintDescriptionTrip,
                          controller: _descriptionController,
                          isRequired: true,
                          enabled: !_isSubmitting,
                          maxLines: 5,
                          validator: Validators.notEmpty,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSizes.gapForm),
                        if (_isModify) ...[
                          if (_hasChanges) ...[
                            AppButton(
                              labelButton: AppStrings.saveButton,
                              isLoading: _isSubmitting,
                              onTap: _canSubmit ? _submit : null,
                            ),
                            const SizedBox(height: AppSizes.gapButtonForm),
                          ],
                          AppButton(
                            labelButton: AppStrings.cancelButton,
                            variant: AppButtonVariant.secondary,
                            onTap: _isSubmitting ? null : _onCancelTap,
                          ),
                        ] else ...[
                          AppButton(
                            labelButton: AppStrings.addTripButton,
                            isLoading: _isSubmitting,
                            onTap: _canSubmit ? _submit : null,
                          ),
                          if (_hasAnyInput) ...[
                            const SizedBox(height: AppSizes.gapButtonForm),
                            AppButton(
                              labelButton: AppStrings.deleteButton,
                              variant: AppButtonVariant.red,
                              onTap: _isSubmitting ? null : _resetForm,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required String hint,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.of(context).textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.fieldLabelGap),
        GestureDetector(
          onTap: _isSubmitting ? null : onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingHorizontalDate,
              vertical: AppSizes.paddingVerticalDate,
            ),
            decoration: BoxDecoration(
              color: AppColors.of(context).surface,
              border: Border.all(color: AppColors.of(context).border),
              borderRadius: BorderRadius.circular(AppSizes.searchRadius),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormatter.formatta(selectedDate)
                  : hint,
              style: AppTextStyles.body.copyWith(
                color: selectedDate != null
                    ? AppColors.of(context).textPrimary
                    : AppColors.of(context).textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
