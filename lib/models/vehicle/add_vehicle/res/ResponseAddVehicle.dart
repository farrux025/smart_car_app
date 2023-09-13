import 'ResTag.dart';

class ResponseAddVehicle {
  int? id;
  int? modelId;
  int? manufactureId;
  String? imageUrl;
  String? status;
  String? carNumber;
  ResTag? tag;
  dynamic user;

  ResponseAddVehicle({
    this.id,
    this.modelId,
    this.manufactureId,
    this.imageUrl,
    this.status,
    this.carNumber,
    this.tag,
    this.user,
  });

  ResponseAddVehicle.fromJson(dynamic json) {
    id = json['id'];
    modelId = json['modelId'];
    manufactureId = json['manufactureId'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    carNumber = json['carNumber'];
    tag = json['tag'] != null ? ResTag.fromJson(json['tag']) : null;
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['modelId'] = modelId;
    map['manufactureId'] = manufactureId;
    map['imageUrl'] = imageUrl;
    map['status'] = status;
    map['carNumber'] = carNumber;
    if (tag != null) {
      map['tag'] = tag?.toJson();
    }
    map['user'] = user;
    return map;
  }
}
