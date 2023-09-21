class WsData {
  String id;
  String method;
  dynamic payload;

  WsData({required this.id, required this.method, this.payload});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'method': method,
      'payload': payload,
    };
  }

  factory WsData.fromMap(Map<String, dynamic> map) {
    return WsData(
        id: map['id'] as String,
        method: map['method'] as String,
        payload: map['payload'] as dynamic);
  }
}
