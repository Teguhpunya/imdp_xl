import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:imdp_xl/helper/databaseHelper.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/models/node.dart';
import 'package:provider/provider.dart';

class PagePembenihan extends StatefulWidget {
  const PagePembenihan({Key? key}) : super(key: key);

  @override
  _PagePembenihanState createState() => _PagePembenihanState();
}

class _PagePembenihanState extends State<PagePembenihan> {
  @override
  Widget build(BuildContext context) {
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
      // body: ListView(
      //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
      //   children: _buildNodeList(_state.getNodeTempModel),
      // ),
      body: FutureBuilder<List<NodeSuhu>>(
        future: DatabaseHelper.instance.retrieveNodeSuhuList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(snapshot.data[index]);
                // ListTile(
                //   title: Text(snapshot.data[index].title),
                //   leading: Text(snapshot.data[index].id.toString()),
                //   subtitle: Text(snapshot.data[index].content),
                //   onTap: () => _navigateToDetail(context, snapshot.data[index]),
                //   trailing: IconButton(
                //       alignment: Alignment.center,
                //       icon: Icon(Icons.delete),
                //       onPressed: () async {
                //         _deleteTodo(snapshot.data[index]);
                //         setState(() {});
                //       }),
                // );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Oops!");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Generate cards
  Widget _buildCard(NodeSuhu node) {
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(node.getTimestamp);
    String _timestamp = DateFormat('dd-MMM-yyyy H:mm').format(_dateTime);
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
          width: 128,
          child: Text(
            "Terakhir update: \n$_timestamp",
            softWrap: true,
          ),
        ),
        _lampuButton(node),
      ]),
    );
  }

  // Lampu button
  Widget _lampuButton(NodeSuhu node) {
    int stateLampu = node.getStateLampu;
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => Size.fromWidth(128)),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                (stateLampu == StateLampu.nyala.index)
                    ? Colors.yellow.shade800
                    : Colors.indigo)),
        onPressed: () {
          // TODO: Publish control message lampu
          switchLampu(node, stateLampu);
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
              Icon((stateLampu == StateLampu.nyala.index)
                  ? FontAwesomeIcons.solidLightbulb
                  : FontAwesomeIcons.lightbulb),
              SizedBox(
                height: 16,
              ),
              Text("Lampu"),
              Text(
                (stateLampu == StateLampu.nyala.index) ? "Menyala" : "Mati",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }

  void switchLampu(NodeSuhu node, int stateLampu) {
    setState(() {
      node.setStateLampu(1 - stateLampu);
      DatabaseHelper.instance.updateSuhu(node);
    });
  }
}
