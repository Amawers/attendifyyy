import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceReport extends StatefulWidget {
  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  List<dynamic> converted = [];
  List<String> subjects = [];
  String? selectedSubject;

  List<dynamic> studentAttendanceData = [];

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
          converted = jsonDecode(response.body);
          print('get list: $converted');
          setState(() {
            subjects = List<String>.from(converted
                .map((dynamic subject) => subject['subject_name'].toString()));
          });
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

  Future<void> getAttendanceList() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    final response = await http.post(Uri.parse(Api.listOfAttendance),
        body: {'teacher_id': teacherId, 'subject_name': selectedSubject});
    if (response.statusCode == 200) {
      try{
        studentAttendanceData = jsonDecode(response.body);
      print("Attendance sa student nga sa specific teacher ug subject: ${studentAttendanceData ?? ""}");
      }catch(error){
        print("no data lods");
        studentAttendanceData.clear();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to fetch schedules")));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Attendance Report'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
              })),
      body: Column(
        children: [
          DropdownButton(
            items: subjects.map((String subjects) {
              return DropdownMenuItem(value: subjects, child: Text(subjects));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSubject = newValue;
              });
              if (selectedSubject != null) {
                getAttendanceList();
              }
            },
            hint: Text(selectedSubject ?? 'Select a schedule'),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: studentAttendanceData.length,
              itemBuilder: (context, index) {
                return AttendanceReportWidget(
                    first_name: studentAttendanceData[index]['first_name'] ?? "",
                    last_name: studentAttendanceData[index]['last_name'] ?? "",
                    attendance_status: studentAttendanceData[index]
                        ['attendance_status'],
                    attendance_time: studentAttendanceData[index]
                        ['formatted_time']);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceReportWidget extends StatelessWidget {
  String first_name;
  String last_name;
  String attendance_status;
  String attendance_time;
  AttendanceReportWidget(
      {required this.first_name,
      required this.last_name,
      required this.attendance_status,
      required this.attendance_time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: const Color(0x009a9a9a).withOpacity(1),
            offset: const Offset(0, 3),
            blurRadius: 5,
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 22, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //first name of the student
                    Text(
                      first_name,
                      style: const TextStyle(
                        color: Color(0xFF1C2C4B),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //last name of the student
                    Text(
                      last_name,
                      style: const TextStyle(
                        color: Color(0xFF1C2C4B),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StudentAttendanceStatus(
                attendance_status: attendance_status,
                attendance_time: attendance_time),
          ],
        ),
      ),
    );
  }
}

class StudentAttendanceStatus extends StatelessWidget {
  String attendance_status;
  String attendance_time;
  StudentAttendanceStatus(
      {required this.attendance_status, required this.attendance_time});

  @override
  Widget build(BuildContext context) {
    if (attendance_status == 'Present') {
      return Column(
        children: [
          //This is the time n of the student
          const Row(
            children: [
              Icon(
                Icons.how_to_reg_outlined,
                color: Colors.green,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'PRESENT',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          //This is the time-in label text
          Row(
            children: [
              Text(
                '$attendance_time AM', //temporary
                style: const TextStyle(
                    color: Color(0xFF1C2C4B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'TIME IN',
                style: TextStyle(
                  color: Color(0xFF1C2C4B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(
            Icons.person_off,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'ABSENT',
            style: TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.w900),
          )
        ],
      );
    }
  }
}
