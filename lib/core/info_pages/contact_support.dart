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
       appBar: AppBar(
        title: const Text("Contact Support", style: TextStyle(color:  Color(0xFF081631) )), 
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed:  () => Navigator.pop(context),
            ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14.0),
        children: [
          const SizedBox(height: 12.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,             
            children: [
              Icon(
                Icons.contact_support_rounded,
                color: Color(0xFF081631),
                size: 35,
              ),  
              Text(
                "Contact Support",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 0, 29, 53),
                  fontWeight: FontWeight.bold,
                ),
              ),           
            ],
            
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
                  "Contact Us:",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "If you have any questions or concerns about our Privacy Policy or data practices, please contact us at:",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(" "),
                Text(
                  "[Attendify@gmail.com/999-222-111]",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(''),
                Text(
                  "Our support team operates during regular business hours, and we aim to respond to inquiries promtly.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(''),
                Text(
                  "Feedback:",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "We welcome your feedback and suggestions on how we can imporove our app and services. Your input is valuable to us and helps us enhance your experience with the QR Code Attendnce Checker App. Please send your feedback to:",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(''),
                Text(
                  "[Attendify@gmail.com].",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(''),
                Text(
                  "Your satisfaction is out top priority, and we are comitted to providing you with excellent service and support. We look forward to assisting you and ensuring your experience with our app is a positive one.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(''),
                Text(
                  "Thank you for choosing QR Code Attendance",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  "Checker App",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),                
              ],
            ),
          ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [                   
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: (){},
                        splashColor: Colors.grey,                   
                        child: Ink.image(                       
                          image: const AssetImage('assets/images/facebook.png'),
                          fit: BoxFit.cover,  
                          width: 70,   
                          height: 70,                                           
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: (){},
                        splashColor: Colors.grey,                   
                        child: Ink.image(                       
                          image: const AssetImage('assets/images/github.png'),
                          fit: BoxFit.cover,  
                          width: 70,   
                          height: 70,                                           
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: (){},
                        splashColor: Colors.grey,                   
                        child: Ink.image(                       
                          image: const AssetImage('assets/images/discord.png'),
                          fit: BoxFit.cover,  
                          width: 70,   
                          height: 70,                                           
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
