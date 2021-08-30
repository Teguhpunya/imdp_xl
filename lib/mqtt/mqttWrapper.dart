// import 'package:imdp_xl/mqtt/mqttAppState.dart';
import 'package:flutter/material.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/mqtt/mqttManager.dart';

class MqttWrapper with ChangeNotifier {
  late MQTTManager _manager;
  late MQTTAppState _state;

  void setState(MQTTAppState state) {
    _state = state;
  }

  void connect() {
    _manager = MQTTManager(
        // TODO: Gunakan broker external
        host: "10.0.2.2",
        // host: "test.mosquitto.org",
        // Subscribe semua topic:
        // Node temperatur -> quaildea/nodes/messages/temp/{nomor node}
        // Node petelur -> quaildea/nodes/messages/food/{nomor node}
        topic: "quaildea/nodes/messages/#",
        // TODO: Pakai UUID
        identifier: "Flutter_Test",
        state: _state);
    _manager.initializeMQTTClient();
    _manager.connect();
    // }
  }

  void configAndConnect(String _host, String _topic) {
    _manager = MQTTManager(
        host: _host,
        topic: _topic,
        // TODO: Pakai UUID
        identifier: "Flutter_Test",
        state: _state);
    _manager.initializeMQTTClient();
    _manager.connect();
    // }
  }

  void disconnect() {
    _manager.disconnect();
  }

  String get getMessage => _state.getReceivedText;

  MQTTAppState get getAppState => _state;
}
