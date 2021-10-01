import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/pages/page_overview.dart';
import 'package:imdp_xl/pages/page_pembenihan.dart';
import 'package:imdp_xl/pages/page_petelur.dart';

import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static List<Widget> pages = [
    OverviewPage(),
    PagePembenihan(),
    PagePetelur(),
    // SettingsPage(),
  ];

  TabController? _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: pages.length,
      vsync: this,
    );
  }

  Widget quaildeaApp(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quailabs'),
          centerTitle: true,
        ),
        bottomNavigationBar: MotionTabBar(
          initialSelectedTab: "Overview",
          labels: ['Overview', 'Pembenihan', 'Petelur'],
          icons: [
            FontAwesomeIcons.bookReader,
            FontAwesomeIcons.earlybirds,
            FontAwesomeIcons.egg
          ],
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          tabIconColor: Colors.blue[600],
          tabSelectedColor: Colors.blue[900],
          tabIconSelectedColor: Colors.white,
          tabBarColor: Colors.white,
          onTabItemSelected: (int value) {
            setState(() {
              _tabController!.index = value;
            });
          },
        ),
        body: TabBarView(
          physics:
              NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          controller: _tabController,
          children: pages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return quaildeaApp(context);
  }
}
