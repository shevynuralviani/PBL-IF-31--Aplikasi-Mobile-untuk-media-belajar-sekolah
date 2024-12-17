import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genetika_app/screen/password/change_password.dart';
import 'package:genetika_app/screen/login/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.red,
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Color(0xFF7BBB07), width: 2),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyCustomAppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo-sekolah.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Expanded(
              // Menggunakan Expanded di sini
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SMA IT',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'ULIL ALBAB BATAM',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _showProfileDropdown(context);
                },
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF7BBB07), width: 2),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.person, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showProfileDropdown(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 70, 0, 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF7BBB07), width: 2),
      ),
      items: [
        const PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.person, color: Colors.black),
                title: Text(
                  'Rina Suryani',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'XII IPA 3',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'nis : 123456789',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey),
            ],
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.lock, color: Colors.black),
            title: const Text(
              'Change Password',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmationDialog(
                  context); // Tampilkan konfirmasi logout
            },
          ),
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 300,
            height: 300,
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo-sekolah.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog konfirmasi logout
                await logout(context); // Panggil fungsi logout
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Pastikan hanya logout jika pengguna sedang login
    if (isLoggedIn) {
      // Ambil role dan currentUserId dari SharedPreferences
      String? role = prefs.getString('role');
      String? currentUserId = prefs.getString('currentUserId');

      // Anda bisa menambahkan pengecekan lebih lanjut berdasarkan role atau currentUserId
      if (role != null && currentUserId != null) {
        print('User with ID $currentUserId and role $role is logging out.');
      }

      // Hapus semua data terkait login
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('currentUserId'); // Hapus currentUserId setelah logout
      await prefs.remove('role'); // Hapus peran pengguna
      await prefs.remove('token'); // Hapus token yang tersimpan
      await prefs.remove('user'); // Hapus data pengguna lainnya

      // Kembali ke halaman login setelah logout
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login', // Rute untuk halaman login
        (route) => false, // Menghapus semua riwayat halaman sebelumnya
      );
    } else {
      // Jika pengguna belum login, arahkan ke halaman login
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }
}
