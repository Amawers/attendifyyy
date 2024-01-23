// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, unnecessary_brace_in_string_interps, avoid_print, sized_box_for_whitespace

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/students/create_student.dart';
import 'package:attendifyyy/students/delete_student.dart';
import 'package:attendifyyy/students/edit_student.dart';
import 'package:attendifyyy/students/widgets/list_of_student_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> gradeLevelList = <String>[
  '1st Year',
  '2nd Year',
  '3rd Year',
  '4th Year',
  '5th Year'
];

class ListOfStudentsScreen extends StatefulWidget {
  String? subject_name;
  String? subject_code;
  String? section_id;
  String? subject_id;
  String? subject_teachers_id;

  ListOfStudentsScreen(
      {required this.subject_name,
      required this.subject_code,
      required this.section_id,
      required this.subject_id,
      required this.subject_teachers_id});

  @override
  State<ListOfStudentsScreen> createState() => _ListOfStudentsScreenState();
}

class _ListOfStudentsScreenState extends State<ListOfStudentsScreen> {
  List<dynamic> studentList = [];

  bool editStudentIcon = false; //variable paras edit subject

  @override
  void initState() {
    super.initState();
    getListOfStudents();
  }

  Future<void> getListOfStudents() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    Map<String, String> headers = {
      'subject_name': widget.subject_name ?? '',
      'section_id': widget.section_id ?? '',
      'subject_id': widget.subject_id ?? '',
      'teacher_id': teacherId
    };
    try {
      final response =
          await http.get(Uri.parse(Api.listOfStudents), headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          studentList = jsonDecode(response.body);
        });
        print("Sa student list ni ${studentList}");
      } else {
        print("nag error conenct sa backend");
      }
    } catch (error) {
      print("kani nag eror $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff081631)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student List',
              style: TextStyle(
                color: Color(0xff081631),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      /*
      * display empty of studentlist is empty
      * */
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Aligns children to the start and end of the row
              children: [
                //text para sa subject name ug subject code
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.subject_name}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff081631),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.subject_code}',
                        style: const TextStyle(
                          color: Color(0xff081631),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                //button para edit
                Ink(
                  decoration: const ShapeDecoration(
                    color:
                        Color(0xff081631), // set ang background color sa button
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          editStudentIcon == false
                              ? editStudentIcon = true
                              : editStudentIcon =
                                  false; //ternary para sa state sa edit icon
                        },
                      );
                    },
                    icon: Icon(
                      editStudentIcon
                          ? Icons.clear
                          : Icons.edit, //ternary para mailisan ang icon sa edit
                      color: Colors.white, // set ang color sa icon
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: (studentList.isEmpty)
                ? const Center(child: Text('Empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(14.0),
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      return ListOfStudentsWidget(
                        first_name:
                            studentList[index]['first_name'] ?? 'No fname',
                        last_name:
                            studentList[index]['last_name'] ?? 'No lname',
                        editBackground: editStudentIcon
                            ? Colors.transparent
                            : Colors.white, //add argument para sa bg color
                        grade_level: editStudentIcon //add widget argument
                            ? Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: DeleteStudent(
                                                student_id: studentList[index]
                                                        ['student_id'] ??
                                                    'No fname'),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.delete_forever,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: EditStudent(
                                                student_id: studentList[index]
                                                        ['student_id'] ??
                                                    'No fname'),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.edit,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                studentList[index]['grade_level'] ??
                                    'No grade level',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: CreateStudent(
                  section_id: widget.section_id, subject_id: widget.subject_id),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Student',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
