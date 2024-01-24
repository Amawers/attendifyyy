import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/attendance/attendance_list.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static String? imagePath;
  static String? firstName;
  static String? lastName;
  static String? email;
  static String? contactNumber;
  static String? department;
  static String subject = '';
  static String section = '';
  static List<dynamic> attendanceListData = [];
  static List<dynamic> subjectListData = [];
  static List<dynamic> scheduleListData = [];

  static Future<void> updateAccount(
      {required BuildContext context,
      required TextEditingController fnameController,
      required TextEditingController lnameController,
      required TextEditingController emailController,
      required TextEditingController contactNoController,
      required TextEditingController departmentController}) async {
    String? teacherId;

    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();
    teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http.put(Uri.parse(Api.updateAccount), body: {
        'teacher_id': teacherId,
        'first_name': fnameController.text,
        'last_name': lnameController.text,
        'email': emailController.text,
        'phone_number': contactNoController.text,
        'department': departmentController.text
      });

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("UPDATE SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("UPDATE FAILED",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("AN APP ERROR OCCURED",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)));
    }
  }

  static Future<void> retrieveImage({required BuildContext context}) async {
    String? teacherId;
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();
    teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http
          .get(Uri.parse('${Api.retrieveImage}?teacher_id=$teacherId'));

      if (response.statusCode == 200) {
        print("RETRIEVE IMAGE: Connection to API established.");

        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          print("RETRIEVE IMAGE: Data retrieval success.");

          imagePath = decoded['image_path'];
        } else if (decoded['success'] == false) {
          print("RETRIEVE IMAGE: Data retrieval failed.");
        }
      } else {
        print("RETRIEVE IMAGE: Problem communicating with API.");
      }
    } catch (error) {
      print(
          "RETRIEVE IMAGE: Incorrect endpoints or problem with controller values.");
    }
  }

  static Future<void> getTeacherData() async {
    List<dynamic> teacherData = [];
    String? teacherId;

    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http
          .get(Uri.parse('${Api.getTeacherData}?teacher_id=$teacherId'));

      if (response.statusCode == 200) {
        print("RETRIEVE TEACHER DATA: Connection to API established.");

        var decoded = jsonDecode(response.body);
        teacherData = decoded["teacher_data"];

        if (decoded['success'] == true) {
          print("RETRIEVE TEACHER DATA: Data retrieval success.");

          firstName = teacherData[0]['first_name'];
          lastName = teacherData[0]['last_name'];
          email = teacherData[0]['email'];
          contactNumber = teacherData[0]['phone_number'];
          department = teacherData[0]['department'];
        } else if (decoded['success'] == false) {
          print("RETRIEVE TEACHER DATA: Data retrieval failed.");
        }
      } else {
        print("RETRIEVE TEACHER DATA: Problem communicating with API.");
      }
    } catch (error) {
      print(
          "RETRIEVE TEACHER DATA: Incorrect endpoints or problem with controller values.");
    }
  }

  static Future<void> getListOfSubjects() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String? teacherId = teacherInfo?['teacher_id'];
    try {
      final response = await http
          .get(Uri.parse('${Api.listOfSubjects}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        print("RETRIEVE TEACHER DATA: Connection to API established.");

        var decoded = jsonDecode(response.body);
        subjectListData = decoded['subject_list_data'];

        if (decoded['success'] == true) {
          print("RETRIEVE TEACHER DATA: Data retrieval success.");

          subject = subjectListData[0]['subject_name'];
          section = subjectListData[0]['section_name'];
        } else if (decoded['success'] == false) {
          print("RETRIEVE TEACHER DATA: Data retrieval failed.");
        }
      } else {
        print("RETRIEVE SUBJECTS LIST: Problem communicating with API.");
      }
    } catch (error) {
      print(
          "RETRIEVE SUBJECTS LIST: Incorrect endpoints or problem with controller values.");
    }
  }

  static Future<void> getAttendanceList(
      {required BuildContext context,
      required String subject,
      required String section}) async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    print("CHECK BACKEND: $subject");
    print("CHECK BACKEND: $section");

    try {
      final response = await http.post(Uri.parse(Api.listOfAttendance), body: {
        'teacher_id': teacherId,
        'subject_name': subject,
        'section_name': section
      });
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        attendanceListData = decoded['attendance_list_data'];

        if (decoded['success'] == true) {
          AttendanceReport.filterData = attendanceListData;

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("UPDATE SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          AttendanceReport.filterData.clear();
          attendanceListData.clear();

          print("sulod sa na clear ${attendanceListData}");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("AN APP ERROR OCCURED",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        AttendanceReport.filterData.clear();
        attendanceListData.clear();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      AttendanceReport.filterData.clear();
      attendanceListData.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("NO ATTENDANCE RECORD FOR SUBJECT",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)));
    }
  }

  static Future<void> createSchedule(
      {required BuildContext context,
      required String? subject,
      required String? section,
      required TimeOfDay start,
      required TimeOfDay end,
      required String? dayWeekValue}) async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http.post(Uri.parse(Api.createSchedule), body: {
        'teacher_id': teacherId,
        'subject_name': subject,
        'section_name': section,
        'start_time': "$start.",
        'end_time': "$end",
        'days_of_week': dayWeekValue
      });
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("CREATED SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("FAILED TO CREATE",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("AN APP ERROR OCCURED",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)));
    }
  }

  static Future<void> getListOfSchedules(
      {required BuildContext context}) async {
    String? teacherId;
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    teacherId = teacherInfo?['teacher_id'];
    try {
      final response = await http
          .get(Uri.parse('${Api.listOfSchedules}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          scheduleListData = decoded['schedule_list_data'];
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("RETRIEVE SUBJECTS SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("NO SCHEDULE FOR CURRENT TEACHER",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("AN APP ERROR OCCURED",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)));
    }
  }

  static Future<void> editSchedule(
      {required BuildContext context,
      required String? schedule,
      required TimeOfDay start,
      required TimeOfDay end,
      required String? dayWeekValue}) async {
    try {
      final response = await http.put(Uri.parse(Api.updateSchedule), body: {
        'schedule_id': schedule,
        'start_time': "$start.",
        'end_time': "$end",
        'days_of_week': dayWeekValue
      });
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("EDITED SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("FAILED TO EDIT",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("AN APP ERROR OCCURED",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)));
    }
  }

  static Future<void> deleteSchedule(
      {required BuildContext context, String? schedule_id}) async {
    try {
      final response = await http.delete(
          Uri.parse('${Api.deleteSchedule}?schedule_id=${schedule_id}'));
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("DELETED SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("FAILED TO DELETE",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      print("DEVSIDE TO HANDLE");
    }
  }

  static Future<void> editSubject(
      {required BuildContext context,
      String? subTeacherId,
      String? subject,
      String? subjectCode,
      String? section,
      String? semester}) async {
    try {
      final response = await http.put(Uri.parse(Api.updateSubjectData), body: {
        'subject_teachers_id': subTeacherId,
        'subject_name': subject,
        'subject_code': subjectCode,
        'section_name': section,
        'semester': semester
      });

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("EDITED SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("FAILED TO EDIT",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      print("DEVSIDE TO HANDLE");
    }
  }

  static Future<void> deleteSubject(
      {required BuildContext context,
      String? subjectId,
      String? sectionId}) async {
    try {
      final response = await http.delete(Uri.parse(Api.deleteSubject),
          body: {'subject_id': subjectId, 'section_id': sectionId});

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("DELETED SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("FAILED TO DELETE",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      print("DEVSIDE TO HANDLE");
    }
  }

  static Future<void> createSubject(
      {required BuildContext context,
      String? subject,
      String? subjectCode,
      String? section,
      String? semester
      }) async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String teacherId = teacherInfo?['teacher_id'];

    try {
      final response = await http.post(Uri.parse(Api.createSubject), body: {
        'teacher_id': teacherId,
        'subject_name': subject,
        'subject_code': subjectCode,
        'section_name': section,
        'semester': semester
      });
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("CREATED SUCCESSFULLY",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)));
        } else if (decoded['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("FAILED TO CREATE",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PROBLEM COMMUNICATING WITH SERVER",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1)));
      }
    } catch (error) {
      print("DEVSIDE TO HANDLE");
    }
  }
}
