class Ville {
  // Propriétés de la ville (déclarées avec 'final' car elles sont immuables)
  final String nom;
  final String pays;
  final double temperature; // Température enregistrée en degrés Celsius
  final String condition;   // Conditions météo : "Ensoleille", "Nuageux", "Pluvieux"
  final int humidite;       // Taux d'humidité en pourcentage (0-100)

  // Constructeur de la classe avec paramètres nommés et obligatoires
  Ville({
    required this.nom,
    required this.pays,
    required this.temperature,
    required this.condition,
    required this.humidite,
  });
}
