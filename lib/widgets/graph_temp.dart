import 'dart:math';

import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';

class GraphTemp extends StatefulWidget {
  GraphTemp({Key? key}) : super(key: key);

  @override
  _GraphTempState createState() => _GraphTempState();
}

class _GraphTempState extends State<GraphTemp> {
  List<Feature> features = [
    Feature(
      title: "Kandang 1",
      color: Colors.blue,
      data: [0.3, 0.6, 0.8, 0.9, 1, Random().nextDouble()],
    ),
    Feature(
      title: "Kandang 2",
      color: Colors.black,
      data: [1, 0.8, 0.6, 0.7, 0.3, Random().nextDouble()],
    ),
    Feature(
      title: "Kandang 3",
      color: Colors.orange,
      data: [0.4, 0.2, 0.9, 0.5, 0.6, Random().nextDouble()],
    ),
    Feature(
      title: "Kandang 4",
      color: Colors.red,
      data: [0.5, 0.2, 0, 0.3, 1, Random().nextDouble()],
    ),
    Feature(
      title: "Kandang 5",
      color: Colors.green,
      data: [0.25, 0.6, 1, 0.5, 0.8, Random().nextDouble()],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Suhu Kandang",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // letterSpacing: 2,
            ),
          ),
        ),
        LineGraph(
          features: features,
          size: Size(420, 320),
          labelX: ['06:00', '07:00', '08:00', '09:00', '10:00', '11:00'],
          labelY: ['27 C', '28 C', '29 C', '30 C', '31 C'],
          showDescription: true,
          graphColor: Colors.black87,
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
