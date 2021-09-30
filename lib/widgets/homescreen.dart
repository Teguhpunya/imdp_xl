import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/pages/page_overview.dart';
import 'package:imdp_xl/pages/page_pembenihan.dart';
import 'package:imdp_xl/pages/page_petelur.dart';
import 'package:imdp_xl/pages/page_settings.dart';

import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return quaildeaApp(context);
  }

  Widget quaildeaApp(BuildContext context) {
    const List<Widget> pages = [
      OverviewPage(),
      PagePembenihan(),
      PagePetelur(),
      // SettingsPage(),
    ];

    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quailabs'),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          child: const TabBar(
            indicatorWeight: 6,
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.houseUser),
                text: 'Overview',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.earlybirds),
                text: 'Pembenihan',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.egg),
                text: 'Petelur',
              ),
              // Tab(
              //   icon: Icon(FontAwesomeIcons.wrench),
              //   text: 'Pengaturan',
              // ),
            ],
          ),
        ),
        body: const TabBarView(
          children: pages,
        ),
      ),
    );
  }
}
