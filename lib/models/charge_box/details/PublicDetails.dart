import 'Data.dart';

class PublicDetails {
  bool? success;
  String? message;
  Data? data;

  PublicDetails({
    this.success,
    this.message,
    this.data,
  });

  PublicDetails.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
