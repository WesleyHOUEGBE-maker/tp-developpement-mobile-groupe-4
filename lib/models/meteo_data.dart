class MeteoData {
  final double temperature; // temperature en Celsius
  final int humidite;       // humidite en %
  final int weatherCode;    // code WMO (0=ensoleille, 61=pluvieux...)

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
  });

  // Creer un MeteoData depuis la reponse JSON de l'API
  factory MeteoData.fromJson(Map<String, dynamic> json) {
    return MeteoData(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidite: (json['relative_humidity_2m'] as num).toInt(),
      weatherCode: (json['weathercode'] as num).toInt(),
    );
  }

  // Convertir le code WMO en texte lisible
  String get conditionTexte {
    if (weatherCode == 0)                   return 'Ensoleille';
    if (weatherCode <= 3)                   return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95)                  return 'Orageux';
    return 'Variable';
  }
}
