// ignore_for_file: use_build_context_synchronously
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'package:attendifyyy/utils/common_widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/sign_up.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

// DOUBLESSSSS
class _LogInState extends State<LogIn> {
  bool obscurePassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  String _response = "";
  String? email;
  String? pass;
  var resBodyOfLogin;
  Map<String, dynamic>? teacherInfo;

  //first load
  @override
  void initState() {
    super.initState();
    fillInLoginCredentials();
  }

  //in first page load if there is an existing credentials stored in local storage
  //occupy the email and password controller with those values
 Future<void> fillInLoginCredentials() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

      if(_prefs.getString('remember_email') != null &&
          _prefs.getString('remember_pass') != null) {
        setState(() {
        emailController.text = _prefs.getString('remember_email')!;
        passwordController.text = _prefs.getString('remember_pass')!;
        rememberMe = true;
        });
      }
  }

  //post credential to database
  Future<void> postSignUp() async {
    //this is for post
    final response = await http.post(
      Uri.parse(Api.logIn),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      resBodyOfLogin = jsonDecode(response.body);
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

    /*
    *
    * this is for remembering credentials
    *
    * */

    //remember credentials if remember me checkbox is checked
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    //remember credentials if remember me checkbox is checked
    if (rememberMe) {
      //check if remember credentials not exist in local storage
      if (_prefs.getString('remember_email') == null &&
          _prefs.getString('remember_pass') == null) {
        //if not exist, store credentials to local
        await _prefs.setString('remember_email', emailController.text);
        await _prefs.setString('remember_pass', passwordController.text);
      }
    }
    //if remember me checkbox is unchecked, remove the local stored credentials
    else if (!rememberMe) {
      if (_prefs.getString('remember_email') != null &&
          _prefs.getString('remember_pass') != null) {
        //if not exist, store credentials to local
        await _prefs.remove('remember_email');
        await _prefs.remove('remember_pass');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              createTextField(emailController, 'Email', (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required.";
                } else if (!EmailValidator.validate(value)) {
                  return "Please use a valid email address.";
                }
                return null;
              }),
              const SizedBox(height: 20),
              //Password with obscure sht
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  labelStyle: const TextStyle(
                      color: Color(0xFFABABAB),
                      fontSize: 14), //affect the size of textfield
                  floatingLabelStyle: const TextStyle(color: Color(0xFF081631)),
                  //when textField is focused or selected
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF081631))),
                  //normal state of textField border
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFABABAB))), // your color
                  errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFFFF0000))),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFFF0000))),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    child: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF081631),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Checkbox(
                      value: rememberMe,
                      activeColor: const Color(0xFF081631),
                      onChanged: (value) {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      }),
                  const Text("Remember Me",
                      style: TextStyle(
                          color: Color(0xFF081631),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    postSignUp();
                  }
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(60)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF081631)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: const Text('LOG IN',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF777777)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      style: ButtonStyle(
                        //this padding is the distance between ...account? and Sign up text
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(5.0)),
                      ),
                      child: const Text('Sign up',
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFF081631))))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}