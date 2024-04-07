import 'dart:collection';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:smart_car_app/hive/hive_store.dart';

part 'ChargeBoxInfo.g.dart';

@HiveType(typeId: MyHiveTypeId.chargeBoxId)
class ChargeBoxInfo {
  @HiveField(0)
  String? country;
  @HiveField(1)
  String? city;
  @HiveField(2)
  String? addressName;
  @HiveField(3)
  String? street;
  @HiveField(4)
  double? locationLatitude;
  @HiveField(5)
  double? locationLongitude;
  @HiveField(6)
  String? name;
  @HiveField(7)
  dynamic id;

  ChargeBoxInfo({
    this.country,
    this.city,
    this.addressName,
    this.street,
    this.locationLatitude,
    this.locationLongitude,
    this.name,
    this.id,
  });

  ChargeBoxInfo.fromJson(dynamic json) {
    country = json['country'];
    city = json['city'];
    addressName = json['addressName'];
    street = json['street'];
    locationLatitude = json['locationLatitude'];
    locationLongitude = json['locationLongitude'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = country;
    map['city'] = city;
    map['addressName'] = addressName;
    map['street'] = street;
    map['locationLatitude'] = locationLatitude;
    map['locationLongitude'] = locationLongitude;
    map['name'] = name;
    map['id'] = id;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeBoxInfo &&
          runtimeType == other.runtimeType &&
          locationLatitude == other.locationLatitude &&
          locationLongitude == other.locationLongitude;

  @override
  int get hashCode => locationLatitude.hashCode ^ locationLongitude.hashCode;
}

compareChargeBox() {
  List<ChargeBoxInfo> list = [
    ChargeBoxInfo(id: 1, name: "Name 1"),
    ChargeBoxInfo(id: 2, name: "Name 2"),
    ChargeBoxInfo(id: 1, name: "Name 3"),
    ChargeBoxInfo(id: 2, name: "Name 4"),
    ChargeBoxInfo(id: 3, name: "Name 5"),
  ];
  HashSet<ChargeBoxInfo> set = HashSet<ChargeBoxInfo>();
  for (var element in list) {
    set.add(element);
  }
  for (var element in set) {
    log("Set element: ${element.name}");
  }
}
