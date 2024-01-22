import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> dayOfWeekList = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

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
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Row(children: [
                                  Icon(Icons.edit, size: 18.0),
                                  SizedBox(width: 5.0),
                                  Text("Edit")
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

/*
*
* Using for creating the schedule dialog content
*
* */
class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  final _subjectFormKey = GlobalKey<FormState>();
  String? subjectNameValue;
  String? sectionNameValue;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String? dayWeekValue;

  //post newly created schedule to the database
  Future<void> createSchedule() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    print("Sulod sa start time: ${startTime}");

    final response = await http.post(Uri.parse(Api.createSchedule), body: {
      'teacher_id': teacherId,
      'subject_name': subjectNameValue,
      'section_name': sectionNameValue,
      'start_time':
          "$startTime.", //I wrap it with double quote to convert it into string
      'end_time': "$endTime",
      'days_of_week': dayWeekValue
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response.body}')));

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text('CREATE SCHEDULE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          Form(
              key: _subjectFormKey,
              child: Column(children: [
                const SizedBox(height: 20),
                /*
                *
                * Dropdown for subject name
                *
                * */
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Subject",
                    contentPadding: const EdgeInsets.all(16.0),
                    //border style when its focus
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                        BorderSide(width: 2, color: Color(0xFF081631))),
                    //border radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isExpanded: true, //set width to 100%
                  // value: dayWeekValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: ['Mobile Programming', 'IAS']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                        value: value, child: Text("$value"));
                  }).toList(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      subjectNameValue = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                /*
                *
                * Dropdown for section
                *
                * */
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Section",
                    contentPadding: const EdgeInsets.all(16.0),
                    //border style when its focus
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                        BorderSide(width: 2, color: Color(0xFF081631))),
                    //border radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isExpanded: true, //set width to 100%
                  // value: dayWeekValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: ['R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7', 'R8', 'R9']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                        value: value, child: Text("$value"));
                  }).toList(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      sectionNameValue = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                /*
                *
                * Time picker for start time
                *
                * */
                OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 14.0)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                    onPressed: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          startTime = timeOfDay;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Text("Start Time:  ",
                              style: TextStyle(color: Color(0xFF081631))),
                          Text("${startTime.hour}:${startTime.minute}",
                              style: const TextStyle(
                                  color: Color(0xFF081631),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                        ]),
                        const Icon(Icons.schedule, color: Color(0xFF081631))
                      ],
                    )),
                const SizedBox(height: 20),
                /*
                *
                * Time picker for end time
                *
                * */
                OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 14.0)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                    onPressed: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          endTime = timeOfDay;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Text("End Time:  ",
                              style: TextStyle(color: Color(0xFF081631))),
                          Text("${endTime.hour}:${endTime.minute}",
                              style: const TextStyle(
                                  color: Color(0xFF081631),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                        ]),
                        const Icon(Icons.schedule, color: Color(0xFF081631))
                      ],
                    )),
                const SizedBox(height: 20),
                /*
                *
                * Dropdown field for day of the week
                *
                * */
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Days in a week",
                    contentPadding: const EdgeInsets.all(16.0),
                    //border style when its focus
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF081631))),
                    //border radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isExpanded: true, //set width to 100%
                  // value: dayWeekValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: dayOfWeekList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                        value: value, child: Text("$value"));
                  }).toList(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dayWeekValue = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                /*
                *
                * submit button
                *
                * */
                TextButton(
                    onPressed: () {
                      print("pressed");
                      //validate input fields
                      if (_subjectFormKey.currentState!.validate()) {
                        print("submitted");
                        createSchedule();
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size.fromHeight(
                              55)), //having height will make width 100%
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 44.0)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF081631),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    child: const Text("Create",
                        style: TextStyle(
                            backgroundColor: Color(0xFF081631),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))
              ])),
        ],
      ),
    );
  }
}
