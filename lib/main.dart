import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genetika_app/screen/guru/guru_homepage.dart';
import 'package:genetika_app/screen/siswa/materi.dart';
import 'screen/login/login.dart';
import 'screen/login/started.dart';
import 'screen/siswa/siswa_homepage.dart';
import 'screen/navbar/custom_appbar.dart';
import 'screen/navbar/bottom_bar.dart';
import 'screen/siswa/videopage.dart';
import 'screen/siswa/favoritpage.dart';
import 'screen/password/forget_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final isLoggedIn = token != null; // Cek apakah sudah login
  final role = prefs.getInt('role'); // Ambil role pengguna

  runApp(MyApp(isLoggedIn: isLoggedIn, role: role));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final int? role;

  const MyApp({super.key, required this.isLoggedIn, this.role});

  Future<Widget> _getInitialScreen() async {
    if (isLoggedIn) {
      if (role == 2) {
        return HomeGuru(); // Halaman untuk guru
      } else if (role == 3) {
        return HomeSiswa(); // Halaman untuk siswa
      }
    }
    return StartedScreen(); // Jika belum login, arahkan ke halaman start
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Tampilan loading
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins'),
            home: snapshot.data,
            routes: {
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

Future<void> saveLoginStatus(String token, int role) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
  prefs.setBool('isLoggedIn', true);
  prefs.setInt('role', role);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token'); // Hapus token
  prefs.remove('isLoggedIn'); // Hapus status login
  prefs.remove('role'); // Hapus role pengguna
}
