class Global {
  static var userModel = UserModel();
  static var myPackageInfo = MyPackageInfo();
}

class UserModel {
  String? username;
  String? otp;

  UserModel({this.username, this.otp});
}

class MyPackageInfo {
  String? appVersion;
  String? appName;

  MyPackageInfo({this.appVersion, this.appName});
}
