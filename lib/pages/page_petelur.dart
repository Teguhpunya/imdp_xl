import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/models/node.dart';
import 'package:imdp_xl/models/nodePakanModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:imdp_xl/appState.dart';

class PagePetelur extends StatefulWidget {
  const PagePetelur({Key? key}) : super(key: key);

  @override
  _PagePetelurState createState() => _PagePetelurState();
}

class _PagePetelurState extends State<PagePetelur> {
  // late MQTTAppState _state = Provider.of<MQTTAppState>(context);
  late MQTTAppState _state;

  @override
  Widget build(BuildContext context) {
    _state = Provider.of<MQTTAppState>(context);

    return Scaffold(
      floatingActionButton: SpeedDial(
        children: [
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.fileExport),
            label: "Ekspor data",
            onTap: () => setState(() {
              // TODO: Export data
            }),
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.fileExport),
            label: "Matikan otomasi",
            onTap: () => setState(() {
              // TODO: Publish matikan otomasi pembenih
              // _state.getNodeTempModel.removeAll();
            }),
          )
        ],
        child: Icon(FontAwesomeIcons.list),
      ),
      body: ListView(
          padding: const EdgeInsets.all(8),
          children: _buildNodeList(_state.getNodePakanModel)),
    );
  }

  // Generate list of nodes
  List<Widget> _buildNodeList(NodePakanModel nodes) {
    return List.generate(
        nodes.getNodes.length, (index) => _buildCard(nodes.getNodes[index]));
  }

  // Generate Card
  Widget _buildCard(NodePakan node) {
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(node.getTimestamp);
    String _timestamp = DateFormat('dd-MMM-yyyy H:mm').format(_dateTime);

    int id = node.getId;
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Kandang $id"),
          ),
          Container(
            child: Text("Terakhir update: \n$_timestamp"),
          ),
          pakanButton(node)
        ],
      ),
    );
  }

  // Pakan button
  Widget pakanButton(NodePakan node) {
    bool _statePakan = node.getStatePakan;
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => Size.fromWidth(128))),
        //     backgroundColor: MaterialStateProperty.resolveWith((states) =>
        //         (!_statePakan) ? Colors.redAccent.shade700 : Colors.grey)),
        onPressed: (!_statePakan)
            ? () {
                setState(() {
                  node.setStatePakan(!_statePakan);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Sukses.'),
                      duration: Duration(milliseconds: 500)),
                );
              }
            : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.fastfood_rounded),
              SizedBox(
                height: 16,
              ),
              // Text("Isi Pakan"),
              (_statePakan) ? Text("Penuh") : Text("Kosong"),
            ],
          ),
        ));
  }
}
