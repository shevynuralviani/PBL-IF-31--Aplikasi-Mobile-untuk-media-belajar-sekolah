class Materi {
  final int id;
  final String judul;
  final String bab;
  final int jumlahHalaman;
  final String pdfUrl;
  final String photoUrl;
  double progres;
  bool isFavorite;

  Materi({
    required this.id,
    required this.judul,
    required this.bab,
    required this.jumlahHalaman,
    required this.pdfUrl,
    required this.photoUrl,
    this.progres = 0.0,
    this.isFavorite = false,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: int.tryParse(json['id'].toString()) ?? 0,
      judul: json['judul'] ?? '',
      bab: json['bab'] ?? '',
      jumlahHalaman: int.tryParse(json['jumlah_halaman'].toString()) ?? 0,
      pdfUrl: json['pdf_url'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      progres: (json['progres'] is String
              ? double.tryParse(json['progres']) ?? 0.0
              : (json['progres']?.toDouble())) ??
          0.0,
      isFavorite: json['is_favorite'] == 1,
    );
  }
}
