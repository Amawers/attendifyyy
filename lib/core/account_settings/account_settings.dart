import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/core/account_settings/image_upload.dart';
import 'package:attendifyyy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  List<dynamic> teacherData = [];

  @override
  void initState() {
    super.initState();
    getTeacherData();
  }

  Future<void> getTeacherData() async {
    String? teacherId;
    try {
      Map<String, dynamic>? teacherInfo =
          await RememberUserPreferences.readUserInfo();

      teacherId = teacherInfo?['teacher_id'];
    } catch (error) {
      print("Error lods: $error");
    }

    final response = await http
        .get(Uri.parse('${Api.getTeacherData}?teacher_id=$teacherId'));

    teacherData = jsonDecode(response.body);
    print("teacher data luds $teacherData");
    fnameController.text = teacherData[0]['first_name'];
    lnameController.text = teacherData[0]['last_name'];
    emailController.text = teacherData[0]['email'];
    // passwordController.text = teacherData[0];
    contactNoController.text = teacherData[0]['phone_number'];
    departmentController.text = teacherData[0]['department'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 80,
            color: TAppTheme.primaryColor,
          ),

          // Circular avatar and form fields
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile picture of the account
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Stack(children: [
                    Container(
                      width: 110.0,
                      height: 110.0,
                      child: const ClipOval(
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey,
                          // backgroundImage:
                          //     NetworkImage('https://picsum.photos/250?image=9'),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageUpload()),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),

              // Form fields
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name Field
                    const SizedBox(height: 5),
                    createTextField(
                        fnameController, 'First Name', Icons.person),
                    const SizedBox(height: 12),

                    // Last Name Field
                    const SizedBox(
                      height: 5,
                    ),
                    createTextField(lnameController, 'Last Name', Icons.person),
                    const SizedBox(height: 12),

                    //Email Field
                    const SizedBox(
                      height: 5,
                    ),
                    createTextField(emailController, 'Email', Icons.email),
                    const SizedBox(height: 12),

                    // Password Field
                    // Need to be obscured so separate jud siya sa createTextField na widget
                    // const SizedBox(height: 5,),
                    // createTextField(passwordController, 'Password', Icons.lock),
                    // const SizedBox(height: 12),

                    // Contact Number Field
                    const SizedBox(
                      height: 5,
                    ),
                    createTextField(
                        contactNoController, 'Contact No.', Icons.phone),
                    const SizedBox(height: 12),

                    // Department Field
                    const SizedBox(
                      height: 5,
                    ),
                    createTextField(
                        departmentController, 'Department', Icons.house),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size.fromHeight(60)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF081631)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'UPDATE',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for custom labels per field
Widget createLabel(label) {
  return Text(
    label,
    style: const TextStyle(
      color: Color(0xff081631),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );
}

// Widget for form fields
Widget createTextField(valueController, label, icon) {
  return TextFormField(
    controller: valueController,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      labelStyle: const TextStyle(
        color: Color(0xFFABABAB),
        fontSize: 14,
      ),
      floatingLabelStyle: const TextStyle(color: Color(0xFF081631)),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 2, color: Color(0xFF081631)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFABABAB)),
      ),
    ),
  );
}
