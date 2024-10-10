import 'package:flutter/material.dart';

class StartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // Tambahkan Container di sini
          padding: EdgeInsets.symmetric(horizontal: 20), // Atur padding di sini
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/get_start.png', // Ganti dengan path gambar Anda
                height: 280,
                width: 280,
              ),
              SizedBox(height: 20),
              Text(
                'The genetics material reader app',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Reading everywhere and anywhere with this app',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/login'); // Navigasi ke halaman login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7DBD07), // Use backgroundColor
                  padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15), // Tambahkan padding di sini
                  foregroundColor: Colors.black, // Set text color to black
                ),
                child: Text('Get started'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
