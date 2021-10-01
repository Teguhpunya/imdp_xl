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
  TabController? _tabController;

  static List<Widget> pages = [
    OverviewPage(),
    PagePembenihan(),
    PagePetelur(),
    // SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: pages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return quaildeaApp(context);
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
          tabIconColor: Colors.blue[600],
          tabIconSize: 28.0,
          tabIconSelectedSize: 26.0,
          tabSelectedColor: Colors.blue[900],
          tabIconSelectedColor: Colors.white,
          tabBarColor: Colors.white,
          onTabItemSelected: (int value) {
            setState(() {
              _tabController!.index = value;
            });
          },
        ),
        // BottomAppBar(
        //   child: const TabBar(
        //     indicatorWeight: 6,
        //     labelColor: Colors.black,
        //     tabs: [
        //       Tab(
        //         icon: Icon(FontAwesomeIcons.houseUser),
        //         text: 'Overview',
        //       ),
        //       Tab(
        //         icon: Icon(FontAwesomeIcons.earlybirds),
        //         text: 'Pembenihan',
        //       ),
        //       Tab(
        //         icon: Icon(FontAwesomeIcons.egg),
        //         text: 'Petelur',
        //       ),
        //       // Tab(
        //       //   icon: Icon(FontAwesomeIcons.wrench),
        //       //   text: 'Pengaturan',
        //       // ),
        //     ],
        //   ),
        // ),
        body: TabBarView(
          physics:
              NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          controller: _tabController,
          children: pages,
        ),
      ),
    );
  }
}
