import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/views/overview/overview_tab.dart';
import 'package:imdp_xl/views/pembenihan/pembenihan_tab.dart';
import 'package:imdp_xl/views/petelur/petelur_tab.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static List<Widget> tabViews = [
    PagePembenihan(),
    OverviewTab(),
    PagePetelur(),
    // PageDev(),
  ];

  TabController? _tabController;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 1,
      length: tabViews.length,
      vsync: this,
    );
  }

  Widget quaildeaApp(BuildContext context) {
    return DefaultTabController(
      length: tabViews.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(107, 107, 107, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 30,
              ),
              Text('uailabs'),
            ],
          ),
          // centerTitle: true,
        ),
        bottomNavigationBar: MotionTabBar(
          initialSelectedTab: 'Overview',
          labels: [
            'Pembenihan',
            'Overview',
            'Petelur',
            // 'Dev'
          ],
          icons: [
            FontAwesomeIcons.earlybirds,
            FontAwesomeIcons.bookReader,
            FontAwesomeIcons.egg,
            // FontAwesomeIcons.wrench,
          ],
          textStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          tabIconColor: Colors.white,
          tabSelectedColor: Color.fromRGBO(215, 189, 148, 1),
          tabIconSelectedColor: Color.fromRGBO(25, 25, 25, 1),
          tabBarColor: Color.fromRGBO(107, 107, 107, 1),
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
          children: tabViews,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return quaildeaApp(context);
  }
}
