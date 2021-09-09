import 'package:imdp_xl/models/node.dart';

class NodeSuhuModel {
  List<NodeSuhu> _nodes = [];

  void add(NodeSuhu node) {
    _nodes.add(node);
  }

  void sort() {
    _nodes.sort((a, b) => a.getId.compareTo(b.getId));
  }

  /// Removes all items
  void removeAll() {
    _nodes.clear();
  }

  void modify(NodeSuhu node) {
    int index = _nodes.indexWhere((e) => (e.getId == node.getId));
    if ((index != -1))
      _nodes[index] = node;
    else {
      add(node);
      sort();
    }
  }

  List<NodeSuhu> get getNodes => _nodes;
}
