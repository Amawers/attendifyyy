class Api {
  static const ip = '192.168.1.11';
  // static const ip = 'localhost';
  static const hostConnect = 'http://$ip/attendifyyy_backend';
  static const signUp = '$hostConnect/authentication/sign_up.php';
  static const logIn = '$hostConnect/authentication/log_in.php';
  static const createSubject = '$hostConnect/create_subject/create_subject.php';
}
