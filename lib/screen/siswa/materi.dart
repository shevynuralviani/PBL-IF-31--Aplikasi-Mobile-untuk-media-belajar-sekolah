import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genetika_app/models/materi_model.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for CachedNetworkImage

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  List<Materi> _materiList = [];
  List<Materi> _filteredMateriList = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  bool _isUpdatingProgress =
      false; // Untuk mengontrol loading saat update progress

  @override
  void initState() {
    super.initState();
    fetchMateri();
    _searchController.addListener(_onSearchChanged);
  }

  // Fetch materi dari API
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
            _filteredMateriList = _materiList;
            _isLoading = false;
          });
        } else {
          _showErrorSnackbar('Failed to fetch materi');
        }
      } else {
        _showErrorSnackbar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to fetch materi: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Menampilkan snackbar error
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Fungsi pencarian dengan debounce
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _filteredMateriList = _materiList
            .where((materi) => materi.judul.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  // Update progress materi
  Future<void> updateProgress(Materi materi) async {
    if (_isUpdatingProgress) return; // Mencegah klik ganda saat update

    setState(() {
      _isUpdatingProgress = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2/api/update_progressmateri.php'),
      body: {
        'user_id': 'USER_ID', // Ganti dengan ID user yang sesuai
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update progress')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materi Pelajaran'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MateriSearchDelegate(
                  materiList: _materiList,
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari materi...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredMateriList.length,
              itemBuilder: (context, index) {
                final materi = _filteredMateriList[index];

                String imageUrl = materi.photoUrl.isNotEmpty
                    ? materi.photoUrl
                    : 'assets/placeholder_image.jpg';

                String pdfUrl = materi.pdfUrl.isNotEmpty
                    ? materi.pdfUrl
                    : 'assets/placeholder_pdf.pdf';

                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 50,
                    height: 50,
                  ),
                  title: Text(materi.judul),
                  subtitle: Text(
                      'Bab: ${materi.bab} - Progres: ${(materi.progres * 100).toStringAsFixed(0)}%'),
                  trailing: IconButton(
                    icon: Icon(
                      materi.isFavorite ? Icons.star : Icons.star_border,
                      color: materi.isFavorite ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        materi.isFavorite = !materi.isFavorite;
                      });
                      updateProgress(materi);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      materi.progres += 0.1;
                      if (materi.progres > 1.0) materi.progres = 1.0;
                    });
                    updateProgress(materi);
                  },
                );
              },
            ),
    );
  }
}

// Search delegate for searching materi
class MateriSearchDelegate extends SearchDelegate {
  final List<Materi> materiList;

  MateriSearchDelegate({required this.materiList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = materiList
        .where((materi) =>
            materi.judul.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final materi = results[index];
        return ListTile(
          title: Text(materi.judul),
          subtitle: Text('Bab: ${materi.bab}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = materiList
        .where((materi) =>
            materi.judul.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final materi = suggestions[index];
        return ListTile(
          title: Text(materi.judul),
          subtitle: Text('Bab: ${materi.bab}'),
        );
      },
    );
  }
}
