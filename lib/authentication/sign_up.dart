// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/log_in.dart';
import 'package:attendifyyy/utils/common_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool obscurePassword = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  String _response = '';

  final _formKey = GlobalKey<FormState>();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_response),
        ),
      );
    } else {
      setState(
        () {
          _response = 'Error';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              //center signup fields or context vertically
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                createTextField(
                  firstNameController,
                  'First Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Must contain only letters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                createTextField(
                  lastNameController,
                  'Last Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Must contain only letters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                createTextField(
                  emailController,
                  'Email',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (!EmailValidator.validate(value)) {
                      return "Please use a valid email address.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
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
                    floatingLabelStyle:
                        const TextStyle(color: Color(0xFF081631)),
                    //when textField is focused or selected
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF081631)),
                    ),
                    //normal state of textField border
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFFABABAB)),
                    ), // your color
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFFFF0000)),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFFF0000)),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            obscurePassword = !obscurePassword;
                          },
                        );
                      },
                      child: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF081631),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.length <= 8) {
                      return "Password must exceed 8 characters.";
                    } else if (!value.contains(RegExp(r'[A-Z]'))) {
                      return "Password must have at least one uppercase letter.";
                    } else if (!value.contains(RegExp(r'[0-9]'))) {
                      return "Password must have at least one number.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                createTextField(
                  phoneNumberController,
                  'Phone Number',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.length <= 10) {
                      return "Please input the correct number.";
                    } else if (value.contains(RegExp(r'[A-Z, a-z]'))) {
                      return "Must contain only numbers.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                createTextField(
                  departmentController,
                  'Department',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Must contain only letters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      postSignUp();
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(60),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF081631),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF777777),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      style: ButtonStyle(
                        //this padding is the distance between ...account? and Sign in text
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(5.0),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF081631),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
*
* Widget components
*
*
* */
Widget createTextField(valueController, label, validationFunction) {
  return TextFormField(
    validator: validationFunction,
    controller: valueController,
    decoration: InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      labelStyle: const TextStyle(
          color: Color(0xFFABABAB),
          fontSize: 14), //affect the size of textfield
      floatingLabelStyle: const TextStyle(color: Color(0xFF081631)),
      //when textField is focused or selected
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
      //normal state of textField border
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xFFABABAB))), // your color
      //border style when error
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xFFFF0000))),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xFFFF0000))),
    ),
  );
}
