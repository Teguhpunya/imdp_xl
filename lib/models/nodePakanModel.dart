import 'dart:math';

import 'package:imdp_xl/models/node.dart';

class NodePakanModel {
  final List<NodePakan> _nodes = List.generate(
      3,
      (index) => NodePakan(
            id: index + 1,
            jenis: "temp",
            timestamp: DateTime.now().millisecondsSinceEpoch,
            statePakan: Random().nextBool(),
            statePakanCadangan: Random().nextInt(2),
          ));

  void add(NodePakan node) {
    _nodes.add(node);
  }

  void sort() {
    _nodes.sort((a, b) => a.getId.compareTo(b.getId));
  }

  /// Removes all items
  void removeAll() {
    _nodes.clear();
  }

  void modify(NodePakan node) {
    int index = _nodes.indexWhere((e) => (e.getId == node.getId));
    if ((index != -1))
      _nodes[index] = node;
    else {
      add(node);
      sort();
    }
  }

  List<NodePakan> get getNodes => _nodes;
}
