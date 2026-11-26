import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/country_info.dart';
import 'package:giachero_gaia_yologo/models/trip.dart';
import 'package:giachero_gaia_yologo/models/weather.dart';
import 'package:giachero_gaia_yologo/screens/add_trip_screen.dart';
import 'package:giachero_gaia_yologo/services/country_service.dart';
import 'package:giachero_gaia_yologo/services/trip_service.dart';
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
  final VoidCallback? onToggleFavorite;
  final bool isOwner;
  final VoidCallback? onEditTap;
  final String? userId;

  const TripDetailScreen({
    required this.trip,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.isOwner = false,
    this.onEditTap,
    this.userId,
    super.key,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late bool _isFavorite;
  CountryInfo? _countryInfo;
  WeatherResult? _weatherResult;
  bool _isLoadingExtras = true;

  late Trip _trip;
  bool _wasUpdated = false;

  Future<void> _loadDetails() async {
    final resultCountry = await CountryService.getCountryInfoForCity(
      _trip.city,
    );
    final resultWeather = await WeatherService.getWeatherForTrip(
      city: _trip.city,
      departureDate: _trip.departureDate,
      returnDate: _trip.returnDate,
    );
    if (!mounted) return;
    setState(() {
      _countryInfo = resultCountry;
      _weatherResult = resultWeather;
      _isLoadingExtras = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _trip = widget.trip;
    _loadDetails();
  }

  Future<void> _openEditScreen() async {
    final userId = widget.userId;
    if (userId == null) return;

    final result = await Navigator.of(context).push<EditTripResult>(
      MaterialPageRoute(
        builder: (_) => AddTripScreen(userId: userId, trip: _trip),
      ),
    );

    if (!mounted) return;

    switch (result) {
      case EditTripResult.deleted:
        Navigator.of(context).pop(EditTripResult.deleted);
      case EditTripResult.updated:
        final updatedTrip = await TripService.fetchTripsById(_trip.id);
        if (updatedTrip != null && mounted) {
          setState(() {
            _trip = updatedTrip;
            _wasUpdated = true;
            _isLoadingExtras = true;
          });
          _loadDetails();
        }
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = _countryInfo;
    final weatherResult = _weatherResult;
    final forecasts =
        weatherResult != null &&
            weatherResult.status == WeatherStatus.available &&
            weatherResult.forecasts.isNotEmpty
        ? weatherResult.forecasts
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.of(context).background,
        elevation: 0,
        leadingWidth: 40 + AppSizes.paddingHorizontalPage,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSizes.paddingHorizontalPage),
          child: IconButton(
            onPressed: () =>
                Navigator.of(context)
                    .pop(_wasUpdated ? EditTripResult.updated : null),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        actionsPadding: const EdgeInsets.only(
          right: AppSizes.paddingHorizontalPage,
        ),
        actions: [
          if (widget.isOwner)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.of(context).textPrimary,
              onPressed: _openEditScreen,
            )
          else if (widget.onToggleFavorite != null)
            IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline),
              color: _isFavorite
                  ? AppColors.of(context).accent
                  : AppColors.of(context).textSecondary,
              onPressed: () {
                widget.onToggleFavorite?.call();
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
          AppSizes.paddingBottomPageDetails,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.imageRadiusDetail),
              child: Image.network(
                _trip.imageUrl ?? '',
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
              _trip.title,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.gapDetailsText),
            Row(
              children: [
                Text(
                  _trip.city,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
                if (country != null)
                  Text(
                    ', ${country.name}',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.gapDetailsText),
            Text(
              '${_trip.type.label} • Persone: 1',
              style: AppTextStyles.body.copyWith(
                color: AppColors.of(context).textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.gapDetails),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.of(context).border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.sectionRadius),
                    color: AppColors.of(context).surfaceVariant,
                  ),
                  padding: EdgeInsets.all(AppSizes.paddingSection),
                  child: Text(
                    DateFormatter.formatRangeDetails(
                      _trip.departureDate,
                      _trip.returnDate,
                    ),
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.gapDatePrice),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.of(context).border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.sectionRadius),
                    color: AppColors.of(context).surfaceVariant,
                  ),
                  padding: EdgeInsets.all(AppSizes.paddingSection),
                  child: Text(
                    '${_trip.price} €',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.of(context).accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.gapDetails),
            if (_trip.description.isNotEmpty)
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
                    _trip.description,
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
            const SizedBox(height: AppSizes.gapDetailsDescription),
            if (_isLoadingExtras)
              const Center(child: CircularProgressIndicator())
            else if (country != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.of(context).border,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.sectionRadius),
                  color: AppColors.of(context).surface,
                ),
                padding: EdgeInsets.all(AppSizes.paddingSection),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        country.flagUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.flagRadius,
                                ),
                                child: Image.network(
                                  country.flagUrl,
                                  width: AppSizes.flagWidth,
                                  height: AppSizes.flagHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.flag_outlined,
                                        color: AppColors.of(context).primary,
                                      ),
                                ),
                              )
                            : Icon(
                                Icons.flag_outlined,
                                color: AppColors.of(context).primary,
                              ),
                        const SizedBox(height: AppSizes.gapDetailsText),
                        Text(
                          country.name,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.location_city_rounded,
                          color: AppColors.of(context).primary,
                        ),
                        const SizedBox(height: AppSizes.gapDetailsText),
                        Text(
                          _trip.city,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          color: AppColors.of(context).primary,
                        ),
                        const SizedBox(height: AppSizes.gapDetailsText),
                        Text(
                          country.currency,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.language,
                          color: AppColors.of(context).primary,
                        ),
                        const SizedBox(height: AppSizes.gapDetailsText),
                        Text(
                          country.language,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              StatusMessage(message: AppStrings.infoError),
            const SizedBox(height: AppSizes.gapDetails),
            Text(
              AppStrings.weatherDetails,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.gapDetailsDescription),
            if (_isLoadingExtras)
              const Center(child: CircularProgressIndicator())
            else if (forecasts != null)
              SizedBox(
                height: 115,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecasts.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSizes.gapDate),
                  itemBuilder: (context, index) {
                    final day = forecasts[index];
                    return Container(
                      width: 100,
                      padding: EdgeInsets.all(AppSizes.paddingSection),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.of(context).border,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSizes.sectionRadius,
                        ),
                        color: AppColors.of(context).surface,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(day.icon, color: AppColors.of(context).primary),
                          const SizedBox(height: 6),
                          Text(
                            DateFormatter.formatShortDay(day.date),
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.of(context).textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.minTemp.round()}° / ${day.maxTemp.round()}°',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.of(context).textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              StatusMessage(
                message:
                    weatherResult?.statusMessage ?? AppStrings.weatherError,
              ),
          ],
        ),
      ),
    );
  }
}
