import 'package:flutter/material.dart';

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

  // Fungsi untuk mengembalikan InputDecoration dengan border hijau atau merah berdasarkan validasi
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
      resizeToAvoidBottomInset: true, // Pastikan diatur ke true atau dihapus
      body: SafeArea(
        // SafeArea untuk menghindari area sistem
        child: SingleChildScrollView(
          // Menambahkan SingleChildScrollView
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                // Tidak perlu mainAxisAlignment.center karena SingleChildScrollView sudah mengatur scroll
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50), // Memberikan jarak dari atas
                  // Logo sekolah
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

                  // Username field dengan validasi
                  TextField(
                    controller: _usernameController,
                    decoration: _inputDecoration('Username', isUsernameValid),
                    style: TextStyle(color: Colors.black), // Warna teks input
                  ),

                  SizedBox(height: 20),

                  // Password field dengan validasi
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Password', isPasswordValid),
                    style: TextStyle(color: Colors.black), // Warna teks input
                  ),

                  SizedBox(height: 10),

                  // Pesan kesalahan
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),

                  SizedBox(height: 20),

                  // Tombol Login
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUsernameValid = _usernameController.text.isNotEmpty;
                        isPasswordValid =
                            _passwordController.text == 'password123';

                        if (!isUsernameValid) {
                          errorMessage = 'Username cannot be empty';
                        } else if (!isPasswordValid) {
                          errorMessage = 'Wrong Password';
                        } else {
                          errorMessage = '';
                          Navigator.pushReplacementNamed(context, '/home');
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

                  SizedBox(height: 10),

                  // Forgot Password
                  TextButton(
                    onPressed: () {
                      // Aksi ketika klik reset password
                    },
                    child: Text('Forgotten your password? Reset Password'),
                  ),

                  SizedBox(height: 50), // Memberikan jarak dari bawah
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
