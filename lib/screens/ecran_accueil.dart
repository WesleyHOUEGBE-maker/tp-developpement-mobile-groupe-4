import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  // Méthode utilitaire privée pour associer une icône à chaque condition météo
  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleillé': 
        return Icons.wb_sunny; // Icône de soleil
      case 'Nuageux':
        return Icons.cloud;    // Icône de nuage
      case 'Pluvieux':
        return Icons.umbrella; // Icône de parapluie
      case 'Orageux':
        return Icons.thunderstorm; // Exercice A
      case 'Ventueux': 
        return Icons.air; // Exercice A
      default:
        return Icons.wb_cloudy; // Icône par défaut si inconnue
    }
  }

  // --- EXERCICE B : AJOUT DE LA MÉTHODE POUR LA COULEUR DE FOND DYNAMIQUE ---
  // Associe une couleur claire spécifique à chaque type de condition météo
  Color _couleurFondMeteo(String condition) {
    switch (condition) {
      case 'Ensoleillé':
      
        return Colors.orange.shade100; // Fond orange clair
      case 'Nuageux':
        return Colors.grey.shade300;   // Fond gris clair
      case 'Pluvieux':
      case 'Orageux':
        return Colors.blue.shade100;   // Fond bleu clair
      default:
        return Colors.white;           // Fond blanc par défaut
    }
  }
  // ------------------------------------------------------------------------

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
          : Container(
              // --- EXERCICE B : APPLICATION DU CONTAINER DE COULEUR ---
              // On prend tout l'espace disponible sur l'écran
              width: double.infinity,
              height: double.infinity,
              // Utilisation d'une BoxDecoration pour appliquer la couleur de fond dynamique
              decoration: BoxDecoration(
                color: _couleurFondMeteo(ville.condition),
              ),
              // ---------------------------------------------------------
              child: Center(
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
                        // Étape 7 : Implémenter la navigation vers la liste des villes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EcranListeVilles(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
