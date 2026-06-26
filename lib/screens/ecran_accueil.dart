import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import '../services/meteo_service.dart';
import 'ecran_liste_villes.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'dart:io' as io;

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

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

  // Teinte de superposition dynamique pour adapter l'ambiance lumineuse sur l'image
  Color _teinteFiltreMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
      case 'Ensoleillé':
        return Colors.orange.withOpacity(0.15);
      case 'Nuageux':
        return Colors.grey.withOpacity(0.2);
      case 'Pluvieux':
      case 'Averses':
      case 'Orageux':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.black.withOpacity(0.1);
    }
  }

  // --- EXERCICE A : MODAL BOTTOM SHEET POUR LE CHOIX DE LA PHOTO ---
  void _afficherChoixPhoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null && context.mounted) {
                    context.read<VilleViewModel>().mettreAJourPhoto(image.path);
                  }
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Appareil photo'),
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null && context.mounted) {
                    context.read<VilleViewModel>().mettreAJourPhoto(image.path);
                  }
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vmWatch = context.watch<VilleViewModel>();
    final ville = vmWatch.villeSelectionnee;

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
      body: Consumer<VilleViewModel>(
        builder: (context, vm, _) {
          final meteo = vm.meteoActuelle;

          return Container(
            width: double.infinity,
            height: double.infinity,
            // --- AJOUT DE TON IMAGE DE FOND LOCALE ---
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('img/nuages.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  _teinteFiltreMeteo(meteo?.conditionTexte ?? 'Inconnu'),
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: SingleChildScrollView( 
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1. Nom de la ville
                      Text(
                        ville.nom,
                        style: TextStyle(
                          fontSize: 32, 
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      
                      // --- EXERCICE B : AFFICHAGE DES COORDONNÉES RÉELLES DU MODÈLE VILLE ---
                      const SizedBox(height: 4),
                      Text(
                        'Lat: ${ville.temperature.toStringAsFixed(2)} | Lon: ${ville.humidite.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- GESTION DE LA PHOTO COMPATIBLE WEB & MOBILE ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () => _afficherChoixPhoto(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: (vm.villeSelectionnee?.photoPath != null && vm.villeSelectionnee!.photoPath!.isNotEmpty)
                                ? (kIsWeb
                                    ? Image.network(
                                        vm.villeSelectionnee!.photoPath!,
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        io.File(vm.villeSelectionnee!.photoPath!),
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ))
                                : Container(
                                    width: double.infinity,
                                    height: 180,
                                    color: Colors.white.withOpacity(0.6),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo, size: 50, color: Colors.blueGrey),
                                        SizedBox(height: 8),
                                        Text('Appuyez pour ajouter une photo', style: TextStyle(fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Gestion des états du chargement réseau
                      if (vm.chargement) ...[
                        const CircularProgressIndicator(),
                      ] else if (vm.erreur != null) ...[
                        Column(
                          children: [
                            const Icon(Icons.wifi_off, size: 60, color: Colors.red),
                            Text(vm.erreur!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => vm.selectionnerVille(ville),
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ] else if (meteo == null) ...[
                        const Text('En attente de chargement...', style: TextStyle(fontWeight: FontWeight.bold)),
                      ] else ...[
                        // Conteneur transparent blanc pour faire ressortir les informations textuelles
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  _iconeMeteo(meteo.conditionTexte),
                                  size: 80,
                                  color: Colors.orange,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${meteo.temperature.toStringAsFixed(1)} °C',
                                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${meteo.conditionTexte} - ${meteo.humidite}% humidité',
                                  style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  meteo.dateHeureFormatee,
                                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[800]),
                                ),

                                // --- SECTION AFFICHAGE DES PRÉVISIONS SUR 3 JOURS ---
                                const SizedBox(height: 24),
                                const Text(
                                  'Prévisions sur 3 jours',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: meteo.previsions.length,
                                    itemBuilder: (context, idx) {
                                      final prev = meteo.previsions[idx];
                                      return Card(
                                        color: Colors.white.withOpacity(0.9),
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
                                                style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
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
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // 3. Bouton pour ouvrir le sélecteur de villes
                      ElevatedButton.icon(
                        icon: const Icon(Icons.list),
                        label: const Text('Changer de ville'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                        ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
