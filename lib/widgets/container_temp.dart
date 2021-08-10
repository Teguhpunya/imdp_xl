import 'dart:math';

import 'package:flutter/material.dart';

class ContainerTemperature extends StatefulWidget {
  ContainerTemperature({Key? key}) : super(key: key);

  @override
  _ContainerTemperatureState createState() => _ContainerTemperatureState();
}

class _ContainerTemperatureState extends State<ContainerTemperature> {
  List<Widget> _buildCard(int count) {
    return List.generate(
        count,
        (index) => Card(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text("Kandang ${index + 1}"),
                  Text(
                    "${27 + Random().nextInt(31 - 27)} C",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: _buildCard(2),
      ),
    );
  }
}
