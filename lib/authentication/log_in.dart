// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _response = '';

  Future<void> postSignUp() async {
    final response = await http.post(
      Uri.parse(Api.logIn),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      var resBodyOfLogin = jsonDecode(response.body);
      if (resBodyOfLogin['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Log in successfully")));

        await RememberUserPreferences.storeUserInfo(
            resBodyOfLogin["teacherData"]);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    } else {
      setState(() {
        _response = 'Not connected to backend or no response';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: postSignUp,
              child: Text('Log In'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
