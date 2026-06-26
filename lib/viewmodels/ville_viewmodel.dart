import 'package:flutter/foundation.dart';
import '../models/ville.dart';
import '../services/meteo_service.dart';
import '../models/meteo_data.dart';

class VilleViewModel extends ChangeNotifier {
  List<Ville> _villes = [];
  Ville? _villeSelectionnee;

  final MeteoService _meteoService = MeteoService();
  MeteoData? _meteoActuelle;
  bool _chargement = false;
  String? _erreur;

  // --- EXERCICE C : LE CACHE LOCAL ---
  // Associe un nom de ville à ses données météo et son heure de capture
  final Map<String, (MeteoData, DateTime)> _cacheMeteo = {};

  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee => _villeSelectionnee;
  MeteoData? get meteoActuelle => _meteoActuelle;
  bool        get chargement    => _chargement;
  String?     get erreur        => _erreur;

  VilleViewModel() {
    _initialiser();
    if (_villeSelectionnee != null) {
      selectionnerVille(_villeSelectionnee!);
    }
  }

  void _initialiser() {
    _villes = [
      Ville(nom: 'Cotonou', pays: 'Benin', temperature: 29, condition: 'Ensoleille', humidite: 75),
      Ville(nom: 'Parakou', pays: 'Benin', temperature: 32, condition: 'Ensoleille', humidite: 60),
      Ville(nom: 'Lagos', pays: 'Nigeria', temperature: 31, condition: 'Nuageux', humidite: 80),
      Ville(nom: 'Abidjan', pays: 'CI', temperature: 27, condition: 'Pluvieux', humidite: 85),
      
      Ville(nom: 'Nattitingou', pays: 'Bénin', temperature: 24.0, condition: 'Orageux', humidite: 90),
      Ville(nom: 'Tanguiéta', pays: 'Bénin', temperature: 26.0, condition: 'Ventueux', humidite: 65),
  
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
    _villeSelectionnee = _villes.first;
    notifyListeners(); 
  }

  // Gère la sélection et la vérification du cache
  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;
    _erreur = null;

    // --- ALGORITHME DU CACHE (EXERCICE C) ---
    if (_cacheMeteo.containsKey(ville.nom)) {
      final (meteoSauvegardee, heureEnregistrement) = _cacheMeteo[ville.nom]!;
      final dureeEcoulee = DateTime.now().difference(heureEnregistrement);

      // Si chargé il y a moins de 30 minutes, on prend le cache sans appeler l'API
      if (dureeEcoulee.inMinutes < 30) {
        print('[CACHE] Récupération des données en cache pour : ${ville.nom} (${dureeEcoulee.inMinutes} min écoulées)');
        _meteoActuelle = meteoSauvegardee;
        _chargement = false;
        notifyListeners();
        return; // Fin prématurée de la fonction !
      }
    }

    // Si pas de cache ou cache expiré -> Appel réseau standard
    print('[API] Chargement des données fraîches sur Internet pour : ${ville.nom}');
    _chargement = true;
    notifyListeners();

    final meteo = await _meteoService.getMeteo(ville.nom);

    if (meteo != null) {
      _meteoActuelle = meteo;
      // Mise en cache des données fraîches avec l'heure actuelle
      _cacheMeteo[ville.nom] = (meteo, DateTime.now());
    } else {
      _erreur = 'Impossible de charger la meteo';
    }
    _chargement = false;
    notifyListeners();
  }
  
  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }
}
