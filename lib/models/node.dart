abstract class Node {
  final String tablename;
  final int _id;
  final String _jenis;
  final int _timestamp;

  Node(this.tablename, this._id, this._jenis, this._timestamp);

  int get getId => this._id;
  String get getJenis => this._jenis;
  int get getTimestamp => this._timestamp;
}

class NodeSuhu extends Node {
  final int suhu;
  int stateLampu;

  NodeSuhu(
      {required int id,
      required String jenis,
      required int timestamp,
      required this.suhu,
      required this.stateLampu})
      : super("nodesuhu", id, jenis, timestamp);

  // TODO: Hapus ini dan ubah jadi final setelah implementasi publish
  void setStateLampu(int lamp) {
    stateLampu = lamp;
  }

  int get getSuhu => suhu;
  int get getStateLampu => stateLampu;

  Map<String, Object?> toMap() {
    return {
      'id': _id,
      'jenis': _jenis,
      'timestamp': _timestamp,
      'suhu': suhu,
      'stateLampu': stateLampu
    };
  }
}

class NodePakan extends Node {
  int statePakan;
  int statePakanCadangan;

  NodePakan(
      {required int id,
      required String jenis,
      required int timestamp,
      required this.statePakan,
      required this.statePakanCadangan})
      : super("nodepakan", id, jenis, timestamp);

  void setStatePakan(int state) {
    statePakan = state;
  }

  void setStatePakanCadangan(int state) {
    statePakanCadangan = state;
  }

  int get getStatePakan => statePakan;

  Map<String, Object?> toMap() {
    return {
      'id': _id,
      'jenis': _jenis,
      'timestamp': _timestamp,
      'statePakan': statePakan,
      'statePakanCadangan': statePakanCadangan
    };
  }
}
