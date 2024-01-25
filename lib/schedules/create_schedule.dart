import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/schedules/widgets/create_schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:attendifyyy/schedules/create_schedule_form.dart';

class ListOfSchedules extends StatefulWidget {
  const ListOfSchedules({super.key});

  @override
  State<ListOfSchedules> createState() => _ListOfSchedulesState();
}
class _ListOfSchedulesState extends State<ListOfSchedules> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await ApiServices.getListOfSchedules(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          itemCount: ApiServices.scheduleListData.length,
          itemBuilder: (context, index) {
            //create card for each class schedule data in converted list
            return ClassScheduleCard(
              schedule_id: ApiServices.scheduleListData[index]['schedule_id'],
              subject_name: ApiServices.scheduleListData[index]['subject_name'],
              section_name: ApiServices.scheduleListData[index]['section_name'],
              start_time: ApiServices.scheduleListData[index]['start_time'],
              end_time: ApiServices.scheduleListData[index]['end_time'],
              day_of_week: ApiServices.scheduleListData[index]['day_of_week'],
              backgroundColor: backgroundColors[index % 2],
            );
          }),

      //button for showing the create schedule dialog
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: CreateSchedule()));
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
