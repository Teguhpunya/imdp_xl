import 'package:flutter/material.dart';
import 'package:imdp_xl/helper/databaseHelper.dart';
import 'package:provider/provider.dart';
import 'package:imdp_xl/appState.dart';
import 'package:imdp_xl/mqtt/mqttWrapper.dart';
import 'package:imdp_xl/widgets/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends MultiProvider {
  MyApp()
      : super(
          providers: [
            ChangeNotifierProvider<MQTTAppState>(
              create: (_) => MQTTAppState(),
            ),
            ChangeNotifierProvider<MqttWrapper>(create: (_) => MqttWrapper()),
          ],
          child: MaterialApp(
            title: 'Quaildea',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const HomeScreen(),
          ),
        );
}
