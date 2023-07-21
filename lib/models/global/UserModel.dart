class Global {
  static var userModel = UserModel();
}

class UserModel {
  String? username;
  String? otp;

  UserModel({this.username, this.otp});
}
