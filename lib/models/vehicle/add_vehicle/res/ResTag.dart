class ResTag {
  int? id;
  dynamic idTag;
  dynamic expiryDate;
  dynamic maxActiveTransactionCount;
  dynamic note;
  dynamic status;
  dynamic username;
  dynamic parentTag;

  ResTag({
    this.id,
    this.idTag,
    this.expiryDate,
    this.maxActiveTransactionCount,
    this.note,
    this.status,
    this.username,
    this.parentTag,
  });

  ResTag.fromJson(dynamic json) {
    id = json['id'];
    idTag = json['idTag'];
    expiryDate = json['expiryDate'];
    maxActiveTransactionCount = json['maxActiveTransactionCount'];
    note = json['note'];
    status = json['status'];
    username = json['username'];
    parentTag = json['parentTag'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['idTag'] = idTag;
    map['expiryDate'] = expiryDate;
    map['maxActiveTransactionCount'] = maxActiveTransactionCount;
    map['note'] = note;
    map['status'] = status;
    map['username'] = username;
    map['parentTag'] = parentTag;
    return map;
  }
}
