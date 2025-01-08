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

  // Get current user ID from SharedPreferences
  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('currentUserId') ?? '';
    });
  }

  // Fetch Materi data from the API
  Future<void> fetchMateri() async {
    try {
      final response = await http.get(Uri.parse(
        'https://lightblue-moose-868535.hostingersite.com/api/get_materi.php',
      ));

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

  // Display a Snackbar message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Filter the Materi list based on search query
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

  // Update progress of Materi to the server
  Future<void> updateProgress(Materi materi) async {
    if (_isUpdatingProgress) return;

    setState(() {
      _isUpdatingProgress = true;
    });

    final response = await http.post(
      Uri.parse(
        'https://lightblue-moose-868535.hostingersite.com/api/update_progressmateri.php',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': currentUserId, // ID pengguna
        'materi_id': materi.id.toString(), // ID materi
        'progres': materi.progres
            .toStringAsFixed(0), // Pastikan progres adalah integer
        'last_read': DateTime.now().toIso8601String(), // Timestamp saat ini
        'is_favorite':
            materi.isFavorite ? 1 : 0, // 1 jika favorit, 0 jika tidak
      }),
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
                            color: materi.isFavorite
                                ? Colors.green
                                : Colors
                                    .grey, // Ganti warna bintang menjadi hijau
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

  // Toggle favorite status of Materi
  void _toggleFavorite(Materi materi) {
    setState(() {
      materi.isFavorite = !materi.isFavorite;
    });
    updateProgress(materi); // Update progress after toggling favorite
  }
}
