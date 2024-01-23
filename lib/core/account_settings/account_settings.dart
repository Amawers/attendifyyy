// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
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
  TextEditingController contactNoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  // List<dynamic> teacherData = [];
  // String? imagePath;
  @override
  void initState() {
    super.initState();
    ApiServices.getTeacherData().then((_) {
      ApiServices.retrieveImage().then((_) {
        initializeControllerValues();
        setState(() {});
      });
    });
  }

  void initializeControllerValues() {
    fnameController.text = ApiServices.firstName ?? "";
    lnameController.text = ApiServices.lastName ?? "";
    emailController.text = ApiServices.email ?? "";
    contactNoController.text = ApiServices.contactNumber ?? "";
    departmentController.text = ApiServices.department ?? "";
  }

  // Future<void> retrieveImage() async {
  //   String? teacherId;
  //   try {
  //     // Assuming RememberUserPreferences.readUserInfo() returns a Map<String, dynamic>
  //     Map<String, dynamic>? teacherInfo =
  //         await RememberUserPreferences.readUserInfo();
  //     teacherId = teacherInfo?['teacher_id'];
  //   } catch (error) {
  //     print("Error loading user info: $error");
  //   }

  //   try {
  //     final response = await http
  //         .get(Uri.parse('${Api.retrieveImage}?teacher_id=$teacherId'));

  //     // Check if the response status code is OK (200)
  //     if (response.statusCode == 200) {
  //       // Decode the JSON response body
  //       Map<String, dynamic> responseBody = json.decode(response.body);

  //       // Check the 'status' field in the response
  //       if (responseBody['status'] == 1) {
  //         // Assuming the image path is stored in the 'image_path' field
  //         imagePath = responseBody['image_path'];

  //         // Do something with the imagePath, e.g., display the image
  //         print("Image Path: $imagePath");
  //       } else {
  //         // Handle the case where the status is not 1
  //         print("Failed to retrieve image path: ${responseBody['status']}");
  //       }
  //     } else {
  //       // Handle non-OK status codes
  //       print("Failed to retrieve image. Status code: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     // Handle network or other errors
  //     print("Error during image retrieval: $error");
  //   }
  //   setState(() {});
  // }

  /*
    *
    * ORIG
    *
    * */

  // Future<void> updateAccount() async {
  //   String? teacherId;

  //   Map<String, dynamic>? teacherInfo =
  //       await RememberUserPreferences.readUserInfo();
  //   teacherId = teacherInfo?['teacher_id'];

  //   try {
  //     final response = await http.put(Uri.parse(Api.updateAccount), body: {
  //       'teacher_id': teacherId,
  //       'first_name': fnameController.text,
  //       'last_name': lnameController.text,
  //       'email': emailController.text,
  //       'phone_number': contactNoController.text,
  //       'department': departmentController.text
  //     });

  //     if (response.statusCode == 200) {
  //       print("Connection to API established.");
  //       var decoded = jsonDecode(response.body);

  //       if (decoded['success'] == true) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             content: Text("UPDATE SUCCESSFULLY",
  //             style: TextStyle(fontWeight: FontWeight.bold)),
  //             backgroundColor: Colors.green,
  //             duration: Duration(seconds: 1)));
  //       } else if (decoded['success'] == false) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             content: Text("UPDATE FAILED",
  //             style: TextStyle(fontWeight: FontWeight.bold)),
  //             backgroundColor: Colors.red,
  //             duration: Duration(seconds: 1)));
  //       }
  //     } else {
  //       print("Problem communicating with API.");
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("PROBLEM COMMUNICATING WITH SERVER",
  //           style: TextStyle(fontWeight: FontWeight.bold)),
  //           backgroundColor: Colors.red,
  //           duration: Duration(seconds: 1)));
  //     }
  //   } catch (error) {
  //     print("Incorrect endpoints or problem with controller values.");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("AN APP ERROR OCCURED",
  //         style: TextStyle(fontWeight: FontWeight.bold)),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 1)));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Starting of AppBar Section
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Account Settings",
            style: TextStyle(color: Color(0xFF081631))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
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
                      child: ClipOval(
                        child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: ApiServices.imagePath != null
                                ? Image.network(
                                        'http://192.168.1.11/attendifyyy_backend/${ApiServices.imagePath}')
                                    .image
                                : Image.asset('assets/images/logo.png').image),
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
                      onPressed: () async {
                        await ApiServices.updateAccount(
                          context: context,
                          fnameController: fnameController,
                          lnameController: lnameController,
                          emailController: emailController,
                          contactNoController: contactNoController,
                          departmentController: departmentController,
                        );
                        await ApiServices.retrieveImage();
                        setState(() {
                          ApiServices.imagePath;
                        });
                      },
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