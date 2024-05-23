class Constant {
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);
  static const Duration prodConnectTimeout = Duration(seconds: 20);
  static const Duration prodReceiveTimeout = Duration(seconds: 20);
  static const Duration prodSendTimeout = Duration(seconds: 20);
  static const int maxLengthForDescription = 250;
  static const String token = 'access_token';
  static const String userInfo = 'userInfo';
  static const String baseUrl = 'https://dummyjson.com/';
}
