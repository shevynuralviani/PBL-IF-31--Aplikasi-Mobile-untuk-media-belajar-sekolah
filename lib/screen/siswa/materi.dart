import 'package:flutter/material.dart';
import 'package:genetika_app/screen/siswa/siswa_homepage.dart';
import 'package:genetika_app/screen/siswa/videopage.dart';


class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  // List to keep track of which items are favorited
  List<bool> isFavorited = [false, false, false, false];
  
  int _selectedIndex = 1; // Track selected bottom nav item

  // List halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const HomeSiswa(),
    const MateriPage(),
    VideoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Materi Pelajaran'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding added to the whole body
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildFavoriteItem(
                  title: 'Enzim Dan Metabolisme',
                  subtitle: 'Biology, Bab 1',
                  progressText: 'Page 11 from 50 (40%)',
                  progressValue: 0.4,
                  index: 0,
                ),
                const SizedBox(height: 20), // Space between items
                buildFavoriteItem(
                  title: 'Sel dan Jaringan',
                  subtitle: 'Biology, Bab 2',
                  progressText: 'Page 5 from 30 (17%)',
                  progressValue: 0.17,
                  index: 1,
                ),
                const SizedBox(height: 20), // Space between items
                buildFavoriteItem(
                  title: 'Genetika dan Pewarisan',
                  subtitle: 'Biology, Bab 3',
                  progressText: 'Page 20 from 45 (44%)',
                  progressValue: 0.44,
                  index: 2,
                ),
                const SizedBox(height: 20), // Space between items
                buildFavoriteItem(
                  title: 'Ekosistem dan Lingkungan',
                  subtitle: 'Biology, Bab 4',
                  progressText: 'Page 8 from 25 (32%)',
                  progressValue: 0.32,
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a favorite item with a clickable star
  Widget buildFavoriteItem({
    required String title,
    required String subtitle,
    required String progressText,
    required double progressValue,
    required int index,
  }) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF7BBB07).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 65,
                height: 80,
                color: const Color(0xFFB4D924),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle),
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      Text(progressText),
                      const SizedBox(height: 10),
                      Container(
                        width: 150, // Adjust width as needed
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7BBB07)),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(
              isFavorited[index] ? Icons.star : Icons.star_border,
              color: isFavorited[index] ? const Color(0xFF396F04) : Colors.grey,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                // Toggle favorite status
                isFavorited[index] = !isFavorited[index];
              });
            },
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MateriPage(),
    debugShowCheckedModeBanner: false,
  ));
}
