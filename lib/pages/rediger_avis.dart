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