class Ville {
  // Propriétés de la ville (déclarées avec 'final' car elles sont immuables)
  final String nom;
  final String pays;
  final double temperature; // Température enregistrée en degrés Celsius
  final String condition;   // Conditions météo : "Ensoleille", "Nuageux", "Pluvieux"
  final int humidite;       // Taux d'humidité en pourcentage (0-100)
  
  final String? photoPath; // <- NOUVEAU : chemin vers la photo

  // Constructeur de la classe avec paramètres nommés et obligatoires
  Ville({
    required this.nom,
    required this.pays,
    required this.temperature,
    required this.condition,
    required this.humidite,
    this.photoPath,
  });
  
  // Copier la ville avec une nouvelle photo (Correction de l'espace ici)
  Ville copierAvecPhoto(String chemin) {
    return Ville(
      nom: nom, 
      pays: pays, 
      temperature: temperature,
      condition: condition, 
      humidite: humidite,
      photoPath: chemin,
    );
  } 
}
