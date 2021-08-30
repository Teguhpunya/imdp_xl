import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/mqtt/mqttWrapper.dart';
import 'package:imdp_xl/pages/page_overview.dart';
import 'package:imdp_xl/pages/page_pembenihan.dart';
import 'package:imdp_xl/pages/page_petelur.dart';
import 'package:imdp_xl/pages/page_settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MQTTAppState>(
        create: (_) => MQTTAppState(),
      ),
      ChangeNotifierProvider<MqttWrapper>(create: (_) => MqttWrapper()),
    ],
    child: const MaterialApp(
      home: const HomePage(),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      OverviewPage(),
      PagePembenihan(),
      PagePetelur(),
      SettingsPage(),
    ];
    final MQTTAppState _state = Provider.of<MQTTAppState>(context);
    final MqttWrapper _mqttWrapper = Provider.of<MqttWrapper>(context);
    _mqttWrapper.setState(_state);
    // _mqttWrapper.connect();

    return MaterialApp(
      home: DefaultTabController(
        length: pages.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quailabs'),
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
                Tab(
                  icon: Icon(FontAwesomeIcons.wrench),
                  text: 'Pengaturan',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
