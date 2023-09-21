import 'dart:convert';
import 'dart:developer';

import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/models/auth/LoginRequest.dart';
import 'package:smart_car_app/services/auth_service.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../models/ws/ws_data.dart';

String wsUrl = "${AppUrl.baseUrl}/websocket/tracker";

var stompClient = StompClient(config: config);
var token = '';
var config = StompConfig.sockJS(
  url: wsUrl,
  stompConnectHeaders: {'Authorization': "Bearer $token"},
  webSocketConnectHeaders: {'Authorization': "Bearer $token"},
  onConnect: _onConnect,
  reconnectDelay: const Duration(seconds: 10),
  onStompError: (error) {
    log("stomp error: ${error.body} \n");
  },
  onWebSocketError: (err) {
    log("web socket error: ${err.toString()}");
  },
  beforeConnect: () async {
    log('waiting to connect...');
    log('connecting...');
  },
);

_onConnect(StompFrame frame) async {
  log('connected');
  stompClient.subscribe(
    // destination: '/user/topic/updates',
    destination: '/topic/messages',
    callback: (frame) {
      log("frame body: ${frame.body}");
    },
  );
  log("Subscribed");
}

Future activateWebSocket() async {
  var phone = await SecureStorage.read(key: SecureStorage.phone);
  var password = await SecureStorage.read(key: SecureStorage.password);
  await AuthService.doLogin(LoginRequest(username: phone, password: password));
  token = await SecureStorage.read(key: SecureStorage.token);
  stompClient.activate();
}

Future deactivateWebSocket() async => stompClient.deactivate();

class StompClientInstance {
  static connect() async => await activateWebSocket();

  static disconnect() async => await deactivateWebSocket();

  static send(WsData wsData) async {
    stompClient.send(
      destination: '/app/handler',
      body: json.encode(wsData.toMap()),
    );
  }
}

class StompSendRequest {
  static openConnection() {
    var openConnection = WsData(
      id: "1",
      method: "OPEN_CONNECTION",
      payload: {'chargeBoxId': '123'},
    );
    StompClientInstance.send(openConnection);
  }
}
