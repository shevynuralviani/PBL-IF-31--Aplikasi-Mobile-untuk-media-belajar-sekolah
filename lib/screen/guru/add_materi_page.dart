import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddMateriPage extends StatefulWidget {
  final Function(String, String) onSave;
  final String? existingTitle;
  final String? existingFile;

  const AddMateriPage({
    required this.onSave,
    this.existingTitle,
    this.existingFile,
    Key? key,
  }) : super(key: key);

  @override
  _AddMateriPageState createState() => _AddMateriPageState();
}

class _AddMateriPageState extends State<AddMateriPage> {
  late TextEditingController _judulController;
  String? selectedFile;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.existingTitle ?? '');
    selectedFile = widget.existingFile;
  }

  Future<void> chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = result.files.single.name;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File tidak dipilih')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existingTitle == null ? 'Tambah Materi' : 'Edit Materi'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Judul Materi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan Judul Materi',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih File',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: chooseFile,
                  child: const Text('Choose File'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedFile ?? 'Belum ada file yang dipilih',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_judulController.text.isEmpty || selectedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap isi semua field dan pilih file!'),
                      ),
                    );
                  } else {
                    widget.onSave(
                      _judulController.text,
                      selectedFile!,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
