import 'package:flutter/material.dart';
import 'package:genetika_app/screen/password/new_password.dart';


class VerifikasiKodePage extends StatelessWidget {
  // Membuat TextEditingControllers untuk setiap kotak kode verifikasi
  final TextEditingController kode1 = TextEditingController();
  final TextEditingController kode2 = TextEditingController();
  final TextEditingController kode3 = TextEditingController();
  final TextEditingController kode4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: const Text(
          'Verifikasi',
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
          children: [
            SizedBox(height: 30),
            const Text(
              'Masukkan kode verifikasi',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKodeInput(kode1, context),
                SizedBox(width: 8), // Jarak antar kotak
                _buildKodeInput(kode2, context),
                SizedBox(width: 8), // Jarak antar kotak
                _buildKodeInput(kode3, context),
                SizedBox(width: 8), // Jarak antar kotak
                _buildKodeInput(kode4, context),
              ],
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Fungsi kirim kode verifikasi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPasswordPage()),
                );
              },
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

  // Fungsi untuk membuat kotak input satu digit
  Widget _buildKodeInput(TextEditingController controller, BuildContext context) {
    return SizedBox(
      width: 50, // Lebar kotak kecil untuk setiap digit
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1, // Membatasi input menjadi satu digit
        decoration: InputDecoration(
          counterText: '', // Menghilangkan penghitung karakter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.green, width: 2.0), // Warna hijau saat fokus
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // Pindah ke input berikutnya
          }
        },
      ),
    );
  }
}
