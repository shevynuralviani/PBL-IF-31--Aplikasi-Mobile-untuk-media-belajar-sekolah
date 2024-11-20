import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genetika_app/screen/guru/guru_homepage.dart';
import 'package:genetika_app/screen/siswa/materi.dart';
import 'screen/login/login.dart';
import 'screen/login/started.dart';
import 'screen/siswa/siswa_homepage.dart';
import 'screen/siswa/videopage.dart';
import 'screen/siswa/favoritpage.dart';
import 'screen/password/forget_password.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Untuk memastikan Flutter siap sebelum menjalankan kode async
  final prefs =
      await SharedPreferences.getInstance(); // Mengakses penyimpanan lokal
  final token = prefs.getString('token'); // Ambil token login (jika ada)
  final isLoggedIn = token != null; // Cek apakah pengguna sudah login
  final role = prefs.getInt('role'); // Ambil peran pengguna (role)

  runApp(MyApp(isLoggedIn: isLoggedIn, role: role)); // Jalankan aplikasi
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // Status login pengguna
  final int? role; // Peran pengguna (misalnya, guru atau siswa)

  const MyApp({super.key, required this.isLoggedIn, this.role});

  // Menentukan layar awal berdasarkan status login dan peran
  Future<Widget> _getInitialScreen() async {
    if (isLoggedIn) {
      // Jika sudah login, tentukan berdasarkan peran
      if (role == 2) {
        return HomeGuru(); // Halaman untuk guru
      } else if (role == 3) {
        return HomeSiswa(); // Halaman untuk siswa
      }
    }
    // Jika belum login, arahkan ke halaman mulai
    return StartedScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(), // Panggil fungsi untuk menentukan layar awal
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading saat layar awal diproses
          return const Center(child: CircularProgressIndicator());
        } else {
          // Jika layar awal sudah ditentukan, jalankan aplikasi
          return MaterialApp(
            debugShowCheckedModeBanner: false, // Hilangkan banner debug
            theme: ThemeData(fontFamily: 'Poppins'), // Atur tema aplikasi
            home: snapshot.data, // Layar awal
            routes: {
              // Definisikan rute (navigasi halaman)
              '/login': (context) => LoginScreen(),
              '/forgetpassword': (context) => ForgetPasswordPage(),
              '/homeSiswa': (context) => HomeSiswa(),
              '/materiSiswa': (context) => MateriPage(),
              '/videoSiswa': (context) => VideoPage(),
              '/favoritSiswa': (context) => FavoritePage(),
              '/homeGuru': (context) => HomeGuru(),
            },
          );
        }
      },
    );
  }
}

// Fungsi untuk menyimpan status login
Future<void> saveLoginStatus(String token, int role) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token); // Simpan token
  prefs.setBool('isLoggedIn', true); // Tandai sudah login
  prefs.setInt('role', role); // Simpan peran pengguna
}

// Fungsi untuk logout
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token'); // Hapus token
  prefs.remove('isLoggedIn'); // Hapus status login
  prefs.remove('role'); // Hapus peran pengguna
}
