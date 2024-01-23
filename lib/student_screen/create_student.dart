// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/student_screen/list_of_student.dart';
import 'package:attendifyyy/utils/common_widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class CreateStudent extends StatefulWidget {
  String? section_id;
  String? subject_id;

  CreateStudent({required this.section_id, required this.subject_id});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
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
  }

  Future<void> createStudent() async {
    final response = await http.post(Uri.parse(Api.createStudent), body: {
      'reference_number': referenceNumberController.text,
      'first_name': firstNameController.text,
      'middle_initial': middleInitialController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'course': courseController.text,
      'grade_level': gradeLevelValue,
      'section_id': widget.section_id,
      'subject_id': widget.subject_id
    });

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("nag error connect sa backend");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text(
            'ADD STUDENT',
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
                    setState(
                      () {
                        gradeLevelValue = value!;
                      },
                    );
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
                  onPressed: () {
                    //validate textfields
                    if (_studentFormKey.currentState!.validate()) {
                      //create student in the database
                      createStudent();
                      Navigator.of(context, rootNavigator: true)
                          .pop(); //close dialog
                    }
                    setState(() {});
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
