class Connectors {
  int? connectorId;
  String? chargeBoxId;
  String? connectorTypeId;
  String? imageUrl;

  Connectors({
    this.connectorId,
    this.chargeBoxId,
    this.connectorTypeId,
    this.imageUrl,
  });

  Connectors.fromJson(dynamic json) {
    connectorId = json['connectorId'];
    chargeBoxId = json['chargeBoxId'];
    connectorTypeId = json['connectorTypeId'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['connectorId'] = connectorId;
    map['chargeBoxId'] = chargeBoxId;
    map['connectorTypeId'] = connectorTypeId;
    map['imageUrl'] = imageUrl;
    return map;
  }
}
