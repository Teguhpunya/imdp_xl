import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/views/dashboard/dashboard_tab.dart';
import 'package:imdp_xl/views/history/history_tab.dart';
// import 'package:imdp_xl/views/visualize/visualize_tab.dart';

class Quaildea extends StatefulWidget {
  const Quaildea({Key? key}) : super(key: key);

  @override
  _QuaildeaState createState() => _QuaildeaState();
}

class _QuaildeaState extends State<Quaildea>
    with SingleTickerProviderStateMixin {
  late final List<Widget> _tabViews;

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
      DashboardView(),
      HistoryView(),
      // VisualizeTab(),
    ];

    _tabController = TabController(length: _tabs.length, vsync: this);
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
