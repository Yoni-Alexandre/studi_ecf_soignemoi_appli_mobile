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
        title: const Text('Consulter les avis', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3498DB),
      ),
      body: Container(
        color: const Color(0xFFF1F1F1),
        child: FutureBuilder<List<Avis>>(
          future: avisList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF3498DB)));
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Color(0xFF3498DB))));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun avis disponible', style: TextStyle(color: Color(0xFF3498DB))));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final avis = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(avis.libelle, style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        children: [
                          Text(avis.description, style: const TextStyle(color: Color(0xFF666666))),
                          Text(avis.medecin, style: const TextStyle(color: Color(0xFF666666))),
                        ],
                      ),
                      trailing: Text(avis.date, style: const TextStyle(color: Color(0xFF999999))),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
