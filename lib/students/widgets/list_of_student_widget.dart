// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ListOfStudentsWidget extends StatelessWidget {
  String first_name;
  String last_name;
  Widget grade_level; //change string to widget
  Color editBackground; //add parameter for bg color

  ListOfStudentsWidget(
      {required this.first_name,
      required this.last_name,
      required this.grade_level,
      required this.editBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF081631),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                first_name,
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              Text(
                last_name,
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
            decoration: BoxDecoration(
              color: editBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: grade_level,
          ),
        ],
      ),
    );
  }
}
