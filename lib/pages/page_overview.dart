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

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _mainView());
  }

  ListView _mainView() {
    return ListView(
      // padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
      children: <Widget>[
        mainContainer(
          Colors.amberAccent,
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Text(
                  'Kandang Pembenihan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Icon(FontAwesomeIcons.temperatureHigh),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Suhu"),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 64),
                child: _listPembenihan(),
              ),
            ],
          ),
        ),
        mainContainer(
          Colors.greenAccent,
          Column(
            children: [
              Text(
                'Kandang Petelur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.fastfood_rounded),
                        SizedBox(
                          height: 16,
                        ),
                        Text("Status tempat pakan"),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          constraints: BoxConstraints(maxHeight: 64),
                          child: _listPetelur(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Container mainContainer(Color? color, Widget? child) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      color: color,
      child: child,
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
        });
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
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text("Kandang ${snapshot.key}"),
                Text(
                  statusPakan(snapshot.value['pakan']),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  statusPakanCadang(snapshot.value['pakanCadang']),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        });
  }

  String statusPakan(pakan) {
    switch (pakan) {
      case 1:
        return 'Penuh';
      default:
        return 'Kosong';
    }
  }

  String statusPakanCadang(pakan) {
    switch (pakan) {
      case 1:
        return 'Sedang';
      case 2:
        return 'Penuh';
      default:
        return 'Kosong';
    }
  }
}
