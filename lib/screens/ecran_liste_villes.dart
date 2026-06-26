import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import '../models/ville.dart';
import '../screens/ecran_ajout_ville.dart';
import '../services/localisation_service.dart';
import '../services/meteo_service.dart';

// Assure-toi que ces imports correspondent bien aux noms exacts de tes fichiers de service
// import '../services/localisation_service.dart'; 
// import '../services/meteo_service.dart';

class EcranListeVilles extends StatelessWidget {
  const EcranListeVilles({super.key});

  @override
  Widget build(BuildContext context) {
    // On lit la liste des villes depuis le ViewModel (écoute active)
    final vm = context.watch<VilleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        
        // --- EXERCICE C : BOUTON PLUS POUR LE FORMULAIRE ---
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EcranAjoutVille(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. La liste prend tout l'espace disponible en haut
          Expanded(
            child: ListView.builder(
              itemCount: vm.villes.length, // Nombre total de villes dans la liste
              itemBuilder: (context, index) {
                final ville = vm.villes[index];
                
                // Vérifie si la ville de la ligne courante est celle actuellement sélectionnée
                final estSelectionnee = ville.nom == vm.villeSelectionnee?.nom;

                return ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: estSelectionnee ? Colors.blue : Colors.grey,
                  ),
                  title: Text(
                    ville.nom,
                    style: TextStyle(
                      fontWeight: estSelectionnee ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(ville.pays),
                  trailing: estSelectionnee
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<VilleViewModel>().selectionnerVille(ville);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          // 2. Le bouton GPS est placé proprement en bas de l'écran
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity, // Bouton sur toute la largeur
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text('Trouver la ville la plus proche'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {

                  final service = LocalisationService();
                  final position = await service.getPosition();

                  if (position != null) {
                    final viewModel = context.read<VilleViewModel>();
                    final villeProche = service.trouverVilleProche(
                      position, viewModel.villes, MeteoService.coords);

                    if (villeProche != null) {
                      viewModel.selectionnerVille(villeProche);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ville proche : ${villeProche.nom}')),
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aucune ville proche trouvée')),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('GPS indisponible')),
                      );
                    }
                  }
                  
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
