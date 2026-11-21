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
    // 1. Nome paese (italiano se presente, altrimenti comune)
    final names = json['names'] as Map<String, dynamic>?;
    final translations = names?['translations'] as Map<String, dynamic>?;
    final ita = translations?['ita'] as Map<String, dynamic>?;
    final countryName =
        (ita?['common'] as String?) ??
        (names?['common'] as String?) ??
        'Sconosciuto';

    // 2. Bandiera
    final flagMap = json['flag'] as Map<String, dynamic>?;
    final flag = flagMap?['url_png'] as String? ?? '';

    // 3. Valuta e lingua
    return CountryInfo(
      name: countryName,
      flagUrl: flag,
      currency: _firstName(json['currencies']) ?? 'Non disponibile',
      language: _firstName(json['languages']) ?? 'Non disponibile',
    );
  }

  // Legge il primo elemento di una lista o mappa e ne estrae un nome leggibile.
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
