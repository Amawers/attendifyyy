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
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('assets/images/privacy.png')
                  ),
                ),
              ),
              const Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 30,
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
            child: const Column(
              children: [
                Text(
                  "Thank you for choosing the QR Code Attendance Checker App. We are committed to safeguarding your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, disclose, and protect your data. By using our app, you consent to the practices described herein. ",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    
                    "Information We Collect:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Text(
                  "1.User Account Information: To use our app, you may be required to create an account. We collect information such as your name, email address, and password to set up and manage your account.",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "2.Attendance Data: Our app collects attendance records, which may include student names, dates, and times of attendance. This information is used solely for attendance tracking purposes.",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "3.Device Information: We may collect information about the device you use to access our app, including the device's unique identifier, operating system, and version.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "4.Usage Data: We gather data on how you interact with our app, including your interactions with features and the frequency and duration of your app usage.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
              ],
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
                Text(
                  "3. Account Management: Your account information is used to manage your app account and provide customer support.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "4. Communication: We may use your email address to send important updates, service-related announcements, and promotional information. You can opt out of promotional ",
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
