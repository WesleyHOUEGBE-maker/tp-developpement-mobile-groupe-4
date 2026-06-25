import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/ville_viewmodel.dart';
import 'screens/ecran_accueil.dart';

void main() {
  runApp(
    // ChangeNotifierProvider injecte l'instance unique de VilleViewModel au sommet de l'arbre
    ChangeNotifierProvider(
      create: (_) => VilleViewModel(), // Initialisation de notre gestionnaire d'état
      child:  MaterialApp(
        title: 'AppMeteo',
        debugShowCheckedModeBanner: false, // Désactive la bannière de debug "SLOW MODE"
        
        theme: ThemeData(
    
    fontFamily: 'Mayan', 
  ),
        home: EcranAccueil(), // Définit l'écran d'accueil comme premier écran
      ),
    ),
  );
}
