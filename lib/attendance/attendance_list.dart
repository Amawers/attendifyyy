import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; //to use DateFormat for date

//filter options
List<String> filterOptions = ['All', 'Present', 'Late', 'Absent'];
//Date
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

/*
 *
 * Use to create studentAttendance card based on the fetched data
 *
 *  */
class studentAttendanceCard extends StatelessWidget {
  String first_name;
  String last_name;
  String attendance_status;
  String attendance_time;
  studentAttendanceCard(
      {required this.first_name,
      required this.last_name,
      required this.attendance_status,
      required this.attendance_time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 20.0), //served as space with its adjacent card
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
        //card content padding
        padding: const EdgeInsets.fromLTRB(16, 10, 22, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /*
            *
            * Left side of the card content
            * Student profile and name
            *
            * */
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
            /*
            *
            * Right side of the card content
            * Student attendance status
            *
            * */
            StudentAttendanceStatus(
                attendance_status: attendance_status,
                attendance_time: attendance_time),
          ],
        ),
      ),
    );
  }
}

/*
*
* Use to create student attendance status content
*
* */
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
    } else if (attendance_status == 'Late') {
      return Column(
        children: [
          //This is the time n of the student
          const Row(
            children: [
              Icon(
                Icons.timer_off,
                color: Colors.orange,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'LATE',
                style: TextStyle(
                    color: Colors.orange,
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
