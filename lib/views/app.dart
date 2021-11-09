import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/views/pembenih/pembenih_tab.dart';
import 'package:imdp_xl/views/history/history_tab.dart';
import 'package:imdp_xl/views/petelur/petelur_tab.dart';
import 'package:imdp_xl/views/widgets/appbar.dart';
import 'package:imdp_xl/views/widgets/updater.dart';

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
        title: 'Pembenih'),
    TabItem(
        icon: Icon(
          FontAwesomeIcons.egg,
          // color: Colors.white,
        ),
        title: 'Petelur'),
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
      PembenihView(),
      PetelurView(),
      HistoryView(),
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

  @override
  Widget build(BuildContext context) {
    return UpdaterView(
      child: Scaffold(
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
                MyAppBar(context: context),
              ];
            },
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: _tabViews,
            ),
          ),
        ),
      ),
    );
  }
}
