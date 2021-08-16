// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/models/model_node_temp.dart';
import 'package:imdp_xl/models/node.dart';
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

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
        children: _buildNodeList(_state.getNodeTempModel),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => setState(() {
          _state.getNodeTempModel.removeAll();
        }),
        child: Text("Remove all"),
      ),
    );
  }

  // Generate list of nodes
  List<Widget> _buildNodeList(NodeTempModel nodes) {
    return List.generate(
        nodes.getNodes.length, (index) => _buildCard(nodes.getNodes[index]));
  }

  // Generate cards
  Widget _buildCard(NodeTemp node) {
    return Card(
      elevation: 4,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text("Kandang ${node.getId}"),
              Text(
                "${node.getSuhu}° C",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          child: Text("${node.getTimestamp}"),
        ),
        _lampuButton(node),
      ]),
    );
  }

  // Lampu button
  Widget _lampuButton(NodeTemp node) {
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => Size.fromWidth(128)),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                (node.getStateLampu) ? Colors.yellow.shade800 : Colors.indigo)),
        onPressed: () {
          // TODO: Publish control message lampu
          setState(() {
            node.setStateLampu(!node.getStateLampu);
          });
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
