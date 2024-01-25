import 'package:flutter/material.dart';


/*
*
* create students card for recent attendance section
*
* */
Widget createStudentCard(status, name, timeIn) {
  //default
  int _iconColor = 0xFF039000;
  var _materialIcon = Icons.playlist_add_check_outlined;

  //set status icon
  switch (status) {
    case "Present":
      {
        _iconColor = 0xFF039000;
        _materialIcon = Icons.playlist_add_check_outlined;
      }
      break;
    case "Late":
      {
        _iconColor = 0xFFFF9900;
        _materialIcon = Icons.timer_off_rounded;
      }
      break;
    case "Absent":
    default:
      {
        _iconColor = 0xFFFF9900;
        _materialIcon = Icons.person_off;
      }
  }

  return Container(
    /*
    *
    * This box decoration purpose is to make the edge of the student card a bit round.
    *
    * */
    decoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        /*
        *
        * container for image and name of the student that is place at the left side of the student card
        *
        * */
        Row(
          children: [
            /*
            *
            * This is the first child of the left container.
            * This is use to contain the student image
            * but right now i use account_circle icon as substitute
            *
            * */
            Container(
              margin: const EdgeInsets.only(
                  right: 7), //margin between avatar and name
              child: const Icon(
                Icons.account_circle,
                size: 50,
                color: Colors.blueAccent,
              ),
            ),
            /*
            *
            * This is the second child of the left container.
            * This is used to contain the student name
            *
            * */
            Text(
              name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        /*
        *
        * This is the container for time-in of student.
        *This is located at the right side of the student card
        *
        * */
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_materialIcon, color: Color(_iconColor)),
                Text(status,
                    style: TextStyle(
                      color: Color(_iconColor),
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            /*
            *
            * This is the time in of the student
            *
            * */
            Text(
              '$timeIn TIME IN',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}