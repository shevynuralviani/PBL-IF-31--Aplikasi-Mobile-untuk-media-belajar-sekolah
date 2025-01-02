import 'package:flutter/material.dart';
import 'package:genetika_app/screen/guru/add_materi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Materi',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MateriListPage(),
    );
  }
}

class MateriListPage extends StatelessWidget {
  const MateriListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Daftar Materi',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol Tambah Materi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green), // Border hijau
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Navigasi ke halaman Tambah Materi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahMateriPage(),
                    ),
                  );
                },
                child: const Text(
                  'Tambah Materi',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ),
          // Daftar Materi
          const Expanded(child: MateriList()),
        ],
      ),
    );
  }
}

class MateriList extends StatelessWidget {
  const MateriList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: 3,
      itemBuilder: (context, index) {
        return MateriItem(
          title: 'Judul Buku ${index + 1}',
          imageUrl: 'assets/images/get_start.png', // Placeholder gambar cover
          progress: (index + 1) * 20, // Contoh progress baca
        );
      },
    );
  }
}

class MateriItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int progress;

  const MateriItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7BBB07).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 65, // ukuran cover
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Informasi Materi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('Biology, Bab 1'),
                const SizedBox(height: 5),
                // Progress Bar
                Column(
                  children: [
                    Text('Page 11 from 50 (40%)'),
                    const SizedBox(height: 10),
                    Container(
                      width: 150,
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF7BBB07),
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Icon Hide with Popup Menu (Edit, Delete)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Materi')),
                );
              } else if (value == 'hapus') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hapus Materi')),
                );
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'hapus',
                  child: Text('Hapus'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
