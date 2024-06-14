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
        title: const Text('Tableau de bord', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3498DB),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthController>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F1F1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF3498DB),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RedigerAvis()),
                  );
                },
                child: const Text('Rédiger un avis'),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF3498DB),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsulterAvis()),
                  );
                },
                child: const Text('Consulter les avis'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
