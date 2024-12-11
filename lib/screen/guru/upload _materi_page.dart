import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class UploadMateriPage extends StatefulWidget {
  @override
  _UploadMateriPageState createState() => _UploadMateriPageState();
}

class _UploadMateriPageState extends State<UploadMateriPage> {
  TextEditingController judulController = TextEditingController();
  File? selectedFile;
  bool isUploading = false;

  // Fungsi untuk memilih file PDF
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('File berhasil dipilih: ${result.files.single.name}')),
      );
    }
  }

  // Fungsi untuk mengupload file ke server
  Future<void> uploadMateri() async {
    if (judulController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul materi tidak boleh kosong!')),
      );
      return;
    }

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan pilih file PDF!')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://your-server-url/uploadMateri.php'), // Ganti dengan URL backend Anda
      );
      request.fields['judul'] = judulController.text;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedFile!.path,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Materi berhasil diupload!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal mengupload materi. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Materi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(
                labelText: 'Judul Materi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: Icon(Icons.attach_file),
              label: Text('Pilih File PDF'),
            ),
            SizedBox(height: 20),
            isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadMateri,
                    child: Text('Upload Materi'),
                  ),
          ],
        ),
      ),
    );
  }
}
