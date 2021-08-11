// import 'package:imdp_xl/mqtt/mqttAppState.dart';
import 'package:flutter/material.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/mqtt/mqttManager.dart';

class MqttWrapper extends ChangeNotifier {
  late MQTTManager _manager;
  late MQTTAppState _state;

  void setState(MQTTAppState state) {
    _state = state;
  }

  void connect() {
    _manager = MQTTManager(
        host: "test.mosquitto.org",
        topic: "quaildea/node/temp/#",
        identifier: "Flutter_Test",
        state: _state);
    if (_state.getAppConnectionState == MQTTAppConnectionState.disconnected) {
      _manager.initializeMQTTClient();
      _manager.connect();
    }
  }

  void disconnect() {
    _manager.disconnect();
  }

  String get getMessage => _state.getReceivedText;

  MQTTAppState get getAppState => _state;
}
