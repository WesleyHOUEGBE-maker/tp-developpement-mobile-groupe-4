import 'package:flutter/foundation.dart';
import '../models/ville.dart';
import '../services/meteo_service.dart';
import '../models/meteo_data.dart';

// Le ViewModel hérite de ChangeNotifier pour pouvoir notifier l'interface des changements
class VilleViewModel extends ChangeNotifier {
  
  // Liste privée des villes disponibles dans l'application
  List<Ville> _villes = [];

  // Variable privée pour stocker la ville actuellement sélectionnée par l'utilisateur
  Ville? _villeSelectionnee;

  final MeteoService _meteoService = MeteoService();
  MeteoData? _meteoActuelle;
  bool _chargement = false;
  String? _erreur;

  // Getters permettant à la Vue (UI) de lire les données privées sans les modifier
  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee => _villeSelectionnee;

  MeteoData? get meteoActuelle => _meteoActuelle;
  bool        get chargement    => _chargement;
  String?     get erreur        => _erreur;

  // Constructeur du ViewModel : charge les données météo dès le démarrage
  VilleViewModel() {
    _initialiser();
  }

  // Méthode privée pour remplir la liste de données brutes
  void _initialiser() {
    _villes = [
      Ville(nom: 'Cotonou', pays: 'Benin', temperature: 29, condition: 'Ensoleille', humidite: 75),
      Ville(nom: 'Parakou', pays: 'Benin', temperature: 32, condition: 'Ensoleille', humidite: 60),
      Ville(nom: 'Lagos', pays: 'Nigeria', temperature: 31, condition: 'Nuageux', humidite: 80),
      Ville(nom: 'Abidjan', pays: 'CI', temperature: 27, condition: 'Pluvieux', humidite: 85),
      
      Ville(nom: 'Nattitingou', pays: 'Bénin', temperature: 24.0, condition: 'Orageux', humidite: 90), // Test Orageux
      
  Ville(nom: 'Tanguiéta', pays: 'Bénin', temperature: 26.0, condition: 'Ventueux', humidite: 65), // Test Ventueux
  
  
  // ajout personnel de villeSelectionnee
  
  Ville(nom: 'Lomé', pays: 'Togo', temperature: 31.0, condition: 'Ensoleillé', humidite: 78),
Ville(nom: 'Kara', pays: 'Togo', temperature: 29.0, condition: 'Nuageux', humidite: 65),
Ville(nom: 'Lagos', pays: 'Nigéria', temperature: 30.0, condition: 'Pluvieux', humidite: 85),
Ville(nom: 'Abuja', pays: 'Nigéria', temperature: 33.0, condition: 'Ensoleillé', humidite: 40),
Ville(nom: 'Dakar', pays: 'Sénégal', temperature: 26.0, condition: 'Ventueux', humidite: 75),
Ville(nom: 'Saint-Louis', pays: 'Sénégal', temperature: 25.0, condition: 'Ventueux', humidite: 70),
Ville(nom: 'Abidjan', pays: 'Côte d\'Ivoire', temperature: 28.0, condition: 'Pluvieux', humidite: 82),
Ville(nom: 'Yamoussoukro', pays: 'Côte d\'Ivoire', temperature: 32.0, condition: 'Orageux', humidite: 60),
Ville(nom: 'Ouagadougou', pays: 'Burkina Faso', temperature: 35.0, condition: 'Ensoleillé', humidite: 30),
Ville(nom: 'Bobo-Dioulasso', pays: 'Burkina Faso', temperature: 31.0, condition: 'Nuageux', humidite: 55),
Ville(nom: 'Paris', pays: 'France', temperature: 18.0, condition: 'Nuageux', humidite: 80),
Ville(nom: 'Marseille', pays: 'France', temperature: 24.0, condition: 'Ensoleillé', humidite: 50),
Ville(nom: 'Montréal', pays: 'Canada', temperature: 15.0, condition: 'Pluvieux', humidite: 88),
Ville(nom: 'Vancouver', pays: 'Canada', temperature: 14.0, condition: 'Nuageux', humidite: 90),
Ville(nom: 'Rio de Janeiro', pays: 'Brésil', temperature: 27.0, condition: 'Ensoleillé', humidite: 73),
Ville(nom: 'São Paulo', pays: 'Brésil', temperature: 22.0, condition: 'Orageux', humidite: 80),
Ville(nom: 'Tokyo', pays: 'Japon', temperature: 21.0, condition: 'Nuageux', humidite: 65),
Ville(nom: 'Kyoto', pays: 'Japon', temperature: 20.0, condition: 'Pluvieux', humidite: 70),
Ville(nom: 'Marrakech', pays: 'Maroc', temperature: 34.0, condition: 'Ensoleillé', humidite: 25),
Ville(nom: 'Casablanca', pays: 'Maroc', temperature: 23.0, condition: 'Ventueux', humidite: 70),

    ];

    // Par défaut, la première ville de la liste (Cotonou) est sélectionnée
    _villeSelectionnee = _villes.first;
    
    // Alerte les widgets à l'écoute (les consommateurs) qu'ils doivent se redessiner
    notifyListeners(); 
  }

  // Charger la vraie meteo quand on selectionne une ville
  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;
    _chargement = true;
    _erreur = null;
    notifyListeners();

    final meteo = await _meteoService.getMeteo(ville.nom);

    if (meteo != null) {
      _meteoActuelle = meteo;
    } else {
      _erreur = 'Impossible de charger la meteo';
    }
    _chargement = false;
    notifyListeners();
  }
  
  
  
    // --- EXERCICE C : AJOUTER UNE VILLE MANUELLEMENT ---
  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners(); // Informe l'application pour reconstruire la liste immédiatement
  }


}
