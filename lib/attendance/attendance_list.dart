// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
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
  static List<dynamic> filterData = [];

  @override
  State<AttendanceReport> createState() => AttendanceReportState();
}

class AttendanceReportState extends State<AttendanceReport> {
  String selectedSubject = '';
  String selectedSectionName = '';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await ApiServices.getListOfSubjects();

    setState(() {
      selectedSubject = ApiServices.subject;
      selectedSectionName = ApiServices.section;
    });

    await ApiServices.getAttendanceList(
        context: context,
        subject: selectedSubject,
        section: selectedSectionName);

    setState(() {});
  }

  void handleFilterSelection(String? selectedFilter) {
    setState(() {
      this.selectedFilter = selectedFilter;
      Navigator.pop(context); // Close bottom sheet

      // Reset filterData to an empty list
      AttendanceReport.filterData = [];

      switch (selectedFilter) {
        case 'All':
          AttendanceReport.filterData = ApiServices.attendanceListData;
          break;
        case 'Present':
        case 'Late':
        case 'Absent':
          AttendanceReport.filterData = ApiServices.attendanceListData
              .where(
                  (student) => student['attendance_status'] == selectedFilter)
              .toList();
          break;
      }

      // Check if there are no students with the selected filter
      if (AttendanceReport.filterData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "No students with the selected filter",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ));
      }
    });
  }

  //variable that holds the current selected filter
  String? selectedFilter = filterOptions.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Attendance Report', style: TextStyle(color: Color(0xFF081631))),
          backgroundColor: Colors.white,
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
                        items: ApiServices.subjectListData
                            .map<DropdownMenuItem<String>>((dynamic value) {
                          String combinedValue =
                              "${value['section_name']} - ${value['subject_name']}";
                          return DropdownMenuItem(
                              value: combinedValue, child: Text(combinedValue));
                        }).toList(),
                        onChanged: (String? newValue) async {
                          List<String> values =
                              newValue!.split(RegExp(r'\s-\s'));
                          setState(() {
                            selectedFilter = "All";
                            AttendanceReport.filterData.clear();
                            ApiServices.attendanceListData.clear();
                            selectedSectionName = values[0];
                            selectedSubject = values[1];
                          });
                          await ApiServices.getAttendanceList(
                                  context: context,
                                  subject: selectedSubject,
                                  section: selectedSectionName)
                              .then((_) {
                            setState(() {});
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
                Row(
                  children: [
                    Text('$selectedFilter',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                        handleFilterSelection("All");
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text(filterOptions[1]),
                                      value: filterOptions[1],
                                      groupValue: selectedFilter,
                                      onChanged: (String? value) {
                                        handleFilterSelection("Present");
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text(filterOptions[2]),
                                      value: filterOptions[2],
                                      groupValue: selectedFilter,
                                      onChanged: (String? value) {
                                        handleFilterSelection("Late");
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text(filterOptions[3]),
                                      value: filterOptions[3],
                                      groupValue: selectedFilter,
                                      onChanged: (String? value) {
                                        handleFilterSelection("Absent");
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
                itemCount: AttendanceReport.filterData.length,
                itemBuilder: (context, index) {
                  return studentAttendanceCard(
                      first_name: AttendanceReport.filterData[index]
                              ['first_name'] ??
                          "",
                      last_name:
                          AttendanceReport.filterData[index]['last_name'] ?? "",
                      attendance_status: AttendanceReport.filterData[index]
                              ['attendance_status'] ??
                          "",
                      attendance_time: AttendanceReport.filterData[index]
                              ['formatted_time'] ??
                          "");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
