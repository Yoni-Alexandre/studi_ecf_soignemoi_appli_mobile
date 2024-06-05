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
