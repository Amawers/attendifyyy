// ignore_for_file: must_be_immutable, non_constant_identifier_names, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/subjects/list_of_subject.dart';
import 'package:attendifyyy/utils/common_widgets/text_field.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSubject extends StatefulWidget {
  String? subject_id;
  String? subject_name;
  String? subject_code;
  String? section_name;
  String? subject_teachers_id;

  EditSubject(
      {required this.subject_id,
      required this.subject_name,
      required this.subject_code,
      required this.section_name,
      required this.subject_teachers_id});

  @override
  _EditSubject createState() => _EditSubject();
}

class _EditSubject extends State<EditSubject> {
  List<dynamic> subjectData = [];

  TextEditingController subjectNameController = TextEditingController();
  TextEditingController subjectCodeController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();
  String semesterValue = semesterList.first;

  final _subjectFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getSubjectData();
  }

  Future<void> getSubjectData() async {
    // // final response = await http.get(
    // //     Uri.parse('${Api.getSubjectData}?subject_id=${widget.subject_id}'));
    // // subjectData = jsonDecode(response.body);
    // print("SUBJECT DATA NIYA: $subjectData");
    subjectNameController.text = widget.subject_name!;
    subjectCodeController.text = widget.subject_code!;
    sectionNameController.text = widget.section_name!;
  }

  Future<void> editSubject() async {
    final response = await http.put(Uri.parse(Api.updateSubjectData), body: {
      'subject_teachers_id': widget.subject_teachers_id,
      'subject_name': subjectNameController.text,
      'subject_code': subjectCodeController.text,
      'section_name': sectionNameController.text,
      'semester': semesterValue
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
      height: 400,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text(
            'EDIT SUBJECT',
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
                      // EditSubject(
                      //     subject_id: widget.subject_id,
                      //     section_name: widget.section_name,
                      //     subject_code: widget.subject_code,
                      //     subject_name: widget.subject_name);
                      editSubject();
                      Navigator.of(context, rootNavigator: true)
                          .pop(); //close dialog
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
                    "Edit",
                    style: TextStyle(
                        backgroundColor: Color(0xFF081631),
                        fontSize: 16,
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
