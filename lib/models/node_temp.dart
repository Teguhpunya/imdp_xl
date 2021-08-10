import 'package:flutter/material.dart';

class NodeTemp with ChangeNotifier {
  int kandang = 1;
  double suhu = 0.0;
  bool stateLampu = false;
  // String lampu = "Mati";

  NodeTemp(
      {required this.kandang, required this.suhu, required this.stateLampu});

  void setSuhu(double temp) {
    suhu = temp;
    notifyListeners();
  }

  void setStateLampu(bool lamp) {
    stateLampu = lamp;
    // lampu = (stateLampu) ? "Menyala" : "Mati";
    notifyListeners();
  }

  int get getKandang => kandang;
  double get getSuhu => suhu;
  bool get getStateLampu => stateLampu;
  // String get getLampu => lampu;
}
