import 'package:flutter/material.dart';

/*
*
* Use to create student attendance status content
*
* */
class StudentAttendanceStatus extends StatelessWidget {
  String attendance_status;
  String attendance_time;
  StudentAttendanceStatus(
      {required this.attendance_status, required this.attendance_time});

  @override
  Widget build(BuildContext context) {
    if (attendance_status == 'Present') {
      return Column(
        children: [
          //This is the time n of the student
          const Row(
            children: [
              Icon(
                Icons.how_to_reg_outlined,
                color: Colors.green,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'PRESENT',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          //This is the time-in label text
          Row(
            children: [
              Text(
                '$attendance_time AM', //temporary
                style: const TextStyle(
                    color: Color(0xFF1C2C4B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'TIME IN',
                style: TextStyle(
                  color: Color(0xFF1C2C4B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      );
    } else if (attendance_status == 'Late') {
      return Column(
        children: [
          //This is the time n of the student
          const Row(
            children: [
              Icon(
                Icons.timer_off,
                color: Colors.orange,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'LATE',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          //This is the time-in label text
          Row(
            children: [
              Text(
                '$attendance_time AM', //temporary
                style: const TextStyle(
                    color: Color(0xFF1C2C4B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'TIME IN',
                style: TextStyle(
                  color: Color(0xFF1C2C4B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(
            Icons.person_off,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'ABSENT',
            style: TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.w900),
          )
        ],
      );
    }
  }
}