import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imdp_xl/models/model_node_temp.dart';
import 'package:imdp_xl/models/node.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  NodeTempModel _nodeTempModel = NodeTempModel();

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    if (_receivedText != '') {
      Map<String, dynamic> msg = jsonDecode(_receivedText);
      bool verified = false;

      // Node untuk pembenihan
      List requiredKeys = ["id", "jenis", "timestamp", "suhu", "stateLampu"];
      for (var key in requiredKeys) {
        verified = msg.containsKey(key);
        if (!verified) {
          print("teguhpunya:: Key missing!");
          break;
        }
      }
      if (verified) {
        NodeTemp node = NodeTemp(
            id: msg["id"],
            jenis: msg["jenis"],
            timestamp: msg["timestamp"],
            suhu: msg["suhu"],
            stateLampu: msg["stateLampu"]);
        _nodeTempModel.modify(node);
      }
    }

    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    // notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  NodeTempModel get getNodeTempModel => _nodeTempModel;
}
