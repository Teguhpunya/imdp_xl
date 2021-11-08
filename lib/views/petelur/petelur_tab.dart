import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/views/widgets/containers.dart';
import 'package:imdp_xl/views/widgets/texts.dart';

class PetelurView extends StatefulWidget {
  PetelurView({Key? key}) : super(key: key);

  @override
  _PetelurViewState createState() => _PetelurViewState();
}

class _PetelurViewState extends State<PetelurView> {
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: MyCard(color: Colors.grey[900], children: [
        Expanded(
          flex: 1,
          child: Text(
            'Petelur',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Expanded(
          flex: 8,
          child: StreamBuilder(
            stream: dbRef.child("pakan").onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                List _list = snapshot.data?.snapshot.value;

                return ListView.builder(
                  itemCount: _list.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  itemBuilder: (BuildContext context, int index) {
                    var pakan1 = _list[index]['pakan1'];
                    var pakan2 = _list[index]['pakan2'];
                    // double result = (pakan1 + pakan2) / 2;
                    return MyCard(
                      color: Colors.black,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                FontAwesomeIcons.hamburger,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyCard(
                                          color: Colors.white,
                                          children: [
                                            MyTextHeader(text: "Pakan 1"),
                                            Text((pakan1 == 1)
                                                ? 'Penuh'
                                                : 'Kosong'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: MyCard(
                                          color: Colors.white,
                                          children: [
                                            MyTextHeader(text: "Pakan 2"),
                                            Text((pakan2 == 1)
                                                ? 'Penuh'
                                                : 'Kosong'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: MyCard(
                                  //         color: Colors.white,
                                  //         children: [
                                  //           MyTextHeader(text: "Tempat pakan"),
                                  //           Text((result == 1)
                                  //               ? 'Penuh'
                                  //               : 'Kosong'),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ]),
    );
  }
}
