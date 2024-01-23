import 'package:flutter/material.dart';

/*
*
* create a listNavButton that navigate you to a certain list page
*
* */
Widget createListPageNavButton(
    context, onClickAction, backgroundColor, materialIcon, label) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => onClickAction),
      );
    },
    style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all<Color>(Color(backgroundColor)),
        padding:
        MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
    child: Row(
      children: [
        Icon(
          materialIcon,
          color: Colors.white,
          size: 35.0,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0))
      ],
    ),
  );
}
