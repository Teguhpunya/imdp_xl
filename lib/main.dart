import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:imdp_xl/models/pembenih.dart';
import 'package:imdp_xl/views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  final dbRef = FirebaseDatabase.instance.reference();
  final DbHelper dbHelper = new DbHelper();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 10), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();

    // read data from firebase
    var data, dataStr, dataJson;
    var suhu1, suhu2;
    Pembenih pembenih;

    dbRef.child('suhu').once().then((value) async {
      data = await value.value[0];
      dataStr = json.encode(data);
      dataJson = json.decode(dataStr);
      pembenih = pembenihFromJson(dataStr);
      suhu1 = dataJson['suhu1'];
      suhu2 = dataJson['suhu2'];

      service.setNotificationInfo(
        title: "Quaildea",
        content: "Suhu 1: $suhu1° C\n Suhu 2: $suhu2° C",
      );

      dbHelper.insert(PembenihQuery.TABLE_NAME, pembenih.toJson());
    });

    // service.sendData(
    //   {"current_date": DateTime.now().toIso8601String()},
    // );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterBackgroundService.initialize(onStart);

    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Splash(),
            );
          } else {
            // Loading is done, return the app:,
            return MaterialApp(
              title: 'Quaildea',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Quaildea(),
            );
          }
        });
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
        backgroundColor: lightMode
            ? Color(0xffffff).withOpacity(1.0)
            : Color(0x042a49).withOpacity(1.0),
        body: Center(
            child: Image.asset(
          'assets/images/splash-logo.png',
        )));
  }
}
