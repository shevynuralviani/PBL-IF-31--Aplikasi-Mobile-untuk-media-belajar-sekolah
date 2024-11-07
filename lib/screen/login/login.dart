import 'package:flutter/material.dart';
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

                  // Username field dengan validasi
                  TextField(
                    controller: _usernameController,
                    decoration: _inputDecoration('Username', isUsernameValid),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),

                  // Password field dengan validasi
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: _inputDecoration('Password', isPasswordValid)
                        .copyWith(
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

                  SizedBox(height: 20),

                  // Forgot Password Button
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        // Navigasi ke halaman Forget Password menggunakan MaterialPageRoute
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage()),
                        );
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
