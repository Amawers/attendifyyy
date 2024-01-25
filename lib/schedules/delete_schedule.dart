// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, deprecated_member_use

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/schedules/create_schedule.dart';
import 'package:attendifyyy/subjects/list_of_subject.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteSchedule extends StatefulWidget {
  String? schedule_id;


  DeleteSchedule({required this.schedule_id});

  @override
  State<DeleteSchedule> createState() => _DeleteScheduleState();
}

class _DeleteScheduleState extends State<DeleteSchedule> {
  // Future<void> deleteSubject() async {
  //   final response = await http.delete(Uri.parse(Api.deleteSubject), body: {
  //     'subject_id': widget.subject_id,
  //     'section_id': widget.section_id
  //   });

  //   print(response.body);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: 100,
      width: 70,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Are you sure?",
            style: TextStyle(
                color: Color(0xFF081631),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await ApiServices.deleteSchedule(
                        context: context, schedule_id: widget.schedule_id);
                    ApiServices.scheduleListData.clear();
                    await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListOfSchedules()));
                  },
                  icon: const Icon(
                    Icons.check,
                  ),
                  label: const Text(
                    'YES',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF081631),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4.0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text(
                    'NO',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF081631),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
