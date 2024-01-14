import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/log_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  String _response = '';

  Future<void> postSignUp() async {
    final response = await http.post(
      Uri.parse(Api.signUp),
      body: {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phone_number': phoneNumberController.text,
        'department': departmentController.text,
      },
    );

    if (response.statusCode == 200) {
      _response = response.body;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_response)));
    } else {
      setState(() {
        _response = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: "First Name",
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFF9B9B9B))), // your color
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFF9B9B9B))), // your color
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFF9B9B9B))), // your color
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFF9B9B9B))), // your color
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFF9B9B9B))), // your color
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFF9B9B9B))), // your color
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: postSignUp,
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size.fromHeight(60)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF081631)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))
              ),
              child: const Text('SIGN UP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
                child: const Text('Already have an account? Sign in'))
          ],
        ),
      ),
    );
  }
}
