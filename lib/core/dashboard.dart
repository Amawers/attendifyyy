import 'dart:convert';
import 'package:attendifyyy/attendance/attendance_list.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/create_students/create_students.dart';
import 'package:attendifyyy/create_subjects/create_subjects.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController subjectNameController = TextEditingController();

  Map<String, dynamic> converted = {};
  String teacherName = '';
  String teacherId = '';

  @override
  void initState() {
    super.initState();
    getTeacherName();
  }

  Future<void> getTeacherName() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();
    setState(() {
      teacherName = teacherInfo?['first_name'];
      teacherId = teacherInfo?['teacher_id'];

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xff101010),
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        'Morning, ${teacherName}, teacher_id: ${teacherId}',
                        style: const TextStyle(
                          color: Color(0xff081631),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Monday, 9 Nov 2023',
                        style: const TextStyle(
                          color: Color(0xff081631),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ListOfSubjects()),
                  );
                },
                child: const Text('Subjects \n List')),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/schedule_list');
                },
                child: const Text('Schedules \n List')),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceReport()),
                  );
                },
                child: const Text('Attendance \n Report')),
            const SizedBox(height: 30),
            Text("testing")
          ])
        ],
      ),
    );
  }
}
