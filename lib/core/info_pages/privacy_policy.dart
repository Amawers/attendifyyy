import "package:flutter/material.dart";

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(color:  Color(0xFF081631))), 
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed:  () => Navigator.pop(context),
            ),
        backgroundColor: Colors.white,
      ),

      // Body with Privacy Policy Information
      body: ListView(
        padding: const EdgeInsets.all(14.0),
        children: [
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,             
            children: [  
              Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/privacy.png')
                  ),
                ),
              ),
              const Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 26,
                  color: Color.fromARGB(255, 0, 29, 53),
                  fontWeight: FontWeight.bold,
                ),
              ),           
            ],
            
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: const[
                BoxShadow(
                  color: Color.fromARGB(255, 80, 80, 80),
                  spreadRadius: 0.6,
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),              
              color: Color.fromARGB(255, 235, 233, 233)),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              "Thank you for choosing the QR Code Attendance Checker App. We are committed to safeguarding your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, disclose, and protect your data. By using our app, you consent to the practices described herein. ",
              style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
                boxShadow: const[
                  BoxShadow(
                    color: Color.fromARGB(255, 80, 80, 80),
                    spreadRadius: 0.6,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black),
                color: const Color(0xFF081631)),
            padding: const EdgeInsets.all(10.0),
            child: const Column(
              children: [
                Text(
                  "How We Use Your Information: We use the information we collect for the following purposes:",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "1. Attendance Tracking: Your attendance data is used to facilitate efficient attendance management for educational institutions.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "2. App Improvement: We use usage data to analyze app performance and make improvements to enhance the user experience.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
