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
    // 1. COUNTRY (preferisce il nome in italiano se presente, altrimenti inglese)
    final translations = json['translations'] as Map<String, dynamic>?;
    final itaTranslation = translations?['ita'] as Map<String, dynamic>?;
    final nameMap = json['name'] as Map<String, dynamic>?;
    final countryName =
        (itaTranslation?['common'] as String?) ??
        (nameMap?['common'] as String?) ??
        'Sconosciuto';

    // 2. FLAG PNG (or SVG)
    final flagsMap = json['flags'] as Map<String, dynamic>?;
    final flag = flagsMap?['png'] as String? ?? '';

    // 3. CURRENCY
    final currenciesMap = json['currencies'] as Map<String, dynamic>?;
    String currencyText = 'Non disponibile';
    if (currenciesMap != null && currenciesMap.isNotEmpty) {
      final firstCurrency = currenciesMap.values.first as Map<String, dynamic>?;
      final currName = firstCurrency?['name'] as String? ?? '';
      final currSymbol = firstCurrency?['symbol'] as String? ?? '';
      if (currName.isNotEmpty) {
        currencyText = currSymbol.isNotEmpty
            ? '$currName ($currSymbol)'
            : currName;
      }
    }

    // 4. LANGUAGE
    final languagesMap = json['languages'] as Map<String, dynamic>?;
    String languageText = 'Non disponibile';
    if (languagesMap != null && languagesMap.isNotEmpty) {
      languageText = languagesMap.values.first.toString();
    }

    return CountryInfo(
      name: countryName,
      flagUrl: flag,
      currency: currencyText,
      language: languageText,
    );
  }
}
