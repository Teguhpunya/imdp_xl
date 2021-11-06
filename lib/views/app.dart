import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Quaildea extends StatefulWidget {
  const Quaildea({Key? key}) : super(key: key);

  @override
  _QuaildeaState createState() => _QuaildeaState();
}

class _QuaildeaState extends State<Quaildea> {
  final dbRef = FirebaseDatabase.instance.reference();

  Widget appList() {
    return StreamBuilder(
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
              return myCard(
                Colors.grey[900],
                [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        FontAwesomeIcons.thermometerEmpty,
                        color: Colors.white,
                      ),
                      mySizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: myCard(
                              Colors.white,
                              [
                                textHeader("Suhu 1"),
                                SizedBox(height: 8),
                                Text("$suhu1° C"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: myCard(
                              Colors.white,
                              [
                                textHeader("Suhu 2"),
                                SizedBox(height: 8),
                                Text("$suhu2° C"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      mySizedBox(),
                      Divider(
                        color: Colors.white30,
                        indent: MediaQuery.of(context).size.width / 4,
                        endIndent: MediaQuery.of(context).size.width / 4,
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      mySizedBox(),
                      Icon(
                        FontAwesomeIcons.lightbulb,
                        color: Colors.white,
                      ),
                      mySizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: myCard(
                              Colors.white,
                              [
                                textHeader("Lampu"),
                                SizedBox(height: 8),
                                Text((stateLampu == 1) ? 'Menyala' : 'Mati'),
                              ],
                            ),
                          ),
                        ],
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
    );
  }

  Text textHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  SizedBox mySizedBox() {
    return SizedBox(
      height: 16,
    );
  }

  Card myCard(Color? color, List<Widget> children) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  SliverAppBar appBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.grey[850],
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: MediaQuery.of(context).size.height / 3,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'Agne',
                color: Colors.white,
                fontSize: 28,
                letterSpacing: 2.5,
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'uaildea',
                    textAlign: TextAlign.center,
                    curve: Curves.easeOut,
                    speed: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: NestedScrollView(
        headerSliverBuilder: (context, boolean) {
          return <Widget>[
            appBar(context),
          ];
        },
        body: appList(),
      ),
    );
  }
}
