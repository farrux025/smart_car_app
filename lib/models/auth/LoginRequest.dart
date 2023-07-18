class LoginRequest {
  String? username;
  String? password;
  bool? rememberMe;

  LoginRequest({
    this.username,
    this.password,
    this.rememberMe,
  });

  LoginRequest.fromJson(dynamic json) {
    username = json['username'];
    password = json['password'];
    rememberMe = json['rememberMe'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;
    map['rememberMe'] = rememberMe;
    return map;
  }
}
