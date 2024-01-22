import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:attendifyyy/create_schedules/create_schedule_form.dart';
import 'package:attendifyyy/create_schedules/edit_schedule_form.dart';

class ListOfSchedules extends StatefulWidget {
  const ListOfSchedules({super.key});

  @override
  State<ListOfSchedules> createState() => _ListOfSchedulesState();
}

class _ListOfSchedulesState extends State<ListOfSchedules> {
  List<dynamic> converted = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getListOfSchedules();
    });
  }

  Future<void> getListOfSchedules() async {
    String? teacherId;
    try {
      Map<String, dynamic>? teacherInfo =
          await RememberUserPreferences.readUserInfo();

      teacherId = teacherInfo?['teacher_id'];
    } catch (error) {
      print("Error lods: $error");
    }

    final response = await http
        .get(Uri.parse('${Api.listOfSchedules}?teacher_id=$teacherId'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        setState(() {
          converted = jsonDecode(response.body);
        });
        print("Already converted from Json: $converted");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No schedules")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to fetch schedules")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColors = [
      0xFF081631,
      0xFF00315D,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule List",
            style: TextStyle(color: Color(0xFF081631))),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 80.0),
          itemCount: converted.length,
          itemBuilder: (context, index) {
            //create card for each class schedule data in converted list
            return ClassScheduleCard(
              schedule_id: converted[index]['schedule_id'],
              subject_name: converted[index]['subject_name'],
              section_name: converted[index]['section_name'],
              start_time: converted[index]['start_time'],
              end_time: converted[index]['end_time'],
              day_of_week: converted[index]['day_of_week'],
              backgroundColor: backgroundColors[index % 2],
            );
          }),

      //button for showing the create schedule dialog
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: CreateSchedule()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Schedule',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

/*
*
* Use for creating class schedule card
*
* */
class ClassScheduleCard extends StatelessWidget {
  String schedule_id;
  String subject_name;
  String section_name;
  String start_time;
  String end_time;
  String day_of_week;
  int backgroundColor;

  ClassScheduleCard(
      {super.key,
      required this.schedule_id,
      required this.subject_name,
      required this.section_name,
      required this.start_time,
      required this.end_time,
      required this.day_of_week,
      required this.backgroundColor});

  Future<void> deleteSchedule(String schedule_id) async {
    final response = await http
        .delete(Uri.parse('${Api.deleteSchedule}?schedule_id=${schedule_id}'));
    if (response.statusCode == 200) {
      print('Na delete? ${jsonDecode(response.body)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            bottom: 20.0), //served as space between its adjacent card
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(1),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: -8,
              ),
            ]),
        // onPressed: () {
        //   showDialog(
        //       context: context,
        //       builder: (BuildContext context) => Dialog(child: StudentsList(subject_name: subject_name, subject_code: subject_code, section_id: section_id, subject_id: subject_id)));
        // },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Class sched card header
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 14.0),
                decoration: BoxDecoration(
                    color: Color(backgroundColor),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14.0), bottom: Radius.zero)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(subject_name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            )),
                      ),
                      PopupMenuButton(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Row(children: [
                                  const Icon(Icons.edit, size: 18.0),
                                  const SizedBox(width: 5.0),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Dialog(
                                                    child: EditSchedule()));
                                      },
                                      child: const Text("Edit")),
                                ]),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Row(children: [
                                  Icon(Icons.delete_forever, size: 18.0),
                                  SizedBox(width: 5.0),
                                  Text("Delete")
                                ]),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            if (value == 0) {
                              print("Class Schedule update.");
                            } else if (value == 1) {
                              // print("Class Schedule delete.");
                              deleteSchedule(schedule_id);
                            }
                          }),
                    ])),
            //Class sched card body
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //left side children of the card body
                  //Container for Day of the week and time schedule
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //day of the week
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Color(0xFF081631)),
                            const SizedBox(width: 10.0),
                            Text(day_of_week,
                                style: const TextStyle(
                                  color: Color(0xFF081631),
                                ))
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        //time schedule
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Color(0xFF081631),
                            ),
                            const SizedBox(width: 10.0),
                            Text("$start_time - $end_time",
                                style: const TextStyle(
                                  color: Color(0xFF081631),
                                ))
                          ],
                        )
                      ]),
                  //Section Text
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(section_name,
                          style: const TextStyle(
                              color: Color(0xFF081631),
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0)))
                ],
              ),
            ),
          ],
        ));
  }
}

