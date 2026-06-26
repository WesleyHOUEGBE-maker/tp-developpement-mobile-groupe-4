import 'package:dio/dio.dart';
import '../models/meteo_data.dart';

class MeteoService {
  static const Map<String, List<double>> _coords = {
    // Bénin
    'Cotonou':      [6.3703,   2.3912],
    'Parakou':      [9.3370,   2.6283],
    'Nattitingou':  [10.3042,  1.3796],
    'Tanguiéta':    [10.6212,  1.2647],

    // Togo
    'Lomé':         [6.1375,   1.2123],
    'Kara':         [9.5511,   1.1861],

    // Nigéria
    'Lagos':        [6.4541,   3.3947],
    'Abuja':        [9.0579,   7.4951],

    // Sénégal
    'Dakar':        [14.7167, -17.4677],
    'Saint-Louis':  [16.0179, -16.4896],

    // Côte d'Ivoire
    'Abidjan':      [5.3600,  -4.0083],
    'Yamoussoukro': [6.8276,  -5.2753],

    // Burkina Faso
    'Ouagadougou':     [12.3714, -1.5197],
    'Bobo-Dioulasso':  [11.1772, -4.2974],

    // France
    'Paris':     [48.8566,   2.3522],
    'Marseille': [43.2965,   5.3698],

    // Canada
    'Montréal':  [45.5017,  -73.5673],
    'Vancouver': [49.2827, -123.1207],

    // Brésil
    'Rio de Janeiro': [-22.9068, -43.1729],
    'São Paulo':      [-23.5505, -46.6333],

    // Japon
    'Tokyo': [35.6762, 139.6503],
    'Kyoto': [35.0116, 135.7681],

    // Maroc
    'Marrakech':  [31.6295,  -7.9811],
    'Casablanca': [33.5731,  -7.5898],
  };

  final Dio _dio = Dio(BaseOptions(
    baseUrl:        'https://api.open-meteo.com/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  MeteoService() {
    _dio.interceptors.add(LogInterceptor(
      requestBody:  false,
      responseBody: false,
      logPrint: (msg) => print('[DIO] $msg'),
    ));
  }

  Future<MeteoData?> getMeteo(String nomVille) async {
    final coords = _coords[nomVille];
    if (coords == null) {
      print('Ville inconnue : $nomVille');
      return null;
    }

    try {
      final lat = coords[0];
      final lon = coords[1];

      // ✅ CORRECTION 3 : slash encodé en %2F pour éviter les erreurs d'URL
      final urlBrute =
          '/forecast?latitude=$lat&longitude=$lon'
          '&current=temperature_2m,relative_humidity_2m,weather_code'
          '&daily=temperature_2m_max,temperature_2m_min,weather_code'
          '&timezone=Africa%2FLagos';

      final response = await _dio.get(urlBrute);

      // ✅ CORRECTION 4 : vérification du type avant le cast
      if (response.data is Map<String, dynamic>) {
        return MeteoData.fromJson(response.data as Map<String, dynamic>);
      }
      print('Réponse inattendue : ${response.data}');
      return null;

    } on DioException catch (e) {
      print('Erreur réseau : ${e.message}');
      if (e.response != null) {
        print('Détails Open-Meteo : ${e.response?.data}');
      }
      return null;
    }
  }
}