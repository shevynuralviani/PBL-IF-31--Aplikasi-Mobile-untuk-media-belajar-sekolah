import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const HomeGuru());
}

class HomeGuru extends StatefulWidget {
  const HomeGuru({super.key});

  @override
  _HomeGuruState createState() => _HomeGuruState();
}

class _HomeGuruState extends State<HomeGuru> {
  final String namaGuru = "Ahmad Subandi";
  final String mataPelajaran = "Biologi";
  final List<String> daftarKelas = [
    "Kelas X IPA 1",
    "Kelas X IPA 2",
    "Kelas XI IPA 1"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage Guru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('Homepage Guru'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang, $namaGuru',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Mata Pelajaran: $mataPelajaran',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Daftar Kelas yang Diampu:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: daftarKelas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.class_),
                      title: Text(daftarKelas[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
