// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/subject_screen/create_subject.dart';
import 'package:attendifyyy/subject_screen/widgets/list_of_subject_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> semesterList = <String>["1st Semester", "2nd Semester"];

class ListOfSubjects extends StatefulWidget {
  const ListOfSubjects({super.key});

  @override
  State<ListOfSubjects> createState() => _ListOfSubjectsState();
}

class _ListOfSubjectsState extends State<ListOfSubjects> {
  List<dynamic> converted = [];

  @override
  void initState() {
    super.initState();
    getListOfSubjects();
  }

  Future<void> getListOfSubjects() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String? teacherId = teacherInfo?['teacher_id'];
    if (teacherId != null && teacherId.isNotEmpty) {
      final response = await http
          .get(Uri.parse('${Api.listOfSubjects}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          setState(() {
            converted = jsonDecode(response.body);
          });
          print("PANGITA SUBJECT TEACHER ID: $converted");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No subjects")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to fetch subjects")));
      }
    } else {
      print("Error: Teacher ID is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColors = [
      0xFF081631,
      0xFF00315D,
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF081631),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
          ),
        ),
        title: const Text(
          'Subject List',
          style:
              TextStyle(color: Color(0xFF081631), fontWeight: FontWeight.bold),
        ),
      ),
      body: (converted.isEmpty)
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              padding: const EdgeInsets.all(14.0),
              itemCount: converted.length,
              itemBuilder: (context, index) {
                return ListOfSubjectsWidget(
                  subject_teachers_id:
                      converted[index]['subject_teachers_id'] ?? 'tesssst',
                  subject_name: converted[index]['subject_name'] ?? 'tesssst',
                  subject_code: converted[index]['subject_code'] ?? 'tesssst',
                  section_name: converted[index]['section_name'] ?? 'tesssst',
                  section_id: converted[index]['section_id'] ?? 'tesssst',
                  subject_id: converted[index]['subject_id'],
                  backgroundColor: backgroundColors[index % 2],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: CreateSubject(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Subject',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
