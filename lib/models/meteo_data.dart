import 'prevision_jour.dart';

class MeteoData {
  final double temperature;
  final int humidite;
  final int weatherCode;
  final String dateHeureRaw;
  final List<PrevisionJour> previsions;

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
    required this.dateHeureRaw,
    required this.previsions,
  });

  factory MeteoData.fromJson(Map<String, dynamic> json) {
    // ✅ CORRECTION 1 : parenthèses autour du ?? pour que le cast s'applique au bon endroit
    final currentJson = (json['current'] ?? json['current_weather']) as Map<String, dynamic>;

    final List<PrevisionJour> listePrevisions = [];

    if (json['daily'] != null) {
      final dailyJson = json['daily'] as Map<String, dynamic>;

      final listDates = dailyJson['time'] as List<dynamic>;
      final listMax   = dailyJson['temperature_2m_max'] as List<dynamic>;
      final listMin   = dailyJson['temperature_2m_min'] as List<dynamic>;
      final listCodes = (dailyJson['weather_code'] ?? dailyJson['weathercode']) as List<dynamic>;

      for (int i = 0; i < 3 && i < listDates.length; i++) {
        listePrevisions.add(PrevisionJour(
          date:        listDates[i] as String,
          tempMax:     (listMax[i] as num).toDouble(),
          tempMin:     (listMin[i] as num).toDouble(),
          weatherCode: (listCodes[i] as num).toInt(),
        ));
      }
    }

    // ✅ CORRECTION 2 : un seul return, le doublon supprimé
    return MeteoData(
      temperature:  ((currentJson['temperature_2m'] ?? currentJson['temperature']) as num).toDouble(),
      humidite:     (currentJson['relative_humidity_2m'] as num).toInt(),
      weatherCode:  ((currentJson['weather_code'] ?? currentJson['weathercode']) as num).toInt(),
      dateHeureRaw: currentJson['time'] as String,
      previsions:   listePrevisions,
    );
  }

  String get dateHeureFormatee {
    try {
      final parties          = dateHeureRaw.split('T');
      final datePartie       = parties[0];
      final heurePartie      = parties[1];
      final composantsDate   = datePartie.split('-');
      final annee            = composantsDate[0];
      final mois             = composantsDate[1];
      final jour             = composantsDate[2];
      final composantsHeure  = heurePartie.split(':');
      final heure            = composantsHeure[0];
      final minute           = composantsHeure[1];
      return 'Mesure du $jour/$mois/$annee à ${heure}h$minute';
    } catch (e) {
      return 'Date indisponible';
    }
  }

  String get conditionTexte {
    if (weatherCode == 0)                        return 'Ensoleillé';
    if (weatherCode <= 3)                        return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67)  return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82)  return 'Averses';
    if (weatherCode >= 95)                       return 'Orageux';
    return 'Variable';
  }
}