class ApiEndpoints {
  ///main
  // static String baseUrl = 'http://localhost:5000/api';
  // static String baseUrl = 'http://192.168.0.189:5000/api';
  static String baseUrl = 'http://10.0.2.2:5000/api';
  static String url = 'http://10.0.2.2:5000/';

  ///auth
  static String register = '$baseUrl/register';
  static String login = '$baseUrl/login';
  static String forget = '$baseUrl/forget-password';
  static String resetPass = '$baseUrl/reset-password';
  static String verify = '$baseUrl/verify-otp';

  static String allPost = '$baseUrl/post';

  static String blogPost = '$baseUrl/admin/post/get';
  static String createPost = '$baseUrl/post';
  static String allMentalPost = '$baseUrl/admin/mental';
  static String allCategory = '$baseUrl/allcategory';
  static String getAllcounselors = '$baseUrl/all';
}
