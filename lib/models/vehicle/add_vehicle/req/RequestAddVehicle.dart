import 'ReqTag.dart';

class RequestAddVehicle {
  int? modelId;
  int? manufactureId;
  String? imageUrl;
  String? status;
  String? carNumber;
  String? username;
  ReqTag? tag;

  RequestAddVehicle({
    this.modelId,
    this.manufactureId,
    this.imageUrl,
    this.status,
    this.carNumber,
    this.username,
    this.tag,
  });

  RequestAddVehicle.fromJson(dynamic json) {
    modelId = json['modelId'];
    manufactureId = json['manufactureId'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    carNumber = json['carNumber'];
    username = json['username'];
    tag = json['tag'] != null ? ReqTag.fromJson(json['tag']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['modelId'] = modelId;
    map['manufactureId'] = manufactureId;
    map['imageUrl'] = imageUrl;
    map['status'] = status;
    map['carNumber'] = carNumber;
    map['username'] = username;
    if (tag != null) {
      map['tag'] = tag?.toJson();
    }
    return map;
  }
}
