// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/subjects/create_subject.dart';
import 'package:attendifyyy/subjects/widgets/list_of_subject_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> semesterList = <String>["1st Semester", "2nd Semester"];

class ListOfSubjects extends StatefulWidget {
  const ListOfSubjects({super.key});

  @override
  State<ListOfSubjects> createState() => _ListOfSubjectsState();
}

class _ListOfSubjectsState extends State<ListOfSubjects> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    await ApiServices.getListOfSubjects();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColors = [
      0xFF081631,
      0xFF00315D,
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF081631),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
          ),
        ),
        title: const Text(
          'Subject List',
          style:
              TextStyle(color: Color(0xFF081631), fontWeight: FontWeight.bold),
        ),
      ),
      body: (ApiServices.subjectListData.isEmpty)
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              padding: const EdgeInsets.all(14.0),
              itemCount: ApiServices.subjectListData.length,
              itemBuilder: (context, index) {
                return ListOfSubjectsWidget(
                  subject_teachers_id:
                      ApiServices.subjectListData[index]['subject_teachers_id'] ?? 'tesssst',
                  subject_name: ApiServices.subjectListData[index]['subject_name'] ?? 'tesssst',
                  subject_code: ApiServices.subjectListData[index]['subject_code'] ?? 'tesssst',
                  section_name: ApiServices.subjectListData[index]['section_name'] ?? 'tesssst',
                  section_id: ApiServices.subjectListData[index]['section_id'] ?? 'tesssst',
                  subject_id: ApiServices.subjectListData[index]['subject_id'],
                  backgroundColor: backgroundColors[index % 2],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: CreateSubject(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Subject',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
