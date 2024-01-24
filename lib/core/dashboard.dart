// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/attendance/attendance_list.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/core/widgets/create_student_card.dart';
import 'package:attendifyyy/core/widgets/list_page_nav_btn.dart';
import 'package:attendifyyy/core/widgets/stats_card.dart';
import 'package:attendifyyy/schedules/create_schedule.dart';
import 'package:attendifyyy/subjects/list_of_subject.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String currentDate = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController subjectNameController = TextEditingController();

  Map<String, dynamic> converted = {};
  String teacherName = '';
  String teacherId = '';
  String? imagePath;
  List<dynamic> recentAttendanceList = [];

  @override
  void initState() {
    super.initState();
    getTeacherName();
    retrieveImage();
    getRecentAttendance();
  }

  String getGreeting() {
    var now = TimeOfDay.now();
    if (now.hour < 12) {
      return 'Morning';
    } else if (now.hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  Future<void> getRecentAttendance() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http.get(Uri.parse('${Api.getRecentAttendance}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        try {
          recentAttendanceList = jsonDecode(response.body);
          print("SULOD SA recentAttendanceList: $recentAttendanceList");
          print("TAN AWON VALUE: ${recentAttendanceList[0]['first_name']}");
        } catch (error) {
          print("WAY SULOD recentAttendanceList");
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to fetch schedules")));
      }
    } catch (error) {
      print("wala mi connect sa backend");
    }
  }

  Future<void> retrieveImage() async {
    String? teacherId;
    try {
      // Assuming RememberUserPreferences.readUserInfo() returns a Map<String, dynamic>
      Map<String, dynamic>? teacherInfo =
          await RememberUserPreferences.readUserInfo();
      teacherId = teacherInfo?['teacher_id'];
    } catch (error) {
      print("Error loading user info: $error");
    }

    try {
      final response = await http
          .get(Uri.parse('${Api.retrieveImage}?teacher_id=$teacherId'));

      // Check if the response status code is OK (200)
      if (response.statusCode == 200) {
        // Decode the JSON response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Check the 'status' field in the response
        if (responseBody['status'] == 1) {
          // Assuming the image path is stored in the 'image_path' field
          imagePath = responseBody['image_path'];

          // Do something with the imagePath, e.g., display the image
          print("Image Path: $imagePath");
        } else {
          // Handle the case where the status is not 1
          print("Failed to retrieve image path: ${responseBody['status']}");
        }
      } else {
        // Handle non-OK status codes
        print("Failed to retrieve image. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error during image retrieval: $error");
    }
    setState(() {});
  }

  Future<void> getTeacherName() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();
    setState(() {
      teacherName = teacherInfo?['first_name'] ?? "";
      teacherId = teacherInfo?['teacher_id'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Container(
            padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 90,
              height: 200,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $teacherName',
                    style: const TextStyle(
                      color: Color(0xff081631),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    currentDate,
                    style: const TextStyle(
                      color: Color(0xff081631),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      minRadius: 15,
                      maxRadius: 25,
                      backgroundImage: imagePath != null
                          ? Image.network(
                                  'http://192.168.1.11/attendifyyy_backend/$imagePath')
                              .image
                          : Image.asset('assets/images/logo.png').image)),
            ],
          ),
          const SizedBox(height: 15),
          //Overview
          Container(
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
                  ],
                ),
                const SizedBox(
                  height: 14.0,
                ),
                //Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /* stats cards */
                    createStatsCard(Icons.playlist_add_check_outlined,
                        0xFF039000, "Present", recentAttendanceList.length),
                    createStatsCard(Icons.person_off, 0xFFFF0000, "Absent", 0),
                    createStatsCard(
                        Icons.timer_off_rounded, 0xFFFF9900, "Late", 0),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 14.0),
          //attendance,class and students buttons section
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            createListPageNavButton(context, ListOfSubjects(), 0xFFCD00B9,
                Icons.subject, "Subject List"),
            //spaces between buttons
            const SizedBox(height: 7),
            createListPageNavButton(
                context,
                const ListOfSchedules(),
                0xFFFF9900,
                Icons.schedule,
                "Schedule List"), //! kani na list of schedules styli na, okay na backend
            //spaces between buttons
            const SizedBox(height: 7),
            createListPageNavButton(context, AttendanceReport(), 0xFF039000,
                Icons.group, "Attendance Report"),
            //spaces between buttons
            const SizedBox(height: 30),
          ]),
          //recent attendance section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recent Attendance",
                  style: TextStyle(
                    color: Color(0xFF081631),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
              const SizedBox(height: 14.0),
              //student card list
              recentAttendanceList.isNotEmpty ? createStudentCard(recentAttendanceList[0]['attendance_status'] ?? "", '${recentAttendanceList[0]['first_name']}\n${recentAttendanceList[0]['last_name']}' ?? "", recentAttendanceList[0]['attendance_time'] ?? "") : createStudentCard("No data", "No data", "No data"),
            ],
          ),
        ],
      ),
    );
  }
}