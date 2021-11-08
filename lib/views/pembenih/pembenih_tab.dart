import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/views/widgets/containers.dart';
import 'package:imdp_xl/views/widgets/texts.dart';

class PembenihView extends StatefulWidget {
  PembenihView({Key? key}) : super(key: key);

  @override
  _PembenihViewState createState() => _PembenihViewState();
}

class _PembenihViewState extends State<PembenihView> {
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: MyCard(color: Colors.grey[900], children: [
        Expanded(
          flex: 1,
          child: Text(
            'Pembenih',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Expanded(
          flex: 8,
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
                    return MyCard(
                      color: Colors.black,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                FontAwesomeIcons.thermometerEmpty,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyCard(
                                      color: Colors.white,
                                      children: [
                                        MyTextHeader(text: "Suhu 1"),
                                        Text(
                                          "$suhu1° C",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: MyCard(
                                      color: Colors.white,
                                      children: [
                                        MyTextHeader(text: "Suhu 2"),
                                        Text(
                                          "$suhu2° C",
                                        ),
                                      ],
                                    ),
                                  ),
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
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                FontAwesomeIcons.lightbulb,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: MyCard(
                                color: Colors.white,
                                children: [
                                  MyTextHeader(text: "Lampu"),
                                  Text((stateLampu == 1) ? 'Menyala' : 'Mati'),
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
