import 'dart:math';

import 'package:imdp_xl/models/node.dart';

class NodeTempModel {
  final List<NodeTemp> _nodes = List.generate(
      3,
      (index) => NodeTemp(
          id: index + 1,
          jenis: "temp",
          timestamp: DateTime.now().millisecondsSinceEpoch,
          suhu: 27 + Random().nextInt(31 - 27),
          stateLampu: Random().nextBool()));

  void add(NodeTemp node) {
    _nodes.add(node);
  }

  void sort() {
    _nodes.sort((a, b) => a.getId.compareTo(b.getId));
  }

  /// Removes all items
  void removeAll() {
    _nodes.clear();
  }

  void modify(NodeTemp node) {
    int index = _nodes.indexWhere((e) => (e.getId == node.getId));
    if ((index != -1))
      _nodes[index] = node;
    else {
      add(node);
      sort();
    }
  }

  List<NodeTemp> get getNodes => _nodes;
}
