import 'package:flutter/material.dart';

/*
*
* create statistic card such as present, absent, and late count.
*
* */
Widget createStatsCard(
    IconData materialIcon, int backgroundColor, String label, int count) {
  return Container(
    width: 90.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14.0),
      //background color of stats card
      color: Color(backgroundColor),
    ),
    padding: const EdgeInsets.all(7.0),
    child: Column(
      children: [
        /*
        *
        * stats card heading
        *
        * */
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(materialIcon, color: Colors.white),
            Text(label,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
        /*
        *
        * stats count
        *
        * */
        Text('$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 50.0,
            ))
      ],
    ),
  );
}