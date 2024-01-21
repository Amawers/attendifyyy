import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

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
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xff081631)),
            onPressed: () => Navigator.pop(context)),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student List',
              style: TextStyle(
                color: Color(0xff081631),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      /*
      * display empty of studentlist is empty
      * */
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Aligns children to the start and end of the row
              children: [
                //text para sa subject name ug subject code
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.subject_name}',
                      style: const TextStyle(
                        color: Color(0xff081631),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.subject_code}',
                      style: const TextStyle(
                        color: Color(0xff081631),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                //button para edit
                Ink(
                  decoration: const ShapeDecoration(
                    color:
                        Color(0xff081631), // set ang background color sa button
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: () {
                      
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white, // set ang color sa icon
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: (studentList.isEmpty)
                ? const Center(child: Text('Empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(14.0),
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      return ListOfStudentsWidget(
                        first_name:
                            studentList[index]['first_name'] ?? 'No fname',
                        last_name:
                            studentList[index]['last_name'] ?? 'No lname',
                        grade_level: studentList[index]['grade_level'] ??
                            'No grade level',
                      );
                    },
                  ),
          ),
        ],
      ),
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
      decoration: BoxDecoration(
        color: const Color(0xFF081631),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(first_name,
                style: const TextStyle(color: Colors.white, fontSize: 18.0)),
            Text(last_name,
                style: const TextStyle(color: Colors.white, fontSize: 18.0)),
          ]),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(grade_level,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          )
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
  String gradeLevelValue = gradeLevelList.first;
  final _studentFormKey = GlobalKey<FormState>();

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
      height: 580,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text('ADD STUDENT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          Form(
              key: _studentFormKey,
              child: Column(children: [
                const SizedBox(height: 14),
                createTextField(referenceNumberController, 'Reference Number',
                    (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
                    return "Must contain only numbers";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(firstNameController, 'First Name', (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  } else if (value.contains(RegExp(r'[0-9]'))) {
                    return "Must contain only letters";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(middleInitialController, 'Middle Initial',
                    (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  } else if (value.contains(RegExp(r'[0-9]'))) {
                    return "Must contain only letters";
                  } else if (value.length > 1) {
                    return "Character limit exceeded.";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(lastNameController, 'Last Name', (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  } else if (value.contains(RegExp(r'[0-9]'))) {
                    return "Must contain only letters";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(emailController, 'Email', (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  } else if (!EmailValidator.validate(value)) {
                    return "Please use a valid email address.";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(courseController, 'Course', (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                }),
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
                  items: gradeLevelList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      //validate textfields
                      if (_studentFormKey.currentState!.validate()) {
                        //create student in the database
                        createStudent();
                        Navigator.of(context, rootNavigator: true)
                            .pop(); //close dialog
                      }
                      setState(() {});
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size.fromHeight(
                              55)), //having height will make width 100%
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 44.0)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF081631),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
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
