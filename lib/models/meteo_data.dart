import 'prevision_jour.dart';

class MeteoData {
  final double temperature;   // Température en Celsius
  final int humidite;         // Humidité en %
  final int weatherCode;      // Code WMO (0=ensoleille, 61=pluvieux...)
  final String dateHeureRaw;  // Date et heure brute de l'API ("YYYY-MM-DDTHH:MM")
  
  // --- EXERCICE B : Liste de prévisions sur 3 jours ---
  final List<PrevisionJour> previsions;

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
    required this.dateHeureRaw,
    required this.previsions,
  });

  // La factory reçoit le JSON complet de l'API (pour lire 'current' ET 'daily')
    factory MeteoData.fromJson(Map<String, dynamic> json) {
    // 1. Extraction des données actuelles ('current')
    final currentJson = json['current'] ?? json['current_weather'] as Map<String, dynamic>;
    
    // 2. Extraction des données de prévisions ('daily')
    final List<PrevisionJour> listePrevisions = [];
    
    if (json['daily'] != null) {
      final dailyJson = json['daily'] as Map<String, dynamic>;
      
      final listDates = dailyJson['time'] as List<dynamic>;
      final listMax = dailyJson['temperature_2m_max'] as List<dynamic>;
      final listMin = dailyJson['temperature_2m_min'] as List<dynamic>;
      
      // SÉCURITÉ CORRIGÉE : On met des parenthèses pour que le cast s'applique bien sur le résultat du ??
      final listCodes = (dailyJson['weather_code'] ?? dailyJson['weathercode']) as List<dynamic>;

      // On extrait uniquement les 3 premiers jours requis par l'Exercice B
      for (int i = 0; i < 3 && i < listDates.length; i++) {
        listePrevisions.add(PrevisionJour(
          date: listDates[i] as String,
          tempMax: (listMax[i] as num).toDouble(),
          tempMin: (listMin[i] as num).toDouble(),
          weatherCode: (listCodes[i] as num).toInt(),
        ));
      }
    }

    // 3. Retour de l'objet complet fusionné
    return MeteoData(
      temperature: ((currentJson['temperature_2m'] ?? currentJson['temperature']) as num).toDouble(),
      humidite: (currentJson['relative_humidity_2m'] as num).toInt(),
      // SÉCURITÉ AJOUTÉE : Parenthèses ici aussi pour le code météo actuel
      weatherCode: ((currentJson['weather_code'] ?? currentJson['weathercode']) as num).toInt(),
      dateHeureRaw: currentJson['time'] as String, // <- AJOUT EXERCICE A
      previsions: listePrevisions,                // <- AJOUT EXERCICE B
    );
  


    // 3. Retour de l'objet complet fusionné
    return MeteoData(
      temperature: (currentJson['temperature_2m'] as num).toDouble(),
      humidite: (currentJson['relative_humidity_2m'] as num).toInt(),
      weatherCode: (currentJson['weather_code'] ?? currentJson['weathercode'] as num).toInt(),
      dateHeureRaw: currentJson['time'] as String, // <- AJOUT EXERCICE A
      previsions: listePrevisions,                // <- AJOUT EXERCICE B
    );
  }
  
  // --- AJOUT EXERCICE A : Transformer "2026-06-21T15:00" en "21/06/2026 à 15h00" ---
  String get dateHeureFormatee {
    try {
      // Découpage de la chaîne de l'API : "YYYY-MM-DDTHH:MM"
      final parties = dateHeureRaw.split('T');
      final datePartie = parties[0]; // "2026-06-21"
      final heurePartie = parties[1]; // "15:00"

      final composantsDate = datePartie.split('-');
      final annee = composantsDate[0];
      final mois = composantsDate[1];
      final jour = composantsDate[2];

      final composantsHeure = heurePartie.split(':');
      final heure = composantsHeure[0];
      final minute = composantsHeure[1];

      return 'Mesure du $jour/$mois/$annee à ${heure}h$minute';
    } catch (e) {
      return 'Date indisponible';
    }
  }

  // Convertir le code WMO actuel en texte lisible
  String get conditionTexte {
    if (weatherCode == 0)                       return 'Ensoleille';
    if (weatherCode <= 3)                       return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95)                      return 'Orageux';
    return 'Variable';
  }
}
