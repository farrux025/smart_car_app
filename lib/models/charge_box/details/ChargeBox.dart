class ChargeBox {
  String? id;
  String? status;
  dynamic imsi;
  String? lastHeartbeatTimestamp;
  String? chargeBoxInfoName;
  String? information;
  dynamic facilities;
  String? workingHours;
  double? price;
  String? addressName;
  dynamic fullAddress;
  String? houseNumber;
  String? locality;
  String? country;
  String? area;
  String? province;
  String? district;
  String? street;
  dynamic other;
  dynamic metro;
  dynamic hydro;
  dynamic vegetation;
  dynamic airport;
  double? locationLatitude;
  double? locationLongitude;
  String? brandName;
  String? phoneSupport1;
  String? phoneSupport2;
  String? telegram;
  String? phoneBoss;
  String? appUrl;
  String? appStoreUrl;
  String? socialNetworks;

  ChargeBox({
    this.id,
    this.status,
    this.imsi,
    this.lastHeartbeatTimestamp,
    this.chargeBoxInfoName,
    this.information,
    this.facilities,
    this.workingHours,
    this.price,
    this.addressName,
    this.fullAddress,
    this.houseNumber,
    this.locality,
    this.country,
    this.area,
    this.province,
    this.district,
    this.street,
    this.other,
    this.metro,
    this.hydro,
    this.vegetation,
    this.airport,
    this.locationLatitude,
    this.locationLongitude,
    this.brandName,
    this.phoneSupport1,
    this.phoneSupport2,
    this.telegram,
    this.phoneBoss,
    this.appUrl,
    this.appStoreUrl,
    this.socialNetworks,
  });

  ChargeBox.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    imsi = json['imsi'];
    lastHeartbeatTimestamp = json['lastHeartbeatTimestamp'];
    chargeBoxInfoName = json['chargeBoxInfoName'];
    information = json['information'];
    facilities = json['facilities'];
    workingHours = json['workingHours'];
    price = json['price'];
    addressName = json['addressName'];
    fullAddress = json['fullAddress'];
    houseNumber = json['houseNumber'];
    locality = json['locality'];
    country = json['country'];
    area = json['area'];
    province = json['province'];
    district = json['district'];
    street = json['street'];
    other = json['other'];
    metro = json['metro'];
    hydro = json['hydro'];
    vegetation = json['vegetation'];
    airport = json['airport'];
    locationLatitude = json['locationLatitude'];
    locationLongitude = json['locationLongitude'];
    brandName = json['brandName'];
    phoneSupport1 = json['phoneSupport1'];
    phoneSupport2 = json['phoneSupport2'];
    telegram = json['telegram'];
    phoneBoss = json['phoneBoss'];
    appUrl = json['appUrl'];
    appStoreUrl = json['appStoreUrl'];
    socialNetworks = json['socialNetworks'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['imsi'] = imsi;
    map['lastHeartbeatTimestamp'] = lastHeartbeatTimestamp;
    map['chargeBoxInfoName'] = chargeBoxInfoName;
    map['information'] = information;
    map['facilities'] = facilities;
    map['workingHours'] = workingHours;
    map['price'] = price;
    map['addressName'] = addressName;
    map['fullAddress'] = fullAddress;
    map['houseNumber'] = houseNumber;
    map['locality'] = locality;
    map['country'] = country;
    map['area'] = area;
    map['province'] = province;
    map['district'] = district;
    map['street'] = street;
    map['other'] = other;
    map['metro'] = metro;
    map['hydro'] = hydro;
    map['vegetation'] = vegetation;
    map['airport'] = airport;
    map['locationLatitude'] = locationLatitude;
    map['locationLongitude'] = locationLongitude;
    map['brandName'] = brandName;
    map['phoneSupport1'] = phoneSupport1;
    map['phoneSupport2'] = phoneSupport2;
    map['telegram'] = telegram;
    map['phoneBoss'] = phoneBoss;
    map['appUrl'] = appUrl;
    map['appStoreUrl'] = appStoreUrl;
    map['socialNetworks'] = socialNetworks;
    return map;
  }
}
