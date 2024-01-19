import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/bottom_nav_bar.dart';
import 'package:attendifyyy/create_students/create_students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> semesterList = <String>["1st Semester", "2nd Semester"];

class ListOfSubjects extends StatefulWidget {
  const ListOfSubjects({super.key});

  @override
  State<ListOfSubjects> createState() => _ListOfSubjectsState();
}

class _ListOfSubjectsState extends State<ListOfSubjects> {
  List<dynamic> converted = [];

  @override
  void initState() {
    super.initState();
    getListOfSubjects();
  }

  Future<void> getListOfSubjects() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String? teacherId = teacherInfo?['teacher_id'];
    if (teacherId != null && teacherId.isNotEmpty) {
      final response = await http
          .get(Uri.parse('${Api.listOfSubjects}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          setState(() {
            converted = jsonDecode(response.body);
          });
          print("Already converted from Json: $converted");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No subjects")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to fetch subjects")));
      }
    } else {
      print("Error: Teacher ID is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColors = [
      0xFF00315D,
      0xFFA4C9FE,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))),
        title: const Text('Subject List'),
      ),
      body: (converted.isEmpty)
          ? const Center(child: Text('Empty'))
          : ListView.builder(
          padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 90.0),
              itemCount: converted.length,
              itemBuilder: (context, index) {
                return ListOfSubjectsWidget(
                  subject_name: converted[index]['subject_name'] ?? 'tesssst',
                  subject_code: converted[index]['subject_code'] ?? 'tesssst',
                  section_name: converted[index]['section_name'] ?? 'tesssst',
                  section_id: converted[index]['section_id'] ?? 'tesssst',
                  subject_id: converted[index]['subject_id'],
                  backgroundColor: backgroundColors[index % 2],
                );
              }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF081631),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: CreateSubject()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Subject',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

class ListOfSubjectsWidget extends StatelessWidget {
  String subject_name;
  String subject_code;
  String section_name;
  String section_id;
  String subject_id;
  int backgroundColor;

  ListOfSubjectsWidget({
    required this.subject_name,
    required this.subject_code,
    required this.section_name,
    required this.section_id,
    required this.subject_id,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:
            const EdgeInsets.only(bottom: 18.0), //spaces between subject cards
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog.fullscreen(
                      child: ListOfStudentsScreen(
                          section_id: section_id,
                          subject_code: subject_code,
                          subject_id: subject_id,
                          subject_name: subject_name)));
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(16.0)),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size.fromHeight(100)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(backgroundColor)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject_name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    )),
                const SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subject_code,
                          style: const TextStyle(
                            color: Color(0xDAEAEAEA),
                            fontSize: 20.0,
                          )),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 14.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(section_name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              )))
                    ]),
              ],
            )));
  }
}

class CreateSubject extends StatefulWidget {
  @override
  _CreateSubject createState() => _CreateSubject();
}

class _CreateSubject extends State<CreateSubject> {
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController subjectCodeController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();
  String semesterValue = semesterList.first;
  final _subjectFormKey = GlobalKey<FormState>();

  Future<void> createSubject() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    final response = await http.post(Uri.parse(Api.createSubject), body: {
      'teacher_id': teacherId,
      'subject_name': subjectNameController.text,
      'subject_code': subjectCodeController.text,
      'section_name': sectionNameController.text.toUpperCase(),
      'semester': semesterValue
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response.body}')));

    print(sectionNameController.text.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const Text('ADD SUBJECT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          Form(
              key: _subjectFormKey,
              child: Column(children: [
                const SizedBox(height: 14),
                createTextField(subjectNameController, "Subject Name", (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(subjectCodeController, "Subject Code", (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  else if(value.length > 10) {
                    return "Character limit exceeded.";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                createTextField(sectionNameController, "Section", (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                }),
                const SizedBox(height: 14),
                DropdownButton<String>(
                  isExpanded: true, //set width to 100%
                  value: semesterValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      semesterValue = value!;
                    });
                  },
                  items: semesterList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                    onPressed: () {
                      //validate textfields
                      if (_subjectFormKey.currentState!.validate()) {
                        //create subject in the database
                        createSubject();
                        Navigator.of(context, rootNavigator: true)
                            .pop(); //close dialog
                      }
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
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
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
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
      ));
}
