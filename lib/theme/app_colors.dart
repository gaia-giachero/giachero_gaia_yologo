import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class AppPalette {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textLogin;
  final Color textPrimary;
  final Color textSecondary;
  final Color surfaceVariant;
  final Color border;
  final Color disabled;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const AppPalette({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textLogin,
    required this.textPrimary,
    required this.textSecondary,
    required this.surfaceVariant,
    required this.border,
    required this.disabled,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });
}

class AppColors {
  // palette light
  static const light = AppPalette(
    primary: Color(0xFF3657F5),
    accent: Color(0xFFFF784F),
    background: Color(0xFFF5F7FC),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE9EDFA),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF475569),
    textLogin: Color(0xFFF4F6FF),
    border: Color(0xFFD8DEEA),
    disabled: Color(0xFF94A3B8),
    success: Color(0xFF25845B),
    warning: Color(0xFFB77919),
    error: Color(0xFFD04450),
    info: Color(0xFF2863C7),
  );

  // palette dark
  static const dark = AppPalette(
    primary: Color(0xFF8294FF),
    accent: Color(0xFFFF906E),
    background: Color(0xFF0D1220),
    surface: Color(0xFF171F33),
    surfaceVariant: Color(0xFF202A43),
    textPrimary: Color(0xFFF4F6FF),
    textSecondary: Color(0xFFAAB4C8),
    textLogin: Color(0xFFF4F6FF),
    border: Color(0xFF34405A),
    disabled: Color(0xFF69758D),
    success: Color(0xFF70C99A),
    warning: Color(0xFFF2C16D),
    error: Color(0xFFF08089),
    info: Color(0xFF83B5FF),
  );

  static AppPalette of(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? dark : light;
}
