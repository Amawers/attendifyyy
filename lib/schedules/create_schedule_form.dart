// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/schedules/create_schedule.dart';
import "package:flutter/material.dart";
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
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

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  final _subjectFormKey = GlobalKey<FormState>();
  String? _subjectNameValue;
  String? _sectionNameValue;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String? _dayWeekValue;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await ApiServices.getListOfSubjects();
    setState(() {});
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
                  items: ApiServices.subjectListData
                      .map<DropdownMenuItem<String>>((dynamic value) {
                    String combinedValue =
                        "${value['section_name']} - ${value['subject_name']}";
                    return DropdownMenuItem(
                        value: combinedValue, child: Text(combinedValue));
                  }).toList(),
                  onChanged: (String? value) {
                    List<String> values = value!.split(RegExp(r'\s-\s'));
                    print('SA SETSTATE ${values[0]}');
                    setState(() {
                      _sectionNameValue = values[0];
                      _subjectNameValue = values[1];
                      print('section name sa SETSTATE $_sectionNameValue');
                      print('subject name sa SETSTATE $_subjectNameValue');
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
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
                      _dayWeekValue = value!;
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
                    onPressed: () async {
                      if (_subjectFormKey.currentState!.validate()) {
                        await ApiServices.createSchedule(
                            context: context,
                            subject: _subjectNameValue,
                            section: _sectionNameValue,
                            start: startTime,
                            end: endTime,
                            dayWeekValue: _dayWeekValue);
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfSchedules()));
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
