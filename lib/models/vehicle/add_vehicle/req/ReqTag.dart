class ReqTag {
  int? id;

  ReqTag({this.id});

  ReqTag.fromJson(dynamic json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }
}
