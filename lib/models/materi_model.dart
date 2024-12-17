class Materi {
  final int id;
  final String judul;
  final String bab;
  final String pengunggahNama;
  final double progres;
  final String fotoSampul;
  bool isFavorite;

  Materi({
    required this.id,
    required this.judul,
    required this.bab,
    required this.pengunggahNama,
    required this.progres,
    required this.fotoSampul,
    this.isFavorite = false,
  });

  // Fungsi untuk mengonversi JSON menjadi objek Materi
  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: int.tryParse(json['id'].toString()) ??
          0, // Mengonversi id menjadi int, default ke 0 jika gagal
      judul: json['judul'] ?? '',
      bab: json['bab'] ?? '',
      pengunggahNama: json['pengunggah_nama'] ?? '',
      progres: _parseDouble(
          json['progres']), // Mengonversi progres dengan pemeriksaan
      fotoSampul: json['foto_sampul'] ?? '',
      isFavorite:
          json['is_favorite'] == 1, // Mengonversi is_favorite menjadi boolean
    );
  }

  // Fungsi untuk mengonversi string atau null menjadi double
  static double _parseDouble(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 0.0; // Defaultkan ke 0 jika null atau kosong
    }
    try {
      return double.parse(value.toString());
    } catch (e) {
      return 0.0; // Mengembalikan 0 jika gagal parse
    }
  }
}
