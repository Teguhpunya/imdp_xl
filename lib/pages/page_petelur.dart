import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/helper/databaseHelper.dart';
import 'package:imdp_xl/models/node.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

class PagePetelur extends StatefulWidget {
  const PagePetelur({Key? key}) : super(key: key);

  @override
  _PagePetelurState createState() => _PagePetelurState();
}

class _PagePetelurState extends State<PagePetelur> {
  // late MQTTAppState _state = Provider.of<MQTTAppState>(context);
  // late MQTTAppState _state;

  @override
  Widget build(BuildContext context) {
    // _state = Provider.of<MQTTAppState>(context);

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
            }),
          )
        ],
        child: Icon(FontAwesomeIcons.list),
      ),
      // body: ListView(
      //     padding: const EdgeInsets.all(8),
      //     children: _buildNodeList(_state.getNodePakanModel)),
      body: FutureBuilder<List<NodePakan>>(
        future: DatabaseHelper.instance.retrieveNodePakanList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(data[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Oops"),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Generate Card
  Widget _buildCard(NodePakan node) {
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(node.getTimestamp);
    String _timestamp = DateFormat('dd-MMM-yyyy H:mm').format(_dateTime);

    return Card(
      elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Kandang ${node.getId}"),
          ),
          Container(
            child: Text("Terakhir update: \n$_timestamp"),
          ),
          _pakanButton(node)
        ],
      ),
    );
  }

  // Pakan button
  Widget _pakanButton(NodePakan node) {
    int statePakan = node.getStatePakan;
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => Size.fromWidth(128))),
        //     backgroundColor: MaterialStateProperty.resolveWith((states) =>
        //         (!_statePakan) ? Colors.redAccent.shade700 : Colors.grey)),
        onPressed: (statePakan == 0)
            ? () {
                setState(() {
                  node.setStatePakan(1);
                  DatabaseHelper.instance.updatePakan(node);
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
              (statePakan == 0) ? Text("Kosong") : Text("Penuh"),
            ],
          ),
        ));
  }
}
