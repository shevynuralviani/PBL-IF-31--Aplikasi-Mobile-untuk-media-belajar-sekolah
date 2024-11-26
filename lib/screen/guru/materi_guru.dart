import 'package:flutter/material.dart';

class MateriGuruPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materi'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Warna latar belakang
        child: const Center(
          child: Text(
            'Tidak ada materi',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
