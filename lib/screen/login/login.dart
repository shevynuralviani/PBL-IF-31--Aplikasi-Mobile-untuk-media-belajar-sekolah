import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

    if (isLoggedIn) {
      if (role == '2') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/homeGuru', (route) => false);
      } else if (role == '3') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/homeSiswa', (route) => false);
      }
    }
  }

  Future<void> login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Username dan password harus diisi';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://lightblue-moose-868535.hostingersite.com/api/loginuser.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final role = data['role'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', role.toString());

          if (role == 2) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/homeGuru', (route) => false);
          } else if (role == 3) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/homeSiswa', (route) => false);
          } else {
            setState(() {
              errorMessage = 'Akses ditolak untuk role Anda';
            });
          }
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Login gagal, coba lagi.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Kesalahan server, coba lagi nanti.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
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
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
                        if (_usernameController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          errorMessage = 'Username dan password harus diisi';
                        } else {
                          errorMessage = '';
                          login();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7DBD07),
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        'Lupa password Anda?',
                        style: TextStyle(
                          color: Color(0xFF7DBD07),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
