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