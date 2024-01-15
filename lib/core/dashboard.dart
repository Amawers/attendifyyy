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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  minRadius: 20,
                  maxRadius: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Morning, $teacherName',
                        style: const TextStyle(
                          color: Color(0xff081631),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Monday, 9 Nov 2023',
                        style: TextStyle(
                          color: Color(0xff081631),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Overview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: const Color(0xFF081631),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //Overview headings row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14.0,
                  ),
                  //Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /* stats cards */
                      //stats card present
                      Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          //background color of stats card
                          color: const Color(0xFF039000),
                        ),
                        padding: const EdgeInsets.all(7.0),
                        child: const Column(
                          children: [
                            //stats card heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.playlist_add_check_outlined,
                                    color: Colors.white),
                                Text('PRESENT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                            //stats count
                            Text('69',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50.0,
                                ))
                          ],
                        ),
                      ),
                      //stats card absent
                      Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          //background color of stats card
                          color: const Color(0xFFFF0000),
                        ),
                        padding: const EdgeInsets.all(7.0),
                        child: const Column(
                          children: [
                            //stats card heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_off, color: Colors.white),
                                Text('ABSENT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                            //stats count
                            Text('7',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50.0,
                                ))
                          ],
                        ),
                      ),
                      //stats card late
                      Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          //background color of stats card
                          color: const Color(0xFFFF9900),
                        ),
                        padding: const EdgeInsets.all(7.0),
                        child: const Column(
                          children: [
                            //stats card heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_off_rounded,
                                    color: Colors.white),
                                Text('LATE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                            //stats count
                            Text('4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50.0,
                                ))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          //attendance,class and students buttons section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ListOfSubjects()),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFCD00B9)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(16.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                child: const Row(
                  children: [
                    Icon(
                      Icons.subject,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Subject List',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0))
                  ],
                ),
              ),
              const SizedBox(height: 7),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/schedule_list');
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFF9900)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(16.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                child: const Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Schedule List',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0))
                  ],
                ),
              ),
              const SizedBox(height: 7),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceReport()),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF039000)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(16.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                child: const Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Attendance Report',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0))
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
          //recent attendance section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Recent Attendance",
                    style: TextStyle(
                      color: Color(0xFF081631),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    )),
                const SizedBox(height: 14.0),
                //student card list
                Column(
                  //student cards
                  children: [
                    Container(
                      //This boxdecoration purpose is to make the edge of the student card a
                      //a bit round.
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //container for image and name of the student that is place at the
                          // left side of the student card
                          Row(
                            children: [
                              //This is the first child of the left container.
                              //This is use to contain the student image
                              //but right now i use account_circle icon as substitute
                              Container(
                                margin: const EdgeInsets.only(right: 7), //margin between avatar and name
                                child: const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              //This is the second child of the left container.
                              //This is used to contain the student name
                              const Text(
                                'Christian Dacoroon',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          //This is the container for time-in of student.
                          //This is located at the right side of the student card
                          const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.timer_off_rounded,
                                      color: Color(0xFFFF9900)),
                                  Text('LATE',
                                      style: TextStyle(
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                              //This is the time in of the student
                              Text(
                                '4:00 AM TIME IN',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      //This boxdecoration purpose is to make the edge of the student card a
                      //a bit round.
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //container for image and name of the student that is place at the
                          // left side of the student card
                          Row(
                            children: [
                              //This is the first child of the left container.
                              //This is use to contain the student image
                              //but right now i use account_circle icon as substitute
                              Container(
                                margin: const EdgeInsets.only(right: 7), //margin between avatar and name
                                child: const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              //This is the second child of the left container.
                              //This is used to contain the student name
                              const Text(
                                'Verseler kerr Handuman',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          //This is the container for time-in of student.
                          //This is located at the right side of the student card
                          const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.playlist_add_check_outlined,
                                      color: Color(0xFF039000)),
                                  Text('PRESENT',
                                      style: TextStyle(
                                        color: Color(0xFF039000),
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                              //This is the time in of the student
                              Text(
                                '7:00 AM TIME IN',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
