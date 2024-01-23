// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print

import 'package:attendifyyy/student_screen/list_of_student.dart';
import 'package:attendifyyy/subject_screen/delete_subject.dart';
import 'package:attendifyyy/subject_screen/edit_subject.dart';
import 'package:flutter/material.dart';

class ListOfSubjectsWidget extends StatelessWidget {
  String subject_teachers_id;
  String subject_name;
  String subject_code;
  String section_name;
  String section_id;
  String subject_id;
  int backgroundColor;

  ListOfSubjectsWidget({
    required this.subject_teachers_id,
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
      margin: const EdgeInsets.only(top: 18), //spaces between subject cards
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog.fullscreen(
              child: ListOfStudentsScreen(
                  subject_teachers_id: subject_teachers_id,
                  section_id: section_id,
                  subject_code: subject_code,
                  subject_id: subject_id,
                  subject_name: subject_name),
            ),
          );
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(16.0),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size.fromHeight(120),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Color(backgroundColor),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subject_name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  //POPUP PARAS EDIT AND DELETE
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.edit,
                                  size: 18.0, color: Color(0xFF081631)),
                              SizedBox(width: 5.0),
                              Text(
                                "Edit",
                                style: TextStyle(
                                  color: Color(0xFF081631),
                                ),
                              )
                            ],
                          ),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_forever,
                                size: 18.0,
                                color: Color(0xFF081631),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "Delete",
                                style: TextStyle(
                                  color: Color(0xFF081631),
                                ),
                              )
                            ],
                          ),
                        ),
                      ];
                    },
                    //DIALOG PARAS EDIT AND DELETE NGA DROPDOWN
                    onSelected: (value) {
                      if (value == 0) {
                        print("Class Schedule update.");

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: EditSubject(
                                subject_teachers_id: subject_teachers_id,
                                subject_id: subject_id,
                                subject_name: subject_name,
                                subject_code: subject_code,
                                section_name: section_name),
                          ),
                        );
                      } else if (value == 1) {
                        print("Subject delete.");

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: DeleteSubject(
                              subject_id: subject_id,
                              section_id: section_id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject_code,
                    style: const TextStyle(
                      color: Color(0xDAEAEAEA),
                      fontSize: 20.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      section_name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
