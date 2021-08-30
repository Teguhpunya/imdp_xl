abstract class Node {
  final int _id;
  final String _jenis;
  final int _timestamp;

  Node(this._id, this._jenis, this._timestamp);

  int get getId => this._id;
  String get getJenis => this._jenis;
  int get getTimestamp => this._timestamp;
}

class NodeTemp extends Node {
  final int suhu;
  bool stateLampu;

  NodeTemp(
      {required int id,
      required String jenis,
      required int timestamp,
      required this.suhu,
      required this.stateLampu})
      : super(id, jenis, timestamp);

  // TODO: Hapus ini dan ubah jadi final setelah implementasi publish
  void setStateLampu(bool lamp) {
    stateLampu = lamp;
  }

  int get getSuhu => suhu;
  bool get getStateLampu => stateLampu;
}

class NodePakan extends Node {
  bool statePakan;
  int statePakanCadangan;

  NodePakan(
      {required int id,
      required String jenis,
      required int timestamp,
      required this.statePakan,
      required this.statePakanCadangan})
      : super(id, jenis, timestamp);

  void setStatePakan(bool state) {
    statePakan = state;
  }

  void setStatePakanCadangan(int state) {
    statePakanCadangan = state;
  }

  bool get getStatePakan => statePakan;
}
