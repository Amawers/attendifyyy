import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPreferences {
  static Future<void> storeUserInfo(dynamic user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(user);
    await preferences.setString('currentTeacherId', userJsonData);
  }

  static Future<Map<String, dynamic>?> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? teacherInfo = preferences.getString('currentTeacherId');

    if (teacherInfo != null) {
      try {
        Map<String, dynamic> teacherDataMap = jsonDecode(teacherInfo);
        return teacherDataMap;
      } catch (e) {
        print("Error decoding JSON: $e");
        return null;
      }
    }

    return null;
  }
}
