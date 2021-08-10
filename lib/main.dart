import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/pages/page_overview.dart';
import 'package:imdp_xl/pages/page_pembenihan.dart';
import 'package:imdp_xl/pages/page_petelur.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorWeight: 6,
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
              ],
            ),
            title: const Text('Qualidea'),
          ),
          body: const TabBarView(
            children: [OverviewPage(), PagePembenihan(), PagePetelur()],
          ),
        ),
      ),
    );
  }
}
