import 'dart:ui';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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

  Widget _tileCard(DataSnapshot item) {
    String? kandang = item.key;
    double suhu = (item.value['suhu1'] + item.value['suhu2']) / 2;
    DateTime _dateTime =
        DateTime.fromMillisecondsSinceEpoch(item.value['timestamp']);
    String _timestamp = DateFormat('dd-MMM-yyyy H:mm').format(_dateTime);

    return Column(
      children: [
        ExpansionTileCard(
          animateTrailing: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Kandang $kandang"),
              Icon(
                FontAwesomeIcons.clock,
                size: 18,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Suhu: $suhu° C",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "$_timestamp",
                softWrap: true,
              ),
            ],
          ),
          expandedColor: Colors.lightBlue[50],
          children: [
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            _tileCardEx(item)
          ],
        ),
      ],
    );
  }

  Widget _tileCardEx(DataSnapshot item) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          // color: Colors.green,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              children: [
                Text('Suhu 1'),
                Text(
                  "${item.value['suhu1']}° C",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text('Suhu 2'),
                Text(
                  "${item.value['suhu2']}° C",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
                constraints: BoxConstraints(minWidth: 128),
                child: _lampuButton(item))
          ]),
        ));
  }

  // Lampu button
  Widget _lampuButton(DataSnapshot item) {
    int stateLampu = item.value['lampu'];

    return ElevatedButton(
        style: ButtonStyle(
            // fixedSize: MaterialStateProperty.resolveWith(
            //     (states) => Size.fromWidth(64)),
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
            padding: EdgeInsets.only(bottom: 32),
            query: dbRef.child('suhu'),
            defaultChild: loading(),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return SizeTransition(
                sizeFactor: animation,
                child: _tileCard(snapshot),
              );
            }));
  }
}
