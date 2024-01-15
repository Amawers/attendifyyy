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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          //center signup fields or context vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 130,
              fit: BoxFit.contain,
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: "First Name",
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelStyle: TextStyle(
                    color: Color(0xFFABABAB),
                    fontSize: 14), //affect the size of textfield
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                //when textField is focused or selected
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                //normal state of textField border
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFABABAB))), // your color
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelStyle: TextStyle(color: Color(0xFFABABAB), fontSize: 14),
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFABABAB))), // your color
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelStyle: TextStyle(color: Color(0xFFABABAB), fontSize: 14),
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFABABAB))), // your color
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelStyle: TextStyle(color: Color(0xFFABABAB), fontSize: 14),
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFABABAB))), // your color
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelStyle: TextStyle(color: Color(0xFFABABAB), fontSize: 14),
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFABABAB))), // your color
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelStyle: TextStyle(color: Color(0xFFABABAB), fontSize: 14),
                floatingLabelStyle: TextStyle(color: Color(0xFF081631)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFABABAB))), // your color
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: postSignUp,
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(60)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF081631)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              child: const Text('SIGN UP',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF777777)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    style: ButtonStyle(
                      //this padding is the distance between ...account? and Sign in text
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(5.0)),
                    ),
                    child: const Text('Sign in',
                        style: TextStyle(
                            fontSize: 16.0, color: Color(0xFF081631))))
              ],
            )
          ],
        ),
      ),
    );
  }
}
