// To parse this JSON data, do
//
//     final pembenih = pembenihFromJson(jsonString);

import 'dart:convert';

Pembenih pembenihFromJson(String str) => Pembenih.fromJson(json.decode(str));

String pembenihToJson(Pembenih data) => json.encode(data.toJson());

class Pembenih {
  Pembenih({
    required this.stateLampu,
    required this.suhu1,
    required this.suhu2,
    required this.timestamp,
  });

  factory Pembenih.fromJson(Map<String, dynamic> json) => Pembenih(
        stateLampu: json["stateLampu"],
        suhu1: json["suhu1"],
        suhu2: json["suhu2"],
        timestamp: json["timestamp"],
      );

  final int stateLampu;
  final int suhu1;
  final int suhu2;
  final int timestamp;

  Map<String, dynamic> toJson() => {
        "stateLampu": stateLampu,
        "suhu1": suhu1,
        "suhu2": suhu2,
        "timestamp": timestamp,
      };
}
