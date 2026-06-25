import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ville.dart';
import '../viewmodels/ville_viewmodel.dart';

class EcranAjoutVille extends StatefulWidget {
  const EcranAjoutVille({super.key});

  @override
  State<EcranAjoutVille> createState() => _EcranAjoutVilleState();
}

class _EcranAjoutVilleState extends State<EcranAjoutVille> {
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour récupérer les textes saisis
  final _nomController = TextEditingController();
  final _paysController = TextEditingController();
  final _tempController = TextEditingController();
  final _humiditeController = TextEditingController();
  
  // Valeurs pour la liste déroulante des conditions météo
  String _conditionSelectionnee = 'Ensoleillé';
  final List<String> _conditions = ['Ensoleillé', 'Nuageux', 'Pluvieux', 'Orageux', 'Ventueux'];

  @override
  void dispose() {
    _nomController.dispose();
    _paysController.dispose();
    _tempController.dispose();
    _humiditeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ Nom de la ville
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom de la ville', border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              const SizedBox(height: 12),
              
              // Champ Pays
              TextFormField(
                controller: _paysController,
                decoration: const InputDecoration(labelText: 'Pays', border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty ? 'Veuillez entrer un pays' : null,
              ),
              const SizedBox(height: 12),
              
              // Champ Température
              TextFormField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Température (°C)', border: OutlineInputBorder()),
                validator: (v) => double.tryParse(v ?? '') == null ? 'Entrez un nombre valide' : null,
              ),
              const SizedBox(height: 12),
              
              // Champ Humidité
              TextFormField(
                controller: _humiditeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Humidité (%)', border: OutlineInputBorder()),
                validator: (v) => int.tryParse(v ?? '') == null ? 'Entrez un entier valide' : null,
              ),
              const SizedBox(height: 12),
              
              // Liste déroulante pour la Condition Météo
              DropdownButtonFormField<String>(
                value: _conditionSelectionnee,
                decoration: const InputDecoration(labelText: 'Condition météo', border: OutlineInputBorder()),
                items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _conditionSelectionnee = val!),
              ),
              const SizedBox(height: 24),
              
              // Bouton de validation
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),

                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Création de l'objet Ville avec les données saisies
                    final nouvelleVille = Ville(
                      nom: _nomController.text.trim(),
                      pays: _paysController.text.trim(),
                      temperature: double.parse(_tempController.text),
                      condition: _conditionSelectionnee,
                      humidite: int.parse(_humiditeController.text),
                    );
                    
                    // Appel de la méthode du ViewModel pour ajouter à la liste
                    context.read<VilleViewModel>().ajouterVille(nouvelleVille);
                    
                    // Retour automatique à l'écran de liste
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ajouter la ville', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
