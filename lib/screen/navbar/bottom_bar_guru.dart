import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: const Color(0xFF7BBB07), // Warna hijau saat dipilih
        ),

        /// Materi
        SalomonBottomBarItem(
          icon: const Icon(Icons.book),
          title: const Text("Materi"),
          selectedColor: const Color(0xFF7BBB07), // Warna hijau saat dipilih
        ),

        /// Video
        SalomonBottomBarItem(
          icon: const Icon(Icons.video_library),
          title: const Text("Video"),
          selectedColor: const Color(0xFF7BBB07), // Warna hijau saat dipilih
        ),
      ],
    );
  }
}
