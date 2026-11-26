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

  factory CountryInfo.fromJson(
    Map<String, dynamic> json, {
    String? fallbackName,
    String? countryCode,
  }) {
    final nameField = json['name'];
    final nameMap = nameField is Map
        ? Map<String, dynamic>.from(nameField)
        : null;
    final translations = json['translations'] is Map
        ? Map<String, dynamic>.from(json['translations'])
        : null;
    final ita = translations?['ita'];

    final String countryName =
        (ita is Map ? ita['common']?.toString() : ita?.toString()) ??
        fallbackName ??
        (nameMap?['common']?.toString() ?? nameField?.toString()) ??
        'Sconosciuto';

    final flagsMap = json['flags'] is Map
        ? Map<String, dynamic>.from(json['flags'])
        : null;
    final flag =
        (flagsMap?['png']?.toString()) ??
        (countryCode != null
            ? 'https://flagcdn.com/w80/${countryCode.toLowerCase()}.png'
            : '');

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

    if (first is String && first.isNotEmpty) return first;
    if (first is Map) {
      for (final key in ['name', 'common', 'english_name']) {
        final text = first[key]?.toString();
        if (text != null && text.isNotEmpty) return text;
      }
    }
    return null;
  }
}
