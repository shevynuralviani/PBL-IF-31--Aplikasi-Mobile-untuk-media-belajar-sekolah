import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genetika_app/screen/guru/guru_homepage.dart';
import 'package:genetika_app/screen/siswa/siswa_homepage.dart';
import 'package:genetika_app/screen/password/forget_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  bool isUsernameValid = true;
  bool isPasswordValid = true;
  bool _isPasswordVisible = false;

  // Fungsi login yang mengirim request ke backend
  Future<void> login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Username dan password harus diisi';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2/practice_api/loginuser.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final role = data['role'];

        setState(() {
          errorMessage = ''; // Reset error message if login is successful
        });

        // Simpan status login dan role user ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('role', role);

        // Menggunakan Navigator.pushNamedAndRemoveUntil untuk mengganti halaman
        if (role == 2) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/homeGuru', // Nama rute untuk halaman HomeGuru
            (route) => false, // Menghapus semua riwayat halaman sebelumnya
          );
        } else if (role == 3) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/homeSiswa', // Nama rute untuk halaman HomeSiswa
            (route) => false, // Menghapus semua riwayat halaman sebelumnya
          );
        } else {
          setState(() {
            errorMessage = 'Access denied for your role';
          });
        }
      } else {
        setState(() {
          errorMessage = data['message'];
        });
      }
    } else {
      setState(() {
        errorMessage = 'Server error, please try again later';
      });
    }
  }

  // Fungsi untuk dekorasi input (username dan password)
  InputDecoration _inputDecoration(String labelText, bool isValid) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: isValid ? Colors.black : Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: isValid ? Colors.green : Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Image.asset(
                    'assets/images/logo-sekolah.png',
                    height: 280,
                    width: 280,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'SMAIT ULIL ALBAB BATAM',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 18),
                  TextField(
                    controller: _usernameController,
                    decoration: _inputDecoration('Username', isUsernameValid),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration:
                        _inputDecoration('Password', isPasswordValid).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUsernameValid = _usernameController.text.isNotEmpty;
                        isPasswordValid = _passwordController.text.isNotEmpty;

                        if (!isUsernameValid) {
                          errorMessage = 'Username cannot be empty';
                        } else if (!isPasswordValid) {
                          errorMessage = 'Password cannot be empty';
                        } else {
                          errorMessage = '';
                          login(); // Panggil login jika valid
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7DBD07),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgetpassword');
                      },
                      child: Text(
                        'Forgotten your password? Reset Password',
                        style: TextStyle(
                          color: Color(0xFF7DBD07),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
