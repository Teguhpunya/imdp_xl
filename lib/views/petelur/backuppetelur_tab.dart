import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PagePetelur extends StatefulWidget {
  const PagePetelur({Key? key}) : super(key: key);

  @override
  _PagePetelurState createState() => _PagePetelurState();
}

class _PagePetelurState extends State<PagePetelur> {
  final dbRef = FirebaseDatabase.instance.reference();

  Widget _mainView() {
    return FirebaseAnimatedList(
        padding: EdgeInsets.only(bottom: 32, top: 4),
        query: dbRef.child('pakan'),
        defaultChild: loading(),
        itemBuilder: (
          context,
          snapshot,
          animation,
          index,
        ) {
          return Card(
            child: SizeTransition(
              sizeFactor: animation,
              child: _tileCard(snapshot),
            ),
          );
        });
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

  Widget _tileCard(DataSnapshot item) {
    String? kandang = item.key;
    int pakan = min(item.value['pakan1'], item.value['pakan2']);
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
                "Pakan: ${_cekPakan(pakan)}",
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
    int pakan = min(item.value['pakan1'], item.value['pakan2']);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        // color: Colors.green,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Text('Pakan utama'),
                      Text(
                        _cekPakan(pakan),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      Text('Pakan cadangan'),
                      Row(
                        children: [
                          Text(
                            "${_cekCPakan(item, 'cpakan1')}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${_cekCPakan(item, 'cpakan2')}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  constraints: BoxConstraints(minWidth: 128),
                  child: _pakanButton(item))
            ],
          ),
        ],
      ),
    );
  }

  String _cekPakan(pakan) {
    return (pakan == 1) ? "Penuh" : "Kosong";
  }

  String _cekCPakan(DataSnapshot item, String jenisCPakan) {
    switch (item.value[jenisCPakan]) {
      case 1:
        return 'Sedang';
      case 2:
        return 'Penuh';
      default:
        return 'Kosong';
    }
  }

  // Pakan button
  Widget _pakanButton(DataSnapshot item) {
    int statePakan = min(item.value['pakan1'], item.value['pakan2']);
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    return ElevatedButton(
      onPressed: (statePakan == 0)
          ? () {
              setState(() {
                statePakan = 1;
                dbRef
                    .child('/pakan/${item.key}')
                    .update({'pakan1': statePakan});
                dbRef
                    .child('/pakan/${item.key}')
                    .update({'pakan2': statePakan});
                dbRef
                    .child('/pakan/${item.key}')
                    .update({'timestamp': timestamp});
              });
              showOkAlertDialog(
                context: context,
                title: 'Sukses!',
                // message: '\"clampu\": $switchLampu'
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
            Center(
                child: (statePakan == 0)
                    ? Text("Beri pakan!")
                    : Text("Masih ada")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(2, 122, 147, 1),
      body: _mainView(),
    );
  }
}
