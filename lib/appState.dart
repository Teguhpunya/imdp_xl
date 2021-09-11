import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imdp_xl/helper/databaseHelper.dart';
import 'package:imdp_xl/models/nodePakanModel.dart';
import 'package:imdp_xl/models/nodeSuhuModel.dart';
import 'package:imdp_xl/models/node.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  // NodeSuhuModel _tempModel = NodeSuhuModel();
  NodePakanModel _pakanModel = NodePakanModel();

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    if (_receivedText != '') {
      Map<String, dynamic> msg = jsonDecode(_receivedText);
      bool verified = false;

      List _requiredKeysCommon = ["id", "jenis", "timestamp"];
      List _requiredKeysPembenih = ["suhu", "stateLampu"];
      List _requiredKeysPetelur = ["statePakan"];

      for (var key in _requiredKeysCommon) {
        if (!msg.containsKey(key)) {
          print("teguhpunya:: Common key missing!");
          break;
        }

        // Node untuk pembenihan
        if (msg["jenis"].toString().toLowerCase() == "temp") {
          for (var key in _requiredKeysPembenih) {
            verified = msg.containsKey(key);
            if (!verified) {
              print("teguhpunya:: Key missing!");
              break;
            }
          }
          if (verified) {
            NodeSuhu node = NodeSuhu(
                id: msg["id"],
                jenis: msg["jenis"],
                timestamp: msg["timestamp"],
                suhu: msg["suhu"],
                stateLampu: msg["stateLampu"]);
            // _tempModel.modify(node);
            DatabaseHelper.instance.updateSuhu(node);
          }
        }

        // Node untuk petelur
        if (msg["jenis"].toString().toLowerCase() == "pakan") {
          for (var key in _requiredKeysPetelur) {
            verified = msg.containsKey(key);
            if (!verified) {
              print("teguhpunya:: Key missing!");
              break;
            }
          }
          if (verified) {
            NodePakan node = NodePakan(
                id: msg["id"],
                jenis: msg["jenis"],
                timestamp: msg["timestamp"],
                statePakan: msg["statePakan"],
                statePakanCadangan: msg["statePakanCadangan"]);
            _pakanModel.modify(node);
          }
        }
      }
    }

    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  // NodeSuhuModel get getNodeTempModel => _tempModel;
  NodePakanModel get getNodePakanModel => _pakanModel;
}
