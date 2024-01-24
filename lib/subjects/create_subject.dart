// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/subjects/list_of_subject.dart';
import 'package:attendifyyy/utils/common_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateSubject extends StatefulWidget {
  @override
  _CreateSubject createState() => _CreateSubject();
}

class _CreateSubject extends State<CreateSubject> {
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController subjectCodeController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();

  String semesterValue = semesterList.first;

  final _subjectFormKey = GlobalKey<FormState>();

  // Future<void> createSubject() async {
  //   Map<String, dynamic>? teacherInfo =
  //       await RememberUserPreferences.readUserInfo();

  //   String teacherId = teacherInfo?['teacher_id'];

  //   final response = await http.post(Uri.parse(Api.createSubject), body: {
  //     'teacher_id': teacherId,
  //     'subject_name': subjectNameController.text,
  //     'subject_code': subjectCodeController.text,
  //     'section_name': sectionNameController.text,
  //     'semester': semesterValue
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text(
            'ADD SUBJECT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Form(
            key: _subjectFormKey,
            child: Column(
              children: [
                const SizedBox(height: 14),
                createTextField(
                  subjectNameController,
                  "Subject Name",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                createTextField(
                  subjectCodeController,
                  "Subject Code",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.length > 10) {
                      return "Character limit exceeded.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                createTextField(
                  sectionNameController,
                  "Section",
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButton<String>(
                  isExpanded: true, //set width to 100%
                  value: semesterValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      semesterValue = value!;
                    });
                  },
                  items: semesterList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    //validate textfields
                    if (_subjectFormKey.currentState!.validate()) {
                      //create subject in the database
                      ApiServices.createSubject(
                          context: context,
                          subject: subjectNameController.text,
                          subjectCode: subjectCodeController.text,
                          section: sectionNameController.text,
                          semester: semesterValue);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOfSubjects()));
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(55),
                    ), //having height will make width 100%
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 44.0),
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
                    "Add",
                    style: TextStyle(
                      backgroundColor: Color(0xFF081631),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
