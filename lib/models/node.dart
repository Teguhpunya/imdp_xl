abstract class Node {
  final int id;
  final String jenis;
  final int timestamp;

  Node(this.id, this.jenis, this.timestamp);

  int get getId => this.id;
  String get getJenis => this.jenis;
  int get getTimestamp => this.timestamp;
}

class NodeTemp extends Node {
  late int suhu;
  late bool stateLampu;

  NodeTemp(
      {required int id,
      required String jenis,
      required int timestamp,
      required this.suhu,
      required this.stateLampu})
      : super(id, jenis, timestamp);

  void setSuhu(int temp) {
    suhu = temp;
  }

  void setStateLampu(bool lamp) {
    stateLampu = lamp;
  }

  int get getSuhu => suhu;
  bool get getStateLampu => stateLampu;
}
