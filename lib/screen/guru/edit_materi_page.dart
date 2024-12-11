import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditMateriPage extends StatefulWidget {
  final Map materi;

  EditMateriPage({required this.materi});

  @override
  _EditMateriPageState createState() => _EditMateriPageState();
}

class _EditMateriPageState extends State<EditMateriPage> {
  TextEditingController judulController = TextEditingController();

  @override
  void initState() {
    super.initState();
    judulController.text = widget.materi['judul'];
  }

  Future<void> updateMateri() async {
    final response = await http.post(
      Uri.parse('http://your-server-url/editMateri.php'),
      body: {
        'id': widget.materi['id'].toString(),
        'judul': judulController.text,
      },
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to update materi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Materi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(labelText: 'Judul Materi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateMateri,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
