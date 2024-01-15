import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListOfStudentsScreen extends StatefulWidget {
  String? subject_name;
  String? subject_code;
  String? section_id;
  String? subject_id;
  ListOfStudentsScreen(
      {required this.subject_name,
      required this.subject_code,
      required this.section_id,
      required this.subject_id});

  @override
  State<ListOfStudentsScreen> createState() => _ListOfStudentsScreenState();
}

class _ListOfStudentsScreenState extends State<ListOfStudentsScreen> {
  List<dynamic> studentList = [];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Students List'),
      ),
      body: ListView.builder(
          itemCount: studentList.length,
          itemBuilder: (context, index) {
            return ListOfStudentsWidget(
                first_name: studentList[index]['first_name'] ?? 'No fname',
                last_name: studentList[index]['last_name'] ?? 'No lname',
                grade_level:
                    studentList[index]['grade_level'] ?? 'No grade level');
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: CreateStudent(
                      section_id: widget.section_id,
                      subject_id: widget.subject_id)));
        },
        child: const Text('Add Student',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ListOfStudentsWidget extends StatelessWidget {
  String first_name;
  String last_name;
  String grade_level;

  ListOfStudentsWidget(
      {required this.first_name,
      required this.last_name,
      required this.grade_level});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        children: [
          Text(first_name),
          const SizedBox(width: 50),
          Text(last_name),
        ],
      ),
      const SizedBox(width: 50),
      Text(grade_level)
    ]);
  }
}

class CreateStudent extends StatelessWidget {
  String? section_id;
  String? subject_id;
  CreateStudent({required this.section_id, required this.subject_id});

  TextEditingController referenceNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleInitialController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController gradeLevelController = TextEditingController();

  Future<void> createStudent() async {
    final response = await http.post(Uri.parse(Api.createStudent), body: {
      'reference_number': referenceNumberController.text,
      'first_name': firstNameController.text,
      'middle_initial': middleInitialController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'course': courseController.text,
      'grade_level': gradeLevelController.text,
      'section_id': section_id,
      'subject_id': subject_id
    });

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("nag error conenct sa backend");
    }
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
              controller: referenceNumberController,
              decoration: const InputDecoration(hintText: 'Reference Number'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(hintText: 'First Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: middleInitialController,
              decoration: const InputDecoration(hintText: 'Middle Initial'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(hintText: 'Last Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: courseController,
              decoration: const InputDecoration(hintText: 'Course'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: gradeLevelController,
              decoration: const InputDecoration(hintText: 'Grade Level'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  createStudent();
                },
                child: const Text("Create"))
          ]))
        ],
      ),
    );
  }
}
