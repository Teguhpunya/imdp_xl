import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final dbRef = FirebaseDatabase.instance.reference();

  _mainView() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 64),
      children: <Widget>[
        mainContainer(
          Column(
            children: [
              Icon(FontAwesomeIcons.earlybirds),
              SizedBox(
                height: 16,
              ),
              Text(
                'Kandang Pembenihan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 96),
                color: Color.fromARGB(50, 99, 99, 99),
                child: _listPembenihan(),
              ),
            ],
          ),
        ),
        mainContainer(
          Column(
            children: [
              Icon(FontAwesomeIcons.egg),
              SizedBox(
                height: 16,
              ),
              Text(
                'Kandang Petelur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(maxHeight: 96),
                color: Color.fromARGB(50, 99, 99, 99),
                child: _listPetelur(),
              ),
            ],
          ),
        ),
        mainContainer(Container(
          height: 128,
          child: Center(
            child: Text(
              'Coming Soon',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        )),
      ],
    );
  }

  Widget mainContainer(Widget? child) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      color: Color.fromRGBO(133, 219, 242, 1),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: child,
      ),
    );
  }

  Widget _listPembenihan() {
    return FirebaseAnimatedList(
        scrollDirection: Axis.horizontal,
        defaultChild: loading(),
        query: dbRef.child('suhu'),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return SizeTransition(
            sizeFactor: animation,
            child: _cardItemPembenihan(snapshot),
          );
        });
  }

  Widget _cardItemPembenihan(DataSnapshot snapshot) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kandang ${snapshot.key}"),
            Text(
              "${snapshot.value['suhu1']}° C",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "${snapshot.value['suhu2']}° C",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text((snapshot.value['lampu'] == 0) ? "Mati" : "Nyala")
          ],
        ),
      ),
    );
  }

  Widget _cardItemPetelur(DataSnapshot snapshot) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kandang ${snapshot.key}"),
            Text(
              "Pakan ${statusPakan(min(snapshot.value['pakan1'], snapshot.value['pakan2']))}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Cadangan 1 ${statusPakanCadang(snapshot.value['cpakan1'])}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Cadangan 2 ${statusPakanCadang(snapshot.value['cpakan2'])}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Column loading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Loading data / sedang offline"),
      ],
    );
  }

  Widget _listPetelur() {
    return FirebaseAnimatedList(
        query: dbRef.child('pakan'),
        scrollDirection: Axis.horizontal,
        defaultChild: loading(),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return _cardItemPetelur(snapshot);
        });
  }

  String statusPakan(int pakan) {
    switch (pakan) {
      case 1:
        return 'Terisi';
      default:
        return 'Kosong';
    }
  }

  String statusPakanCadang(int pakan) {
    switch (pakan) {
      case 1:
        return 'Sedang';
      case 2:
        return 'Penuh';
      default:
        return 'Kosong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(2, 122, 147, 1), body: _mainView());
  }
}
