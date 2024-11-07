import 'package:flutter/material.dart';
import 'package:genetika_app/screen/siswa/materi.dart';
import 'screen/login/login.dart';
import 'screen/login/started.dart';
import 'screen/siswa/siswa_homepage.dart';
import 'screen/navbar/custom_appbar.dart';
import 'screen/navbar/bottom_bar.dart';
import 'screen/siswa/materi.dart';
import 'screen/siswa/videopage.dart';
import 'screen/siswa/favoritpage.dart';
import 'screen/password/forget_password.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: StartedScreen(),
      routes: {
        '/login': (context) =>
            LoginScreen(), // Define the route for the login page
         'forgetpaswword': (context) => ForgetPasswordPage(),
        '/home': (context) => const HomeSiswa(),
        '/materi': (context) => const MateriPage(),
        '/video': (context) => VideoPage(),
        '/favorit': (context) => FavoritePage(),

      },
    );
  }
}
