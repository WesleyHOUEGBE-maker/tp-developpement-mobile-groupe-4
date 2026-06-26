import 'package:flutter/foundation.dart';
import '../models/ville.dart';
import '../services/meteo_service.dart';
import '../models/meteo_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VilleViewModel extends ChangeNotifier {
  List<Ville> _villes = [];
  Ville?      _villeSelectionnee;

  final MeteoService _meteoService = MeteoService();
  MeteoData? _meteoActuelle;
  bool       _chargement = false;
  String?    _erreur;

  final Map<String, (MeteoData, DateTime)> _cacheMeteo = {};

  List<Ville> get villes           => _villes;
  Ville?      get villeSelectionnee => _villeSelectionnee;
  MeteoData?  get meteoActuelle     => _meteoActuelle;
  bool        get chargement        => _chargement;
  String?     get erreur            => _erreur;

  VilleViewModel() {
    _initialiser();
  }

  void _initialiser() {
    _villes = [
      // ✅ CORRECTION 5 : Lagos en double supprimé, on garde une seule entrée par nom
      Ville(nom: 'Cotonou',         pays: 'Bénin',          temperature: 29,   condition: 'Ensoleillé',  humidite: 75),
      Ville(nom: 'Parakou',         pays: 'Bénin',          temperature: 32,   condition: 'Ensoleillé',  humidite: 60),
      Ville(nom: 'Lagos',           pays: 'Nigéria',        temperature: 31,   condition: 'Nuageux',     humidite: 80),
      Ville(nom: 'Abidjan',         pays: 'Côte d\'Ivoire', temperature: 27,   condition: 'Pluvieux',    humidite: 85),
      Ville(nom: 'Nattitingou',     pays: 'Bénin',          temperature: 24.0, condition: 'Orageux',     humidite: 90),
      Ville(nom: 'Tanguiéta',       pays: 'Bénin',          temperature: 26.0, condition: 'Ventueux',    humidite: 65),
      Ville(nom: 'Lomé',            pays: 'Togo',           temperature: 31.0, condition: 'Ensoleillé',  humidite: 78),
      Ville(nom: 'Kara',            pays: 'Togo',           temperature: 29.0, condition: 'Nuageux',     humidite: 65),
      Ville(nom: 'Abuja',           pays: 'Nigéria',        temperature: 33.0, condition: 'Ensoleillé',  humidite: 40),
      Ville(nom: 'Dakar',           pays: 'Sénégal',        temperature: 26.0, condition: 'Ventueux',    humidite: 75),
      Ville(nom: 'Saint-Louis',     pays: 'Sénégal',        temperature: 25.0, condition: 'Ventueux',    humidite: 70),
      Ville(nom: 'Yamoussoukro',    pays: 'Côte d\'Ivoire', temperature: 32.0, condition: 'Orageux',     humidite: 60),
      Ville(nom: 'Ouagadougou',     pays: 'Burkina Faso',   temperature: 35.0, condition: 'Ensoleillé',  humidite: 30),
      Ville(nom: 'Bobo-Dioulasso',  pays: 'Burkina Faso',   temperature: 31.0, condition: 'Nuageux',     humidite: 55),
      Ville(nom: 'Paris',           pays: 'France',         temperature: 18.0, condition: 'Nuageux',     humidite: 80),
      Ville(nom: 'Marseille',       pays: 'France',         temperature: 24.0, condition: 'Ensoleillé',  humidite: 50),
      Ville(nom: 'Montréal',        pays: 'Canada',         temperature: 15.0, condition: 'Pluvieux',    humidite: 88),
      Ville(nom: 'Vancouver',       pays: 'Canada',         temperature: 14.0, condition: 'Nuageux',     humidite: 90),
      Ville(nom: 'Rio de Janeiro',  pays: 'Brésil',         temperature: 27.0, condition: 'Ensoleillé',  humidite: 73),
      Ville(nom: 'São Paulo',       pays: 'Brésil',         temperature: 22.0, condition: 'Orageux',     humidite: 80),
      Ville(nom: 'Tokyo',           pays: 'Japon',          temperature: 21.0, condition: 'Nuageux',     humidite: 65),
      Ville(nom: 'Kyoto',           pays: 'Japon',          temperature: 20.0, condition: 'Pluvieux',    humidite: 70),
      Ville(nom: 'Marrakech',       pays: 'Maroc',          temperature: 34.0, condition: 'Ensoleillé',  humidite: 25),
      Ville(nom: 'Casablanca',      pays: 'Maroc',          temperature: 23.0, condition: 'Ventueux',    humidite: 70),
    ];

    _villeSelectionnee = _villes.first;
    notifyListeners();

    // ✅ CORRECTION 6 : chargement de la ville par défaut au démarrage
    selectionnerVille(_villeSelectionnee!);
  }

  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;
    _erreur = null;

    if (_cacheMeteo.containsKey(ville.nom)) {
      final (meteoSauvegardee, heureEnregistrement) = _cacheMeteo[ville.nom]!;
      final dureeEcoulee = DateTime.now().difference(heureEnregistrement);

      if (dureeEcoulee.inMinutes < 30) {
        print('[CACHE] ${ville.nom} (${dureeEcoulee.inMinutes} min)');
        _meteoActuelle = meteoSauvegardee;
        _chargement    = false;
        notifyListeners();
        return;
      }
    }

    print('[API] Chargement pour : ${ville.nom}');
    _chargement    = true;
    _meteoActuelle = null;
    notifyListeners();

    final meteo = await _meteoService.getMeteo(ville.nom);
    

    if (meteo != null) {
      _meteoActuelle        = meteo;
      _cacheMeteo[ville.nom] = (meteo, DateTime.now());
    } else {
      _erreur = 'Impossible de charger la météo';
    }

    _chargement = false;
    notifyListeners();
  }
  
  Future<void> _verifierAlerteChaleur() async {
  if (_meteoActuelle == null) return;
  if (_meteoActuelle!.temperature > 33) {
    final plugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails details =
        AndroidNotificationDetails(
      'canal_alerte', 'Alertes Meteo',
      importance: Importance.high, priority: Priority.high,
    );

    await plugin.show(
      1,
      'Alerte chaleur !',
      'Il fait ${_meteoActuelle!.temperature.toStringAsFixed(0)}°C a ${_villeSelectionnee!.nom}',
      NotificationDetails(android: details),
    );
  }
}

  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }
  
  
  void mettreAJourPhoto(StringcheminPhoto) {
if (_villeSelectionnee == null) return;
// Trouver l'index de la ville dans la liste
final index = _villes.indexWhere ((v) => v.nom ==
_villeSelectionnee !.nom);

if (index ==-1) return;
// Creer une copie avec la nouvelle photo
_villes[index] = _villes[index ]. copierAvecPhoto(cheminPhoto);
_villeSelectionnee = _villes[index ];
notifyListeners (); // prevenir les widgets

  }
}