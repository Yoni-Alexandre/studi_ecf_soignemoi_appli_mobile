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
