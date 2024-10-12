import 'package:flutter/material.dart';
import 'package:genetika_app/screen/login/login.dart';
import 'package:genetika_app/screen/login/started.dart';
import 'package:genetika_app/screen/siswa/siswa_homepage.dart';

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
        '/home': (context) => HomeSiswa(),
      },
    );
  }
}
