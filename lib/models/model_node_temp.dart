import 'package:imdp_xl/models/node.dart';

class NodeTempModel {
  final List<NodeTemp> _nodes = [
    NodeTemp(id: 1, jenis: "temp", suhu: 0, stateLampu: false),
    NodeTemp(id: 2, jenis: "temp", suhu: 0, stateLampu: false),
  ];

  void add(NodeTemp node) {
    _nodes.add(node);
  }

  /// Removes all items
  void removeAll() {
    _nodes.clear();
  }

  void modify(NodeTemp node) {
    int index = _nodes.indexWhere((e) => (e.getId == node.getId));
    if ((index != -1)) _nodes[index] = node;
  }

  List<NodeTemp> get getNodes => _nodes;
}
