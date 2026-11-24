class CountryInfo {
  final String name;
  final String flagUrl;
  final String currency;
  final String language;

  const CountryInfo({
    required this.name,
    required this.flagUrl,
    required this.currency,
    required this.language,
  });

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    // 1. Country name
    final names = json['names'] as Map<String, dynamic>?;
    final translations = names?['translations'] as Map<String, dynamic>?;
    final ita = translations?['ita'] as Map<String, dynamic>?;
    final countryName =
        (ita?['common'] as String?) ??
        (names?['common'] as String?) ??
        'Sconosciuto';

    // 2. Flag
    final flagMap = json['flag'] as Map<String, dynamic>?;
    final rawFlag = flagMap?['url_png'] as String? ?? '';
    final flag = rawFlag.replaceFirst(
      'https://flags.restcountries.com/v5/',
      'https://flagcdn.com/',
    );

    // 3. Currencies and Language
    return CountryInfo(
      name: countryName,
      flagUrl: flag,
      currency: _firstName(json['currencies']) ?? 'Non disponibile',
      language: _firstName(json['languages']) ?? 'Non disponibile',
    );
  }

  static String? _firstName(dynamic value) {
    dynamic first;
    if (value is List && value.isNotEmpty) {
      first = value.first;
    } else if (value is Map && value.isNotEmpty) {
      first = value.values.first;
    }

    if (first is String) return first;
    if (first is Map<String, dynamic>) {
      for (final key in ['name', 'common', 'english_name']) {
        final text = first[key];
        if (text is String && text.isNotEmpty) return text;
      }
    }
    return null;
  }
}
