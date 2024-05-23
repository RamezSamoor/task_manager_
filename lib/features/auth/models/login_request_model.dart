class LoginRequestModel {
  final String? username;
  final String? password;

  LoginRequestModel({
    this.username,
    this.password,
  });

  LoginRequestModel.fromJson(Map<String, dynamic> json)
    : username = json['username'] as String?,
      password = json['password'] as String?;

  Map<String, dynamic> toJson() => {
    if(username!=null)
    'username' : username,
    if(password!=null)
    'password' : password,
  };
}