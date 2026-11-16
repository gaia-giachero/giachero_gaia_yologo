import 'package:giachero_gaia_yologo/utils/app_strings.dart';

class Validators {
  static String? notEmpty(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.requiredField;

    return null;
  }

  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.requiredField;

    final number = int.tryParse(value.trim());
    if (number == null) return AppStrings.invalidPrice;
    if (number < 0) return AppStrings.negativePrice;
    
    return null;
  }

  static String? returnDate(DateTime? departure, DateTime? returnDate) {
    if (departure == null || returnDate == null) return AppStrings.requiredField;

    if (!returnDate.isAfter(departure)) return AppStrings.returnBeforeDeparture;

    return null;
  }

  // static String? email(String? value) {
  //   if (value == null || value.trim().isEmpty) return AppStrings.requiredField;

  //   if (!(value.contains('@'))) return AppStrings.missingCharacter;

  //   return null;
  // }

  // static String? password(String? value) {
  //   if (value == null || value.trim().isEmpty) return AppStrings.requiredField;

  //   if (value.length < 6) return AppStrings.shortPassword;

  //   return null;
  // }
}
