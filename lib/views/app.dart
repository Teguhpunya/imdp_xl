import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:imdp_xl/models/pembenih.dart';

class Quaildea extends StatefulWidget {
  const Quaildea({Key? key}) : super(key: key);

  @override
  _QuaildeaState createState() => _QuaildeaState();
}

class _QuaildeaState extends State<Quaildea>
    with SingleTickerProviderStateMixin {
  final dbRef = FirebaseDatabase.instance.reference();

  final DbHelper _dbHelper = new DbHelper();
  late TabController _tabController;
  late final List<Widget> _tabViews;
  final List<Widget> _tabs = [
    Icon(
      FontAwesomeIcons.earlybirds,
    ),
    Icon(
      FontAwesomeIcons.bookReader,
    ),
  ];

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabViews = [
      myAppList(),
      testList(),
    ];
  }

  Widget myAppList() {
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
                                myTextHeader("Suhu 1"),
                                SizedBox(height: 8),
                                Text("$suhu1° C"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: myCard(
                              Colors.white,
                              [
                                myTextHeader("Suhu 2"),
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
                                myTextHeader("Lampu"),
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

  Text myTextHeader(String text) {
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

  SliverAppBar myAppBar(BuildContext context) {
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
              height: 32,
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

  testList() {
    return FutureBuilder(
      future: _dbHelper.getDataPembenih(PembenihQuery.TABLE_NAME),
      builder: (BuildContext context, AsyncSnapshot<List<Pembenih>> snapshot) {
        var data = snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Center(
                  child: myCard(
                    Colors.white,
                    [
                      Text(
                        "${data![index].toJson()}",
                      ),
                    ],
                  ),
                );
              });
        } else {
          return myCard(Colors.white, [CircularProgressIndicator()]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: _tabs,
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, boolean) {
            return <Widget>[
              myAppBar(context),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: _tabViews,
          ),
        ),
      ),
    );
  }
}
