import 'package:dio/dio.dart';
import '../models/meteo_data.dart';

class MeteoService {
  // Coordonnees GPS des villes (Mises à jour avec tes ajouts personnels)
  static const Map<String, List<double>> _coords = {
    // Villes de base du TP
    'Cotonou': [6.3703, 2.3912],
    'Parakou': [9.3370, 2.6283],
    'Lagos': [6.4541, 3.3947],
    'Abidjan': [5.3600, -4.0083],
    
    // Tes ajouts au Bénin
    'Nattitingou': [10.3042, 1.3796],
    'Tanguiéta': [10.6212, 1.2647],
    
    // Togo
    'Lomé': [6.1375, 1.2123],
    'Kara': [9.5511, 1.1861],
    
    // Nigéria
    'Nigéria': [9.0820, 8.6753], 
    'Abuja': [9.0579, 7.4951],
    
    // Sénégal
    'Dakar': [14.7167, -17.4677],
    'Saint-Louis': [16.0179, -16.4896],
    
    // Côte d'Ivoire
    'Yamoussoukro': [6.8276, -5.2753],
    
    // Burkina Faso
    'Ouagadougou': [12.3714, -1.5197],
    'Bobo-Dioulasso': [11.1772, -4.2974],
    
    // France
    'Paris': [48.8566, 2.3522],
    'Marseille': [43.2965, 5.3698],
    
    // Canada
    'Montréal': [45.5017, -73.5673],
    'Vancouver': [49.2827, -123.1207],
    
    // Brésil
    'Rio de Janeiro': [-22.9068, -43.1729],
    'São Paulo': [-23.5505, -46.6333],
    
    // Japon
    'Tokyo': [35.6762, 139.6503],
    'Kyoto': [35.0116, 135.7681],
    
    // Maroc
    'Marrakech': [31.6295, -7.9811],
    'Casablanca': [33.5731, -7.5898],
  };

  // Instance de dio configuree
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.open-meteo.com/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  MeteoService() {
    // Ajouter un intercepteur de log
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (msg) => print('[DIO] $msg'),
    ));
  }

  // Recuperer la meteo d'une ville
  Future<MeteoData?> getMeteo(String nomVille) async {
    final coords = _coords[nomVille];
    if (coords == null) {
      print('Ville inconnue : $nomVille');
      return null;
    }

    try {
      final lat = coords[0];
      final lon = coords[1];
      
      // Construction de l'URL brute à la main pour éviter l'encodage des virgules par Dio (%2C)
      final urlBrute = '/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,weather_code,time&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=Africa/Lagos';

      final response = await _dio.get(urlBrute);

      // On passe le JSON complet à la factory
      return MeteoData.fromJson(response.data as Map<String, dynamic>);

    } on DioException catch (e) {
      print('Erreur reseau : ${e.message}');
      if (e.response != null) {
        print('Détails du serveur Open-Meteo : ${e.response?.data}');
      }
      return null;
    }
  }
}
