import 'ChargeBox.dart';
import 'Images.dart';
import 'Connectors.dart';

class Data {
  ChargeBox? chargeBox;
  List<Images>? images;
  List<Connectors>? connectors;

  Data({
    this.chargeBox,
    this.images,
    this.connectors,
  });

  Data.fromJson(dynamic json) {
    chargeBox = json['chargeBox'] != null
        ? ChargeBox.fromJson(json['chargeBox'])
        : null;
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    if (json['connectors'] != null) {
      connectors = [];
      json['connectors'].forEach((v) {
        connectors?.add(Connectors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chargeBox != null) {
      map['chargeBox'] = chargeBox?.toJson();
    }
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    if (connectors != null) {
      map['connectors'] = connectors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
