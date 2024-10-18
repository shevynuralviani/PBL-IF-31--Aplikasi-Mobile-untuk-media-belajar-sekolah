import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() {
  runApp(BottomBar());
}

class BottomBar extends StatefulWidget {
  static const title = 'salomon_bottom_bar';

  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BottomBar.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(BottomBar.title),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Color(0xFF7BBB07), // Warna hijau saat dipilih
            ),

            /// Book
            SalomonBottomBarItem(
              icon: const Icon(Icons.book),
              title: const Text("Materi"),
              selectedColor: Color(0xFF7BBB07), // Warna hijau saat dipilih
            ),

            /// Video
            SalomonBottomBarItem(
              icon: const Icon(Icons.video_library),
              title: const Text("Video"),
              selectedColor: Color(0xFF7BBB07), // Warna hijau saat dipilih
            ),

            /// Star
            SalomonBottomBarItem(
              icon: const Icon(Icons.star),
              title: const Text("Favorit"),
              selectedColor: Color(0xFF7BBB07), // Warna hijau saat dipilih
            ),
          ],
        ),
      ),
    );
  }
}
