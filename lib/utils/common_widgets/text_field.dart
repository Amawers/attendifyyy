import 'package:flutter/material.dart';

Widget createTextField(valueController, label, validationFunction) {
  return TextFormField(
    validator: validationFunction,
    controller: valueController,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
      hintText: label,
      hintStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Color(0xFFABABAB)),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xFF081631))),
//normal state of textField border
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xFFABABAB))),

      //border style when error
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xFFFF0000))),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xFFFF0000))),
    ),
  );
}