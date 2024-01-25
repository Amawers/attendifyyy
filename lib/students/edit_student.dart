// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/students/list_of_student.dart';
import 'package:attendifyyy/utils/common_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class EditStudent extends StatefulWidget {
  String? student_id;
  String? section_id;
  String? subject_code;
  String? subject_id;
  String? subject_name;
  String? subject_teachers_id;

  EditStudent(
      {required this.student_id,
      required this.section_id,
      required this.subject_code,
      required this.subject_id,
      required this.subject_name,
      required this.subject_teachers_id});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  List<dynamic> studentData = [];

  TextEditingController referenceNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleInitialController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  String gradeLevelValue = gradeLevelList.first;

  final _studentFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await ApiServices.getStudentData(
        context: context, studentId: widget.student_id);

    setState(() {
      firstNameController.text = ApiServices.studentFname;
      middleInitialController.text = ApiServices.studentMinitial;
      lastNameController.text = ApiServices.studentLname;
      emailController.text = ApiServices.studentEmail;
      referenceNumberController.text = ApiServices.studentReferenceNumber;
      courseController.text = ApiServices.studentCourse;
      gradeLevelValue = ApiServices.studentGradeLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text(
            'EDIT STUDENT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Form(
            key: _studentFormKey,
            child: Column(
              children: [
                const SizedBox(height: 14),
                createTextField(
                  referenceNumberController,
                  'Reference Number',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
                      return "Must contain only numbers";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                createTextField(
                  firstNameController,
                  'First Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Must contain only letters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                createTextField(
                  middleInitialController,
                  'Middle Initial',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Must contain only letters";
                    } else if (value.length > 1) {
                      return "Character limit exceeded.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                createTextField(
                  lastNameController,
                  'Last Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Must contain only letters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
                createTextField(
                  courseController,
                  'Course',
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
                  value: gradeLevelValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      gradeLevelValue = value!;
                    });
                  },
                  items: gradeLevelList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    //validate textfields
                    if (_studentFormKey.currentState!.validate()) {
                      await ApiServices.editStudent(
                          context: context,
                          studentId: widget.student_id,
                          referenceNumber: referenceNumberController.text,
                          fName: firstNameController.text,
                          mName: middleInitialController.text,
                          lName: lastNameController.text,
                          email: emailController.text,
                          course: courseController.text,
                          gradeLevel: gradeLevelValue);
                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOfStudentsScreen(
                                    section_id: widget.section_id,
                                    subject_code: widget.subject_code,
                                    subject_id: widget.subject_id,
                                    subject_name: widget.subject_name,
                                    subject_teachers_id:
                                        widget.subject_teachers_id,
                                  )));
                    }
                    // setState(() {});
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
                    "Edit",
                    style: TextStyle(
                        backgroundColor: Color(0xFF081631),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
