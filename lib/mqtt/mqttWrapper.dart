// import 'package:imdp_xl/mqtt/mqttAppState.dart';
import 'package:flutter/material.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/mqtt/mqttManager.dart';

class MqttWrapper extends ChangeNotifier {
  late final MQTTManager _manager;
  final MQTTAppState _state = MQTTAppState();
  // final MQTTAppState _appState;

  MqttWrapper() {
    // _state = MQTTAppState();
    _manager = MQTTManager(
        host: "test.mosquitto.org",
        topic: "quaildea/messages",
        identifier: "Flutter_Test",
        state: _state);
  }
  void connect() {
    // _state = state;
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
