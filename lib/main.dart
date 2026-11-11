import 'package:flutter/material.dart';
// import 'package:giachero_gaia_yologo/screens/auth/login_screen.dart';
import 'package:giachero_gaia_yologo/screens/widget_test_screen.dart';
import 'package:giachero_gaia_yologo/theme/app_theme.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const WidgetTestScreen(),
    ),
  );
}