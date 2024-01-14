import 'package:flutter/material.dart';

class ListOfStudentsScreen extends StatefulWidget {
  String? subject_name;
  String? subject_code;
  String? section_id;
  String? subject_id;
  ListOfStudentsScreen({required this.subject_name, required this.subject_code, required this.section_id, required this.subject_id});

  @override
  State<ListOfStudentsScreen> createState() => _ListOfStudentsScreenState();
}

class _ListOfStudentsScreenState extends State<ListOfStudentsScreen> {

  List<dynamic> studentList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Students List'),
      ),
      body: ListView.builder(
          itemCount: studentList.length,
          itemBuilder: (context, index) {
            return ListOfStudentsWidget(
                subject_name:
                    studentList[index]['first_name'] ?? 'students Null nia, e edit lang',
                subject_code:
                    studentList[index]['last_name'] ?? 'students Null nia, e edit lang');
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) => Dialog(child: CreateStudent(section_id: widget.section_id, subject_id: widget.subject_id)));
        },
        child: const Text('Add Student',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ListOfStudentsWidget extends StatelessWidget {
  String subject_name;
  String subject_code;

  ListOfStudentsWidget({required this.subject_name, required this.subject_code});

  @override
  Widget build(BuildContext context) {
    return  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject_name),
              const SizedBox(width: 50),
              Text(subject_code)
            ]);
  }
}
