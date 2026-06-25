import 'package:flutter/foundation.dart';
import '../models/ville.dart';

// Le ViewModel hérite de ChangeNotifier pour pouvoir notifier l'interface des changements
class VilleViewModel extends ChangeNotifier {
  
  // Liste privée des villes disponibles dans l'application
  List<Ville> _villes = [];

  // Variable privée pour stocker la ville actuellement sélectionnée par l'utilisateur
  Ville? _villeSelectionnee;

  // Getters permettant à la Vue (UI) de lire les données privées sans les modifier
  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee => _villeSelectionnee;

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
    ];

    // Par défaut, la première ville de la liste (Cotonou) est sélectionnée
    _villeSelectionnee = _villes.first;
    
    // Alerte les widgets à l'écoute (les consommateurs) qu'ils doivent se redessiner
    notifyListeners(); 
  }

  // Méthode publique pour changer la ville affichée à l'écran
  void selectionnerVille(Ville ville) {
    _villeSelectionnee = ville;
    
    // Notification indispensable après chaque modification de données
    notifyListeners();
  }
}
