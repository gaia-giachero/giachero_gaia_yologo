import 'package:flutter/material.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pagina dettaglio'),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Torna alla home'),
            ),
          ],
        ),
      ),
    );
  }
}
