import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

class PagePetelur extends StatefulWidget {
  const PagePetelur({Key? key}) : super(key: key);

  @override
  _PagePetelurState createState() => _PagePetelurState();
}

class _PagePetelurState extends State<PagePetelur> {
  final dbRef = FirebaseDatabase.instance.reference();

  Widget _mainView() {
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
      //       }),
      //     )
      //   ],
      //   child: Icon(FontAwesomeIcons.list),
      // ),
      body: FirebaseAnimatedList(
          query: dbRef.child('pakan'),
          defaultChild: loading(),
          itemBuilder: (context, snapshot, animation, index) {
            return SizeTransition(
                sizeFactor: animation, child: _buildCard(snapshot));
          }),
    );
  }

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

  // Generate Card
  Widget _buildCard(DataSnapshot item) {
    DateTime _dateTime =
        DateTime.fromMillisecondsSinceEpoch(item.value['timestamp']);
    String _timestamp = DateFormat('dd-MMM-yyyy H:mm').format(_dateTime);

    return Card(
      elevation: 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Kandang ${item.key}"),
              ),
              Container(
                child: Text("Terakhir update: \n$_timestamp"),
              ),
              Column(
                children: [
                  _pakanButton(item),
                ],
              )
            ],
          ),
          Row(
            children: [
              cekCPakan(item, "cpakan1"),
              cekCPakan(item, "cpakan2"),
            ],
          ),
        ],
      ),
    );
  }

  Widget cekCPakan(DataSnapshot item, String jenisCPakan) {
    switch (item.value[jenisCPakan]) {
      case 1:
        return Expanded(
          child: Container(
              color: Colors.yellow,
              child: Center(child: Text('$jenisCPakan: Sedang'))),
        );
      case 2:
        return Expanded(child: Center(child: Text('$jenisCPakan: Penuh')));
      default:
        return Expanded(
          child: Container(
            color: Colors.red[200],
            child: Center(child: Text('$jenisCPakan: Kosong')),
          ),
        );
    }
  }

  // Pakan button
  Widget _pakanButton(DataSnapshot item) {
    int statePakan = min(item.value['pakan1'], item.value['pakan2']);
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => Size.fromWidth(128))),
        onPressed: (statePakan == 0)
            ? () {
                setState(() {
                  statePakan = 1;
                  dbRef
                      .child('/pakan/${item.key}')
                      .update({'pakan': statePakan});
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Sukses. Pakan: $statePakan'),
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
              (statePakan == 0) ? Text("Kosong") : Text("Tersedia"),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _mainView(),
    );
  }
}
