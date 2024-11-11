import 'package:flutter/material.dart';

class StartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // Added padding around the content
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/get_start.png', // Path to your image
                height: 280,
                width: 280,
              ),
              SizedBox(height: 20),
              Text(
                'The genetics material reader app',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Reading everywhere and anywhere with this app',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/login'); // Navigating to login screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7DBD07), // Set button color
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15), // Button padding
                  foregroundColor: Colors.black, // Text color of button
                ),
                child: Text('Get started'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
