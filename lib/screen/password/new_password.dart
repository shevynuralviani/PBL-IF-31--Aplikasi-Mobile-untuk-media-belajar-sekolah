import 'package:flutter/material.dart';
import 'package:genetika_app/screen/password/change_password.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showError('Password fields cannot be empty.');
    } else if (newPassword != confirmPassword) {
      _showError('Passwords do not match.');
    } else if (newPassword.length < 5) {
      _showError('Password should be at least 5 characters long.');
    } else {
      // Implement password change logic here, for now navigating to next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
      );
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: const Text(
          'Buat Password Baru',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            const Text(
              'Masukkan password baru Anda.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            Text(
              'Masukan password baru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            // New Password Field
            TextFormField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              decoration: InputDecoration(
                hintText: 'min 5 character (huruf kecil, angka, dan simbol)',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ulangi Password Baru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: 'min 5 character (huruf kecil, angka, dan simbol)',
                hintStyle: TextStyle(color: Colors.grey), 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Submit Button
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7DBD07),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Kirim',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
