import 'package:flutter/material.dart';
import 'package:genetika_app/models/materi_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class MaterialDetailPage extends StatefulWidget {
  final Materi materi;

  const MaterialDetailPage({super.key, required this.materi});

  @override
  _MaterialDetailPageState createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {
  bool _isUpdatingProgress = false;

  Future<void> updateProgress(Materi materi) async {
    if (_isUpdatingProgress) return;

    setState(() {
      _isUpdatingProgress = true;
    });

    final response = await http.post(
      Uri.parse(
          'http://www.bekend.infinityfreeapp.com/update_progressmateri.php'),
      body: {
        'user_id': 'user_id_here', // Ganti dengan ID pengguna yang sesuai
        'materi_id': materi.id.toString(),
        'progres': materi.progres.toString(),
        'last_read': DateTime.now().toIso8601String(),
        'is_favorite': materi.isFavorite ? '1' : '0',
      },
    );

    setState(() {
      _isUpdatingProgress = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update progress')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final materi = widget.materi;
    return Scaffold(
      appBar: AppBar(
        title: Text(materi.judul),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar sebagai header, lebar penuh dengan tinggi tertentu
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: materi.fotoSampul.isNotEmpty
                    ? materi.fotoSampul
                    : 'https://via.placeholder.com/150',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 200, // Sesuaikan tinggi gambar agar seperti header
                fit: BoxFit.cover, // Menjaga gambar tetap proporsional
              ),
            ),
            SizedBox(height: 16),
            Text('Bab: ${materi.bab}', style: TextStyle(fontSize: 18)),
            Text('Pengunggah: ${materi.pengunggahNama}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Progress: ${(materi.progres * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
