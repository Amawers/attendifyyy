import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
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
    } catch (error){
      print("Error lods: $error");
    }

    
    final response = await http.get(Uri.parse('${Api.listOfSchedules}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          setState(() {
            converted = jsonDecode(response.body);
          });
          print("Already converted from Json: ${converted}");
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))),
        title: const Text('Schedule List'),
      ),
      body: ListView.builder(
          itemCount: converted.length,
          itemBuilder: (context, index) {
            return ListOfSchedulesWidget(
                subject_name: converted[index]['subject_name'],
                section_name: converted[index]['section_name'],
                start_time: converted[index]['start_time'],
                end_time: converted[index]['end_time'],
                day_of_week: converted[index]['day_of_week']);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: CreateSchedule()));
        },
        child: const Text('Add Schedule',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ListOfSchedulesWidget extends StatelessWidget {
  String subject_name;
  String section_name;
  String start_time;
  String end_time;
  String day_of_week;

  ListOfSchedulesWidget(
      {required this.subject_name,
      required this.section_name,
      required this.start_time,
      required this.end_time,
      required this.day_of_week});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) => Dialog(child: StudentsList(subject_name: subject_name, subject_code: subject_code, section_id: section_id, subject_id: subject_id)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text('Subject Name: ${subject_name}'),
                const SizedBox(width: 50),
                Text('Section Name: ${section_name}'),
                const SizedBox(width: 50),
                 Text('Start Time: ${start_time}'),
                const SizedBox(width: 50),
                Text('End Time: ${end_time}'),
                const SizedBox(width: 50),
                Text('Day/s of Week: ${day_of_week}'),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ));
  }
}

class CreateSchedule extends StatelessWidget {
  CreateSchedule({super.key});

  TextEditingController subjectNameController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dayWeekController = TextEditingController();

  Future<void> createSchedule() async {
     Map<String, dynamic>? teacherInfo =
    await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    final response = await http.post(Uri.parse(Api.createSchedule), 
    body: {
      'teacher_id': teacherId,
      'subject_name': subjectNameController.text,
      'section_name': sectionNameController.text,
      'start_time': startTimeController.text,
      'end_time': endTimeController.text,
      'days_of_week': dayWeekController.text
    });
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        children: [
          const Text('Create Schedule'),
          Form(
              child: Column(children: [
            TextFormField(
              controller: subjectNameController,
              decoration: const InputDecoration(hintText: 'Subject Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: sectionNameController,
              decoration: const InputDecoration(hintText: 'Section Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: startTimeController,
              decoration: const InputDecoration(hintText: 'Start Time'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: endTimeController,
              decoration: const InputDecoration(hintText: 'End Time'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: dayWeekController,
              decoration: const InputDecoration(hintText: 'Day of Week'),
            ),
            ElevatedButton(
                onPressed: () {
                  createSchedule();
                },
                child: const Text("Create"))
          ]))
        ],
      ),
    );
  }
}
