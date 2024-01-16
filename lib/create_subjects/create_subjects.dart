import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/create_students/create_students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

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
          print("Already converted from Json: ${converted}");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No subjects")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to fetch subjects")));
      }
    } else {
      print("Error: Teacher ID is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))),
        title: const Text('Subject List'),
      ),
      body: (converted.isEmpty) ? const Center(child: Text('Empty')) : ListView.builder(
          padding: const EdgeInsets.all(14.0),
          itemCount: converted.length,
          itemBuilder: (context, index) {
            return ListOfSubjectsWidget(
                subject_name: converted[index]['subject_name'] ?? 'tesssst',
                subject_code: converted[index]['subject_code'] ?? 'tesssst',
                section_name: converted[index]['section_name'] ?? 'tesssst',
                section_id: converted[index]['section_id'] ?? 'tesssst',
                subject_id: converted[index]['subject_id']);
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: CreateSubject()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Subject',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

class ListOfSubjectsWidget extends StatelessWidget {
  String subject_name;
  String subject_code;
  String section_name;
  String section_id;
  String subject_id;

  ListOfSubjectsWidget(
      {required this.subject_name,
      required this.subject_code,
      required this.section_name,
      required this.section_id,
      required this.subject_id});

  Random random = Random();
  var backgroundColors = [
    const Color(0xFF081631),
    const Color(0xFFCD00B9),
    const Color(0xFFFF9900),
    const Color(0xFFFF9900),
    const Color(0xFF039000)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:
            const EdgeInsets.only(bottom: 18.0), //spaces between subject cards
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog.fullscreen(
                      child: ListOfStudentsScreen(
                          section_id: section_id,
                          subject_code: subject_code,
                          subject_id: subject_id,
                          subject_name: subject_name)));
            },
            style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size.fromHeight(100)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    backgroundColors[random.nextInt(5)]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subject_name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          )),
                      Text(subject_code,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ))
                    ]),
                Text(section_name,
                    style: const TextStyle(
                      color: Color(0xDAEAEAEA),
                      fontSize: 18.0,
                    ))
              ],
            )));
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
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

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
      height: 380,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text('ADD SUBJECT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          Form(
              child: Column(children: [
            TextFormField(
              controller: subjectNameController,
              decoration: const InputDecoration(
                  hintText: 'Subject Name',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Color(0xFFABABAB))),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: subjectCodeController,
              decoration: const InputDecoration(
                  hintText: 'Subject Code',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Color(0xFFABABAB))),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: sectionNameController,
              decoration: const InputDecoration(
                  hintText: 'Section',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Color(0xFFABABAB))),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: semesterController,
              decoration: const InputDecoration(
                  hintText: 'Semester',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Color(0xFFABABAB))),
            ),
            const SizedBox(height: 20.0),
            TextButton(
                onPressed: () {
                  createSubject();
                  Navigator.of(context, rootNavigator: true).pop(); //close dialog
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 44.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF081631),
                  ),
                ),
                child: const Text("Add",
                    style: TextStyle(
                        backgroundColor: Color(0xFF081631),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ]))
        ],
      ),
    );
  }
}
