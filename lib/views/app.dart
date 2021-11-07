import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:imdp_xl/models/pembenih.dart';
// import 'package:imdp_xl/views/visualize/visualize_tab.dart';

class Quaildea extends StatefulWidget {
  const Quaildea({Key? key}) : super(key: key);

  @override
  _QuaildeaState createState() => _QuaildeaState();
}

class _QuaildeaState extends State<Quaildea>
    with SingleTickerProviderStateMixin {
  final dbRef = FirebaseDatabase.instance.reference();

  late final List<Widget> _tabViews;

  final DbHelper _dbHelper = new DbHelper();
  late TabController _tabController;
  final List<TabItem> _tabs = [
    TabItem(
        icon: Icon(
          FontAwesomeIcons.earlybirds,
          // color: Colors.white,
        ),
        title: 'Dashboard'),
    TabItem(
        icon: Icon(
          FontAwesomeIcons.bookReader,
          // color: Colors.white,
        ),
        title: 'History'),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabViews = [
      myDashboard(),
      myHistory(),
      // VisualizeTab(),
    ];

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Widget myDashboard() {
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

  Widget myListOnCard(Color? color, child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: color,
        child: Padding(padding: const EdgeInsets.all(16.0), child: child),
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

  Stream<List<Pembenih>> _fetchData() async* {
    // This loop will run forever
    while (true) {
      // Fetch data from database
      yield await _dbHelper.getDataPembenih(PembenihQuery.TABLE_NAME);
      // Update every 10 seconds
      await Future<void>.delayed(Duration(seconds: 1));
    }
  }

  Widget myHistory() {
    return Container(
      // margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: myCard(Colors.grey[900], [
        Expanded(
          flex: 1,
          child: Text(
            'History',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Expanded(
          flex: 8,
          child: StreamBuilder(
            stream: _fetchData().asBroadcastStream(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Pembenih>> snapshot) {
              var data = snapshot.data;
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: data!.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Center(
                      child: myCard(
                        Colors.black,
                        [
                          myCard(
                            Colors.white,
                            [
                              myTextHeader("Waktu"),
                              Text(
                                "${DateTime.fromMillisecondsSinceEpoch(data[index].timestamp).toLocal()}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: myCard(
                                  Colors.white,
                                  [
                                    myTextHeader("Suhu 1"),
                                    Text(
                                      "${data[index].suhu1}",
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: myCard(
                                  Colors.white,
                                  [
                                    myTextHeader("Suhu 2"),
                                    Text(
                                      "${data[index].suhu2}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          myCard(
                            Colors.white,
                            [
                              myTextHeader("Lampu"),
                              Text((data[index].stateLampu == 1)
                                  ? 'Menyala'
                                  : 'Mati'),
                            ],
                          ),
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: ConvexAppBar(
        items: _tabs,
        controller: _tabController,
        backgroundColor: Colors.black,
        activeColor: Colors.white,
        height: 48,
        top: -16,
        style: TabStyle.titled,
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, boolean) {
            return <Widget>[
              myAppBar(context),
            ];
          },
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: _tabViews,
          ),
        ),
      ),
    );
  }
}
