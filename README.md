# Présentation du Projet SoigneMoi version MOBILE

Dans le cadre de mon projet, j'ai développé une application mobile Flutter pour un hôpital fictif SoigneMoi, qui permet aux Médecins de se connecter, de rédiger des avis sur les patients et de consulter ces avis. 
L'application consomme une API sécurisée (API Platform via le projet web en Symfony) avec un système d'authentification JWT (JSON Web Token).

### Structure du Projet

J'ai structuré le projet de manière à séparer les différentes responsabilités en utilisant le model MVC, ce qui facilite la maintenance et l'évolutivité de l'application. 
Voici l'arborescence des dossiers :

##### 1. controllers/ : 
- Contient les classes de contrôleurs pour gérer la logique métier et l'état de l'application.
##### 2. models/ : 
- Contient les classes de modèles représentant les données de l'application.
##### 3. pages/ : 
- Contient les différentes pages de l'application.
##### 4. services/ : 
- Contient les services pour interagir avec l'API.
##### 5. main.dart : 
- Point d'entrée de l'application.

### Dépendances

Pour gérer les requêtes HTTP et la gestion d'état, j'ai ajouté les dépendances suivantes dans le fichier pubspec.yaml :

```YAML
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  http: ^0.15.0
  provider: ^6.0.0
  flutter_secure_storage: ^5.0.2
```

### Configuration de l'API avec Authentification JWT

#### 1. Création du Service API

Dans le fichier `lib/services/api_service.dart`, j'ai créé le service pour gérer les requêtes HTTP vers l'API, en utilisant des tokens JWT pour l'authentification. 
J'ai également désactivé la vérification SSL pour contourner les problèmes de certificats auto-signés pendant le développement.

```DART
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/models/avis.dart';


class ApiService {
  static const String baseUrl = 'https://172.16.3.116:8000';
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
```

### 2. Création des Modèles de Données

J'ai créé une classe Avis dans le fichier lib/models/avis.dart pour représenter les avis récupérés depuis l'API :

```DART
class Avis {
  final String libelle;
  final String date;
  final String description;
  final String medecin;

  Avis({
    required this.libelle,
    required this.date,
    required this.description,
    required this.medecin,
  });

  factory Avis.fromJson(Map<String, dynamic> json) {
    return Avis(
      libelle: json['libelle'],
      date: json['date'],
      description: json['description'],
      medecin: json['medecin']['@id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'libelle': libelle,
      'date': date,
      'description': description,
      'medecin': medecin,
    };
  }
}

```

### 3. Création du Contrôleur d'Authentification

J'ai créé le contrôleur d'authentification AuthController dans le fichier lib/controllers/auth_controller.dart pour gérer la logique d'authentification et l'état de l'utilisateur :

```DART
import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/services/api_service.dart';

class AuthController with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    _isLoggedIn = await ApiService.login(email, password);
    print('isLoggedIn: $_isLoggedIn'); // Debugging statement
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

```

### 4. Création des Pages de l'Application
##### Page de Connexion

La page de connexion HomePage permet à l'utilisateur de se connecter en saisissant son email et son mot de passe. J'ai ajouté des print statements pour faciliter le débogage.

```DART
import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                print('Email: $email'); // Debugging statement
                print('Password: $password'); // Debugging statement

                await context.read<AuthController>().login(email, password);

                if (context.read<AuthController>().isLoggedIn) {
                  print('Login successful'); // Debugging statement
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  print('Login failed'); // Debugging statement
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Échec de la connexion')),
                  );
                }
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Tableau de Bord

La page Dashboard permet à l'utilisateur de naviguer vers les pages de rédaction et de consultation des avis, et de se déconnecter.

```DART
import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/controllers/auth_controller.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/pages/consulter_avis.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/pages/rediger_avis.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthController>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedigerAvis()),
                );
              },
              child: Text('Rédiger un avis'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsulterAvis()),
                );
              },
              child: Text('Consulter les avis'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Page de Rédaction d'Avis

La page RedigerAvis permet à l'utilisateur de rédiger un avis et de l'envoyer à l'API.

```DART
import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/services/api_service.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/models/avis.dart';

class RedigerAvis extends StatelessWidget {
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController medecinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rédiger un avis'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: libelleController,
              decoration: InputDecoration(labelText: 'Libellé'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: medecinController,
              decoration: InputDecoration(labelText: 'ID du médecin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final libelle = libelleController.text;
                final description = descriptionController.text;
                final medecin = medecinController.text;

                Avis avis = Avis(
                  libelle: libelle,
                  date: DateTime.now().toIso8601String(),
                  description: description,
                  medecin: medecin,
                );

                bool success = await ApiService.postAvis(avis);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Avis envoyé avec succès')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Échec de l\'envoi de l\'avis')),
                  );
                }
              },
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Page de Consultation d'Avis

La page ConsulterAvis permet à l'utilisateur de consulter les avis récupérés depuis l'API.

```DART
import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/services/api_service.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/models/avis.dart';

class ConsulterAvis extends StatefulWidget {
  @override
  _ConsulterAvisState createState() => _ConsulterAvisState();
}

class _ConsulterAvisState extends State<ConsulterAvis> {
  late Future<List<Avis>> avisList;

  @override
  void initState() {
    super.initState();
    avisList = ApiService.getAvis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulter les avis'),
      ),
      body: FutureBuilder<List<Avis>>(
        future: avisList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun avis disponible'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final avis = snapshot.data![index];
                return ListTile(
                  title: Text(avis.libelle),
                  subtitle: Text(avis.description),
                  trailing: Text(avis.date),
                );
              },
            );
          }
        },
      ),
    );
  }
}
```

#### Initialisation de l'Application

Dans le fichier main.dart, j'ai initialisé l'application et configuré les routes pour la navigation.

```DART
import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/controllers/auth_controller.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/pages/homepage.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/pages/dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthController(),
      child: MaterialApp(
        title: 'Application SoigneMoi',
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/dashboard': (context) => Dashboard(),
        },
      ),
    );
  }
}
```

