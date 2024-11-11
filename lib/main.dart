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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getInt('role');

    if (isLoggedIn) {
      if (role == 2) {
        return const HomeGuru(); // Halaman untuk guru
      } else if (role == 3) {
        return const HomeSiswa(); // Halaman untuk siswa
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
          return const CircularProgressIndicator(); // Tampilan loading
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins'),
            home: snapshot
                .data, // The screen will be determined by the login status
            routes: {
              '/login': (context) => LoginScreen(),
              'forgetpassword': (context) => ForgetPasswordPage(),
              '/homeSiswa': (context) => const HomeSiswa(),
              '/materiSiswa': (context) => const MateriPage(),
              '/videoSiswa': (context) => VideoPage(),
              '/favoritSiswa': (context) => FavoritePage(),
              '/homeGuru': (context) => const HomeGuru(),
            },
          );
        }
      },
    );
  }
}
