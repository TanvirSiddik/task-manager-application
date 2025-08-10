class ApiConfig {
  static const String baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registration = '$baseUrl/Registration';
  static const String login = '$baseUrl/Login';
  static const String update = '$baseUrl/ProfileUpdate';
  static const String profileDetails = '$baseUrl/ProfileDetails';
  static const String createTask = '$baseUrl/createTask';
  static const String getTask = '$baseUrl/listTaskByStatus';
  static const String getNewTask = '$baseUrl/listTaskByStatus/New';
  static const String getCompletedTask = '$baseUrl/listTaskByStatus/Completed';
  static const String getCanceledTask = '$baseUrl/listTaskByStatus/Canceled';
  static const String getProgressTask = '$baseUrl/listTaskByStatus/Progress';
  static String deleteTask(String id) => '$baseUrl/deleteTask/$id';
  static const String taskStatusCount = '$baseUrl/taskStatusCount';
  static String recoverVerifyEmail(String userEmail) =>
      '$baseUrl/RecoverVerifyEmail/$userEmail';
  static String recoverVerifyOtp(String userEmail, String otp) => '$baseUrl/RecoverVerifyOtp/$userEmail/$otp';
  static const String recoverResetPassword = '$baseUrl/RecoverResetPassword';

  static String updateTaskStatus(String id, String taskType) => '$baseUrl/updateTaskStatus/$id/$taskType';
}
