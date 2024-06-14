import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/models/avis.dart';


class ApiService {
  static const String baseUrl = 'https://127.0.0.1:8000';
  static String token = '';

static Future<bool> login(String email, String password) async {
    try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      IOClient ioClient = IOClient(httpClient);

      http.Response response = await ioClient.post(
        Uri.parse('$baseUrl/auth'),
        headers: <String, String>{
          'Content-Type': 'application/ld+json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      // Gestion des redirections manuellement
      if (response.statusCode == 307 || response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        response = await ioClient.post(
          Uri.parse(redirectUrl!),
          headers: <String, String>{
            'Content-Type': 'application/ld+json',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
          }),
        );
      }

      print('Response status: ${response.statusCode}'); // Ajout pour le debug
      print('Response body: ${response.body}'); // Ajout pour le debug

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['token'];
        return true;
      } else {
        print('Erreur de réponse: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return false;
    }
  }

  static Future<List<Avis>> getAvis() async {
    try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.get(
        Uri.parse('$baseUrl/apiMedecins/avis'),
        headers: <String, String>{
          'Content-Type': 'application/ld+json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Avis> avisList = (data['hydra:member'] as List)
            .map((avis) => Avis.fromJson(avis))
            .toList();
        return avisList;
      } else {
        throw Exception('Échec du chargement des avis');
      }
    } catch (e) {
      print('Erreur lors de la récupération des avis: $e');
      return [];
    }
  }

  static Future<bool> postAvis(Avis avis) async {
    try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        Uri.parse('$baseUrl/apiMedecins/avis'),
        headers: <String, String>{
          'Content-Type': 'application/ld+json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(avis.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'avis: $e');
      return false;
    }
  }
}