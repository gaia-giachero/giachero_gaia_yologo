import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/screens/auth/login_screen.dart';
import 'package:giachero_gaia_yologo/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isDark = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentMode,
          scrollBehavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          home: const LoginScreen(),
        );
      },
    ),
  );
}