import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/screens/trip_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripDetailScreen(),
                  ),
                );
              },
              child: Text('Apri dettaglio'),
            ),
          ],
        ),
      ),
    );
  }
}
