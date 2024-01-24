// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/students/list_of_student.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteStudent extends StatefulWidget {
  String? student_id;
  String? section_id;
  String? subject_code;
  String? subject_id;
  String? subject_name;
  String? subject_teachers_id;

  DeleteStudent(
      {required this.student_id,
      required this.section_id,
      required this.subject_code,
      required this.subject_id,
      required this.subject_name,
      required this.subject_teachers_id});

  @override
  State<DeleteStudent> createState() => _DeleteStudentState();
}

class _DeleteStudentState extends State<DeleteStudent> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: 100,
      width: 70,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Are you sure?",
            style: TextStyle(
                color: Color(0xFF081631),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await ApiServices.deleteStudent(
                        context: context, studentId: widget.student_id);
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
                  },
                  icon: const Icon(
                    Icons.check,
                  ),
                  label: const Text(
                    'YES',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF081631),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4.0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text(
                    'NO',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF081631),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4.0,
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
