
import 'package:flutter/material.dart';
import 'package:attendifyyy/schedules/create_schedule_form.dart';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/schedules/widgets/create_schedule_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ListOfSchedules extends StatefulWidget {
  const ListOfSchedules({super.key});

  @override
  State<ListOfSchedules> createState() => _ListOfSchedulesState();
}

class _ListOfSchedulesState extends State<ListOfSchedules> {
  List<dynamic> converted = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getListOfSchedules();
    });
  }

  Future<void> getListOfSchedules() async {
    String? teacherId;
    try {
      Map<String, dynamic>? teacherInfo =
          await RememberUserPreferences.readUserInfo();

      teacherId = teacherInfo?['teacher_id'];
    } catch (error) {
      print("Error lods: $error");
    }

    final response = await http
        .get(Uri.parse('${Api.listOfSchedules}?teacher_id=$teacherId'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        setState(() {
          converted = jsonDecode(response.body);
        });
        print("Already converted from Json: $converted");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No schedules")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to fetch schedules")));
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    * Background colors used for student cards
    * */
    var backgroundColors = [
      0xFF081631,
      0xFF00315D,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule List",
            style: TextStyle(color: Color(0xFF081631))),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 80.0),
          itemCount: converted.length,
          itemBuilder: (context, index) {
            //create card for each class schedule data in converted list
            return ClassScheduleCard(
              schedule_id: converted[index]['schedule_id'],
              subject_name: converted[index]['subject_name'],
              section_name: converted[index]['section_name'],
              start_time: converted[index]['start_time'],
              end_time: converted[index]['end_time'],
              day_of_week: converted[index]['day_of_week'],
              backgroundColor: backgroundColors[index % 2],
            );
          }),

      //button for showing the create schedule form dialog
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  const Dialog(child: CreateSchedule()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Schedule',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

