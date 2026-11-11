import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/price_formatter.dart';

import '../utils/date_formatter.dart';

import '../data/sample_trips.dart';

class WidgetTestScreen extends StatelessWidget {
  const WidgetTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PROVA DATE FORMATTER",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Data singola: ${DateFormatter.formatta(DateTime.now())}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              Text(
                'Intervallo viaggi: ${DateFormatter.formatRange(DateTime(2026, 11, 25), DateTime(2026, 12, 2))}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              Text(
                'Data nulla (fallback): ${DateFormatter.formatta(null)}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              Divider(),
              Text(
                "PROVA PRICE FORMATTER",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Prezzo: ${PriceFormatter.formatta(sampleTrips[0].price)}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              Text(
                'Prezzo nullo (fallback): ${PriceFormatter.formatta(null)}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
