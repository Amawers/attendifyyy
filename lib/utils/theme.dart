import "package:flutter/material.dart";

class TAppTheme {
  static const primaryColor = Color(0xFF081631);
  static const secondaryColor = Color(0xFFABABAB);

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: primaryColor,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: primaryColor),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 2, color: primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: secondaryColor)),
      ));

  //Theme.of(context).inputDecorationTheme.labelStyle //not working
}
