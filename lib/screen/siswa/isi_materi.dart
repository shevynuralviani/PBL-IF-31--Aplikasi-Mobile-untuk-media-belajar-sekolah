import 'package:flutter/material.dart';

class ReadMateri extends StatefulWidget {
  const ReadMateri({super.key});

  @override
  State<ReadMateri> createState() => _ReadMateriState();
}

class _ReadMateriState extends State<ReadMateri> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Teks bacaan yang akan berubah berdasarkan klik bab
  String _mainContent = 'Pilih bab untuk membaca konten.';

  final List<String> _babList = [
    "Bab 1: Pengantar Genetika",
    "Bab 2: Struktur DNA",
    "Bab 3: Replikasi DNA",
    "Bab 4: Transkripsi dan Translasi"
  ];

  final Map<String, String> _contentMap = {
    "Bab 1: Pengantar Genetika":
        "Genetika adalah cabang ilmu biologi yang mempelajari pewarisan sifat...",
    "Bab 2: Struktur DNA":
        "DNA adalah materi genetik yang terdapat dalam inti sel, terdiri dari dua rantai...",
    "Bab 3: Replikasi DNA":
        "Replikasi DNA adalah proses penggandaan molekul DNA sebelum sel membelah...",
    "Bab 4: Transkripsi dan Translasi":
        "Transkripsi adalah proses pembentukan RNA dari template DNA, sementara translasi adalah proses sintesis protein..."
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Judul Materi',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.green),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: _babList.map((bab) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        bab,
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          _mainContent =
                              _contentMap[bab] ?? 'Konten tidak ditemukan.';
                        });
                        Navigator.pop(context); // Tutup drawer setelah memilih
                      },
                    ),
                    const Divider(color: Colors.green),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _mainContent,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/get_start.png',
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
