import 'package:flutter/material.dart';
import 'package:genetika_app/screen/guru/upload%20_materi_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Pastikan ini diimpor
import 'package:genetika_app/screen/guru/add_materi_page.dart';
import 'package:genetika_app/screen/siswa/materi.dart';
import 'package:genetika_app/screen/login/login.dart';
import 'package:genetika_app/screen/login/started.dart';
import 'package:genetika_app/screen/siswa/siswa_homepage.dart';
import 'package:genetika_app/screen/siswa/videopage.dart';
import 'package:genetika_app/screen/siswa/favoritpage.dart';
import 'package:genetika_app/screen/password/forget_password.dart';
import 'package:genetika_app/screen/guru/guru_homepage.dart';
import 'package:genetika_app/screen/siswa/isi_materi.dart';
import 'package:genetika_app/screen/guru/materi_list_page.dart';
import 'package:genetika_app/screen/guru/edit_materi_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final isLoggedIn = token != null;
  final role = prefs.getString('role'); // Mengambil role sebagai string
  final currentUserId =
      prefs.getString('currentUserId'); // Mengambil currentUserId

  runApp(
      MyApp(isLoggedIn: isLoggedIn, role: role, currentUserId: currentUserId));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;
  final String? currentUserId;

  const MyApp(
      {super.key, required this.isLoggedIn, this.role, this.currentUserId});

  Future<Widget> _getInitialScreen() async {
    if (isLoggedIn) {
      if (role == 'guru') {
        return HomeGuru();
      } else if (role == 'siswa') {
        return HomeSiswa();
      }
    }
    return StartedScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
              '/materiRead': (context) => const ReadMateri(),
              '/addmateri': (context) => AddMateriPage(
                    onSave: (judul, file) {
                      Navigator.pop(context, {'judul': judul, 'file': file});
                    },
                  ),
              '/videoSiswa': (context) => VideoPage(),
              '/favoritSiswa': (context) => FavoritePage(),
              '/homeGuru': (context) => HomeGuru(),
              '/materilist': (context) => MateriListPage(),
              '/upload': (context) => UploadMateriPage(),
              '/edit': (context) => EditMateriPage(materi: {}),
            },
          );
        }
      },
    );
  }
}
