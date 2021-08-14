// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/models/model_node_temp.dart';
import 'package:imdp_xl/models/node_temp.dart';
import 'package:provider/provider.dart';

class PagePembenihan extends StatefulWidget {
  const PagePembenihan({Key? key}) : super(key: key);

  @override
  _PagePembenihanState createState() => _PagePembenihanState();
}

class _PagePembenihanState extends State<PagePembenihan> {
  late MQTTAppState _state;

  @override
  Widget build(BuildContext context) {
    _state = Provider.of<MQTTAppState>(context);

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Column(children: _buildWidget(_state.getNodeTempModel)),
      ],
    );
  }

  // Generate widget for cards
  List<Widget> _buildWidget(NodeTempModel nodes) {
    return List.generate(
        nodes.getNodes.length,
        (index) => buildCard(
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text("Kandang ${nodes.getNodes[index].getKandang}"),
                      Text(
                        "${nodes.getNodes[index].getSuhu}° C",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                lampuButton(nodes.getNodes[index]),
              ]),
            ));
  }

  // Generate cards
  Widget buildCard(Widget child) {
    return Card(
      elevation: 4,
      child: child,
    );
  }

  // Lampu button
  Widget lampuButton(NodeTemp node) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                (node.getStateLampu) ? Colors.yellow.shade800 : Colors.indigo)),
        onPressed: () {
          node.setStateLampu(!node.getStateLampu);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sukses.'),
              duration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon((node.getStateLampu)
                  ? FontAwesomeIcons.solidLightbulb
                  : FontAwesomeIcons.lightbulb),
              SizedBox(
                height: 16,
              ),
              Text("Lampu"),
              Text(
                (node.getStateLampu) ? "Menyala" : "Mati",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }
}
