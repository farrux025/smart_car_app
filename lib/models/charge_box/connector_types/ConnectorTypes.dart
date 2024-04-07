class ConnectorTypes {
  String? id;
  dynamic newId;
  String? status;
  dynamic information;
  List<ConnectorTypeLogos>? logos;

  ConnectorTypes({
    this.id,
    this.newId,
    this.status,
    this.information,
    this.logos,
  });

  ConnectorTypes.fromJson(dynamic json) {
    id = json['id'];
    newId = json['newId'];
    status = json['status'];
    information = json['information'];
    if (json['logos'] != null) {
      logos = [];
      json['logos'].forEach((v) {
        logos?.add(ConnectorTypeLogos.fromJson(v));
      });
    }
  }

  ConnectorTypes copyWith({
    String? id,
    dynamic newId,
    String? status,
    dynamic information,
    List<ConnectorTypeLogos>? logos,
  }) =>
      ConnectorTypes(
        id: id ?? this.id,
        newId: newId ?? this.newId,
        status: status ?? this.status,
        information: information ?? this.information,
        logos: logos ?? this.logos,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['newId'] = newId;
    map['status'] = status;
    map['information'] = information;
    if (logos != null) {
      map['logos'] = logos?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ConnectorTypeLogos {
  ConnectorTypeLogos({
    this.id,
    this.entityId,
    this.name,
    this.status,
    this.ord,
    this.group,
    this.url,
    this.srcUrl,
    this.localUrl,
    this.chargeBoxInfoId,
  });

  ConnectorTypeLogos.fromJson(dynamic json) {
    id = json['id'];
    entityId = json['entityId'];
    name = json['name'];
    status = json['status'];
    ord = json['ord'];
    group = json['group'];
    url = json['url'];
    srcUrl = json['srcUrl'];
    localUrl = json['localUrl'];
    chargeBoxInfoId = json['chargeBoxInfoId'];
  }

  int? id;
  dynamic entityId;
  String? name;
  String? status;
  int? ord;
  dynamic group;
  String? url;
  dynamic srcUrl;
  dynamic localUrl;
  dynamic chargeBoxInfoId;

  ConnectorTypeLogos copyWith({
    int? id,
    dynamic entityId,
    String? name,
    String? status,
    int? ord,
    dynamic group,
    String? url,
    dynamic srcUrl,
    dynamic localUrl,
    dynamic chargeBoxInfoId,
  }) =>
      ConnectorTypeLogos(
        id: id ?? this.id,
        entityId: entityId ?? this.entityId,
        name: name ?? this.name,
        status: status ?? this.status,
        ord: ord ?? this.ord,
        group: group ?? this.group,
        url: url ?? this.url,
        srcUrl: srcUrl ?? this.srcUrl,
        localUrl: localUrl ?? this.localUrl,
        chargeBoxInfoId: chargeBoxInfoId ?? this.chargeBoxInfoId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['entityId'] = entityId;
    map['name'] = name;
    map['status'] = status;
    map['ord'] = ord;
    map['group'] = group;
    map['url'] = url;
    map['srcUrl'] = srcUrl;
    map['localUrl'] = localUrl;
    map['chargeBoxInfoId'] = chargeBoxInfoId;
    return map;
  }
}
