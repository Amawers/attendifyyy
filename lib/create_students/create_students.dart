import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> gradeLevelList = <String>[
  '1st Year',
  '2nd Year',
  '3rd Year',
  '4th Year',
  '5th Year'
];

class ListOfStudentsScreen extends StatefulWidget {
  String? subject_name;
  String? subject_code;
  String? section_id;
  String? subject_id;
  ListOfStudentsScreen(
      {required this.subject_name,
      required this.subject_code,
      required this.section_id,
      required this.subject_id});

  @override
  State<ListOfStudentsScreen> createState() => _ListOfStudentsScreenState();
}

class _ListOfStudentsScreenState extends State<ListOfStudentsScreen> {
  List<dynamic> studentList = [];

  @override
  void initState() {
    super.initState();
    getListOfStudents();
  }

  Future<void> getListOfStudents() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    Map<String, String> headers = {
      'subject_name': widget.subject_name ?? '',
      'section_id': widget.section_id ?? '',
      'subject_id': widget.subject_id ?? '',
      'teacher_id': teacherId
    };
    try {
      final response =
          await http.get(Uri.parse(Api.listOfStudents), headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          studentList = jsonDecode(response.body);
        });
        print("Sa student list ni ${studentList}");
      } else {
        print("nag error conenct sa backend");
      }
    } catch (error) {
      print("kani nag eror $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Student List',
              style: TextStyle(
                color: Color(0xff081631),
                fontSize: 20,
              ),
            ),
            Text(
              '${widget.subject_name}',
              style: const TextStyle(
                color: Color(0xff081631),
                fontSize: 12,
              ),
            ),
          ])),
      /*
      * display empty of studentlist is empty
      * */
      body: (studentList.isEmpty)
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              padding: const EdgeInsets.all(14.0),
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                return ListOfStudentsWidget(
                    first_name: studentList[index]['first_name'] ?? 'No fname',
                    last_name: studentList[index]['last_name'] ?? 'No lname',
                    grade_level:
                        studentList[index]['grade_level'] ?? 'No grade level');
              }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: CreateStudent(
                      section_id: widget.section_id,
                      subject_id: widget.subject_id)));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Student',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

class ListOfStudentsWidget extends StatelessWidget {
  String first_name;
  String last_name;
  String grade_level;

  ListOfStudentsWidget(
      {required this.first_name,
      required this.last_name,
      required this.grade_level});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        // color: const Color(0xff081631),
        border: Border(
            bottom: BorderSide(
          width: 1,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$first_name $last_name",
              style: const TextStyle(color: Color(0xff081631), fontSize: 16.0)),
          Text(grade_level,
              style: const TextStyle(color: Color(0xFF696969), fontSize: 14.0)),
        ],
      ),
    );
  }
}

class CreateStudent extends StatefulWidget {
  String? section_id;
  String? subject_id;
  CreateStudent({required this.section_id, required this.subject_id});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  TextEditingController referenceNumberController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController middleInitialController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController courseController = TextEditingController();

  //TextEditingController gradeLevelController = TextEditingController();
  String gradeLevelValue = gradeLevelList.first;

  @override
  void initState() {
    super.initState();
  }

  Future<void> createStudent() async {
    final response = await http.post(Uri.parse(Api.createStudent), body: {
      'reference_number': referenceNumberController.text,
      'first_name': firstNameController.text,
      'middle_initial': middleInitialController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'course': courseController.text,
      'grade_level': gradeLevelValue,
      'section_id': widget.section_id,
      'subject_id': widget.subject_id
    });

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("nag error connect sa backend");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text('ADD STUDENT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          Form(
              child: Column(children: [
            createTextField(referenceNumberController, 'reference Number'),
            const SizedBox(height: 14),
            createTextField(firstNameController, 'First Name'),
            const SizedBox(height: 14),
            createTextField(middleInitialController, 'Middle Initial'),
            const SizedBox(height: 14),
            createTextField(lastNameController, 'Last Name'),
            const SizedBox(height: 14),
            createTextField(emailController, 'Last Name'),
            const SizedBox(height: 14),
            createTextField(emailController, 'Course'),
            const SizedBox(height: 14),
            DropdownButton<String>(
              isExpanded: true, //set width to 100%
              value: gradeLevelValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  gradeLevelValue = value!;
                });
              },
              items:
                  gradeLevelList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  createStudent();
                  Navigator.of(context, rootNavigator: true)
                      .pop(); //close dialog
                  setState(() {});
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 44.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF081631),
                  ),
                ),
                child: const Text("Add",
                    style: TextStyle(
                        backgroundColor: Color(0xFF081631),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))
          ]))
        ],
      ),
    );
  }
}

/*
*
* Widget components
*
*
* */
Widget createTextField(valueController, label) {
  return TextFormField(
    controller: valueController,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Color(0xFFABABAB)),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF081631),
          width: 2.0,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF8F8F8F)),
      ),
    ),
  );
}
