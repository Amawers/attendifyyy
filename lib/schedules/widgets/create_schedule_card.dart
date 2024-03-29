// ignore_for_file: use_build_context_synchronously

import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/schedules/create_schedule.dart';
import 'package:attendifyyy/schedules/delete_schedule.dart';

import 'package:attendifyyy/schedules/edit_schedule_form.dart';
import 'package:flutter/material.dart';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
                                  Text("Edit"),
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
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                      child: EditSchedule(
                                          schedule_id: schedule_id,
                                          start_time: start_time,
                                          end_time: end_time,
                                          day_of_week: day_of_week)));
                            } else if (value == 1) {
                              // print("Class Schedule delete.");
                              // await ApiServices.deleteSchedule(
                              //     context: context, schedule_id: schedule_id);
                              // await Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ListOfSchedules()));

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: DeleteSchedule(
                                    schedule_id: schedule_id,
                                  ),
                                ),
                              );

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
