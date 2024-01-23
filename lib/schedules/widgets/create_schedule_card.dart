import 'package:flutter/material.dart';
import 'package:attendifyyy/schedules/edit_schedule_form.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            *
            * Class sched card HEADER
            *
            * */
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
                      /*
                      *
                      * This is the 3 dot options icon
                      * This menu items such as edit and delete for each cards
                      *
                      * */
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
                            //0 is the edit menu item
                            if (value == 0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  const Dialog(
                                      child: EditSchedule()));
                            }
                            //1 is the delete menu item
                            else if (value == 1) {
                              deleteSchedule(schedule_id);
                            }
                          }),
                    ])),
            /*
            *
            * Class sched card BODY
            *
            * */
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*
                  *
                  * This column is the left side children of the card body
                  * Container for Day of the week and time
                  *
                  * */
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*
                        * day of the week
                        * */
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
                        /*
                        * time schedule
                        * */
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
                  /*
                  *
                  * This column is the right side children of the card body
                  * Container for Section name label
                  *
                  * */
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
