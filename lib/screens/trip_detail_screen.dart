import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/country_info.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/weather.dart';
import 'package:giachero_gaia_yologo/services/country_service.dart';
import 'package:giachero_gaia_yologo/services/weather_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/date_formatter.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/status_message.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const TripDetailScreen({
    required this.trip,
    required this.isFavorite,
    required this.onToggleFavorite,
    super.key,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late bool _isFavorite;
  CountryInfo? _countryInfo;
  Weather? _weather;
  bool _isLoadingExtras = true;

  Future<void> _loadDetails() async {
    final resultCountry = await CountryService.getCountryInfoForCity(
      widget.trip.city,
    );
    final resultWeather = await WeatherService.getWeatherForCity(
      widget.trip.city,
    );
    if (!mounted) return;
    setState(() {
      _countryInfo = resultCountry;
      _weather = resultWeather;
      _isLoadingExtras = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    final country = _countryInfo;
    final weather = _weather;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40 + AppSizes.paddingHorizontalPage,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSizes.paddingHorizontalPage),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        actionsPadding: const EdgeInsets.only(
          right: AppSizes.paddingHorizontalPage,
        ),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline),
            color: _isFavorite
                ? AppColors.of(context).accent
                : AppColors.of(context).textSecondary,
            onPressed: () {
              widget.onToggleFavorite();
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ],
        titleSpacing: 0,
        title: Text(AppStrings.backButton),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingHorizontalPage,
          AppSizes.paddingTopPage,
          AppSizes.paddingHorizontalPage,
          AppSizes.paddingBottomPage,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.imageRadiusDetail),
              child: Image.network(
                widget.trip.imageUrl ?? '',
                fit: BoxFit.cover,
                height: AppSizes.heightImgDetails,
                width: AppSizes.widthImgDetails,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.webp',
                    width: AppSizes.widthImgDetails,
                    height: AppSizes.heightImgDetails,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.gapDetails),
            Text(
              widget.trip.title,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.gapDetailsText),
            Row(
              children: [
                Text(
                  widget.trip.city,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
                if (_countryInfo != null)
                  Text(
                    ', ${_countryInfo?.name}',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.gapDetailsText),
            Text(
              '${widget.trip.type.label} • Persone: 1',
              style: AppTextStyles.body.copyWith(
                color: AppColors.of(context).textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.gapDetails),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormatter.formatRangeDetails(
                      widget.trip.departureDate,
                      widget.trip.returnDate,
                    ),
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.gapDatePrice),
                Expanded(
                  child: Text(
                    '${widget.trip.price} €',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.of(context).accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.gapDetails),
            if (widget.trip.description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.description,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.gapDetailsDescription),
                  Text(
                    widget.trip.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: AppSizes.gapDetails),
            Text(
              AppStrings.infoDetails,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            if (_isLoadingExtras = true)
              Center(child: CircularProgressIndicator()),
            _countryInfo != null
                ? Text('Info paese')
                : StatusMessage(message: AppStrings.infoError),
            const SizedBox(height: AppSizes.gapDetails),
            Text(
              AppStrings.weatherDetails,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            if (_isLoadingExtras = true)
              Center(child: CircularProgressIndicator()),
            _weather != null
                ? Text('Meteo')
                : StatusMessage(message: AppStrings.weatherError),
          ],
        ),
      ),
    );
  }
}
