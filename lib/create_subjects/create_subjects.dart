import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/create_students/create_students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListOfSubjects extends StatefulWidget {
  const ListOfSubjects({super.key});

  @override
  State<ListOfSubjects> createState() => _ListOfSubjectsState();
}

class _ListOfSubjectsState extends State<ListOfSubjects> {
  List<dynamic> converted = [];

  Future<void> getListOfSubjects() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/bottom_navbar', (route) => false)),
        title: const Text('Class List'),
      ),
      body: ListView.builder(
          itemCount: converted.length,
          itemBuilder: (context, index) {
            return ListOfSubjectsWidget(
                subject_name: converted[index]['subject_name'],
                subject_code: converted[index]['subject_code'],
                section_id: converted[index]['section_id'] ??
                    'b5322bf4-7e02-4016-8dab-27bfd48e4f50',
                subject_id: converted[index]['subject_id']);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: CreateSubject()));
        },
        child: const Text('Add Subject',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ListOfSubjectsWidget extends StatelessWidget {
  String subject_name;
  String subject_code;
  String section_id;
  String subject_id;

  ListOfSubjectsWidget(
      {required this.subject_name,
      required this.subject_code,
      required this.section_id,
      required this.subject_id});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: ListOfStudentsScreen(
                      subject_name: subject_name,
                      subject_code: subject_code,
                      section_id: section_id,
                      subject_id: subject_id)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(subject_name),
              const SizedBox(width: 50),
              Text(subject_code)
            ]),
            const SizedBox(height: 15),
            Text(section_id)
          ],
        ));
  }
}
class CreateSubject extends StatefulWidget {
  @override
  _CreateSubject createState() => _CreateSubject();
}

class _CreateSubject extends State<CreateSubject> {

  TextEditingController subjectNameController = TextEditingController();
  TextEditingController subjectCodeController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();
  TextEditingController semesterController = TextEditingController();

  Future<void> createSubject() async {
    Map<String, dynamic>? teacherInfo = await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    final response = await http.post(Uri.parse(Api.createSubject), body: {
      'teacher_id': teacherId,
      'subject_name': subjectNameController.text,
      'subject_code': subjectCodeController.text,
      'section_name': sectionNameController.text,
      'semester': semesterController.text
    });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.body}')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        children: [
          const Text('Create Class'),
          Form(
              child: Column(children: [
            TextFormField(
              controller: subjectNameController,
              decoration: const InputDecoration(hintText: 'Subject Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: subjectCodeController,
              decoration: const InputDecoration(hintText: 'Subject Code'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: sectionNameController,
              decoration: const InputDecoration(hintText: 'Section Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: semesterController,
              decoration: const InputDecoration(hintText: 'Semester'),
            ),
            ElevatedButton(
                onPressed: () {
                  createSubject();
                },
                child: const Text("Create"))
          ]))
        ],
      ),
    );
  }
}
