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
