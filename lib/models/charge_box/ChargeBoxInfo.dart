class ChargeBoxInfo {
  String? country;
  String? city;
  String? addressName;
  String? street;
  double? locationLatitude;
  double? locationLongitude;
  String? name;
  String? id;

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
}
