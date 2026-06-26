

class PrevisionJour {
  final String date;          // Format renvoyé par l'API : "2026-06-27"
  final double tempMax;       // Température maximale de la journée
  final double tempMin;       // Température minimale de la journée
  final int weatherCode;      // Code WMO pour l'icône et la condition

  PrevisionJour({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  // Convertit le code WMO en texte lisible pour les prévisions
  String get conditionTexte {
    if (weatherCode == 0)                      return 'Ensoleillé';
    if (weatherCode <= 3)                      return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95)                     return 'Orageux';
    return 'Variable';
  }

  // Formatage de la date "2026-06-27" vers un format plus compact "27/06"
  String get dateFormatee {
    try {
      final morceaux = date.split('-');
      return '${morceaux[2]}/${morceaux[1]}';
    } catch (e) {
      return date;
    }
  }
}
