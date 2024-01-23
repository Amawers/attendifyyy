


import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static String? imagePath;
  static String? firstName;
  static String? lastName;
  static String? email;
  static String? contactNumber;
  static String? department;

  static Future<void> updateAccount(
      {required BuildContext context,
      required TextEditingController fnameController,
      required TextEditingController lnameController,
      required TextEditingController emailController,
      required TextEditingController contactNoController,
      required TextEditingController departmentController}) async {
    String? teacherId;

    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();
    teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http.put(Uri.parse(Api.updateAccount), body: {
        'teacher_id': teacherId,
        'first_name': fnameController.text,
        'last_name': lnameController.text,
        'email': emailController.text,
        'phone_number': contactNoController.text,
        'department': departmentController.text
      });

      if (response.statusCode == 200) {
        print("Connection to API established.");
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("UPDATE SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("UPDATE FAILED",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        print("Problem communicating with API.");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      print("Incorrect endpoints or problem with controller values.");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("AN APP ERROR OCCURED",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)));
    }
  }

  static Future<void> retrieveImage() async {
    String? teacherId;
    try {
      // Assuming RememberUserPreferences.readUserInfo() returns a Map<String, dynamic>
      Map<String, dynamic>? teacherInfo =
          await RememberUserPreferences.readUserInfo();
      teacherId = teacherInfo?['teacher_id'];
    } catch (error) {
      print("Error loading user info: $error");
    }

    try {
      final response = await http
          .get(Uri.parse('${Api.retrieveImage}?teacher_id=$teacherId'));

      // Check if the response status code is OK (200)
      if (response.statusCode == 200) {
        // Decode the JSON response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Check the 'status' field in the response
        if (responseBody['status'] == 1) {
          // Assuming the image path is stored in the 'image_path' field
          imagePath = responseBody['image_path'];

          // Do something with the imagePath, e.g., display the image
          print("Image Path: $imagePath");
        } else {
          // Handle the case where the status is not 1
          print("Failed to retrieve image path: ${responseBody['status']}");
        }
      } else {
        // Handle non-OK status codes
        print("Failed to retrieve image. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error during image retrieval: $error");
    }
  }

  static Future<void> getTeacherData() async {
    List<dynamic> teacherData = [];

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
    firstName = teacherData[0]['first_name'];
    lastName = teacherData[0]['last_name'];
    email = teacherData[0]['email'];
    contactNumber = teacherData[0]['phone_number'];
    department = teacherData[0]['department'];
  }
}
