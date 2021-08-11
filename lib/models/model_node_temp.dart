import 'package:imdp_xl/models/node_temp.dart';

class NodeTempModel {
  final List<NodeTemp> _nodes = [
    NodeTemp(kandang: 1, suhu: 0, stateLampu: false),
    NodeTemp(kandang: 2, suhu: 0, stateLampu: false)
  ];

  void add(NodeTemp node) {
    _nodes.add(node);
  }

  /// Removes all items from the cart.
  void removeAll() {
    _nodes.clear();
  }

  void modify(NodeTemp node, int index) {
    _nodes[index - 1] = node;
  }

  List<NodeTemp> get getNodes => _nodes;
}
