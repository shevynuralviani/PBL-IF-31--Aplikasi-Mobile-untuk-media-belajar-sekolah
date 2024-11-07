import 'package:flutter/material.dart';
import 'package:genetika_app/screen/password/verifikasi_kode.dart';

class ForgetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: const Text(
          'Forget Password',
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
              'Masukkan email Anda untuk menerima link reset password.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman verifikasi kode
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifikasiKodePage()),
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
}
