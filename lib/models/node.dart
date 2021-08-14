abstract class Node {
  final int id;
  final String jenis;

  Node(this.id, this.jenis);

  int get getId => this.id;
  String get getJenis => this.jenis;
}

class NodeTemp extends Node {
  late int suhu;
  late bool stateLampu;

  NodeTemp(
      {required int id,
      required String jenis,
      required this.suhu,
      required this.stateLampu})
      : super(id, jenis);

  void setSuhu(int temp) {
    suhu = temp;
  }

  void setStateLampu(bool lamp) {
    stateLampu = lamp;
  }

  int get getSuhu => suhu;
  bool get getStateLampu => stateLampu;
}
