import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class AttendanceReport extends StatefulWidget {
  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  List<String> subjects = [];
  List<String> sections = [];
  String? selectedSubject;
  String? selectedSection;

  List<dynamic> studentAttendanceData = [];

  Future<void> getListOfSubjects() async {
    // setState(() {
    //   subjects = List<String>.from(unconvertedSubjects
    //       .map((dynamic subject) => subject['subject_name'].toString()));
    //   sections = List<String>.from(unconvertedSections
    //       .map((dynamic section) => section['section_name'].toString()));
    // });
  }

  // Future<void> getTeacherDetails() async {

  // }

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
            items: subjects.map((String subject) {
              return DropdownMenuItem(value: subject, child: Text(subject));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSubject = newValue;
              });
              // getTeacherDetails();
            },
            hint: Text('Select a subject'),
          ),
          DropdownButton(
            items: sections.map((String sections) {
              return DropdownMenuItem(value: sections, child: Text(sections));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSection = newValue;
              });
              // getTeacherDetails();
            },
            hint: Text('Select a section'),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: studentAttendanceData.length,
              itemBuilder: (context, index) {
                return AttendanceReportWidget(
                  first_name: studentAttendanceData[index]['first_name'],
                  last_name: studentAttendanceData[index]['last_name'],
                  attendance_status: studentAttendanceData[index]
                      ['attendance_status'],
                );
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
  AttendanceReportWidget(
      {required this.first_name,
      required this.last_name,
      required this.attendance_status});

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
            StudentAttendanceStatus(attendance_status: attendance_status),
          ],
        ),
      ),
    );
  }
}

class StudentAttendanceStatus extends StatelessWidget {
  String attendance_status;
  StudentAttendanceStatus({required this.attendance_status});

  @override
  Widget build(BuildContext context) {
    if (attendance_status == 'Present') {
      return const Column(
        children: [
          //This is the time n of the student
          Row(
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
          SizedBox(
            height: 10,
          ),
          //This is the time-in label text
          Row(
            children: [
              Text(
                '4:00 AM', //temporary
                style: TextStyle(
                    color: Color(0xFF1C2C4B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
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
