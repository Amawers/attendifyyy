import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/core/info_pages/contact_support.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Starting of AppBar Section
      appBar: AppBar(
        title: const Text("About App", style: TextStyle(color:  Color(0xFF081631) )), 
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed:  () => Navigator.pop(context),
            ),
        backgroundColor: Colors.white,
      ), // Ending of AppBar Section

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),
            // Section: Icon and Title
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Color(0xFF081631),
                    size: 35,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'About App',
                    style: TextStyle(
                      color: Color(0xFF081631),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Section: App Description
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF081631),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF081631).withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Text(
                '''Welcome to the QR Code Attendance Checker app, your trusted attendance management solution designed especially for schools and students!
                \nWho We Are:\n We are 3rd Year BSIT students under the guidance of Sir Gisan Dan Raniego, this is our final project for both terms. Our app is the brainchild of passionate individuals who understand the unique needs and challenges faced by schools and students. We are committed to providing an innovative mobile solution that saves time, reduces administrative burdens, and enhances efficiency in the education sector.
                \nOur Mission:\nOur mission is clear - to transform attendance management in schools through a user-friendly, feature-rich mobile app. We aim to empower educators, streamline administrative processes, and ensure students' academic success by providing an intuitive and reliable QR code-based attendance tracking platform.''',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            // Some additional SizedBox widgets
            const SizedBox(height: 10),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
