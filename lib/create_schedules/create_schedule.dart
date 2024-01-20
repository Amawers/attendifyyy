import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<int> dayOfWeekList = [1, 2, 3, 4, 5, 6, 7];

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
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))),
        title: const Text('Schedule List'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 80.0),
          itemCount: converted.length,
          itemBuilder: (context, index) {
            //create card for each class schedule data in converted list
            return ClassScheduleCard(
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
  String subject_name;
  String section_name;
  String start_time;
  String end_time;
  String day_of_week;
  int backgroundColor;

  ClassScheduleCard(
      {super.key,
      required this.subject_name,
      required this.section_name,
      required this.start_time,
      required this.end_time,
      required this.day_of_week,
      required this.backgroundColor});

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
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 14.0),
                decoration: BoxDecoration(
                    color: Color(backgroundColor),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14.0), bottom: Radius.zero)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subject_name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          )),
                      PopupMenuButton(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Row(children: [
                                  Icon(Icons.delete_forever, size: 18.0),
                                  SizedBox(width: 5.0),
                                  Text("Edit")
                                ]),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Row(children: [
                                  Icon(Icons.edit, size: 18.0),
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
                              print("Class Schedule delete.");
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
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();
  //TextEditingController startTimeController = TextEditingController();
  //TextEditingController endTimeController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int dayWeekValue = dayOfWeekList.first;

  //post newly created schedule to the database
  Future<void> createSchedule() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    final response = await http.post(Uri.parse(Api.createSchedule), body: {
      'teacher_id': teacherId,
      'subject_name': subjectNameController.text,
      'section_name': sectionNameController.text,
      'start_time': "$startTime", //I wrap it with double quote to convert it into string
      'end_time': "$endTime",
      'days_of_week': "$dayWeekValue"
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
                * Input Text field for subject name
                *
                * */
                createTextFormField("Subject Name", subjectNameController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                /*
                *
                * Input Text field for section
                *
                * */
                createTextFormField("Section", sectionNameController, (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                /*
                *
                * Time picker for start time
                *
                * */
                OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(20.0)),
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
                        Text(
                            "Start Time: ${startTime.hour}:${startTime.minute}",
                            style: const TextStyle(color: Color(0xFFABABAB))),
                        const Icon(Icons.schedule, color: Color(0xFFABABAB))
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
                            const EdgeInsets.all(20.0)),
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
                        Text("Start Time: ${endTime.hour}:${endTime.minute}",
                            style: const TextStyle(color: Color(0xFFABABAB))),

                        const Icon(Icons.schedule, color: Color(0xFFABABAB))
                      ],
                    )),
                const SizedBox(height: 20),
                /*
                *
                * Dropdown field for day of the week
                *
                * */
                DropdownButtonFormField<int>(
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
                  value: dayWeekValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dayWeekValue = value!;
                    });
                  },
                  items: dayOfWeekList.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
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

/*
*
* TextFormField input components
* This is for schedule and section
*
* */
Widget createTextFormField(label, valueController, validationCondition) {
  return TextFormField(
      validator: validationCondition,
      controller: valueController,
      decoration: InputDecoration(
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Color(0xFFABABAB)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
        //normal state of textField border
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFFABABAB))),
        //border style when error
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFFFF0000))),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 2, color: Color(0xFFFF0000))),
      ));
}

/*
*
* time input components
* this is for start and end time
*
* */
