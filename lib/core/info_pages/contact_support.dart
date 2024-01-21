import 'package:flutter/material.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Starting of AppBar Section
      appBar: AppBar(
        title: const Text('Contact Support'), // Title of the app bar
      ), // Ending of AppBar Section
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contact_support_rounded,
                    color: Color(0xFF081631),
                    size: 35,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Contact Support',
                    style: TextStyle(
                      color: Color(0xFF081631),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 100),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 40, right: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF081631),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.6), // Set the shadow color
                    spreadRadius: 2, // Set the spread radius
                    blurRadius: 5, // Set the blur radius
                    offset: const Offset(2, 2), // Set the shadow offset
                  ),
                ],
              ),
              child: const Text(
                '''Contact Us:\nIf you have any questions or concerns about our Privacy Policy or data practices, please contact us [69iners45261@gmail.com/999-222-111].
                \nOur support team operates during regular business hours, and we aim to respond to inquiries promptly.
                \nFeedback:\nWe welcome your feedback and suggestions on how we can improve our app and services. Your input is valuable to us and helps us enhance your experience with the QR Code Attendance Checker App. Please send your feedback to [69iners45261@gmail.com].
                \nYour satisfaction is our top priority, and we are committed to providing you with excellent service and support. We look forward to assisting you and ensuring your experience with our app is a positive one.
                \nThank you for choosing QR Code Attendance Checker App.''',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 60),
                primary: const Color(0xFF081631),
                onPrimary: Colors.white,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'BACK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
