import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/theme/app_theme.dart';

void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light, 
      home: const FontTestScreen(),
    ),
  );
}

class FontTestScreen extends StatelessWidget {
  const FontTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DOVE ANDRAI DOMANI?', style: AppTextStyles.brandTitle),
            const SizedBox(height: 16),
            const Text('Pronto ad esplorare?', style: AppTextStyles.display),
            const SizedBox(height: 16),
            const Text('Testo normale di prova', style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
