class ApiEndpoints {
  ///main
  static String baseUrl = 'http://192.168.0.189:5000/api';


  ///auth
  static String  register = '$baseUrl/register';
  static String  login = '$baseUrl/login';
  static String  forget = '$baseUrl/forget-password';
  static String  resetPass = '$baseUrl/reset-password';
  static String  verify = '$baseUrl/verify-otp';


}