import 'dart:convert';
import 'dart:io';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageUpload extends StatelessWidget {
  late File _image;

  Future<void> _chooseImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      String? teacherId;
      try {
        // Assuming RememberUserPreferences.readUserInfo() returns a Map<String, dynamic>
        Map<String, dynamic>? teacherInfo =
            await RememberUserPreferences.readUserInfo();
        teacherId = teacherInfo?['teacher_id'];
      } catch (error) {
        print("Error loading user info: $error");
      }
      _image = File(pickedFile.path);
      var isUploaded = await _uploadImage(teacherId!, _image);
      if (isUploaded) {
        print('uploaded');
      } else {
        print('wala naupload');
      }
      print("Image selected!");
    }
  }

  Future<bool> _uploadImage(String user_id, File user_image) async {
    final bytes = user_image.readAsBytesSync();

    final data = {'teacher_id': user_id, 'teacher_image': base64Encode(bytes)};

    final response =
        await http.post(Uri.parse(Api.uploadImage), body: jsonEncode(data));

    final message = jsonDecode(response.body);

    if (message['status'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        ElevatedButton(
            onPressed: _chooseImageFromCamera, child: const Text("Camera")),
        ElevatedButton(onPressed: () {}, child: const Text("Choose Image")),
      ]),
    );
  }
}
