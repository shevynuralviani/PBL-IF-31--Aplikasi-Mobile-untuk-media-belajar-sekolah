import 'package:flutter/material.dart';
import 'add_materi_page.dart';

class MateriListPage extends StatefulWidget {
  @override
  _MateriListPageState createState() => _MateriListPageState();
}

class _MateriListPageState extends State<MateriListPage> {
  List<Map<String, String>> materi = [];

  void addMateri(String judul, String file) {
    setState(() {
      materi.add({'judul': judul, 'file': file});
    });
  }

  void editMateri(int index, String newJudul, String newFile) {
    setState(() {
      materi[index] = {'judul': newJudul, 'file': newFile};
    });
  }

  void deleteMateri(int index) {
    setState(() {
      materi.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Materi'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: materi.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(materi[index]['judul']!),
            subtitle: Text(materi[index]['file']!),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMateriPage(
                        onSave: (newJudul, newFile) {
                          editMateri(index, newJudul, newFile);
                        },
                        existingTitle: materi[index]['judul'],
                        existingFile: materi[index]['file'],
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  deleteMateri(index);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Hapus'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMateriPage(
                onSave: (judul, file) {
                  addMateri(judul, file);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
}
