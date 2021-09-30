import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/helper/databaseHelper.dart';
import 'package:imdp_xl/models/node.dart';
import 'package:imdp_xl/models/nodePakanModel.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  ListView _mainView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.amberAccent,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Text(
                  'Kandang Pembenihan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Icon(FontAwesomeIcons.temperatureHigh),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Suhu"),
                        ),
                        Container(
                          constraints: BoxConstraints(maxHeight: 64),
                          child: _listPembenihan(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Colors.greenAccent,
          child: Column(
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
                        // Container(
                        //   constraints: BoxConstraints(maxHeight: 48),
                        //   // height: 48,
                        //   child: _listPetelur(),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
              padding: EdgeInsets.symmetric(horizontal: 4),
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

  List<Widget> _buildColumnsPetelur(NodePakanModel node) {
    return List.generate(
        node.getNodes.length,
        (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text("Kandang ${node.getNodes[index].getId}"),
                  Text(
                    "${node.getNodes[index].getStatePakan}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ));
  }

  FutureBuilder<List<NodePakan>> _listPetelur() {
    return FutureBuilder<List<NodePakan>>(
      future: DatabaseHelper.instance.retrieveNodePakanList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Text("Kandang ${data[index].getId}"),
                    Text(
                      "${data[index].getStatePakan}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("Oops");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
