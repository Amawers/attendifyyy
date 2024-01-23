import 'package:flutter/material.dart';
import 'package:attendifyyy/attendance/widgets/student_attendance_status.dart';


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