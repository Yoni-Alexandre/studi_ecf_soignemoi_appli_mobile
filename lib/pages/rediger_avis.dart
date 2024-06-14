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
        title: const Text('Rédiger un avis', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3498DB),
      ),
      body: Container(
        color: const Color(0xFFF1F1F1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: libelleController,
              decoration: const InputDecoration(
                labelText: 'Libellé',
                labelStyle: TextStyle(color: Color(0xFF3498DB)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3498DB)),
                ),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Color(0xFF3498DB)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3498DB)),
                ),
              ),
            ),
            TextField(
              controller: medecinController,
              decoration: const InputDecoration(
                labelText: 'ID du médecin',
                labelStyle: TextStyle(color: Color(0xFF3498DB)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3498DB)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF3498DB),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
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
                      const SnackBar(content: Text('Avis envoyé avec succès')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Échec de l\'envoi de l\'avis')),
                    );
                  }
                },
                child: const Text('Envoyer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
