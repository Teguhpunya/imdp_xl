import 'package:flutter/material.dart';
import 'package:imdp_xl/models/node_temp.dart';

class NodeTempModel extends ChangeNotifier {
  final List<NodeTemp> _nodes = [
    NodeTemp(kandang: 1, suhu: 36, stateLampu: true),
    NodeTemp(kandang: 2, suhu: 38, stateLampu: false)
  ];

  void add(NodeTemp node) {
    _nodes.add(node);
    // notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _nodes.clear();
    // notifyListeners();
  }

  List<NodeTemp> get getNodes => _nodes;
}
