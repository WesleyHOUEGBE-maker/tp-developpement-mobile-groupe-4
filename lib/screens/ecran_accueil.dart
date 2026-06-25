import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  // Méthode utilitaire privée pour associer une icône à chaque condition météo
  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Icons.wb_sunny; // Icône de soleil
      case 'Nuageux':
        return Icons.cloud;    // Icône de nuage
      case 'Pluvieux':
        return Icons.umbrella; // Icône de parapluie
      default:
        return Icons.wb_cloudy; // Icône par défaut si inconnue
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écoute active du ViewModel : l'UI se reconstruit automatiquement à chaque modification
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Si aucune ville n'est encore chargée, afficher un indicateur de chargement circulaire
      body: ville == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Section 1 : Affichage de l'icône météo correspondante
                  Icon(
                    _iconeMeteo(ville.condition),
                    size: 100,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  
                  // Section 2 : Affichage de la température sans décimales
                  Text(
                    '${ville.temperature.toStringAsFixed(0)}°C',
                    style: const TextStyle(
                      fontSize: 60, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  // Section 3 : Affichage du nom de la ville
                  Text(
                    ville.nom,
                    style: TextStyle(
                      fontSize: 28, 
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  // Section 4 : Affichage de la condition textuelle et du taux d'humidité
                  Text(
                    '${ville.condition} - Humidite : ${ville.humidite}%',
                    style: const TextStyle(
                      fontSize: 16, 
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Section 5 : Bouton interactif pour ouvrir le sélecteur de villes
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('Changer de ville'),
                    onPressed: () {
                      // TODO Étape 7 : Implémenter la navigation vers la liste des villes
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
