class Connectors {
  int? connectorId;
  num? chargeBoxId;
  String? connectorTypeId;
  num? kilowatt;
  String? imageUrl;

  Connectors({
    this.connectorId,
    this.chargeBoxId,
    this.connectorTypeId,
    this.kilowatt,
    this.imageUrl,
  });

  Connectors.fromJson(dynamic json) {
    connectorId = json['connectorId'];
    chargeBoxId = json['chargeBoxId'];
    connectorTypeId = json['connectorTypeId'];
    kilowatt = json['kilowatt'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['connectorId'] = connectorId;
    map['chargeBoxId'] = chargeBoxId;
    map['connectorTypeId'] = connectorTypeId;
    map['kilowatt'] = kilowatt;
    map['imageUrl'] = imageUrl;
    return map;
  }
}
