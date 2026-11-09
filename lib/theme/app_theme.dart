import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static final ThemeData light = _build(AppColors.light, Brightness.light);
  static final ThemeData dark = _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness b) {
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      scaffoldBackgroundColor: p.background,
      colorScheme: ColorScheme(
        brightness: b,
        primary: p.primary,
        onPrimary: p.surface,
        secondary: p.accent,
        onSecondary: p.surface,
        error: p.error,
        onError: p.surface,
        surface: p.surface,
        onSurface: p.textPrimary,
        onSurfaceVariant: p.textSecondary,
        surfaceContainerHighest: p.surfaceVariant,
        outlineVariant: p.border,
      ),
      textTheme: _textTheme(p),
    );
  }

  static TextTheme _textTheme(AppPalette p) {
    return const TextTheme(
      displayLarge: AppTextStyles.display,
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,
      titleLarge: AppTextStyles.h4,
      titleMedium: AppTextStyles.cardTitle,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.label,
      bodySmall: AppTextStyles.caption,
      labelSmall: AppTextStyles.small,
    ).apply(bodyColor: p.textPrimary, displayColor: p.textPrimary);
  }
}
