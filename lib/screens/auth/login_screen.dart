import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/screens/main_shell_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Accedi'),
            const SizedBox(height: 15),
            FilledButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const MainShellScreen(),
                ),
              ),
              child: const Text(AppStrings.loginButton),
            ),
          ],
        ),
      ),
    );
  }
}
