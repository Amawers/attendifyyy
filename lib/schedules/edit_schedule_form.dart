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

class EditSchedule extends StatefulWidget {
  String? schedule_id;
  String? start_time;
  String? end_time;
  String? day_of_week;
  EditSchedule(
      {required this.schedule_id,
      required this.start_time,
      required this.end_time,
      required this.day_of_week});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  final _subjectFormKey = GlobalKey<FormState>();
  String? _subjectNameValue;
  String? _sectionNameValue;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String? _dayWeekValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text('EDIT SCHEDULE',
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
                    labelText: "${widget.day_of_week}",
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
                      await ApiServices.editSchedule(
                          schedule: widget.schedule_id,
                          start: startTime,
                          end: endTime,
                          dayWeekValue: _dayWeekValue,
                          context: context);
                      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListOfSchedules()));

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
                    child: const Text("Edit",
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
