class Api {
  static const ip = '192.168.1.11';
  // static const ip = 'localhost';
  static const hostConnect = 'http://$ip/attendifyyy_backend';
  static const signUp = '$hostConnect/authentication/sign_up.php';
  static const logIn = '$hostConnect/authentication/log_in.php';
  static const createSubject = '$hostConnect/create_subject/create_subject.php';
  static const listOfSubjects = '$hostConnect/create_subject/subjects_list.php';
  static const listOfStudents = '$hostConnect/create_student/students_list.php';
  static const createStudent = '$hostConnect/create_student/create_students.php';
  static const listOfSchedules = '$hostConnect/create_schedule/schedules_list.php';
  static const createSchedule = '$hostConnect/create_schedule/create_schedule.php';
  static const listOfAttendance = '$hostConnect/attendance/attendance_list.php';
  static const createAttendance = '$hostConnect/attendance/create_attendance.php';
  static const getTeacherData = '$hostConnect/utils/teacher_data.php';
  static const uploadImage = '$hostConnect/upload_image.php';
  static const retrieveImage = '$hostConnect/retrieve_image.php';
  static const deleteSchedule = '$hostConnect/create_schedule/delete_schedule.php';
  static const updateAccount = '$hostConnect/account/update_account.php';
}
