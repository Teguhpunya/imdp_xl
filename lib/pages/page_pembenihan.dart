import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PagePembenihan extends StatefulWidget {
  const PagePembenihan({Key? key}) : super(key: key);

  @override
  _PagePembenihanState createState() => _PagePembenihanState();
}

class _PagePembenihanState extends State<PagePembenihan> {
  final dbRef = FirebaseDatabase.instance.reference();

  Widget loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 18,
          ),
          Text("Loading data / sedang offline"),
        ],
      ),
    );
  }

  // Generate cards
  Widget _buildCard(DataSnapshot item) {
    DateTime _dateTime =
        DateTime.fromMillisecondsSinceEpoch(item.value['timestamp']);
    String _timestamp = DateFormat('dd-MMM-yyyy H:mm').format(_dateTime);
    return Card(
      elevation: 4,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text("Kandang ${item.key}"),
              Text(
                "${item.value['suhu1']}° C",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${item.value['suhu2']}° C",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 128),
          child: Text(
            "Terakhir update: \n$_timestamp",
            softWrap: true,
          ),
        ),
        _lampuButton(item),
      ]),
    );
  }

  // Lampu button
  Widget _lampuButton(DataSnapshot item) {
    int stateLampu = item.value['lampu'];
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => Size.fromWidth(128)),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                (stateLampu == 1) ? Colors.yellow.shade800 : Colors.indigo)),
        onPressed: () {
          // TODO: Publish control message lampu
          Future.delayed(Duration(seconds: 4));
          switchLampu(item, stateLampu);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon((stateLampu == 1)
                  ? FontAwesomeIcons.solidLightbulb
                  : FontAwesomeIcons.lightbulb),
              SizedBox(
                height: 16,
              ),
              Text("Lampu"),
              Text(
                (stateLampu == 1) ? "Menyala" : "Mati",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }

  void switchLampu(DataSnapshot item, int stateLampu) {
    setState(() {
      int switchLampu = 1 - stateLampu;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      dbRef
          .child('/suhu/${item.key}')
          .update({'lampu': switchLampu, 'timestamp': timestamp});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sukses. Lampu = $switchLampu'),
          duration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: SpeedDial(
        //   children: [
        //     SpeedDialChild(
        //       child: Icon(FontAwesomeIcons.fileExport),
        //       label: "Ekspor data",
        //       onTap: () => setState(() {
        //         // TODO: Export data
        //       }),
        //     ),
        //     SpeedDialChild(
        //       child: Icon(FontAwesomeIcons.fileExport),
        //       label: "Matikan otomasi",
        //       onTap: () => setState(() {
        //         // TODO: Publish matikan otomasi pembenih
        //         // _state.getNodeTempModel.removeAll();
        //       }),
        //     )
        //   ],
        //   child: Icon(FontAwesomeIcons.list),
        // ),
        body: FirebaseAnimatedList(
            query: dbRef.child('suhu'),
            defaultChild: loading(),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return SizeTransition(
                sizeFactor: animation,
                child: _buildCard(snapshot),
              );
            }));
  }
}
