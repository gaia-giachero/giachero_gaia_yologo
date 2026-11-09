import 'package:flutter/painting.dart';

class AppTextStyles {
  static const String manrope = 'Manrope';
  static const String atma = 'Atma';

  static const TextStyle display = TextStyle(
    fontFamily: manrope,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: manrope,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 28 / 36,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: manrope,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: manrope,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: manrope,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: manrope,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: manrope,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle body = TextStyle(
    fontFamily: manrope,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static const TextStyle label = TextStyle(
    fontFamily: manrope,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: manrope,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  static const TextStyle small = TextStyle(
    fontFamily: manrope,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
  );

  static const TextStyle brandTitle = TextStyle(
    fontFamily: atma,
    fontSize: 42,
    fontWeight: FontWeight.w700,
    height: 45 / 42,
    letterSpacing: 42*0.05,
  );

  static const TextStyle price = TextStyle(
    fontFamily: manrope,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
  );
}
