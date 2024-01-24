// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/attendance/widgets/student_attendance_card.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; //to use DateFormat for date

/*
* filter options is use for the radio button in the bottom sheet
* */
List<String> filterOptions = ['All', 'Present', 'Late', 'Absent'];
/*
* current date is use for the current date below the dropdown sections
* */
String currentDate = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  List<dynamic> converted = [];
  List<String> subjects = [];
  List<String> sections = [];
  String? selectedSubject;
  String? selectedSectionName;
  //this is where the first or the original fetched studentAttendanceData will be stored
  List<dynamic> studentAttendanceDataOriginal = [];
  //this is the studentAttendanceData that going to be use for making student cards
  //this is also the list that will be filtered when selecting a filter option
  List<dynamic> studentAttendanceData =
      []; //by default its value is the studentAttendanceDAtaOriginal

  @override
  void initState() {
    super.initState();
    getListOfSubjects();
  }

  //fetching data from database
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
          print('VALUE OF CONVERTED: $converted');
          setState(() {
            selectedSubject = converted[0]['subject_name'];
            selectedSectionName = converted[0]['section_name'];
            getAttendanceList();
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

  //use for fetching all attendance list of the selected subject
  Future<void> getAttendanceList() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    try {
      print('SELECTED SUBJECT ${selectedSubject}');
      print('SELECTED SECTION ${selectedSectionName}');
      final response = await http.post(Uri.parse(Api.listOfAttendance), body: {
        'teacher_id': teacherId,
        'subject_name': selectedSubject,
        'section_name': selectedSectionName
      });
      if (response.statusCode == 200) {
        try {
          studentAttendanceDataOriginal = jsonDecode(response.body);
          studentAttendanceData = studentAttendanceDataOriginal;
          print(
              "Attendance sa student nga sa specific teacher ug subject: ${studentAttendanceDataOriginal ?? ""}");
        } catch (error) {
          print("No attendance data for specific teacher ug subject");
          studentAttendanceDataOriginal.clear();
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to fetch schedules")));
      }
    } catch (error) {
      print("wala mi connect sa backend");
    }
    setState(() {});
  }

  //variable that holds the current selected filter
  String? selectedFilter = filterOptions.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Attendance Report'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()),
                );
              })),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 80.0),
        child: Column(
          children: [
            /*
             *
             * Headings
             * Subject dropdown with date and filter option
             *
             *  */
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*
                * Subject dropdown and date
                * */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //subject dropdown
                    DropdownButton(
                        underline:
                            const SizedBox(), //make the dropdownbutton underline invisible
                        focusColor: Colors.transparent,
                        items: converted
                            .map<DropdownMenuItem<String>>((dynamic value) {
                          String combinedValue =
                              "${value['section_name']} - ${value['subject_name']}";
                          return DropdownMenuItem(
                              value: combinedValue, child: Text(combinedValue));
                        }).toList(),
                        onChanged: (String? newValue) {
                          List<String> values =
                              newValue!.split(RegExp(r'\s-\s'));
                          setState(() {
                            print("BEFORE E SPLIT $values");
                            selectedSectionName = values[0];
                            selectedSubject = values[1];
                                                        getAttendanceList();

                          });
                          // if (selectedSectionId != null &&
                          //     selectedSubject != null) {
                          //   getAttendanceList();
                          // }
                        },

                        //hide default arrow_downward icon
                        icon: const Visibility(
                            visible: false, child: Icon(Icons.arrow_downward)),
                        //hint or placeholder of the dropdownbutton
                        //this box limit the width of the row widget
                        hint: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200.0),
                          child: Row(
                            children: [
                              //flexible allows text child to adjust
                              Flexible(
                                  child: Text(
                                      selectedSubject ?? 'Select a schedule',
                                      style: const TextStyle(
                                          //with overflow it hide or turn the overflowed text into ellipsis
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF081631)))),
                              const Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        )),
                    //current date
                    Text(currentDate,
                        style: const TextStyle(color: Color(0xFF081631))),
                  ],
                ),
                /*
                *
                * Filter option
                *
                * */
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    /*
                      *
                      * this is the bottom sheet that will popup when filter icon is clicked
                      *
                      * */
                    showModalBottomSheet<void>(
                      //remove constraints in height to customized the minHeight
                      constraints: const BoxConstraints(
                        minHeight: 260.0,
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                /*
                                  *
                                  * heading title
                                  *
                                  * */
                                const Center(
                                    child: Text("Filter",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ))),
                                const SizedBox(height: 10.0),
                                /*
                                  *
                                  * radio button list
                                  *
                                  * */
                                RadioListTile<String>(
                                  title: Text(filterOptions[0]),
                                  value: filterOptions[0],
                                  groupValue: selectedFilter,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedFilter =
                                          value; //set the current selectedradio button
                                      Navigator.pop(
                                          context); //close bottomsheet
                                      studentAttendanceData =
                                          studentAttendanceDataOriginal; //filter the studentAttendanceDate
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text(filterOptions[1]),
                                  value: filterOptions[1],
                                  groupValue: selectedFilter,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedFilter = value;
                                      Navigator.pop(
                                          context); //close bottomsheet
                                      print(studentAttendanceDataOriginal[0]
                                          ['attendance_status']);
                                      studentAttendanceData =
                                          studentAttendanceDataOriginal
                                              .where((student) =>
                                                  student[
                                                      'attendance_status'] ==
                                                  "Present")
                                              .toList(); //filter the studentAttendanceDate
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text(filterOptions[2]),
                                  value: filterOptions[2],
                                  groupValue: selectedFilter,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedFilter = value;
                                      Navigator.pop(
                                          context); //close bottomsheet
                                      studentAttendanceData =
                                          studentAttendanceDataOriginal
                                              .where((student) =>
                                                  student[
                                                      'attendance_status'] ==
                                                  "Late")
                                              .toList(); //filter the studentAttendanceDate
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text(filterOptions[3]),
                                  value: filterOptions[3],
                                  groupValue: selectedFilter,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedFilter = value;
                                      Navigator.pop(
                                          context); //close bottomsheet
                                      studentAttendanceData =
                                          studentAttendanceDataOriginal
                                              .where((student) =>
                                                  student[
                                                      'attendance_status'] ==
                                                  "Absent")
                                              .toList(); //filter the studentAttendanceDate
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            /*
            *
            * list of student attendance cards
            *
            * */
            Expanded(
              child: ListView.builder(
                itemCount: studentAttendanceData.length,
                itemBuilder: (context, index) {
                  return studentAttendanceCard(
                      first_name:
                          studentAttendanceData[index]['first_name'] ?? "",
                      last_name:
                          studentAttendanceData[index]['last_name'] ?? "",
                      attendance_status: studentAttendanceData[index]
                          ['attendance_status'],
                      attendance_time: studentAttendanceData[index]
                          ['formatted_time']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
