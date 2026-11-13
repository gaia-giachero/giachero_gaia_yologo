import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/trip_type.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/utils/price_formatter.dart';
import 'package:giachero_gaia_yologo/widgets/app_text_field.dart';
import 'package:giachero_gaia_yologo/widgets/popular_destination_item.dart';
import 'package:giachero_gaia_yologo/widgets/search_filter_bar.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';
import 'package:giachero_gaia_yologo/widgets/trip_card.dart';
import 'package:giachero_gaia_yologo/widgets/trip_image.dart';
import 'package:giachero_gaia_yologo/widgets/trip_type_chip.dart';

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
                'Data singola: ${DateFormatter.formatta(sampleTrips[0].createdAt)}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              Text(
                'Intervallo viaggi: ${DateFormatter.formatRange(sampleTrips[0].departureDate, sampleTrips[0].returnDate)}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              Text(
                'Data nulla (fallback): ${DateFormatter.formatta(null)}',
                style: TextStyle(color: AppColors.of(context).primary),
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
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
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              StatusMessage(
                message: AppStrings.addError,
                textButton: AppStrings.errorButton,
                onPressed: () {},
                buttonColor: AppColors.of(context).error,
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              StatusMessage(message: AppStrings.addError),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              StatusMessage(
                message: AppStrings.addError,
                textButton: AppStrings.errorButton,
                onPressed: null,
                buttonColor: AppColors.of(context).disabled,
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              SizedBox(
                width: 320,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.imageRadius),
                  child: TripImage(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuUYitDsMSaKcmH445tll7s9tVuKJSp9wThA43Wr_mIvhaJG-_Lkh9DHE&s=10',
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: 60,
                child: ClipOval(
                  child: TripImage(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuUYitDsMSaKcmH445tll7s9tVuKJSp9wThA43Wr_mIvhaJG-_Lkh9DHE&s=10',
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 320,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.imageRadius),
                  child: TripImage(
                    imageUrl: 'https://ted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuUYitDsMSaKcmH445tll7s9tVuKJSp9wThA43Wr_mIvhaJG-_Lkh9DHE&s=10',
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 320,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.imageRadius),
                  child: TripImage(),
                ),
              ),
              SizedBox(height: 20),
              TripCard(trip: sampleTrips[0]),
              SizedBox(height: 5),
              TripCard(
                trip: sampleTrips[0],
                isFavorite: true,
                onFavoriteTap: () {},
              ),
              SizedBox(height: 5),
              TripCard(
                trip: sampleTrips[1],
                isFavorite: false,
                onFavoriteTap: () {},
              ),
              SizedBox(height: 5),
              TripCard(trip: sampleTrips[2], onEditTap: () {}),
              SizedBox(height: 5),
              TripCard(
                trip: sampleTrips[0],
                variant: TripCardVariant.horizontal,
                onFavoriteTap: () {},
              ),
              SizedBox(height: 20),
              PopularDestinationItem(
                city: 'Barcellona',
                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuUYitDsMSaKcmH445tll7s9tVuKJSp9wThA43Wr_mIvhaJG-_Lkh9DHE&s=10',
              ),
              SizedBox(height: 20),
              SearchFilterBar(),
              SizedBox(height: 20),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  TripTypeChip(
                    type: TripType.backpacking,
                    isSelected: false,
                    onTap: (value) => false,
                  ),
                  TripTypeChip(
                    type: TripType.cityAndCulture,
                    isSelected: true,
                    onTap: (value) => true,
                  ),
                  TripTypeChip(
                    type: TripType.natureAndAdventure,
                    isSelected: false,
                    onTap: (value) => false,
                  ),
                  TripTypeChip(
                    type: TripType.seaAndRelax,
                    isSelected: false,
                    onTap: (value) => false,
                  ),
                  TripTypeChip(
                    type: TripType.onTheRoad,
                    isSelected: false,
                    onTap: (value) => false,
                  ),
                  SizedBox(height: 20,),
                  AppTextField(labelText: 'Email', hintText: 'Inserisci l\'email',),
                  AppTextField(labelText: 'Password', isPassword: true, hintText: 'Inserisci la password',),
                  AppTextField(labelText: 'Destinazione', isRequired: true, hintText: 'Inserisci la destinazione',)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
