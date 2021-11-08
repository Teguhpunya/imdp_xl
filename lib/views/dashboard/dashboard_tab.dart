import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/views/widgets/containers.dart';
import 'package:imdp_xl/views/widgets/texts.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: dbRef.child("suhu").onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            List _list = snapshot.data?.snapshot.value;

            return ListView.builder(
              itemCount: _list.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (BuildContext context, int index) {
                var suhu1 = _list[index]['suhu1'];
                var suhu2 = _list[index]['suhu2'];
                var stateLampu = _list[index]['stateLampu'];
                return MyCard(color: Colors.grey[900], children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        FontAwesomeIcons.thermometerEmpty,
                        color: Colors.white,
                      ),
                      MySizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: MyCard(
                              color: Colors.white,
                              children: [
                                MyTextHeader(text: "Suhu 1"),
                                SizedBox(height: 8),
                                Text("$suhu1° C"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: MyCard(
                              color: Colors.white,
                              children: [
                                MyTextHeader(text: "Suhu 2"),
                                SizedBox(height: 8),
                                Text("$suhu2° C"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      MySizedBox(),
                      Divider(
                        color: Colors.white30,
                        indent: MediaQuery.of(context).size.width / 4,
                        endIndent: MediaQuery.of(context).size.width / 4,
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      MySizedBox(),
                      Icon(
                        FontAwesomeIcons.lightbulb,
                        color: Colors.white,
                      ),
                      MySizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: MyCard(
                              color: Colors.white,
                              children: [
                                MyTextHeader(text: "Lampu"),
                                SizedBox(height: 8),
                                Text((stateLampu == 1) ? 'Menyala' : 'Mati'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
