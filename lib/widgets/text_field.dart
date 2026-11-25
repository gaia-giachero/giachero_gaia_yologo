import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';

import '../utils/helpers.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final String? suffixText;
  final bool isPassword;
  final bool isRequired;
  final bool showLabel;
  final bool enabled;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const AppTextField({
    this.controller,
    required this.labelText,
    required this.hintText,
    this.suffixText,
    this.isPassword = false,
    this.isRequired = false,
    this.showLabel = true,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    super.key,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden;

  @override
  void initState() {
    super.initState();
    _hidden = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.isRequired ? '${widget.labelText} *' : widget.labelText,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.of(context).textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.fieldLabelGap),
        ],
        TextFormField(
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          obscureText: _hidden,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixText: widget.suffixText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden ? Icons.visibility : Icons.visibility_off,
                    ),
                    color: AppColors.of(context).textSecondary,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
