import 'dart:convert';
import 'package:attendifyyy/student_creation/list_of_students.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController subjectNameController = TextEditingController();

  Map<String, dynamic> converted = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
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
                        'Morning, ${converted['first_name']}',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/class_list');
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
          MaterialPageRoute(builder: (context) => ListOfStudentsScreen(subject_name: '', subject_code: '', section_id: '', subject_id: '')),
        );
                },
                child: const Text('Attendance \n Report')),
          ])
        ],
      ),
    );
  }
}
