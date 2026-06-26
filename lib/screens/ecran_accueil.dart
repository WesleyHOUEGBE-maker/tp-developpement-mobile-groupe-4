import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';

import 'package:image_picker/image_picker.dart ';
import 'dart:io';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  // Méthode pour associer une icône à chaque condition météo réelle
  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille': 
      case 'Ensoleillé': 
        return Icons.wb_sunny;
      case 'Nuageux':
        return Icons.cloud;
      case 'Pluvieux':
      case 'Averses':
        return Icons.umbrella;
      case 'Orageux':
        return Icons.thunderstorm;
      case 'Ventueux': 
        return Icons.air;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Méthode pour la couleur de fond dynamique basée sur l'API
  Color _couleurFondMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
      case 'Ensoleillé':
        return Colors.orange.shade100;
      case 'Nuageux':
        return Colors.grey.shade300;
      case 'Pluvieux':
      case 'Averses':
      case 'Orageux':
        return Colors.blue.shade100;
      default:
        return Colors.white;
    }
  }

   @override
  Widget build(BuildContext context) {
    // On écoute le ViewModel pour savoir quelle ville est sélectionnée
    final vmWatch = context.watch<VilleViewModel>();
    final ville = vmWatch.villeSelectionnee;

    // Si aucune ville n'est sélectionnée au départ
    if (ville == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Le Consumer englobe maintenant tout le body pour que la couleur de fond 
      // se mette à jour dynamiquement dès que la météo arrive !
      body: Consumer<VilleViewModel>(
        builder: (context, vm, _) {
          final meteo = vm.meteoActuelle; // Extraire la météo DIRECTEMENT dans le Consumer

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _couleurFondMeteo(meteo?.conditionTexte ?? 'Inconnu'),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Nom de la ville toujours visible en haut
                  Text(
                    ville.nom,
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Gestion des états du chargement réseau
                  if (vm.chargement) ...[
                    const CircularProgressIndicator(),
                  ] else if (vm.erreur != null) ...[
                    Column(
                      children: [
                        const Icon(Icons.wifi_off, size: 60, color: Colors.red),
                        Text(vm.erreur!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => vm.selectionnerVille(ville),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ] else if (meteo == null) ...[
                    const Text('En attente de chargement...'),
                  ] else ...[
                    // S'il n'y a pas d'erreur et que la météo est prête, on affiche le bloc complet
                    Column(
                      children: [
                        Icon(
                          _iconeMeteo(meteo.conditionTexte),
                          size: 100,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${meteo.temperature.toStringAsFixed(1)} °C',
                          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${meteo.conditionTexte} - ${meteo.humidite}% humidité',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        // Affichage de la date et de l'heure (Exercice A)
                        Text(
                          meteo.dateHeureFormatee,
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                        ),

                        // --- EXERCICE B : SECTION AFFICHAGE DES PRÉVISIONS SUR 3 JOURS ---
                        const SizedBox(height: 24),
                        const Text(
                          'Prévisions sur 3 jours',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, // Défilement horizontal
                            shrinkWrap: true,
                            itemCount: meteo.previsions.length,
                            itemBuilder: (context, idx) {
                              final prev = meteo.previsions[idx];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        prev.dateFormatee, 
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        prev.conditionTexte, 
                                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                                      ),
                                      const SizedBox(height: 6),
                                      Text('Max: ${prev.tempMax.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 11)),
                                      Text('Min: ${prev.tempMin.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // 3. Bouton pour ouvrir le sélecteur de villes
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('Changer de ville'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EcranListeVilles(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        
        
        GestureDetector(
onTap: () async {
mainAxisAlignment: MainAxisAlignment.center ,
children: [
// Ouvrir la galerie
final picker = ImagePicker ();
final XFile? image = await picker.pickImage(source:
ImageSource.gallery);
if (image != null) {
// Mettre a jour le ViewModel avec le chemin de la photo
context.read <VilleViewModel >().mettreAJourPhoto(image.path
);
}
},
child: ClipRRect(
borderRadius: BorderRadius.circular (12) ,
child: vm.villeSelectionnee ?. photoPath != null
? Image.file(
File(vm.villeSelectionnee !. photoPath !),
width: double.infinity ,
height: 200,
fit: BoxFit.cover ,
)
: Container(
width: double.infinity ,
height: 200,
color: Colors.grey [200] ,
child: Column(Icon(Icons.add_a_photo , size: 50, color: Colors.
grey),
Text('Appuyez pour ajouter une photo '),
),
),
],
),
),
 
      ),
    );
  }
}