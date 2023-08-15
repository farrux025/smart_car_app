class Images {
  String? name;
  String? url;
  String? id;

  Images({
    this.name,
    this.url,
    this.id,
  });

  Images.fromJson(dynamic json) {
    name = json['name'];
    url = json['url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    map['id'] = id;
    return map;
  }
}
