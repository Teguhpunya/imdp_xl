import 'package:flutter/material.dart';

class NodeTemp with ChangeNotifier {
  int kandang = 1;
  int suhu = 0;
  bool stateLampu = false;
  // String lampu = "Mati";

  NodeTemp(
      {required this.kandang, required this.suhu, required this.stateLampu});

  void setSuhu(int temp) {
    suhu = temp;
    notifyListeners();
  }

  void setStateLampu(bool lamp) {
    stateLampu = lamp;
    // lampu = (stateLampu) ? "Menyala" : "Mati";
    notifyListeners();
  }

  int get getKandang => kandang;
  int get getSuhu => suhu;
  bool get getStateLampu => stateLampu;
  // String get getLampu => lampu;
}
