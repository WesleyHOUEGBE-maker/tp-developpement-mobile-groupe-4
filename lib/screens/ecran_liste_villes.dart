import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import '../models/ville.dart';

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
      ),
      body: ListView.builder(
        itemCount: vm.villes.length, // Nombre total de villes dans la liste
        itemBuilder: (context, index) {
          final ville = vm.villes[index];
          
          // Vérifie si la ville de la ligne courante est celle actuellement sélectionnée
          final estSelectionnee = ville.nom == vm.villeSelectionnee?.nom;

          return ListTile(
            // Icône à gauche : Bleue si sélectionnée, grise sinon
            leading: Icon(
              Icons.location_city,
              color: estSelectionnee ? Colors.blue : Colors.grey,
            ),
            // Nom de la ville : En gras si sélectionnée
            title: Text(
              ville.nom,
              style: TextStyle(
                fontWeight: estSelectionnee ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            // Sous-titre : Pays et température de la ville
            subtitle: Text('${ville.pays} - ${ville.temperature}°C'),
            
            // Icône à droite : Un cercle de validation bleu uniquement sur la ville active
            trailing: estSelectionnee
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : null,
                
            // Action au clic sur une ligne (Code visible sur l'image 1000109804.jpg)
            onTap: () {
              // Utiliser context.read() pour appeler l'action du ViewModel sans reconstruire le widget
              context.read<VilleViewModel>().selectionnerVille(ville);
              
              // Revenir à l'écran précédent (l'écran d'accueil)
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
