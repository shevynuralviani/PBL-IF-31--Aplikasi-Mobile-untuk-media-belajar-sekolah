import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit'),
      ),
      body: const Center(
        child: Text(
          'Tidak ada materi dan video favorit',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
