import 'package:flutter/material.dart';
import 'package:genetika_app/models/materi_model.dart';
import 'package:genetika_app/screen/siswa/material_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  List<Materi> _materiList = [];
  List<Materi> _filteredMateriList = [];
  bool _isLoading = true;
  bool _isUpdatingProgress = false;
  String currentUserId = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserId();
    fetchMateri();
    _searchController.addListener(_filterMateriList);
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('currentUserId') ?? '';
    });
  }

  Future<void> fetchMateri() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/api/get_materi.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _materiList = (data['data'] as List)
                .map((item) => Materi.fromJson(item))
                .toList();
            _filteredMateriList = List.from(_materiList);
            _isLoading = false;
          });
        } else {
          _showSnackbar('Failed to load data');
        }
      } else {
        _showSnackbar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error fetching data: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _filterMateriList() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMateriList = _materiList.where((materi) {
        return materi.judul.toLowerCase().contains(query) ||
            materi.pengunggahNama.toLowerCase().contains(query) ||
            materi.bab.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleFavorite(Materi materi) {
    setState(() {
      materi.isFavorite = !materi.isFavorite;
    });
    updateProgress(materi);
  }

  Future<void> updateProgress(Materi materi) async {
    if (_isUpdatingProgress) return;

    setState(() {
      _isUpdatingProgress = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2/api/update_progressmateri.php'),
      body: {
        'user_id': currentUserId,
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
    return Scaffold(
      appBar: AppBar(title: Text('Materi Pelajaran')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Materi atau Pengunggah',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _filteredMateriList.length,
                    itemBuilder: (context, index) {
                      final materi = _filteredMateriList[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: materi.fotoSampul.isNotEmpty
                              ? materi.fotoSampul
                              : 'https://via.placeholder.com/50',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 50,
                          height: 50,
                        ),
                        title: Text(materi.judul),
                        subtitle: Text(
                            'Bab: ${materi.bab} - Progress: ${(materi.progres * 100).toStringAsFixed(0)}%\nPengunggah: ${materi.pengunggahNama}'),
                        trailing: IconButton(
                          icon: Icon(
                            materi.isFavorite ? Icons.star : Icons.star_border,
                            color:
                                materi.isFavorite ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(materi),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaterialDetailPage(
                                materi: materi,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
